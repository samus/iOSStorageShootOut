//
//  PostParser.m
//  ShootOut
//
//  Created by Sam Corder on 3/18/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import "PostParser.h"

#import "CHCSVParser.h"

@interface PostParser () <CHCSVParserDelegate>
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;

@property (nonatomic, strong) NSMutableDictionary *postDict;
@property (nonatomic, copy) void (^postCallBack)(NSDictionary *post);
@end

@implementation PostParser
- (NSTimeInterval)parsePostsWithPostCallBack:(void (^)(NSDictionary * post))postCallBack
{

    self.postCallBack = postCallBack;
    
    NSString* fileRoot = [[NSBundle mainBundle] pathForResource:@"Posts" ofType:@"csv"];
    NSURL *postURL = [NSURL fileURLWithPath:fileRoot];

    CHCSVParser *parser = [[CHCSVParser alloc]initWithContentsOfCSVURL:postURL];
    parser.delegate = self;
    parser.sanitizesFields = YES;
    [parser parse];

    return [self.end timeIntervalSinceDate:self.start];

}

- (void)parserDidBeginDocument:(CHCSVParser *)parser
{
    self.start = [NSDate date];
}

- (void)parserDidEndDocument:(CHCSVParser *)parser
{
    self.end = [NSDate date];
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    if (recordNumber == 1) { //field headers
        return;
    }
    self.postDict = [[NSMutableDictionary alloc]init];
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    if (self.postDict && self.postCallBack) {
        self.postCallBack(self.postDict);
    }
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    static NSArray *keys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @[@"Id", @"Score", @"OwnerUserId", @"Body", @"Title", @"Tags"];
    });
    if (self.postDict == nil) {
        return;
    }
    
    self.postDict[keys[fieldIndex]] = field;
}
@end
