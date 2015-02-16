//
//  NewsFeedsViewController.h
//  CheckApp
//
//  Created by Bon Ryan Benaojan on 2/8/15.
//  Copyright (c) 2015 Bon Ryan M. Benaojan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedsViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet NSMutableArray *newsfeeds;
@property (assign, nonatomic) int page;

@end
