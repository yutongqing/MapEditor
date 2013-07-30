//
//  MEPopLayer.h
//  MapEditor
//
//  Created by Yu on 7/30/13.
//
//

#ifndef __MapEditor__MEPopLayer__
#define __MapEditor__MEPopLayer__
#include "cocos2d.h"
#include <iostream>
class MEPopLayer : public cocos2d::CCLayer
{
private:
    cocos2d::CCArray *allSprites;
    
    int selcetedId = 0;
    int spriteTag = 12;
    
public:
    cocos2d::CCSprite* selectedSprite;
    
    virtual bool init();
    void selectIamge();
    cocos2d::CCArray* SeachAttachFileInDocumentDirctory();
    CREATE_FUNC(MEPopLayer);
    void chosenBg(CCObject* pSender);
    
    virtual void registerWithTouchDispatcher(void);
    virtual bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);// 按下
    virtual void ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent); //抬起
};
#endif /* defined(__MapEditor__MEPopLayer__) */
