//
//  BTRECViewController.m
//  NBProject
//
//  Created by scuser on 2017/11/7.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBRECViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import "NBRECManager.h"


#define length NB_SCREEN_WIDTH
#define NoticeHeight 50
static NSString * notice = @"点击开始按钮进行录制";

@interface NBRECViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property(nonatomic,strong)AVCaptureSession * session;

// 当前设备
@property (nonatomic, strong)AVCaptureDevice *backCamera;
@property (nonatomic, strong)AVCaptureDevice *frontCamera;
@property (nonatomic, strong)AVCaptureDevice *audioMic;


//输入
@property (nonatomic, strong)AVCaptureDeviceInput *backCameraInput;
@property (nonatomic, strong)AVCaptureDeviceInput *frontCameraInput;
@property (nonatomic,strong)AVCaptureDeviceInput * audioMicInput;


//输出
@property (nonatomic, strong)AVCaptureVideoDataOutput *videoOutput;//视频输入入口
@property (nonatomic, strong)AVCaptureAudioDataOutput *audioOutput;//音频输入入口


@property (nonatomic, strong)dispatch_queue_t captureQueue;//处理队列
@property (nonatomic, strong)UIImageView * preView;//当前录制的视图预览图




//@property(nonatomic,strong)AVCaptureConnection * videoConnection;//视频连接
//@property(nonatomic,strong)AVCaptureConnection * audioConnection;//音频连接

@property(nonatomic,strong)NBRECManager * writeManager;


//拍摄显示图层类
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewLayer;//视频呈现图层


@property (nonatomic, strong)BaseView * controllView;//底部操作区域
@property(nonatomic,strong)UIButton * btnRecord;//录制按钮


@property(nonatomic,assign)BOOL isCapturing;//是否在录制
@property(nonatomic,assign)BOOL isPaused;//是否处于暂停状态

@end

@implementation NBRECViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAuthorityToCamera];
    
}

// 1、获取摄像设备-后置摄像头
- (AVCaptureDevice *)backCamera {
    if (!_backCamera) {
        
        _backCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
    }
    return _backCamera;
}
// 1、获取摄像设备-前置摄像头
- (AVCaptureDevice *)frontCamera {
    if (!_frontCamera) {
        _frontCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
    }
    return _frontCamera;
}
- (AVCaptureDevice *)audioMic{
    if (!_audioMic) {
        _audioMic = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    }
    return _audioMic;
}



#pragma mark ------------------------------------ 初始化导航栏
-(void)initNavigationView{
    
    self.navigationItem.title = @"录制小视频";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor getColorNumber:125];
}

-(void)rightBarButtonClicked{
    
    if (self.writeManager.writer.status != AVAssetWriterStatusUnknown) {
        
        
        [self stopCaptureHandler:^(UIImage *movieImage) {
            
            self.preView.image = movieImage;
            
        }];
    }

    
    
}

//停止录制
- (void) stopCaptureHandler:(void (^)(UIImage *movieImage))handler {
    @synchronized(self) {
        NSString* path = self.writeManager.videoPath;
        NSURL* url = [NSURL fileURLWithPath:path];
        
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self.writeManager.writer finishWritingWithCompletionHandler:^{
                
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    if (!error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NBAlertView * alertView = [NBAlertView new];
                            [alertView showSuccess:@"恭喜你保存成功"];
                            NSLog(@"保存成功");
                            self.writeManager = nil;
                        });
                    }
                }];
                [self movieToImageHandler:handler];
                
            }];
            
        });
    }
}


//获取视频第一帧的图片
- (void)movieToImageHandler:(void (^)(UIImage *movieImage))handler {
    NSURL *url = [NSURL fileURLWithPath:self.writeManager.videoPath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(0, 60);
    generator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    AVAssetImageGeneratorCompletionHandler generatorHandler =
    ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *thumbImg = [UIImage imageWithCGImage:im];
            if (handler) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(thumbImg);
                });
            }
        }
    };
    [generator generateCGImagesAsynchronouslyForTimes:
     [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:generatorHandler];
}



