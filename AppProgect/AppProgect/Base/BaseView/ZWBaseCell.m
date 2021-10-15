//
//  ZWBaseCell.m
//  NBJKCardHome
//
//  Created by step_zhang on 2020/11/26.
//

#import "ZWBaseCell.h"

@implementation ZWBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self zw_setupViews];
        [self zw_bindViewModel];
    }
    return self;
}

- (void)zw_setupViews{}

- (void)zw_bindViewModel{}
@end
