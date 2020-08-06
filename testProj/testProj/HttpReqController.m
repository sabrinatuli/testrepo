//
//  HttpReqController.m
//  HarrikeniOS
//
//  Created by Btrac on 12/6/15.
//  Copyright © 2015 Harriken. All rights reserved.
//

#import "HttpReqController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "RestaurantViewController.h"
#import "SearchListViewController.h"
#import "SettingSidebarViewController.h"
#import "SocialViewController.h"
#import "Reachability.h"
#import "SocialViewController.h"
#import "FeedViewController.h"
#import "ProfileViewController.h"
#import "DashboardViewController.h"
#import <MessageUI/MessageUI.h>
#import "CONSTANT.h"

@interface HttpReqController ()

@end

@implementation HttpReqController
@synthesize navigate,setcare_vw,navigate1,navigate2,navigate3,navigate4;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)regComplete:(NSMutableDictionary *)regInfo
{
    
    appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
    [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    //NSString *regUrl = [NSString stringWithFormat:@"%@user_registration.php",BaseURLString];
    NSString *regUrl = [NSString stringWithFormat:@"%@",BaseURLString];
    NSLog(@"url %@",regUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:regUrl
     
       parameters:@{
                    @"tag":@"register",@"password":[regInfo valueForKey:@"password"],@"fullname": [regInfo valueForKey:@"fullname"],@"mobileno":[regInfo valueForKey:@"mobileno"],@"email":[regInfo valueForKey:@"email"],@"dofbirth":[regInfo valueForKey:@"dofbirth"],@"gender":[regInfo valueForKey:@"gender"],@"gcmid":[regInfo valueForKey:@"gcmid"],@"fbid":[regInfo valueForKey:@"fbid"]                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSDictionary *jsondict=responseObject;
         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
         if (![jsondict isKindOfClass:[NSNull class]])
         {
             @try {
                 
                 if ([[jsondict valueForKey:@"success"]integerValue]==1)
                 {
                     NSLog(@"registation response %@",jsondict);
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                     message:@"Registration Successful"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     [alert show];
                     
                     [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"userid"]] forKey:@"userid"];
                     SearchListViewController *log = [[SearchListViewController alloc] initWithNibName:@"SearchListViewController" bundle:[NSBundle mainBundle]];
                     [navigate pushViewController:log animated:YES];
                     
                 }
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                     message:[jsondict valueForKey:@"message"]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                     [alert show];
                 }
             }
             @catch (NSException *exception)
             {
                 NSLog(@"Exception %@",exception);
             }
             @finally
             {
                 NSLog(@"Finally");
             }
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                             message:@"Sorry can not login"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         // [prefs setValue:@"0" forKey:@"success_reg"];
         NSLog(@"Error: %@", error);
         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                         message:@"Connecting Error"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
     }];
}

