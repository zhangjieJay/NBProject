//
//  NBSQLManager.m
//  NBProject
//
//  Created by Jay on 17/8/10.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBSQLManager.h"
#import <sqlite3.h>



@interface NBSQLManager(){
    
    void * _sql_db;
}

@property(nonatomic,copy)NSString * path;
@property(nonatomic,assign)NSInteger nColumn;//当前出表格的列数

@end

@implementation NBSQLManager

+ (instancetype)sharedManager{
    
    static NBSQLManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[NBSQLManager alloc] initInstance];
        }
    });
    return manager;
}

-(NSString *)path{
    
    if (!_path) {
        //获取沙箱地址
        NSArray *documentArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [documentArr firstObject];
        // nb_data.db 为数据库的名字
        _path = [NSString stringWithFormat:@"%@/nb_data.db",documentPath];
        NSLog(@"%@",_path);
    }
    return _path;
}


/**
 *  初始化一个父类对象
 *
 *  @return 一个本类对象
 */
-(instancetype)initInstance{
    
    self = [super init];
    if (self) {
        _sql_db = nil;
    }
    return self;
}


/**
 *  对于init方法进行处理抛出异常
 *
 */
- (instancetype)init
{
    @throw @"初始化对象失败,请采用类方法defaultObserver初始化单例对象.";
    
    return nil;
}


/*打开数据库*/
-(BOOL)open{
    
    if (_sql_db) {//
        return YES;
    }
    const char * cPath = self.path.UTF8String;
    int result = sqlite3_open(cPath, (sqlite3**)&_sql_db);
    [self checkResulr:result type:NBDBExcuteType_pen];
    if(result != SQLITE_OK) {
        return NO;
    }
    return YES;
}

/*关闭数据库*/
-(BOOL)close{

    if (!_sql_db) {
        NSLog(@"关闭数据库成功");
        return YES;
    }
    int  rc;
    BOOL retry;
    BOOL triedFinalizingOpenStatements = NO;
    do {
        retry   = NO;
        rc      = sqlite3_close(_sql_db);
        if (SQLITE_BUSY == rc || SQLITE_LOCKED == rc) {
            if (!triedFinalizingOpenStatements) {
                triedFinalizingOpenStatements = YES;
                sqlite3_stmt *pStmt;
                while ((pStmt = sqlite3_next_stmt(_sql_db, nil)) !=0) {
                    NSLog(@"Closing leaked statement");
                    sqlite3_finalize(pStmt);
                    retry = YES;
                }
            }
        }
        else if (SQLITE_OK != rc) {
            NSLog(@"关闭数据库失败");
        }
    }
    while (retry);
    _sql_db = nil;
    NSLog(@"关闭数据库成功");
    return YES;
}
#pragma mark -------------------------------------------------------- 创建表
/**
 *  举例  "create table if not exists tablename(id integer primary key autoincrement,name char,sex char)";
 *  tablename 为表名
 *  integer,char,text为数据类型
 *  autoNo,name,sex 为表列结构字段值
 */


/**
 *  创建表
 *  @name 表明
 *  @column 查询的列值  (不过目前是全部返回)
 *  @condition 查询条件
 *  return 查询结果(查询结果为字典集合的数组)
 */
-(void)createTable:(NSString *)name columnParams:(NSString *)sParam{
    
    NSString * sql_line = [NSString stringWithFormat:@"create table if not exists %@(%@)",name,sParam];
    const char *createSQL = [sql_line UTF8String];
    char * error;
    int result = sqlite3_exec(_sql_db, createSQL, NULL, NULL, &error);
    [self checkResulr:result type:NBDBExcuteType_create];
}

#pragma mark -------------------------------------------------------- 增加语句
/**
 *  举例  "insert into tablename (name,sex) values('stepper','male')"  (注意values内部字符串结构单双引号)
 *  tablename 为表名
 *  name,sex 为表列结构值
 *  stepper,male 为插入对应值  即name = stepper, sex = male;
 */

/**
 *  根据表名获取表结构值
 *  @name 表名
 *  @column 增加的列值
 *  @sValue 增加的值
 */
