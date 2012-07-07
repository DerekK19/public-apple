//
//  DGKCurrentTableViewCell.m
//  ProjectTimer
//
//  Created by Derek Knight on 6/06/11.
//  Copyright 2011 ASB. All rights reserved.
//

#define LOW_LEVEL_DEBUG TRUE

#import "CurrentTableViewCell.h"

@implementation DGKCurrentTableViewCell

@synthesize label;
@synthesize detail;
@synthesize button;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGRect rect;

//        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // Create a label for the task name
        rect = CGRectMake(10, 0, 200, 30);
        label = [[UILabel alloc] initWithFrame:rect];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:label];
        label.highlightedTextColor = [UIColor whiteColor];
        [label release];
        
        // Create a label for the work to date
        rect = CGRectMake(10, 25, 200, 15);
        detail = [[UILabel alloc] initWithFrame:rect];
        detail.font = [UIFont boldSystemFontOfSize:10];
        detail.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:detail];
        detail.highlightedTextColor = [UIColor whiteColor];
        [detail release];

        // Create a button for the Start/Stop behaviour
        rect = CGRectMake(254, 7, 60, 30);
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:rect];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        button.backgroundColor = [UIColor redColor];
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius = 10.0f;
        [button setTitle:@"Start" forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        //[button release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected
              animated:animated];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    label.backgroundColor = backgroundColor;
    detail.backgroundColor = backgroundColor;
}

- (void)dealloc
{
    [label release];
    [detail release];
    [button release];
    [super dealloc];
}

- (void)showTaskRunning
{
    [button setTitle:@"Stop" forState:UIControlStateNormal];  
    button.backgroundColor = [UIColor greenColor];
}

- (void)showTaskStopped
{
    [button setTitle:@"Start" forState:UIControlStateNormal];  
    button.backgroundColor = [UIColor redColor];
}

- (IBAction)buttonPressed:(id)sender
{
    if (button.titleLabel.text == @"Start")
    {
        [self showTaskRunning];
    }
    else
    {
        [self showTaskStopped];
    }
}
@end
