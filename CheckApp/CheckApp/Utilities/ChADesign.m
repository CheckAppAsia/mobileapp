//
//  CADesign.m
//  CheckApp
//
//  Created by John Q. Dometita on 7/10/14.
//  Copyright (c) 2014 John Q. Dometita. All rights reserved.
//

#import "ChADesign.h"
#import <QuartzCore/QuartzCore.h>

#define kPaddingValue 15.0f
@implementation ChADesign

+(UIColor *)baseColor {
    return [UIColor colorWithRed:66.0f/255.0f green:181.0f/255.0f blue:247.0f/255.0f alpha:1.0f];}

+(void)applyDefaultTextField:(UITextField *)textfield {
    [ChADesign applyDefaultTextField:textfield withBorders:YES];
}

+(void)applyDefaultTextField:(UITextField *)textfield withBorders:(BOOL)apply {
    [ChADesign applyDefaultTextField:textfield withBorders:apply radius:3.0f];
}

+(void)applyDefaultTextField:(UITextField *)textfield withBorders:(BOOL)apply radius:(CGFloat)radius {
    //add left padding
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kPaddingValue, textfield.frame.size.height)];
    textfield.leftView = paddingView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    
    //add right padding
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kPaddingValue, textfield.frame.size.height)];
    textfield.rightView = paddingView;
    textfield.rightViewMode = UITextFieldViewModeAlways;
    
    //add the border color
    if(apply) {
        [ChADesign applyRoundedCorners:textfield radius:radius];
    }
    
    //customize the placeholder
    NSString *placeholder = textfield.placeholder;
    textfield.placeholder = nil;
    textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Roboto-LightItalic" size:14.0f]}];
    
    //there must be an issue with the attributedPlaceholder, adding this line below to fix
    textfield.font = [ChADesign defaultItalicFontWithSize:14.0f];
}

+(void)applyDefaultButton:(UIButton *)button {
    //add the border color
    button.layer.cornerRadius = 3.0f;
    button.layer.borderColor = [ChADesign baseColor].CGColor;
    button.layer.borderWidth = 1.0f;
    
    button.backgroundColor = [ChADesign baseColor];
}

+(void)applyRoundedCorners:(UIView *)view {
    [ChADesign applyRoundedCorners:view radius:3.0f];
}

+(void)applyRoundedCorners:(UIView *)view radius:(CGFloat)radius {
    view.layer.cornerRadius = radius;
    view.layer.borderColor = [ChADesign baseColor].CGColor;
    view.layer.borderWidth = 1.0f;
}

+(void)applyBorder:(UIView *)view width:(CGFloat)width color:(UIColor *)color {
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
}

+(void)applyBaseMenuItemDesign:(UIButton *)btn {
    [ChADesign applyBaseMenuItemDesign:btn withImage:[UIImage imageNamed:@"ico_people"]];
}

+(void)applyBaseMenuItemDesign:(UIButton *)btn withImage:(UIImage *)image {
    [ChADesign applyBaseMenuItemDesign:btn withNormalImage:image andSelected:nil];
}

+(void)applyBaseMenuItemDesign:(UIButton *)btn withNormalImage:(UIImage *)image andSelected:(UIImage *)selectedImage  {
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 0.0f)];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f)];
    [btn.titleLabel setFont:[ChADesign defaultFontWithSize:14.0f]];
    [ChADesign applyBorder:btn width:1.0f color:[ChADesign profileBaseColor]];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    if(selectedImage != nil) {
        [btn setImage:selectedImage forState:UIControlStateHighlighted];
        [btn setImage:selectedImage forState:UIControlStateSelected];
    }
    [btn setBackgroundImage:[ChADesign getMenuItemBackgroundImage:YES size:btn.frame.size] forState:UIControlStateNormal];
    [btn setBackgroundImage:[ChADesign getMenuItemBackgroundImage:NO size:btn.frame.size] forState:UIControlStateHighlighted];
}

+(UIImage *)getMenuItemBackgroundImage:(BOOL)normal size:(CGSize)size {
    UIImage *image = nil;
    UIGraphicsBeginImageContext(size);
    
    //divide the size into 5
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect  = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIColor *color = (normal) ? [ChADesign menuBaseColor] : [ChADesign menuHighlightColor];
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextFillRect(ctx, rect);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIColor *)dashBoardBaseColor {
    return [UIColor colorWithRed:63.0f/255.0f green:145.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
}

+(UIColor *)myHealthBaseColor {
    return [UIColor colorWithRed:53.0f/255.0f green:171.0f/255.0f blue:248.0f/255.0f alpha:1.0f];
}

+(UIColor *)doctorsBaseColor {
    return [UIColor colorWithRed:66.0f/255.0f green:181.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
}

+(UIColor *)friendsBaseColor {
    return [UIColor colorWithRed:95.0f/255.0f green:195.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
}

+(UIColor *)profileBaseColor {
    return [UIColor colorWithRed:122.0f/255.0f green:205.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
}

+(UIColor *)menuBaseColor {
    return [UIColor colorWithRed:51.0f/255.0f green:149.0f/255.0f blue:215.0f/255.0f alpha:1.0f];
}

+(UIColor *)menuHighlightColor {
    return [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
}

+(UIImage *)getTabBarBackground {
    UIImage *image = nil;
    CGSize size = [[UIScreen mainScreen] bounds].size;
    UIGraphicsBeginImageContext(size);
    
    //divide the size into 5
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect  = CGRectMake(0.0f, 0.0f, size.width/5.0f, 49.0f);
    NSArray *colors = @[
                      [ChADesign dashBoardBaseColor],
                      [ChADesign myHealthBaseColor],
                      [ChADesign doctorsBaseColor],
                      [ChADesign friendsBaseColor],
                      [ChADesign profileBaseColor]
                      ];
    for(int i = 0; i < 5; i++) {
        rect.origin.x = i * size.width/5.0f;
        CGContextSetFillColorWithColor(ctx, [colors[i] CGColor]);
        CGContextFillRect(ctx, rect);
    }
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    return image;
}

+(UIFont *)defaultFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Roboto-Light" size:size];
}

+(UIFont *)defaultItalicFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Roboto-LightItalic" size:size];
}

@end
