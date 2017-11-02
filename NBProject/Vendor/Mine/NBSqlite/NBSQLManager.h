//
//  NBSQLManager.h
//  NBProject
//
//  Created by 峥刘 on 17/8/10.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBSQLManager : NSObject

+ (instancetype)sharedManager;

/*打开数据库*/
-(BOOL)open;
/*关闭数据库*/
-(BOOL)close;
/*创建表*/
-(void)createTable:(NSString *)name columnParams:(NSString *)sParam;
/*增加*/
-(void)insertIntoTable:(NSString *)name cloumn:(NSString *)sParam values:(NSString *)sValue;
/*删除*/
-(void)deleteFromTable:(NSString *)name condition:(NSString *)condition;
/*修改*/
-(void)updateTable:(NSString *)name value:(NSString *)value condition:(NSString *)condition;
/*查询*/
-(NSArray *)queryInTable:(NSString *)name column:(NSString *)colomn condition:(NSString *)condition;
@end
