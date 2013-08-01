//
//  MEPoint.m
//  MapEditor
//
//  Created by Yu on 7/29/13.
//
//

#import "MEPoint.h"

@implementation MEPoint
@synthesize ID;
@synthesize point;
@synthesize fileLocation;
@synthesize direction;
@synthesize userGroup;
@synthesize sprite;
@synthesize routeID;
@synthesize startPoint;

- (id)init
{
    self = [super init];
    if (self) {
        direction = 0;
        userGroup = 0;
        routeID = 0;
        startPoint = 0;
    }
    return self;
}
@end
