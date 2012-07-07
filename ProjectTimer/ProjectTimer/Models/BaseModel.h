//
//  BaseModel.h
//  OnesNotes
//
//  Created by Derek Knight on 29/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Logging.h"

@class DGKModelFactoryJunk;

@interface DGKBaseModel : NSManagedObject
{    
    NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)initWithFetchedResultsController: (NSFetchedResultsController*) aFetchedResultsController;
- (void)delete;
- (UIColor *) colourWithHexString: (NSString *) stringToConvert;
- (NSString *) hexStringWithColour  : (UIColor *) color;

@end
