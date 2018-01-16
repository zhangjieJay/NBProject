//
//  UIControl+NBClicked.m
//  NBProject
//
//  Created by 张杰 on 2018/1/11.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "UIControl+NBClicked.h"

/**本类UISwitch慎用**/
/**本类UISwitch慎用**/
/**本类UISwitch慎用**/


static NSString * const UIControl_acceptEventInterval = @"UIControl_acceptEventInterval";
static NSString * const UIControl_ignoreEvent= @"UIControl_ignoreEventl";

@interface UIControl()
@property(nonatomic,assign)BOOL nb_ignoreEvent;

@end

@implementation UIControl (NBClicked)

@dynamic nb_clickedInterval;

+ (void)load
{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(__nb_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}

- (NSTimeInterval)nb_clickedInterval
{
    return [objc_getAssociatedObject(self, &UIControl_acceptEventInterval) doubleValue];
}
- (void)setNb_clickedInterval:(NSTimeInterval)nb_clickedInterval
{
    objc_setAssociatedObject(self, &UIControl_acceptEventInterval, @(nb_clickedInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)nb_ignoreEvent{
    return [objc_getAssociatedObject(self, &UIControl_ignoreEvent) boolValue];
}

-(void)setNb_ignoreEvent:(BOOL)nb_ignoreEvent{
        objc_setAssociatedObject(self, &UIControl_ignoreEvent, @(nb_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)__nb_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (self.nb_ignoreEvent) return;
    if (self.nb_clickedInterval > 0){
        self.nb_ignoreEvent = YES;
        [self performSelector:@selector(setNb_ignoreEvent:) withObject:@(NO) afterDelay:self.nb_clickedInterval];
    }
    [self __nb_sendAction:action to:target forEvent:event];
}
@end
