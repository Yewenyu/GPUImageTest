//
//  BaseScrollView.h
//  ProductModifier
//
//  Created by 叶文宇 on 2017/6/27.
//  Copyright © 2017年 优珥格. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseButton.h"

@protocol BaseScrollViewDelegate<NSObject>

@optional

-(void)BaseScrollViewSegmentBtnSelectAction:(BaseButton*)button andView:(id)view;

@end
@interface BaseScrollView : UIScrollView

@property (assign)id<BaseScrollViewDelegate>baseScrollViewDelegate;

@property NSInteger selectIndex;

@property (nonatomic)CGFloat currentAlpha;

-(instancetype)initWithFrame:(CGRect)frame andnameArray:(NSArray*)nameArray andIdArray:(NSArray*)idArray;

@end
