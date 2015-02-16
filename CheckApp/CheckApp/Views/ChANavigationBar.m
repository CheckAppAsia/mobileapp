//
//  ChANavigationBar.m
//  CheckApp
//
//  Created by John Q. Dometita on 7/23/14.
//  Copyright (c) 2014 John Q. Dometita. All rights reserved.
//

#import "ChANavigationBar.h"
#import "ChADesign.h"

@interface ChANavigationBar () <UITextFieldDelegate> {
    UITextField *_searchTextField;
    UIButton *_chatButton;
    UIButton *_notificationButton;
    UIButton *_bookADoctorButton;
    //UIButton *_menuButton;
    UIButton *_cancelButton;
}

@end

@implementation ChANavigationBar
@synthesize _menuButton = _menuButton;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self _setupViews];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self _setupViews];
    }
    return self;
}

-(void)_setupViews {
    
    self.clipsToBounds = YES;
    [self setBackgroundColor:[ChADesign baseColor]];
    UIImage *image = [UIImage imageNamed:@"ico_navigation_home"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat xPos = 3.0f;
    CGFloat yPos = 20.0f;
    CGRect frame = CGRectMake(xPos, yPos , 40.0f, 40.0f);
    [btn setFrame:frame];
    [self addSubview:btn];
    [btn setImage:image forState:UIControlStateNormal];
    
    yPos += 7.0f;
    frame.origin.x += btn.frame.size.width;
    frame.origin.y = yPos;
    frame.size.width = 118.0f;
    frame.size.height = 30.0f;
    _searchTextField = [[UITextField alloc] initWithFrame:frame];
    [ChADesign applyRoundedCorners:_searchTextField radius:7.0f];
    _searchTextField.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    _searchTextField.textColor = [UIColor whiteColor];
    _searchTextField.font = [UIFont systemFontOfSize:12.0f];
    _searchTextField.placeholder = @"Find Doctors, Friends...";
    _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_searchTextField.placeholder attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    _searchTextField.delegate = self;
    
    //add the sidebar
    image = [UIImage imageNamed:@"ico_people"];
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, image.size.width + 10.0f, frame.size.height)];
    [leftView setImage:image];
    leftView.contentMode = UIViewContentModeCenter;
    [_searchTextField setLeftView:leftView];
    [_searchTextField setLeftViewMode:UITextFieldViewModeAlways];
    _searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self addSubview:_searchTextField];
    
    //setup the chat icon
    frame.size.width = 40.0f;
    frame.size.height = 40.0f;
    frame.origin.x += _searchTextField.frame.size.width;
    frame.origin.y = 20.0f;
    image = [UIImage imageNamed:@"ico_message"];
    _chatButton = [[UIButton alloc] initWithFrame:frame];
    [_chatButton setImage:image forState:UIControlStateNormal];
    [self addSubview:_chatButton];
    
    //setup the bell icon
    frame.size.width = 40.0f;
    frame.size.height = 40.0f;
    frame.origin.x += _chatButton.frame.size.width;
    frame.origin.y = 20.0f;
    image = [UIImage imageNamed:@"ico_bell"];
    _notificationButton = [[UIButton alloc] initWithFrame:frame];
    [_notificationButton setImage:image forState:UIControlStateNormal];
    [self addSubview:_notificationButton];
    
    //setup the book a doctor icon
    frame.size.width = 40.0f;
    frame.size.height = 40.0f;
    frame.origin.x += _notificationButton.frame.size.width;
    frame.origin.y = 20.0f;
    image = [UIImage imageNamed:@"ico_book_a_doctor"];
    _bookADoctorButton = [[UIButton alloc] initWithFrame:frame];
    [_bookADoctorButton setImage:image forState:UIControlStateNormal];
    [self addSubview:_bookADoctorButton];
    
    //setup the menu icon
    frame.size.width = 50.0f;
    frame.size.height = 55.0f;
    frame.origin.x += _bookADoctorButton.frame.size.width;
    frame.origin.y = 20.0f;
    image = [UIImage imageNamed:@"ico_menu"];
    _menuButton = [[UIButton alloc] initWithFrame:frame];
    [_menuButton setImage:image forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(_showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [ChADesign applyRoundedCorners:_menuButton radius:10.0f];
    [_menuButton setImageEdgeInsets:UIEdgeInsetsMake(-5.0f, -8.0f, 0, 0)];
    [self addSubview:_menuButton];
    
    //create the cancel button
    //setup the menu icon
    frame.size.width = 50.0f;
    frame.size.height = 30.0f;
    frame.origin.x = self.frame.size.width - 55.0f;
    frame.origin.y = 27.0f;
    image = [UIImage imageNamed:@"ico_menu"];
    _cancelButton = [[UIButton alloc] initWithFrame:frame];
    [ChADesign applyRoundedCorners:_cancelButton radius:7.0f];
    _cancelButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [self addSubview:_cancelButton];
    [_cancelButton addTarget:self action:@selector(_cancelSearchInput:) forControlEvents:UIControlEventTouchUpInside];

    [self _hideIcons:NO];
}

-(void)_hideIcons:(BOOL)hide {
    [_menuButton setHidden:hide];
    [_bookADoctorButton setHidden:hide];
    [_chatButton setHidden:hide];
    [_notificationButton setHidden:hide];
    [_cancelButton setHidden:!hide];
}

-(void)_expandTextField:(BOOL)expand {
    //get the additional width
    CGFloat additionalWidth = _menuButton.frame.size.width + _menuButton.imageEdgeInsets.left
    + _bookADoctorButton.frame.size.width
    + _chatButton.frame.size.width
    + _notificationButton.frame.size.width - 8.0f
    - _cancelButton.frame.size.width;
    
    CGRect frame = _searchTextField.frame;
    if(expand) {
        frame.size.width += additionalWidth;
    }else {
        frame.size.width -= additionalWidth;
    }
    
    //add animation
    [UIView animateWithDuration:0.3f animations:^{
        _searchTextField.frame = frame;
    }];
}

-(void)_cancelSearchInput:(id)sender {
    [_searchTextField resignFirstResponder];
    [_searchTextField setText:@""];
}

-(void)_showMenu:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    //toggle the color
    if(sender.selected) {
        [sender setBackgroundColor:[ChADesign menuBaseColor]];
    }else {
        [sender setBackgroundColor:[UIColor clearColor]];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(navigationBarSelectedMenu:hide:)]) {
        [self.delegate navigationBarSelectedMenu:self hide:!sender.selected];
    }
}

-(void)_hideMenu {
    _menuButton.selected = NO;
    [_menuButton setBackgroundColor:[UIColor clearColor]];
    if(self.delegate && [self.delegate respondsToSelector:@selector(navigationBarSelectedMenu:hide:)]) {
        [self.delegate navigationBarSelectedMenu:self hide:YES];
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //hide the icons
    [self _hideIcons:YES];
    
    //make the textfield expand
    [self _expandTextField:YES];
    
    //require to hide the menu
    [self _hideMenu];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self _expandTextField:NO];
    [self _hideIcons:NO];
}

@end
