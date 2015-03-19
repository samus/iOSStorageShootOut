//
//  FMDBPostDataController.h
//  ShootOut
//
//  Created by Sam Corder on 3/18/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PostDataControllerProtocol.h"

@class FMDatabase;

@interface FMDBPostDataController : NSObject<PostDataControllerProtocol>
- (instancetype)initWithDatabasePath:(NSString *)databasePath;
@end
