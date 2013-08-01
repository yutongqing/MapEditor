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

using namespace cocos2d;

CCLabelTTF *locationInfoLabel;

MEPoint *homeA;
MEPoint *homeB;
NSMutableArray *routes;
NSMutableArray *playerPuts;

CCArray *playerPutSprites;
CCSprite *selectedBuilding;
BOOL canMoveBuilding = true;

MEPopLayer* popLayer;

CCMenu *finishMenu; //完成此路线

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
    
    this->setTouchEnabled(true);
    
    
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
    pointsInRoute0 = [[NSMutableArray alloc] init];
    pointsInRoute1 = [[NSMutableArray alloc] init];
    pointsInRoute2 = [[NSMutableArray alloc] init];
    
    playerPutSprites = new CCArray;
    playerPuts = [[NSMutableArray alloc] init];
    routes = [[NSMutableArray alloc] initWithCapacity:3];
    
    locationInfoLabel = CCLabelTTF::create("", "Helcatica", 20);
    locationInfoLabel->setVisible(false);
    this->addChild(locationInfoLabel);
    
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    
    CCMenuItem *menuItem1 = CCMenuItemFont::create("新建路线", this, menu_selector(MELayer::createRoute));
    menuItem1->setPosition(winSize.width / 5 * 1, winSize.height / 8);
    CCMenuItem *menuItem2 = CCMenuItemFont::create("玩家放置点", this, menu_selector(MELayer::createPlayerPut));
    menuItem2->setPosition(winSize.width / 5 * 2, winSize.height / 8);
    CCMenuItem *menuItem3 = CCMenuItemFont::create("中立点", this, menu_selector(MELayer::createSystemPut));
    menuItem3->setPosition(winSize.width / 5 * 3, winSize.height / 8);
    CCMenuItem *menuItem4 = CCMenuItemFont::create("图素", this, menu_selector(MELayer::createSceneObj));
    menuItem4->setPosition(winSize.width / 5 * 4, winSize.height / 8);
    
    CCMenu *menu = CCMenu::create(menuItem1, menuItem2, menuItem3, menuItem4, NULL);
    menu->setPosition(CCPointZero);
    
    this->addChild(menu, 1);
    
    this->scheduleUpdate();
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
    MEPopLayer *popLayer = new MEPopLayer(@"background");
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
        CCMenuItem *menuItem = CCMenuItemFont::create("完成此路线", this, menu_selector(MELayer::finishRoute));
        menuItem->setPosition(winSize.width - 100, winSize.height - 30);
        finishMenu = CCMenu::create(menuItem, NULL);
        finishMenu->setPosition(CCPointZero);
        
        this->addChild(finishMenu, 1);
    }
    
    
}

void MELayer::finishRoute()
{
    canMoveBuilding = true;
    
    isCreateRoute = FALSE;
    numberOfRouteCreated++;
    finishMenu->setVisible(false);
    
    routeID = numberOfRouteCreated - 1;
    MERoute *route = [[MERoute alloc] init];
    [route setID:routeID];
    
    NSLog(@"routeID ---> %d",routeID);
    
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
        }
        
        }
    if(isCreateRoute) {
        
        CCPoint p = pTouch->getLocation();
        
        char str[20];
        int tempX = (int)p.x;
        int tempY = (int)p.y;
        std::sprintf(str, "(%d, %d)", tempX, tempY);
        
        locationInfoLabel->setString(str);
        locationInfoLabel->setPosition(ccp(p.x, p.y + 50));
        locationInfoLabel->setVisible(true);
    }
    
    }
void MELayer::ccTouchEnded(CCTouch *touch, CCEvent *pEvent)
{
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
                [pointsInRoute0 addObject:touchPoint];
                break;
            case 1:
                [pointsInRoute1 addObject:touchPoint];
                break;
            case 2:
                [pointsInRoute2 addObject:touchPoint];
                break;
            default:
                break;
        }
        
        draw();
        
        pointID++;

        
    }else if (isCreatePlayerPut) {
        
        
        
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

void MELayer::chosenBuilding()
{
    MEPoint *point = [[MEPoint alloc] init];
    point.point = popLayer->selectedSprite->getPosition();
    point.fileLocation = popLayer->selectedFile;
    [playerPuts addObject:point];
    CCSprite *sprite = popLayer->selectedSprite;
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    sprite->setPosition(ccp(winSize.width / 2, winSize.height / 2));
    playerPutSprites->addObject(sprite);
    this->addChild(sprite);
}

void MELayer::createPlayerPut()
{
    MEPopLayer *layer = new MEPopLayer(@"buildings");
    popLayer = layer;
    this->getParent()->addChild(popLayer,1,11);

}

void MELayer::createSystemPut()
{
    NSLog(@"中立点 menuItem is clicked...");
}

void MELayer::createSceneObj()
{
    NSLog(@"图素 menuItem is clicked...");
}

