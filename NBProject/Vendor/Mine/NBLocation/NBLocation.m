//
//  NBLocation.m
//  NBProject
//
//  Created by 张杰 on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "NBLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface NBLocation()<CLLocationManagerDelegate>


@end
@implementation NBLocation{
    CLLocationManager *locationManager;

}

+ (instancetype)sharedManager{
    
    static NBLocation * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[NBLocation alloc] initInstance];
        }
    });
    return manager;
}
/**
 *  初始化一个父类对象
 *
 *  @return 一个本类对象
 */
-(instancetype)initInstance{
    
    self = [super init];
    if (self) {

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
-(void)startToLoaction{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        locationManager = [[CLLocationManager alloc]init];
        //多少米，去更新一次位置信息
        locationManager.distanceFilter = 50;
        //设置定位的精准度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //3、 挂上代理  并实现代理方法
        locationManager.delegate = self;
        
        
        CLAuthorizationStatus status =[CLLocationManager authorizationStatus];
        
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
                [locationManager requestWhenInUseAuthorization];
                [locationManager startUpdatingLocation];
                break;
            case kCLAuthorizationStatusDenied:
                NSLog(@"用户拒绝了定位授权");
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                [locationManager startUpdatingLocation];
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                [locationManager startUpdatingLocation];
                break;
            default:
                break;
        }
        
        


    }else{
        
        NSLog(@"定位功能不可用");
        
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    if (locations.count>0) {
        CLLocation * location = locations.lastObject;
        
        // 获取当前所在的城市名
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
        
        [manager stopUpdatingLocation];
        //根据经纬度反向地理编译出地址信息
    
//        @property (nonatomic, readonly, copy, nullable) NSString *name; // 新宸国际益州大道中段555号
//        @property (nonatomic, readonly, copy, nullable) NSString *thoroughfare; //益州大道中段599号
//        @property (nonatomic, readonly, copy, nullable) NSString *subThoroughfare; // eg. 1
//        @property (nonatomic, readonly, copy, nullable) NSString *locality; //成都市
//        @property (nonatomic, readonly, copy, nullable) NSString *subLocality; // 武侯区
//        @property (nonatomic, readonly, copy, nullable) NSString *administrativeArea; // 四川省
//        @property (nonatomic, readonly, copy, nullable) NSString *subAdministrativeArea; // county, eg. Santa Clara
//        @property (nonatomic, readonly, copy, nullable) NSString *postalCode; // zip code, eg. 95014
//        @property (nonatomic, readonly, copy, nullable) NSString *ISOcountryCode; // eg.CN US
//        @property (nonatomic, readonly, copy, nullable) NSString *country; // eg. 中国

        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
         
         {
             if (array.count > 0)
                 
             {
                 CLPlacemark *placemark = [array objectAtIndex:0];
                 NSLog(@"%@",placemark.name);
                 //获取城市
                 NSString *city = placemark.locality;
                 if (!city) {
                     //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                     city = placemark.administrativeArea;
                 }
                 NSLog(@"%@",city);
             }
             else if (error == nil && [array count] == 0)
             {
                 NSLog(@"No results were returned.");
             }
             
             else if (error != nil)
             {
                 NSLog(@"An error occurred = %@", error);
             }
             
         }];
        

    }
    
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if (error) {
        [[[NBAlertView alloc]init] show:error.domain];
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    switch (status) {
        case kCLAuthorizationStatusDenied:
            NSLog(@"用户拒绝了定位授权");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户还未做出选择是否能够定位");
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"用户同意一直使用位置");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"用户同意了使用时获取定位");
            break;
        default:
            break;
    }
}
@end
