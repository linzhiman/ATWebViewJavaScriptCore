# ATWebViewJavaScriptCore

## App与WebView页面交互规范

1、App在WebView注入一个对象window.appJavaScriptBridge。  

2、页面JavaScript调用Native  

    window.appJavaScriptBridge.callNative(command, argument);
    如果需要App回调，需将callback函数挂在window.appJavaScriptBridge，函数名自定义，如callbackName，并在argument中添加字段'callback':'callbackName'；
    其中callback为 function callbackName(command, argument)；

3、Native调用页面JavaScript  

    window.appJavaScriptBridge.callbackName(command, argument);  

4、参数说明  

    command为 String，标记需要调用的方法；  
    argument为 JSON对象，调用方法需要的参数；  

5、示例  

    ATWebViewJavaScriptCore.html  

## 使用

1、将core中的文件加入工程  
2、加入头文件  

    #import "ATWebViewJavaScriptCore.h”  

3、新建属性或变量持有bridge对象  

    @property (nonatomic, strong) ATWebViewJavaScriptCore *bridge;  

4、创建bridge对象，会将webView的delegate设置为bridge对象，bridge对象处理完再回调webViewDelegate，webViewDelegate可以为空  

    _bridge = [ATWebViewJavaScriptCore bridgeForWebView:_webView webViewDelegate:nil];  

5、注册处理动作，每个页面调用实现一个Action，可以添加多个Action  

    [_bridge registerAction:[[ATWebViewJavaScriptCoreTestAction alloc] init]];  

6、加载测试页面  

    NSURL *testUrl = [ATWebViewJavaScriptCoreTestAction testUrl];  
    [_webView loadRequest:[NSURLRequest requestWithURL:testUrl]];  


