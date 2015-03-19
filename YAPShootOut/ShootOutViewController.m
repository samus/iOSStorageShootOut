//
//  ViewController.m
//  YAPShootOut
//
//  Created by Sam Corder on 3/17/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import "ShootOutViewController.h"
#import "PostParser.h"

@interface ShootOutViewController ()

@end

@implementation ShootOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)import:(id)sender
{
    PostParser *parser = [[PostParser alloc]init];
    NSTimeInterval time = [parser parsePostsWithPostCallBack:^(NSDictionary *post) {
        [self.postDataController importPost:post];
    }];
    NSLog(@"Seconds to complete importing, %f", time);
}


@end
