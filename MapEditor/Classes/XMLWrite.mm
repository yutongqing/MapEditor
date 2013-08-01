//
//  XMLWrite.cpp
//  Game
//
//  Created by Zhang Baowen on 13-7-29.
//
//

#include "XMLWrite.h"
#include <stdlib.h>
#include <stdio.h>

#include <string.h>
#include <cstring>

/****************************
 输入：自定义XMLWrite对象，以及包含所要处理数据的对象
 输出：xml处理流程是否有正常
 功能：将对象里的数据按照既定格式输出到xml文档中
 *****************************/
char * parse(int value)
{
    char *data = new char[10];
    memset(data, 0, 10);
    sprintf(data, "%d",value);
    return data;
}

char * parse(float value)
{
    char *data = new char[10];
    memset(data, 0, 10);
    sprintf(data, "%f",value);
    return data;
}


bool XMLWrite::xmlDataWrite(XMLWrite xmlWriteObj,NSMutableArray *routes, NSMutableArray *playerPosition,NSMutableArray *systemPuts,float bgmap_width,float bgmap_height,const NSString *bgmapFilePath)
{
    
    if ( routes == NULL && playerPosition == NULL) {
        return false;
    }
    
    xmlWriteObj.setXMLDocWritePtr(xmlNewDoc(BAD_CAST xmlWriteObj.getXMLWriteVersion()));
    xmlWriteObj.setXMLWriteRootNode(xmlNewNode(NULL, BAD_CAST "root"));
    
    
    if (NULL == xmlWriteObj.getXMLDocWritePtr()) {
        NSLog(@"xml指针异常");
        xmlFreeDoc(xmlWriteObj.getXMLDocWritePtr());
        return false;
    }
    
    if (NULL == xmlWriteObj.getXMLWriteRootNode()) {
        NSLog(@"xml根节点指针异常");
        xmlFreeDoc(xmlWriteObj.getXMLDocWritePtr());
        return false;
    }
    
    xmlDocSetRootElement(xmlWriteObj.getXMLDocWritePtr(), xmlWriteObj.getXMLWriteRootNode());
    
    
    xmlNodePtr xmlChildNodeOfRootNode1 = xmlNewNode(NULL, BAD_CAST "head");
    xmlAddChild(xmlWriteObj.getXMLWriteRootNode(), xmlChildNodeOfRootNode1);
    xmlNodePtr xmlChildNodeOfHeadNode1 = xmlNewNode(NULL, BAD_CAST "size");
    xmlNodePtr xmlChildNodeOfHeadNode2 = xmlNewNode(NULL, BAD_CAST "file");
    xmlAddChild(xmlChildNodeOfRootNode1, xmlChildNodeOfHeadNode1);
    xmlAddChild(xmlChildNodeOfRootNode1, xmlChildNodeOfHeadNode2);
    
    //数据处理开始
    
    xmlNewProp(xmlChildNodeOfHeadNode1, BAD_CAST "x", BAD_CAST parse(bgmap_width));
    xmlNewProp(xmlChildNodeOfHeadNode1, BAD_CAST "y", BAD_CAST parse(bgmap_height));
    xmlNewProp(xmlChildNodeOfHeadNode2, BAD_CAST "location", BAD_CAST bgmapFilePath);
    
    
    
    xmlNodePtr xmlChildNodeOfRootNode2 = xmlNewNode(NULL, BAD_CAST "routes");
    xmlAddChild(xmlWriteObj.getXMLWriteRootNode(), xmlChildNodeOfRootNode2);
    
    for(MERoute *route in routes)
    {
        xmlNodePtr xmlChildNodeOfRoutesNode1 = xmlNewNode(NULL, BAD_CAST "route");
        xmlAddChild(xmlChildNodeOfRootNode2, xmlChildNodeOfRoutesNode1);
        
        xmlNewProp(xmlChildNodeOfRoutesNode1, BAD_CAST "id", BAD_CAST parse(route.ID));
        xmlNewProp(xmlChildNodeOfRoutesNode1, BAD_CAST "head", BAD_CAST parse(route.head));
        xmlNewProp(xmlChildNodeOfRoutesNode1, BAD_CAST "tail", BAD_CAST parse(route.tail));
        
        for (MEPoint *pointOfRoute in route.points) {
            
            xmlNodePtr xmlChildNodeOfRouteNode1 = xmlNewNode(NULL, BAD_CAST "point");
            xmlAddChild(xmlChildNodeOfRoutesNode1, xmlChildNodeOfRouteNode1);
            
            xmlNewProp(xmlChildNodeOfRouteNode1, BAD_CAST "id", BAD_CAST parse(pointOfRoute.ID));
            xmlNewProp(xmlChildNodeOfRouteNode1, BAD_CAST "x", BAD_CAST parse(pointOfRoute.point.x));
            xmlNewProp(xmlChildNodeOfRouteNode1, BAD_CAST "y", BAD_CAST parse(pointOfRoute.point.y));
        }
        
    }
    
    xmlNodePtr xmlChildNodeOfRootNode3 = xmlNewNode(NULL, BAD_CAST "playerPuts");
    xmlAddChild(xmlWriteObj.getXMLWriteRootNode(), xmlChildNodeOfRootNode3);
    
    for (MEPoint *playerPositionChildren in playerPosition) {
        
        xmlNodePtr xmlChildNodeOfPlayerPutsNode1 = xmlNewNode(NULL, BAD_CAST "playerPut");
        xmlAddChild(xmlChildNodeOfRootNode3, xmlChildNodeOfPlayerPutsNode1);
        
        xmlNodePtr xmlChildNodeOfPlayerPutNode1 = xmlNewNode(NULL, BAD_CAST "file");
        xmlNodePtr xmlChildNodeOfPlayerPutNode2 = xmlNewNode(NULL, BAD_CAST "position");
        xmlNodePtr xmlChildNodeOfPlayerPutNode3 = xmlNewNode(NULL, BAD_CAST "route");
        xmlAddChild(xmlChildNodeOfPlayerPutsNode1, xmlChildNodeOfPlayerPutNode1);
        xmlAddChild(xmlChildNodeOfPlayerPutsNode1, xmlChildNodeOfPlayerPutNode2);
        xmlAddChild(xmlChildNodeOfPlayerPutsNode1, xmlChildNodeOfPlayerPutNode3);
        
        
        xmlNewProp(xmlChildNodeOfPlayerPutsNode1, BAD_CAST "id", BAD_CAST parse(playerPositionChildren.ID));
        xmlNewProp(xmlChildNodeOfPlayerPutsNode1, BAD_CAST "user_group", BAD_CAST parse(playerPositionChildren.userGroup));
        
        xmlNewProp(xmlChildNodeOfPlayerPutNode1, BAD_CAST "location", BAD_CAST playerPositionChildren.fileLocation);
        
        
        xmlNewProp(xmlChildNodeOfPlayerPutNode2, BAD_CAST "x", BAD_CAST parse(playerPositionChildren.sprite->getPosition().x));
        xmlNewProp(xmlChildNodeOfPlayerPutNode2, BAD_CAST "y", BAD_CAST parse(playerPositionChildren.sprite->getPosition().y));
        xmlNewProp(xmlChildNodeOfPlayerPutNode2, BAD_CAST "direction", BAD_CAST parse(playerPositionChildren.direction));
        xmlNewProp(xmlChildNodeOfPlayerPutNode2, BAD_CAST "id", BAD_CAST "1");
        xmlNewProp(xmlChildNodeOfPlayerPutNode2, BAD_CAST "startPoint", BAD_CAST "0");
        
        
    }
    
    xmlNodePtr xmlChildNodeOfRootNode4 = xmlNewNode(NULL, BAD_CAST "systemPuts");
    xmlAddChild(xmlWriteObj.getXMLWriteRootNode(), xmlChildNodeOfRootNode4);
    
    for(MEPoint *systemPoint in systemPuts)
    {
        
        xmlNodePtr xmlChildNodeOfSystemPutsNode1 = xmlNewNode(NULL, BAD_CAST "systemPut");
        xmlAddChild(xmlChildNodeOfRootNode3, xmlChildNodeOfSystemPutsNode1);
        
        xmlNodePtr xmlChildNodeOfSystemPutNode1 = xmlNewNode(NULL, BAD_CAST "file");
        xmlNodePtr xmlChildNodeOfSystemPutNode2 = xmlNewNode(NULL, BAD_CAST "position");
        xmlNodePtr xmlChildNodeOfSystemPutNode3 = xmlNewNode(NULL, BAD_CAST "route");
        xmlAddChild(xmlChildNodeOfSystemPutsNode1, xmlChildNodeOfSystemPutNode1);
        xmlAddChild(xmlChildNodeOfSystemPutsNode1, xmlChildNodeOfSystemPutNode2);
        xmlAddChild(xmlChildNodeOfSystemPutsNode1, xmlChildNodeOfSystemPutNode3);
        
        
        xmlNewProp(xmlChildNodeOfSystemPutsNode1, BAD_CAST "id", BAD_CAST parse(systemPoint.ID));
        xmlNewProp(xmlChildNodeOfSystemPutsNode1, BAD_CAST "user_group", BAD_CAST parse(systemPoint.userGroup));
        
        xmlNewProp(xmlChildNodeOfSystemPutNode1, BAD_CAST "location", BAD_CAST systemPoint.fileLocation);
        
        xmlNewProp(xmlChildNodeOfSystemPutNode2, BAD_CAST "x", BAD_CAST parse(systemPoint.sprite->getPosition().x));
        xmlNewProp(xmlChildNodeOfSystemPutNode2, BAD_CAST "y", BAD_CAST parse(systemPoint.sprite->getPosition().y));
        xmlNewProp(xmlChildNodeOfSystemPutNode2, BAD_CAST "direction", BAD_CAST parse(systemPoint.direction));
        
        xmlNewProp(xmlChildNodeOfSystemPutNode3, BAD_CAST "id", BAD_CAST "1");
        xmlNewProp(xmlChildNodeOfSystemPutNode3, BAD_CAST "startPoint", BAD_CAST "0");
        
    }
    
    //数据处理结束
    
    //输出数据流到xml文件
    const char* path = [xmlWriteObj.getXMlFileSavePath() UTF8String];
    const char* encoding = [xmlWriteObj.getXMLWriteEncoding() UTF8String];
    xmlSaveFormatFileEnc(path, xmlWriteObj.getXMLDocWritePtr(),encoding, 1);
    NSLog(@"xml生成成功");
    
    //释放所占资源
    xmlFreeDoc(xmlWriteObj.getXMLDocWritePtr());
    xmlCleanupParser();
    xmlMemoryDump();
    return true;
}


