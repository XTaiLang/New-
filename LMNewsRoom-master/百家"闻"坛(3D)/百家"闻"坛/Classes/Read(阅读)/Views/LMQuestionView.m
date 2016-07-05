//
//  LMQuestionView.m
//  onlyOne
//
//  Created by lim on 16/2/22.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMQuestionView.h"
#import "LMBaseFun.h"

@interface LMQuestionView ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;// item 加载中转转的菊花
@end

@implementation LMQuestionView {
    LMQuestionModal *currentQuestionModal;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setUpViews];
    }
    
    return self;
}

- (void)setUpViews {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.bounds];
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scalesPageToFit = NO;
    self.webView.tag = WebViewTag;
    self.webView.backgroundColor = WebViewBGColor;
    self.webView.scrollView.backgroundColor = WebViewBGColor;
    self.webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
    self.webView.multipleTouchEnabled = NO;
    self.webView.scrollView.scrollsToTop = YES;
    [self addSubview:self.webView];
    
    // 初始化加载中的菊花控件
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.hidesWhenStopped = YES;
    [self addSubview:self.indicatorView];
}

- (void)startRefreshing {
    self.indicatorView.center = self.center;
    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.indicatorView startAnimating];
}

- (void)configureQuestionViewWithQuestionModal:(LMQuestionModal *)questionModal {
    currentQuestionModal = questionModal;
    
//     如果当前的问题内容没有获取过来，就暂时直接加载该问题对应的官方手机版网页
    if (IsStringEmpty(questionModal.strQuestionId)) {
        self.dateLabel.superview.hidden = YES;
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.wufazhuce.com/question/2016-02-22"]]];
    } else {
        self.dateLabel.superview.hidden = NO;
        self.dateLabel.text = [LMBaseFun enMarketTimeWithOriginalMarketTime:questionModal.strQuestionMarketTime];
        
        NSString *webViewBGColor = @"#ffffff";
        NSString *webViewContentTextColor = DawnWebViewTextColorName;
        NSString *separateLineColor = @"#d4d4d4";
        
        NSMutableString *HTMLString = [[NSMutableString alloc] init];
        // Questin Title
        [HTMLString appendString:[NSString stringWithFormat:@"<body style=\"margin: 0px; background-color: %@;\"><div style=\"margin-bottom: 0px; margin-top: 0px; background-color: %@;\"><div style=\"margin-bottom: 100px; margin-top: 34px;\"><table style=\"width: 100%%;\"><tbody style=\"display: table-row-group; vertical-align: middle; border-color: inherit;\"><tr style=\"display: table-row; vertical-align: inherit;\"><td style=\"width: 84px;\" align=\"center\"><img style=\"width: 42px; height: 42px; vertical-align: middle;\" alt=\"问题\" src=\"http://s2-cdn.wufazhuce.com/m.wufazhuce/images/question.png\" /></td>", webViewBGColor, webViewBGColor]];
        [HTMLString appendString:[NSString stringWithFormat:@"<td><p style=\"margin-top: 0; margin-left: 0; color: %@; font-size: 16px; font-weight: bold;\">%@</p></td></tr></tbody></table>", webViewContentTextColor, questionModal.strQuestionTitle]];
        // Question Content
        [HTMLString appendString:[NSString stringWithFormat:@"<div style=\"line-height: 26px; margin-top: 14px;\"><p style=\"margin-left: 20px; margin-right: 20px; margin-bottom: 0; color: %@; text-shadow: none; font-size: 15px;\">%@</p></div>", webViewContentTextColor, questionModal.strQuestionContent]];
        // Separate Line
        [HTMLString appendString:[NSString stringWithFormat:@"<div style=\"margin-top: 15px; margin-bottom: 15px; width: 95%%; height: 1px; background-color: %@; margin-left: auto; margin-right: auto;\"></div>", separateLineColor]];
        // Answer Title
        [HTMLString appendString:[NSString stringWithFormat:@"<table style=\"width: 100%%;\"><tbody style=\"display: table-row-group; vertical-align: middle; border-color: inherit;\"><tr style=\"display: table-row; vertical-align: inherit; border-color: inherit;\"><td style=\"width: 84px;\" align=\"center\"><img style=\"width: 42px; height: 42px; vertical-align: middle;\" alt=\"回答\" src=\"http://s2-cdn.wufazhuce.com/m.wufazhuce/images/answer.png\" /></td><td align=\"left\"><p style=\"margin-top: 0; margin-left: 0; color: %@; font-size: 16px; font-weight: bold; margin-right: 20px; margin-bottom: 0; text-shadow: none;\">%@</p></td></tr></tbody></table>", webViewContentTextColor, questionModal.strAnswerTitle]];
        // Answer Content
        [HTMLString appendString:[NSString stringWithFormat:@"<div style=\"line-height: 26px; margin-top: 14px;\"><p></p><p style=\"margin-left: 20px; margin-right: 20px; margin-bottom: 0; color: %@; text-shadow: none; font-size: 15px;\">%@</p><p></p></div>", webViewContentTextColor, questionModal.strAnswerContent]];
        // Question Editor
        [HTMLString appendString:[NSString stringWithFormat:@"<p style=\"color: #333333; font-style: oblique; margin-left: 20px; margin-right: 20px; margin-bottom: 0; text-shadow: none; font-size: 15px;\">%@</p></div></div></body>", questionModal.sEditor]];
        
        [self.webView loadHTMLString:HTMLString baseURL:nil];
    }
    self.webView.delegate = self;
    [self.webView.scrollView scrollsToTop];
}

- (void)refreshSubviewsForNewItem {
    self.dateLabel.text = @"";
    
    self.webView.hidden = YES;
    
    [self startRefreshing];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicatorView stopAnimating];
    self.webView.hidden = NO;
    
    if (isGreatThanIOS9) {
        CGFloat activationPointX = self.webView.scrollView.accessibilityActivationPoint.x;
        if (activationPointX > 0 && activationPointX < SCREEN_WIDTH) {
            self.webView.scrollView.scrollsToTop = YES;
        } else {
            self.webView.scrollView.scrollsToTop = NO;
        }
    }
    
    // 获取网页内容的真实高度
    CGFloat webBrowserViewHeight = 0;
    for (id view in webView.scrollView.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIWebBrowserView")]) {
            webBrowserViewHeight = ((UIView *)view).frame.size.height;
            break;
        }
    }
    
    CGSize readingContentSize = webView.scrollView.contentSize;
    readingContentSize.height = webBrowserViewHeight;
    webView.scrollView.contentSize = readingContentSize;
    
}

@end
