//
//  MEPoint.h
//  MapEditor
//
//  Created by Yu on 7/29/13.
//
//
#ifndef MAPEDITOR_MEPOINT
#define MAPEDITOR_MEPOINT
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MEPoint : NSObject 
{
    int ID;
    cocos2d::CCSprite* sprite;
    cocos2d::CCPoint point;
    NSString *fileLocation;
    int direction;
    int userGroup;
    int routeID;
    int startPoint;
}
@property(nonatomic)int ID;
@property(nonatomic)cocos2d::CCPoint point;
@property(nonatomic)cocos2d::CCSprite* sprite;
@property(nonatomic,copy)NSString *fileLocation;
@property(nonatomic)int direction;
@property(nonatomic)int userGroup;
@property(nonatomic)int routeID;
@property(nonatomic)int startPoint;
@end

#endif