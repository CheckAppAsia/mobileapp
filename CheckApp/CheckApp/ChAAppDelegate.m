//
//  CAAppDelegate.m
//  CheckApp
//
//  Created by John Q. Dometita on 7/9/14.
//  Copyright (c) 2014 John Q. Dometita. All rights reserved.
//

#import "ChAAppDelegate.h"
#import "AFNetworkActivityLogger.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"



@implementation ChAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:66.0f/255.0f green:181.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];
    
#ifdef DEBUG
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
#endif
    
    [self viewVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)viewVisible {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([[self checkuserLogin] isEqualToString:@"online"]) {
        
        UIViewController *cinitViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChATabBarController"];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = cinitViewController;
        
    } else {
        UIViewController *cinitViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = cinitViewController;
        
    }
    
}

-(NSString*) checkuserLogin {
    
    
    
    [self prepareDatabase];
    
    NSString *status = [[NSString alloc] init];
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"checkApp.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    FMResultSet *results = [database executeQuery:@"SELECT online_status FROM user"];
    
    if ([results next]) {
        status = [results stringForColumn:@"online_status"];
    }
    
    [database close];
    
    return status;
    
}

- (void)prepareDatabase {
    // Get the documents directory
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"checkApp.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:@"CREATE TABLE IF NOT EXISTS user (userid varchar(20),title varchar(100),username varchar(100),email varchar(100),firstname varchar(100),middlename varchar(100),lastname varchar(100),birthdate date NOT NULL DEFAULT '0000-00-00',gender varchar(10),address varchar(200),marital varchar(50),ethnicity varchar(100),race varchar(100),religion varchar(100),profilepic varchar(200),type varchar(50),activity varchar(100),loc_city varchar(100),loc_lat varchar(100),loc_lang varchar(100),loc_country varchar(100),loc_zip varchar(100),online_status varchar(10))"];
    
    NSLog(@"DB Path: %@",dbPath);
    
    [database close];
    
    
    
}
- (void) dropTable {
    // Get the documents directory
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"thumbDB.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:@"DROP TABLE IF EXISTS user"];
    [database close];
    
}

@end
