//
//  VenueCell.h
//  RKFoursquareCoffees
//
//  Created by Mosab Khaled on 7/1/12.
//  Copyright (c) 2012 mbabgi@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLable;
@property (strong, nonatomic) IBOutlet UILabel *distanceLable;
@property (strong, nonatomic) IBOutlet UILabel *checkedinLable;

@end