-(void)insertIntoTable:(NSString *)name cloumn:(NSString *)colomn values:(NSString *)sValue{
    
    //sql语句格式: insert into 表名 (列名)values(值)
    sqlite3_stmt *stmt = NULL;
    NSString * sql_line = [NSString stringWithFormat:@"insert into %@ (%@) values(%@)",name,colomn,sValue];
    const char * update_sql = [sql_line UTF8String];
    int insertResult = sqlite3_prepare_v2(_sql_db, update_sql, -1, &stmt, nil);
    
    BOOL  suc = [self checkResulr:insertResult type:NBDBExcuteType_add];
    
    if (suc) {
        // 执行sql语句
        sqlite3_step(stmt);
    }
    //关闭句柄
    sqlite3_finalize(stmt);
    
}


#pragma mark -------------------------------------------------------- 删除语句
/**
 *  举例  "delete from tablename where name = 'runner'"  (注意内部字符串结构单双引号)
 *  tablename 为表名
 *  name ='runner' 为查询条件
 */

/**
 *  根据条件进行删除
 *  @name 表名
 *  @column 查询的列值  (不过目前是全部返回)
 *  @condition 查询条件
 *  return 查询结果(查询结果为字典集合的数组,无则返回空)
 */
-(void)deleteFromTable:(NSString *)name condition:(NSString *)condition{
    
    //删除条件,如果为空则删除全部表格数据
    NSString * sql_line = [NSString stringWithFormat:@"delete from %@ where %@",name,condition];
    if ([NBTool isEmpty:condition]) {
        sql_line = [NSString stringWithFormat:@"delete from %@",name];
    }
    //sql语句格式: delete from 表名(name) where 条件(condition)
    sqlite3_stmt *stmt = NULL;
    const char * update_sql = [sql_line UTF8String];
    int insertResult = sqlite3_prepare_v2(_sql_db, update_sql, -1, &stmt, nil);
    
    BOOL  suc = [self checkResulr:insertResult type:NBDBExcuteType_delete];
    
    if (suc) {
        // 执行sql语句
        sqlite3_step(stmt);
    }
    //关闭句柄
    sqlite3_finalize(stmt);
    
}



#pragma mark -------------------------------------------------------- 修改语句
/**
 *  举例  //"update tablename set name = 'newrunner' where name = 'runner'";  (注意values内部字符串结构单双引号)
 *  tablename 为表名
 *  name = 'newrunner'  新值
 *  name = 'runner' 更新条件
 */

/**
 *  根据表名获取表结构值
 *  @name 表名
 *  @value 新值
 *  @condition 更新条件
 */
-(void)updateTable:(NSString *)name value:(NSString *)value condition:(NSString *)condition{
    
    //sql语句格式: update 表名(name) set 新值(value) 条件(condition)
    sqlite3_stmt *stmt = NULL;
    NSString * sql_line = [NSString stringWithFormat:@"update %@ set %@ where %@",name,value,condition];
    const char * update_sql = [sql_line UTF8String];
    int insertResult = sqlite3_prepare_v2(_sql_db, update_sql, -1, &stmt, nil);
    
    BOOL  suc = [self checkResulr:insertResult type:NBDBExcuteType_revise];
    
    if (suc) {
        // 执行sql语句
        sqlite3_step(stmt);
    }
    //关闭句柄
    sqlite3_finalize(stmt);
    
}





#pragma mark -------------------------------------------------------- 查询语句
/**
 *  举例  "select autoNo,name,sex from tablename where name = 'stepper'" (注意condition内部字符串结构单双引号)
 *  tablename 为表名
 *  autoNo,name,sex 为查询想要获取那些字段的值
 *  name ='stepper' 为查询条件
 */

/**
 *  查询相关数据
 *  @name 表明
 *  @column 查询的列值  (不过目前是全部返回)
 *  @condition 查询条件
 *  return 查询结果(查询结果为字典集合的数组,无则返回空)
 */
