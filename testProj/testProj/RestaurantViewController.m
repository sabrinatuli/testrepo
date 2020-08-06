//
//  RestaurantViewController.m
//  HarrikeniOS
//
//  Created by Btrac on 10/14/15.
//  Copyright (c) 2015 Harriken. All rights reserved.
//

#import "RestaurantViewController.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "CONSTANT.h"
#import "ViewController.h"
#import "EditProfileViewController.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchListViewController.h"
#define MINIMUM_SCALE 0.5
#define MAXIMUM_SCALE 6.0
@interface RestaurantViewController ()

@end

@implementation RestaurantViewController
@synthesize FBbutton,restInfoDict,imagealbum_arr,hFlowView,hPageControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden=NO;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // orange 255 51 0
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigation_gray"]
                                                  forBarMetrics:UIBarMetricsDefault];
    rest_scroll.contentSize = CGSizeMake(rest_scroll.frame.size.width, 1200);
    st=-1;
    fn = -1;
    
    SWRevealViewController *revealViewController = [self revealViewController];
  //  UITapGestureRecognizer *tap = [revealViewController tapGestureRecognizer];
  //  tap.delegate = self;
    
   // [self.view addGestureRecognizer:tap];

    MenuButtonView = [[UIView alloc]initWithFrame:CGRectMake(-20, 0, 70, 40)];
    
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
    nameArr = [[NSMutableArray alloc] initWithObjects:@"flower1.png",@"flower2.png",@"flower3.png",nil];
    
   
    hFlowView.delegate = self;
    hFlowView.dataSource = self;
    hFlowView.pageControl = hPageControl;
    hFlowView.minimumPageAlpha = 0.3;
    hFlowView.minimumPageScale = 0.9;
        
    [self setInfo];
   // return [comp weekday]; // 1 = Sunday, 2 = Monday, etc.
    
    /*
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:@"https://fb.me/1072575449428887"];
    //optionally set previewImageURL
   // content.appInvitePreviewImageURL = [NSURL URLWithString:@"https://www.mydomain.com/my_invite_image.jpg"];
    
    // present the dialog. Assumes self implements protocol `FBSDKAppInviteDialogDelegate`
    
    [FBSDKAppInviteDialog showWithContent:content
                                 delegate:self];
     */
    
   
   

     
}
-(IBAction)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:TRUE];
    
}

