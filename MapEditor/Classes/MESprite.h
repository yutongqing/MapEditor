//
//  MESprite.h
//  MapEditor
//
//  Created by Vertra on 13-7-29.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

using namespace cocos2d;

class MESprite : public cocos2d::CCSprite
{
    CCLabelTTF *layer;
    
    
    bool init();
};


