//
//  EditProfileViewController.m
//  HarrikeniOS
//
//  Created by Btrac on 10/20/15.
//  Copyright © 2015 Harriken. All rights reserved.
//

#import "EditProfileViewController.h"
#import "CONSTANT.h"
#import "HttpReqController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "Reachability.h"
#import "SearchListViewController.h"


@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
     self.navigationController.navigationBarHidden=NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigation_gray"]
                                                  forBarMetrics:UIBarMetricsDefault];
    SWRevealViewController *revealViewController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealViewController tapGestureRecognizer];
    tap.delegate = self;
    
    [self.view addGestureRecognizer:tap];
    
    MenuButtonView = [[UIView alloc]initWithFrame:CGRectMake(-20, 0, 50, 40)];
    
    MenuButton=[UIButton buttonWithType:UIButtonTypeSystem];
    MenuButton.frame=MenuButtonView.frame;
    [MenuButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    MenuButton.tintColor=[UIColor whiteColor];
    
    [MenuButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [MenuButtonView addSubview:MenuButton];
    UIBarButtonItem *Menu=[[UIBarButtonItem alloc]initWithCustomView:MenuButtonView];
    //self.navigationItem.leftBarButtonItem=Menu;
    MenuButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 32)];
    
    
    MenuButton=[UIButton buttonWithType:UIButtonTypeSystem];
    MenuButton.frame=MenuButtonView.frame;
    [MenuButton setImage:[UIImage imageNamed:@"sidemenu"] forState:UIControlStateNormal];
    MenuButton.tintColor=[UIColor whiteColor];
    
    [MenuButton addTarget:revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [MenuButtonView addSubview:MenuButton];
    
    Menu=[[UIBarButtonItem alloc]initWithCustomView:MenuButtonView];
    self.navigationItem.rightBarButtonItem=Menu;
    
    
    profImgVw.layer.cornerRadius = profImgVw.frame.size.height /2;
    profImgVw.layer.masksToBounds = YES;

    edit_scroll.contentSize = CGSizeMake(self.view.frame.size.width, 900);
    gender=1;
    gender_str=@"male";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backAction:(id)sender
{
    NSLog(@"ENTER");
    [self.navigationController popViewControllerAnimated:TRUE];
    
}
-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)save_action:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
     NSData *imageData = UIImageJPEGRepresentation(profImgVw.image, 0.5);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[prefs valueForKey:@"userid"],@"userid",name_fld.text,@"fullname",mobile_fld.text,@"mobileno",[prefs valueForKey:@"useremail"],@"email",dob_btn.titleLabel.text,@"dofbirth",gender_str,@"sex",prof_btn.titleLabel.text,@"profession",city_btn.titleLabel.text,@"city",@"editcarprofile",@"tag",nil];
    appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"No Internet Connection"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSLog(@"There IS internet connection");
    [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    
    
    NSString *thisUrl = [NSString stringWithFormat:@"%@",BaseURLString];
    NSLog(@"url %@",thisUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestOperation *op = [manager POST:thisUrl parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      //do not put image inside parameters dictionary as I did, but append it!
                                      [formData appendPartWithFileData:imageData name:@"propic" fileName:@"propic.jpg" mimeType:@"image/jpeg" ];
                                     // [formData appendPartWithFormData:[profileInfo valueForKey:@"propic"] name:@"propic"];
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject)
                                  {
                                      
                                      NSLog(@"JSON: %@", responseObject);
                                      NSDictionary *jsondict=responseObject;
                                      [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                                      if (![jsondict isKindOfClass:[NSNull class]])
                                      {
                                          @try {
                                              if ([[jsondict valueForKey:@"success"]integerValue]==1)
                                              {
                                                  
                                                  
                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                                                  message:@"Update Successful"
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                                  [alert show];
                                                  
                                                  
                                              }
                                          }
                                          
                                          
                                          @catch (NSException *exception) {
                                              NSLog(@"Exception %@",exception);
                                          }
                                          @finally {
                                              
                                          }
                                      }
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      
                                     // NSLog(@"Error: %@", error);
                                      NSLog(@"%@", operation.responseString);
                                      [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                                      message:@"Connecting Error"
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"OK"
                                                                            otherButtonTitles:nil];
                                      [alert show];
                                      
                                      
                                  }];
    [op start];
    }

    
}
#pragma UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //textField.textColor= [UIColor colorWithRed:(225.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0];
    
    // myscroll.contentOffset=CGPointMake(0.0, 100.0);
    if (IPHONE_4)
    {
        if (textField.tag==0) {
            
            self.view.transform = CGAffineTransformMakeTranslation(0.0, -80.0);
        }
        
        else if (textField.tag==1) {
            self.view.transform = CGAffineTransformMakeTranslation(0.0, -150.0);
        }
        
        
        
    }
    else
    {
        
        if (textField.tag==0) {
            // signup_scroll.contentOffset=CGPointMake(0.0, 100.0);
            edit_scroll.contentOffset = CGPointMake(0.0, 0.0);
        }
        
        else if (textField.tag==1) {
            edit_scroll.contentOffset=CGPointMake(0.0, 170.0);
        }
        

    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    edit_scroll.contentOffset=CGPointMake(0.0, 0.0);
    self.view.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
    return YES;
}
- (IBAction)gender_select:(id)sender {
    UIButton *btn= sender;
    if (btn.tag==1) {
        [male setImage:[UIImage imageNamed:@"edit_select.png"] forState:UIControlStateNormal];
        [female setImage:[UIImage imageNamed:@"edit_disselect.png"] forState:UIControlStateNormal];
        gender=1;
        gender_str=@"male";
    }
    else if (btn.tag==2)
    {
        [female setImage:[UIImage imageNamed:@"edit_select.png"] forState:UIControlStateNormal];
        [male setImage:[UIImage imageNamed:@"edit_disselect.png"] forState:UIControlStateNormal];
        gender=2;
        gender_str=@"female";
    }
    
}