-(void)loginComplete:(NSMutableDictionary *)logInfo
{
    
    appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
    [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    
    NSString *regUrl = [NSString stringWithFormat:@"%@",BaseURLString];
    NSLog(@"url %@",regUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:regUrl
     
       parameters:@{
                    @"password":[logInfo valueForKey:@"password"],@"email": [logInfo valueForKey:@"email"],@"gcmid":[logInfo valueForKey:@"gcmid"],@"tag":[logInfo valueForKey:@"tag"]
                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"JSON: %@", responseObject);
         NSDictionary *jsondict=responseObject;
         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
         if (![jsondict isKindOfClass:[NSNull class]])
         {
             @try {
                 
                 if ([[jsondict valueForKey:@"success"]integerValue]==1)
                 {
                     NSLog(@"login response %@",jsondict);
                     [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"uid"]] forKey:@"userid"];
                     if (![[jsondict valueForKey:@"city"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"city"]] forKey:@"usercity"];
                     }
                     
                     if (![[jsondict valueForKey:@"dofbirth"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"dofbirth"]] forKey:@"userdofbirth"];
                     }
                     if (![[jsondict valueForKey:@"email"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"email"]] forKey:@"useremail"];
                     }
                     if (![[jsondict valueForKey:@"fullname"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"fullname"]] forKey:@"userfullname"];
                     }
                     if (![[jsondict valueForKey:@"gender"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"gender"]] forKey:@"usergender"];
                     }
                     if (![[jsondict valueForKey:@"pmobile"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"pmobile"]] forKey:@"userpmobile"];
                     }
                     if (![[jsondict valueForKey:@"profileimage"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"profileimage"]] forKey:@"userprofileimage"];
                     }
                     
                     /*
                      [prefs setValue:[jsondict valueForKey:@"userid"] forKey:@"userid"];
                      appDelegate.userinfoArr = [[NSMutableArray alloc]init];
                      appDelegate.userinfoArr = [[jsondict valueForKey:@"user"]mutableCopy];
                      NSMutableArray * tempArr = [[NSMutableArray alloc]init];
                      for (int i = 0; i<[appDelegate.userinfoArr count]; i++)
                      {
                      NSMutableDictionary *mut_dict=[[NSMutableDictionary alloc]init];
                      mut_dict= [[appDelegate.userinfoArr objectAtIndex:i]mutableCopy];
                      
                      for( id key in [mut_dict allKeys])
                      {
                      if ([[mut_dict valueForKey:key] isKindOfClass:[NSNull class]])
                      {
                      
                      [mut_dict setObject:@" " forKey:key];
                      }
                      
                      
                      }
                      [tempArr addObject:mut_dict];
                      
                      }
                      appDelegate.userinfoArr = [[NSMutableArray alloc]init];
                      appDelegate.userinfoArr = tempArr;
                      // NSLog(@"userinfo %@",appDelegate.userinfoArr);
                      */
                     appDelegate.userinfo = [[NSMutableDictionary alloc]init];
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
                         [navigate pushViewController:dash animated:YES];
                         
                     }
                     
                     
                     
                 }
                 
                 
                 else
                 {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                     message:[jsondict valueForKey:@"message"]
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
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                             message:@"Sorry can not login"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
             
             
         }
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         [prefs setValue:@"0" forKey:@"success_reg"];
         
         NSLog(@"Error: %@", error);
         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                         message:@"Connecting Error"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
         
         
         
         
     }];
    
    
    
}
-(void)loginFbCheck:(NSMutableDictionary *)fbInfo
{
    
    appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    
    [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    
    NSString *regUrl = [NSString stringWithFormat:@"%@",BaseURLString];
    NSLog(@"url %@",regUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:regUrl
     
       parameters:@{
                    @"fbid":[fbInfo valueForKey:@"fbid"],@"tag":[fbInfo valueForKey:@"tag"],@"gcmid":[fbInfo valueForKey:@"gcmid"]
                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"JSON: %@", responseObject);
         NSDictionary *jsondict=responseObject;
         
         if (![jsondict isKindOfClass:[NSNull class]])
         {
             @try {
                 
                 if ([[jsondict valueForKey:@"success"]integerValue]==1)
                 {
                     NSLog(@"login response %@",jsondict);
                     
                     [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                     appDelegate.userinfo = [[NSMutableDictionary alloc]init];
                     // [prefs setObject:[jsondict valueForKey:@"value"] forKey:@"userinfo"];
                     // [prefs setObject:[appDelegate.userinfo valueForKey:@"userinfo"]  forKey:@"login_userinfo"];
                     [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"userid"]] forKey:@"userid"];
                     NSLog(@"userid %@",[prefs valueForKey:@"userid"]);
                     if (![[jsondict valueForKey:@"city"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"city"]] forKey:@"usercity"];
                     }
                     
                     if (![[jsondict valueForKey:@"dofbirth"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"dofbirth"]] forKey:@"userdofbirth"];
                     }
                     if (![[jsondict valueForKey:@"email"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"email"]] forKey:@"useremail"];
                     }
                     if (![[jsondict valueForKey:@"fullname"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"fullname"]] forKey:@"userfullname"];
                     }
                     if (![[jsondict valueForKey:@"gender"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"gender"]] forKey:@"usergender"];
                     }
                     if (![[jsondict valueForKey:@"pmobile"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"pmobile"]] forKey:@"userpmobile"];
                     }
                     if (![[jsondict valueForKey:@"profileimage"]isKindOfClass:[NSNull class]]) {
                         [prefs setValue:[NSString stringWithFormat:@"%@",[jsondict valueForKey:@"profileimage"]] forKey:@"userprofileimage"];
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
                         
                         DashboardViewController *dash = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
                         [navigate pushViewController:dash animated:YES];
                         
                     }
                     
                 }
                 
                 
                 else
                 {
                     NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[fbInfo valueForKey:@"fullname"],@"fullname",[fbInfo valueForKey:@"password"],@"password",[fbInfo valueForKey:@"mobileno"],@"mobileno",[fbInfo valueForKey:@"email"],@"email",[fbInfo valueForKey:@"dofbirth"],@"dofbirth",[fbInfo valueForKey:@"gender"],@"gender",[fbInfo valueForKey:@"fbid"],@"fbid",@" ",@"gcmid",nil];
                     HttpReqController *htp = [[HttpReqController alloc]init];
                     [htp regComplete:dict];
                     
                     
                 }
             }
             @catch (NSException *exception) {
                 NSLog(@"Exception %@",exception);
             }
             @finally {
                 
             }
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                             message:@"Sorry can not login"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
             
             
         }
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         NSLog(@"%@", operation.responseString);
         
         
         NSLog(@"Error: %@", error);
         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                         message:@"Connecting Error"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
         
         
         
         
     }];
    
    
    
}