-(NSArray *)queryInTable:(NSString *)name column:(NSString *)colomn condition:(NSString *)condition{
    
    NSArray * arKeys =  [self getTableInfo:name];
    
    NSString * allColumn = [arKeys componentsJoinedByString:@","];
    // 查找
    //sql语句格式: select 列名 from 表名 where 列名 ＝ 参数
    //注：前面的列名为查询结果里所需要看到的 列名,后面的 列名 ＝ 参数 用于判断删除哪条数据
    
    NSString * sql_line = [NSString stringWithFormat:@"select %@ from %@ where %@",allColumn,name,condition];
    sqlite3_stmt *stmt = NULL;
    const char *searchSQL = [sql_line UTF8String];
    int result = sqlite3_prepare_v2(_sql_db, searchSQL, -1, &stmt, nil);
    BOOL  suc = [self checkResulr:result type:NBDBExcuteType_query];
    NSMutableArray * array;
    if (suc) {
        array = [NSMutableArray array];
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // 查询的结果可能不止一条,直到 sqlite3_step(stmt) != SQLITE_ROW,查询结束。
            NSString * sData = @"";
            NSMutableDictionary * dic =[NSMutableDictionary dictionary];
            for (int i = 0; i<self.nColumn; i++) {
                if (i == 0) {
                    int autoNo = sqlite3_column_int(stmt, 0);
                    sData = [NSString stringWithFormat:@"%d",autoNo];
                }else{
                    char * text = (char *) sqlite3_column_text(stmt, i);
                    sData = [NSString stringWithFormat:@"%s",text];
                }
                NSString * key = [arKeys objectAtIndex:i];
                [dic setValue:sData forKey:key];
            }
            [array addObject:dic];//一条数据
        }
    }
    
    sqlite3_finalize(stmt);//关闭句柄
    if (array.count>0) {
        return array;
    }else{
        return nil;
    }
}

#pragma mark -------------------------------------------------------- 获取表结构
/**
 *  根据表名获取表结构值(构造返回的字典keys)
 *  @name 表明
 *  return 结构数组
 */
-(NSArray *)getTableInfo:(NSString *)name{
    
    const char * getColumn = [[NSString stringWithFormat:@"PRAGMA table_info(%@)",name] UTF8String];
    
    sqlite3_stmt *stmt = NULL;
    
    int result = sqlite3_prepare_v2(_sql_db, getColumn, -1, &stmt, nil);
    
    BOOL  suc = [self checkResulr:result type:NBDBExcuteType_query];
    NSMutableArray * arKeys = [NSMutableArray array];
    if (suc) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char * nameData = (char *)sqlite3_column_text(stmt, 1);
            NSString *columnName = [[NSString alloc] initWithUTF8String:nameData];
            [arKeys addObject:columnName.mutableCopy];
        }
    }
    sqlite3_finalize(stmt);
    if(arKeys.count>0){
        self.nColumn = arKeys.count;
        return arKeys;
    }else{
        self.nColumn = 0;
        return nil;
    }
}

#pragma mark -------------------------------------------------------- 判断sql是否执行成功

/**
 *  判断sql执行结果
 *  @result 结果值
 *  @type 执行对应的功能
 *  return 该语句是否执行成功
 */
-(BOOL)checkResulr:(int)result type:(NBDBExcuteType)type{
    
    NSString * message = @"";
    switch (type) {
        case NBDBExcuteType_create:
            message = @"创建表";
            break;
        case NBDBExcuteType_pen:
            message = @"打开数据库";
            break;
        case NBDBExcuteType_close:
            message = @"关闭数据库";
            break;
        case NBDBExcuteType_add:
            message = @"增加数据";
            break;
        case NBDBExcuteType_delete:
            message = @"删除数据";
            break;
        case NBDBExcuteType_revise:
            message = @"修改数据";
            break;
        case NBDBExcuteType_query:
            message = @"查询数据";
            break;
            
        default:
            break;
    }
    if (result == SQLITE_OK) {
        NSLog(@"%@成功",message);
        return YES;
    }else{
        NSLog(@"%@失败",message);
        return NO;
    }
}








@end
