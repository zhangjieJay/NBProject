//
//  NBPImageView.m
//  NBProject
//
//  Created by JayZhang on 17/8/30.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "NBPImageView.h"
#import "SheetModel.h"


@interface NBPImageView()<NBSheetViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,assign)CGRect supViewFrame;//俯视图的原始尺寸
@end

@implementation NBPImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addGesture];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGesture];
    }
    return self;
}


-(void)addGesture{
    UILongPressGestureRecognizer * longGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longAcktion:)];
    longGR.delegate =self;
    longGR.minimumPressDuration = 1.f;
    [self addGestureRecognizer:longGR];

}

-(void)setImage:(UIImage *)image{
    [super setImage:image];
    [self resetImageViewFrame:self];
}


-(void)resetSuperViewFrame{
    self.superview.frame = self.supViewFrame;
}


-(void)resetImageViewFrame:(UIImageView *)imageView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat scale = screenWidth/screenHeight;//屏幕宽高比
    
    
    CGFloat width = imageView.image.size.width;//图片宽度
    CGFloat height = imageView.image.size.height;//图片高度
    
    CGFloat imageScale = width/height;//图片宽高比
    CGRect frame = imageView.frame;//此处即为屏幕的尺寸
    CGRect superFrame = imageView.superview.frame;
    frame.origin.x = 0.f;
    frame.origin.y = 0.f;
    
    if (scale<=imageScale) {//高度防线上要留缝隙(宽图相对于屏幕)
        frame.size.width = screenWidth;
        frame.size.height = frame.size.width/imageScale;
        superFrame.size.height = frame.size.height;
        superFrame.origin.y = (screenHeight-frame.size.height)/2.f;
        imageView.frame = frame;
    }else{//宽度方向上要留缝隙(长图相对应屏幕)
        frame.size.width = screenHeight;
        frame.size.width = frame.size.height*imageScale;
        superFrame.size.width = frame.size.width;
        superFrame.origin.x = (screenWidth-frame.size.width)/2.f;
        imageView.frame = frame;
    }
    self.supViewFrame = superFrame;
    imageView.superview.frame = superFrame;
    
}

-(void)longAcktion:(UILongPressGestureRecognizer *)gesture{

    if (gesture.state == UIGestureRecognizerStateBegan) {
        SheetModel * model1 = [SheetModel new];
        model1.key = @"saveToPhotoLibrary";
        model1.displayValue = @"保存至相册";
        
        SheetModel * model2 = [SheetModel new];
        model2.key = @"blurEffect";
        model2.displayValue = @"添加毛玻璃效果";
        
        
        SheetModel * model10 = [SheetModel new];
        model10.key = @"cancel";
        model10.displayValue = @"取消";
        
        NSArray * array = @[model1,model2,model10];
        
        NBSheetView * sheetView = [[NBSheetView alloc]init];
        sheetView.sDelegate = self;
        [sheetView showWithArray:array];
    }else if (gesture.state == UIGestureRecognizerStateEnded){
    
    
    
    }
}


-(void)didSelectAtIndex:(NSInteger)index key:(NSString *)key value:(NSString *)value{

    if ([key isEqualToString:@"saveToPhotoLibrary"]) {//保存至相册
        UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);//把图片保存在本地
    }else if ([key isEqualToString:@"blurEffect"]){
    
        [self blurEffect];
    
    }else if ([key isEqualToString:@"cancel"]){
    
        [self removeBlurEffect];
    
    }

}
//图片保存至相册的结果回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo: (void *) contextInfo{
    
    if (error) {
        [NBTool showMessage:@"保存相册失败"];

    }else{
        [NBTool showMessage:@"保存相册成功"];

    }
}


@end
