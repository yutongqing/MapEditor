//
//  MERoute.m
//  MapEditor
//
//  Created by Vertra on 13-7-29.
//
//

#import "MERoute.h"

@implementation MERoute

@synthesize ID, head, tail, points;

- (id)init
{
    self = [super init];
    if (self) {
        head = 0;
        tail = 0;
    }
    return self;
}

@end
