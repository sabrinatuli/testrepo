//
//  SearchListViewController.m
//  HarrikeniOS
//
//  Created by Btrac on 11/2/15.
//  Copyright © 2015 Harriken. All rights reserved.
//

#import "SearchListViewController.h"
#import "HttpReqController.h"
#import "Reachability.h"
#import <GoogleMaps/GoogleMaps.h> 

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface SearchListViewController ()

@end

@implementation SearchListViewController
@synthesize candySearchBar,restSearchInfo,locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
   self.navigationController.navigationBarHidden=NO;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITextField *searchField = [candySearchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    // orange 255 51 0
    self.navigationController.navigationBarHidden=NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"navigation_orange"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:12.0],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = [NSString stringWithFormat:@"%lu results found",(unsigned long)restSearchInfo.count];

    SWRevealViewController *revealViewController = [self revealViewController];
   // UITapGestureRecognizer *tap = [revealViewController tapGestureRecognizer];
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
   // self.navigationItem.leftBarButtonItem=Menu;
    MenuButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 32)];
    
    
    MenuButton=[UIButton buttonWithType:UIButtonTypeSystem];
    MenuButton.frame=MenuButtonView.frame;
    [MenuButton setImage:[UIImage imageNamed:@"sidemenu"] forState:UIControlStateNormal];
    MenuButton.tintColor=[UIColor whiteColor];
    
    [MenuButton addTarget:revealViewController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [MenuButtonView addSubview:MenuButton];
    
    Menu=[[UIBarButtonItem alloc]initWithCustomView:MenuButtonView];
    self.navigationItem.rightBarButtonItem=Menu;
   
    datatemparray= [[NSArray alloc]init];
    searcharray= [[NSArray alloc]init];
    dataArray= [[NSArray alloc]init];
    datatemparray=restSearchInfo;
    NSLog(@"rest info %@",datatemparray);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backAction:(id)sender
{
    NSLog(@"ENTER");
    
    [self.navigationController popViewControllerAnimated:TRUE];
    
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
    
   // [locationManager stopUpdatingLocation];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        NSLog(@"alert");
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }
    
}
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope

{
   
   NSPredicate *placesPredicate= [NSPredicate predicateWithFormat:@"(%K CONTAINS[c] %@) OR (%K CONTAINS[c] %@)",
     @"name", searchText, @"type", searchText];
    //NSArray *tempArray = [datatemparray filteredArrayUsingPredicate:placesPredicate];
    NSArray *tempArray = [datatemparray filteredArrayUsingPredicate:placesPredicate] ;
   // NSLog(@"text %@",predicate2);
    
       dataArray=tempArray;
        searcharray=tempArray;
    
    
    if ([searcharray count]==0) {
        dataArray=datatemparray;
    }
    else {
        
        dataArray=searcharray;
    }
    restSearchInfo=dataArray;
    self.title = [NSString stringWithFormat:@"%lu results found",(unsigned long)restSearchInfo.count];
    
    [mytableview reloadData];
    // NSLog(@" search%@",dataArray);
    
    
}