//用来返回是前置摄像头还是后置摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    //返回和视频录制相关的所有默认设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //遍历这些设备返回跟position相关的设备
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

//开启闪光灯
- (void)openFlashLight {
    AVCaptureDevice *backCamera = [self backCamera];
    if (backCamera.torchMode == AVCaptureTorchModeOff) {
        [backCamera lockForConfiguration:nil];
        backCamera.torchMode = AVCaptureTorchModeOn;
        backCamera.flashMode = AVCaptureFlashModeOn;
        [backCamera unlockForConfiguration];
    }
}


//关闭闪光灯
- (void)closeFlashLight {
    AVCaptureDevice *backCamera = [self backCamera];
    if (backCamera.torchMode == AVCaptureTorchModeOn) {
        [backCamera lockForConfiguration:nil];
        backCamera.torchMode = AVCaptureTorchModeOff;
        backCamera.flashMode = AVCaptureTorchModeOff;
        [backCamera unlockForConfiguration];
    }
}


- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        // 高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetMedium];
        
        if ([_session canAddInput:self.backCameraInput]) {
            [_session addInput:self.backCameraInput];
        }
        if ([_session canAddOutput:self.videoOutput]) {
            [_session addOutput:self.videoOutput];
        }
        
        if ([_session canAddInput:self.audioMicInput]) {
            [_session addInput:self.audioMicInput];
        }
        if ([_session canAddOutput:self.audioOutput]) {
            [_session addOutput:self.audioOutput];
        }
    }
    return _session;
}





//后置摄像头输入
-(AVCaptureDeviceInput *)backCameraInput{
    if (!_backCameraInput) {
        NSError *error;
        _backCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.backCamera error:&error];
        if (error) {
            [NBHudProgress showErrorText:@"获取后置摄像头失败~"];
        }
    }
    return _backCameraInput;
}
//前置摄像头输入
-(AVCaptureDeviceInput *)frontCameraInput{
    if (!_frontCameraInput) {
        NSError *error;
        _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.frontCamera error:&error];
        if (error) {
            [NBHudProgress showErrorText:@"获取前置摄像头失败~"];
        }
    }
    return _frontCameraInput;
}


-(AVCaptureDeviceInput*)audioMicInput{
    if (!_audioMicInput) {
        NSError *error;
        _audioMicInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.audioMic error:&error];
    }
    return _audioMicInput;
}

//捕获到的视频呈现的layer
- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        //通过AVCaptureSession初始化
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        //设置比例为铺满全屏
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = CGRectMake(0, NoticeHeight, NB_SCREEN_WIDTH, NB_SCREEN_WIDTH);
        
    }
    return _previewLayer;
}
//视频输出
- (AVCaptureVideoDataOutput *)videoOutput {
    if (!_videoOutput) {
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoOutput setSampleBufferDelegate:self queue:self.captureQueue];
        
        // 指定像素格式
        NSDictionary* setcapSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                        nil];
        
        _videoOutput.videoSettings = setcapSettings;
        
    }
    return _videoOutput;
}
//音频输出
- (AVCaptureAudioDataOutput *)audioOutput {
    if (!_audioOutput) {
        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [_audioOutput setSampleBufferDelegate:self queue:self.captureQueue];
    }
    return _audioOutput;
}

////视频连接
//- (AVCaptureConnection *)videoConnection {
//    _videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
//    return _videoConnection;
//}
//
////音频连接
//- (AVCaptureConnection *)audioConnection {
//    if (_audioConnection == nil) {
//        _audioConnection = [self.audioOutput connectionWithMediaType:AVMediaTypeAudio];
//    }
//    return _audioConnection;
//}

//视频和音频处理队列
-(dispatch_queue_t)captureQueue{
    if (!_captureQueue) {
        _captureQueue = dispatch_queue_create("NBCaptureQueue", NULL);
    }
    return _captureQueue;
}

