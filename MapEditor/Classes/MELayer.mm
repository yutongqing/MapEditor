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

MEPoint *homeA;
MEPoint *homeB;
NSMutableArray *routes;
NSMutableArray *playerPuts;
NSMutableArray *playerPutSprites;

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
    
    routes = [[NSMutableArray alloc] initWithCapacity:3];
    
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
    MEPopLayer *popLayer = MEPopLayer::create();
    this->removeAllChildren();
    this->getParent()->addChild(popLayer,1,11);
}

void MELayer::createRoute()
{
    isCreateRoute = true;
    
    NSLog(@"新建路线 menuItem is clicked...");
    
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    CCMenuItem *menuItem = CCMenuItemFont::create("完成此路线", this, menu_selector(MELayer::finishRoute));
    menuItem->setPosition(winSize.width - 100, winSize.height - 30);
    finishMenu = CCMenu::create(menuItem, NULL);
    finishMenu->setPosition(CCPointZero);
    
    this->addChild(finishMenu, 1);
}

void MELayer::finishRoute()
{
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
    
    for (MERoute *route in routes) {
        
        NSMutableArray *temp = [route points];
        
        for (MEPoint *point in temp) {
            
            NSLog(@"--->(%f, %f)", [point point].x, [point point].y);
        }
    }
    
    NSLog(@"numberOfRouteCreated--->%d", numberOfRouteCreated);
    
    
}

bool MELayer::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{    
    return true;
}

void MELayer::ccTouchEnded(CCTouch *touch, CCEvent *pEvent)
{    
    if (isCreateRoute) {
        
        CCPoint touchLocation = touch->getLocation();
        MEPoint *touchPoint = [MEPoint alloc];
        [touchPoint setID:pointID];
        [touchPoint setPoint:touchLocation];
        
        CCSprite *pointSprite = new CCSprite();
        pointSprite->initWithFile("point.png");
        pointSprite->setPosition(touchLocation);
        this->addChild(pointSprite);
        
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
    ccDrawColor4B(0,255,0,255);
    
    int count0 = [pointsInRoute0 count];
    int count1 = [pointsInRoute1 count];
    int count2 = [pointsInRoute2 count];
    
    if(count0 > 1) {
        
        for (int i = 0; i < count0 - 1; i++) {            
            CCPoint point1 = [[pointsInRoute0 objectAtIndex:i] point];
            CCPoint point2 = [[pointsInRoute0 objectAtIndex:i + 1] point];            
            ccDrawLine(point1, point2);
        }
    }
    if(count1 > 1) {
        
        for (int i = 0; i < count1 - 1; i++) {            
            CCPoint point1 = [[pointsInRoute1 objectAtIndex:i] point];
            CCPoint point2 = [[pointsInRoute1 objectAtIndex:i + 1] point];
            ccDrawLine(point1, point2);
        }
    }
    if(count2 > 1) {
        
        for (int i = 0; i < count2 - 1; i++) {
            CCPoint point1 = [[pointsInRoute2 objectAtIndex:i] point];
            CCPoint point2 = [[pointsInRoute2 objectAtIndex:i + 1] point];
            ccDrawLine(point1, point2);
        }
    }
    
    //检测是否有OpenGL错误发生，如果有则打印错误
    CHECK_GL_ERROR_DEBUG();
}

void MELayer::createPlayerPut()
{
    NSLog(@"玩家放置点 menuItem is clicked...");
}

void MELayer::createSystemPut()
{
    NSLog(@"中立点 menuItem is clicked...");
}

void MELayer::createSceneObj()
{
    NSLog(@"图素 menuItem is clicked...");
}

