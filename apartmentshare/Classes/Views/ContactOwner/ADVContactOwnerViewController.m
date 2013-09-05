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
    
    NSString *senderEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"ContactOwnerEmailKey"];
    
    SMCustomCodeRequest *request = [[SMCustomCodeRequest alloc]
                                    initPostRequestWithMethod:(NSString *)@"sendgrid/email"
                                    body:(NSString *) nil];
    
    NSArray *usernames = [[NSArray alloc]
                          initWithObjects:self.apartmentOwner, nil];
    
    //convert object to data
    NSDictionary *dic = [[NSDictionary alloc]
                         initWithObjectsAndKeys:
                         usernames, @"usernames",
                         @"Inquiry On Apartment", @"subject",
                         self.message.text, @"html",
                         senderEmail, @"from",
                         nil];
    
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization
                        dataWithJSONObject:dic
                        options:0 error:&error];
    
    [request setRequestBody:[[NSString alloc]
                             initWithData:jsonData
                             encoding:NSUTF8StringEncoding]];
    
    [[[SMClient defaultClient] dataStore] performCustomCodeRequest:request onSuccess:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Email sent!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [successAlertView show];
     } onFailure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"Error: %@", [error localizedDescription]);
     }];
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
