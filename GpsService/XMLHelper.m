//
//  XMLHelper.m
//  GpsService
//
//  Created by LiuLei on 12-3-2.
//  Copyright (c) 2012年 LiuLei. All rights reserved.
//

#import "XMLHelper.h"
#import "LLFileManage.h"
#import "TBXML.h"

@implementation XMLHelper

/*!
 * 获取配置文件单一节点
 * @param firstNode
 * @param secNode
 */
+ (NSString *)getNodeStr:(NSString *)firstNode secondNode:(NSString *)secNode
{
    NSData *data;
    //判断配置文件是否已经下载
    NSString *fileName = @"config.xml";
    BOOL fileIsExist = [LLFileManage fileIsExist:fileName];
    if (fileIsExist) {
        NSLog(@"已经下载到本地");
        data = [LLFileManage ReadFromFile:fileName];
        //NSLog(@"data1==%@", data);
    }else{        
        data = [LLFileManage ReadLocalFile:@"config" FileType:@"xml"];
        //NSLog(@"data2==%@", data);
    }

    
    TBXML *tbxml = [TBXML tbxmlWithXMLData:data error:nil];
    TBXMLElement * root = tbxml.rootXMLElement;
    
	if (root) {
        TBXMLElement *tmpNode1 = [TBXML childElementNamed:firstNode parentElement:root];
        if (tmpNode1) {
            
            TBXMLElement *tmpNode2 = [TBXML childElementNamed:secNode parentElement:tmpNode1];
            if (tmpNode2) {
                NSString *strResult = [TBXML textForElement:tmpNode2];
                NSLog(@"strResult = %@", strResult);
                return strResult;
            }
        }
    }
    
    return nil;
}
@end
