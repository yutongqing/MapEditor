//
//  MEPopLayer.h
//  MapEditor
//
//  Created by Yu on 7/30/13.
//
//

#ifndef __MapEditor__MEPopLayer__
#define __MapEditor__MEPopLayer__
#import <Foundation/Foundation.h>
#include "cocos2d.h"

class MEPopLayer : public cocos2d::CCLayer
{
private:
    cocos2d::CCArray *allSprites;
    int selcetedId = 0;
    const int spriteTag = 12;
    NSString *tag;
public:
    cocos2d::CCSprite* selectedSprite;
    NSString *selectedFile;
    
    MEPopLayer(NSString *tag);
    virtual bool init();
    void selectImage();
    cocos2d::CCArray* SeachAttachFileInDocumentDirctory();
    void chosenBg();
    void chosenBuilding();
    void menuOK(CCObject* pSender);
    
    virtual void registerWithTouchDispatcher(void);
    virtual bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);// 按下
    virtual void ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent); //抬起
};
#endif /* defined(__MapEditor__MEPopLayer__) */
