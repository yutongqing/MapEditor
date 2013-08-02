//
//  MELayer.mm
//  MapEditor
//
//  Created by Yu on 7/29/13.
//
//

#include "MELayer.h"
#include "MEPoint.h"
#include "MERoute.h"
#include "MESprite.h"
#include "MEPopLayer.h"
#include "XMLWrite.h"
using namespace cocos2d;

//需要保存至xml的数据
MEPoint *homeA;
MEPoint *homeB;
NSString *bgFileName;
CCSprite *bgSprite;
NSMutableArray *routes;
NSMutableArray *playerPuts;
NSMutableArray *systemPuts;

CCLabelTTF *locationInfoLabel;  //手指在屏幕上移动时，在触摸点上方显示的触摸坐标
CCSprite *dustbinSprite;    //移动玩家放置点或者中立点的时候，屏幕左上角显示的垃圾桶图案
CCArray *playerPutSprites;  //显示出来的玩家放置点和中立点的精灵
CCSprite *selectedBuilding; //当前选择的玩家放置点或者中立点
BOOL canMoveBuilding = true;    //玩家放置点或中立点是否可以移动
MEPopLayer* popLayer;
CCMenu *finishRouteMenu; //完成此路线的菜单
CCMenu *recreateAllMenu;    //全部重画菜单

int numberOfRouteCreated = 0;   //已经创建好的路径条数，点击一次“完成此路线”计数+1

NSMutableArray *pointsInRoute0;
NSMutableArray *pointsInRoute1;
NSMutableArray *pointsInRoute2;

bool isCreateRoute = false;
bool isCreatePlayerPut = false;
bool isCreateSystemPut = false;
bool isCreateSceneObj = false;

int pointID = 0;
int routeID = 0;
int playerPutID = 0;
int systemPutID = 0;

void MELayer::registerWithTouchDispatcher()
{
    CCDirector* director = CCDirector::sharedDirector();
    director->getTouchDispatcher()->addTargetedDelegate(this, 0, true);
}

bool MELayer::init()
{
    if (!CCLayer::init()) {
        return false;
    }
       
    
    CCSize size = CCDirector::sharedDirector()->getWinSize();
    CCMenuItem *menuItme = CCMenuItemFont::create("请选择背景图片", this, menu_selector(MELayer::chooseBg));
    menuItme->setPosition(ccp(size.width/2,size.height/2));
    CCMenu* Menu = CCMenu::create(menuItme, NULL);
    Menu->setPosition(CCPointZero);
    this->addChild(Menu, 1);
    
    return true;
}

void MELayer::initMainScene()
{
    this->setTouchEnabled(true);
    
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    
    dustbinSprite = new CCSprite();
    dustbinSprite->initWithFile("dustbin_normal.png");
    dustbinSprite->setPosition(ccp(50, winSize.height - 50));
    dustbinSprite->setVisible(false);
    this->addChild(dustbinSprite);
    
    pointsInRoute0 = [[NSMutableArray alloc] init];
    pointsInRoute1 = [[NSMutableArray alloc] init];
    pointsInRoute2 = [[NSMutableArray alloc] init];
    
    playerPutSprites = new CCArray;
    playerPuts = [[NSMutableArray alloc] init];
    systemPuts = [[NSMutableArray alloc] init];
    routes = [[NSMutableArray alloc] initWithCapacity:3];
    
    locationInfoLabel = CCLabelTTF::create("", "Helcatica", 20);
    locationInfoLabel->setVisible(false);
    this->addChild(locationInfoLabel);
    

    
    CCMenuItem *menuItem1 = CCMenuItemFont::create("新建路线", this, menu_selector(MELayer::createRoute));
    menuItem1->setPosition(winSize.width / 5 * 1, winSize.height / 8);
    CCMenuItem *menuItem2 = CCMenuItemFont::create("玩家放置点", this, menu_selector(MELayer::createPlayerPut));
    menuItem2->setPosition(winSize.width / 5 * 2, winSize.height / 8);
    CCMenuItem *menuItem3 = CCMenuItemFont::create("中立点", this, menu_selector(MELayer::createSystemPut));
    menuItem3->setPosition(winSize.width / 5 * 3, winSize.height / 8);
    CCMenuItem *menuItem4 = CCMenuItemFont::create("保存", this, menu_selector(MELayer::xmlWriteData));
    menuItem4->setPosition(winSize.width / 5 * 4, winSize.height / 8);
  
    CCMenu *menu = CCMenu::create(menuItem1, menuItem2, menuItem3, menuItem4, NULL);
    menu->setPosition(CCPointZero);
    
    CCMenuItem *recreateAllMenuItem = CCMenuItemFont::create("重画此地图", this, menu_selector(MELayer::recreateAll));
    recreateAllMenu = CCMenu::create(recreateAllMenuItem, NULL);
    recreateAllMenu->setPosition(CCPointZero);
    recreateAllMenuItem->setPosition(200, winSize.height - 50);
    this->addChild(recreateAllMenu);
    
    this->addChild(menu, 1);
    this->scheduleUpdate();
}

