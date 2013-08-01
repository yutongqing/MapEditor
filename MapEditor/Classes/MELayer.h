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
#import "MESprite.h"
using namespace cocos2d;

class MELayer : public cocos2d::CCLayer
{
private:
public:
    
    
    
    CCSprite *bgSprite;
    
    virtual bool init();
    void initMainScene();
    static cocos2d::CCScene* scene();
    CREATE_FUNC(MELayer);
    void chooseBg(CCObject* pSender);
    void chosenBuilding();
    
    void update(float delta);
    virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
    virtual void ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent);
    virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);
    virtual void registerWithTouchDispatcher();
    
    void createRoute();
    void finishRoute();
    void recreateRoute();
    
    void createPlayerPut();
    void createSystemPut();
    void createSceneObj();
    
    virtual void draw();
    
    
};

#endif /* defined(__MapEditor__MELayer__) */
