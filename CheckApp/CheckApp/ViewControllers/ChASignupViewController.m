//
//  CASignupViewController.m
//  CheckApp
//
//  Created by John Q. Dometita on 7/13/14.
//  Copyright (c) 2014 John Q. Dometita. All rights reserved.
//

#import "ChASignupViewController.h"
#import "ChADesign.h"
#import "TTTAttributedLabel.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "NSString+FormValidation.h"


#define kFieldYear 0
#define kFieldCountry 1
#define kFieldAreaOfPractice 2
#define kFieldQualifyingDegree 3

@interface ChASignupViewController() <UITableViewDataSource,
                                        UITableViewDelegate,
                                        UITextFieldDelegate,
                                        TTTAttributedLabelDelegate,
                                        UIPickerViewDataSource,
                                        UIPickerViewDelegate
                                        >
{
    BOOL isDoctor;
    NSMutableDictionary *items;
    NSArray *mFieldItems;
    UITextField *mActiveField;
    NSUInteger mFieldIndex;
    NSArray *mCountryArray;
    NSArray *mDegreeArray;
    NSArray *mAreaOfPracticeArray;
}

@property (weak, nonatomic) IBOutlet UIButton *mMemberButton;
@property (weak, nonatomic) IBOutlet UIButton *mDoctorButton;
@property (weak, nonatomic) IBOutlet UITableView *mFieldsTableView;
@property (weak, nonatomic) IBOutlet UIView *mSection1;
@property (weak, nonatomic) IBOutlet UIView *mSection2;
@property (weak, nonatomic) IBOutlet UIScrollView *mFieldsContainer;
@property (weak, nonatomic) IBOutlet UITextField *mFirstNameField;
@property (weak, nonatomic) IBOutlet UITextField *mMiddleNameField;
@property (weak, nonatomic) IBOutlet UITextField *mLastNameField;
@property (weak, nonatomic) IBOutlet UITextField *mEmailField;
@property (weak, nonatomic) IBOutlet UITextField *mPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *mYearButton;
@property (weak, nonatomic) IBOutlet UIButton *mCountryButton;
@property (weak, nonatomic) IBOutlet UIButton *mAreaOfPracticeButton;
@property (weak, nonatomic) IBOutlet UIButton *mQualifyingButton;
@property (weak, nonatomic) IBOutlet UITextField *mSchoolField;
@property (weak, nonatomic) IBOutlet UITextField *mProfLicenseField;
@property (weak, nonatomic) IBOutlet UIButton *mSignupButton;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *mTermsLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *mPickerView;
@property (weak, nonatomic) IBOutlet UIButton *mFieldSelectButton;
@property (weak, nonatomic) IBOutlet UIImageView *mHippaView;
@property (weak, nonatomic) IBOutlet UIImageView *mNortonView;

@end

@implementation ChASignupViewController

-(IBAction)selectSignupMode:(UIButton *)sender {
    NSDictionary *links = nil;
    NSString *text = nil;
    if([sender isEqual:self.mMemberButton]) {
        isDoctor = NO;
        self.mDoctorButton.selected = NO;
        self.mMemberButton.selected = YES;
        links = @{@"Terms": @"checkapp://termsofservice", @"Privacy": @"checkapp://privacypolicy"};
        text = @"By signing up, I agree with the Terms\nand Privacy and I’m 16 years or over.";
    }else if([sender isEqual:self.mDoctorButton]) {
        isDoctor = YES;
        self.mDoctorButton.selected = YES;
        self.mMemberButton.selected = NO;
        links = @{@"Terms of Service": @"checkapp://termsofservice", @"Privacy Policy": @"checkapp://privacypolicy"};
        text = @"I agree with the Terms of Service\nand Privacy Policy";
    }
    
    [self _setupLink:text links:links];
    [self _setUpViews];
    [self.mFieldsTableView reloadData];
    if(mActiveField != nil) {
        [mActiveField resignFirstResponder];
    }
}

