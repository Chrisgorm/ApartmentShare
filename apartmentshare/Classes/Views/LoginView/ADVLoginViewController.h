//
//  ADVLoginViewController.h
//  apartmentshare
//
//  Created by Tope Abayomi on 22/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADVLoginViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *userTextField;

@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) IBOutlet UITableView *loginTableView;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, weak) IBOutlet UIButton *signupButton;

- (IBAction)signUpPressed:(id)sender;
- (IBAction)logInPressed:(id)sender;
- (IBAction)showHelp:(id)sender;

@end
