//
//  FMDBPostDataController.m
//  ShootOut
//
//  Created by Sam Corder on 3/18/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import "FMDBPostDataController.h"

#import "FMDB.h"

#import "PostModelProtocol.h"
#import "NSCodingPost.h"

@interface FMDBPostDataController ()
@property (nonatomic, strong) NSOperationQueue *backgroundQueue;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@end

@implementation FMDBPostDataController

- (instancetype)initWithDatabasePath:(NSString *)databasePath
{
    if ((self = [super init]) == nil) {
        return nil;
    }
    
    self.backgroundQueue = [[NSOperationQueue alloc]init];
    self.dbQueue = [[FMDatabaseQueue alloc]initWithPath:databasePath];
    [self setupDatabase];
    return self;
}

- (void)setupDatabase
{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"CREATE TABLE if not exists Posts "
         "(Id TEXT UNIQUE, OwnerUserId TEXT, Score INTEGER, Body TEXT, Title TEXT, Tags TEXT);"];
        
        [db executeUpdate:@"CREATE INDEX if not exists "
         "scoreIndex on Posts (Score);"];
    }];

}

- (void)importPost:(NSDictionary *)postDict
{
    [self.backgroundQueue addOperationWithBlock:^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = @"INSERT INTO Posts (Id, OwnerUserId, Score, Body, Title, Tags) VALUES (?,?,?,?,?,?);";
            [db executeUpdate:sql, postDict[@"Id"], postDict[@"OwnerUserId"], @([((NSString *)postDict[@"Score"]) integerValue]), postDict[@"Body"], postDict[@"Title"], postDict[@"Tags"]];
        }];
    }];
}

- (void)findPostsWithScoreOver:(NSInteger)score completion:(void (^)(NSArray *))completion
{
    NSString *sql = @"SELECT Id, OwnerUserId, Score, Body, Title, Tags FROM Posts WHERE score >= ?";
    NSMutableArray *posts = [[NSMutableArray alloc]init];
    [self query:sql parameters:@[@(score)] result:^(FMResultSet *results) {
        while ([results next]) {
            [posts addObject:[self postFromResultSet:results]];
        }
    } completion:^{
        completion(posts);
    }];
}

- (void)getPostById:(NSString *)postId completion:(void (^)(NSObject<PostModelProtocol> *))completion
{
    if (completion == NULL) {
        return;
    }
    
    NSString *sql = @"SELECT Id, OwnerUserId, Score, Body, Title, Tags FROM Posts WHERE Id = ?";
    __block NSObject<PostModelProtocol> *post;
    [self query:sql parameters:@[postId] result:^(FMResultSet *results) {
        while ([results next]) {
            post = [self postFromResultSet:results];
        }
    } completion:^{
        completion(post);
    }];
}

- (void)query:(NSString *)sql parameters:(NSArray *)params result:(void (^)(FMResultSet *results))resultBlock completion:(void (^)())completion
{
    [self.backgroundQueue addOperationWithBlock:^{
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *results = [db executeQuery:sql withArgumentsInArray:params];
            if (resultBlock) {
                resultBlock(results);
            }
        }];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    }];
}

- (void)clearAll
{
    [self.backgroundQueue addOperationWithBlock:^{
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = @"DELETE FROM Posts";
            [db executeUpdate:sql];
        }];
    }];
}

- (NSObject<PostModelProtocol> *)postFromResultSet:(FMResultSet *)result
{
    NSCodingPost *p = [[NSCodingPost alloc]init];
    p.postId = [result stringForColumn:@"Id"];
    p.ownerUserId = [result stringForColumn:@"OwnerUserId"];
    p.score = [result longForColumn:@"Score"];
    p.body = [result stringForColumn:@"Body"];
    p.title = [result stringForColumn:@"Title"];
    p.tags = [result stringForColumn:@"Tags"];
    
    return p;
}
@end
