//
//  ViewController.h
//  YAPShootOut
//
//  Created by Sam Corder on 3/17/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostDataControllerProtocol.h"

@interface ShootOutViewController : UIViewController

@property (nonatomic, strong) NSObject<PostDataControllerProtocol> *postDataController;

@end

