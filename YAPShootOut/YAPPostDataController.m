//
//  YAPPostDataController.m
//  ShootOut
//
//  Created by Sam Corder on 3/18/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import "YAPPostDataController.h"
#import "YapDatabase.h"

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
    self.connection = [database newConnection];
    self.rwconnection = [database newConnection];
    
    return self;
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
@end
