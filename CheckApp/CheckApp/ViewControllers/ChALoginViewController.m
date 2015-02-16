//
//  CAViewController.m
//  CheckApp
//
//  Created by John Q. Dometita on 7/9/14.
//  Copyright (c) 2014 John Q. Dometita. All rights reserved.
//

#import "ChALoginViewController.h"
#import "TTTAttributedLabel.h"
#import "ChADesign.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "NSString+FormValidation.h"

@interface ChALoginViewController () <TTTAttributedLabelDelegate, UITextFieldDelegate> {
    UITextField *mActiveField;
}

@property (weak, nonatomic) IBOutlet UIImageView *mHeaderLogoView;
@property (weak, nonatomic) IBOutlet UIImageView *mHeaderImageView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *mLoginLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mMainContainer;
@property (weak, nonatomic) IBOutlet UITextField *mUserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *mLoginButton;

@end

@implementation ChALoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self _layoutViews];
    //add action to the custom label
    [self _setupLink];
    [self _registerForKeyboardNotifications];
    [self _applyDesigns];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)login:(id)sender {
    //TODO: Add validation
    /*id viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChATabBarController"];
    if(viewController != nil) {
        UIWindow *main = [[[UIApplication sharedApplication] delegate] window];
        main.rootViewController = viewController;
    }*/
    
    
    
    
    NSString *username  = [self.mUserNameTextField text];
    NSString *password  = [self.mPasswordTextField text];
    
    
    if ([username isEqualToString:@""]) {
        
        [self alertStatus:@"Please enter your Username" :@"Oops!"];
        
        
    } else if ([password isEqualToString:@""]) {
        
        [self alertStatus:@"Please enter your Password" :@"Oops!"];
        
    } else {
        
        
        NSDictionary *parameters = @{@"username":username,
                                     @"password":password};
        
        NSLog(@"parameters %@",parameters);
        
        
        
        [SVProgressHUD showWithStatus:@"Connecting..." maskType:SVProgressHUDMaskTypeGradient];
        
        [self connectAPI:APIBaseURL stringURL:@"access/login" jsonParams:parameters];
        
    }
    
    
    
}

#pragma mark - Private
-(void)_layoutViews {
    CGRect frame = self.view.frame;
    CGFloat yPos = (frame.size.height > 480.0f) ? 65.0f : 30.0f;
    frame = self.mHeaderLogoView.frame;
    frame.origin.y = yPos;
    self.mHeaderLogoView.frame = frame;
    
    yPos += self.mHeaderLogoView.frame.size.height + 8.0f;
    frame = self.mHeaderImageView.frame;
    frame.origin.y  = yPos;
    self.mHeaderImageView.frame = frame;
    
    yPos += self.mHeaderImageView.frame.size.height - 10.0f;
    frame = self.mLoginLabel.frame;
    frame.origin.y = yPos;
    self.mLoginLabel.frame = frame;
    
    yPos += self.mLoginLabel.frame.size.height + 8.0f;
    frame = self.mUserNameTextField.frame;
    frame.origin.y = yPos;
    self.mUserNameTextField.frame = frame;
    
    yPos += self.mUserNameTextField.frame.size.height + 8.0f;
    frame = self.mPasswordTextField.frame;
    frame.origin.y = yPos;
    self.mPasswordTextField.frame = frame;
    
    yPos += self.mPasswordTextField.frame.size.height + 8.0f;
    frame = self.mLoginButton.frame;
    frame.origin.y = yPos;
    self.mLoginButton.frame = frame;
}

-(void)_setupLink {
    self.mLoginLabel.delegate = self;
    NSString *text = self.mLoginLabel.text;
    NSString *linkText = @"Sign up";
    NSRange linkRange = [text rangeOfString:linkText];
    UIColor *linkColor = [UIColor colorWithRed:53.0f/255.0f green:123.0f/255.0f blue:185.0f/255 alpha:1];
    UIColor *linkBGColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
    
    self.mLoginLabel.lineHeightMultiple = 0.9f;
    self.mLoginLabel.linkAttributes = [NSDictionary dictionaryWithObject:(__bridge id)[linkColor CGColor]
                                                                  forKey:(NSString *)kCTForegroundColorAttributeName];
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:(__bridge id)[linkBGColor CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:5.0f] forKey:(NSString *)kTTTBackgroundCornerRadiusAttributeName];
    self.mLoginLabel.activeLinkAttributes = mutableActiveLinkAttributes;
    [self.mLoginLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:nil];
    [self.mLoginLabel addLinkToURL:[NSURL URLWithString:@"checkapp://signup"] withRange:linkRange];
}

-(void)_applyDesigns {
    [ChADesign applyDefaultTextField:self.mUserNameTextField];
    [ChADesign applyDefaultTextField:self.mPasswordTextField];
    [ChADesign applyDefaultButton:self.mLoginButton];
}