/****************************
 输入：xml文件保存路径、xml版本、xml编码方式
 输出：初始化是否成功
 功能：初始化xml输入流需要的xml相关数据，为xml输入流操作做准备
 *****************************/
bool XMLWrite::XMLWriteInit(NSString *xmlFileSavePath,NSString *xmlWriteVersion,NSString *xmlWriteEncoding)
{
    this->setXMLFileSavePath(xmlFileSavePath);
    this->setXMLWriteVersion(xmlWriteVersion);
    this->setXMLWriteEncoding(xmlWriteEncoding);
    if (this->getXMlFileSavePath() == NULL || this->getXMLWriteVersion() == NULL || this->getXMLWriteEncoding() == NULL) {
        NSLog(@"xml数据初始化失败！");
        return false;
    }
    return true;
}


//以下全是成员变量的set方法和get方法

void XMLWrite::setXMLFileSavePath(NSString *xmlFileSavePath)
{
    this->xmlFileSavePath = xmlFileSavePath;
}
NSString* XMLWrite::getXMlFileSavePath()
{
    return this->xmlFileSavePath;
}
void XMLWrite::setXMLDocWritePtr(xmlDocPtr xmlDocWritePtr)
{
    this->xmlDocWritePtr = xmlDocWritePtr;
}
xmlDocPtr XMLWrite::getXMLDocWritePtr()
{
    return this->xmlDocWritePtr;
}
void XMLWrite::setXMLWriteRootNode(xmlNodePtr xmlWriteRootNode)
{
    this->xmlWriteRootNode = xmlWriteRootNode;
}
xmlNodePtr XMLWrite::getXMLWriteRootNode()
{
    return this->xmlWriteRootNode;
}
void XMLWrite::setXMLWriteVersion(NSString *xmlWriteVersion)
{
    this->xmlWriteVersion = xmlWriteVersion;
}
NSString* XMLWrite::getXMLWriteVersion()
{
    return this->xmlWriteVersion;
}
void XMLWrite::setXMLWriteEncoding(NSString *xmlWriteEncoding)
{
    this->xmlWriteEncoding = xmlWriteEncoding;
}
NSString* XMLWrite::getXMLWriteEncoding()
{
    return this->xmlWriteEncoding;
}