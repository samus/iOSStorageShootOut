//
//  ViewController.m
//  YAPShootOut
//
//  Created by Sam Corder on 3/17/15.
//  Copyright (c) 2015 Synapptic Labs. All rights reserved.
//

#import "ViewController.h"
#import "PostParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)import:(id)sender
{
    PostParser *parser = [[PostParser alloc]init];
    NSTimeInterval time = [parser parsePostsWithPostCallBack:^(NSDictionary *post) {
        //Do import here
    }];
    NSLog(@"Seconds to complete importing, %f", time);
}


@end
