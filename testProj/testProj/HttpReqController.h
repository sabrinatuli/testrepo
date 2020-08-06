//
//  HttpReqController.h
//  HarrikeniOS
//
//  Created by Btrac on 12/6/15.
//  Copyright © 2015 Harriken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"

@interface HttpReqController : UIViewController<UIAlertViewDelegate,UITabBarControllerDelegate,SWRevealViewControllerDelegate>

{
    AppDelegate *appDelegate;
    int success;
    SWRevealViewController *splitMenu;
    SWRevealViewController *splitMenu2;
    SWRevealViewController *splitMenu3;
    SWRevealViewController *splitMenu4;
    
    
    
}

-(void)getAllRest;
- (void) regComplete:(NSMutableDictionary *)regInfo;
-(void)loginComplete:(NSMutableDictionary *)logInfo;
-(void)loginFbCheck:(NSMutableDictionary *)fbInfo;
-(void)ShowRestInfo:(NSMutableDictionary *)restInfo;
-(void)updateNotification:(NSMutableDictionary *)updateInfo;
-(void)insertGlucose:(NSMutableDictionary *)gluInfo;
-(void)insertInsulin:(NSMutableDictionary *)insInfo;
-(void)assignCaregiverById:(NSString *)userid;
-(void)updateProfile:(NSMutableDictionary *)profileInfo;
-(void)updateUserType:(NSString *)userid usertype:(NSString *)usertype;
-(void)changePassword:(NSString *)userid password:(NSString *)password oldpassword :(NSString *)oldpassword;
-(void)patientListCG:(NSString *)userid;
-(void)sugarReport:(NSMutableDictionary *)sugarInfo;
-(void)insulinReport:(NSMutableDictionary *)insInfo;
-(void)sugarDataReport:(NSMutableDictionary *)sugarInfo;

@property (strong, nonatomic) UINavigationController *navigate1;
@property (strong, nonatomic) UINavigationController *navigate2;
@property (strong, nonatomic) UINavigationController *navigate3;
@property (strong, nonatomic) UINavigationController *navigate4;

@property (nonatomic,retain) UINavigationController *navigate;
@property (nonatomic,retain) UIViewController *setcare_vw;

@end
