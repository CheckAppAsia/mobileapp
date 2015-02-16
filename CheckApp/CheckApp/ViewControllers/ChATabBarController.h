//
//  ChATabBarController.h
//  CheckApp
//
//  Created by John Q. Dometita on 7/24/14.
//  Copyright (c) 2014 John Q. Dometita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChANavigationBar.h"
#import "ChAMenuDrawer.h"

@class ChAMenuDrawer;

@interface ChATabBarController : UITabBarController <buttondelegate,UITabBarControllerDelegate,UITabBarDelegate> {
    
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) ChANavigationBar *navigationBar;

@property (strong, nonatomic) IBOutlet UITabBar *tabBar;

@property (strong, nonatomic) IBOutlet ChATabBarController *tabBarController;
@property (assign, nonatomic) int tabbarItemheight;
@property (assign, nonatomic) int tabbarItemwidth;
@end
