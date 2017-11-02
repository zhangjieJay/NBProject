//
//  QRCodeViewController.m
//  LivingMuseumMF
//
//  Created by 峥刘 on 17/5/8.
//  Copyright © 2017年 刘峥. All rights reserved.
//

#import "QRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>


#define length 240 * NB_SCALE_6
static NSString *notice = @"将二维码置于取景框内系统会自动扫描";
static NSString *notice1 = @"建议与镜头保持100CM距离，尽量避免逆光和阴影";



@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>


// 当前设备
@property (nonatomic, strong)AVCaptureDevice *device;

// 输入流
@property (nonatomic, strong)AVCaptureDeviceInput *input;

// 输出流
@property (nonatomic, strong)AVCaptureMetadataOutput *output;

// 会话对象
@property (nonatomic, strong)AVCaptureSession *session;
// 图层类
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;

// 动画图片
@property (nonatomic, strong)UIImageView *lineImageView;



@end

@implementation QRCodeViewController

// 1、获取摄像设备
- (AVCaptureDevice *)device {
    if (!_device) {
        
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

// 2、创建输入流
- (AVCaptureDeviceInput *)input {
    if (!_input) {
        NSError *error = nil;
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    return _input;
}
// 3、创建输出流
- (AVCaptureMetadataOutput *)output {
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
    }
    return _output;
    
}


- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        // 高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = CGRectMake(0, 0, NB_SCREEN_WIDTH, NB_SCREEN_HEIGHT);
    }
    return _previewLayer;
}


- (UIImageView *)lineImageView {
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NB_scan_line"]];
        _lineImageView.bounds = CGRectMake(0, 0, length, 10);
    }
    return _lineImageView;
}

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self initNavigationView];
    
    [self getAuthorityToCamera];

}


-(void)getAuthorityToCamera{

    // 1、 获取摄像设备
    if (self.device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{

                if (granted) {
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限");
                    [self initUserInterface];

                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];//
                    NBAlertView * alertView = [NBAlertView new];
                    [alertView showError:@"拒绝访问相机!"];
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限");
                }
                });

            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            dispatch_async(dispatch_get_main_queue(), ^{
                
            [self initUserInterface];
                
            });
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 相机] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
            });

            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{

        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            [self dismissViewControllerAnimated:YES completion:nil];

        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
        });
    }

}



#pragma mark -- 初始化导航栏
-(void)initNavigationView{
    
    self.view.backgroundColor = [NBTool getColorNumber:200];
    self.title = @"扫描二维码";
    self.navigationController.navigationBar.barTintColor = [NBTool getColorNumber:410];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"wz_back_white.png"] style:UIBarButtonItemStylePlain target:self action:@selector(funGoBack)];
    self.navigationItem.leftBarButtonItem.tintColor = [NBTool getColorNumber:200];//白色
    self.navigationController.navigationBar.translucent =YES;
}


#pragma mark -- 返回
-(void)funGoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    // 1、如果扫描完成，停止会话
    [self.session stopRunning];
    
    self.navigationController.navigationBar.translucent = NO;
}



-(void)initUserInterface{


    [self drawLayer];//绘制边框及填充区域
    
    [self initControls];//主要初始化label

    [self setupNBQRCodeScanning];//启动扫描

}


- (void)initControls{
    
    CGRect actualRect = CGRectMake((NB_SCREEN_WIDTH - length) / 2.0, (NB_SCREEN_HEIGHT - length) / 2.0, length, length);
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *noticeLabel = [UILabel new];
    CGSize size = [NBTool autoString:notice font:[NBTool getFont:14.f] width:NB_SCREEN_WIDTH - 40];
    noticeLabel.text = notice;
    noticeLabel.numberOfLines = 0;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.textColor = [NBTool getColorNumber:0];
    noticeLabel.font = [NBTool getFont:14.f];
    noticeLabel.frame = CGRectMake((NB_SCREEN_WIDTH - size.width)/2.f, actualRect.origin.y - 20.f - size.height, size.width, size.height);
    [self.view addSubview:noticeLabel];

    
    
    
    UILabel *noticeLabel1 = [UILabel new];
    
    size = [NBTool autoString:notice1 font:[NBTool getFont:14.f] width:NB_SCREEN_WIDTH - 40];
    noticeLabel1.text = notice1;
    noticeLabel1.numberOfLines = 0;
    noticeLabel1.textAlignment = NSTextAlignmentCenter;
    noticeLabel1.textColor = [NBTool getColorNumber:0];
    noticeLabel1.font = [NBTool getFont:14.f];
    noticeLabel1.frame = CGRectMake((NB_SCREEN_WIDTH - size.width)/2.f, CGRectGetMaxY(actualRect)+20.f, size.width, size.height);
    [self.view addSubview:noticeLabel1];
    
}
- (void)setupNBQRCodeScanning
{
    // 5.1 添加会话输入
    [self.session addInput:self.input];
    
    // 5.2 添加会话输出
    [self.session addOutput:self.output];
    
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    [self.view.layer insertSublayer: self.previewLayer atIndex:0];
    
    [self startToScan];//开始扫描
}


