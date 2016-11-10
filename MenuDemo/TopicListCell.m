//
//  TopicListCell.m
//  MenuDemo
//
//  Created by 宋炬峰 on 2016/11/9.
//  Copyright © 2016年 appfactory. All rights reserved.
//

#import "TopicListCell.h"
#import "TopicViewModel.h"
#import "TopicModel.h"

@interface TopicListCell ()
@property(nonatomic, strong)UILabel* titleLabel;
@end

@implementation TopicListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

- (void)clearData{
    self.titleLabel.text = @"";
}

- (void)loadCellData:(TopicViewModel*)model{
    self.titleLabel.text = model.topic.title;
}

@end
