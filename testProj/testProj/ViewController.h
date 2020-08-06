//
//  ViewController.h
//  HarrikeniOS
//
//  Created by Btrac on 10/8/15.
//  Copyright (c) 2015 Harriken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppDelegate.h"
#import "SWRevealViewController.h"
@interface ViewController : UIViewController<FBSDKLoginButtonDelegate,SWRevealViewControllerDelegate,UITabBarControllerDelegate>
{
   AppDelegate *appDelegate;
    IBOutlet UIView *containerview;
    SWRevealViewController *splitMenu;
    SWRevealViewController *splitMenu2;
    SWRevealViewController *splitMenu3;
    SWRevealViewController *splitMenu4;
}

@property (strong, nonatomic) UINavigationController *navigate1;
@property (strong, nonatomic) UINavigationController *navigate2;
@property (strong, nonatomic) UINavigationController *navigate3;
@property (strong, nonatomic) UINavigationController *navigate4;
@property (weak, nonatomic) IBOutlet id<FBSDKLoginButtonDelegate> delegate;
@property (retain, nonatomic) IBOutlet FBSDKLoginButton *FBbutton;
- (IBAction)signup:(id)sender;
- (IBAction)harriken_login:(id)sender;

@end

