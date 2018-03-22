//
//  BTRootViewController.m
//  NBProject
//
//  Created by JayZhang on 2017/10/31.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRootViewController.h"
#import "NBSliderView.h"

#import "NBRECViewController.h"
#import "NBBannerView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UserEntity.h"
#import "NBShareView.h"


@interface NBRootViewController ()<NBSliderViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)UITableView * mainTableView;
@property(nonatomic,weak)UILabel * fffff;
@property(nonatomic,strong)NSArray * arMusics;
@end

@implementation NBRootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title =@"嘿嘿";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"点击" style:UIBarButtonItemStylePlain target:self action:@selector(dosomething:)];

    NBBannerView * banner = [[NBBannerView alloc]init];
    banner.stopInterval = 3.f;
    banner.frame = CGRectMake(0, 0, NB_SCREEN_WIDTH, sHeight(200));
    NSArray * arImages = @[@"banner_01.jpeg",@"banner_02.jpeg",@"banner_03.jpeg",@"banner_04.jpeg"];
    banner.arImages = arImages;
    
    self.mainTableView.tableHeaderView = banner;
    
}
-(NSArray *)arMusics{
    if (!_arMusics) {
        _arMusics = @[@"1000",@"1001",@"1002",@"1003",@"1004",@"1005",@"1006",@"1007",@"1008",@"1009",@"1010",@"1011",@"1012",@"1013",@"1014",@"1015",@"1016",@"1020",@"1021",@"1022",@"1023",@"1024",@"1025",@"1026",@"1027",@"1028",@"1029",@"1030",@"1031",@"1032",@"1033",@"1034",@"1035",@"1036",@"1050",@"1051",@"1052",@"1053",@"1054",@"1055",@"1056",@"1057",@"1070",@"1071",@"1072",@"1073",@"1074",@"1075",@"1100",@"1101",@"1102",@"1103",@"1104",@"1105",@"1106",@"1107",@"1108",@"1109",@"1110",@"1111",@"1112",@"1113",@"1114",@"1115",@"1116",@"1117",@"1118",@"1150",@"1151",@"1152",@"1153",@"1154",@"1200",@"1201",@"1202",@"1203",@"1204",@"1205",@"1206",@"1207",@"1208",@"1209",@"1210",@"1211",@"1254",@"1255",@"1256",@"1257",@"1258",@"1259",@"1300",@"1301",@"1302",@"1303",@"1304",@"1305",@"1306",@"1307",@"1308",@"1309",@"1310",@"1311",@"1312",@"1313",@"1314",@"1315",@"1316",@"1317",@"1318",@"1319",@"1320",@"1321",@"1322",@"1323",@"1323",@"1325",@"1326",@"1327",@"1328",@"1329",@"1330",@"1331",@"1332",@"1333",@"1334",@"1335",@"1336",@"1350",@"1351",@"4950"];
    }
    return _arMusics;
}

-(void)dosomething:(UIBarButtonItem *)sender{
    //这里是关键，点击按钮后先取消之前的操作，再进行需要进行的操作
    NSString * sUrl = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/%%E5%%BE%%AE%%E5%%AE%%9D%%E6%%8E%%8C%%E6%%9F%%9C/id1318610467?mt=8&uo=4"];
    

    UIImage * image = [NBQRCodeTool generateWithLogoQRCodeData:sUrl imageWidth:500 logoImageName:@"VBlogo.png"];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);//把图片保存在本地

//    NSURL * url = [NSURL URLWithString:sUrl];
//    if ([[UIApplication sharedApplication]canOpenURL:url]) {
//
//        [[UIApplication sharedApplication]openURL:url];
//    }
    
//
//    [self.mainTableView.nb_header endRefreshing];
//
//    [NBHudProgress showInView:self.view];
    
    
//    NBShareView * sv = [[NBShareView alloc]initWithTitle:@"分享" content:@"分享内容" image:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=467987889,420985202&fm=173&s=719E789550D9B7C650BC9D030300C071&w=635&h=403&img.JPEG" webUrl:@"www.baidu.com"];
//    [sv show];
    
//    NBBadgeButton * button = [[NBBadgeButton alloc] initWithFrame:CGRectMake(100, 100, 60, 30)];
//    [button setTitle:@"测试" forState:UIControlStateNormal];
//    [button updateBadge:@"5"];
//    [self.view addSubview:button];

    
//    NBCodeButton * button = [[NBCodeButton alloc] initToGetCustomButton];
//    [button startWithInterral:10];
//    [self.view addSubview:button];
    
    
//    [NBTool openSetting];
//    [[NBAudio shareInstance] playVoice];
//    [self.navigationController showViewController:[NBRECViewController new] sender:nil];
}
//图片保存至相册的结果回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo: (void *) contextInfo{
    
    if (error) {
        [NBTool showMessage:@"保存相册失败"];
        
    }else{
        [NBTool showMessage:@"保存相册成功"];
    }
}
        
-(void)textHudView{
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.mainTableView.nb_header endRefreshing];
//            [self.mainTableView.nb_footer endRefreshingWithNoMoreData];
//
        });
        
    });
    
}




-(void)testSliderView{
    NSArray * arTitle = @[@"全部",@"待付款",@"待收货",@"已完成",@"售后"];
    NBSliderView * sliderView = [[NBSliderView alloc]initWithFrame:CGRectMake(0, 64, NB_SCREEN_WIDTH, 45.f)];
    sliderView.arTitle = arTitle;
    sliderView.nbsv_delegate = self;
    sliderView.isAverage = YES;
    sliderView.showLine = YES;
    sliderView.showBar= YES;

    
    
    [self.view addSubview:sliderView];
}

-(void)sliderView:(NBSliderView *)sliderView didClickedButton:(UIButton *)sender atIndex:(NSInteger)index{
    
    NSLog(@"滚动到第%ld个",index);
    
}



-(UITableView *)mainTableView{
    
    if (!_mainTableView) {
        WEAKSELF
        CGRect rect = self.view.bounds;
        rect.size.height = NB_SCREEN_HEIGHT- NB_NAVI_HEIGHT - NB_TABBAR_HEIGHT-200;
        rect.origin.y = 200;
        _mainTableView =[[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _mainTableView.nb_header = [NBNormalHeader headerWithRefreshingBlock:^{
            
            NSLog(@"header block start");
            
        }];
        
//        NBRefreshNormalHeader * header = [NBRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf textHudView];
//        }];
//        _mainTableView.nb_header = header;
//        header.lastUpdatedTimeLabel.hidden = YES;
//
//
//        
//        NBRefreshAutoNormalFooter * footer = [NBRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf textHudView];
//
//        }];
//
//        [footer setTitle:@"~~~~~~~~~~我是有底线的~~~~~~~~~~" forState:NBRefreshStateNoMoreData];
//        [footer setTitle:@"拼命加载中..." forState:NBRefreshStateRefreshing];
//
//        _mainTableView.nb_footer = footer;
        [self.view addSubview:_mainTableView];
        [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:_mainTableView];
        
    }
    
    return _mainTableView;
}
#pragma mark ------------------------------------ tableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arMusics.count;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.arMusics objectAtIndex:indexPath.row];
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SystemSoundID soundID = (unsigned int)[[self.arMusics objectAtIndex:indexPath.row] integerValue];
    
    
    
    //    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    
//    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, NULL, NULL);
    
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
    
    
}




@end
