//
//  DGKViewController.m
//  Repeater
//
//  Created by Derek Knight on 23/09/12.
//  Copyright (c) 2012 Derek Knight. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "DGKViewController.h"

@interface DGKViewController ()
{
    int _seconds;
    int _repeats;
    int _counter;
    int _count;
    NSTimer *_timer;
    NSTimer *_countdown;
    NSTimer *_trigger;
    UIColor *_initialBackground;
    SystemSoundID _beep;
}

- (void)timerFired:(NSTimer *)timer;
- (void)countdownTriggered:(NSTimer *)timer;
- (void)countdownFired:(NSTimer *)timer;
- (void)setLabelText:(int)seconds;
- (void)setResetButtonLabel:(NSString *)text;

@end

@implementation DGKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _initialBackground = self.view.backgroundColor;
    
    _seconds = 48;
    _counter = 5;
    _repeats = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didPressReset:(id)sender
{
    if (!_timer)
    {
        self.view.backgroundColor = (_repeats % 2 == 0) ? [UIColor blueColor] : [UIColor redColor];
        [self setLabelText:_seconds];
        _timer = [NSTimer scheduledTimerWithTimeInterval:_seconds
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil
                                                 repeats:YES];
        _countdown = [NSTimer scheduledTimerWithTimeInterval:_seconds-_counter
                                                  target:self
                                                selector:@selector(countdownTriggered:)
                                                userInfo:nil
                                                 repeats:NO];
        NSString* path = [[NSBundle mainBundle] pathForResource:@"beep"
                                                         ofType:@"wav"];
        if (path != nil)
        {
            NSURL* url = [NSURL fileURLWithPath:path];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_beep);
        }
        [self setResetButtonLabel:@"Stop"];
    }
    else
    {
        self.view.backgroundColor = _initialBackground;
        [_timer invalidate];
        _timer = nil;
        [_trigger invalidate];
        _trigger = nil;
        [_countdown invalidate];
        _countdown = nil;
        AudioServicesDisposeSystemSoundID(_beep);
        _beep = 0;
        [self setLabelText:0];
        [self setResetButtonLabel:@"Start"];
    }
}

- (void)timerFired:(NSTimer *)timer
{
    [self setLabelText:_seconds];
    self.view.backgroundColor = (++_repeats % 2 == 0) ? [UIColor blueColor] : [UIColor redColor];
    [_countdown invalidate];
    _countdown = nil;
    _trigger = [NSTimer scheduledTimerWithTimeInterval:_seconds-_counter
                                                target:self
                                              selector:@selector(countdownTriggered:)
                                              userInfo:nil
                                               repeats:NO];
    if (_beep != 0) AudioServicesPlaySystemSound(_beep);
}

- (void)countdownTriggered:(NSTimer *)timer
{
    self.view.backgroundColor = [UIColor yellowColor];
    _count = _counter;
    [self setLabelText:_counter];
    _countdown = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(countdownFired:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)countdownFired:(NSTimer *)timer
{
    [self setLabelText:--_count];
}

- (void)setLabelText:(int)seconds
{
    if (seconds > _counter)
        _label.text = [NSString stringWithFormat:@"Counting down from %d\nseconds", seconds];
    else if (seconds > 0)
        _label.text = [NSString stringWithFormat:@"%d\nseconds", seconds];
    else
        _label.text = @"Press button to start timer";

}

- (void)setResetButtonLabel:(NSString *)text
{
    [_reset setTitle:text forState:UIControlStateNormal];
    [_reset setTitle:text forState:UIControlStateSelected];
    [_reset setTitle:text forState:UIControlStateHighlighted];
}

@end
