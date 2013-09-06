//
//  ADVUploadImageViewController.m
//  apartmentshare
//
//  Created by Tope Abayomi on 22/01/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ADVUploadImageViewController.h"
#import "ADVTheme.h"
#import "DetailsCell.h"
#import "MBProgressHUD.h"


#import <QuartzCore/QuartzCore.h>

typedef enum {
    LocationDetail,
    PriceDetail,
    RoomDetail,
    TypeDetail
} DetailIndex ;

@interface ADVUploadImageViewController ()

@end

@implementation ADVUploadImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Upload Apartment";

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(uploadTapped:)];
    
    id <ADVTheme> theme = [ADVThemeManager sharedTheme];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[theme viewBackground]]];
    
    [self.imageContainer.layer setBorderWidth:5];
    [self.imageContainer.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.imageContainer.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.imageContainer.layer setShadowOffset:CGSizeMake(2, 2)];
    [self.imageContainer.layer setShadowOpacity:0.6];
    [self.imageContainer.layer setShadowRadius:5];
    
    [self.dataTableView setDataSource:self];
    [self.dataTableView setDelegate:self];
    
    self.locationTextField = [[UITextField alloc] initWithFrame:CGRectMake(130, 15, 175, 30)];
    [self.locationTextField setBackgroundColor:[UIColor clearColor]];
    [self.locationTextField setPlaceholder:@"The Cloister, London"];
    [self.locationTextField setBorderStyle:UITextBorderStyleNone];
    [self.locationTextField setReturnKeyType:UIReturnKeyDone];
    [self.locationTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(130, 15, 175, 30)];
    [self.priceTextField setBackgroundColor:[UIColor clearColor]];
    [self.priceTextField setPlaceholder:@"$1,500"];
    [self.priceTextField setBorderStyle:UITextBorderStyleNone];
    [self.priceTextField setReturnKeyType:UIReturnKeyDone];
    [self.priceTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.priceTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.roomsSlider = [[UISlider alloc] initWithFrame:CGRectMake(130, 15, 150, 30)];
    [self.roomsSlider setMaximumValue:7];
    [self.roomsSlider setMinimumValue:1];
    [self.roomsSlider setValue:2];
    [self.roomsSlider addTarget:self action:@selector(numberOfRoomsChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    self.roomsLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 12, 40, 30)];
    [self.roomsLabel setBackgroundColor:[UIColor clearColor]];
    [self.roomsLabel setTextColor:[UIColor darkGrayColor]];
    [self.roomsLabel setText:@"2"];
    

    self.apartmentTypeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"House", @"Flat" ,nil]];
    [self.apartmentTypeControl setFrame:CGRectMake(130, 15, 175, 44)];
    [self.apartmentTypeControl setSegmentedControlStyle:UISegmentedControlStylePlain];
    [self.apartmentTypeControl setSelectedSegmentIndex:0];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIImageView *imgBkg = [[UIImageView alloc] initWithImage:[[ADVThemeManager sharedTheme] tableSectionHeaderBackground]];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 300, 22)];
    lblTitle.text = @"Details";
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor colorWithRed:0.43f green:0.43f blue:0.43f alpha:1.00f];
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    
    [imgBkg addSubview:lblTitle];
    return imgBkg;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    DetailsCell *cell = (DetailsCell*)[tableView dequeueReusableCellWithIdentifier:@"DetailsCell"];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list-element.png"]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case LocationDetail:
            cell.detailLabel.text = @"Location";
            [cell addSubview:self.locationTextField];
            break;
        case PriceDetail:
            cell.detailLabel.text = @"Price/month";
            [cell addSubview:self.priceTextField];
            break;
        case RoomDetail:
            cell.detailLabel.text = @"Rooms";
            [cell addSubview:self.roomsSlider];
            [cell addSubview:self.roomsLabel];
            break;
        case TypeDetail:
            cell.detailLabel.text = @"Type";
            [cell addSubview:self.apartmentTypeControl];
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.row == TypeDetail) {
        
        return 65;
    }
    return 55.0f;
}



#pragma mark IB Actions
- (IBAction)numberOfRoomsChanged:(id)sender
{
    
    [self.roomsLabel setText:[NSString stringWithFormat:@"%.0f", self.roomsSlider.value]];
}
- (IBAction)selectPicturePressed:(id)sender
{

    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];


}

- (IBAction)uploadTapped:(id)sender
{
    [self.locationTextField resignFirstResponder];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading...";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self uploadDataToServer];
        
	});
    
}

- (void)uploadDataToServer
{
    
    
}

#pragma mark UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo 
{
    [picker dismissModalViewControllerAnimated:YES];
    
    //Place the image in the imageview
    self.uploadImageView.image = img;    
}

#define kOFFSET_FOR_KEYBOARD 80.0

- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    [sender resignFirstResponder];
    return YES;
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
}


-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    } else if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

- (void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    } else if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.priceTextField] || [sender isEqual:self.locationTextField]) {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0) {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp) {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    } else {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


@end
