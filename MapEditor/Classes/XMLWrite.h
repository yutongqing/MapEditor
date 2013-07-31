//
//  XMLWrite.h
//  Game
//
//  Created by Zhang Baowen on 13-7-29.
//
//

#ifndef Game_XMLWrite_h
#define Game_XMLWrite_h

#include <libxml2/libxml/parser.h>
#include <libxml2/libxml/tree.h>
#include <cocos2d.h>
#include "MERoute.h"
#include "MEPoint.h"

class XMLWrite {
    char *xmlFileSavePath;//xml文件保存路径，由用户选择
    xmlDocPtr xmlDocWritePtr = NULL;//指向写入xml文件的指针
    xmlNodePtr xmlWriteRootNode = NULL;//写入xml的根节点
    char *xmlWriteVersion;//xml版本，一般值是"1.0"
    char *xmlWriteEncoding;//xml文件的编码，一般是"utf-8",不是的话就要强制转换
    
public:
    //所有成员变量的set和get方法
    void setXMLFileSavePath(char *xmlFileSavePath);
    char* getXMlFileSavePath();
    void setXMLDocWritePtr(xmlDocPtr xmlDocWritePtr);
    xmlDocPtr getXMLDocWritePtr();
    void setXMLWriteRootNode(xmlNodePtr xmlWriteRootNode);
    xmlNodePtr getXMLWriteRootNode();
    void setXMLWriteVersion(char *xmlVersion);
    char* getXMLWriteVersion();
    void setXMLWriteEncoding(char *xmlWriteEncoding);
    char* getXMLWriteEncoding();
    //根据通过参数获取的N个对象，从中读取需要的数据，并按一定的格式输出到xml文件中
    bool xmlDataWrite(XMLWrite xmlWriteObj,MERoute **route, MEPoint *playerPosition,MEPoint *playerRoute,int bgmap_x,int bgmap_y,char *bgmapPath);
    //调用写入XML方法前需要调用的xml初始化方法
    bool XMLWriteInit(char *xmlFileSavePath, char *xmlWriteVersion, char *xmlWriteEncoding);
};

#endif
