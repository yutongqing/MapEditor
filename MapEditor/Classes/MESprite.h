//
//  MESprite.h
//  MapEditor
//
//  Created by Vertra on 13-7-29.
//
//

#import "cocos2d.h"

using namespace cocos2d;

class MESprite : public cocos2d::CCSprite
{
public:
    
    CCLabelTTF *layer;
    CREATE_FUNC(MESprite);    
    bool init();
};


