//
//  DWMUtility.h
//  D Window Manager
//
//  Created by Derek Knight on 29/06/12.
//  Copyright (c) 2012 ASB. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @interface DWMUtility
 @addtogroup Classes
 @{
 */
/**
 @brief Utility class
 
 Utility functions, typically these will be class methods rather then instance methods
 */
@interface DWMUtility : NSObject

/**
 @brief Is this runnng on an iPad
 
 Is the application running on an iPad
 
 @return Is this an iPad?
 */
+ (BOOL) isIPad;

/**
 @brief Parse the current configration's device orientations
 
 Get a list of device orientations from the set of descriptions, which would have con from the app's plist
 
 @param orientations The list of descriptions
 @return The list of orientations
 */
+ (NSArray*) parseInterfaceOrientations:(NSArray*)orientations;

@end

/** @} */