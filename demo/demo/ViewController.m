//
//  ViewController.m
//  demo
//
//  Created by linzhiman on 16/3/31.
//  Copyright © 2016年 linzhiman. All rights reserved.
//

#import "ViewController.h"
#import "ATWebViewJavaScriptCore.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) ATWebViewJavaScriptCore *bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _bridge = [ATWebViewJavaScriptCore bridgeForWebView:_webView webViewDelegate:nil];
    [_bridge registerAction:[[ATWebViewJavaScriptCoreTestAction alloc] init]];
    
    NSURL *testUrl = [ATWebViewJavaScriptCoreTestAction testUrl];
    [_webView loadRequest:[NSURLRequest requestWithURL:testUrl]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