#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    //NSLog(@"enterd text1");
    
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    //  NSLog(@"enterd text2");
    
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [candySearchBar resignFirstResponder];
    
    if ([searcharray count]==0) {
        dataArray=datatemparray;
    }
    else {
        
        dataArray=searcharray;
    }
    
    
    restSearchInfo =dataArray;
    
    [mytableview reloadData];
    NSLog(@"after search%@",dataArray);
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [candySearchBar resignFirstResponder];
    
    if ([searcharray count]==0) {
        dataArray=datatemparray;
    }
    else {
        
        dataArray=searcharray;
    }
    
    
    restSearchInfo=dataArray;
    
    [mytableview reloadData];
    NSLog(@"after search%@",dataArray);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma tableview delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [restSearchInfo count];
    // return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //
    //    if (!cell) {
    UITableViewCell *   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    UITextView *fromView = [[UITextView alloc]initWithFrame:CGRectMake(10,5, 300, 27)];
    fromView.text = [[restSearchInfo objectAtIndex:indexPath.row]valueForKey:@"name"];
    fromView.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.0];
    fromView.textColor = [UIColor colorWithRed:(255/255.0) green:(51.0/255.0) blue:(0.0/255.0) alpha:1.0];
    //fromView.backgroundColor = [UIColor greenColor];
    fromView.textAlignment = NSTextAlignmentLeft;
    fromView.editable=NO;
    
    // [fromView setAlwaysBounceVertical:NO];
    // [fromView setAlwaysBounceHorizontal:YES];
    // [scroll addSubview:fromView];
    //[fromLabel sizeToFit];
    
    [cell addSubview:fromView];
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 200, 20)];
    fromLabel.text = [[restSearchInfo objectAtIndex:indexPath.row]valueForKey:@"locationname"];
    fromLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:11.0];
    fromLabel.numberOfLines = 1;
    fromLabel.textColor = [UIColor blackColor];
    //fromLabel.backgroundColor = [UIColor greenColor];
    fromLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:fromLabel];
   // originLatitude=locationManager.location.coordinate.latitude;
   // originLongitude= locationManager.location.coordinate.longitude;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    float currentDistance = GMSGeometryDistance(CLLocationCoordinate2DMake([[[restSearchInfo objectAtIndex:indexPath.row]valueForKey:@"latitude"]floatValue], [[[restSearchInfo objectAtIndex:indexPath.row]valueForKey:@"longitude"]floatValue]), CLLocationCoordinate2DMake([[prefs valueForKey:@"current_lat"]floatValue], [[prefs valueForKey:@"current_long"]floatValue]));
    float distkm= currentDistance/1000.0;
    NSLog(@"%.2f distance",distkm);
    
    fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(appDelegate.window.frame.size.width-60, 35, 60, 20)];
    fromLabel.text = [NSString stringWithFormat:@"%.1f km",distkm];
    fromLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:11.0];
    fromLabel.numberOfLines = 1;
    fromLabel.textColor = [UIColor greenColor];
    //fromLabel.backgroundColor = [UIColor greenColor];
    fromLabel.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:fromLabel];
    
    fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 58, 300, 20)];
    fromLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:11.0];
    fromLabel.numberOfLines = 1;
    fromLabel.textColor = [UIColor grayColor];
    //fromLabel.backgroundColor = [UIColor yellowColor];
    fromLabel.textAlignment = NSTextAlignmentLeft;
    NSString *detail;
    if ([[[restSearchInfo objectAtIndex:indexPath.row]valueForKey:@"type"]isKindOfClass:[NSNull class]]) {
        detail = @" ";
    }
    else
    {
        detail = [[restSearchInfo objectAtIndex:indexPath.row]valueForKey:@"type"];
        if (![detail isKindOfClass:[NSNull class]]&&[detail length] > 0) {
            detail = [detail substringToIndex:[detail length] - 2];
        }
        else
            detail = @" ";
        
    }
    fromLabel.text = detail;
    [fromLabel sizeToFit];
    [cell addSubview:fromLabel];
    cell.detailTextLabel.font= [UIFont fontWithName:@"OpenSans-Semibold" size:10.0];
     cell.detailTextLabel.textColor=[UIColor grayColor];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
   // cell.backgroundColor=[UIColor colorWithRed:(225.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:0.2];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:(225.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:0.3];
  //  [cell setSelectedBackgroundView:bgColorView];
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *restid = [NSString stringWithFormat:@"%@",[[restSearchInfo objectAtIndex:indexPath.row]valueForKey:@"restaurantid"]];
    [prefs setValue:restid forKey:@"current_restid"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[prefs valueForKey:@"userid"],@"userid",restid,@"resturantid",nil];
    HttpReqController *htp = [[HttpReqController alloc]init];
    htp.navigate=self.navigationController;
     NSLog(@"userid rest %@",[dict valueForKey:@"userid"]);
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
    [htp ShowRestInfo:dict];
    }
}




- (CGFloat)tableView:(UITableView *)TableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83; // first row is 123px high
    
    
}



@end
