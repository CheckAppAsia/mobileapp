//
//  ChAMenuDrawer.h
//  CheckApp
//
//  Created by John Q. Dometita on 7/29/14.
//  Copyright (c) 2014 John Q. Dometita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChANavigationBar.h"



@protocol buttondelegate <NSObject>

- (void)logout:(NSString*)data;

@end

@interface ChAMenuDrawer : UIView {
    id <buttondelegate> delegate;
}

@property (nonatomic, weak) id <buttondelegate> delegate;
@property (nonatomic, retain) ChANavigationBar *navigationBar;

/**
 * Set title for the menu
 * @param title. NSString. string to set as title
 */
-(void)setTitle:(NSString *)title;

/**
 * Load menu items
 * @param items. NSArray of NSDictionaries containing
 *             i.e. @{@"icon" : @"icon_name", @"title" : @"item_title", @"action" : @"item_selector"}
 */
-(void)loadMenuItems:(NSArray *)items;





@end
