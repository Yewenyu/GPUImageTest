//
//  UIView+ViewAutoLayout.h
//  ProductModifier
//
//  Created by 叶文宇 on 2017/6/24.
//  Copyright © 2017年 优珥格. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ViewAutoLayout)

-(void)setFrameOrigin:(CGPoint)pos;
-(void)setFrameSize:(CGSize)size;
-(void)setFrameWithScreenScale:(CGFloat)screenScale andHeight:(CGFloat)height;
-(void)setFrameWithScreenScale:(CGFloat)screenScale andWidth:(CGFloat)width;
-(void)sizeEqualToView:(id)view;
-(void)squareSizeWithLength:(CGFloat)length;
-(void)setFrameWithOrigin:(CGPoint)pos andSize:(CGSize)size;
-(void)posAdjustFromView:(id)view andOffset:(CGPoint)offset;
-(void)posDownAdjustFromView:(id)view andOffset:(CGPoint)offset;
-(void)posDownAdjustFromView:(id)view andOffset:(CGPoint)offset isCenter:(BOOL)isCenter;
-(void)setSize:(CGSize)size posAdjustFromView:(id)view andOffset:(CGPoint)offset;
-(void)sizeAdjustFromView:(id)view andScale:(CGPoint)scale;
-(void)sizeAdjustFromView:(id)view andDiffValue:(CGPoint)diffValue;

@end
