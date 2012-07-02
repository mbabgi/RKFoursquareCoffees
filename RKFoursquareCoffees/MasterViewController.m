//
//  MasterViewController.m
//  RKFoursquareCoffees
//
//  Created by Mosab Khaled on 6/30/12.
//  Copyright (c) 2012 mbabgi@me.com. All rights reserved.
//

#import "MasterViewController.h"
#import <RestKit/RestKit.h>
#import "Venue.h"
#import "VenueCell.h"

#define kCLIENTID "0YFTQO5KMDF3QQJCJ3ANQPPSOVORMY01JTAABONSEUZ1G3GN"
#define kCLIENTSECRET "LBWBFL1X0UB5JLDAAUFPM1WDW3D54OSMDD1ZUHS5SZRNWB0Q"

@interface MasterViewController ()

@property (strong, nonatomic) NSArray *data;

@end

@implementation MasterViewController
@synthesize data;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"MBabgi check-in service";
    RKURL *baseURL = [RKURL URLWithBaseURLString:@"https://api.Foursquare.com/v2"];
    RKObjectManager *objManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objManager.client.baseURL = baseURL;
	
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
    [venueMapping mapKeyPathsToAttributes:@"name", @"name", nil];
    [objManager.mappingProvider setMapping:venueMapping forKeyPath:@"response.venues"];
    
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping mapKeyPathsToAttributes:@"address", @"address", @"city", @"city", @"country", @"country", @"crossStreet", @"crossStreet", @"postalCode", @"postalCode", @"state", @"state", @"distance", @"distance", @"lat", @"lat", @"lng", @"lng", nil];
    
    [venueMapping mapRelationship:@"location" withMapping:locationMapping];
    [objManager.mappingProvider setMapping:locationMapping forKeyPath:@"location"];
    
    RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[Stats class]];
    [statsMapping mapKeyPathsToAttributes:@"checkinsCount", @"checkins", @"tipCount", @"tips", @"usersCount", @"users", nil];
    [venueMapping mapRelationship:@"stats" withMapping:statsMapping];
    [objManager.mappingProvider setMapping:statsMapping forKeyPath:@"stats"];
     
    [self sendRequest];
}

-(void) sendRequest
{
    NSString *latLong      = @"24.751508,46.740131";
    NSString *clientID     = [NSString stringWithUTF8String:kCLIENTID];
    NSString *clientSecret = [NSString stringWithUTF8String:kCLIENTSECRET];
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:latLong, @"ll", clientID, @"client_id", clientSecret, @"client_secret", @"coffee", @"query", @"20120602", @"v", nil];
    RKObjectManager *objManager = [RKObjectManager sharedManager];
    RKURL *url = [RKURL URLWithBaseURL:[objManager baseURL] resourcePath:@"/venues/search" queryParameters:queryParams];
    [objManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@", [url resourcePath],[url query]] delegate:self];
    NSString *curl = [NSString stringWithFormat:@"%@?%@", [url resourcePath],[url query]];
    NSLog(@"URL Call:>> %@",curl);
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"response code: %d", [response statusCode]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"objects[%d]", [objects count]);
    data = objects;
    
    [self.tableView reloadData];
}

#pragma mark -

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell"];

    Venue *venue = [data objectAtIndex:indexPath.row];
    cell.nameLable.text = [venue.name length] > 40 ? [venue.name substringToIndex:40] : [venue name];
    cell.distanceLable.text = [NSString stringWithFormat:@"%.0fm", [venue.location.distance floatValue]];
    cell.checkedinLable.text = [NSString stringWithFormat:@"%d checkins", [venue.stats.checkins intValue]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
