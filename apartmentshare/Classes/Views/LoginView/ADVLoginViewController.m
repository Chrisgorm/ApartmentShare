//
//  ADVLoginViewController.m
//  apartmentshare
//
//  Created by Tope Abayomi on 22/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVLoginViewController.h"
#import "ADVRegisterViewController.h"
#import "ADVApartmentListViewController.h"
#import "ADVTheme.h"
#import "AppDelegate.h"
#import "StackMob.h"
#import "User.h"
#import "UserVoice.h"

@implementation ADVLoginViewController

@synthesize userTextField = _userTextField, passwordTextField = _passwordTextField;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id <ADVTheme> theme = [ADVThemeManager sharedTheme];
    
    
    self.title = @"Login";
    
    self.loginTableView = [[UITableView alloc] initWithFrame:CGRectMake(16, 50, 294, 110) style:UITableViewStyleGrouped];
    
    [self.loginTableView setScrollEnabled:NO];
    [self.loginTableView setBackgroundView:nil];
    [self.view addSubview:self.loginTableView];
    
    [self.loginTableView setDataSource:self];
    [self.loginTableView setDelegate:self];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[theme viewBackground]]];
    
    
    [self.loginButton setBackgroundImage:[theme colorButtonBackgroundForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.loginButton setBackgroundImage:[theme colorButtonBackgroundForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    
    
    
    self.userTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 260, 50)];
    [self.userTextField setPlaceholder:@"Username"];
    [self.userTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 260, 50)];
    [self.passwordTextField setPlaceholder:@"Password"];
    [self.passwordTextField setSecureTextEntry:YES];
    [self.passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        
    self.userTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.userTextField = nil;
    self.passwordTextField = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell* cell = nil;
    
    if(indexPath.row == 0){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UsernameCell"];
        
        [cell addSubview:self.userTextField];
        
    }else {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PasswordCell"];
        
        [cell addSubview:self.passwordTextField];
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark IB Actions

//Show the hidden register view
- (IBAction)signUpPressed:(id)sender
{
    [self performSegueWithIdentifier:@"signup" sender:self];
}

//Login button pressed
- (IBAction)logInPressed:(id)sender
{
    [[SMClient defaultClient] loginWithUsername:self.userTextField.text password:self.passwordTextField.text onSuccess:^(NSDictionary *results) {
        
        NSLog(@"Logged in");
        
        // Save email for contacting owner
        [[NSUserDefaults standardUserDefaults] setObject:[results objectForKey:@"email"] forKey:@"ContactOwnerEmailKey"];
        
        [self performSegueWithIdentifier:@"list" sender:self];
        
    } onFailure:^(NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

- (IBAction)showHelp:(id)sender
{
    UVConfig *config = [UVConfig configWithSite:@"YOUR_USERVOICE_URL"
                                         andKey:@"YOUR_KEY"
                                      andSecret:@"YOUR_SECRET"];
    
    [UserVoice presentUserVoiceInterfaceForParentViewController:self andConfig:config];
}

@end