-(void)DobPickerset
{
    CGRect pickerFrame;
    if (appDelegate.window.frame.size.height==480) {
        pickerFrame = CGRectMake(0,118,0,0);
    }
    else
    {
        pickerFrame = CGRectMake((appDelegate.window.frame.size.width-320)/2,180,0,0);
    }
    
    myPicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    
    myPicker.backgroundColor= [UIColor whiteColor];
    myPicker.datePickerMode = UIDatePickerModeDate ;
    
    [myPicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    popupbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [popupbutton setBackgroundImage:[UIImage imageNamed:@"trans_bg.png"] forState:UIControlStateNormal];
    //popupbutton.alpha=0.9;
    
    
    popupbutton.frame = CGRectMake(0, 0, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height);
    UIScrollView *dob_scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height)];
    dob_scroll.contentSize = CGSizeMake(self.view.frame.size.width, 100);
    [appDelegate.window addSubview:popupbutton];
    [popupbutton addSubview:dob_scroll];
    
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (IPHONE_6) {
        cancel.frame = CGRectMake(25,appDelegate.window.frame.size.height-260, 150, 30);
    }
    else if (IPHONE_6Plus )
    {
        cancel.frame = CGRectMake(50,appDelegate.window.frame.size.height-320, 150, 30);
    }
    else if (appDelegate.window.frame.size.height==568 )
    {
        cancel.frame = CGRectMake(5,appDelegate.window.frame.size.height-160, 150, 30);
    }
    else if (appDelegate.window.frame.size.height==480)
    {
        cancel.frame = CGRectMake(5,appDelegate.window.frame.size.height-140, 150, 30);
    }
    cancel.backgroundColor =[UIColor whiteColor];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancel setTag:2];
    [cancel.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0]];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancel addTarget:self
               action:@selector(closePicker:)
     forControlEvents:UIControlEventTouchDown];
    
    UIButton *ok = [UIButton buttonWithType:UIButtonTypeCustom];
    //ok.frame = CGRectMake(200,appDelegate.window.frame.size.height-260, 150, 50);
    if (IPHONE_6) {
        ok.frame = CGRectMake(200,appDelegate.window.frame.size.height-260, 150, 30);
    }
    else if (IPHONE_6Plus )
    {
        ok.frame = CGRectMake(220,appDelegate.window.frame.size.height-320, 150, 30);
    }
    else if (appDelegate.window.frame.size.height==568  )
    {
        ok.frame = CGRectMake(165,appDelegate.window.frame.size.height-160, 150, 30);
    }
    else if (appDelegate.window.frame.size.height==480)
    {
        ok.frame = CGRectMake(165,appDelegate.window.frame.size.height-140, 150, 30);
    }
    ok.backgroundColor =[UIColor whiteColor];
    [ok setTitle:@"OK" forState:UIControlStateNormal];
    [ok.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:14.0]];
    [ok setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ok addTarget:self
           action:@selector(closePicker:)
 forControlEvents:UIControlEventTouchDown];
    
    [dob_scroll addSubview:myPicker];
    [dob_scroll addSubview:cancel];
    [dob_scroll addSubview:ok];
    [popupbutton setHidden:NO];
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.50];
    [popupbutton setFrame:CGRectMake(0,0,popupbutton.frame.size.width, popupbutton.frame.size.height)];
    
    [UIView commitAnimations];
    
}

- (void)pickerChanged:(id)sender
{
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"dd-MM-yyyy"]; // Date formater
    NSString *date = [dateformate stringFromDate:[myPicker date]]; // Convert date to string
    NSLog(@"date :%@",date);
    [dob_btn setTitle:date forState:UIControlStateNormal];
}

