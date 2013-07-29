//
//  MEPoint.h
//  MapEditor
//
//  Created by Yu on 7/29/13.
//
//

#import <Foundation/Foundation.h>

@interface MEPoint : NSObject
{
    int ID;
    CGPoint point;
    NSString *fileLocation;
    int userGroup;
}
@property(nonatomic)int ID;
@property(nonatomic)CGPoint point;
@property(nonatomic)int direction;
@property(nonatomic)int userGroup;
@end