-(NBRECManager *)writeManager{
    
    if (!_writeManager) {
        
        NSString *betaCompressionDirectory = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/Movie.mp4"];
        
        _writeManager = [[NBRECManager alloc]initPath:betaCompressionDirectory Height:720 width:720 channels:1 samples:44100];
    }
    return _writeManager;
    
}

-(BaseView*)controllView{
    
    
    if (!_controllView) {
        _controllView = [[BaseView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.previewLayer.frame), NB_SCREEN_WIDTH, NB_SCREEN_HEIGHT-length-NoticeHeight)];
        _controllView.backgroundColor = [UIColor getColorNumber:0];
        
        self.btnRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnRecord.frame = CGRectMake((NB_SCREEN_WIDTH-50)/2.f, 0, 50, 50);
        [_controllView addSubview:self.btnRecord];
        [self.btnRecord setBackgroundImage:[UIImage imageNamed:@"rec_start"] forState:UIControlStateNormal];
        [self.btnRecord setBackgroundImage:[UIImage imageNamed:@"rec_stop"] forState:UIControlStateSelected];
        
        [self.btnRecord addTarget:self action:@selector(recordbButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _controllView;
    
}
-(UIImageView *)preView{

    if (!_preView) {
        _preView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self.controllView addSubview:_preView];
    }
    return _preView;

}

-(void)getAuthorityToCamera{
    
    // 1、 获取摄像设备
    if (self.backCamera) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (granted) {
                        // 用户第一次同意了访问相机权限
                        NSLog(@"用户第一次同意了访问相机权限");
                        NBAlertView * alertView = [NBAlertView new];
                        [alertView showSuccess:@"可以使用相机"];
                        
                    } else {
                        
                        
                        [self.navigationController popViewControllerAnimated:YES];//
                        NBAlertView * alertView = [NBAlertView new];
                        [alertView showError:@"拒绝访问相机!"];
                        // 用户第一次拒绝了访问相机权限
                        NSLog(@"用户第一次拒绝了访问相机权限");
                    }
                });
                
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NBAlertView * alertView = [NBAlertView new];
                [alertView showSuccess:@"同意过了,可以直接使用相机"];
                [self initUserInterface];
                
            });
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 相机] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
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


-(void)initUserInterface{
    
    [self initNavigationView];
    [self drawLayer];//绘制边框及填充区域
    [self initControls];//主要初始化label
    
}




- (void)drawLayer {
    
    //中间透明矩形作用区域
    CGRect actualRect = CGRectMake(0, NoticeHeight, NB_SCREEN_WIDTH, NB_SCREEN_WIDTH);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, NB_SCREEN_WIDTH, NB_SCREEN_HEIGHT)];
    UIBezierPath *actualPath = [UIBezierPath bezierPathWithRect:actualRect];
    [path appendPath:actualPath];
    
    //绘制中心区域白色边线,并填充
    CAShapeLayer *centerLayer = [CAShapeLayer layer];
    centerLayer.path = actualPath.CGPath;
    centerLayer.fillColor = [UIColor clearColor].CGColor;
    centerLayer.strokeColor = [UIColor whiteColor].CGColor;
    centerLayer.lineWidth = 0.5;
    [path stroke];
    
    //填充path区域
    CAShapeLayer *qrcodeActualLayer = [CAShapeLayer layer];
    qrcodeActualLayer.path = path.CGPath;
    qrcodeActualLayer.fillColor = [UIColor getColorNumber:35].CGColor;
    qrcodeActualLayer.fillRule = kCAFillRuleEvenOdd;
    qrcodeActualLayer.opacity = 0.7;
    
    
    [self.view.layer addSublayer:qrcodeActualLayer];
    [self.view.layer addSublayer:centerLayer];
}


