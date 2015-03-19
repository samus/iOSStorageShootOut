//
//  NSKeyedArchiverPostDataController.m
//  ShootOut
//
//  Created by Alex Argo on 3/19/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import "NSKeyedArchiverPostDataController.h"
#import "NSCodingPost.h"

@interface NSKeyedArchiverPostDataController ()

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, copy) NSString *fileName;

@end

@implementation NSKeyedArchiverPostDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileName = @"posts.data";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:_fileName];
        
        NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        if(!array) {
            _posts = [NSMutableArray array];
        } else {
            _posts = array;
        }
    }
    return self;
}

- (void)importPost:(NSDictionary *)postDict {
    NSCodingPost *post = [[NSCodingPost alloc] initWithDictionary:postDict];
    [self.posts addObject:post];
}

- (void)getPostById:(NSString *)postId completion:(void(^)(NSObject<PostModelProtocol>*))completion {
    for(NSCodingPost *post in self.posts) {
        if([post.postId isEqualToString:postId]) {
            completion(post);
            return;
        }
    }
    completion(nil);
    
}

- (void)archive {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //file name to write the data to using the documents directory:
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",
                          documentsDirectory,self.fileName];
    
    [NSKeyedArchiver archiveRootObject:self.posts toFile:filePath];
}

- (void)finishedImportingPosts {
    
    [self archive];
}

- (void)findPostsWithScoreOver:(NSInteger)score completion:(void(^)(NSArray *posts))completion {
    NSMutableArray *postsWithScoreOver = [NSMutableArray array];
    for (NSCodingPost *post in self.posts) {
        if(post.score>=score) {
            [postsWithScoreOver addObject:post];
        }
    }
    
    completion(postsWithScoreOver);
    
}

- (void)clearAll {
    self.posts = [NSMutableArray array];
    [self archive];
}

@end
