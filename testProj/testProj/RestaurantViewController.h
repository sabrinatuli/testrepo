//
//  RestaurantViewController.h
//  HarrikeniOS
//
//  Created by Btrac on 10/14/15.
//  Copyright (c) 2015 Harriken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "PagedFlowView.h"
#import "SWRevealViewController.h"
#import "RateView.h"
#import <CoreGraphics/CoreGraphics.h>


@interface RestaurantViewController : UIViewController<FBSDKAppInviteDialogDelegate,FBSDKLoginButtonDelegate,GMSMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,PagedFlowViewDelegate,PagedFlowViewDataSource,UIScrollViewDelegate,RateViewDelegate,UITextViewDelegate>
{
    UIImageView *imgContainer;
    CGSize *orgSz;
    AppDelegate *appDelegate;
    int count;
    int currenttag;
    IBOutlet UILabel *review_lbl;
    UIView* MenuButtonView;
    UIButton* MenuButton;
    IBOutlet UITextView *add_txtvw;
    IBOutlet UIView *slide_imgvw;
    IBOutlet UITableView *photo_tbl;
    UITapGestureRecognizer *tapRecognizer;
    IBOutlet UIView *photoVw;
    IBOutlet UILabel *restname;
    IBOutlet UIView *branch_vw;
    IBOutlet UILabel * restaurant_branch_name;
    IBOutlet UILabel *cuisine_lbl1;
    IBOutlet UIImageView *arrow;
    IBOutlet UIView *topvw;
    UIButton *show_branch;
    IBOutlet UIButton *info_btn;
    IBOutlet UIButton *menu_btn;
    IBOutlet UIButton *review_btn;
    IBOutlet UIButton *photo_btn;
    IBOutlet UIButton *map_btn;
    IBOutlet UIScrollView *rest_scroll;
    IBOutlet UIView *info_view;
    IBOutlet UIImageView *sunD;
    IBOutlet UIImageView *monD;
    IBOutlet UIImageView *tueD;
    IBOutlet UIImageView *wedD;
    IBOutlet UIImageView *thuD;
    IBOutlet UIImageView *friD;
    IBOutlet UIImageView *satD;
    IBOutlet UILabel *sunLbl;
    IBOutlet UILabel *monLbl;
    IBOutlet UILabel *tueLbl;
    IBOutlet UILabel *wedLbl;
    IBOutlet UILabel *thuLbl;
    IBOutlet UILabel *friLbl;
    IBOutlet UILabel *satLbl;
    IBOutlet UILabel *ambLbl;
    IBOutlet UIImageView *wifi;
    IBOutlet UIImageView *cards;
    IBOutlet UIImageView *smoke;
    IBOutlet UIImageView *AC;
    IBOutlet UIImageView *reserve;
    UIImageView * review_imgVw;
    UILabel * reviewer_name;
    UILabel *review_time;
    UITextView * review_text;
    UIView *backgrView;
    int st;
    int fn;
    int like;
    GMSMapView *mapView;
    GMSMarker *marker;
    GMSCameraPosition *camera;
    
    IBOutlet UILabel *rate_lbl;
    IBOutlet UIView *showImgvw;
    IBOutlet UILabel *sunL;
    IBOutlet UILabel *monL;
    IBOutlet UILabel *tueL;
    IBOutlet UILabel *wedL;
    IBOutlet UILabel *thuL;
    IBOutlet UILabel *friL;
    IBOutlet UILabel *satL;
    IBOutlet UIButton *like_btn;
    IBOutlet UIButton *rate_btn;
    IBOutlet UILabel *like_lbl;
    IBOutlet UIButton *wreview_btn;
    IBOutlet UIView *wrview_vew;
    IBOutlet UITextView *review_txtvw;
    int estimated_count;
    UIImageView * imageV1;
    UIImageView * imageV2;
    UIImageView * imageV3;
     UIImageView * imgVw;
    NSMutableArray *imageArr;
    NSMutableArray *nameArr;
    UIButton *popupbutton;
    UISwipeGestureRecognizer *swipeRecognizerLeft;
    UISwipeGestureRecognizer *swipeRecognizerRight;
    UIScrollView *imageScroll;
    UIScrollView *containerview;
    UIScrollView *albumcontainerVw;
    UIPageControl *pageControl;
    UIButton *cross_btn;
    RateView *restaurant_rate;
    float quality_rating;
    float service_rating;
    float value_rating;
    float environment_rating;
    IBOutlet UIView *rate_view;
    
    IBOutlet UILabel *quality_lbl;
    IBOutlet UILabel *service_lbl;
    IBOutlet UILabel *value_lbl;
    IBOutlet UILabel *env_lbl;
}
- (IBAction)submit_rating:(id)sender;

- (IBAction)close_rating:(id)sender;

- (IBAction)close_review:(id)sender;
@property (nonatomic, strong) IBOutlet PagedFlowView *hFlowView;
@property (nonatomic, strong) IBOutlet UIPageControl *hPageControl;
- (IBAction)pageControlValueDidChange:(id)sender;
@property (nonatomic,retain) NSMutableArray *imagealbum_arr;
@property (retain, nonatomic) IBOutlet FBSDKLoginButton *FBbutton;
@property (retain, nonatomic) IBOutlet NSMutableDictionary *restInfoDict;
- (IBAction)post_review_action:(id)sender;

- (IBAction)edit_profile:(id)sender;
- (IBAction)info_action:(id)sender;
- (IBAction)menu_action:(id)sender;
- (IBAction)review_action:(id)sender;
- (IBAction)photo_action:(id)sender;
- (IBAction)map_action:(id)sender;
- (IBAction)like_action:(id)sender;
- (IBAction)write_review:(id)sender;
- (IBAction)rate_action:(id)sender;
- (IBAction)call_action:(id)sender;

@end
