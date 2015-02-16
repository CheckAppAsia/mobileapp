//
//  NewsFeedsViewController.m
//  CheckApp
//
//  Created by Bon Ryan Benaojan on 2/8/15.
//  Copyright (c) 2015 Bon Ryan M. Benaojan. All rights reserved.
//

#import "NewsFeedsViewController.h"
#import "SVProgressHUD.h"
#import "SVPullToRefresh.h"

@interface NewsFeedsViewController () <UITableViewDataSource,UITableViewDelegate>

@end

static int initialPage = 1;

@implementation NewsFeedsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    __weak NewsFeedsViewController *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)insertRowAtTop {
    
    __weak NewsFeedsViewController *weakSelf = self;
    weakSelf.page = initialPage;
   // [weakSelf getDataFromServer:@"top"];
    
    // [self performSelectorOnMainThread:@selector(getDataFromServer:) withObject:nil waitUntilDone:NO];
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        
    });
    // [self.tableView endUpdates];
    [weakSelf.tableView.infiniteScrollingView stopAnimating];
}

- (void)insertRowAtBottom {
    
    
    __weak NewsFeedsViewController *weakSelf = self;
    
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
     //   [weakSelf getDataFromServer:@"bottom"];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierLang = @"Cell";
     UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifierLang];
   // NotificationsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifierLang];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
