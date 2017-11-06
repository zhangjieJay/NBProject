//
//  PreCCell.m
//  NBProject
//
//  Created by 峥刘 on 17/8/30.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "PreCCell.h"
#import "NBPImageView.h"

@interface PreCCell()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView * scaleView;//缩放的滚动视图
@property(nonatomic,strong)NBPImageView * igvView;//imageView
@end

@implementation PreCCell{

    CGRect maxFrame;
}

-(UIScrollView *)scaleView{

    if (!_scaleView) {
        maxFrame = CGRectMake(0, 0, NB_SCREEN_WIDTH, NB_SCREEN_HEIGHT);
        _scaleView = [[UIScrollView alloc]initWithFrame:maxFrame];
        _scaleView.backgroundColor = [UIColor blackColor];
        _scaleView.showsHorizontalScrollIndicator = NO;
        _scaleView.showsVerticalScrollIndicator = NO;
        _scaleView.minimumZoomScale = 1.f;
        _scaleView.maximumZoomScale = 3.f;
        _scaleView.delegate =self;
        [self.contentView addSubview:_scaleView];
    }
    return _scaleView;
}

-(NBPImageView *)igvView{

    if (!_igvView) {
    
        
        _igvView = [[NBPImageView alloc]initWithFrame:self.scaleView.bounds];
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapped:)];
        [_igvView addGestureRecognizer:tapGR];
        
        
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapped:)];
        doubleTap.numberOfTapsRequired = 2;
        [tapGR requireGestureRecognizerToFail:doubleTap];
        
        [_igvView addGestureRecognizer:doubleTap];
        _igvView.backgroundColor = [UIColor redColor];
        _igvView.userInteractionEnabled = YES;
        _igvView.multipleTouchEnabled = YES;
        _igvView.contentMode = UIViewContentModeScaleAspectFill;
        [self.scaleView addSubview:_igvView];
    }
    return _igvView;

}


-(void)setModel:(ImageModel *)model{
    NSLog(@"图片名称%@",model.imageName);
    self.igvView.image = [UIImage imageNamed:model.imageName];
    [self.igvView resetSuperViewFrame];

}
#pragma mark -------------------------------------------------------- UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.igvView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    [self changeFramse:scrollView];
}

-(void)scaledToMin{

    [self.scaleView setZoomScale:1.f animated:YES];

}




-(void)resetFrames:(UIImageView *)imageView{
    
    CGFloat scale = [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;//屏幕宽高比
    
    CGFloat width = imageView.image.size.width;//图片宽度
    CGFloat height = imageView.image.size.height;//图片高度
    
    CGFloat imageScale = width/height;//图片宽高比
    
    CGRect frame = imageView.frame;
    CGRect superFrame = imageView.superview.frame;
    
    if (scale<=imageScale) {
        height = superFrame.size.height;
        frame.size.height = frame.size.width/imageScale;
        superFrame.size.height = frame.size.height;
        superFrame.origin.y = (height-frame.size.height)/2.f;
        imageView.frame = frame;
    }else{
        
//        width = superFrame.size.width;
        frame.size.width = frame.size.height*imageScale;
        superFrame.size.width = frame.size.width;
        imageView.frame = frame;
        
    }
    self.scaleView.frame = superFrame;
}


-(void)changeFramse:(UIScrollView *)scrollview{
    
    CGRect imageFrame = self.igvView.frame;
    
    if (imageFrame.size.width>maxFrame.size.width) {
        imageFrame.origin.x = 0;
        imageFrame.size.width = maxFrame.size.width;
    }else{
        imageFrame.origin.x = (maxFrame.size.width - imageFrame.size.width)/2.f;
    }
    
    if (imageFrame.size.height>maxFrame.size.height) {
        imageFrame.size.height = maxFrame.size.height;
        imageFrame.origin.y = 0;
    }else{
        
        imageFrame.origin.y = (maxFrame.size.height - imageFrame.size.height)/2.f;
    }
    scrollview.frame = imageFrame;
}

-(void)singleTapped:(UITapGestureRecognizer *)sGR{
    
    UIView * view = [NBTool recurseTogetSuperView:@"NBPreView" childView:self];
    if (view) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.frame = CGRectMake(self.frame.origin.x, NB_SCREEN_HEIGHT, 0, 0);
            
        } completion:^(BOOL finished) {
            
            [view removeFromSuperview];
        }];
    }

}

-(void)doubleTapped:(UITapGestureRecognizer *)dGR{
    
    CGFloat zoScale = self.scaleView.zoomScale;


    if (zoScale <= 2) {
        CGRect bound = self.scaleView.bounds;
        CGRect boundIgv = self.igvView.bounds;
        CGPoint point = [dGR locationInView:self.igvView];
        CGFloat xRatio = point.x/boundIgv.size.width;
        CGFloat yRatio = point.y/boundIgv.size.height;
        CGFloat x = xRatio * bound.size.width;
        CGFloat y = yRatio * bound.size.height;
        [self.scaleView zoomToRect:CGRectMake(x, y, 1, 1) animated:YES];

        
    }else{
    
        [self.scaleView setZoomScale:1.f animated:YES];

    }

}



@end