- (void)initControls{
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *noticeLabel = [UILabel new];
    CGSize size = [NBTool autoString:notice font:[NBTool getFont:14.f] width:NB_SCREEN_WIDTH - 40];
    noticeLabel.text = notice;
    noticeLabel.numberOfLines = 0;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.textColor = [UIColor getColorNumber:0];
    noticeLabel.font = [NBTool getFont:14.f];
    noticeLabel.frame = CGRectMake((NB_SCREEN_WIDTH - size.width)/2.f,(NoticeHeight-size.height)/2.f, size.width, size.height);
    [self.view addSubview:noticeLabel];
    
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    [self.view addSubview:self.controllView];
    [self.session startRunning];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 写入数据
- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    
    if (!self.isCapturing || self.isPaused) {
        //如果未录制或者处于暂停状态  则不处理
        return;
    }
    
    
    
    //如果正在录制
    if (self.isCapturing) {
        //如果是视频
        if ([captureOutput isEqual:self.videoOutput]) {
            NSLog(@"正在录制视频...");
            [self encodeFrame:sampleBuffer isVideo:YES];
            
            
        }
        //如果是语音
        else if ([captureOutput isEqual:self.audioOutput]){
            NSLog(@"正在录制语音...");
            
            [self encodeFrame:sampleBuffer isVideo:NO];
            
            
            
        }
    }else{
        
        NSLog(@"未进入录制状态");
        
    }
    
    
    
    //    BOOL isVideo = YES;
    //    @synchronized(self) {
    //        if (!self.isCapturing  || self.isPaused) {
    //            return;
    //        }
    //        if (captureOutput != self.videoOutput) {
    //            isVideo = NO;
    //        }
    //
    //        //初始化编码器，当有音频和视频参数时创建编码器
    //        if ((self.recordEncoder == nil) && !isVideo)
    //        {
    //            CMFormatDescriptionRef fmt = CMSampleBufferGetFormatDescription(sampleBuffer);
    //            [self setAudioFormat:fmt];
    //            NSString *videoName = [NSString getUploadFile_type:@"video" fileType:@"mp4"];
    //            self.videoPath = [[self getVideoCachePath] stringByAppendingPathComponent:videoName];
    //            self.recordEncoder = [WCLRecordEncoder encoderForPath:self.videoPath Height:_cy width:_cx channels:_channels samples:_samplerate];
    //        }
    //
    //        //判断是否中断录制过
    //        if (self.discont) {
    //            if (isVideo) {
    //                return;
    //            }
    //            self.discont = NO;
    //            // 计算暂停的时间
    //            CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    //            CMTime last = isVideo ? _lastVideo : _lastAudio;
    //            if (last.flags & kCMTimeFlags_Valid) {
    //                if (_timeOffset.flags & kCMTimeFlags_Valid) {
    //                    pts = CMTimeSubtract(pts, _timeOffset);
    //                }
    //                CMTime offset = CMTimeSubtract(pts, last);
    //                if (_timeOffset.value == 0) {
    //                    _timeOffset = offset;
    //                }else {
    //                    _timeOffset = CMTimeAdd(_timeOffset, offset);
    //                }
    //            }
    //            _lastVideo.flags = 0;
    //            _lastAudio.flags = 0;
    //        }
    //        // 增加sampleBuffer的引用计时,这样我们可以释放这个或修改这个数据，防止在修改时被释放
    //        CFRetain(sampleBuffer);
    //        if (_timeOffset.value > 0) {
    //            CFRelease(sampleBuffer);
    //            //根据得到的timeOffset调整
    //            sampleBuffer = [self adjustTime:sampleBuffer by:_timeOffset];
    //        }
    //        // 记录暂停上一次录制的时间
    //        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    //        CMTime dur = CMSampleBufferGetDuration(sampleBuffer);
    //        if (dur.value > 0) {
    //            pts = CMTimeAdd(pts, dur);
    //        }
    //        if (isVideo) {
    //            _lastVideo = pts;
    //        }else {
    //            _lastAudio = pts;
    //        }
    //    }
    //    CMTime dur = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    //    if (self.startTime.value == 0) {
    //        self.startTime = dur;
    //    }
    //    CMTime sub = CMTimeSubtract(dur, self.startTime);
    //    self.currentRecordTime = CMTimeGetSeconds(sub);
    //    if (self.currentRecordTime > self.maxRecordTime) {
    //        if (self.currentRecordTime - self.maxRecordTime < 0.1) {
    //            if ([self.delegate respondsToSelector:@selector(recordProgress:)]) {
    //                dispatch_async(dispatch_get_main_queue(), ^{
    //                    [self.delegate recordProgress:self.currentRecordTime/self.maxRecordTime];
    //                });
    //            }
    //        }
    //        return;
    //    }
    //    if ([self.delegate respondsToSelector:@selector(recordProgress:)]) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [self.delegate recordProgress:self.currentRecordTime/self.maxRecordTime];
    //        });
    //    }
    //    // 进行数据编码
    //    [self.recordEncoder encodeFrame:sampleBuffer isVideo:isVideo];
    //    CFRelease(sampleBuffer);
}


