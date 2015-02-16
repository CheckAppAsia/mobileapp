//
//  ChANavigationBar.h
//  CheckApp
//
//  Created by John Q. Dometita on 7/23/14.
//  Copyright (c) 2014 John Q. Dometita. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChANavigationBarDelegate;

@interface ChANavigationBar : UIView

@property (weak, nonatomic) id <ChANavigationBarDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *_menuButton;

@end

@protocol ChANavigationBarDelegate <NSObject>

-(void)navigationBarSelectedMenu:(ChANavigationBar *)navigationBar hide:(BOOL)hide;
-(void)_hideMenu;


@end
