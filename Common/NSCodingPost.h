//
//  NSCodingPost.h
//  ShootOut
//
//  Created by Sam Corder on 3/18/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostModelProtocol.h"

@interface NSCodingPost : NSObject<NSCoding, PostModelProtocol>
- (instancetype)initWithDictionary:(NSDictionary *)postDict;
@end
