//
//  NSData+CRC32.m
//
//  Created by Guilherme Andrade on 12/21/11.
//  Copyright (c) 2011 2thinkers. All rights reserved.
//

#import "NSData+CRC32.h"
#import "zlib.h"

@implementation NSData (CRC32)

+ (NSString *)CRC32:(NSData *)input {
    uLong crcValue = crc32(0L, NULL, 0L);
    crcValue = crc32(crcValue, (const Bytef*)input.bytes, input.length);
    
    return [NSString stringWithFormat:@"%lx", crcValue];
}

- (NSString *)CRC32 {
    return [NSData CRC32:self];
}

@end