#pragma mark - Keyboard
// Call this method somewhere in your view controller setup code.
- (void)_registerForKeyboardNotifications{
    
    self.mMainContainer.contentSize = self.mMainContainer.frame.size;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    NSLog(@"Registered for notifications");
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)_keyboardWasShown:(NSNotification*)aNotification{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.mMainContainer.contentInset = contentInsets;
    self.mMainContainer.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect visibleRect = self.mMainContainer.frame;
    visibleRect.size.height -= kbSize.height;
    
    // Field origin -- Additional code not got from the Apple site
    CGPoint fieldOrigin = mActiveField.frame.origin;
    fieldOrigin.y += self.mMainContainer.frame.origin.y;
    
    if (!CGRectContainsPoint(visibleRect, fieldOrigin) ) {
       [self.mMainContainer scrollRectToVisible:mActiveField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)_keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mMainContainer.contentInset = contentInsets;
    self.mMainContainer.scrollIndicatorInsets = contentInsets;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    if([[url absoluteString] isEqualToString:@"checkapp://signup"]) {
        NSLog(@"checkapp://signup");
        UIViewController *signup = [self.storyboard instantiateViewControllerWithIdentifier:@"ChASignupViewController"];
        if(signup != nil)
            [self presentViewController:signup animated:YES completion:NULL];
        return;
    }
}



#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    mActiveField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s", __func__);
    if(self.mUserNameTextField.text.length == 0)
        [self.mUserNameTextField becomeFirstResponder];
    else if(self.mPasswordTextField.text.length == 0)
        [self.mPasswordTextField becomeFirstResponder];
    
    return YES;
}


- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}


-(void) connectAPI:(NSString *)baseURL stringURL:(NSString *)URLString jsonParams:(NSDictionary *) parameters {
    
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    
    // if JSON Response
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    // if HTTP Response
    // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        NSString *status = [responseObject objectForKey:@"status"];
        NSString *message = [responseObject objectForKey:@"message"];
        
        
        
        if ([status isEqualToString:@"true"]) {
            
            NSDictionary *data = [responseObject objectForKey:@"data"];
            [self insertDB:data];
            
           // [self alertStatus:@"Please check your email for varification" :@"Successful Registration."];
            
            UIViewController *initViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChATabBarController"];
            initViewController.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
            [self presentViewController:initViewController animated:YES completion:nil];
            
           
        } else {
            
            
            [self alertStatus:@"Please try again" :message];
            
        }
        
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
    }];
    
}



- (void) insertDB:(NSDictionary *)json {
    
    [self dropTable];
   
    
    NSString *userid      = [json objectForKey:@"user_id"];
   // NSString *title     = [json objectForKey:@"title"];
    NSString *username    = [json objectForKey:@"username"];
    NSString *email       = [json objectForKey:@"email"];
    NSString *first_name  = [json objectForKey:@"first_name"];
   // NSString *middle_name = [json objectForKey:@"middle_name"];
    NSString *last_name   = [json objectForKey:@"last_name"];
    NSString *gender      = [json objectForKey:@"gender"];
    NSString *type        = [json objectForKey:@"type"];
    NSString *profile_pic = [json objectForKey:@"profile_pic"];
    NSString *birthdate   = [json objectForKey:@"birthdate"];
    NSString *coord_lat   = [json objectForKey:@"coord_lat"];
    NSString *coord_lng   = [json objectForKey:@"coord_lng"];
    NSString *activity   = [json objectForKey:@"activity"];
    
    
    [self prepareDatabase];
    
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"checkApp.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:@"INSERT INTO user (userid, title, username, email, firstname, middlename, lastname, birthdate, gender, address, marital, ethnicity, race, religion, profilepic, type, activity, loc_city, loc_lat, loc_lang, loc_country, loc_zip, online_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [NSString stringWithFormat:@"%@", userid], [NSString stringWithFormat:@"%@",@"title"], [NSString stringWithFormat:@"%@", username], [NSString stringWithFormat:@"%@", email], [NSString stringWithFormat:@"%@", first_name],[NSString stringWithFormat:@"%@", @"middlename"],[NSString stringWithFormat:@"%@", last_name],[NSString stringWithFormat:@"%@", birthdate],[NSString stringWithFormat:@"%@", gender],[NSString stringWithFormat:@"%@", @"address"],[NSString stringWithFormat:@"%@", @"marital"],[NSString stringWithFormat:@"%@", @"ethnicity"], [NSString stringWithFormat:@"%@", @"race"], [NSString stringWithFormat:@"%@", @"religion"], [NSString stringWithFormat:@"%@", profile_pic], [NSString stringWithFormat:@"%@", type],[NSString stringWithFormat:@"%@", activity],[NSString stringWithFormat:@"%@", @"loc_city"],[NSString stringWithFormat:@"%@", coord_lat],[NSString stringWithFormat:@"%@", coord_lng],[NSString stringWithFormat:@"%@", @"country"],[NSString stringWithFormat:@"%@", @"zip"],[NSString stringWithFormat:@"%@", @"online"], nil];
    [database close];
    
    
}




- (void)prepareDatabase {
    // Get the documents directory
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"checkApp.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:@"CREATE TABLE IF NOT EXISTS user (userid varchar(20),title varchar(100),username varchar(100),email varchar(100),firstname varchar(100),middlename varchar(100),lastname varchar(100),birthdate date NOT NULL DEFAULT '0000-00-00',gender varchar(10),address varchar(200),marital varchar(50),ethnicity varchar(100),race varchar(100),religion varchar(100),profilepic varchar(200),type varchar(50),activity varchar(100),loc_city varchar(100),loc_lat varchar(100),loc_lang varchar(100),loc_country varchar(100),loc_zip varchar(100),online_status varchar(10))"];
    
    
    
    
    [database close];
    
    
    
}
- (void) dropTable {
    // Get the documents directory
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"checkApp.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:@"DROP TABLE IF EXISTS user"];
    [database close];
    
}

@end
