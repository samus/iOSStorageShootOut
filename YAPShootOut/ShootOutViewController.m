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
@property (weak, nonatomic) IBOutlet UILabel *postIdLbl;
@property (weak, nonatomic) IBOutlet UIWebView *bodyWebView;

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

- (IBAction)getPostTapped:(id)sender
{
    [self.postDataController getPostById:self.postIdLbl.text completion:^(NSObject<PostModelProtocol> *post) {
        if (post == nil) {
            [self.bodyWebView loadHTMLString:@"<H1>Post Not Found</H1>" baseURL:nil];
            return;
        }
        NSString *body = [NSString stringWithFormat:@"<h3>%@</h3>%@", post.title, post.body];
        [self.bodyWebView loadHTMLString:body baseURL:nil];
    }];
}

@end
