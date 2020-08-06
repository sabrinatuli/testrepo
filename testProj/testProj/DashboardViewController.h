//
//  DashboardViewController.h
//  HarrikeniOS
//
//  Created by Btrac on 11/12/15.
//  Copyright © 2015 Harriken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface DashboardViewController : UIViewController<UITabBarControllerDelegate,SWRevealViewControllerDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
AppDelegate *appDelegate;
    UIView* MenuButtonView;
    UIButton* MenuButton;
    IBOutlet UIView *filter_view;
    float originLatitude;
    float originLongitude;
    IBOutlet UIButton *rest_sel;
    IBOutlet UIButton *rest_nonsel;
    IBOutlet UIButton *cuisine_sel;
    IBOutlet UIButton *cuisine_nonsel;
    IBOutlet UIButton *open_sel;
    IBOutlet UIButton *open_nonsel;
}
@property (nonatomic, strong) CLLocationManager *locationManager;
- (IBAction)filter_action:(id)sender;
- (IBAction)filter_backAction:(id)sender;
- (IBAction)filter_apply:(id)sender;
- (IBAction)rest_select:(id)sender;
- (IBAction)cuisine_select:(id)sender;
- (IBAction)open_select:(id)sender;

@end