-(void)startToScan{

    // 9、启动会话
    [self.session startRunning];

}




- (void)drawLayer {
    
    //中间透明矩形作用区域
    CGRect actualRect = CGRectMake((NB_SCREEN_WIDTH - length) / 2.0, (NB_SCREEN_HEIGHT - length) / 2.0, length, length);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, NB_SCREEN_WIDTH, NB_SCREEN_HEIGHT)];
    UIBezierPath *actualPath = [UIBezierPath bezierPathWithRect:actualRect];
    [path appendPath:actualPath];
    
    //绘制中心区域白色边线
    CAShapeLayer *centerLayer = [CAShapeLayer layer];
    centerLayer.path = actualPath.CGPath;
    centerLayer.fillColor = [UIColor clearColor].CGColor;
    centerLayer.strokeColor = [UIColor whiteColor].CGColor;
    centerLayer.lineWidth = 0.5;
    [path stroke];
    
    //
    CAShapeLayer *qrcodeActualLayer = [CAShapeLayer layer];
    qrcodeActualLayer.path = path.CGPath;
    qrcodeActualLayer.fillColor = [UIColor blackColor].CGColor;
    qrcodeActualLayer.fillRule = kCAFillRuleEvenOdd;
    qrcodeActualLayer.opacity = 0.7;
    
    [self.view.layer addSublayer:qrcodeActualLayer];
    [self.view.layer addSublayer:centerLayer];
    [self.view addSubview:self.lineImageView];
    
    //line animation
    CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    lineAnimation.duration = 2;
    lineAnimation.repeatCount = MAXFLOAT;
    lineAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(NB_SCREEN_WIDTH / 2.0, CGRectGetMinY(actualRect))];
    lineAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(NB_SCREEN_WIDTH / 2.0, CGRectGetMaxY(actualRect))];
    lineAnimation.removedOnCompletion = NO;
    lineAnimation.fillMode = kCAFillModeForwards;
    lineAnimation.autoreverses = YES;
    [self.lineImageView.layer addAnimation:lineAnimation forKey:nil];
}


#pragma mark -------------------------------------------------------- AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count != 0) {
        
        // 0、扫描成功之后的提示音
//        [self SG_playSoundEffect:@"SGQRCode.bundle/sound.caf"];
        
        // 1、如果扫描完成，停止会话
        [self.session stopRunning];
        
        // 2、删除预览图层
        [self.previewLayer removeFromSuperlayer];
        
        // 3、设置界面显示扫描结果
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        [self dealQRCodeResult:obj.stringValue];
        
        
    }
    
}


/** 播放音效文件 */
- (void)SG_playSoundEffect:(NSString *)name {
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}

/** 播放完成回调函数 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    //SGQRCodeLog(@"播放完成...");
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    __weak typeof(self)weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf scanQRCodeFromPhotosInTheAlbum:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }];
    
    
}



#pragma mark - - - 从相册中识别二维码, 并进行界面跳转
- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {
    //    // 对选取照片的处理，如果选取的图片尺寸过大，则压缩选取图片，否则不作处理
    //    image = [UIImage imageSizeWithScreenImage:image];
    
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *scannedResult = feature.messageString;
        //SGQRCodeLog(@"scannedResult - - %@", scannedResult);
        // 在此发通知，告诉子类二维码数据
        [self dealImageQRCodeResult:scannedResult];
    }
}


#pragma mark - - - 处理相册中识别到的二维码
- (void)dealImageQRCodeResult:(NSString *)sResult{
    
    
    
}

#pragma mark - - - 处理扫描结果的二维码
- (void)dealQRCodeResult:(NSString *)sResult{
    
    
    
    
    
}



@end
