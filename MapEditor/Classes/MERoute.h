//
//  MERoute.h
//  MapEditor
//
//  Created by Vertra on 13-7-29.
//
//


#ifndef MAPEDITOR_MERoute
#define MAPEDITOR_MERoute

#import <Foundation/Foundation.h>

@interface MERoute : NSObject
{
    int ID; //路径ID
    int head;   //路径头
    int tail;   //路径尾
    
    NSMutableArray *points; //路径中包含的点集
}

@property(nonatomic) int ID;
@property(nonatomic) int head;
@property(nonatomic) int tail;
@property(nonatomic, retain) NSMutableArray *points;

@end
#endif