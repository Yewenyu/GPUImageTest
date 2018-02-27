//
//  UIView+ViewAutoLayout.m
//  ProductModifier
//
//  Created by 叶文宇 on 2017/6/24.
//  Copyright © 2017年 优珥格. All rights reserved.
//

#define CGRectMakeWidthLocation(location,width,height) CGRectMake(location.x, location.y, width, height)
#define CGRectMakeWidthLocationAndSize(location,CGSize) CGRectMake(location.x, location.y, CGSize.width, CGSize.height)
#define CGRectMakeWidthSize(x,y,CGSize) CGRectMake(x, y, CGSize.width, CGSize.height)

#import "UIView+ViewAutoLayout.h"

@implementation UIView (ViewAutoLayout)


-(void)setFrameOrigin:(CGPoint)pos{
    
    self.frame = CGRectMakeWidthLocationAndSize(pos, self.frame.size);
}
-(void)setFrameSize:(CGSize)size{
    
    self.frame = CGRectMakeWidthLocationAndSize(self.frame.origin, size);
}
-(void)setFrameWithScreenScale:(CGFloat)screenScale andHeight:(CGFloat)height{
    
    CGFloat width = height/screenScale;
    
    self.frame = CGRectMakeWidthLocationAndSize(self.frame.origin, CGSizeMake(width, height));
}
-(void)setFrameWithScreenScale:(CGFloat)screenScale andWidth:(CGFloat)width{
    
    CGFloat height = width*screenScale;
    
    self.frame = CGRectMakeWidthLocationAndSize(self.frame.origin, CGSizeMake(width, height));
}

-(void)sizeEqualToView:(id)view{
    [self setFrameSize:[view frame].size];
}
-(void)squareSizeWithLength:(CGFloat)length{
    [self setFrameSize:CGSizeMake(length, length)];
}
-(void)setFrameWithOrigin:(CGPoint)pos andSize:(CGSize)size{
    
    self.frame = CGRectMakeWidthLocationAndSize(pos, size);
}

-(CGPoint)countPosFromView:(id)view andOffset:(CGPoint)offset{
    CGPoint viewPos = [view frame].origin;
    
    CGPoint selfPos = CGPointMake(viewPos.x+offset.x, viewPos.y+offset.y);
    return selfPos;
}
-(void)posAdjustFromView:(id)view andOffset:(CGPoint)offset{
    
    
    CGPoint selfPos = [self countPosFromView:view andOffset:offset];
    
    [self setFrameOrigin:selfPos];
}
-(CGPoint)countDownAdjustFromView:(id)view andOffset:(CGPoint)offset{
    
    CGSize viewSize = [view frame].size;
    CGPoint selfPos = [self countPosFromView:view andOffset:offset];
    selfPos.y+=viewSize.height;
    return selfPos;
}
-(void)posDownAdjustFromView:(id)view andOffset:(CGPoint)offset{
    
    CGPoint selfPos = [self countDownAdjustFromView:view andOffset:offset];
    [self setFrameOrigin:selfPos];
}
-(CGPoint)countDownAdjustFromView:(id)view andOffset:(CGPoint)offset isCenter:(BOOL)isCenter{
    CGPoint selfPos = [self countDownAdjustFromView:view andOffset:offset];
    if(isCenter){
        selfPos.x +=[view frame].size.width/2-self.frame.size.width/2;
    }
    return selfPos;
}
-(void)posDownAdjustFromView:(id)view andOffset:(CGPoint)offset isCenter:(BOOL)isCenter{
    
    CGPoint selfPos = [self countDownAdjustFromView:view andOffset:offset isCenter:isCenter];
    
    [self setFrameOrigin:selfPos];
}
-(void)setSize:(CGSize)size posAdjustFromView:(id)view andOffset:(CGPoint)offset{
    
    CGPoint viewPos = [view frame].origin;
    
    CGPoint selfPos = CGPointMake(viewPos.x+offset.x, viewPos.y+offset.y);
    
    [self setFrameWithOrigin:selfPos andSize:size];
}
-(void)sizeAdjustFromView:(id)view andScale:(CGPoint)scale{
    
    CGSize viewSize = [view frame].size;
    
    CGSize selfSize = CGSizeMake(viewSize.width*scale.x, viewSize.height*scale.y);
    
    [self setFrameSize:selfSize];
}

-(void)sizeAdjustFromView:(id)view andDiffValue:(CGPoint)diffValue{
    
    CGSize viewSize = [view frame].size;
    
    CGSize selfSize = CGSizeMake(viewSize.width+diffValue.x, viewSize.height+diffValue.y);
    
    [self setFrameSize:selfSize];
}


@end
