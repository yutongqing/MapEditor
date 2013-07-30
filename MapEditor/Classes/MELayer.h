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

using namespace cocos2d;

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
    
    virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
    virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);
    virtual void registerWithTouchDispatcher();
    
    void createRoute();
    void finishRoute();
    
    void createPlayerPut();
    void createSystemPut();
    void createSceneObj();
    
    virtual void draw();
    
    
};

#endif /* defined(__MapEditor__MELayer__) */
