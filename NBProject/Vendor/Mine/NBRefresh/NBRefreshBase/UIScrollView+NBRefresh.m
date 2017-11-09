//
//  UIScrollView+NBRefresh.m
//  NBProject
//
//  Created by JayZhang on 2017/11/6.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "UIScrollView+NBRefresh.h"
#import "NBRefreshHeader.h"
#import "NBRefreshFooter.h"
#import <objc/runtime.h>

@implementation NSObject (NBRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end

@implementation UIScrollView (NbRefresh)

#pragma mark - header
static const char NBRefreshHeaderKey = '\0';
- (void)setNb_header:(NBRefreshHeader *)nb_header
{
    if (nb_header != self.nb_header) {
        // 删除旧的，添加新的
        [self.nb_header removeFromSuperview];
        [self insertSubview:nb_header atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"nb_header"]; // KVO
        objc_setAssociatedObject(self, &NBRefreshHeaderKey,
                                 nb_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"nb_header"]; // KVO
    }
}

- (NBRefreshHeader *)nb_header
{
    return objc_getAssociatedObject(self, &NBRefreshHeaderKey);
}

#pragma mark - footer
static const char NBRefreshFooterKey = '\0';
- (void)setNb_footer:(NBRefreshFooter *)Nb_footer
{
    if (Nb_footer != self.nb_footer) {
        // 删除旧的，添加新的
        [self.nb_footer removeFromSuperview];
        [self insertSubview:Nb_footer atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"nb_footer"]; // KVO
        objc_setAssociatedObject(self, &NBRefreshFooterKey,
                                 Nb_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"nb_footer"]; // KVO
    }
}

- (NBRefreshFooter *)nb_footer
{
    return objc_getAssociatedObject(self, &NBRefreshFooterKey);
}



#pragma mark - other
- (NSInteger)nb_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char NbRefreshReloadDataBlockKey = '\0';
- (void)setNb_reloadDataBlock:(void (^)(NSInteger))nb_reloadDataBlock
{
    [self willChangeValueForKey:@"nb_reloadDataBlock"]; // KVO
    objc_setAssociatedObject(self, &NbRefreshReloadDataBlockKey, nb_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"nb_reloadDataBlock"]; // KVO
}

- (void (^)(NSInteger))nb_reloadDataBlock
{
    return objc_getAssociatedObject(self, &NbRefreshReloadDataBlockKey);
}

- (void)executeReloadDataBlock
{
    !self.nb_reloadDataBlock ? : self.nb_reloadDataBlock(self.nb_totalDataCount);
}
@end

@implementation UITableView (NbRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(Nb_reloadData)];
}

- (void)Nb_reloadData
{
    [self Nb_reloadData];
    
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (NbRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(Nb_reloadData)];
}

- (void)Nb_reloadData
{
    [self Nb_reloadData];
    
    [self executeReloadDataBlock];
}
@end
