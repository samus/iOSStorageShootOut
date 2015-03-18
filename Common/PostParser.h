//
//  PostParser.h
//  ShootOut
//
//  Created by Sam Corder on 3/18/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostParser : NSObject
- (NSTimeInterval)parsePostsWithPostCallBack:(void (^)(NSDictionary * post))postCallBack;
@end
