//
//  PostModelProtocol.h
//  ShootOut
//
//  Created by Sam Corder on 3/18/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PostModelProtocol <NSObject>
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *ownerUserId;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *tags;
@end
