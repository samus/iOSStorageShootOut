//
//  NSCodingPost.m
//  ShootOut
//
//  Created by Sam Corder on 3/18/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import "NSCodingPost.h"

@interface NSCodingPost ()

@end

@implementation NSCodingPost

@synthesize postId = _postId;
@synthesize score = _score;
@synthesize ownerUserId = _ownerUserId;
@synthesize body = _body;
@synthesize title = _title;
@synthesize tags = _tags;

- (id)initWithCoder:(NSCoder *)decoder // NSCoding deserialization
{
    if ((self = [super init]) == nil) {
        return nil;
    }
    
    self.postId = [decoder decodeObjectForKey:@"Id"];
    self.score = [(NSNumber *)[decoder decodeObjectForKey:@"Score"] integerValue];
    self.ownerUserId = [decoder decodeObjectForKey:@"OwnerUserId"];
    self.body = [decoder decodeObjectForKey:@"Body"];
    self.title = [decoder decodeObjectForKey:@"Title"];
    self.tags = [decoder decodeObjectForKey:@"Tags"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder // NSCoding serialization
{
    [encoder encodeObject:self.postId forKey:@"Id"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.score] forKey:@"Score"];
    [encoder encodeObject:self.ownerUserId forKey:@"OwnerUserId"];
    [encoder encodeObject:self.body forKey:@"Body"];
    [encoder encodeObject:self.title forKey:@"Title"];
    [encoder encodeObject:self.tags forKey:@"Tags"];
}

- (instancetype)initWithDictionary:(NSDictionary *)postDict
{
    if ((self = [super init]) == nil) {
        return nil;
    }
    
    self.postId = postDict[@"Id"];
    self.score = [((NSString *)postDict[@"score"]) integerValue];
    self.ownerUserId = postDict[@"OwnerUserId"];
    self.body = postDict[@"Body"];
    self.title = postDict[@"Title"];
    self.tags = postDict[@"Tags"];
    
    return self;
}
@end
