//
//  Venue.h
//  RKFoursquareCoffees
//
//  Created by Mosab Khaled on 6/30/12.
//  Copyright (c) 2012 mbabgi@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Stats.h"

@interface Venue : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) Stats *stats;

@end
