//
//  ModelFactory.h
//  GTD
//
//  Created by Derek Knight on 14/11/10.
//  Copyright (c) 2010 ASB. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ModelFactory : NSObject {

    NSFetchedResultsController *fetchedResultsController;

}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