-(IBAction)signup:(id)sender {
    
    
    NSString *firstname  = [self.mFirstNameField text];
    NSString *middlename = [self.mMiddleNameField text];
    NSString *lastname   = [self.mLastNameField text];
    NSString *email      = [self.mEmailField text];
    NSString *password   = [self.mPasswordField text];
    
    
    if (isDoctor == NO) {
    
    
        if ([firstname isEqualToString:@""]) {
            [self alertStatus:@"Please enter your Firstname" :@"Oops!"];
        
        
        } else if ([middlename isEqualToString:@""]) {
            [self alertStatus:@"Please enter your Middle Name" :@"Oops!"];
        
        
        } else if ([lastname isEqualToString:@""]) {
            [self alertStatus:@"Please enter your Lastname" :@"Oops!"];
        
        
        } else if ([email isEqualToString:@""]) {
            [self alertStatus:@"Please enter your Name" :@"Oops!"];
        
        } else if ([password isEqualToString:@""]) {
            [self alertStatus:@"Please enter your Password" :@"Oops!"];
        
        } else {
            
            if (![firstname isValidName]) {
                
                [self alertStatus:@"Firstname is maximum of 50 characters only" :@"Please enter a valid Firstame"];
                
            } else if (![middlename isValidName]) {
                
                [self alertStatus:@"Middlename is maximum of 50 characters only" :@"Please enter a valid Middlename"];
            
            } else if (![lastname isValidName]) {
                
                [self alertStatus:@"Lastname is maximum of 50 characters only" :@"Please enter a valid Lastname"];
                
            } else if (![password isValidPassword]) {
                
                [self alertStatus:@"Please enter a valid password. Password must be 8 characters long." :@"Oops!"];
                
            }  else if (![email isValidEmail]) {
                
                [self alertStatus:@"Please enter a valid email" :@"Oops"];
            }
        
        
        }
        
        
        NSString *uname = [NSString stringWithFormat:@"%@%@",@"p",[self generateRandom]];
        
        NSDictionary *parameters = @{@"first_name":firstname,
                                     @"middle_name":middlename,
                                     @"last_name":lastname,
                                     @"password":password,
                                     @"email":email,
                                     @"username":uname,
                                     @"user_type":@"1"};
        
        NSLog(@"parameters %@",parameters);
        
        [SVProgressHUD showWithStatus:@"Connecting..." maskType:SVProgressHUDMaskTypeGradient];
        
        [self connectAPI:APIBaseURL stringURL:@"signup/" jsonParams:parameters];
        
    } else {
        
        
        
        NSString *school            = [self.mSchoolField text];
        NSString *license           = [self.mProfLicenseField text];
        NSString *yearbuttonName    = [self.mYearButton titleForState:UIControlStateNormal];
        NSString *countrybuttonName = [self.mCountryButton titleForState:UIControlStateNormal];
        NSString *praticebuttonName = [self.mAreaOfPracticeButton titleForState:UIControlStateNormal];
        NSString *qualifybuttonName = [self.mQualifyingButton titleForState:UIControlStateNormal];
        
        
        if ([firstname isEqualToString:@""]) {
            [self alertStatus:@"Please enter your Firstname" :@"Oops!"];
            
            
        } else if ([middlename isEqualToString:@""]) {
            [self alertStatus:@"Please enter your Middle Name" :@"Oops!"];
            
            
        } else if ([lastname isEqualToString:@""]) {
            [self alertStatus:@"Please enter your Lastname" :@"Oops!"];
            
            
        } else if ([email isEqualToString:@""]) {
            [self alertStatus:@"Please enter your Name" :@"Oops!"];
            
        } else if ([password isEqualToString:@""]) {
            [self alertStatus:@"Please enter your Password" :@"Oops!"];
            
        } else if ([school isEqualToString:@""]) {
            [self alertStatus:@"Please enter your Medical or Grad School" :@"Oops!"];
        
        } else if ([yearbuttonName isEqualToString:@"Year"]) {
            [self alertStatus:@"Please choose a year" :@"Oops!"];
            
        } else if ([praticebuttonName isEqualToString:@"Area of Practice"]) {
            [self alertStatus:@"Please choose your Area of Practice" :@"Oops!"];
            
        } else if ([qualifybuttonName isEqualToString:@"Qualifying Degree"]) {
            [self alertStatus:@"Please choose your Qualifying Degree" :@"Oops!"];
            
        } else if ([license isEqualToString:@""]) {
            [self alertStatus:@"Please enter your Professional License" :@"Oops!"];
            
        } else if ([countrybuttonName isEqualToString:@"Country"]) {
            [self alertStatus:@"Please choose your country" :@"Oops!"];
            
        
        } else {
            
            if (![firstname isValidName]) {
                
                [self alertStatus:@"Firstname is maximum of 50 characters only" :@"Please enter a valid Firstame"];
                
            } else if (![middlename isValidName]) {
                
                [self alertStatus:@"Middlename is maximum of 50 characters only" :@"Please enter a valid Middlename"];
                
            } else if (![lastname isValidName]) {
                
                [self alertStatus:@"Lastname is maximum of 50 characters only" :@"Please enter a valid Lastname"];
                
            } else if (![password isValidPassword]) {
                
                [self alertStatus:@"Please enter a valid password. Password must be 8 characters long." :@"Oops!"];
                
            }  else if (![email isValidEmail]) {
                
                [self alertStatus:@"Please enter a valid email" :@"Oops"];
            }
            
            
        }
        
        
        NSString *uname = [NSString stringWithFormat:@"%@%@",@"d",[self generateRandom]];
       
        NSDictionary *parameters = @{@"first_name":firstname,
                                     @"last_name":lastname,
                                     @"middle_name":middlename,
                                     @"password":password,
                                     @"email":email,
                                     @"username":uname,
                                     @"user_type":@"2"};
        
        NSLog(@"parameters %@",parameters);
        
        
        
        [SVProgressHUD showWithStatus:@"Connecting..." maskType:SVProgressHUDMaskTypeGradient];
        
        [self connectAPI:APIBaseURL stringURL:@"signup" jsonParams:parameters];
        
    }
    
    
    
}


