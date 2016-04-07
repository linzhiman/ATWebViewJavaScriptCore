//
//  ATWebViewJavaScriptCore.m
//  apptemplate
//
//  Created by linzhiman on 16/3/30.
//  Copyright © 2016年 apptemplate. All rights reserved.
//

#import "ATWebViewJavaScriptCore.h"

#define CheckCurrentWebView(returnValue) \
    if (webView != _webView) { return returnValue; }

@interface ATWebViewJavaScriptCore ()

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) id<UIWebViewDelegate> webViewDelegate;
@property (nonatomic, strong) NSMutableArray *actions;

@end

@implementation ATWebViewJavaScriptCore

- (void)dealloc
{
    _webView.delegate = nil;
    _webView = nil;
    _webViewDelegate = nil;
}

- (void)bridgeForWebView:(UIWebView*)webView webViewDelegate:(id<UIWebViewDelegate>)webViewDelegate
{
    _webView = webView;
    _webViewDelegate = webViewDelegate;
    _webView.delegate = self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    CheckCurrentWebView(YES)
    
    if ([_webViewDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        [_webViewDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    CheckCurrentWebView()
    
    if ([_webViewDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_webViewDelegate webViewDidStartLoad:webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CheckCurrentWebView()
    
    [self insertAppServiceScript];
    
    if ([_webViewDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_webViewDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    CheckCurrentWebView()
    
    if ([_webViewDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_webViewDelegate webView:webView didFailLoadWithError:error];
    }
}

- (void)insertAppServiceScript
{
    JSContext *context = [self context];
    context[@"appJavaScriptBridge"] = self;
}

- (void)registerAction:(id<ATWebViewJavaScriptCoreAction>)action
{
    if (!_actions) {
        _actions = [[NSMutableArray alloc] init];
    }
    action.bridge = self;
    [_actions addObject:action];
}

- (void)setCallback:(JSValue *)callback
{
    JSContext *context = [self context];
    context[@"appJavaScriptBridge"][@"callback"] = callback;
}

- (void)callNative:(NSString *)command argument:(NSDictionary *)argument
{
    for (id<ATWebViewJavaScriptCoreAction> action in _actions) {
        if ([command isEqualToString:[action command]]) {
            [action actionWithArgument:argument];
        }
    }
}

- (void)callJavaScriptWithCommand:(NSString *)command argument:(NSDictionary *)argument
{
    JSContext *context = [self context];
    NSData *data = [NSJSONSerialization dataWithJSONObject:argument options:NSJSONWritingPrettyPrinted error:nil];
    NSString *argumentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [context evaluateScript:[NSString stringWithFormat:@"appJavaScriptBridge.callback('%@', %@)", command, argumentString]];
}

- (JSContext *)context
{
    return [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
}

+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(id<UIWebViewDelegate>)webViewDelegate
{
    ATWebViewJavaScriptCore* bridge = [[[self class] alloc] init];
    [bridge bridgeForWebView:webView webViewDelegate:webViewDelegate];
    return bridge;
}

@end

@implementation ATWebViewJavaScriptCoreTestAction

- (NSString *)command
{
    return @"GetSomething";
}

- (void)actionWithArgument:(NSDictionary *)argument
{
    if (self.bridge) {
        [self.bridge callJavaScriptWithCommand:@"onGetSomething" argument:@{@"argument":argument}];
    }
}

+ (NSURL *)testUrl
{
    return [[NSBundle mainBundle] URLForResource:@"ATWebViewJavaScriptCore" withExtension:@"html"];
}

@end
