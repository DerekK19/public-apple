//
//  TaskModel.m
//  ProjectTimer
//
//  Created by Derek Knight on 29/05/11.
//  Copyright 2011 ASB. All rights reserved.
//

#define LOW_LEVEL_DEBUG FALSE

#import "TaskModel.h"

@implementation TaskModel

@dynamic Name;
@dynamic colour;
@dynamic totalMinutes;
@dynamic notes;
@dynamic events;

- (NSString *)PrettyPrint:(NSInteger)minutes
{
    if (minutes == 0)
        return @"No time";
    if (minutes < 60)
        return [NSString stringWithFormat:@"%d min%s", minutes, minutes == 1 ? "ute" : "s"];
    int hours = minutes / 60;
    minutes = minutes % 60;
    if (minutes == 0)
        return [NSString stringWithFormat:@"%d hour%s", hours, hours == 1 ? "" : "s"];
    return [NSString stringWithFormat:@"%d hour%s %d min%s", hours, hours == 1 ? "" : "s", minutes, minutes == 1 ? "ute" : "s"];
}

- (NSInteger)minutesToday
{
    return 1;
}
- (NSInteger)minutesThisWeek
{
    return 11;
}
- (NSInteger)minutesThisMonth
{
    return 111;
}
- (NSInteger)minutesRemaining
{
    return [[self totalMinutes]intValue] - 131;
}
- (NSInteger)minutesTotal
{
    return [[self totalMinutes]intValue];
}

- (NSString *)PrettyPrintTimeToday;
{
    return [self PrettyPrint:[self minutesToday]];
}
- (NSString *)PrettyPrintTimeThisWeek
{
    return [self PrettyPrint:[self minutesThisWeek]];
}
- (NSString *)PrettyPrintTimeThisMonth
{
    return [self PrettyPrint:[self minutesThisMonth]];
}
- (NSString *)PrettyPrintTimeRemaining
{
    return [self PrettyPrint:[self minutesRemaining]];
}
- (NSString *)PrettyPrintTimeTotal
{
    return [self PrettyPrint:[self minutesTotal]];
}

@end