-(IBAction)cancelSignup:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)showYearSelector:(id)sender {
    mFieldIndex = kFieldYear;
    if(mActiveField != nil)
        [mActiveField resignFirstResponder];
    [self _showPickerView];
}

-(IBAction)showCountrySelector:(id)sender {
    mFieldIndex = kFieldCountry;
    if(mActiveField != nil)
        [mActiveField resignFirstResponder];
    [self _showPickerView];
}

-(IBAction)showDegreeSelector:(id)sender {
    mFieldIndex = kFieldQualifyingDegree;
    if(mActiveField != nil)
        [mActiveField resignFirstResponder];
    [self _showPickerView];
}

-(IBAction)showAreaOfPracticeSelector:(id)sender {
    mFieldIndex = kFieldAreaOfPractice;
    if(mActiveField != nil)
        [mActiveField resignFirstResponder];
    [self _showPickerView];
}

-(IBAction)selectFieldValue:(id)sender {
    [self _hidePickerView];
    
    NSUInteger selectedIndex = [self.mPickerView selectedRowInComponent:0];
    
    switch (mFieldIndex) {
        case kFieldAreaOfPractice:
            [self.mAreaOfPracticeButton setTitle:mAreaOfPracticeArray[selectedIndex] forState:UIControlStateNormal];
            break;
        case kFieldCountry:
            [self.mCountryButton setTitle:mCountryArray[selectedIndex] forState:UIControlStateNormal];
            break;
        case kFieldQualifyingDegree:
            [self.mQualifyingButton setTitle:mDegreeArray[selectedIndex] forState:UIControlStateNormal];
            break;
        case kFieldYear:
            [self.mYearButton setTitle:[NSString stringWithFormat:@"%lu", 1900 + selectedIndex] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    mFieldItems = @[@"first_name", @"middle_name", @"last_name", @"email", @"password"];
    mCountryArray = @[@"Malaysia", @"Philippines", @"Singapore"];
    mDegreeArray = @[@"Degree 1", @"Degree 2", @"Degree 3"];
    mAreaOfPracticeArray = @[@"Area 1", @"Area 2", @"Area 3", @"Area 3"];
    [self _registerForKeyboardNotifications];
    [self _applyDesign];
    [self _setUpViews];
    [self selectSignupMode:self.mMemberButton];
    
    
    
    NSLog(@"rendom %@",[self generateRandom]);
    
    mFieldIndex = kFieldYear;
}

-(void)_showPickerView {
    self.mPickerView.hidden = NO;
    CGRect frame = self.mPickerView.frame;
    frame.origin.x = 0.0f;
    frame.origin.y = self.view.frame.size.height - frame.size.height - self.mFieldSelectButton.frame.size.height;
    self.mPickerView.frame = frame;
    
    frame = self.mFieldSelectButton.frame;
    frame.origin.y = self.view.frame.size.height - self.mFieldSelectButton.frame.size.height;
    self.mFieldSelectButton.frame = frame;
    
    [self _adjustFieldContainer:self.mPickerView.frame.size.height];
    //put the pickerview on top
    [self.view insertSubview:self.mPickerView aboveSubview:self.mFieldsContainer];
    [self.view insertSubview:self.mFieldSelectButton aboveSubview:self.mFieldsContainer];
    
    [self.mPickerView reloadAllComponents];
    self.mFieldSelectButton.hidden = NO;
}


-(void)_hidePickerView {
    [self _adjustFieldContainer:0.0f];
    self.mPickerView.hidden = YES;
    self.mFieldSelectButton.hidden = YES;
}

-(void)_setUpViews {
    //set up the content size of the container
    [self.mFieldsContainer setContentSize:CGSizeMake(320.0f, 440.0f)];
    [self _hidePickerView];
    
    CGRect frame;
    if(isDoctor) {
        self.mNortonView.hidden = YES;
        self.mHippaView.hidden = YES;
        
        self.mSection2.hidden = NO;
        
        //move the signup button below the second section
        frame = self.mSignupButton.frame;
        frame.origin.y = self.mSection2.frame.size.height + self.mSection2.frame.origin.y + 10.0f;
        self.mSignupButton.frame = frame;
        
        //move the terms below the signup button
        frame = self.mTermsLabel.frame;
        frame.origin.y = self.mSignupButton.frame.origin.y + self.mSignupButton.frame.size.height + 0.0f;
        self.mTermsLabel.frame = frame;
        
    }else {
        self.mNortonView.hidden = NO;
        self.mHippaView.hidden = NO;
        
        //hide the second section
        self.mSection2.hidden = YES;
        
        //move the signup button below the first section
        frame = self.mSignupButton.frame;
        frame.origin.y = self.mSection1.frame.size.height + self.mSection1.frame.origin.y + 30.0f;
        self.mSignupButton.frame = frame;
        
        //move the terms below the signup button
        frame = self.mTermsLabel.frame;
        frame.origin.y = self.mSignupButton.frame.origin.y + self.mSignupButton.frame.size.height + 20.0f;
        self.mTermsLabel.frame = frame;
        
        //move the logos below the terms
        frame = self.mNortonView.frame;
        frame.origin.y = self.mTermsLabel.frame.size.height + self.mTermsLabel.frame.origin.y + 15.0f;
        self.mNortonView.frame = frame;
        
        frame = self.mHippaView.frame;
        frame.origin.y = self.mTermsLabel.frame.size.height + self.mTermsLabel.frame.origin.y + 15.0f;
        self.mHippaView.frame = frame;
        
    }
    
    self.mTermsLabel.delegate = self;
    self.mCountryButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5.0f, 0.0f, 5.0f);
    self.mYearButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5.0f, 0.0f, 5.0f);
    self.mQualifyingButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15.0f, 0.0f, 5.0f);
    self.mAreaOfPracticeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15.0f, 0.0f, 5.0f);
}

