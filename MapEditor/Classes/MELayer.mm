//
//  MELayer.mm
//  MapEditor
//
//  Created by Yu on 7/29/13.
//
//

#include "MELayer.h"
#include "MEPoint.h"
using namespace cocos2d;

bool MELayer::init()
{
    if (!CCLayer::init()) {
        return false;
    }
    CCSize size = CCDirector::sharedDirector()->getWinSize();
    CCMenuItem *menuItme = CCMenuItemFont::create("please choose background picture", this, menu_selector(MELayer::chooseBg));
    menuItme->setPosition(ccp(size.width/2,size.height/2));
    CCMenu* Menu = CCMenu::create(menuItme, NULL);
    Menu->setPosition(CCPointZero);
    this->addChild(Menu, 1);
    return true;
}

CCScene* MELayer::scene()
{
    CCScene *scene = CCScene::create();
    MELayer *layer = MELayer::create();
    scene->addChild(layer);
    return scene;
}

void MELayer::chooseBg(CCObject* pSender)
{
    NSString *picPath =  [[NSBundle mainBundle]pathForResource:@"123" ofType:@"png" inDirectory:@"backgroundPic"];
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:picPath];
    CCSprite    *sprite = CCSprite::create();
    NSData* imgData = UIImagePNGRepresentation(image);
    CCImage *cimg = new CCImage();
    void* data = malloc([imgData length]);
    [imgData getBytes:data];
    bool ret =  cimg->initWithImageData(data, [imgData length], CCImage::kFmtPng, image.size.width, image.size.height);
    free(data);
    
    
    CCTexture2D *texture = new CCTexture2D();
    texture->initWithImage(cimg);
    sprite->initWithTexture(texture);
    
    this->addChild(sprite);
}

