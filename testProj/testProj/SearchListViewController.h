//
//  SearchListViewController.h
//  HarrikeniOS
//
//  Created by Btrac on 11/2/15.
//  Copyright © 2015 Harriken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,SWRevealViewControllerDelegate,UITextViewDelegate,UIScrollViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    NSArray *datatemparray;
    NSArray *searcharray;
    AppDelegate *appDelegate;
    IBOutlet UITableView *mytableview;
    NSArray *dataArray;
    UIView* MenuButtonView;
    UIButton* MenuButton;
    float originLatitude;
    float originLongitude;
}
@property (nonatomic,retain) NSMutableArray *restSearchInfo;
@property (strong, nonatomic) IBOutlet UISearchBar *candySearchBar;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end
