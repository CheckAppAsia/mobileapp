//
//  ChAMenuDrawer.m
//  CheckApp
//
//  Created by John Q. Dometita on 7/29/14.
//  Copyright (c) 2014 John Q. Dometita. All rights reserved.
//

#import "ChAMenuDrawer.h"
#import "ChADesign.h"
#import "ChALoginViewController.h"
#import "OverviewViewController.h"
#import "ChANavigationBar.h"

@interface ChAMenuDrawer () <UINavigationControllerDelegate,UINavigationBarDelegate,ChANavigationBarDelegate> {
    UILabel *_titleLabel;
    UIButton *_helpButton;
    UIButton *_logoutButton;
    UIButton *_newsfeeds;
    UIButton *_overview;
    UIButton *_managewidgets;
    ChAMenuDrawer *mMenuDrawer;
}

@end
@implementation ChAMenuDrawer

@synthesize delegate = _delegate;

-(id)initWithFrame:(CGRect)frame {
    frame.size.width = 200.f;
    frame.size.height = 300.0f;
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [ChADesign menuBaseColor];
        [ChADesign applyRoundedCorners:self radius:5.0f];
        [self _setupViews];
    }
    return self;
}


-(void)_setupViews {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, self.frame.size.width, 40.0f)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"Title";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [ChADesign profileBaseColor];
        _titleLabel.font = [ChADesign defaultFontWithSize:27.0f];
        [self addSubview:_titleLabel];
    }
}

-(void)setTitle:(NSString *)title {
    if(_titleLabel != nil)
        [_titleLabel setText:title];
}

