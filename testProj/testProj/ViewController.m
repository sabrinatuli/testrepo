//
//  ViewController.m
//  HarrikeniOS
//
//  Created by Btrac on 10/8/15.
//  Copyright (c) 2015 Harriken. All rights reserved.
//

#import "ViewController.h"
#import "CONSTANT.h"
#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "RestaurantViewController.h"
#import "MBProgressHUD.h"
#import "HttpReqController.h"
#import "EditProfileViewController.h"
#import "Reachability.h"
#import "DashboardViewController.h"
#import "SettingSidebarViewController.h"
#import "SocialViewController.h"
#import "ProfileViewController.h"
#import "FeedViewController.h"

@interface ViewController () <FBSDKLoginButtonDelegate>

@end

@implementation ViewController
@synthesize navigate1, navigate2, navigate3, navigate4;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigation.png"]
                                      forBarMetrics:UIBarMetricsDefault];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //self.navigationController.navigationBarHidden = YES;
    //set the delegate to self in order for the delegate protocol methods to be notified
    appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
    FBSDKLoginButton *loginBtn = [[FBSDKLoginButton alloc] init];
    loginBtn.delegate=self;
    loginBtn.center= containerview.center;
    loginBtn.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    if (IPHONE_4)
    {
       loginBtn.frame = CGRectMake(loginBtn.frame.origin.x-50,loginBtn.frame.origin.y-253, 285, 45);
    }
    else
    loginBtn.frame = CGRectMake(loginBtn.frame.origin.x-50,loginBtn.frame.origin.y-325, 285, 45);
    [containerview addSubview:loginBtn];
    if (IPHONE_6 || IPHONE_6Plus)
    {
        containerview.transform = CGAffineTransformMakeTranslation(0.0, 50.0);
       
    }
    
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
        NSObject * object = [prefs objectForKey:@"userid"];
    if ([FBSDKAccessToken currentAccessToken] && object != nil)
    {
        
        [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me"
                                      parameters:@{ @"fields": @"id,name,birthday,email,gender,friends,location,music",}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSLog(@"fetched user:%@", result);
                NSLog(@"fetched user:%@", result);
                NSLog(@"fb id %@",[result valueForKey:@"id"]);
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[result valueForKey:@"id"],@"fullname",@" ",@"password",@" ",@"mobileno",[result valueForKey:@"email"],@"email",[result valueForKey:@"birthday"],@"dofbirth",[result valueForKey:@"gender"],@"gender",[result valueForKey:@"id"],@"fbid",@"fbcheck",@"tag",@" ",@"gcmid",nil];
                HttpReqController *htp = [[HttpReqController alloc]init];
                htp.navigate= self.navigationController;
                
                [htp loginFbCheck:dict];
                
                
            }
        }];
        
    }
        
      
      else  if(object != nil)
       {
        NSLog(@"userid %@",[prefs valueForKey:@"userid"]);
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
                              DashboardViewController *dash = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
               [self.navigationController pushViewController:dash animated:YES];
               
               

           }
    
    }


        
    }
    /*
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        UIViewController *secondCV = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]instantiateViewControllerWithIdentifier:@"AnotherViewController"];
     
        [self presentViewController:secondCV animated:YES completion:nil];
    }
     */
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    if(!error){
        NSLog(@"You've Logged in");
        NSLog(@"%@", result);
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
        if ([FBSDKAccessToken currentAccessToken])
        {
            
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:@"/me"
                                          parameters:@{ @"fields": @"id,name,gender,birthday,email,friends,location,music,picture",}
                                          HTTPMethod:@"GET"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSLog(@"fetched user:%@", result);
                    NSLog(@"fb id %@",[result valueForKey:@"id"]);
                    [prefs setValue:[NSString stringWithFormat:@"%@",[result valueForKey:@"email"]] forKey:@"useremail"];
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[result valueForKey:@"name"],@"fullname",@" ",@"password",@" ",@"mobileno",[result valueForKey:@"email"],@"email",[result valueForKey:@"birthday"],@"dofbirth",[result valueForKey:@"gender"],@"gender",[result valueForKey:@"id"],@"fbid",@"fbcheck",@"tag",@" ",@"gcmid",nil];
                    HttpReqController *htp = [[HttpReqController alloc]init];
                    htp.navigate= self.navigationController;
                    [htp loginFbCheck:dict];
                    /*
                    RestaurantViewController *sign = [[RestaurantViewController alloc]initWithNibName:@"RestaurantViewController" bundle:[NSBundle mainBundle]];
                    [self.navigationController pushViewController:sign animated:YES];
             [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                     */
                    

                }
            }];

        }
        
        
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
     NSLog(@"You've Logged out");
}

- (IBAction)signup:(id)sender
{
    NSLog(@"enter");
    
    SignUpViewController *sign = [[SignUpViewController alloc]initWithNibName:@"SignUpViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:sign animated:YES];
    
}
- (IBAction)harriken_login:(id)sender
{
    
    
    if (IPHONE_4)
    {
        LoginViewController *sign = [[LoginViewController alloc]initWithNibName:@"LoginViewController_4s" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:sign animated:YES];
    }
    else
    {
    LoginViewController *sign = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:sign animated:YES];
    }
  
    

}

@end
