//
//  DSWeatherReportHeaderTableViewCell.m
//  DSWeatherApp
//
//  Created by bharadwaj Vangara on 2/19/18.
//  Copyright © 2018 bharadwaj Vangara. All rights reserved.
//

#import "DSWeatherReportHeaderTableViewCell.h"

@implementation DSWeatherReportHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)switchAction:(id)sender {
    UISegmentedControl *dayAndNightControl = (UISegmentedControl *)sender ;
    
    if([self.delegate respondsToSelector:@selector(didPressDayAndNightControl:)]){
        [self.delegate didPressDayAndNightControl:(UISegmentedControl *)dayAndNightControl];
    }
}

@end
