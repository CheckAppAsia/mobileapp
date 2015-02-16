//
//  CADesign.h
//  CheckApp
//
//  Created by John Q. Dometita on 7/10/14.
//  Copyright (c) 2014 John Q. Dometita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChADesign : NSObject

+(UIColor *)baseColor;
+(void)applyDefaultTextField:(UITextField *)textfield;
+(void)applyDefaultTextField:(UITextField *)textfield withBorders:(BOOL)apply radius:(CGFloat)radius;
+(void)applyDefaultTextField:(UITextField *)textfield withBorders:(BOOL)apply;
+(void)applyDefaultButton:(UIButton *)button;
+(void)applyRoundedCorners:(UIView *)view;
+(void)applyRoundedCorners:(UIView *)view radius:(CGFloat)radius;
+(void)applyBorder:(UIView *)view width:(CGFloat)width color:(UIColor *)color;
+(void)applyBaseMenuItemDesign:(UIButton *)btn;
+(void)applyBaseMenuItemDesign:(UIButton *)btn withImage:(UIImage *)image;
+(void)applyBaseMenuItemDesign:(UIButton *)btn withNormalImage:(UIImage *)image andSelected:(UIImage *)selectedImage;


+(UIColor *)dashBoardBaseColor;
+(UIColor *)myHealthBaseColor;
+(UIColor *)doctorsBaseColor;
+(UIColor *)friendsBaseColor;
+(UIColor *)profileBaseColor;
+(UIColor *)menuBaseColor;
+(UIColor *)menuHighlightColor;

+(UIImage *)getTabBarBackground;
+(UIFont *)defaultFontWithSize:(CGFloat)size;
+(UIFont *)defaultItalicFontWithSize:(CGFloat)size;


@end