-(void)_setupLink:(NSString *)text links:(NSDictionary *)links {
    UIColor *linkColor = [UIColor colorWithRed:53.0f/255.0f green:123.0f/255.0f blue:185.0f/255 alpha:1];
    UIColor *linkBGColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
    self.mTermsLabel.textColor = [UIColor darkGrayColor];
    self.mTermsLabel.lineHeightMultiple = 0.9f;
    self.mTermsLabel.linkAttributes = [NSDictionary dictionaryWithObject:(__bridge id)[linkColor CGColor]
                                                                  forKey:(NSString *)kCTForegroundColorAttributeName];
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:(__bridge id)[linkBGColor CGColor] forKey:(NSString *)kTTTBackgroundFillColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:5.0f] forKey:(NSString *)kTTTBackgroundCornerRadiusAttributeName];
    self.mTermsLabel.activeLinkAttributes = mutableActiveLinkAttributes;
    [self.mTermsLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:nil];
    
    for(NSString *linkText in links.allKeys){
        NSRange linkRange = [text rangeOfString:linkText];
        [self.mTermsLabel addLinkToURL:[NSURL URLWithString:links[linkText]] withRange:linkRange];
    }
}


-(void)_applyDesign {
    [self.mFieldsTableView setContentInset:UIEdgeInsetsMake(-15, 0, 0, 0)];
    [self.mFieldsTableView setBackgroundColor:[UIColor whiteColor]];
    [ChADesign applyRoundedCorners:self.mSection1 radius:8.0f];
    [ChADesign applyRoundedCorners:self.mSection2 radius:8.0f];
    self.mSection1.clipsToBounds = YES;
    self.mSection2.clipsToBounds = YES;
    
    [ChADesign applyDefaultTextField:self.mFirstNameField withBorders:YES radius:0.0f];
    [ChADesign applyDefaultTextField:self.mMiddleNameField withBorders:YES radius:0.0f];
    [ChADesign applyDefaultTextField:self.mLastNameField withBorders:YES radius:0.0f];
    [ChADesign applyDefaultTextField:self.mEmailField withBorders:YES radius:0.0f];
    [ChADesign applyDefaultTextField:self.mPasswordField withBorders:YES radius:0.0f];
    
    [ChADesign applyDefaultTextField:self.mSchoolField withBorders:YES radius:0.0f];
    [ChADesign applyDefaultTextField:self.mProfLicenseField withBorders:YES radius:0.0f];
    self.mAreaOfPracticeButton.backgroundColor = [UIColor whiteColor];
    self.mQualifyingButton.backgroundColor = [UIColor whiteColor];
    self.mYearButton.backgroundColor = [ChADesign baseColor];
    self.mCountryButton.backgroundColor = [ChADesign baseColor];
    [self.mYearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.mCountryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.mAreaOfPracticeButton setTitleColor:[ChADesign baseColor] forState:UIControlStateNormal];
    [self.mQualifyingButton setTitleColor:[ChADesign baseColor]  forState:UIControlStateNormal];
    
    [ChADesign applyRoundedCorners:self.mAreaOfPracticeButton radius:0.0f];
    [ChADesign applyDefaultButton:self.mSignupButton];
    [self.mPickerView setBackgroundColor:[ChADesign baseColor]];
}

