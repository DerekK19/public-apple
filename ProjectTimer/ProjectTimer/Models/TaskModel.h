//
//  TaskModel.h
//  ProjectTimer
//
//  Created by Derek Knight on 29/05/11.
//  Copyright 2011 ASB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Logging.h"
#import "BaseModel.h"

@interface TaskModel : DGKBaseModel
{
    
}

@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) UIColor *colour;
@property (nonatomic, retain) NSNumber *totalMinutes;
@property (nonatomic, retain) NSString *notes;
@property (nonatomic, retain) NSSet *events;

- (NSInteger)minutesToday;
- (NSInteger)minutesThisWeek;
- (NSInteger)minutesThisMonth;
- (NSInteger)minutesRemaining;
- (NSInteger)minutesTotal;

- (NSString *)PrettyPrintTimeToday;
- (NSString *)PrettyPrintTimeThisWeek;
- (NSString *)PrettyPrintTimeThisMonth;
- (NSString *)PrettyPrintTimeRemaining;
- (NSString *)PrettyPrintTimeTotal;

@end
