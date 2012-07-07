//
//  EventModel.h
//  ProjectTimer
//
//  Created by Derek Knight on 29/05/11.
//  Copyright 2011 ASB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Logging.h"
#import "BaseModel.h"
#import "TaskModel.h"

@interface EventModel : DGKBaseModel
{
    
}

@property (nonatomic, retain) NSDate *Start;
@property (nonatomic, retain) NSDate *Finish;
@property (nonatomic, retain) TaskModel *task;

@end
