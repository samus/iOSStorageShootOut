//
//  PostDataControllerProtocol.h
//  ShootOut
//
//  Created by Sam Corder on 3/18/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostModelProtocol.h"

@protocol PostDataControllerProtocol <NSObject>
- (void)importPost:(NSDictionary *)postDict;
- (void)getPostById:(NSString *)postId completion:(void(^)(NSObject<PostModelProtocol>*))completion;
@end
