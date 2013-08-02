//
//  MEPopLayer.mm
//  MapEditor
//
//  Created by Yu on 7/30/13.
//
//

#include "MEPopLayer.h"
#include "MELayer.h"
using namespace cocos2d;

NSMutableArray *allFileName;

bool MEPopLayer::init()
{
    if (!CCLayer::init()) {
        return false;
    }
    this->setTouchEnabled(true);
    selectImage();
    return true;
}

MEPopLayer::MEPopLayer(NSString *tag)
{
    this->tag = tag;
    init();
}

void MEPopLayer::selectImage()
{
    allSprites = SeachAttachFileInDocumentDirctory();
    selectedSprite = (CCSprite*)allSprites->objectAtIndex(selcetedId);
    this->addChild(selectedSprite,0,spriteTag);
    
    CCSize size = CCDirector::sharedDirector()->getWinSize();
    CCMenuItem *menuItme = CCMenuItemFont::create("OK",this, menu_selector(MEPopLayer::menuOK));
    menuItme->setPosition(ccp(size.width-50,size.height-50));
    CCMenu* Menu = CCMenu::create(menuItme, NULL);
    Menu->setPosition(CCPointZero);
    this->addChild(Menu,100,1);
}

CCArray* MEPopLayer::SeachAttachFileInDocumentDirctory()
{
    
    CCArray *sprites =new CCArray;
    allFileName = [[NSMutableArray alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //获取Document目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    dir = [[dir stringByAppendingString:@"/"] stringByAppendingString:tag];
    
    //遍历目录，并创建精灵数组
    NSDirectoryEnumerator *dirEnumerater = [fm enumeratorAtPath:dir];
    NSString *filePath = nil;
    while(nil != (filePath = [dirEnumerater nextObject])) {
        if ([filePath isEqualToString:@".DS_Store"]) {
            continue;
        }
        [allFileName addObject:filePath];
        filePath = [[dir stringByAppendingString:@"/"] stringByAppendingString:filePath];
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:filePath];
        CCSprite    *sprite = CCSprite::create();
        NSData* imgData = UIImagePNGRepresentation(image);
        CCImage *cimg = new CCImage();
        void* data = malloc([imgData length]);
        [imgData getBytes:data];
        cimg->initWithImageData(data, [imgData length], CCImage::kFmtPng, image.size.width, image.size.height);
        free(data);
        
        CCTexture2D *texture = new CCTexture2D();
        texture->initWithImage(cimg);
        sprite->initWithTexture(texture);
        CCSize size = CCDirector::sharedDirector()->getWinSize();
        sprite->setPosition(ccp(size.width/2, size.height/2));
        sprites->addObject(sprite);
    }
    return sprites;
}

bool MEPopLayer::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    return true;
}

void MEPopLayer::ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    CCPoint p1 = pTouch->getPreviousLocation();
    CCPoint p2 = pTouch->getLocation();
    if (p1.x < p2.x) {
        selcetedId--;
    }else{
        selcetedId++;
    }
    selcetedId =MIN(allSprites->count()-1, MAX(selcetedId, 0));
    this->removeChildByTag(spriteTag);
    selectedSprite = (CCSprite*)allSprites->objectAtIndex(selcetedId);
    this->addChild(selectedSprite,0,spriteTag);
}

//注册触摸代理
void MEPopLayer::registerWithTouchDispatcher(void)
{
    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, kCCMenuHandlerPriority, true);
}

void MEPopLayer::chosenBg()
{
    MELayer *layer0 = (MELayer*)this->getParent()->getChildren()->objectAtIndex(0);
    this->removeAllChildren();
    this->getParent()->removeChild(this);
    selectedFile = (NSString*)[allFileName objectAtIndex:this->selcetedId];
    layer0->chosenBg();
    
    layer0->initMainScene();
}

void MEPopLayer::chosenBuilding()
{
    MELayer *layer0 = (MELayer*)this->getParent()->getChildren()->objectAtIndex(0);
    this->removeAllChildren();
    this->getParent()->removeChild(this);
    selectedFile = (NSString*)[allFileName objectAtIndex:this->selcetedId];
    layer0->chosenBuilding();
    
}

void MEPopLayer::menuOK(CCObject *pSender)
{
    if ([tag isEqualToString:@"background"]) {
        chosenBg();
    }else if([tag isEqualToString:@"buildings"]){
        chosenBuilding();
    }
}