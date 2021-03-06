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
@required
- (void)importPost:(NSDictionary *)postDict;
@optional
- (void)finishedImportingPosts;
@required
- (void)getPostById:(NSString *)postId completion:(void(^)(NSObject<PostModelProtocol>*))completion;
- (void)findPostsWithScoreOver:(NSInteger)score completion:(void(^)(NSArray *posts))completion;
- (void)clearAll;
@end