-(BOOL)closePicker:(id)sender
{
    UIButton *btn = sender;
    
    
    if (btn.tag==2) {
        [dob_btn setTitle:@"DD-MM-YYYY" forState:UIControlStateNormal];
        // dob_fld.text= nil;
    }
    
    // [pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.50];
    [UIView commitAnimations];
    
    
    
    [self performSelector:@selector(hideSplash) withObject:nil afterDelay:.30];
    
    return YES;
}
-(void)hideSplash
{
    [popupbutton setHidden:YES];
    
    
}
-(void) hideKeyboard
{
    [self.view endEditing:YES];
    edit_scroll.contentOffset=CGPointMake(0.0, 0.0);
    [name_fld resignFirstResponder];
    [mobile_fld resignFirstResponder];
        [myPicker setHidden:YES];
    
    
}
- (IBAction)select_prof:(id)sender
{
    [self hideKeyboard];
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Student",
                            @"Private service-holder",
                            @"Teacher",
                            @"Government officer",
                            @"Development org/NGO",
                            @"Retired",
                            @"Homemaker",
                            nil];
    popup.tag = 3;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)select_city:(id)sender
{
    [self hideKeyboard];
    popupcity = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Dhaka",
                            @"Chittagong",
                            @"Sylhet",
                            @"Khulna",
                            @"Rajshahi",
                            @"Barisal",
                            @"Mymensingh",
                            @"Other",
                            nil];
    popupcity.tag = 2;
    [popupcity showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)takephoto:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Select from photos",
                            @"Take new picture",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];

    
    
    
}

- (IBAction)dob_action:(id)sender
{
    [self hideKeyboard];
    [self DobPickerset];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSLog(@"%f,%f",img.size.width,img.size.height);
   // frame.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [profImgVw setImage:img];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                {
                    picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    [self presentViewController:picker animated:YES completion:NULL];

                }
                    break;
                case 1:
                {
                    picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                    [self presentViewController:picker animated:YES completion:NULL];

                }
                    break;
                    default:
                    break;
            }
            break;
        }
        case 2: {
            switch (buttonIndex) {
                case 0:
                {
                    [city_btn setTitle:@"  Dhaka" forState:UIControlStateNormal];
                    
                }
                    break;
                case 1:
                {
                    [city_btn setTitle:@"  Chittagong" forState:UIControlStateNormal];
                }
                    break;
                case 2:
                {
                    [city_btn setTitle:@"  Sylhet" forState:UIControlStateNormal];
                    
                }
                    break;
                case 3:
                {
                    [city_btn setTitle:@"  Khulna" forState:UIControlStateNormal];
                }
                    break;
                case 4:
                {
                    [city_btn setTitle:@"  Rajshahi" forState:UIControlStateNormal];
                    
                }
                    break;
                case 5:
                {
                    [city_btn setTitle:@"  Barisal" forState:UIControlStateNormal];
                }
                    break;
                case 6:
                {
                    [city_btn setTitle:@"  Mymensingh" forState:UIControlStateNormal];
                }
                    break;
                case 7:
                {
        
                    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"New Location"
                                                                          message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                   // other_fld = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
                   // [other_fld setBackgroundColor:[UIColor grayColor]];
                    myAlertView.alertViewStyle=UIAlertViewStylePlainTextInput;
                    //[myAlertView addSubview:other_fld];
                    [myAlertView show];
                    //appDelegate.window.alpha=0.5;
                    //[appDelegate.window addSubview:myAlertView];
                }
                    break;
                default:
                    break;
            }
            break;
        }
        case 3: {
            switch (buttonIndex) {
                case 0:
                {
                    [prof_btn setTitle:@"  Student" forState:UIControlStateNormal];
                    
                }
                    break;
                case 1:
                {
                    [prof_btn setTitle:@"  Private service-holder" forState:UIControlStateNormal];
                }
                    break;
                case 2:
                {
                    [prof_btn setTitle:@"  Teacher" forState:UIControlStateNormal];
                    
                }
                    break;
                case 3:
                {
                    [prof_btn setTitle:@"  Government officer" forState:UIControlStateNormal];
                }
                    break;
                case 4:
                {
                    [prof_btn setTitle:@"  Development org/NGO" forState:UIControlStateNormal];
                    
                }
                    break;
                case 5:
                {
                    [prof_btn setTitle:@"  Retired" forState:UIControlStateNormal];
                }
                    break;
                case 6:
                {
                    [prof_btn setTitle:@"  Homemaker" forState:UIControlStateNormal];
                }
                    break;
                
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        
        NSLog(@"%@", [alertView textFieldAtIndex:0].text);
        if ([alertView textFieldAtIndex:0].text.length==0)
        {
          [city_btn setTitle:@"  Select your city" forState:UIControlStateNormal];
        }
        else
        [city_btn setTitle:[NSString stringWithFormat:@"  %@",[alertView textFieldAtIndex:0].text] forState:UIControlStateNormal];
        
    }
    
}

@end
