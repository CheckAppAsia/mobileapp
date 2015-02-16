//
//  ChATabBarController.m
//  CheckApp
//
//  Created by John Q. Dometita on 7/24/14.
//  Copyright (c) 2014 John Q. Dometita. All rights reserved.
//

#import "ChATabBarController.h"
#import "ChANavigationBar.h"
#import "ChADesign.h"
#import "ChAMenuDrawer.h"

@interface ChATabBarController () <ChANavigationBarDelegate> {
    NSArray *mTitles;
    UIView *mButtonContainers;
    NSArray *mColors;
    NSArray *mButtonImageNames;
    ChAMenuDrawer *mMenuDrawer;
}
    
@end

@implementation ChATabBarController;
@synthesize tabBar;
@synthesize tabbarItemheight;
@synthesize tabbarItemwidth;


-(void)viewDidLoad {
    [super viewDidLoad];
    
        self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
    
    self.navigationBar = [[ChANavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 64.0f)];
    self.navigationBar.delegate = self;
   // self.tabBarController.delegate = self;
    self.delegate = self;
  //  self.tabBar.delegate = self
    [self.view addSubview:self.navigationBar];
   // NSLog(@"%s", __func__);
    
    [self _setupViews];
    [self _changeTabs:mButtonContainers.subviews[0]];
    
 
    for (UIView *v in self.tabBar.subviews) {
        if ([NSStringFromClass(v.class) isEqual:@"UITabBarButton"]) {
            [v performSelector:@selector(_setUnselectedTintColor:) withObject:[UIColor whiteColor]];
        }
    }
    
    
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    
    // here you need to use the icon with the color you want, as it will be rendered as it is
    
    item1.image = [[UIImage imageNamed:@"ico_appointments@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // this icon is used for selected tab and it will get tinted as defined in
    
    item1.selectedImage = [[UIImage imageNamed:@"ico_appointment_selected@2x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];



  
    
    NSLog(@"iiitem %@", tabBar.items);
    /*
    [[tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"ico_menu_help@2x.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"ico_menu_help@2x.png"]];
    */
  //  [[tabBar.items objectAtIndex:0] setBarTintColor:[UIColor redColor]];

   
   
    int i = 0;
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            
            tabbarItemheight = view.frame.size.height;
            tabbarItemwidth = view.frame.size.width;
             NSLog(@"tabbarItemwidth %d", tabbarItemwidth);
    
            // view.frame contains the frame for each item's view
            // view.center contains the center of each item's view
        }
    
    }
    
    
    [tabBar setBackgroundColor:[UIColor colorWithRed:0.000 green:0.733 blue:0.616 alpha:1.000]];
    
}



-(void)tabBar:(UITabBar *)theTabBar didSelectItem:(UIViewController *)viewController
{
    NSLog(@"Tab index = %@ ", theTabBar.selectedItem);
    for(int i = 0; i < theTabBar.items.count; i++)
    {
        if(theTabBar.selectedItem == theTabBar.items[i])
        {
          //  NSLog(@"tab %d",i);// this will give the selected tab
        }
        
    }
    //NSlog(@"Items = %@", theTabBar.items[0]);
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
   // UITabBarItem *item = [tabBarController.selectedIndex];
    NSLog(@"item %lu", (unsigned long)tabBarController.selectedIndex);
    
    if (tabBarController.selectedIndex == 0) {
        [self _updateMenu:0];
    } else if (tabBarController.selectedIndex == 1) {
        [self _updateMenu:1];
       
        
        
        
    } else if (tabBarController.selectedIndex == 2) {
        [self _updateMenu:2];
    } else if (tabBarController.selectedIndex == 3) {
        [self _updateMenu:3];
    } else if (tabBarController.selectedIndex == 4) {
        [self _updateMenu:4];
    } else if (tabBarController.selectedIndex == 5) {
        [self _updateMenu:5];
    }
    
}

-(void)logout:(NSString*)data {
    
    UIViewController *initViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    initViewController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:initViewController animated:YES completion:nil];
}


-(void)_changeTabs:(UIButton *)btn {
    for(UIButton *v in mButtonContainers.subviews) {
        UILabel *label  = (UILabel *)[v viewWithTag:101];
        if(![v isEqual:btn]) {
            [v setBackgroundColor:mColors[v.tag]];
            v.selected = NO;
            [label setTextColor:[UIColor whiteColor]];
        }else {
            [label setTextColor:[ChADesign baseColor]];
        }
    }
    [btn setBackgroundColor:[UIColor whiteColor]];
    btn.selected = YES;
    
    //update menu
    [self _updateMenu:btn.tag];
   // mMenuDrawer.hidden = YES;
    
     //mMenuDrawer.hidden = YES;
    
    /*UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"ChATabBarController"];
    tabBar.selectedViewController = [tabBar.viewControllers objectAtIndex:btn.tag];*/
    
   // [self.navigationController pushViewController:tabBar animated:YES];
}

-(void)_updateMenu:(NSUInteger)tag {
    switch (tag) {
        case 0:
            [mMenuDrawer setTitle:@"Dashboard"];
            [mMenuDrawer loadMenuItems:@[@{@"title" : @"Overview", @"icon" : @"ico_dashboard_overview", @"icon_selected" : @"ico_dashboard_overview_selected"},
                                  @{@"title" : @"Newsfeed", @"icon" : @"ico_dashboard_newsfeed", @"icon_selected" : @"ico_dashboard_newsfeed_selected"},
                                  @{@"title" : @"Manage Widgets", @"icon" : @"ico_dashboard_widgets", @"icon_selected" : @"ico_dashboard_widgets_selected"}
                                  ]];
            break;
        case 1:
            [mMenuDrawer setTitle:@"My Health"];
            [mMenuDrawer loadMenuItems:@[@{@"title" : @"Overview"},
                                         @{@"title" : @"Expenses"},
                                         @{@"title" : @"Medical Profile"},
                                         @{@"title" : @"Medical Records"},
                                         @{@"title" : @"Medications"},
                                         @{@"title" : @"Allergies"},
                                         @{@"title" : @"Family Health History"},
                                         @{@"title" : @"HMO/Health Insurance"},
                                         @{@"title" : @"Emergency Contacts"}
                                         ]];
            break;
        case 2:
            [mMenuDrawer setTitle:@"Doctors"];
            [mMenuDrawer loadMenuItems:@[@{@"title" : @"My Doctors"},
                                         @{@"title" : @"Appointments"},
                                         @{@"title" : @"Book a Doctor"},
                                         @{@"title" : @"Ask a Doctor"},
                                         @{@"title" : @"Following Doctors"}
                                         ]];
            break;
        case 3:
            [mMenuDrawer setTitle:@"Friends"];
            [mMenuDrawer loadMenuItems:@[@{@"title" : @"Social Timeline"},
                                         @{@"title" : @"My Photos"},
                                         @{@"title" : @"My Friends"},
                                         @{@"title" : @"My Groups"},
                                         @{@"title" : @"Messages"},
                                         @{@"title" : @"Chat"}
                                         ]];
            break;
        case 4:
            [mMenuDrawer setTitle:@"Profile"];
            [mMenuDrawer loadMenuItems:@[
                                         ]];
            break;
        default:
            [mMenuDrawer setTitle:@"Dashboard"];
            [mMenuDrawer loadMenuItems:@[@{@"title" : @"Overview"},
                                         @{@"title" : @"Newsfeed"},
                                         @{@"title" : @"Manage Widgets"},
                                         @{@"title" : @"Some"},
                                         @{@"title" : @"Some"}
                                         ]];
            break;
    }
}

-(void)_setupViews {
    mTitles = @[@"Dashboard", @"My Health", @"Doctors", @"Friends", @"Profile"];
    mColors = @[
                [ChADesign dashBoardBaseColor],
                [ChADesign myHealthBaseColor],
                [ChADesign doctorsBaseColor],
                [ChADesign friendsBaseColor],
                [ChADesign profileBaseColor]
                ];
    mButtonImageNames = @[@"ico_dashboard",
                      @"ico_my_health",
                      @"ico_doctor",
                      @"ico_friends",
                      @"ico_profile",
                      ];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [ChADesign baseColor]} forState:UIControlStateSelected];
   
   // [[UITabBar appearance] setBackgroundImage:[ChADesign getTabBarBackground]];
   // self.tabBar.backgroundColor = [UIColor colorWithPatternImage:[ChADesign getTabBarBackground]];
    

    CGSize size = self.view.frame.size;
    CGRect rect  = CGRectMake(0.0f, 0.0f, size.width/5.0f, 49.0f);
    UIView *uiview = nil;
    for(int i = 0; i < 5; i++) {
        rect.origin.x = i * size.width/5.0f;
        uiview = [[UIView alloc] initWithFrame:rect];
        if (i== 1) {
            uiview.backgroundColor = [UIColor colorWithRed:0.000 green:0.796 blue:0.835 alpha:1.000];
            [tabBar insertSubview:uiview atIndex:0];
        } else if (i== 2) {
            uiview.backgroundColor = [UIColor colorWithRed:0.000 green:0.733 blue:0.616 alpha:1.000];
            [tabBar insertSubview:uiview atIndex:0];
        }  else if (i== 3) {
            uiview.backgroundColor = [UIColor colorWithRed:1.000 green:0.769 blue:0.271 alpha:1.000];
            [tabBar insertSubview:uiview atIndex:0];
        }  else if (i== 4) {
            uiview.backgroundColor = [UIColor colorWithRed:1.000 green:0.447 blue:0.000 alpha:1.000];
            [tabBar insertSubview:uiview atIndex:0];
        }  else if (i== 5) {
            uiview.backgroundColor = [UIColor greenColor];
            [tabBar insertSubview:uiview atIndex:0];
        }
    }
    
    
   // UITabBar *tabBar = self.tabBar;
  //  tabBar.hidden = YES;
    //just add the buttons
    
   /* CGSize size = self.view.frame.size;
    mButtonContainers = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height - 49.0f, self.view.frame.size.width, 49.0f)];
    [self.view addSubview:mButtonContainers];
    CGRect rect  = CGRectMake(0.0f, 0.0f, size.width/5.0f, 49.0f);
    UIButton *btn = nil;
    for(int i = 0; i < 5; i++) {
        rect.origin.x = i * size.width/5.0f;
        btn = [[UIButton alloc] initWithFrame:rect];
        btn.tag = i;
        btn.backgroundColor = mColors[i];
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, -30, 0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-40, 0, 0, 0)];
        [btn setTitleColor:[ChADesign baseColor] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:mButtonImageNames[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed: [NSString stringWithFormat:@"%@_selected", mButtonImageNames[i]]] forState:UIControlStateSelected];
        [mButtonContainers addSubview:btn];
        //add the title label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 32.0f, rect.size.width, 20.0f)];
        [label setTextColor:[UIColor whiteColor]];
        label.tag = 101;
        [label setText:mTitles[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [ChADesign defaultFontWithSize:10.0f];
        [btn addSubview:label];
        [btn addTarget:self action:@selector(_changeTabs:) forControlEvents:UIControlEventTouchUpInside];
    }
    */
    
    mMenuDrawer = [[ChAMenuDrawer alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 190.0f, self.navigationBar.frame.size.height - 10.0f, 200.0f, 300.0f)];
    [self.view insertSubview:mMenuDrawer belowSubview:self.navigationBar];
    mMenuDrawer.hidden = YES;
}

#pragma mark -
#pragma mark ChANavigationBarDelegate
-(void)navigationBarSelectedMenu:(ChANavigationBar *)navigationBar hide:(BOOL)hide {
    //show the menu
  //  NSLog(@"%s", __func__);
    mMenuDrawer.hidden = hide;
}

@end
