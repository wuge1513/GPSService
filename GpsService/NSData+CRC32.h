//
//  NSData+CRC32.h
//
//  Created by Guilherme Andrade on 12/21/11.
//  Copyright (c) 2011 2thinkers. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (CRC32)

+ (NSString *)CRC32:(NSData *)input;
- (NSString *)CRC32;

@end