void MELayer::recreateAll()
{
    
    NSLog(@"before recreateAll:");
    printAllArrays();
    
    numberOfRouteCreated = 0;
    
    [pointsInRoute0 release];
    pointsInRoute0 = nil;
    pointsInRoute0 = [[NSMutableArray alloc] init];
    [pointsInRoute1 release];
    pointsInRoute1 = nil;
    pointsInRoute1 = [[NSMutableArray alloc] init];
    [pointsInRoute2 release];
    pointsInRoute2 = nil;
    pointsInRoute2 = [[NSMutableArray alloc] init];
    while (this->getChildByTag(0)) {
        this->removeChildByTag(0, true);
    }
    while (this->getChildByTag(1)) {
        this->removeChildByTag(1, true);
    }
    while (this->getChildByTag(2)) {
        this->removeChildByTag(2, true);
    }
    while (this->getChildByTag(8)) {
        this->removeChildByTag(8, true);
    }
    
    [playerPuts release];
    playerPuts = nil;
    playerPuts = [[NSMutableArray alloc] init];
    
    [systemPuts release];
    systemPuts = nil;
    systemPuts = [[NSMutableArray alloc] init];
    
    playerPutSprites->release();
    playerPutSprites = NULL;
    playerPutSprites = new CCArray();
    
    NSLog(@"after recreateAll:");
    printAllArrays();
}


void MELayer::xmlWriteData()
{
    
    //将数据写入xml
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    dir = [[dir stringByAppendingString:@"/"] stringByAppendingString:@"mapData.xml"];
    XMLWrite xmlWrite;
    xmlWrite.XMLWriteInit((char *)[dir UTF8String], "1.0", "utf-8");
    
    xmlWrite.xmlDataWrite(xmlWrite,routes,playerPuts,systemPuts,bgSprite->getContentSize().width,bgSprite->getContentSize().height,bgFileName);
    
}



CCScene* MELayer::scene()
{
    CCScene *scene = CCScene::create();
    MELayer *layer = MELayer::create();
    scene->addChild(layer);
    return scene;
}

void MELayer::update(float delta)
{
    for (int i = 0; i < playerPutSprites->count(); i++){
        CCSprite *sprite = (CCSprite*)playerPutSprites->objectAtIndex(i);
        CCSize size = CCDirector::sharedDirector()->getWinSize();
        int zOrder = sqrt((sprite->getPosition().x) * (sprite->getPosition().x)
                          + (sprite->getPosition().y-size.height) * (sprite->getPosition().y-size.height));
        sprite->setZOrder( zOrder);
    }
}


void MELayer::chooseBg(CCObject* pSender)
{
    MEPopLayer *layer = new MEPopLayer(@"background");
    popLayer = layer;
    this->removeAllChildren();
    this->getParent()->addChild(popLayer,1,11);
}

