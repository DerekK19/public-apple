//
//  Repository.h
//  ProjectTimer
//
//  Created by Derek Knight on 6/06/11.
//  Copyright 2011 ASB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Logging.h"
#import "TaskModel.h"
#import "EventModel.h"

#define NOTIFICATION_TASKS @"TASKS_NOTIFY"
#define NOTIFICATION_EVENTS @"EVENTS_NOTIFY"


@interface DGKRepository : NSObject <NSFetchedResultsControllerDelegate>
{
    NSManagedObjectContext *managedObjectContext;
    
    NSFetchedResultsController *frcTasks;
    NSFetchedResultsController *frcEvents;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

-(NSFetchedResultsController *)Tasks;
-(NSFetchedResultsController *)Events;

- (TaskModel *)createTaskWithName:(NSString *)name
                        andColour:(UIColor *)colour
                  andTotalMinutes:(NSNumber *)totalMinutes;

- (TaskModel *)findTaskForRowAtIndexPath:(NSIndexPath *)indexPath;
- (TaskModel *)findTaskWithName: (NSString *)Name;

- (EventModel *)createEventForTask:(TaskModel *)task;

- (EventModel *)findEventForRowAtIndexPath:(NSIndexPath *)indexPath;
- (EventModel *)findEventWithStartTime: (NSDate *)StartTime;

- (void)save;
- (void)saveTasks;
- (void)saveEvents;

@end
