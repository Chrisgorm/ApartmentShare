//
//  ADVApartmentListViewController.m
//  apartmentshare
//
//  Created by Tope Abayomi on 22/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//


#import "ADVApartmentListViewController.h"
#import "ADVUploadImageViewController.h"
#import "ADVLoginViewController.h"
#import "ADVDetailViewController.h"
#import "StackMob.h"
#import "ApartmentCell.h"
#import "Apartment.h"
#import "FTWCache.h"
#import "ADVTheme.h"
#import "NSString+MD5.h"
#import "MBProgressHUD.h"

@interface ADVApartmentListViewController ()

@property (nonatomic, retain) NSArray *apartments;
@property (nonatomic, retain) NSMutableDictionary *apartmentImages;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;


- (void)getAllApartments;

@end

@implementation ADVApartmentListViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Apartments";

    id <ADVTheme> theme = [ADVThemeManager sharedTheme];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[theme viewBackground]]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[self getLogText] style:UIBarButtonItemStylePlain target:self action:@selector(loginLogoutPressed:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadPressed:)];
    
    self.managedObjectContext = [[[SMClient defaultClient] coreDataStore] contextForCurrentThread];

    [self.apartmentTableView setDelegate:self];
    [self.apartmentTableView setDataSource:self];
    
    self.apartmentImages = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveSyncDidFinishNotification:) name:@"FinishedSync" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem.title = [self getLogText];
    
    [self getAllApartments];
        
    NSLog(@"got all apartments");
   
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FinishedSync" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.apartments count];
}

- (void)didReceiveSyncDidFinishNotification:(NSNotification *)notification
{
    [self getAllApartments];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ApartmentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ApartmentCell" forIndexPath:indexPath];
    
    Apartment *apartment = [self.apartments objectAtIndex:indexPath.row];
    
    NSNumber* roomCount = [apartment valueForKey:@"roomCount"];
    NSString* roomCountText = [NSString stringWithFormat:@"%d Bed", [roomCount intValue]];
    
    NSNumber* price = [apartment valueForKey:@"price"];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *priceString = [numberFormatter stringFromNumber:price];
    
    [cell.locationLabel setText:[apartment valueForKey:@"location"]];
    [cell.priceLabel setText:priceString];
    [cell.roomsLabel setText:roomCountText];
    [cell.apartmentTypeLabel setText:[apartment valueForKey:@"apartmentType"]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSString *picString = [apartment valueForKey:@"photo"];
    
    if ([SMBinaryDataConversion stringContainsURL:picString]) {
        NSURL* imageURL = [NSURL URLWithString:picString];
        
        NSString *key = [imageURL.absoluteString MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            cell.apartmentImageView.image = image;
            
            [self.apartmentImages setObject:image forKey:indexPath];
            
        } else {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    ApartmentCell* c = (ApartmentCell*)[tableView cellForRowAtIndexPath:indexPath];
                    c.apartmentImageView.image = image;
                    
                    [self.apartmentImages setObject:image forKey:indexPath];
                });
            });
        }
    } else {
        UIImage *image = [UIImage imageWithData:[SMBinaryDataConversion dataForString:picString]];
        cell.apartmentImageView.image = image;
        [self.apartmentImages setObject:image forKey:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self performSegueWithIdentifier:@"detail" sender:self];
}

#pragma mark Receive Wall Objects


- (void)getAllApartments
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Apartment"];
    [self.managedObjectContext executeFetchRequest:fetch onSuccess:^(NSArray *results) {
        
        self.apartments = results;
        [self.apartmentTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } onFailure:^(NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

#pragma mark IB Actions
- (IBAction)uploadPressed:(id)sender
{
    if([[SMClient defaultClient] isLoggedIn]){
        
        [self performSegueWithIdentifier:@"upload" sender:self];
    }
    else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Please Log In" message:@"You need to be logged in to upload details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }

}


- (IBAction)loginLogoutPressed:(id)sender
{
    if([[SMClient defaultClient] isLoggedIn]){
    
        [[SMClient defaultClient] logoutOnSuccess:^(NSDictionary *result) {
            NSLog(@"Success, you are logged out");
            
            self.navigationItem.leftBarButtonItem.title = [self getLogText];
            [self.navigationController popViewControllerAnimated:YES];
            
        } onFailure:^(NSError *error) {
            NSLog(@"Logout Fail: %@",error);
        }];
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (NSString*)getLogText
{
    
    NSString* logText = [[SMClient defaultClient] isLoggedIn] ? @"Log Out" : @"Log In";
    
    return logText;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"detail"]){
 
        ADVDetailViewController* detail = (ADVDetailViewController*)segue.destinationViewController;
        
        NSIndexPath* indexPath = [self.apartmentTableView indexPathForSelectedRow];
        Apartment *apartment = [self.apartments objectAtIndex:indexPath.row];
        
        detail.apartment = apartment;
        
        if([self.apartmentImages objectForKey:indexPath]){
            
            detail.apartmentImage = [self.apartmentImages objectForKey:indexPath];
        }

    }
}

@end
