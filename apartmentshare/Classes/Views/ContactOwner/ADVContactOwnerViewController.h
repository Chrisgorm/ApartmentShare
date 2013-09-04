//
//  ADVContactOwnerViewController.h
//  apartmentshare
//
//  Created by Matt Vaznaian on 9/3/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADVContactOwnerViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *message;

@property (nonatomic, strong) NSString *apartmentOwner;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;


- (IBAction)cancelButton:(id)sender;
- (IBAction)sendButton:(id)sender;

@end
