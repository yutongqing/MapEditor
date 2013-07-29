//
//  MELayer.h
//  MapEditor
//
//  Created by Yu on 7/29/13.
//
//

#ifndef __MapEditor__MELayer__
#define __MapEditor__MELayer__

#import "cocos2d.h"

class MELayer : public cocos2d::CCLayer
{
private:
    //MEPoint *homeA;
    //MEPoint *homeB;
    //NSMutableArray *routes;
    //NSMutableArray *playerPuts;
    //NSMutableArray *playerPutSprites;
public:
    virtual bool init();
    static cocos2d::CCScene* scene();
    CREATE_FUNC(MELayer);
    void chooseBg(CCObject* pSender);
};

#endif /* defined(__MapEditor__MELayer__) */
