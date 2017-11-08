//
//  NBImagePickerViewController.m
//  NBProject
//
//  Created by scuser on 2017/11/7.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBImagePickerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface NBImagePickerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation NBImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCamera];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupCamera{

    //如果相机可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]) {
            // 支持视频录制
            WEAKSELF;
            self.videoQuality = UIImagePickerControllerQualityType640x480;
            self.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.mediaTypes = @[(NSString *)kUTTypeMovie];
            self.delegate = weakSelf;

            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                [self setCameraDevice:UIImagePickerControllerCameraDeviceFront];
            }
        }
    }

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