-(void)getAllRest
{
    
    appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
    [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    
    NSString *regUrl = [NSString stringWithFormat:@"%@",BaseURLString];
    NSLog(@"url %@",regUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:regUrl
     
       parameters:@{
                    @"tag":@"allrestaurant"
                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // NSLog(@"JSON: %@", responseObject);
         NSDictionary *jsondict=responseObject;
         
         if (![jsondict isKindOfClass:[NSNull class]])
         {
             @try {
                 
                 if ([[jsondict valueForKey:@"success"]integerValue]==1)
                 {
                     // NSLog(@"allrest response %@",jsondict);
                     
                     [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                     appDelegate.userinfo = [[NSMutableDictionary alloc]init];
                     appDelegate.appD_restlistinfo = [[NSMutableArray alloc]init];
                     
                     
                     
                     
                     SearchListViewController *dash = [[SearchListViewController alloc] initWithNibName:@"SearchListViewController" bundle:[NSBundle mainBundle]];
                     dash.restSearchInfo = [[jsondict valueForKey:@"resdata"]mutableCopy];
                     appDelegate.appD_restlistinfo = [[jsondict valueForKey:@"resdata"]mutableCopy];
                     //splitMenu.frontViewController= dash;
                     [navigate pushViewController:dash animated:YES];
                     
                     
                     
                 }
                 
                 
                 else
                 {
                     
                     
                 }
             }
             @catch (NSException *exception) {
                 NSLog(@"Exception %@",exception);
             }
             @finally {
                 
             }
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                             message:@"Error in Connection"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
             
             
         }
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         
         NSLog(@"Error: %@", error);
         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                         message:@"Connecting Error"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
         
         
         
         
     }];
    
    
    
}



-(void)ShowRestInfo:(NSMutableDictionary *)restInfo
{
    
    appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
    [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    
    NSString *regUrl = [NSString stringWithFormat:@"%@",BaseURLString];
    NSLog(@"url %@",regUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:regUrl
     
       parameters:@{
                    @"tag":@"resturantinfo",@"userid":[restInfo valueForKey:@"userid"],@"resturantid":[restInfo valueForKey:@"resturantid"]
                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"JSON: %@", responseObject);
         NSDictionary *jsondict=responseObject;
         
         if (![jsondict isKindOfClass:[NSNull class]])
         {
             @try {
                 
                 if ([[jsondict valueForKey:@"success"]integerValue]==1)
                 {
                     NSLog(@"rest response %@",jsondict);
                     
                     [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                     appDelegate.userinfo = [[NSMutableDictionary alloc]init];
                     // [prefs setObject:[jsondict valueForKey:@"value"] forKey:@"userinfo"];
                     // [prefs setObject:[appDelegate.userinfo valueForKey:@"userinfo"]  forKey:@"login_userinfo"];
                     
                     appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                     RestaurantViewController *dash = [[RestaurantViewController alloc] initWithNibName:@"RestaurantViewController" bundle:[NSBundle mainBundle]];
                     
                     dash.restInfoDict = [jsondict mutableCopy];
                     
                     [navigate pushViewController:dash animated:YES];
                     //[self showRoute:@"showlatlng" userid:[prefs valueForKey:@"userid"] vehicleid:[jsondict valueForKey:@"vehicleid"]];
                     
                 }
                 
                 
                 else
                 {
                     
                     
                 }
             }
             @catch (NSException *exception) {
                 NSLog(@"Exception %@",exception);
             }
             @finally {
                 
             }
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                             message:@"Error in Connection"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
             
             
         }
         
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         
         NSLog(@"Error: %@", error);
         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                         message:@"Connecting Error"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
         
         
         
         
     }];
    
    
    
}


@end
