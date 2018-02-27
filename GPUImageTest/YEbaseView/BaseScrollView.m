//
//  BaseScrollView.m
//  ProductModifier
//
//  Created by 叶文宇 on 2017/6/27.
//  Copyright © 2017年 优珥格. All rights reserved.
//

#import "BaseScrollView.h"


@implementation BaseScrollView{
    
    NSMutableArray *segmentBtnArray;
    
    id lastBtn;
    
    float segmentWidth;
    float segmentHeight;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(instancetype)initWithFrame:(CGRect)frame andnameArray:(NSArray*)nameArray andIdArray:(NSArray*)idArray{
    
    self = [self initWithFrame:frame];
    
    if(self){
        self.currentAlpha = 1;
        [self createSelfWithandnameArray:nameArray andIdArray:idArray];
        
    }
    return self;
}
-(void)setCurrentAlpha:(CGFloat)currentAlpha{
    _currentAlpha = currentAlpha;
    self.alpha = currentAlpha;
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    segmentHeight = self.frame.size.height;
    segmentWidth = 0;
    
    CGPoint lastBtnPos = CGPointMake(0, 0);
    for (NSInteger index = 0; index < segmentBtnArray.count; index++){
        
        BaseButton *button = segmentBtnArray[index];
        CGSize size = [button.titleLabel FitWithToFontWithFontSize:16];
        size = CGSizeMake(size.width+10, size.height);
        segmentWidth +=size.width;
        [button setFrameWithOrigin:lastBtnPos andSize:CGSizeMake(size.width, segmentHeight)];
        lastBtnPos = CGPointMake(lastBtnPos.x+size.width, lastBtnPos.y);

    }
    CGSize contentSize = CGSizeMake(segmentWidth, segmentHeight);
    if(contentSize.width>self.frame.size.width){
        self.contentSize = contentSize;
    }else{
        self.contentSize = self.frame.size;
    }
}

-(void)createSelfWithandnameArray:(NSArray*)nameArray andIdArray:(NSArray*)idArray{
    
    if(!nameArray){
        return;
    }
    segmentBtnArray = [NSMutableArray array];
    
    for (NSInteger index = 0; index < nameArray.count; index++) {
        BaseButton *segmentBtn = [BaseButton createButton:CGRectZero name:nameArray[index] andAction:@selector(segmentBtnAction:) andTarget:self];
        [segmentBtn setBackgroundImage:nil forState:UIControlStateNormal];
        segmentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        segmentBtn.targetIndex = [idArray[index]integerValue];
        [segmentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        
        [segmentBtnArray addObject:segmentBtn];
        [self addSubview:segmentBtn];
        if (index == 0) {
            lastBtn = segmentBtn;
            segmentBtn.selected = YES;
            self.selectIndex = segmentBtn.targetIndex;
        }
    }
    
}

-(void)segmentBtnAction:(BaseButton*)button{
    
    [lastBtn setSelected:NO];
    lastBtn = button;
     button.selected = YES;
    self.selectIndex = button.targetIndex;
   
    
    if(self.baseScrollViewDelegate){
        
        if([self.baseScrollViewDelegate respondsToSelector:@selector(BaseScrollViewSegmentBtnSelectAction:andView:)]){
            
            [self.baseScrollViewDelegate BaseScrollViewSegmentBtnSelectAction:button andView:self];
        }
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    if(self.alpha<1){
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
        }];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if(self.currentAlpha<1){
        //self.alpha = self.currentAlpha;
        [UIView animateWithDuration:1 animations:^{
            self.alpha = self.currentAlpha;
        }];
    }
}

@end