-(void)viewWillAppear:(BOOL)animated
{
[self setInfo];
}
-(void) setInfo
{
    [mapView removeFromSuperview];
    [rest_scroll addSubview:info_view];
    rest_scroll.contentSize = CGSizeMake(rest_scroll.frame.size.width, 1200);
    if ([[restInfoDict valueForKey:@"isreviewed"]integerValue]==0) {
        [wreview_btn setBackgroundImage:[UIImage imageNamed:@"red_review"] forState:UIControlStateNormal];
        review_lbl.text = @"Review";
        
    }
    else
    {
        [wreview_btn setBackgroundImage:[UIImage imageNamed:@"green_review"] forState:UIControlStateNormal];
        review_lbl.text = @"Reviewed";
        
    }
    if ([[restInfoDict valueForKey:@"rating1"]integerValue]==-1 && [[restInfoDict valueForKey:@"rating2"]integerValue]==-1 &&[[restInfoDict valueForKey:@"rating3"]integerValue]==-1 && [[restInfoDict valueForKey:@"rating4"]integerValue]==-1)
    {
        [rate_btn setBackgroundImage:[UIImage imageNamed:@"red_rate"] forState:UIControlStateNormal];
        rate_lbl.text = @"Rate";
    }
    else
    {
        [rate_btn setBackgroundImage:[UIImage imageNamed:@"green_rate"] forState:UIControlStateNormal];
        rate_lbl.text = @"Rated";
    }

    restname.text = [restInfoDict valueForKey:@"restaurantname"];
    restaurant_branch_name.text= [NSString stringWithFormat:@"%@",[restInfoDict valueForKey:@"locationname"]];
    if (![[restInfoDict valueForKey:@"address"]isKindOfClass:[NSNull class]])
    {
        add_txtvw.text= [restInfoDict valueForKey:@"address"];
    }
   // restaurant_branch_name.text= @"Gulshan,Dhaka";
    if ([[restInfoDict valueForKey:@"like"]integerValue]==0) {
        [like_btn setBackgroundImage:[UIImage imageNamed:@"red_like"] forState:UIControlStateNormal];
        like_lbl.text = @"Like";

    }
    else
    {
        [like_btn setBackgroundImage:[UIImage imageNamed:@"green_like"] forState:UIControlStateNormal];
        like_lbl.text = @"Liked";

    }

    [restaurant_branch_name sizeToFit];
    CGRect frame = arrow.frame;
    frame.origin.x= restaurant_branch_name.frame.size.width+5.0;
    arrow.frame=frame;
    show_branch=[UIButton buttonWithType:UIButtonTypeCustom];
    show_branch.frame=CGRectMake(branch_vw.frame.origin.x, branch_vw.frame.origin.y, restaurant_branch_name.frame.size.width+5.0+arrow.frame.size.width, branch_vw.frame.size.height);
    
    // MenuButton.tintColor=[UIColor colorWithRed:(225.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0];
    
    [show_branch addTarget:self action:@selector(dropAction:) forControlEvents:UIControlEventTouchUpInside];
    [topvw addSubview:show_branch];
    NSString *str = [restInfoDict valueForKey:@"restauranttype"];
    if (![str isKindOfClass:[NSNull class]]&&[str length] > 0) {
        str = [str substringToIndex:[str length] - 2];
    }
    else
        str = @" ";
    cuisine_lbl1.text = str;
    [cuisine_lbl1 sizeToFit];
    
    str = [restInfoDict valueForKey:@"ambiancetype"];
    if (![str isKindOfClass:[NSNull class]]&&[str length] > 0) {
        str = [str substringToIndex:[str length] - 2];
    }
    else
        str = @" ";
    ambLbl.text = str;
    [ambLbl sizeToFit];
    if ([[restInfoDict valueForKey:@"wifi"]integerValue]==1)
    {
        [wifi setImage:[UIImage imageNamed:@"tic"]];
    }
    else
        [wifi setImage:[UIImage imageNamed:@"cross"]];
    if ([[restInfoDict valueForKey:@"cards"]integerValue]==1)
    {
        [cards setImage:[UIImage imageNamed:@"tic"]];
    }
    else
        [cards setImage:[UIImage imageNamed:@"cross"]];
    if ([[restInfoDict valueForKey:@"smoking"]integerValue]==1)
    {
        [smoke setImage:[UIImage imageNamed:@"tic"]];
    }
    else
        [smoke setImage:[UIImage imageNamed:@"cross"]];
    if ([[restInfoDict valueForKey:@"aircondition"]integerValue]==1)
    {
        [AC setImage:[UIImage imageNamed:@"tic"]];
    }
    else
        [AC setImage:[UIImage imageNamed:@"cross"]];
    if ([[restInfoDict valueForKey:@"reservation"]integerValue]==1)
    {
        [reserve setImage:[UIImage imageNamed:@"tic"]];
    }
    else
        [reserve setImage:[UIImage imageNamed:@"cross"]];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:kCFCalendarUnitWeekday fromDate:[NSDate date]];
    if ([comp weekday]==1)
    {
        [sunD setImage:[UIImage imageNamed:@"day_red"]];
        sunL.textColor = [UIColor whiteColor];
        sunL.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
       sunLbl.font= [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        monL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        monL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        monLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        tueL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        tueL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        tueLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        wedL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        wedL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        wedLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        thuL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        thuL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        thuLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        friL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        friL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        friLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];

        [monD setImage:[UIImage imageNamed:@"day_ash"]];
        [tueD setImage:[UIImage imageNamed:@"day_ash"]];
        [wedD setImage:[UIImage imageNamed:@"day_ash"]];
        [thuD setImage:[UIImage imageNamed:@"day_ash"]];
        [friD setImage:[UIImage imageNamed:@"day_ash"]];
        [satD setImage:[UIImage imageNamed:@"day_ash"]];
        
    }
    else if ([comp weekday]==2) {
        [monD setImage:[UIImage imageNamed:@"day_red"]];
        monL.textColor = [UIColor whiteColor];
        monL.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        monLbl.font= [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        sunL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        sunL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        sunLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        tueL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        tueL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        tueLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        wedL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        wedL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        wedLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        thuL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        thuL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        thuLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        friL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        friL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        friLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        satL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        satL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        satLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];

        [sunD setImage:[UIImage imageNamed:@"day_ash"]];
        [tueD setImage:[UIImage imageNamed:@"day_ash"]];
        [wedD setImage:[UIImage imageNamed:@"day_ash"]];
        [thuD setImage:[UIImage imageNamed:@"day_ash"]];
        [friD setImage:[UIImage imageNamed:@"day_ash"]];
        [satD setImage:[UIImage imageNamed:@"day_ash"]];
    }
    else if ([comp weekday]==3) {
        [tueD setImage:[UIImage imageNamed:@"day_red"]];
        tueL.textColor = [UIColor whiteColor];
        tueL.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        tueLbl.font= [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        monL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        monL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        monLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        satL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        satL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        satLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        wedL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        wedL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        wedLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        thuL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        thuL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        thuLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        friL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        friL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        friLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        sunL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        sunL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        sunLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];

        [monD setImage:[UIImage imageNamed:@"day_ash"]];
        [sunD setImage:[UIImage imageNamed:@"day_ash"]];
        [wedD setImage:[UIImage imageNamed:@"day_ash"]];
        [thuD setImage:[UIImage imageNamed:@"day_ash"]];
        [friD setImage:[UIImage imageNamed:@"day_ash"]];
        [satD setImage:[UIImage imageNamed:@"day_ash"]];
    }
    else if ([comp weekday]==4) {
        [wedD setImage:[UIImage imageNamed:@"day_red"]];
        wedL.textColor = [UIColor whiteColor];
        wedL.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        wedLbl.font= [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        monL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        monL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        monLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        tueL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        tueL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        tueLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        satL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        satL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        satLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        thuL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        thuL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        thuLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        friL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        friL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        friLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        sunL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        sunL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        sunLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];

        [monD setImage:[UIImage imageNamed:@"day_ash"]];
        [tueD setImage:[UIImage imageNamed:@"day_ash"]];
        [sunD setImage:[UIImage imageNamed:@"day_ash"]];
        [thuD setImage:[UIImage imageNamed:@"day_ash"]];
        [friD setImage:[UIImage imageNamed:@"day_ash"]];
        [satD setImage:[UIImage imageNamed:@"day_ash"]];
    }
    else if ([comp weekday]==5) {
        [thuD setImage:[UIImage imageNamed:@"day_red"]];
        thuL.textColor = [UIColor whiteColor];
        thuL.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        thuLbl.font= [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        monL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        monL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        monLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        tueL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        tueL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        tueLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        wedL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        wedL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        wedLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        satL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        satL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        satLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        friL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        friL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        friLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        sunL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        sunL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        sunLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];

        [monD setImage:[UIImage imageNamed:@"day_ash"]];
        [tueD setImage:[UIImage imageNamed:@"day_ash"]];
        [wedD setImage:[UIImage imageNamed:@"day_ash"]];
        [sunD setImage:[UIImage imageNamed:@"day_ash"]];
        [friD setImage:[UIImage imageNamed:@"day_ash"]];
        [satD setImage:[UIImage imageNamed:@"day_ash"]];
    }
    else if ([comp weekday]==6) {
        [friD setImage:[UIImage imageNamed:@"day_red"]];
        friL.textColor = [UIColor whiteColor];
        friL.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        friLbl.font= [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        monL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        monL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        monLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        tueL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        tueL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        tueLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        wedL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        wedL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        wedLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        thuL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        thuL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        thuLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        satL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        satL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        satLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        sunL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        sunL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        sunLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];

        [monD setImage:[UIImage imageNamed:@"day_ash"]];
        [tueD setImage:[UIImage imageNamed:@"day_ash"]];
        [wedD setImage:[UIImage imageNamed:@"day_ash"]];
        [thuD setImage:[UIImage imageNamed:@"day_ash"]];
        [sunD setImage:[UIImage imageNamed:@"day_ash"]];
        [satD setImage:[UIImage imageNamed:@"day_ash"]];
    }
    else if ([comp weekday]==7) {
        [satD setImage:[UIImage imageNamed:@"day_red"]];
        satL.textColor = [UIColor whiteColor];
        satL.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        satLbl.font= [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        monL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        monL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        monLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        tueL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        tueL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        tueLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        wedL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        wedL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        wedLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        thuL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        thuL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        thuLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        friL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        friL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        friLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        sunL.textColor=[UIColor colorWithRed:(102.0/255.0) green:(102.0/255.0) blue:(102.0/255.0) alpha:1.0];
        sunL.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];
        sunLbl.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13.0];

        [monD setImage:[UIImage imageNamed:@"day_ash"]];
        [tueD setImage:[UIImage imageNamed:@"day_ash"]];
        [wedD setImage:[UIImage imageNamed:@"day_ash"]];
        [thuD setImage:[UIImage imageNamed:@"day_ash"]];
        [friD setImage:[UIImage imageNamed:@"day_ash"]];
        [sunD setImage:[UIImage imageNamed:@"day_ash"]];
    }
   ////////////////////////
    if (![[restInfoDict valueForKey:@"servicetime"]isKindOfClass:[NSNull class]])
    {
        
//***********************Satday**********************************
    NSString *timestrt= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:0]valueForKey:@"starttime"];
        NSString *timefns= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:0]valueForKey:@"closetime"];
        NSString *strt1;
        NSString *strt2;
        st =-1; fn=-1;
        if (![timestrt isKindOfClass:[NSNull class]]&&[timestrt length] > 0) {
            strt1 = [timestrt substringToIndex:[timestrt length] - 3];
            strt2 = [strt1 substringToIndex:[strt1 length] - 3];
        
        
        if ([strt2 integerValue]>12)
        {
            st=1;
            int val = [strt2 integerValue]-12;
            strt2 = [NSString stringWithFormat:@"%d",val];
            NSLog(@"val %d str %@",val,strt2);
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
        }
        else
        {
            st =0;
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];

        }
        }
        
        //////////////////////////////////////////////////////////
        NSString *fns1;
        NSString *fns2;
        if (![timefns isKindOfClass:[NSNull class]]&&[timefns length] > 0) {
            fns1 = [timefns substringToIndex:[timefns length] - 3];
            fns2 = [fns1 substringToIndex:[fns1 length] - 3];
        
        
        if ([fns2 integerValue]>12)
        {
            fn = 1;
            int val = [fns2 integerValue]-12;
            fns2 = [NSString stringWithFormat:@"%d",val];
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
        }
        else
        {
            fn=0;
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
            
        }
        }
        if (st==1 && fn==1)
        {
            
        satLbl.text = [NSString stringWithFormat:@"%@ PM to %@ PM",timestrt,timefns];
        }
        else if (st==1 && fn==0)
        {
        satLbl.text = [NSString stringWithFormat:@"%@ PM to %@ AM",timestrt,timefns];
        }
        else if (st==0 && fn==1)
        {
        satLbl.text = [NSString stringWithFormat:@"%@ AM to %@ PM",timestrt,timefns];
        }
        else if (st==0 && fn==0)
        {
            satLbl.text = [NSString stringWithFormat:@"%@ AM to %@ AM",timestrt,timefns];
        }
        else if ((st==-1 && fn==-1) || (st==-1 && fn==0) || (st==-1 && fn==1) || (st==0 && fn==-1) || (st==1 && fn==-1))
        {
            satLbl.text = [NSString stringWithFormat:@"not available"];
        }
        //***********************Sunday**********************************
        timestrt= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:1]valueForKey:@"starttime"];
        timefns= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:1]valueForKey:@"closetime"];
        st =-1; fn=-1;
        
        if (![timestrt isKindOfClass:[NSNull class]]&&[timestrt length] > 0) {
            strt1 = [timestrt substringToIndex:[timestrt length] - 3];
            strt2 = [strt1 substringToIndex:[strt1 length] - 3];
        
        
        if ([strt2 integerValue]>12)
        { st =1;
            int val = [strt2 integerValue]-12;
            strt2 = [NSString stringWithFormat:@"%d",val];
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
        }
        else
        {
            st=0;
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
            
        }
        }
        //////////////////////////////////////////////////////////
        
        if (![timefns isKindOfClass:[NSNull class]]&&[timefns length] > 0) {
            fns1 = [timefns substringToIndex:[timefns length] - 3];
            fns2 = [fns1 substringToIndex:[fns1 length] - 3];
        
        
        if ([fns2 integerValue]>12)
        {
            fn=1;
            int val = [fns2 integerValue]-12;
            fns2 = [NSString stringWithFormat:@"%d",val];
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
        }
        else
        {
            fn=0;
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
            
        }
        }
        
        if (st==1 && fn==1)
        {
            
            sunLbl.text = [NSString stringWithFormat:@"%@ PM to %@ PM",timestrt,timefns];
        }
        else if (st==1 && fn==0)
        {
            sunLbl.text = [NSString stringWithFormat:@"%@ PM to %@ AM",timestrt,timefns];
        }
        else if (st==0 && fn==1)
        {
            sunLbl.text = [NSString stringWithFormat:@"%@ AM to %@ PM",timestrt,timefns];
        }
        else if (st==0 && fn==0)
        {
            sunLbl.text = [NSString stringWithFormat:@"%@ AM to %@ AM",timestrt,timefns];
        }
        else if ((st==-1 && fn==-1) || (st==-1 && fn==0) || (st==-1 && fn==1) || (st==0 && fn==-1) || (st==1 && fn==-1))
        {
            sunLbl.text = [NSString stringWithFormat:@"not available"];
        }
        //***********************Monday**********************************
        timestrt= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:2]valueForKey:@"starttime"];
        timefns= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:2]valueForKey:@"closetime"];
        
        st =-1; fn=-1;
        if (![timestrt isKindOfClass:[NSNull class]]&&[timestrt length] > 0) {
            strt1 = [timestrt substringToIndex:[timestrt length] - 3];
            strt2 = [strt1 substringToIndex:[strt1 length] - 3];
        
        
        if ([strt2 integerValue]>12)
        {
            st=1;
            int val = [strt2 integerValue]-12;
            strt2 = [NSString stringWithFormat:@"%d",val];
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
        }
        else
        {
            st=0;
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
            
        }
        }
        //////////////////////////////////////////////////////////
        
        if (![timefns isKindOfClass:[NSNull class]]&&[timefns length] > 0) {
            fns1 = [timefns substringToIndex:[timefns length] - 3];
            fns2 = [fns1 substringToIndex:[fns1 length] - 3];
        
        
        if ([fns2 integerValue]>12)
        {
            fn=1;
            int val = [fns2 integerValue]-12;
            fns2 = [NSString stringWithFormat:@"%d",val];
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
        }
        else
        {
            fn=0;
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
            
        }
        }
        if (st==1 && fn==1)
        {
            
            monLbl.text = [NSString stringWithFormat:@"%@ PM to %@ PM",timestrt,timefns];
        }
        else if (st==1 && fn==0)
        {
            monLbl.text = [NSString stringWithFormat:@"%@ PM to %@ AM",timestrt,timefns];
        }
        else if (st==0 && fn==1)
        {
            monLbl.text = [NSString stringWithFormat:@"%@ AM to %@ PM",timestrt,timefns];
        }
        else if (st==0 && fn==0)
        {
            monLbl.text = [NSString stringWithFormat:@"%@ AM to %@ AM",timestrt,timefns];
        }
        else if ((st==-1 && fn==-1) || (st==-1 && fn==0) || (st==-1 && fn==1) || (st==0 && fn==-1) || (st==1 && fn==-1))
        {
            monLbl.text = [NSString stringWithFormat:@"not available"];
        }
        //***********************Tueday**********************************
        timestrt= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:3]valueForKey:@"starttime"];
        timefns= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:3]valueForKey:@"closetime"];
        st =-1; fn=-1;
        
        if (![timestrt isKindOfClass:[NSNull class]]&&[timestrt length] > 0) {
            strt1 = [timestrt substringToIndex:[timestrt length] - 3];
            strt2 = [strt1 substringToIndex:[strt1 length] - 3];
        
        
        if ([strt2 integerValue]>12)
        {
            st =1;
            int val = [strt2 integerValue]-12;
            strt2 = [NSString stringWithFormat:@"%d",val];
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
        }
        else
        {
            st =0;
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
            
        }
        }
        //////////////////////////////////////////////////////////
        
        if (![timefns isKindOfClass:[NSNull class]]&&[timefns length] > 0) {
            fns1 = [timefns substringToIndex:[timefns length] - 3];
            fns2 = [fns1 substringToIndex:[fns1 length] - 3];
        
        
        if ([fns2 integerValue]>12)
        {
            fn =1;
            int val = [fns2 integerValue]-12;
            fns2 = [NSString stringWithFormat:@"%d",val];
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
        }
        else
        {
            fn = 0;
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
            
        }
        }
        
        if (st==1 && fn==1)
        {
            
            tueLbl.text = [NSString stringWithFormat:@"%@ PM to %@ PM",timestrt,timefns];
        }
        else if (st==1 && fn==0)
        {
            tueLbl.text = [NSString stringWithFormat:@"%@ PM to %@ AM",timestrt,timefns];
        }
        else if (st==0 && fn==1)
        {
            tueLbl.text = [NSString stringWithFormat:@"%@ AM to %@ PM",timestrt,timefns];
        }
        else if (st==0 && fn==0)
        {
            tueLbl.text = [NSString stringWithFormat:@"%@ AM to %@ AM",timestrt,timefns];
        }
        else if ((st==-1 && fn==-1) || (st==-1 && fn==0) || (st==-1 && fn==1) || (st==0 && fn==-1) || (st==1 && fn==-1))
        {
            tueLbl.text = [NSString stringWithFormat:@"not available"];
        }
        //***********************Wedday**********************************
        timestrt= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:4]valueForKey:@"starttime"];
        timefns= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:4]valueForKey:@"closetime"];
        st =-1; fn=-1;
        
        if (![timestrt isKindOfClass:[NSNull class]]&&[timestrt length] > 0) {
            strt1 = [timestrt substringToIndex:[timestrt length] - 3];
            strt2 = [strt1 substringToIndex:[strt1 length] - 3];
        
        
        if ([strt2 integerValue]>12)
        {
            st = 1;
            int val = [strt2 integerValue]-12;
            strt2 = [NSString stringWithFormat:@"%d",val];
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
        }
        else
        {
            st=0;
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
            
        }
        }
        //////////////////////////////////////////////////////////
        
        if (![timefns isKindOfClass:[NSNull class]]&&[timefns length] > 0) {
            fns1 = [timefns substringToIndex:[timefns length] - 3];
            fns2 = [fns1 substringToIndex:[fns1 length] - 3];
        
        
        if ([fns2 integerValue]>12)
        {
            fn = 1;
            int val = [fns2 integerValue]-12;
            fns2 = [NSString stringWithFormat:@"%d",val];
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
        }
        else
        {
            fn=0;
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
            
        }
        }
        if (st==1 && fn==1)
        {
            
            wedLbl.text = [NSString stringWithFormat:@"%@ PM to %@ PM",timestrt,timefns];
        }
        else if (st==1 && fn==0)
        {
            wedLbl.text = [NSString stringWithFormat:@"%@ PM to %@ AM",timestrt,timefns];
        }
        else if (st==0 && fn==1)
        {
            wedLbl.text = [NSString stringWithFormat:@"%@ AM to %@ PM",timestrt,timefns];
        }
        else if (st==0 && fn==0)
        {
            wedLbl.text = [NSString stringWithFormat:@"%@ AM to %@ AM",timestrt,timefns];
        }
        else if ((st==-1 && fn==-1) || (st==-1 && fn==0) || (st==-1 && fn==1) || (st==0 && fn==-1) || (st==1 && fn==-1))
        {
            wedLbl.text = [NSString stringWithFormat:@"not available"];
        }
        //***********************Thuday**********************************
        timestrt= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:5]valueForKey:@"starttime"];
        timefns= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:5]valueForKey:@"closetime"];
        st =-1; fn=-1;
        if (![timestrt isKindOfClass:[NSNull class]]&&[timestrt length] > 0) {
            strt1 = [timestrt substringToIndex:[timestrt length] - 3];
            strt2 = [strt1 substringToIndex:[strt1 length] - 3];
        
        
        if ([strt2 integerValue]>12)
        {
            st =1;
            int val = [strt2 integerValue]-12;
            strt2 = [NSString stringWithFormat:@"%d",val];
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
        }
        else
        {
            
            st =0;
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
            
        }
        }
        //////////////////////////////////////////////////////////
        
        if (![timefns isKindOfClass:[NSNull class]]&&[timefns length] > 0) {
            fns1 = [timefns substringToIndex:[timefns length] - 3];
            fns2 = [fns1 substringToIndex:[fns1 length] - 3];
        
        
        if ([fns2 integerValue]>12)
        {
            fn = 1;
            int val = [fns2 integerValue]-12;
            fns2 = [NSString stringWithFormat:@"%d",val];
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
        }
        else
        {
            fn =0;
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
            
        }
        }
        if (st==1 && fn==1)
        {
            
            thuLbl.text = [NSString stringWithFormat:@"%@ PM to %@ PM",timestrt,timefns];
        }
        else if (st==1 && fn==0)
        {
            thuLbl.text = [NSString stringWithFormat:@"%@ PM to %@ AM",timestrt,timefns];
        }
        else if (st==0 && fn==1)
        {
            thuLbl.text = [NSString stringWithFormat:@"%@ AM to %@ PM",timestrt,timefns];
        }
        else if (st==0 && fn==0)
        {
            thuLbl.text = [NSString stringWithFormat:@"%@ AM to %@ AM",timestrt,timefns];
        }
        else if ((st==-1 && fn==-1) || (st==-1 && fn==0) || (st==-1 && fn==1) || (st==0 && fn==-1) || (st==1 && fn==-1))
        {
            thuLbl.text = [NSString stringWithFormat:@"not available"];
        }
        //***********************Friday**********************************
        timestrt= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:6]valueForKey:@"starttime"];
        timefns= [[[restInfoDict valueForKey:@"servicetime"]objectAtIndex:6]valueForKey:@"closetime"];
        st =-1; fn=-1;
        if (![timestrt isKindOfClass:[NSNull class]]&&[timestrt length] > 0) {
            strt1 = [timestrt substringToIndex:[timestrt length] - 3];
            strt2 = [strt1 substringToIndex:[strt1 length] - 3];
        
        
        if ([strt2 integerValue]>12)
        {
            st =1;
            int val = [strt2 integerValue]-12;
            strt2 = [NSString stringWithFormat:@"%d",val];
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
        }
        else
        {
            st =0;
            strt1 = [strt1 substringFromIndex:3];
            timestrt = [strt2 stringByAppendingString:[NSString stringWithFormat:@":%@",strt1]];
            
        }
        }
        //////////////////////////////////////////////////////////
        
        if (![timefns isKindOfClass:[NSNull class]]&&[timefns length] > 0) {
            fns1 = [timefns substringToIndex:[timefns length] - 3];
            fns2 = [fns1 substringToIndex:[fns1 length] - 3];
        
        
        if ([fns2 integerValue]>12)
        { fn=1;
            int val = [fns2 integerValue]-12;
            fns2 = [NSString stringWithFormat:@"%d",val];
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
        }
        else
        {
            fn=0;
            fns1 = [fns1 substringFromIndex:3];
            timefns = [fns2 stringByAppendingString:[NSString stringWithFormat:@":%@",fns1]];
            
        }
        }
        if (st==1 && fn==1)
        {
            
            friLbl.text = [NSString stringWithFormat:@"%@ PM to %@ PM",timestrt,timefns];
        }
        else if (st==1 && fn==0)
        {
            friLbl.text = [NSString stringWithFormat:@"%@ PM to %@ AM",timestrt,timefns];
        }
        else if (st==0 && fn==1)
        {
            friLbl.text = [NSString stringWithFormat:@"%@ AM to %@ PM",timestrt,timefns];
        }
        else if (st==0 && fn==0)
        {
            friLbl.text = [NSString stringWithFormat:@"%@ AM to %@ AM",timestrt,timefns];
        }
        else if ((st==-1 && fn==-1) || (st==-1 && fn==0) || (st==-1 && fn==1) || (st==0 && fn==-1) || (st==1 && fn==-1))
        {
            friLbl.text = [NSString stringWithFormat:@"not available"];
        }
        

    }

}
- (IBAction)dropAction:(id)sender
{
    NSLog(@"show branch");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
}
#pragma mark UITextView Delegate Method
- (void)textViewDidBeginEditing:(UITextView *)textView {
        NSLog(@"did begin editing");
    if (textView.tag==1)
    {
       NSLog(@"tag 1"); 
        appDelegate.window.transform = CGAffineTransformMakeTranslation(0.0, -100.0);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text isEqualToString:[text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]] ) {
        //appDelegate.window.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
        return YES;
    } else {
        [textView resignFirstResponder];
        appDelegate.window.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
    }
    return YES;
    return YES;
}

