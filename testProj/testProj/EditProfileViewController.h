//
//  EditProfileViewController.h
//  HarrikeniOS
//
//  Created by Btrac on 10/20/15.
//  Copyright © 2015 Harriken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SWRevealViewController.h"

@interface EditProfileViewController : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDelegate>
{
    
    AppDelegate *appDelegate;
    UIView* MenuButtonView;
    UIButton* MenuButton;

    UIDatePicker *myPicker;
    IBOutlet UIButton *male;
    IBOutlet UIButton *female;
    IBOutlet UIButton *dob_btn;
    UIActionSheet *pickerViewPopup;
    UIButton *popupbutton;
    UIImagePickerController *picker;
    UIImage *img;
    IBOutlet UIImageView *profImgVw;
    IBOutlet UIButton *city_btn;
    IBOutlet UIButton *prof_btn;
    UITextField *other_fld;
    UIActionSheet *popupcity;
    IBOutlet UIScrollView *edit_scroll;
    IBOutlet UIImageView *frame;
    IBOutlet UITextField *name_fld;
    IBOutlet UITextField *mobile_fld;
    NSString *gender_str;
    int gender;

}
- (IBAction)select_prof:(id)sender;

- (IBAction)select_city:(id)sender;
- (IBAction)takephoto:(id)sender ;
- (IBAction)dob_action:(id)sender;
- (IBAction)gender_select:(id)sender;
-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;
- (IBAction)save_action:(id)sender;

@end
