//
//  RealmPostDataController.m
//  ShootOut
//
//  Created by Alex Robinson on 3/19/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import "RealmPostDataController.h"
#import "PostParser.h"
#import "Post.h"
#import <Realm/Realm.h>

@implementation RealmPostDataController

- (void)setupDatabase
{
 
    
}

- (void)importPost:(NSDictionary *)postDict
{
        //Do import here
        Post *post = [[Post alloc] init];
        post.postId = postDict[@"Id"];
        post.score = [postDict[@"Score"] integerValue];
        post.ownerUserId = postDict[@"OwnerUserId"];
        post.body = postDict[@"Body"];
        post.title = postDict[@"Title"];
        post.tags = postDict[@"Tags"];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addObject:post];
        [realm commitWriteTransaction];
    
}

- (void)getPostById:(NSString *)postId completion:(void(^)(NSObject<PostModelProtocol>*))completion
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"postId = %@", postId];
    RLMResults *posts = [Post objectsWithPredicate:pred];
    completion(posts.firstObject);
}

- (void)findPostsWithScoreOver:(NSInteger)score completion:(void (^)(NSArray *))completion
{
    if (completion == nil) {
        return;
    }
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"score > %@", @(score)];
    RLMResults *results = [Post objectsWithPredicate:pred];
    
    NSArray *posts = [self RLMResultsToNSArray:results];
    
    completion(posts);
}

- (void)clearAll
{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

-(NSArray *)RLMResultsToNSArray:(RLMResults *)results {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:results.count];
    for (RLMObject *object in results) {
        [array addObject:object];
    }
    return array;
}

@end
