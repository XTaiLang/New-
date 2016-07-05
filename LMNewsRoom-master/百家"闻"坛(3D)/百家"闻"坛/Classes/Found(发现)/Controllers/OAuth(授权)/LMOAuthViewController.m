//
//  LMOAuthViewController.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMOAuthViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "LMAccount.h"
#import "LMAccountTool.h"

#define LMOAuthBaseUrl @"https://api.weibo.com/oauth2/authorize"
#define LMClient_id @"2004282461"
#define LMRedirect_uri @"http://www.baidu.com"
#define LMAppSecret @"8e2823592b7a47ce51278689e2167ac5"

@interface LMOAuthViewController ()<UIWebViewDelegate>

@end

@implementation LMOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //展示登录的网页 -> UIWebView
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    //加载网页
    //完整的URL：一个基本URL+参数https://api.weibo.com/oauth2/authorize?client_id=&redirect_uri=
    //基本URL: https://api.weibo.com/oauth2/authorize

    //拼接URL字符串
    NSString *URLStr = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",LMOAuthBaseUrl,LMClient_id,LMRedirect_uri];
    //创建URL
    NSURL *url = [NSURL URLWithString:URLStr];
    //创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //加载请求
    [webView loadRequest:request];
    //设置代理
    webView.delegate = self;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //提示用户正在加载。。。
    [MBProgressHUD showMessage:@"正在加载..."];
}
//webView加载完成时调用
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //移除提示框
    [MBProgressHUD hideHUD];
}
//加载失败时移除提示框
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUD];
}

//拦截WebView请求
//当webView需要加载请求的时候，就会调用这个方法，询问是否请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //获取请求的URL
    NSString *urlStr = request.URL.absoluteString;
    //获取code（RequsetToken）
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.length) {//有code=
        //ranger.length + range.location 是指code=后的第一个字符的下标
        NSString *code = [urlStr substringFromIndex:range.location + range.length];
        //换取accessToken
        [self accessTokenWithCode:code];
        return NO;
    }
    return YES;
}
#pragma mark - 换取acessToken
- (void)accessTokenWithCode:(NSString *)code {
    
    [LMAccountTool accountWithCode:code success:^{
        //进入发现刷微博界面
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        //请求失败时调用
        NSLog(@"%@",error);
    }];
    
}

@end