-(void)loadMenuItems:(NSArray *)items {
    
    //remove all views except the 3 important
    for(UIView *v in self.subviews) {
        if([v isEqual:_titleLabel] || [v isEqual:_helpButton] || [v isEqual:_logoutButton]) {
            
        }else {
            [v removeFromSuperview];
        }
    }
    CGFloat yPos = _titleLabel.frame.origin.y + _titleLabel.frame.size.height;
    CGFloat height = yPos;
    UIButton *btn = nil;
    
    int itag = 1;
    
    for(int i = 0; i < items.count; i++) {
        NSDictionary *item = items[i];
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, yPos, self.frame.size.width, 40.0f)];
        yPos += 39.0f;
       // NSLog(@"yPos %.2lf", yPos);
        
      
        
        
        [btn setTag:itag];
        
      
        [self addSubview:btn];
        [btn setTitle:item[@"title"] forState:UIControlStateNormal];
        NSString *icon = item[@"icon"];
        if(icon != nil) {
            [ChADesign applyBaseMenuItemDesign:btn withNormalImage:[UIImage imageNamed:icon] andSelected:[UIImage imageNamed:item[@"icon_selected"]]];
        }else {
            [ChADesign applyBaseMenuItemDesign:btn];
        }
        
         NSLog(@"title %@", btn.titleLabel.text);
        
        NSLog(@"%ld", (long)btn.tag);
        
        
        // buttons
        if ([_titleLabel.text isEqualToString:@"Dashboard"]) {
            
            
            if (btn.tag == 1) {
            [btn addTarget:self action:@selector(overviewbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 2) {
            [btn addTarget:self action:@selector(newfeedbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 3) {
            [btn addTarget:self action:@selector(widgetbutton:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        } else if ([_titleLabel.text isEqualToString:@"My Health"]) {
            if (btn.tag == 1) {
                [btn addTarget:self action:@selector(mhoverviewbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 2) {
                [btn addTarget:self action:@selector(expensesbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 3) {
                [btn addTarget:self action:@selector(medprofbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 4) {
                [btn addTarget:self action:@selector(medrecbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 5) {
                [btn addTarget:self action:@selector(medicationbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 6) {
                [btn addTarget:self action:@selector(allergiesbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 7) {
                [btn addTarget:self action:@selector(famhisbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 8) {
                [btn addTarget:self action:@selector(hmobutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 9) {
                [btn addTarget:self action:@selector(emergencybutton:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        } else if ([_titleLabel.text isEqualToString:@"Doctors"]) {
            if (btn.tag == 1) {
                [btn addTarget:self action:@selector(mydocbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 2) {
                [btn addTarget:self action:@selector(appoinmentbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 3) {
                [btn addTarget:self action:@selector(bookadocbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 4) {
                [btn addTarget:self action:@selector(askadocbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 5) {
                [btn addTarget:self action:@selector(followdocbutton:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        } else if ([_titleLabel.text isEqualToString:@"Friends"]) {
            if (btn.tag == 1) {
                [btn addTarget:self action:@selector(soctimebutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 2) {
                [btn addTarget:self action:@selector(myphotosbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 3) {
                [btn addTarget:self action:@selector(myfriendsbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 4) {
                [btn addTarget:self action:@selector(mygroupsbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 5) {
                [btn addTarget:self action:@selector(messagesbutton:) forControlEvents:UIControlEventTouchUpInside];
            } else if (btn.tag == 6) {
                [btn addTarget:self action:@selector(chatbutton:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        
        itag++;
    }
    height += yPos - 10.0f;
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
    
    
    //always add the help and login button
    if(_helpButton == nil) {
        _helpButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height, self.frame.size.width/2.0f, 40.0f)];
        [_helpButton setTitle:@"Help" forState:UIControlStateNormal];
        [ChADesign applyBaseMenuItemDesign:_helpButton withNormalImage:[UIImage imageNamed:@"ico_menu_help"] andSelected:[UIImage imageNamed:@"ico_menu_help_selected"]];
        [self addSubview:_helpButton];
        //[ChADesign applyBaseMenuItemDesign:_helpButton];
    }
    
    if(_logoutButton == nil) {
        _logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2.0f - 1.0f, yPos, self.frame.size.width/2.0f, 40.0f)];
        [_logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
        [ChADesign applyBaseMenuItemDesign:_logoutButton withNormalImage:[UIImage imageNamed:@"ico_menu_logout"] andSelected:[UIImage imageNamed:@"ico_menu_logout_selected"]];
        [self addSubview:_logoutButton];
       // [ChADesign applyBaseMenuItemDesign:_logoutButton];
    }
    
    frame = _helpButton.frame;
    frame.origin.y = yPos;
    _helpButton.frame = frame;
    
    frame = _logoutButton.frame;
    frame.origin.y = yPos;
    _logoutButton.frame = frame;
    
    //touch logout button
    
    [_logoutButton addTarget:self action:@selector(logoutButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_helpButton addTarget:self action:@selector(helpButton:) forControlEvents:UIControlEventTouchUpInside];
   
    
}

- (IBAction)overviewbutton:(id)sender {
    NSLog(@"title %@", @"overviewbutton");
    self.viewForBaselineLayout.hidden = YES;
    ChANavigationBar *navbar = [[ChANavigationBar alloc] init];
    navbar._menuButton.selected = NO;
    
    [self navigationBarSelectedMenu:self hide:YES];
 
    
  //  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
   /* OverviewViewController *viewController = [[OverviewViewController alloc] init];
     UIViewController *vc = self.window.rootViewController;
    [vc.navigationController pushViewController:viewController animated:YES];
    */
    
  /*  UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:@"NavDashOverview"];
    initViewController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    UIViewController *vc = self.window.rootViewController;
    [vc presentViewController:initViewController animated:YES completion:nil];*/
    
}

- (IBAction)newfeedbutton:(id)sender {
    NSLog(@"title %@", @"newfeedbutton");
    
   /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    
    UIViewController *initViewController = [storyboard instantiateViewControllerWithIdentifier:@"NavDashOverview"];
    initViewController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    UIViewController *vc = self.window.rootViewController;
    [vc presentViewController:initViewController animated:YES completion:nil];
    */
    
}

- (IBAction)widgetbutton:(id)sender {
    NSLog(@"title %@", @"widgetbutton");
    
}


// my health


- (IBAction)mhoverviewbutton:(id)sender {
    NSLog(@"title %@", @"mhoverviewbutton");
    
}

- (IBAction)expensesbutton:(id)sender {
    NSLog(@"title %@", @"expensesbutton");
    
}

- (IBAction)medprofbutton:(id)sender {
    NSLog(@"title %@", @"medprofbutton");
    
}


- (IBAction)medrecbutton:(id)sender {
    NSLog(@"title %@", @"medrecbutton");
    
}

- (IBAction)medicationbutton:(id)sender {
    NSLog(@"title %@", @"medicationbutton");
    
}

- (IBAction)allergiesbutton:(id)sender {
    NSLog(@"title %@", @"allergiesbutton");
    
}

- (IBAction)famhisbutton:(id)sender {
    NSLog(@"title %@", @"famhisbutton");
    
}

- (IBAction)hmobutton:(id)sender {
    NSLog(@"title %@", @"hmobutton");
    
}

- (IBAction)emergencybutton:(id)sender {
    NSLog(@"title %@", @"emergencybutton");
    
}


// my doctors


- (IBAction)mydocbutton:(id)sender {
    NSLog(@"title %@", @"mydocbutton");
    
}

- (IBAction)appoinmentbutton:(id)sender {
    NSLog(@"title %@", @"appoinmentbutton");
    
}

- (IBAction)bookadocbutton:(id)sender {
    NSLog(@"title %@", @"bookadocbutton");
    
}

- (IBAction)askadocbutton:(id)sender {
    NSLog(@"title %@", @"askadocbutton");
    
}

- (IBAction)followdocbutton:(id)sender {
    NSLog(@"title %@", @"followdocbutton");
}



// friends


- (IBAction)soctimebutton:(id)sender {
    NSLog(@"title %@", @"soctimebutton");
    
}

- (IBAction)myphotosbutton:(id)sender {
    NSLog(@"title %@", @"myphotosbutton");
    
}

- (IBAction)myfriendsbutton:(id)sender {
    NSLog(@"title %@", @"myfriendsbutton");
    
}

- (IBAction)mygroupsbutton:(id)sender {
    NSLog(@"title %@", @"mygroupsbutton");
    
}

- (IBAction)messagesbutton:(id)sender {
    NSLog(@"title %@", @"messagesbutton");
    
}

- (IBAction)chatbutton:(id)sender {
    NSLog(@"title %@", @"chatbutton");
    
}



- (IBAction)helpButton:(id)sender {
   
   NSLog(@"title %@", @"help");
}



- (IBAction)logoutButton:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   
    id viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    if(viewController != nil) {
        UIWindow *main = [[[UIApplication sharedApplication] delegate] window];
        main.rootViewController = viewController;
    }
    
    /*
    if([self.delegate respondsToSelector:@selector(logout:)])
    {
        //send the delegate function with the amount entered by the user
        //   NSLog(@"Backback %@",dicComments);
        NSLog(@"Success: post");
        [self.delegate logout:@"logout"];
        
    }*/
    
  [self logoutDB];
    
}

-(void)logoutDB {
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"checkApp.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:@"DROP TABLE IF EXISTS user"];
    [database close];
    
    
}

-(void)navigationBarSelectedMenu:(ChANavigationBar *)navigationBar hide:(BOOL)hide {
    //show the menu
     NSLog(@"%s", __func__);
    mMenuDrawer.hidden = hide;
}



@end
