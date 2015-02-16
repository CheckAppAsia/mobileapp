//
//  NSString+FormValidation.m
//  SimpleForm
//
//  Created by Blake on 2/15/14.
//  Copyright (c) 2014 BlakeAnderson. All rights reserved.
//

#import "NSString+FormValidation.h"

@implementation NSString (FormValidation)

- (BOOL)isValidEmail {
	NSString *regex = @"[^@]+@[A-Za-z0-9.-]+\\.[A-Za-z]+";
	NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [emailPredicate evaluateWithObject:self];
}

- (BOOL)isValidPassword {
	return (self.length >= 8);
}

- (BOOL)isValidName {
	return (self.length >= 1 && self.length<=50) ;
}


- (BOOL)isValidUsername {
	return (self.length >= 5);
}

-(BOOL) validUsername {
    NSString *regex = @"[A-Za-z0-9^]*";
	NSPredicate *username = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [username evaluateWithObject:self];
}

@end
