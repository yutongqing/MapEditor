//
//  MERoute.h
//  MapEditor
//
//  Created by Vertra on 13-7-29.
//
//

#import <Foundation/Foundation.h>

@interface MERoute : NSObject
{
    int ID;
    int head;
    int tail;
    
    NSMutableArray *points;
}

@property(nonatomic) int ID;
@property(nonatomic) int head;
@property(nonatomic) int tail;
@property(nonatomic, retain) NSMutableArray *points;

@end
