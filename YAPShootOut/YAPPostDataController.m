//
//  YAPPostDataController.m
//  ShootOut
//
//  Created by Sam Corder on 3/18/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import "YAPPostDataController.h"
#import "YapDatabase.h"

#import "YapDatabaseSecondaryIndex.h"

#import "NSCodingPost.h"

@interface YAPPostDataController ()
@property (nonatomic, strong) YapDatabase *database;
@property (nonatomic, strong) YapDatabaseConnection *connection;
@property (nonatomic, strong) YapDatabaseConnection *rwconnection;
@end

@implementation YAPPostDataController
- (instancetype)initWithDatabase:(YapDatabase *)database
{
    if ((self = [super self]) == nil) {
        return nil;
    }
    
    self.database = database;
    [self setupDatabase];
    self.connection = [database newConnection];
    self.rwconnection = [database newConnection];
    
    return self;
}

- (void)setupDatabase
{
    YapDatabaseSecondaryIndexSetup *scoreSetup = [[YapDatabaseSecondaryIndexSetup alloc] init];
    [scoreSetup addColumn:@"score" withType:YapDatabaseSecondaryIndexTypeReal];
    
    YapDatabaseSecondaryIndexHandler *scoreHandler = [YapDatabaseSecondaryIndexHandler withObjectBlock:^(NSMutableDictionary *dict, NSString *collection, NSString *key, id object) {
        if ([object isKindOfClass:[NSCodingPost class]]){
            NSCodingPost *post = (NSCodingPost *)object;
            
            [dict setObject:@(post.score) forKey:@"score"];
        }
    }];
    
    YapDatabaseSecondaryIndex *scoreIndex = [[YapDatabaseSecondaryIndex alloc]initWithSetup:scoreSetup handler:scoreHandler];
    [self.database registerExtension:scoreIndex withName:@"scoreIndex"];
    
}

- (void)importPost:(NSDictionary *)postDict
{
    NSCodingPost *post = [[NSCodingPost alloc]initWithDictionary:postDict];
    [self.rwconnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:post forKey:post.postId inCollection:@"posts"];
    }];
}

- (void)getPostById:(NSString *)postId completion:(void(^)(NSObject<PostModelProtocol>*))completion
{
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        if (completion) {
            completion((NSObject<PostModelProtocol>*)[transaction objectForKey:postId inCollection:@"posts"]);
        }
    }];
}

- (void)findPostsWithScoreOver:(NSInteger)score completion:(void (^)(NSArray *))completion
{
    if (completion == nil) {
        return;
    }
    [self.connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
        NSMutableArray *posts = [[NSMutableArray alloc]init];
        YapDatabaseQuery *query = [YapDatabaseQuery queryWithFormat:@"WHERE score >= ?", @(score)];
        [[transaction ext:@"scoreIndex"] enumerateKeysAndObjectsMatchingQuery:query
                                                            usingBlock:^(NSString *collection, NSString *key, id object, BOOL *stop) {
                                                                [posts addObject:object];
                                                            }];

        completion(posts);
    }];
}

- (void)clearAll
{
    [self.rwconnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction removeAllObjectsInCollection:@"posts"];
    }];
}
@end