#pragma mark Facebook Login Delegate
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"results %@",results);
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
 NSLog(@"error %@",error);
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    if(!error){
        NSLog(@"You've Logged in");
        NSLog(@"%@", result);
        
        if ([FBSDKAccessToken currentAccessToken])
        {
            
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:@"/me"
                                          parameters:@{ @"fields": @"id,name,gender,birthday,email,friends,location,music",}
                                          HTTPMethod:@"GET"];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSLog(@"fetched user:%@", result);
                    NSLog(@"fb id %@",[result valueForKey:@"id"]);
                    
                }
            }];
            
        }
        
        
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"You've Logged out");
}

#pragma mark UITableView Delegate Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //
    //    if (!cell) {
    UITableViewCell *   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //  }
    
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    int cellcount= indexPath.row *3;
    if (count==1 && estimated_count<3)
    {
        if (estimated_count==1)
        {
            imageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(23,5, (appDelegate.window.frame.size.width/3-10), 100)];
            
            NSString *urlStr= [NSString stringWithFormat:@"http://%@",[[imagealbum_arr objectAtIndex:cellcount]valueForKey:@"imagesrc"]];
            [imageV1 setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"loading_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            tapRecognizer = [[UITapGestureRecognizer alloc]
                             initWithTarget:self action:@selector(schemeTouchedAtIndex:)];
            [tapRecognizer setNumberOfTouchesRequired:1];
            
            [tapRecognizer setDelegate:self];
            //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
            imageV1.userInteractionEnabled = YES;
            imageV1.tag=cellcount;
            [imageV1 addGestureRecognizer:tapRecognizer];
            [cell addSubview:imageV1];
            
        }
        else if (estimated_count==2)
        {
            imageV1= [[UIImageView alloc]initWithFrame:CGRectMake(23,5, (appDelegate.window.frame.size.width/3-10), 100)];
            NSString *urlStr= [NSString stringWithFormat:@"http://%@",[[imagealbum_arr objectAtIndex:cellcount]valueForKey:@"imagesrc"]];
            [imageV1 setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"loading_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            imageV1.tag=cellcount;
            tapRecognizer = [[UITapGestureRecognizer alloc]
                             initWithTarget:self action:@selector(schemeTouchedAtIndex:)];
            [tapRecognizer setNumberOfTouchesRequired:1];
            
            [tapRecognizer setDelegate:self];
            //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
            imageV1.userInteractionEnabled = YES;
            [imageV1 addGestureRecognizer:tapRecognizer];
            
            
            imageV2= [[UIImageView alloc]initWithFrame:CGRectMake((appDelegate.window.frame.size.width/3-10)+27, 5, (appDelegate.window.frame.size.width/3-10), 100)];
            
            urlStr= [NSString stringWithFormat:@"http://%@",[[imagealbum_arr objectAtIndex:(cellcount+1)]valueForKey:@"imagesrc"]];
            [imageV2 setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"loading_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            
            imageV2.tag=cellcount+1;
            tapRecognizer = [[UITapGestureRecognizer alloc]
                             initWithTarget:self action:@selector(schemeTouchedAtIndex:)];
            [tapRecognizer setNumberOfTouchesRequired:1];
            
            [tapRecognizer setDelegate:self];
            //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
            imageV2.userInteractionEnabled = YES;
            [imageV2 addGestureRecognizer:tapRecognizer];
            
            [cell addSubview:imageV1];
            [cell addSubview:imageV2];
            
        }
 
    }
    else  if (indexPath.row==estimated_count && ([imagealbum_arr count]%estimated_count)!=0)
    {
        NSLog(@"indexlast %d",indexPath.row);
        
        int val= [imagealbum_arr count]%estimated_count;
        if (val==1)
        {
            imageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(23,5, (appDelegate.window.frame.size.width/3-10), 100)];
            
            NSString *urlStr= [NSString stringWithFormat:@"http://%@",[[imagealbum_arr objectAtIndex:cellcount]valueForKey:@"imagesrc"]];
            [imageV1 setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"loading_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            tapRecognizer = [[UITapGestureRecognizer alloc]
                             initWithTarget:self action:@selector(schemeTouchedAtIndex:)];
            [tapRecognizer setNumberOfTouchesRequired:1];
            
            [tapRecognizer setDelegate:self];
            //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
            imageV1.userInteractionEnabled = YES;
            imageV1.tag=cellcount;
            [imageV1 addGestureRecognizer:tapRecognizer];
            [cell addSubview:imageV1];
           
        }
        else if (val==2)
        {
            imageV1= [[UIImageView alloc]initWithFrame:CGRectMake(23,5, (appDelegate.window.frame.size.width/3-10), 100)];
            NSString *urlStr= [NSString stringWithFormat:@"http://%@",[[imagealbum_arr objectAtIndex:cellcount]valueForKey:@"imagesrc"]];
            [imageV1 setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"loading_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

            imageV1.tag=cellcount;
            tapRecognizer = [[UITapGestureRecognizer alloc]
                             initWithTarget:self action:@selector(schemeTouchedAtIndex:)];
            [tapRecognizer setNumberOfTouchesRequired:1];
            
            [tapRecognizer setDelegate:self];
            //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
            imageV1.userInteractionEnabled = YES;
            [imageV1 addGestureRecognizer:tapRecognizer];
            
            
            imageV2= [[UIImageView alloc]initWithFrame:CGRectMake((appDelegate.window.frame.size.width/3-10)+27, 5, (appDelegate.window.frame.size.width/3-10), 100)];
            
            urlStr= [NSString stringWithFormat:@"http://%@",[[imagealbum_arr objectAtIndex:(cellcount+1)]valueForKey:@"imagesrc"]];
            [imageV2 setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"loading_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

            
                       imageV2.tag=cellcount+1;
            tapRecognizer = [[UITapGestureRecognizer alloc]
                             initWithTarget:self action:@selector(schemeTouchedAtIndex:)];
            [tapRecognizer setNumberOfTouchesRequired:1];
            
            [tapRecognizer setDelegate:self];
            //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
            imageV2.userInteractionEnabled = YES;
            [imageV2 addGestureRecognizer:tapRecognizer];
            
            [cell addSubview:imageV1];
            [cell addSubview:imageV2];
           
        }
    }
    
    else
    {
        NSLog(@"index %d",indexPath.row);
        
        imageV1= [[UIImageView alloc]initWithFrame:CGRectMake(23,5, (appDelegate.window.frame.size.width/3-10), 100)];
        
        NSString *urlStr= [NSString stringWithFormat:@"http://%@",[[imagealbum_arr objectAtIndex:cellcount]valueForKey:@"imagesrc"]];
        [imageV1 setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"loading_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //imageV1.image = [UIImage imageNamed:@"flower1.png"];
        
        imageV1.tag=cellcount;
        tapRecognizer = [[UITapGestureRecognizer alloc]
                         initWithTarget:self action:@selector(schemeTouchedAtIndex:)];
        [tapRecognizer setNumberOfTouchesRequired:1];
        
        [tapRecognizer setDelegate:self];
        //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
        imageV1.userInteractionEnabled = YES;
        [imageV1 addGestureRecognizer:tapRecognizer];
        
        
        imageV2= [[UIImageView alloc]initWithFrame:CGRectMake((appDelegate.window.frame.size.width/3-10)+27, 5, (appDelegate.window.frame.size.width/3-10), 100)];
        
        urlStr= [NSString stringWithFormat:@"http://%@",[[imagealbum_arr objectAtIndex:(cellcount+1)]valueForKey:@"imagesrc"]];
        [imageV2 setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"loading_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //imageV2.image = [UIImage imageNamed:@"flower2.png"];

       
        imageV2.tag=cellcount+1;
        tapRecognizer = [[UITapGestureRecognizer alloc]
                         initWithTarget:self action:@selector(schemeTouchedAtIndex:)];
        [tapRecognizer setNumberOfTouchesRequired:1];
        
        [tapRecognizer setDelegate:self];
        //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
        imageV2.userInteractionEnabled = YES;
        [imageV2 addGestureRecognizer:tapRecognizer];
        

        
        imageV3= [[UIImageView alloc]initWithFrame:CGRectMake(2*(appDelegate.window.frame.size.width/3-10)+32, 5, (appDelegate.window.frame.size.width/3-10), 100)];
        urlStr= [NSString stringWithFormat:@"http://%@",[[imagealbum_arr objectAtIndex:(cellcount+2)]valueForKey:@"imagesrc"]];
        [imageV3 setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"loading_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //imageV3.image = [UIImage imageNamed:@"flower3.png"];

        
        imageV3.tag=cellcount+2;
        tapRecognizer = [[UITapGestureRecognizer alloc]
                         initWithTarget:self action:@selector(schemeTouchedAtIndex:)];
        [tapRecognizer setNumberOfTouchesRequired:1];
        
        [tapRecognizer setDelegate:self];
        //Don't forget to set the userInteractionEnabled to YES, by default It's NO.
        imageV3.userInteractionEnabled = YES;
        [imageV3 addGestureRecognizer:tapRecognizer];
        
        [cell addSubview:imageV1];
        [cell addSubview:imageV2];
        [cell addSubview:imageV3];
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //cell.backgroundColor=[UIColor greenColor];

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}




- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110.0; // first row is 123px high
    
    
}
-(void)schemeTouchedAtIndex:(UITapGestureRecognizer *)gesture
{
    NSLog(@"%d", gesture.view.tag);
    
    
    
    if (gesture.view.tag==-100)
    {
        [slide_imgvw removeFromSuperview];
        [backgrView removeFromSuperview];
    }
    else
    {
        
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        popupbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [popupbutton setBackgroundImage:[UIImage imageNamed:@"trans_bg.png"] forState:UIControlStateNormal];
       // popupbutton.alpha=0.9;
        
        
        popupbutton.frame = CGRectMake(0, 0, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height);
        // popupbutton.alpha=0.8;
        
        [popupbutton addTarget:self
                        action:@selector(close_popup:)
              forControlEvents:UIControlEventTouchDown];
        [appDelegate.window addSubview:popupbutton];
        
        cross_btn=[UIButton buttonWithType:UIButtonTypeCustom];
        cross_btn.frame= CGRectMake(appDelegate.window.frame.size.width-40, 18, 20, 20);
        [cross_btn setImage:[UIImage imageNamed:@"white_cross"] forState:UIControlStateNormal];
               [cross_btn addTarget:self action:@selector(close_popup:) forControlEvents:UIControlEventTouchUpInside];
        [popupbutton addSubview:cross_btn];
        albumcontainerVw= [[UIScrollView alloc]init];
       //
        albumcontainerVw= [imageArr objectAtIndex:gesture.view.tag];
        
        currenttag=  (int)gesture.view.tag;
         //[popupbutton addSubview:slide_imgvw];
        for (UIView *i in albumcontainerVw.subviews){
            if([i isKindOfClass:[UIImageView class]]){
                imgContainer = (UIImageView *)i;
                NSLog(@"enter");
                
            }
        }

        
        [popupbutton addSubview:albumcontainerVw];

        [popupbutton setHidden:NO];
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:0.50];
        [popupbutton setFrame:CGRectMake(0,0,popupbutton.frame.size.width, popupbutton.frame.size.height)];
        
        [UIView commitAnimations];
    }
   // imageArr = [[NSArray alloc] initWithObjects:@"0.tiff",@"1.tiff",@"2.tiff",@"3.tiff",@"4.tiff",@"5.tiff",@"6.tiff",@"7.tiff",nil];
    
   }

-(BOOL)close_popup:(id)sender
{
    
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

-(void)schemeSwipeAtIndex:(UISwipeGestureRecognizer *)gesture
{
    
    
    //  NSLog(@"right %d",gesture.view.tag);
    
    CGAffineTransform transform2 = CGAffineTransformMakeScale(1.0, 1.0);
    gesture.view.transform = transform2;
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        
        if (gesture.view.tag<([imageArr count]-1))
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            //[popupbutton.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [popupbutton removeFromSuperview];
            ///////////////////////////////////////////////////////////
            appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            popupbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [popupbutton setBackgroundImage:[UIImage imageNamed:@"trans_bg.png"] forState:UIControlStateNormal];
            // popupbutton.alpha=0.9;
            
            
            popupbutton.frame = CGRectMake(0, 0, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height);
            // popupbutton.alpha=0.8;
            
            [popupbutton addTarget:self
                            action:@selector(close_popup:)
                  forControlEvents:UIControlEventTouchDown];
            [appDelegate.window addSubview:popupbutton];
            
            cross_btn=[UIButton buttonWithType:UIButtonTypeCustom];
            cross_btn.frame= CGRectMake(appDelegate.window.frame.size.width-40, 18, 20, 20);
            [cross_btn setImage:[UIImage imageNamed:@"white_cross"] forState:UIControlStateNormal];
            [cross_btn addTarget:self action:@selector(close_popup:) forControlEvents:UIControlEventTouchUpInside];
            [popupbutton addSubview:cross_btn];
            [popupbutton.layer addAnimation:transition forKey:nil];
            albumcontainerVw= [[UIScrollView alloc]init];
            //
            albumcontainerVw= [imageArr objectAtIndex:(gesture.view.tag+1)];
            
            currenttag=  (int)gesture.view.tag+1;
            NSLog(@"current %d",currenttag);
            //[popupbutton addSubview:slide_imgvw];
            
            UIImageView *test;
            
            //imgContainer = [[UIImageView alloc]init];
            for (UIView *i in albumcontainerVw.subviews){
                if([i isKindOfClass:[UIImageView class]]){
                    test = (UIImageView *)i;
                    
                    
                }
            }
            imgContainer=test;
            
            /*
            imgContainer = [[UIImageView alloc]init];
            for (UIView *i in albumcontainerVw.subviews){
                if([i isKindOfClass:[UIImageView class]]){
                    imgContainer = (UIImageView *)i;
                    
                    
                }
            }
            */
            
            [popupbutton addSubview:albumcontainerVw];
            //////////////////////////////////////////////////////////
            /*
            [popupbutton.layer addAnimation:transition forKey:nil];
            
            
            //[gesture.view removeFromSuperview];
            albumcontainerVw= [[UIScrollView alloc]init];
            albumcontainerVw= [imageArr objectAtIndex:(gesture.view.tag+1)];
            [popupbutton addSubview:albumcontainerVw];
            */
            
    
            
  
            
        }
        
    }
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"right");
        if (gesture.view.tag>0)
        {
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [popupbutton removeFromSuperview];
            ///////////////////////////////////////////////////////////
            appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            popupbutton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [popupbutton setBackgroundImage:[UIImage imageNamed:@"trans_bg.png"] forState:UIControlStateNormal];
            // popupbutton.alpha=0.9;
            
            
            popupbutton.frame = CGRectMake(0, 0, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height);
            // popupbutton.alpha=0.8;
            
            [popupbutton addTarget:self
                            action:@selector(close_popup:)
                  forControlEvents:UIControlEventTouchDown];
            [appDelegate.window addSubview:popupbutton];
            
            cross_btn=[UIButton buttonWithType:UIButtonTypeCustom];
            cross_btn.frame= CGRectMake(appDelegate.window.frame.size.width-40, 18, 20, 20);
            [cross_btn setImage:[UIImage imageNamed:@"white_cross"] forState:UIControlStateNormal];
            [cross_btn addTarget:self action:@selector(close_popup:) forControlEvents:UIControlEventTouchUpInside];
            [popupbutton addSubview:cross_btn];
            [popupbutton.layer addAnimation:transition forKey:nil];
            albumcontainerVw= [[UIScrollView alloc]init];
            //
            
            albumcontainerVw= [imageArr objectAtIndex:(gesture.view.tag-1)];
            
            currenttag=  (int)gesture.view.tag-1;
            NSLog(@"current %d",currenttag);
            //[popupbutton addSubview:slide_imgvw];
            UIImageView *test;
            
            //imgContainer = [[UIImageView alloc]init];
            for (UIView *i in albumcontainerVw.subviews){
                if([i isKindOfClass:[UIImageView class]]){
                    test = (UIImageView *)i;
                    
                    
                }
            }
            imgContainer=test;
           
            [popupbutton addSubview:albumcontainerVw];
            //////////////////////////////////////////////////////////
            /*
            [popupbutton.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [popupbutton.layer addAnimation:transition forKey:nil];
            //[gesture.view removeFromSuperview];
            
            albumcontainerVw= [[UIScrollView alloc]init];
            albumcontainerVw= [imageArr objectAtIndex:(gesture.view.tag-1)];
           // imgContainer = [[UIImageView alloc]init];
            [popupbutton addSubview:albumcontainerVw];
            
            
             */
        }
             
        
        
    }
    
}
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    
    //NSLog(@"Pinch scale: %f", recognizer.scale);
    CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
    recognizer.view.transform = transform;
   
    if (recognizer.scale>MINIMUM_SCALE && recognizer.scale<MAXIMUM_SCALE)
    {
        recognizer.view.transform = transform;
     }
    
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        if (recognizer.scale<1.0)
        {
            recognizer.view.transform= CGAffineTransformIdentity;
        }
    }
    //CGAffineTransform transform2 = CGAffineTransformMakeScale(1.0, 1.0);
    //recognizer.view.transform = transform2;
    
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"scroll %d",scrollView.tag);
    for (UIImageView *iv in [scrollView subviews]) {
        imgContainer = iv;
        break;
    }
    
        return imgContainer;
   // return [imageArr objectAtIndex:currenttag];
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"Pinch scale: %f", scale);
    
   
    if (scale<1.5)
    {
        scrollView.frame= CGRectMake(appDelegate.window.frame.size.width/2-slide_imgvw.frame.size.width/2, appDelegate.window.frame.size.height/2-slide_imgvw.frame.size.height/2, slide_imgvw.frame.size.width, slide_imgvw.frame.size.height);
     [scrollView setZoomScale:1.0f];
    }
    
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
//[scrollView setContentSize:CGSizeMake(scale*320, scale*1700)];
    scrollView.frame= CGRectMake(0, 0, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height);
}
- (IBAction)post_review_action:(id)sender
{
    
    appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
    appDelegate.window.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
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
        NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
        
        NSString *regUrl = [NSString stringWithFormat:@"%@",BaseURLString];
        NSLog(@"userid rest %@",[prefs valueForKey:@"userid"]);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:regUrl
         
           parameters:@{
                        @"tag":@"insertreview",@"userid":[prefs valueForKey:@"userid"],@"resturantid":[prefs valueForKey:@"current_restid"],@"reviewtext":review_txtvw.text
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary *jsondict=responseObject;
             
             if (![jsondict isKindOfClass:[NSNull class]])
             {
                 @try {
                     
                     if ([[jsondict valueForKey:@"success"]integerValue]==1)
                     {
                         // NSLog(@"allrest response %@",jsondict);
                         
                         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                         [wreview_btn setBackgroundImage:[UIImage imageNamed:@"green_review"] forState:UIControlStateNormal];
                         review_lbl.text = @"Reviewed";
                         [backgrView removeFromSuperview];
                         [wrview_vew removeFromSuperview];
                         
                         
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
}

- (IBAction)edit_profile:(id)sender
{
    EditProfileViewController *dash = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:dash animated:YES];

}

- (IBAction)info_action:(id)sender {
    rest_scroll.contentSize = CGSizeMake(rest_scroll.frame.size.width, 1200);
    [info_btn setBackgroundImage:[UIImage imageNamed:@"info_select"] forState:UIControlStateNormal];
    [menu_btn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [review_btn setBackgroundImage:[UIImage imageNamed:@"review"] forState:UIControlStateNormal];
    [photo_btn setBackgroundImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    [map_btn setBackgroundImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    [rest_scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setInfo];

    
}

- (IBAction)menu_action:(id)sender {
    rest_scroll.contentSize = CGSizeMake(rest_scroll.frame.size.width, 1200);
    [menu_btn setBackgroundImage:[UIImage imageNamed:@"menu_select"] forState:UIControlStateNormal];
    [info_btn setBackgroundImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    [review_btn setBackgroundImage:[UIImage imageNamed:@"review"] forState:UIControlStateNormal];
    [photo_btn setBackgroundImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    [map_btn setBackgroundImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    [rest_scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [rest_scroll addSubview:photoVw];
    
    appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@" NO internet connection");
        [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"No Internet Connection"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSLog(@"Yes internet connection");
        
        [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
        NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
        NSLog(@" %@",[prefs valueForKey:@"current_restid"]);
        NSString *regUrl = [NSString stringWithFormat:@"%@",BaseURLString];
        NSLog(@"url %@",regUrl);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:regUrl
         
           parameters:@{
                        @"tag":@"imageurl",@"resturantid":[prefs valueForKey:@"current_restid"],@"imagetype":@"2"
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary *jsondict=responseObject;
             
             if (![jsondict isKindOfClass:[NSNull class]])
             {
                 @try {
                     
                     if ([[jsondict valueForKey:@"success"]integerValue]==1)
                     {
                         // NSLog(@"allrest response %@",jsondict);
                         
                         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                         imagealbum_arr= [[NSMutableArray alloc]init];
                         imagealbum_arr = [[jsondict valueForKey:@"imagedata"]mutableCopy];
                         NSLog(@"total count %d",[imagealbum_arr count]);
                         NSString *value=[NSString stringWithFormat:@"%d",[imagealbum_arr count]/3];
                         
                         count = [ value integerValue];
                       //  NSLog(@"value %d",count);
                         if (count!=0) {
                            
                         if ([imagealbum_arr count]%count>0)
                         {
                             
                             estimated_count=count;
                             count++;
                             
                         }
                         else
                         {
                             estimated_count=count;
                             
                         }
                         }
                             else
                             {
                                 count=1;
                                 estimated_count=[imagealbum_arr count];
                             }
                         NSLog(@"final count %d estimated %d",count,estimated_count);
                         
                         photo_tbl.frame = CGRectMake(photo_tbl.frame.origin.x, photo_tbl.frame.origin.y, appDelegate.window.frame.size.width, photo_tbl.frame.size.height);
                          imageArr = [[NSMutableArray alloc]init];
                         for (int i=0; i<[imagealbum_arr count]; i++)
                         {
                             
                             appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
                             
                             containerview = [[UIScrollView alloc]initWithFrame:CGRectMake(appDelegate.window.frame.size.width/2-slide_imgvw.frame.size.width/2, appDelegate.window.frame.size.height/2-slide_imgvw.frame.size.height/2, slide_imgvw.frame.size.width, slide_imgvw.frame.size.height)];
                             
                             
                             
                             imgVw = [[UIImageView alloc]initWithFrame:CGRectMake(0,0 , containerview.frame.size.width, containerview.frame.size.height)];
                             NSString *urlStr= [NSString stringWithFormat:@"http://%@",[[imagealbum_arr objectAtIndex:i]valueForKey:@"imagesrc"]];
                             [imgVw setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"loading_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                             
                             //imgVw.image= [UIImage imageNamed:[nameArr objectAtIndex:i]];
                             
                             swipeRecognizerLeft = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(schemeSwipeAtIndex:)];
                             //containerview.tag=i;
                             imgVw.tag=i;
                             
                             [swipeRecognizerLeft setDelegate:self];
                             [swipeRecognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
                             imgVw.userInteractionEnabled = YES;
                             [imgVw addGestureRecognizer:swipeRecognizerLeft];
                             
                             //////////////
                             swipeRecognizerRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(schemeSwipeAtIndex:)];
                             
                             
                             [swipeRecognizerRight setDelegate:self];
                             [swipeRecognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
                             imgVw.userInteractionEnabled = YES;
                             [imgVw addGestureRecognizer:swipeRecognizerRight];
                             
                             UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc]
                                                                         initWithTarget:self
                                                                         action:@selector(twoFingerPinch:)]
                             ;
                             
                             //[imgVw addGestureRecognizer:twoFingerPinch];
                             
                             pageControl = [[UIPageControl alloc] init];
                             pageControl.frame = CGRectMake(0,imgVw.frame.size.height , containerview.frame.size.width, 37);
                             pageControl.numberOfPages = 3;
                             pageControl.currentPage = i;
                             pageControl.tintColor = [UIColor whiteColor];
                             pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(255/255.0) green:(51/255.0) blue:(0/255.0) alpha:1.0];
                             //[self.view addSubview:pageControl];
                             //pageControl.backgroundColor = [UIColor redColor];
                             // containerview.userInteractionEnabled=YES;
                             
                             
                             
                             
                             [containerview addSubview:imgVw];
                             containerview.tag=i;
                             containerview.contentSize = imgVw.bounds.size;
                             containerview.scrollEnabled=YES;
                             float minScale  = containerview.frame.size.width  / imgVw.frame.size.width;
                             containerview.minimumZoomScale = MINIMUM_SCALE;
                             containerview.maximumZoomScale = MAXIMUM_SCALE;
                             containerview.zoomScale = minScale;
                             containerview.delegate=self;
                             //[containerview addSubview:pageControl];
                             [imageArr addObject:containerview];
                             
                         }
                         
                         [photo_tbl reloadData];
                         [rest_scroll addSubview:photoVw];
                     }
                     
                     
                     else
                     {
                         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                         photo_tbl.frame = CGRectMake(photo_tbl.frame.origin.x, photo_tbl.frame.origin.y, appDelegate.window.frame.size.width, photo_tbl.frame.size.height);
                         
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
    

}

- (IBAction)review_action:(id)sender {
    [review_btn setBackgroundImage:[UIImage imageNamed:@"review_select"] forState:UIControlStateNormal];
    [info_btn setBackgroundImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    [menu_btn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [photo_btn setBackgroundImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    [map_btn setBackgroundImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    //[info_view removeFromSuperview];
    //[mapView removeFromSuperview];
    [rest_scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@" NO internet connection");
        [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"No Internet Connection"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSLog(@"Yes internet connection");
        
        [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
        NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
        NSLog(@" %@",[prefs valueForKey:@"current_restid"]);
        NSString *regUrl = [NSString stringWithFormat:@"%@",BaseURLString];
        NSLog(@"url %@",regUrl);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:regUrl
         
           parameters:@{
                        @"tag":@"resturantreview",@"resturantid":[prefs valueForKey:@"current_restid"]
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary *jsondict=responseObject;
             
             if (![jsondict isKindOfClass:[NSNull class]])
             {
                 @try {
                     
                     if ([[jsondict valueForKey:@"success"]integerValue]==1)
                     {
                         // NSLog(@"allrest response %@",jsondict);
                         
                         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                         int lastpos=0;
                    
                         NSMutableArray *reviewDataArr= [[NSMutableArray alloc]init];
                         reviewDataArr = [[jsondict valueForKey:@"reviewdata"]mutableCopy];
                         for (int i=0; i<[reviewDataArr count]; i++) {
                             
    
                         review_imgVw = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, lastpos+20.0, 40.0, 40.0)];
                             NSString *urlStr= [NSString stringWithFormat:@"http://%@",[[reviewDataArr objectAtIndex:i]valueForKey:@"imagesrc"]];
                        [review_imgVw setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"loading_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                             review_imgVw.layer.cornerRadius = review_imgVw.frame.size.height /2;
                             review_imgVw.layer.masksToBounds = YES;
                             
                             reviewer_name = [[UILabel alloc]initWithFrame:CGRectMake(55.0, lastpos+20.0, 200.0, 15.0)];
                             reviewer_name.text = [NSString stringWithFormat:@"%@",[[reviewDataArr objectAtIndex:i]valueForKey:@"fullname"]];
                             reviewer_name.font=[UIFont fontWithName:@"OpenSans-Semibold" size:11.0];
                             
                             NSDate *dateA=[NSDate date];
                             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                             dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                             NSDate *dateB= [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",[[reviewDataArr objectAtIndex:i]valueForKey:@"time"] ]];
                             NSString *date = [dateFormatter stringFromDate:dateA]; // Convert date to string
                             NSLog(@"date :%@",date);

                             
                             NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
                             NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                                        fromDate:dateB
                                                                          toDate:dateA
                                                                         options:0];
                             
                             NSLog(@"Difference in date components: yr %i/mnth %i/ day %i/hr %i/min %i/ sec %i",components.year,components.month, components.day, components.hour, components.minute,components.second);
                             
                             review_time = [[UILabel alloc]initWithFrame:CGRectMake(55.0, lastpos+37.0, 200.0, 15.0)];
                             if (components.year>0)
                             {
                                 if (components.year==1) {
                                     review_time.text = @"1 year ago";
                                 }
                                 else
                                 review_time.text =[NSString stringWithFormat:@"%i years ago",components.year];
                             }
                             else if (components.month>0)
                             {
                                 if (components.month==1) {
                                     review_time.text = @"1 month ago";
                                 }
                                 else
                                     review_time.text = [NSString stringWithFormat:@"%i months ago",components.month];
                             }
                             else if (components.day>0)
                             {
                                 if (components.day==1) {
                                     review_time.text = @"1 day ago";
                                 }
                                 else
                                     review_time.text = [NSString stringWithFormat:@"%i days ago",components.day];
                             }
                             else if (components.hour>0)
                             {
                                 if (components.hour==1) {
                                     review_time.text = @"1 hour ago";
                                 }
                                 else
                                     review_time.text = [NSString stringWithFormat:@"%i hours ago",components.hour];
                             }
                             else if (components.minute>0)
                             {
                                 if (components.minute==1) {
                                     review_time.text = @"1 minute ago";
                                 }
                                 else
                                     review_time.text = [NSString stringWithFormat:@"%i minutes ago",components.minute];
                             }
                             else if (components.second>0)
                             {
                                 if (components.second==1) {
                                     review_time.text = @"1 second ago";
                                 }
                                 else
                                     review_time.text = [NSString stringWithFormat:@"%i seconds ago",components.second];
                             }
                             //review_time.text = [NSString stringWithFormat:@"%@",[[reviewDataArr objectAtIndex:i]valueForKey:@"fullname"]];
                             review_time.font=[UIFont fontWithName:@"OpenSans-Semibold" size:9.0];
                             review_time.textColor=[UIColor colorWithRed:(2.0/255.0) green:(181.0/255.0) blue:(77.0/255.0) alpha:1.0];
                             //2,181,77
                             review_text = [[UITextView alloc]initWithFrame:CGRectMake(10.0, lastpos+20.0+43, 280.0, 50.0)];
                             review_text.delegate=self;
                             review_text.text = [NSString stringWithFormat:@"%@",[[reviewDataArr objectAtIndex:i]valueForKey:@"reviewtext"]];
                             review_text.font=[UIFont fontWithName:@"OpenSans-Regular" size:10.0];
                             lastpos = lastpos + 20+45+50;
                             [rest_scroll addSubview: review_imgVw];
                             [rest_scroll addSubview:reviewer_name];
                             [rest_scroll addSubview: review_text];
                             [rest_scroll addSubview:review_time];
                             
                         }
                         rest_scroll.contentSize = CGSizeMake(rest_scroll.frame.size.width, lastpos+300);
                         
                     }
                     
                     
                     else
                     {
                       [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                         
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

    
    
}

- (IBAction)photo_action:(id)sender {
    rest_scroll.contentSize = CGSizeMake(rest_scroll.frame.size.width, 1200);
    
    [photo_btn setBackgroundImage:[UIImage imageNamed:@"photo_select"] forState:UIControlStateNormal];
    [info_btn setBackgroundImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    [review_btn setBackgroundImage:[UIImage imageNamed:@"review"] forState:UIControlStateNormal];
    [menu_btn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [map_btn setBackgroundImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    [rest_scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   // [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
    
    
    [rest_scroll addSubview:photoVw];
    
    appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@" NO internet connection");
        [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:@"No Internet Connection"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        NSLog(@"Yes internet connection");
        
        [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
        NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
        NSLog(@" %@",[prefs valueForKey:@"current_restid"]);
        NSString *regUrl = [NSString stringWithFormat:@"%@",BaseURLString];
        NSLog(@"url %@",regUrl);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:regUrl
         
           parameters:@{
                        @"tag":@"imageurl",@"resturantid":[prefs valueForKey:@"current_restid"],@"imagetype":@"1"
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary *jsondict=responseObject;
             
             if (![jsondict isKindOfClass:[NSNull class]])
             {
                 @try {
                     
                     if ([[jsondict valueForKey:@"success"]integerValue]==1)
                     {
                         // NSLog(@"allrest response %@",jsondict);
                         
                         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                         imagealbum_arr= [[NSMutableArray alloc]init];
                         imagealbum_arr = [[jsondict valueForKey:@"imagedata"]mutableCopy];
                         NSLog(@"total count %d",[imagealbum_arr count]);
                         NSString *value=[NSString stringWithFormat:@"%d",[imagealbum_arr count]/3];
                         count = [ value integerValue];
                         if (count!=0) {
                             
                             if ([imagealbum_arr count]%count>0)
                             {
                                 
                                 estimated_count=count;
                                 count++;
                                 
                             }
                             else
                             {
                                 estimated_count=count;
                                 
                             }
                         }
                         else
                         {
                             count=1;
                             estimated_count=[imagealbum_arr count];
                         }
                         NSLog(@"final count %d estimated %d",count,estimated_count);
                         
                         photo_tbl.frame = CGRectMake(photo_tbl.frame.origin.x, photo_tbl.frame.origin.y, appDelegate.window.frame.size.width, photo_tbl.frame.size.height);
                        // imageArr = [[NSMutableArray alloc]init];
                         imageArr = [[NSMutableArray alloc]init];
                         for (int i=0; i<[imagealbum_arr count]; i++)
                         {
                           
                       appDelegate= (AppDelegate *) [[UIApplication sharedApplication]delegate];
                             
                             containerview = [[UIScrollView alloc]initWithFrame:CGRectMake(appDelegate.window.frame.size.width/2-slide_imgvw.frame.size.width/2, appDelegate.window.frame.size.height/2-slide_imgvw.frame.size.height/2, slide_imgvw.frame.size.width, slide_imgvw.frame.size.height)];
                             
                             
                             
                             imgVw = [[UIImageView alloc]initWithFrame:CGRectMake(0,0 , containerview.frame.size.width, containerview.frame.size.height)];
                             NSString *urlStr= [NSString stringWithFormat:@"http://%@",[[imagealbum_arr objectAtIndex:i]valueForKey:@"imagesrc"]];
                             [imgVw setImageWithURL:[NSURL URLWithString:urlStr]placeholderImage:[UIImage imageNamed:@"loading_bg.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

                             //imgVw.image= [UIImage imageNamed:[nameArr objectAtIndex:i]];
                             
                             swipeRecognizerLeft = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(schemeSwipeAtIndex:)];
                             //containerview.tag=i;
                             imgVw.tag=i;
                             
                             [swipeRecognizerLeft setDelegate:self];
                             [swipeRecognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
                             imgVw.userInteractionEnabled = YES;
                             [imgVw addGestureRecognizer:swipeRecognizerLeft];
                             
                             //////////////
                             swipeRecognizerRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(schemeSwipeAtIndex:)];
                             
                             
                             [swipeRecognizerRight setDelegate:self];
                             [swipeRecognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
                             imgVw.userInteractionEnabled = YES;
                             [imgVw addGestureRecognizer:swipeRecognizerRight];
                             
                             UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc]
                                                                         initWithTarget:self
                                                                         action:@selector(twoFingerPinch:)]
                             ;
                             
                            //[imgVw addGestureRecognizer:twoFingerPinch];

                             pageControl = [[UIPageControl alloc] init];
                             pageControl.frame = CGRectMake(0,imgVw.frame.size.height , containerview.frame.size.width, 37);
                             pageControl.numberOfPages = 3;
                             pageControl.currentPage = i;
                             pageControl.tintColor = [UIColor whiteColor];
                             pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(255/255.0) green:(51/255.0) blue:(0/255.0) alpha:1.0];
                             //[self.view addSubview:pageControl];
                             //pageControl.backgroundColor = [UIColor redColor];
                            // containerview.userInteractionEnabled=YES;
                             
                             
                             
                             
                             [containerview addSubview:imgVw];
                             containerview.tag=i;
                             containerview.contentSize = imgVw.bounds.size;
                             containerview.scrollEnabled=YES;
                             float minScale  = containerview.frame.size.width  / imgVw.frame.size.width;
                             containerview.minimumZoomScale = MINIMUM_SCALE;
                             containerview.maximumZoomScale = MAXIMUM_SCALE;
                             containerview.zoomScale = minScale;
                             containerview.delegate=self;
                             //[containerview addSubview:pageControl];
                             [imageArr addObject:containerview];
                             
                         }

                         [photo_tbl reloadData];
                         [rest_scroll addSubview:photoVw];
                     }
                     
                     
                     else
                     {
                        [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                         photo_tbl.frame = CGRectMake(photo_tbl.frame.origin.x, photo_tbl.frame.origin.y, appDelegate.window.frame.size.width, photo_tbl.frame.size.height);
                         
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
    

}

- (IBAction)map_action:(id)sender {
    [map_btn setBackgroundImage:[UIImage imageNamed:@"map_select"] forState:UIControlStateNormal];
    [info_btn setBackgroundImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    [review_btn setBackgroundImage:[UIImage imageNamed:@"review"] forState:UIControlStateNormal];
    [photo_btn setBackgroundImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    [menu_btn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [rest_scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createMap];

}

- (IBAction)like_action:(id)sender
{
    if ([[restInfoDict valueForKey:@"like"]integerValue]==0) {
        like=1;
    }
    else
        like = 0;
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
    NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    
    NSString *regUrl = [NSString stringWithFormat:@"%@",BaseURLString];
    NSLog(@"url %@",regUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:regUrl
     
       parameters:@{
                    @"tag":@"likeinsert",@"userid":[prefs valueForKey:@"userid"],@"resturantid":[prefs valueForKey:@"current_restid"],@"like":[NSString stringWithFormat:@"%d",like]
                    }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         NSDictionary *jsondict=responseObject;
         
         if (![jsondict isKindOfClass:[NSNull class]])
         {
             @try {
                 
                 if ([[jsondict valueForKey:@"success"]integerValue]==1)
                 {
                     // NSLog(@"allrest response %@",jsondict);
                     
                     [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                     if (like==1) {
                        
                         [like_btn setBackgroundImage:[UIImage imageNamed:@"green_like"] forState:UIControlStateNormal];
                         like_lbl.text = @"Liked";
                         [restInfoDict setValue:@"1" forKey:@"like"];
                     }
                     else
                     {
                         [like_btn setBackgroundImage:[UIImage imageNamed:@"red_like"] forState:UIControlStateNormal];
                         like_lbl.text = @"Like";
                         [restInfoDict setValue:@"0" forKey:@"like"];
                     }
                     
                     
                 }
                 
                 
                 else
                 {
                     [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                     
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
   
}

- (IBAction)write_review:(id)sender
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    backgrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    backgrView.backgroundColor = [UIColor blackColor];
    backgrView.alpha = 0.6;
    [[appDelegate window] addSubview:backgrView];
    wrview_vew.frame = CGRectMake(appDelegate.window.frame.size.width/2-wrview_vew.frame.size.width/2, appDelegate.window.frame.size.height/2-wrview_vew.frame.size.height/2, wrview_vew.frame.size.width, wrview_vew.frame.size.height);
    [appDelegate.window addSubview:wrview_vew];
    
}

- (IBAction)rate_action:(id)sender
{
  
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    backgrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    backgrView.backgroundColor = [UIColor blackColor];
    backgrView.alpha = 0.6;
    [[appDelegate window] addSubview:backgrView];
    rate_view.frame = CGRectMake(appDelegate.window.frame.size.width/2-rate_view.frame.size.width/2, appDelegate.window.frame.size.height/2-rate_view.frame.size.height/2, rate_view.frame.size.width, rate_view.frame.size.height);

    if ([[restInfoDict valueForKey:@"rating1"]integerValue]==-1 && [[restInfoDict valueForKey:@"rating2"]integerValue]==-1 &&[[restInfoDict valueForKey:@"rating3"]integerValue]==-1 && [[restInfoDict valueForKey:@"rating4"]integerValue]==-1)
    {
        
    RateView* rv = [RateView rateViewWithRating:2.5f];
    rv.delegate=self;
     
     // Extra frames width, height ignored
    // rv.frame = CGRectMake(13, 70, 2000, 700);
        rv.frame = CGRectMake(13, 70, rate_view.frame.size.width, 40);
        //[rv sizeToFit];
     
     // Responsive to star size
     rv.starSize = 40;
    
    
        // Customizable border color
    rv.starBorderColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
    
    // Customizable star normal color
    rv.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
    
    // Customizable star fill color
    rv.starFillColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
    
    
    rv.starFillMode = StarFillModeHorizontal;
     
     // Change rating whenever needed
    // rv.rating = 2.5f;
    rv.step=0.5f;
     
     // Can Rate (User Interaction, as needed)
     rv.canRate = YES;
    rv.tag=0;
        quality_rating= rv.rating;
   [rate_view addSubview:rv];
    /////////////////////////////////////
    RateView* rv1 = [RateView rateViewWithRating:2.5f];
    rv1.delegate=self;
    
    // Extra frames width, height ignored
    rv1.frame = CGRectMake(13, 135, rate_view.frame.size.width, 40);
    
    // Responsive to star size
    rv1.starSize = 40;
    
    
    // Customizable border color
    rv1.starBorderColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
    
    // Customizable star normal color
    rv1.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
    
    // Customizable star fill color
    rv1.starFillColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
    
    rv1.starFillMode = StarFillModeHorizontal;
    
    // Change rating whenever needed
    // rv.rating = 2.5f;
    rv1.step=0.5f;
    
    // Can Rate (User Interaction, as needed)
    rv1.canRate = YES;
    rv1.tag=1;
        service_rating= rv1.rating;
    [rate_view addSubview:rv1];
    //////////////////////////////
    RateView* rv2 = [RateView rateViewWithRating:2.5f];
    rv2.delegate=self;
    
    // Extra frames width, height ignored
    rv2.frame = CGRectMake(13, 200, rate_view.frame.size.width, 40);
    
    // Responsive to star size
    rv2.starSize = 40;
    
    
    rv2.starBorderColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
    
    // Customizable star normal color
    rv2.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
    
    // Customizable star fill color
    rv2.starFillColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
    
    
    rv2.starFillMode = StarFillModeHorizontal;
    
    // Change rating whenever needed
    // rv.rating = 2.5f;
    rv2.step=0.5f;
    
    // Can Rate (User Interaction, as needed)
    rv2.canRate = YES;
    rv2.tag=2;
        value_rating= rv2.rating;
    [rate_view addSubview:rv2];
    ///////////////////////////////////
    RateView* rv3 = [RateView rateViewWithRating:2.5f];
    rv3.delegate=self;
    
    // Extra frames width, height ignored
    rv3.frame = CGRectMake(13, 268, rate_view.frame.size.width, 40);
    
    // Responsive to star size
    rv3.starSize = 40;
    
    
    // Customizable border color
    rv3.starBorderColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
    
    // Customizable star normal color
    rv3.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
    
    // Customizable star fill color
    rv3.starFillColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
    
    rv3.starFillMode = StarFillModeHorizontal;
    
    // Change rating whenever needed
    // rv.rating = 2.5f;
    rv3.step=0.5f;
    
    // Can Rate (User Interaction, as needed)
    rv3.canRate = YES;
    rv3.tag=3;
        environment_rating= rv3.rating;
    [rate_view addSubview:rv3];
    }
    else
    {
    
        RateView* rv = [RateView rateViewWithRating:[[restInfoDict valueForKey:@"rating1"]floatValue]];
        rv.delegate=self;
        
        // Extra frames width, height ignored
        rv.frame = CGRectMake(13, 70, rate_view.frame.size.width, 40);
       // [rv sizeToFit];
        
        // Responsive to star size
        rv.starSize = 40;
    
        rv.starFillMode = StarFillModeHorizontal;
        
        // Change rating whenever needed
        // rv.rating = 2.5f;
        rv.step=0.5f;
        
        // Can Rate (User Interaction, as needed)
        rv.canRate = YES;
        rv.tag=0;
        [self setRating:rv];
        quality_rating= rv.rating;
        [rate_view addSubview:rv];
        /////////////////////////////////////
        RateView* rv1 = [RateView rateViewWithRating:[[restInfoDict valueForKey:@"rating2"]floatValue]];
        rv1.delegate=self;
        
        // Extra frames width, height ignored
        rv1.frame = CGRectMake(13, 135, rate_view.frame.size.width, 40);
        
        // Responsive to star size
        rv1.starSize = 40;
        
        rv1.starFillMode = StarFillModeHorizontal;
        
        // Change rating whenever needed
        // rv.rating = 2.5f;
        rv1.step=0.5f;
        
        // Can Rate (User Interaction, as needed)
        rv1.canRate = YES;
        rv1.tag=1;
        [self setRating:rv1];
        service_rating= rv1.rating;
        [rate_view addSubview:rv1];
        //////////////////////////////
        RateView* rv2 = [RateView rateViewWithRating:[[restInfoDict valueForKey:@"rating3"]floatValue]];
        rv2.delegate=self;
        
        // Extra frames width, height ignored
        rv2.frame = CGRectMake(13, 200, rate_view.frame.size.width, 40);
        
        // Responsive to star size
        rv2.starSize = 40;
        
        rv2.starFillMode = StarFillModeHorizontal;
        
        // Change rating whenever needed
        // rv.rating = 2.5f;
        rv2.step=0.5f;
        
        // Can Rate (User Interaction, as needed)
        rv2.canRate = YES;
        rv2.tag=2;
        [self setRating:rv2];
        value_rating= rv2.rating;
        [rate_view addSubview:rv2];
        ///////////////////////////////////
        RateView* rv3 = [RateView rateViewWithRating:[[restInfoDict valueForKey:@"rating1"]floatValue]];
        rv3.delegate=self;
        
        // Extra frames width, height ignored
        rv3.frame = CGRectMake(13, 268, rate_view.frame.size.width, 40);
        
        // Responsive to star size
        rv3.starSize = 40;
        
        rv3.starFillMode = StarFillModeHorizontal;
        
        // Change rating whenever needed
        // rv.rating = 2.5f;
        rv3.step=0.5f;
        
        // Can Rate (User Interaction, as needed)
        rv3.canRate = YES;
        rv3.tag=3;
        [self setRating:rv3];
        environment_rating= rv3.rating;
        [rate_view addSubview:rv3];
    }
   
    [appDelegate.window addSubview:rate_view];

    }
-(void)setRating:(RateView*)rateView
{
    if (rateView.tag==0)
    {
        
        if (rateView.rating==0.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==1.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==1.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==2.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==2.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==3.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==3.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==4.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==4.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==5.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
    }
    
    if (rateView.tag==1)
    {
        
        if (rateView.rating==0.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==1.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==1.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==2.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==2.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==3.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==3.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==4.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==4.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==5.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
    }
    if (rateView.tag==2)
    {
        
        if (rateView.rating==0.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==1.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==1.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==2.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==2.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==3.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==3.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==4.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==4.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==5.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
    }
    if (rateView.tag==3)
    {
        
        if (rateView.rating==0.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==1.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==1.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==2.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==2.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==3.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==3.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==4.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==4.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rateView.rating==5.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
    }
 
}
-(void)rateView:(RateView*)rateView didUpdateRating:(float)rating
{
   
    NSLog(@"rateViewDidUpdateRating: %.1f", rating);
    if (rateView.tag==0)
    {
 
    if (rating==0.5)
    {
        // Customizable border color
        rateView.starBorderColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
        
        // Customizable star normal color
        rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
        
        // Customizable star fill color
        rateView.starFillColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
        
        // Customizable star fill mode
        
    }
    if (rating==1.0)
    {
        // Customizable border color
        rateView.starBorderColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
        
        // Customizable star normal color
        rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
        
        // Customizable star fill color
        rateView.starFillColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
        
        // Customizable star fill mode
        
    }
    if (rating==1.5)
    {
        // Customizable border color
        rateView.starBorderColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
        
        // Customizable star normal color
        rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
        
        // Customizable star fill color
        rateView.starFillColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
        
        // Customizable star fill mode
        
    }
    if (rating==2.0)
    {
        // Customizable border color
        rateView.starBorderColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
        
        // Customizable star normal color
        rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
        
        // Customizable star fill color
        rateView.starFillColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
        
        // Customizable star fill mode
        
    }
    if (rating==2.5)
    {
        // Customizable border color
        rateView.starBorderColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
        
        // Customizable star normal color
        rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
        
        // Customizable star fill color
        rateView.starFillColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
        
        // Customizable star fill mode
        
    }
    if (rating==3.0)
    {
        // Customizable border color
        rateView.starBorderColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
        
        // Customizable star normal color
        rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
        
        // Customizable star fill color
        rateView.starFillColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
        
        // Customizable star fill mode
        
    }
    if (rating==3.5)
    {
        // Customizable border color
        rateView.starBorderColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
        
        // Customizable star normal color
        rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
        
        // Customizable star fill color
        rateView.starFillColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
        
        // Customizable star fill mode
        
    }
    if (rating==4.0)
    {
        // Customizable border color
        rateView.starBorderColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
        
        // Customizable star normal color
        rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
        
        // Customizable star fill color
        rateView.starFillColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
        
        // Customizable star fill mode
        
    }
    if (rating==4.5)
    {
        // Customizable border color
        rateView.starBorderColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
        
        // Customizable star normal color
        rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
        
        // Customizable star fill color
        rateView.starFillColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
        
        // Customizable star fill mode
        
    }
    if (rating==5.0)
    {
        // Customizable border color
        rateView.starBorderColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
        
        // Customizable star normal color
        rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
        
        // Customizable star fill color
        rateView.starFillColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
        
        // Customizable star fill mode
        
    }
        quality_rating=rating;
        quality_lbl.text=[NSString stringWithFormat:@"%.1f/5.0",rating];
    }
    
    if (rateView.tag==1)
    {
        
        if (rating==0.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==1.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==1.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==2.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==2.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==3.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==3.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==4.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==4.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==5.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        service_rating= rating;
        service_lbl.text=[NSString stringWithFormat:@"%.1f/5.0",rating];
    }
    if (rateView.tag==2)
    {
        
        if (rating==0.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==1.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==1.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==2.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==2.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==3.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==3.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==4.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==4.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==5.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        value_rating= rating;
        value_lbl.text=[NSString stringWithFormat:@"%.1f/5.0",rating];
    }
    if (rateView.tag==3)
    {
        
        if (rating==0.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(235/255.0) green:(60/255.0) blue:(38/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==1.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(240/255.0) green:(87/255.0) blue:(50/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==1.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(244/255.0) green:(130/255.0) blue:(67/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==2.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(249/255.0) green:(166/255.0) blue:(71/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==2.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(251/255.0) green:(218/255.0) blue:(59/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==3.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(211/255.0) green:(222/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==3.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(133/255.0) green:(195/255.0) blue:(68/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==4.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(81/255.0) green:(184/255.0) blue:(73/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==4.5)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(56/255.0) green:(158/255.0) blue:(70/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        if (rating==5.0)
        {
            // Customizable border color
            rateView.starBorderColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star normal color
            rateView.starNormalColor = [UIColor colorWithRed:(216/255.0) green:(216/255.0) blue:(216/255.0) alpha:1.0];
            
            // Customizable star fill color
            rateView.starFillColor = [UIColor colorWithRed:(17/255.0) green:(140/255.0) blue:(40/255.0) alpha:1.0];
            
            // Customizable star fill mode
            
        }
        environment_rating= rating;
        env_lbl.text=[NSString stringWithFormat:@"%.1f/5.0",rating];
    }
    
}


- (IBAction)call_action:(id)sender
{
    NSString *phNo =[restInfoDict valueForKey:@"mobile"] ;
    if (![phNo isKindOfClass:[NSNull class]] && ![phNo isEqualToString:@""])
    {
        NSLog(@"got num");
        phNo = [restInfoDict valueForKey:@"mobile"];
    }
    else
        phNo = @"+8801730311601";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
       UIAlertView * calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}
- (IBAction)submit_rating:(id)sender
{
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
        NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
        
        NSString *regUrl = [NSString stringWithFormat:@"%@",BaseURLString];
        NSLog(@"userid rest %@",[prefs valueForKey:@"userid"]);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:regUrl
         
           parameters:@{
                        @"tag":@"ratinginsert",@"userid":[prefs valueForKey:@"userid"],@"resturantid":[prefs valueForKey:@"current_restid"],@"rating1":[NSString stringWithFormat:@"%.1f",quality_rating],@"rating2":[NSString stringWithFormat:@"%.1f",service_rating],@"rating3":[NSString stringWithFormat:@"%.1f",value_rating],@"rating4":[NSString stringWithFormat:@"%.1f",environment_rating]
                        }
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             NSDictionary *jsondict=responseObject;
             
             if (![jsondict isKindOfClass:[NSNull class]])
             {
                 @try {
                     
                     if ([[jsondict valueForKey:@"success"]integerValue]==1)
                     {
                         // NSLog(@"allrest response %@",jsondict);
                         
                         [MBProgressHUD hideAllHUDsForView:appDelegate.window animated:YES];
                         [rate_btn setBackgroundImage:[UIImage imageNamed:@"green_rate"] forState:UIControlStateNormal];
                         rate_lbl.text = @"Rated";
                         [backgrView removeFromSuperview];
                         [rate_view removeFromSuperview];
                         
                         
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

}

- (IBAction)close_rating:(id)sender
{
    [backgrView removeFromSuperview];
    [rate_view removeFromSuperview];
}

- (IBAction)close_review:(id)sender
{
    [backgrView removeFromSuperview];
    [wrview_vew removeFromSuperview];
    appDelegate.window.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
}
- (void)createMap
{
    
    
    // mapContainerView.frame= CGRectMake(mapContainerView.frame.origin.x, mapContainerView.frame.origin.y,appDelegate.window.frame.size.width, appDelegate.window.frame.size.height);
    
    [info_view removeFromSuperview];
    NSLog(@"enter map");
    
    camera = [GMSCameraPosition cameraWithLatitude:[[restInfoDict valueForKey:@"latitude"]floatValue]
                                         longitude:[[restInfoDict valueForKey:@"longitude"]floatValue]
                                              zoom:16];
    
    mapView = [GMSMapView mapWithFrame:rest_scroll.bounds camera:camera];
    mapView.delegate=self;
    
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([[restInfoDict valueForKey:@"latitude"]floatValue], [[restInfoDict valueForKey:@"longitude"]floatValue]);
    marker.title = [restInfoDict valueForKey:@"restaurantname"];
   // marker.icon = [UIImage imageNamed:@""];
    marker.map = mapView;
    
        [mapView animateToViewingAngle:90];
    [rest_scroll addSubview:mapView];
    
}
- (void)mapView:(GMSMapView *)mapView
didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"long press");
    NSLog(@"coordinate at this point lat %f long %f",coordinate.latitude,coordinate.longitude);
   
}


- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
   
}



@end
