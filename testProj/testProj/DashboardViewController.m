//
//  DashboardViewController.m
//  HarrikeniOS
//
//  Created by Btrac on 11/12/15.
//  Copyright © 2015 Harriken. All rights reserved.
//

#import "DashboardViewController.h"
#import "HttpReqController.h"
#import "CONSTANT.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface DashboardViewController ()
{
    IBOutlet UIButton *search_btn;
}
- (IBAction)search_action:(id)sender;

@end

@implementation DashboardViewController
@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=NO;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // orange 255 51 0
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigation_gray"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setHidesBackButton:YES animated:YES];
       
    SWRevealViewController *revealViewController = [self revealViewController];
  //  UITapGestureRecognizer *tap = [revealViewController tapGestureRecognizer];
   // tap.delegate = self;
    
   // [self.view addGestureRecognizer:tap];
    
     MenuButtonView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, 55, 32)];
        UIBarButtonItem *Menu=[[UIBarButtonItem alloc]initWithCustomView:MenuButtonView];
   // self.navigationItem.leftBarButtonItem=Menu;
   
    
    
    MenuButton=[UIButton buttonWithType:UIButtonTypeSystem];
    MenuButton.frame=MenuButtonView.frame;
    [MenuButton setImage:[UIImage imageNamed:@"sidemenu"] forState:UIControlStateNormal];
    MenuButton.tintColor=[UIColor whiteColor];
    
    [MenuButton addTarget:revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [MenuButtonView addSubview:MenuButton];
    
    Menu=[[UIBarButtonItem alloc]initWithCustomView:MenuButtonView];
    self.navigationItem.rightBarButtonItem=Menu;
    if ([CLLocationManager locationServicesEnabled]) {
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate=self;
        locationManager.distanceFilter = 10.0;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        
        if(IS_OS_8_OR_LATER)
        {
            [locationManager requestWhenInUseAuthorization];
        }
        
        if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [locationManager startUpdatingLocation];
        
        
    }
    else
    {
        NSLog(@"Location not enabled");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Location is disabled"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:@"Enable from settings",nil];
        [alert show];
    }

   

}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    //UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //  [errorAlert show];
    if([CLLocationManager locationServicesEnabled])
    {
        NSLog(@"Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            NSLog(@"Permission Denied");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Location is disabled"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:@"Enable from settings",nil];
            [alert show];
            
        }
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation   *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"updated location");
    originLatitude=newLocation.coordinate.latitude;
    originLongitude=newLocation.coordinate.longitude;
    NSLog(@"originlat %f originlong %f",originLatitude,originLongitude);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:[NSString stringWithFormat:@"%f",originLatitude] forKey:@"current_lat"];
    [prefs setValue:[NSString stringWithFormat:@"%f",originLongitude] forKey:@"current_long"];
    [locationManager stopUpdatingLocation];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        NSLog(@"alert");
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)search_action:(id)sender
{
    HttpReqController *htp = [[HttpReqController alloc]init];
    htp.navigate= self.navigationController;
    [htp getAllRest];
}
- (IBAction)filter_action:(id)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.view.layer addAnimation:transition forKey:kCATransition];
    filter_view.hidden=NO;
    
   }

- (IBAction)filter_backAction:(id)sender
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
[self.view.layer addAnimation:transition forKey:kCATransition];
    filter_view.hidden=YES;
}

- (IBAction)filter_apply:(id)sender
{
    HttpReqController *htp = [[HttpReqController alloc]init];
    htp.navigate= self.navigationController;
    [htp getAllRest];
}

- (IBAction)rest_select:(id)sender
{
    UIButton *btn= sender;
 
    if (btn.tag==2)
    {
        [rest_nonsel setHidden:NO];
        [rest_sel setHidden:YES];
        
    }
    else if (btn.tag==1)
    {
       
        [rest_sel setHidden:NO];
        [rest_nonsel setHidden:YES];
    }
    
    
  
}

- (IBAction)cuisine_select:(id)sender
{
    UIButton *btn= sender;
    
    if (btn.tag==2)
    {
        [cuisine_nonsel setHidden:NO];
        [cuisine_sel setHidden:YES];
        
    }
    else if (btn.tag==1)
    {
        
        [cuisine_sel setHidden:NO];
        [cuisine_nonsel setHidden:YES];
    }

}

- (IBAction)open_select:(id)sender
{
    UIButton *btn= sender;
    
    if (btn.tag==2)
    {
        [open_nonsel setHidden:NO];
        [open_sel setHidden:YES];
        
    }
    else if (btn.tag==1)
    {
        
        [open_sel setHidden:NO];
        [open_nonsel setHidden:YES];
    }

}
@end