void MELayer::createRoute()
{
    if (numberOfRouteCreated >= 3) {
        
        isCreateRoute = false;
        canMoveBuilding = true;
        
    } else
    {
        isCreateRoute = true;
        
        canMoveBuilding = false;
        
        NSLog(@"新建路线 menuItem is clicked...");
        
        CCSize winSize = CCDirector::sharedDirector()->getWinSize();
        CCMenuItem *finishRouteItem = CCMenuItemFont::create("完成此路线", this, menu_selector(MELayer::finishRoute));
        
        CCMenuItem *deleteRouteItem = CCMenuItemFont::create("重画此路线", this, menu_selector(MELayer::recreateRoute));
        
        
        finishRouteItem->setPosition(winSize.width - 100, winSize.height - 30);
        deleteRouteItem->setPosition(winSize.width - 300, winSize.height - 30);
        finishRouteMenu = CCMenu::create(finishRouteItem, deleteRouteItem, NULL);
        finishRouteMenu->setPosition(CCPointZero);
        
        this->addChild(finishRouteMenu, 1);
    }
    
    
}

void MELayer::recreateRoute()
{
    switch (numberOfRouteCreated) {
        case 0:
            [pointsInRoute0 release];
            pointsInRoute0 = nil;
            pointsInRoute0 = [[NSMutableArray alloc] init];
            while (this->getChildByTag(0)) {
                this->removeChildByTag(0, true);
            }
            break;
        case 1:
            [pointsInRoute1 release];
            pointsInRoute1 = nil;
            pointsInRoute1 = [[NSMutableArray alloc] init];
            while (this->getChildByTag(1)) {
                this->removeChildByTag(1, true);
            }
            break;
        case 2:
            [pointsInRoute2 release];
            pointsInRoute2 = nil;
            pointsInRoute2 = [[NSMutableArray alloc] init];
            while (this->getChildByTag(2)) {
                this->removeChildByTag(2, true);
            }
            break;
            
            
        default:
            break;
    }
    
    
}

void MELayer::finishRoute()
{
    canMoveBuilding = true;
    
    isCreateRoute = FALSE;
    numberOfRouteCreated++;

    finishRouteMenu->setVisible(false);
    
    routeID = numberOfRouteCreated - 1;
    MERoute *route = [[MERoute alloc] init];
    [route setID:routeID];
    

    
    [routes addObject:route];
    
    switch (routeID) {
        case 0:
            [route setPoints:pointsInRoute0];
            break;
        case 1:
            [route setPoints:pointsInRoute1];
            break;
        case 2:
            [route setPoints:pointsInRoute2];
            break;
            
        default:
            break;
    }
        
}

bool MELayer::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
    for (int i = 0; i < playerPutSprites->count(); i++) {
    CCSprite *s = (CCSprite*)playerPutSprites->objectAtIndex(i);
    if (pTouch->getLocation().x < s->getPosition().x + s->getContentSize().width/2
        && pTouch->getLocation().x > s->getPosition().x - s->getContentSize().width/2
        && pTouch->getLocation().y < s->getPosition().y + s->getContentSize().height/2
        && pTouch->getLocation().y > s->getPosition().y - s->getContentSize().height/2) {
        selectedBuilding = s;
        
        }
    }
    
    return true;
}

void MELayer::ccTouchMoved(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    if (canMoveBuilding) {
        
        if (selectedBuilding) {
            
            selectedBuilding->setPosition(pTouch->getLocation());
            
            dustbinSprite->setVisible(true);

        }
        
        }
        
        
    CCPoint p = pTouch->getLocation();
        
    char str[20];
    int tempX = (int)p.x;
    int tempY = (int)p.y;
    std::sprintf(str, "(%d, %d)", tempX, tempY);
        
    locationInfoLabel->setString(str);
    locationInfoLabel->setPosition(ccp(p.x, p.y + 50));
    locationInfoLabel->setVisible(true);
    
    
    }
