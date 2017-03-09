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
 2、页面JavaScript调用Native
    window.appJavaScriptBridge.callNative(command, argument);
    如果需要App回调，需将callback函数挂在window.appJavaScriptBridge，函数名自定义，如callbackName，并在argument中添加字段'callback':'callbackName'；
    其中callback为 function callbackName(command, argument)；
 3、Native调用页面JavaScript
    window.appJavaScriptBridge.callbackName(command, argument);
 4、参数说明
    command为 String，标记需要调用的方法；
    argument为 String，内容为JSON对象，调用方法需要的参数；App回调时为JSON对象；
 5、示例
    ATWebViewJavaScriptBridge.html
 */

@class ATWebViewJavaScriptCore;

//ATWebViewJavaScriptCoreAction

@protocol ATWebViewJavaScriptCoreAction <NSObject>

@property (nonatomic, weak) ATWebViewJavaScriptCore *bridge;

- (NSString *)command;
- (void)actionWithArgument:(NSDictionary *)argument callback:(NSString *)callback;

@end

//ATWebViewJavaScriptCoreDelegate

@protocol ATWebViewJavaScriptCoreDelegate <JSExport>

JSExportAs(callNative,
           - (void)callNative:(NSString *)command argument:(NSDictionary *)argument
           );

@end

//ATWebViewJavaScriptCore

@interface ATWebViewJavaScriptCore : NSObject<UIWebViewDelegate, ATWebViewJavaScriptCoreDelegate>

- (void)registerAction:(id<ATWebViewJavaScriptCoreAction>)action;
- (void)callJavaScriptWithCommand:(NSString *)command argument:(NSDictionary *)argument callback:(NSString *)callback;

+ (instancetype)bridgeForWebView:(UIWebView*)webView webViewDelegate:(id<UIWebViewDelegate>)webViewDelegate;

@end

//ATWebViewJavaScriptCoreTestAction

@interface ATWebViewJavaScriptCoreTestAction : NSObject<ATWebViewJavaScriptCoreAction>

@property (nonatomic, weak) ATWebViewJavaScriptCore *bridge;

+ (NSURL *)testUrl;

@end;
