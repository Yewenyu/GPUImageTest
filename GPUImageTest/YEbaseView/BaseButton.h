//
//  BaseButton.h
//  ProductModifier
//
//  Created by 叶文宇 on 2017/4/8.
//  Copyright © 2017年 优珥格. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ViewAutoLayout.h"



@interface UILabel (FitFontSize)

-(CGSize)FitWithToFontWithFontSize:(float)fontSize;

@end
@interface BaseButton : UIButton

@property NSInteger targetIndex;
@property NSString *name;
@property (strong,nonatomic)UIImage *upImage;
@property (strong,nonatomic)UIImage *downImage;
@property (nonatomic)BOOL isDown;
@property (strong,nonatomic)id targetObject;

-(void)setUpImage:(NSString*)upImageName andDownImage:(NSString*)downImageName;
+(id)createButton:(CGRect)frame name:(NSString*)name andAction:(SEL)action andTarget:(id)target;

+(UILabel*)createLableWithFrame:(CGRect)frame andName:(NSString*)labelName;

+(NSArray*)createSwitchWithFrame:(CGRect)frame andName:(NSString*)name;

@end
