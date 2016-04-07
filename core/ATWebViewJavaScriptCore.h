//
//  ATWebViewJavaScriptCore.h
//  apptemplate
//
//  Created by linzhiman on 16/3/30.
//  Copyright © 2016年 apptemplate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

/*
 App与WebView页面交互规范
 1、App在WebView注入一个对象window.appJavaScriptBridge。
 2、页面JavaScript在调用Native方法前需设置回调函数
    window.appJavaScriptBridge.setCallback(callback)；
    其中callback为 function callback(command, argument)，函数名可自定义；
    callback函数会存放在window.appJavaScriptBridge.callback
 3、页面JavaScript调用Native
    window.appJavaScriptBridge.callNative(command, argument);
 4、Native调用页面JavaScript
    window.appJavaScriptBridge.callback(command, argument);
 5、参数说明
    command为 String，标记需要调用的方法；
    argument为 JSON对象，调用方法需要的参数；
 6、示例
    ATWebViewJavaScriptCore.html
 */

@class ATWebViewJavaScriptCore;

//ATWebViewJavaScriptCoreAction

@protocol ATWebViewJavaScriptCoreAction <NSObject>

@property (nonatomic, weak) ATWebViewJavaScriptCore *bridge;

- (NSString *)command;
- (void)actionWithArgument:(NSDictionary *)argument;

@end

//ATWebViewJavaScriptCoreDelegate

@protocol ATWebViewJavaScriptCoreDelegate <JSExport>

- (void)setCallback:(JSValue *)callback;
JSExportAs(callNative,
           - (void)callNative:(NSString *)command argument:(NSDictionary *)argument
           );

@end

//ATWebViewJavaScriptCore

@interface ATWebViewJavaScriptCore : NSObject<UIWebViewDelegate, ATWebViewJavaScriptCoreDelegate>

- (void)registerAction:(id<ATWebViewJavaScriptCoreAction>)action;
- (void)callJavaScriptWithCommand:(NSString *)command argument:(NSDictionary *)argument;

+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(id<UIWebViewDelegate>)webViewDelegate;

@end

//ATWebViewJavaScriptCoreTestAction

@interface ATWebViewJavaScriptCoreTestAction : NSObject<ATWebViewJavaScriptCoreAction>

@property (nonatomic, weak) ATWebViewJavaScriptCore *bridge;

+ (NSURL *)testUrl;

@end;
