//
//  LMVideoCell.m
//  百家"闻"坛
//
//  Created by lim on 16/2/18.
//  Copyright © 2016年 lim. All rights reserved.
//

#import "LMVideoCell.h"
#import "LMVideoView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface LMVideoCell ()

/** 头像 */
@property (strong, nonatomic) UIImageView *profileImageView;
/** 昵称 */
@property (strong, nonatomic) UILabel *nameLabel;
/** 时间 */
@property (strong, nonatomic) UILabel *createTimeLabel;
/** 更多按钮 */
@property (strong, nonatomic) UIButton *moreButton;
/** 顶 */
@property (strong, nonatomic) UIButton *dingButton;
/** 踩 */
@property (strong, nonatomic) UIButton *caiButton;
/** 分享 */
@property (strong, nonatomic) UIButton *shareButton;
/** 评论 */
@property (strong, nonatomic) UIButton *commentButton;
/** 新浪加V */
@property (strong, nonatomic) UIImageView *sinaVView;
/** 文字标签*/
@property (strong, nonatomic) UILabel *text_label;
/** 视频视图 */
@property (nonatomic, strong) LMVideoView *videoView;

@end

@implementation LMVideoCell

- (LMVideoView *)videoView {
    if (!_videoView) {
        LMVideoView *videoView = [LMVideoView videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addAllChildViews];
    }
    return self;
}

- (void)addAllChildViews {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
    //头像视图
    UIImageView *profileImageView = [[UIImageView alloc]init];
    self.profileImageView = profileImageView;
    [self addSubview:profileImageView];
    [profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.width.height.equalTo(@35);
    }];
    //姓名label
    UILabel *nameLabel = [[UILabel alloc]init];
    self.nameLabel = nameLabel;
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    nameLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(profileImageView.mas_right).offset(10);
        make.top.equalTo(self).offset(10);
    }];
    //时间label
    UILabel *createTimeLabel = [[UILabel alloc]init];
    self.createTimeLabel = createTimeLabel;
    createTimeLabel.font = [UIFont systemFontOfSize:12];
    createTimeLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:createTimeLabel];
    [createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.bottom.equalTo(profileImageView.mas_bottom);
    }];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:@"cellmorebtnnormal"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    self.moreButton = moreButton;
    [self addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.width.height.equalTo(@20);
    }];
    
    UILabel *text_label = [[UILabel alloc]init];
    self.text_label = text_label;
    self.text_label.numberOfLines = 0;
    text_label.font = [UIFont systemFontOfSize:14];
    text_label.textColor = [UIColor darkTextColor];
    [self addSubview:text_label];
    [text_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(profileImageView.mas_left);
        make.top.equalTo(profileImageView.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-10);
    }];
    
    LMVideoView *videoView = [LMVideoView videoView];
    self.videoView = videoView;
    [self addSubview:videoView];
    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(profileImageView.mas_left);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(text_label.mas_bottom).offset(10);
    }];
    
    UIButton *dingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dingButton = dingButton;
    dingButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [dingButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:dingButton];
    
    UIButton *caiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.caiButton = caiButton;
    caiButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [caiButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:caiButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton = shareButton;
    shareButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [shareButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:shareButton];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton = commentButton;
    commentButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:commentButton];
    
    [dingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(profileImageView.mas_left);
        make.right.equalTo(caiButton.mas_left);
        make.top.equalTo(videoView.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(shareButton.mas_width);
        make.width.equalTo(caiButton.mas_width);
        make.width.equalTo(commentButton.mas_width);
    }];
    [caiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shareButton.mas_left);
        make.top.equalTo(videoView.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(-10);
        
    }];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(commentButton.mas_left);
        make.top.equalTo(videoView.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(-10);
    }];
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(10);
        make.top.equalTo(videoView.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    
}

- (void)setVideoModal:(LMVideoModal *)videoModal {
    _videoModal = videoModal;
    
    // 新浪加V
    self.sinaVView.hidden = !videoModal.isSina_v;
    
    // 设置头像
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:videoModal.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    // 设置名字
    self.nameLabel.text = videoModal.name;
    
    // 设置帖子的创建时间
    self.createTimeLabel.text = videoModal.create_time;
    
    // 设置按钮文字和图片
    [self setupButtonTitle:self.dingButton count:videoModal.ding placeholder:@"顶" picture:@"mainCellDing"];
    [self setupButtonTitle:self.caiButton count:videoModal.cai placeholder:@"踩" picture:@"mainCellCai"];
    [self setupButtonTitle:self.shareButton count:videoModal.repost placeholder:@"分享" picture:@"mainCellShare"];
    [self setupButtonTitle:self.commentButton count:videoModal.comment placeholder:@"评论" picture:@"mainCellComment"];
    
    //设置文字
    self.text_label.text = videoModal.text;
    
    //视频帖子
    self.videoView.hidden = NO;
    self.videoView.videoModal = videoModal;
    self.videoView.frame = videoModal.videoF;
}

/**
 * 设置底部按钮文字
 */
- (void)setupButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder picture:(NSString *)imageName{
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    } else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%ld", count];
    }
    [button setTitle:placeholder forState:UIControlStateNormal];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)more {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏", @"举报", nil];
    [sheet showInView:self.window];
}


@end