void MELayer::ccTouchEnded(CCTouch *touch, CCEvent *pEvent)
{
    if (selectedBuilding) {
        
        CCSize winSize = CCDirector::sharedDirector()->getWinSize();
        
        CCPoint p = selectedBuilding->getPosition();
        if (p.x < 50 && p.y > winSize.height - 50) {
            
            playerPutSprites->removeObject(selectedBuilding);
            for (int i = 0; i < [playerPuts count]; i++) {
                
                if (selectedBuilding == [[playerPuts objectAtIndex:i] sprite]) {
                    
                    [playerPuts removeObjectAtIndex:i];
                }
            }
            for (int i = 0; i < [systemPuts count]; i++) {
                
                if (selectedBuilding == [[systemPuts objectAtIndex:i] sprite]) {
                    
                    [systemPuts removeObjectAtIndex:i];
                }
            }
            this->removeChildByTag(8);
        }
    }
    
    selectedBuilding = nil;
//    canMoveBuilding = false;
    
    locationInfoLabel->setVisible(false);
    
    if (isCreateRoute) {
        
        CCPoint touchLocation = touch->getLocation();
        MEPoint *touchPoint = [MEPoint alloc];
        [touchPoint setID:pointID];
        [touchPoint setPoint:touchLocation];
        
        CCSprite *pointSprite = new CCSprite();
        pointSprite->initWithFile("point.png");
        pointSprite->setPosition(touchLocation);
        this->addChild(pointSprite);
        
        
        CCLabelTTF *pointLabel = CCLabelTTF::create("", "Helcatica", 20);
        char str[20];
        int tempX = (int)touchLocation.x;
        int tempY = (int)touchLocation.y;
        std::sprintf(str, "(%d, %d)", tempX, tempY);
        
        pointLabel->setString(str);
        pointLabel->setPosition(ccp(touchLocation.x, touchLocation.y + 50));
        this->addChild(pointLabel);
        
        switch (numberOfRouteCreated) {
            case 0:
                pointSprite->setTag(0);
                pointLabel->setTag(0);
                [pointsInRoute0 addObject:touchPoint];
                break;
            case 1:
                pointSprite->setTag(1);
                pointLabel->setTag(1);
                [pointsInRoute1 addObject:touchPoint];
                break;
            case 2:
                pointSprite->setTag(2);
                pointLabel->setTag(2);
                [pointsInRoute2 addObject:touchPoint];
                break;
            default:
                break;
        }
        
        draw();
        
        pointID++;

        
    }else if (isCreatePlayerPut) {
        
        CCPoint touchLocation = touch->getLocation();
        CCLabelTTF *pointLabel = CCLabelTTF::create("", "Helcatica", 20);
        char str[20];
        int tempX = (int)touchLocation.x;
        int tempY = (int)touchLocation.y;
        std::sprintf(str, "(%d, %d)", tempX, tempY);
        
        pointLabel->setString(str);
        pointLabel->setPosition(ccp(touchLocation.x, touchLocation.y + 50));
        this->addChild(pointLabel);
        
    }else if (isCreateSystemPut) {
        
        
        
    }else if (isCreateSceneObj) {
        
        
    }
}

