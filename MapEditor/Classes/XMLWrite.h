//
//  XMLWrite.h
//  Game
//
//  Created by Zhang Baowen on 13-7-29.
//
//

#ifndef MAPEDITOR_XMLWrite
#define MAPEDITOR_XMLWrite

#include <libxml2/libxml/parser.h>
#include <libxml2/libxml/tree.h>
#include <cocos2d.h>
#include "MERoute.h"
#include "MEPoint.h"

class XMLWrite {
    NSString *xmlFileSavePath;//xml文件保存路径，由用户选择
    xmlDocPtr xmlDocWritePtr = NULL;//指向写入xml文件的指针
    xmlNodePtr xmlWriteRootNode = NULL;//写入xml的根节点
    NSString *xmlWriteVersion;//xml版本，一般值是"1.0"
    NSString *xmlWriteEncoding;//xml文件的编码，一般是"utf-8",不是的话就要强制转换
    
public:
    //所有成员变量的set和get方法
    void setXMLFileSavePath(NSString *xmlFileSavePath);
    NSString* getXMlFileSavePath();
    void setXMLDocWritePtr(xmlDocPtr xmlDocWritePtr);
    xmlDocPtr getXMLDocWritePtr();
    void setXMLWriteRootNode(xmlNodePtr xmlWriteRootNode);
    xmlNodePtr getXMLWriteRootNode();
    void setXMLWriteVersion(NSString *xmlVersion);
    NSString* getXMLWriteVersion();
    void setXMLWriteEncoding(NSString *xmlWriteEncoding);
    NSString* getXMLWriteEncoding();
    //根据通过参数获取的N个对象，从中读取需要的数据，并按一定的格式输出到xml文件中
    bool xmlDataWrite(XMLWrite xmlWriteObj,NSMutableArray *routes, NSMutableArray *playerPosition,NSMutableArray *systemPuts,float bgmap_width,float bgmap_height,const NSString *bgmapFilePath);
    //调用写入XML方法前需要调用的xml初始化方法
    bool XMLWriteInit(NSString *xmlFileSavePath,NSString *xmlWriteVersion,NSString *xmlWriteEncoding);
};

#endif
