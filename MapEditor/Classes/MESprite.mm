//
//  MESprite.m
//  MapEditor
//
//  Created by Vertra on 13-7-29.
//
//

#import "MESprite.h"

using namespace cocos2d;

bool MESprite::init()
{
    layer = new CCLabelTTF();
    layer->setPosition(this->getPosition());
    this->addChild(layer);
    
    return true;
}