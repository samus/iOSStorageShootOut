//
//  NSUserDefaultsPostDataController.m
//  ShootOut
//
//  Created by Alex Argo on 3/19/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import "NSUserDefaultsPostDataController.h"
#import "NSCodingPost.h"

@interface NSUserDefaultsPostDataController ()

@property (nonatomic, retain) NSMutableArray *posts;

@end

@implementation NSUserDefaultsPostDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"Posts"];
        if(!array) {
            _posts = [NSMutableArray array];
        } else {
            _posts = array;
        }
    }
    return self;
}

- (void)importPost:(NSDictionary *)postDict {
    [self.posts addObject:postDict];
}

- (void)getPostById:(NSString *)postId completion:(void(^)(NSObject<PostModelProtocol>*))completion {
    for(NSDictionary *post in self.posts) {
        if([post[@"Id"] isEqualToString:postId]) {
            NSCodingPost *postToReturn = [[NSCodingPost alloc]initWithDictionary:post];
            completion(postToReturn);
            return;
        }
    }
    completion(nil);
    
}

- (void)finishedImportingPosts {

    [[NSUserDefaults standardUserDefaults] setObject:self.posts forKey:@"Posts"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)findPostsWithScoreOver:(NSInteger)score completion:(void(^)(NSArray *posts))completion {
    NSMutableArray *postsWithScoreOver = [NSMutableArray array];
    for (NSDictionary *post in self.posts) {
        NSInteger testScore = [post[@"Score"] integerValue];
        if(testScore>=score) {
            [postsWithScoreOver addObject:post];
        }
    }
    
    completion(postsWithScoreOver);
    
}

- (void)clearAll {
    self.posts = [NSMutableArray array];
    [[NSUserDefaults standardUserDefaults] setObject:self.posts forKey:@"Posts"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