//调整媒体数据的时间
- (CMSampleBufferRef)adjustTime:(CMSampleBufferRef)sample by:(CMTime)offset {
    CMItemCount count;
    CMSampleBufferGetSampleTimingInfoArray(sample, 0, nil, &count);
    CMSampleTimingInfo* pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
    CMSampleBufferGetSampleTimingInfoArray(sample, count, pInfo, &count);
    for (CMItemCount i = 0; i < count; i++) {
        pInfo[i].decodeTimeStamp = CMTimeSubtract(pInfo[i].decodeTimeStamp, offset);
        pInfo[i].presentationTimeStamp = CMTimeSubtract(pInfo[i].presentationTimeStamp, offset);
    }
    CMSampleBufferRef sout;
    CMSampleBufferCreateCopyWithNewTiming(nil, sample, count, pInfo, &sout);
    free(pInfo);
    return sout;
}
#pragma mark ------------------------------------ 开始或者停止
-(void)recordbButtonDidClicked:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.isCapturing = sender.selected;
}

//// 通过抽样缓存数据创建一个UIImage对象
//- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
//{
//    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    // 锁定pixel buffer的基地址
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);
//
//    // 得到pixel buffer的基地址
//    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//
//    // 得到pixel buffer的行字节数
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//    // 得到pixel buffer的宽和高
//    size_t width = CVPixelBufferGetWidth(imageBuffer);
//    size_t height = CVPixelBufferGetHeight(imageBuffer);
//
//    // 创建一个依赖于设备的RGB颜色空间
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//
//    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
//    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
//                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    // 根据这个位图context中的像素数据创建一个Quartz image对象
//    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
//    // 解锁pixel buffer
//    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//
//    // 释放context和颜色空间
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//
//    // 用Quartz image创建一个UIImage对象image
//    UIImage *image = [UIImage imageWithCGImage:quartzImage];
//
//    // 释放Quartz image对象
//    CGImageRelease(quartzImage);
//
//    return (image);
//}


//通过这个方法写入数据
- (BOOL)encodeFrame:(CMSampleBufferRef) sampleBuffer isVideo:(BOOL)isVideo {
    //数据是否准备写入
    if (CMSampleBufferDataIsReady(sampleBuffer)) {
        //写入状态为未知,保证视频先写入
        if (self.writeManager.writer.status == AVAssetWriterStatusUnknown && isVideo) {
            //获取开始写入的CMTime
            CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            //开始写入
            [self.writeManager.writer startWriting];
            [self.writeManager.writer startSessionAtSourceTime:startTime];
        }
        //写入失败
        if (self.writeManager.writer.status == AVAssetWriterStatusFailed) {
            NSLog(@"writer error %@", self.writeManager.writer.error.localizedDescription);
            return NO;
        }
        //判断是否是视频
        if (isVideo) {
            //视频输入是否准备接受更多的媒体数据
            if (self.writeManager.videoInput.readyForMoreMediaData == YES) {
                //拼接数据
                [self.writeManager.videoInput appendSampleBuffer:sampleBuffer];
                return YES;
            }
        }else {
            //音频输入是否准备接受更多的媒体数据
            if (self.writeManager.audioInput.readyForMoreMediaData) {
                //拼接数据
                [self.writeManager.audioInput appendSampleBuffer:sampleBuffer];
                return YES;
            }
        }
    }
    return NO;
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