void MELayer::draw()
{    
    glLineWidth( 5.0f );
    ccDrawColor4B(0,255,255,255);
    
    int count0 = [pointsInRoute0 count];
    int count1 = [pointsInRoute1 count];
    int count2 = [pointsInRoute2 count];
    
    if(count0 > 1) {
        
        for (int i = 0; i < count0 - 1; i++) {            
            CCPoint point1 = [[pointsInRoute0 objectAtIndex:i] point];
            CCPoint point2 = [[pointsInRoute0 objectAtIndex:i + 1] point];
            ccDrawColor4B(255,0,0,255);
            ccDrawLine(point1, point2);
        }
    }
    if(count1 > 1) {
        
        for (int i = 0; i < count1 - 1; i++) {            
            CCPoint point1 = [[pointsInRoute1 objectAtIndex:i] point];
            CCPoint point2 = [[pointsInRoute1 objectAtIndex:i + 1] point];
            ccDrawColor4B(0,255,0,255);
            ccDrawLine(point1, point2);
        }
    }
    if(count2 > 1) {
        
        for (int i = 0; i < count2 - 1; i++) {
            CCPoint point1 = [[pointsInRoute2 objectAtIndex:i] point];
            CCPoint point2 = [[pointsInRoute2 objectAtIndex:i + 1] point];
            ccDrawColor4B(0,0,255,255);
            ccDrawLine(point1, point2);
        }
    }
    
    //检测是否有OpenGL错误发生，如果有则打印错误
    CHECK_GL_ERROR_DEBUG();
}

void MELayer::chosenBg()
{
    if (popLayer) {
        bgFileName = popLayer->selectedFile;
        bgSprite = popLayer->selectedSprite;
        bgSprite->setPosition(ccp(CCDirector::sharedDirector()->getWinSize().width/2,CCDirector::sharedDirector()->getWinSize().height/2));
        this->addChild(bgSprite,-1);
    }
    
}

void MELayer::chosenBuilding()
{
    MEPoint *point = [[MEPoint alloc] init];
    //point.point = popLayer->selectedSprite->getPosition();
    point.fileLocation = popLayer->selectedFile;
    point.sprite = popLayer->selectedSprite;
    if (isCreatePlayerPut) {
        [point setID:playerPutID];
        playerPutID++;
        [playerPuts addObject:point];
    } else if (isCreateSystemPut) {
        [point setID:systemPutID];
        systemPutID++;
        [systemPuts addObject:point];
    }
    
    
    CCSprite *sprite = popLayer->selectedSprite;
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    sprite->setPosition(ccp(winSize.width / 2, winSize.height / 2));
    playerPutSprites->addObject(sprite);
    sprite->setTag(8);
    this->addChild(sprite);
    
    
    
    isCreatePlayerPut = false;
    isCreateSystemPut = false;
    
    
}

void MELayer::createPlayerPut()
{
    isCreatePlayerPut = true;
    
    MEPopLayer *layer = new MEPopLayer(@"buildings");
    popLayer = layer;
    this->getParent()->addChild(popLayer, 1, 11);

}

void MELayer::createSystemPut()
{
    NSLog(@"中立点 menuItem is clicked...");
    
    isCreateSystemPut = true;
    
    MEPopLayer *layer = new MEPopLayer(@"buildings");
    popLayer = layer;
    this->getParent()->addChild(popLayer, 1, 11);
}

void MELayer::createSceneObj()
{
    NSLog(@"图素 menuItem is clicked...");
}

void MELayer::printAllArrays()
{
    NSLog(@"***************************************************");
    NSLog(@"The NSMutableArray routes has %d items.", [routes count]);
    
    for (MEPoint *p in pointsInRoute0) {
        
        NSLog(@"pointsInRoute0-->(%f, %f)", [p point].x, [p point].y);
    }
    for (MEPoint *p in pointsInRoute1) {
        
        NSLog(@"pointsInRoute1-->(%f, %f)", [p point].x, [p point].y);
    }
    for (MEPoint *p in pointsInRoute2) {
        
        NSLog(@"pointsInRoute2-->(%f, %f)", [p point].x, [p point].y);
    }
    
    NSLog(@"-------------------------------");
    for (MEPoint *p in playerPuts) {
        
        NSLog(@"playerPuts --> (%f, %f)", [p sprite]->getPosition().x, [p sprite]->getPosition().y);
    }
    
    NSLog(@"-------------------------------");
    for (MEPoint *p in systemPuts) {
        
        NSLog(@"systemPuts --> (%f, %f)", [p sprite]->getPosition().x, [p sprite]->getPosition().y);
    }
    
    
    
}