#pragma mark -
#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (isDoctor) ? 2 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? 5 :4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if(indexPath.section == 0) {
        UITextField *texfField = (UITextField *)[cell.contentView viewWithTag:10];
        [ChADesign applyDefaultTextField:texfField withBorders:NO];
        if(texfField != nil) {
            NSDictionary *item = [items objectForKey:[mFieldItems objectAtIndex:indexPath.row]];
            [texfField setPlaceholder:item[@"placeholder"]];
        }
    }else {
        
    }
    
    return cell;
}

#pragma mark -
#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.mFieldsTableView) {    // self.tableview
            CGFloat cornerRadius = 10.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 5, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            layer.strokeColor = [ChADesign baseColor].CGColor;
            
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+5, bounds.size.height-lineHeight, bounds.size.width-5, lineHeight);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}

-(void)_adjustFieldContainer:(CGFloat)height {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, height, 0.0);
    self.mFieldsContainer.contentInset = contentInsets;
    self.mFieldsContainer.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Keyboard
// Call this method somewhere in your view controller setup code.
- (void)_registerForKeyboardNotifications{
    
    self.mFieldsContainer.contentSize = self.mFieldsContainer.frame.size;
    
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
    
    [self _adjustFieldContainer:kbSize.height];
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect visibleRect = self.mFieldsTableView.frame;
    visibleRect.size.height -= kbSize.height;
    
    
    // Field origin -- Additional code not got from the Apple site
    CGPoint fieldOrigin = mActiveField.frame.origin;
    fieldOrigin.y += self.mFieldsContainer.frame.origin.y;
    
    if (!CGRectContainsPoint(visibleRect, fieldOrigin) ) {
        [self.mFieldsContainer scrollRectToVisible:mActiveField.frame animated:YES];
    }
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)_keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.mFieldsContainer.contentInset = contentInsets;
    self.mFieldsContainer.scrollIndicatorInsets = contentInsets;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    mActiveField = textField;
    //hide picker view
    [self _hidePickerView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s", __func__);
    if(self.mFirstNameField.text.length == 0)
        [self.mFirstNameField becomeFirstResponder];
    else if(self.mMiddleNameField.text.length == 0)
        [self.mMiddleNameField becomeFirstResponder];
    else if(self.mLastNameField.text.length == 0)
        [self.mLastNameField becomeFirstResponder];
    else if(self.mEmailField.text.length == 0)
        [self.mEmailField becomeFirstResponder];
    else if(self.mPasswordField.text.length == 0)
        [self.mPasswordField becomeFirstResponder];
    
    return YES;
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    if([[url absoluteString] isEqualToString:@"checkapp://termsofservice"]) {
        NSLog(@"checkapp://termsofservice");
        return;
    }else if([[url absoluteString] isEqualToString:@"checkapp://privacypolicy"]) {
        NSLog(@"checkapp://privacypolicy");
        return;
    }
    
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (mFieldIndex) {
        case kFieldYear:
            return 100;
        case kFieldAreaOfPractice:
            return mAreaOfPracticeArray.count;
        case kFieldCountry:
            return mCountryArray.count;
        case kFieldQualifyingDegree:
            return mDegreeArray.count;
        default:
            break;
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (mFieldIndex) {
        case kFieldYear:
            return [NSString stringWithFormat:@"%ld", 1900 + row];
        case kFieldAreaOfPractice:
            return mAreaOfPracticeArray[row];
        case kFieldCountry:
            return mCountryArray[row];
        case kFieldQualifyingDegree:
            return mDegreeArray[row];
        default:
            break;
    }
    
    return @"";
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
            [self alertStatus:@"Please check your email for varification" :@"Successful Registration."];
            
            UIViewController *initViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
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

- (NSString*)generateRandom
{
   // static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY";
    static NSString *digits = @"0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:5];
    for (NSUInteger i = 0; i < 3; i++) {
        uint32_t r;
        
        // Append 2 random letters:
       /* r = arc4random_uniform((uint32_t)[letters length]);
        [s appendFormat:@"%C", [letters characterAtIndex:r]];
        r = arc4random_uniform((uint32_t)[letters length]);
        [s appendFormat:@"%C", [letters characterAtIndex:r]];
        */
        // Append 2 random digits:
        r = arc4random_uniform((uint32_t)[digits length]);
        [s appendFormat:@"%C", [digits characterAtIndex:r]];
        r = arc4random_uniform((uint32_t)[digits length]);
        [s appendFormat:@"%C", [digits characterAtIndex:r]];
        
    }
    NSLog(@"s-->%@",s);
    return s;
}


@end
