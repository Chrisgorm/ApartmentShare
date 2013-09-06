//
//  ADVContactOwnerViewController.m
//  apartmentshare
//
//  Created by StackMob, Inc. on 9/3/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVContactOwnerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "StackMob.h"
#import "ADVTheme.h"
#import "MBProgressHUD.h"

@implementation ADVContactOwnerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.message.layer setBorderWidth:1.0];
    self.title = @"Contact Owner";
    
    id <ADVTheme> theme = [ADVThemeManager sharedTheme];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[theme viewBackground]]];
    
    [self.cancelButton setBackgroundImage:[theme colorButtonBackgroundForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[theme colorButtonBackgroundForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    
    [self.sendButton setBackgroundImage:[theme colorButtonBackgroundForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.sendButton setBackgroundImage:[theme colorButtonBackgroundForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    
	// Do any additional setup after loading the view.
}

- (IBAction)cancelButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendButton:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Sending...";
    
   
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.message isFirstResponder] && [touch view] != self.message) {
        [self.message resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

@end
