//
//  BaseModel.h
//  OnesNotes
//
//  Created by Derek Knight on 29/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ModelFactory;

@interface BaseModel : NSManagedObject {
    
    ModelFactory *modelFactory;
    NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)initWithFetchedResultsController: (NSFetchedResultsController*) aFetchedResultsController;
- (void)delete;
- (UIColor *) colourWithHexString: (NSString *) stringToConvert;
- (NSString *) hexStringWithColour  : (UIColor *) color;

@end
