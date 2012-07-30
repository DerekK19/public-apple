//
//  Logging.h
//  FastMobile
//
//  Created by Derek Knight on 9/03/11.
//  Copyright 2011 ASB. All rights reserved.
//

// How to use this
// In your .m file #define LOW_LEVEL_DEBUG as TRUE
// before you include this header file
// Use DEBUGLog instead of NSLog

// DEBUGLog will only log output if LOW_LEVEL_DEBUG is TRUE, ERRORLog will always log output

// example

//#define LOW_LEVEL_DEBUG FALSE
//
//#import "Logging.h"
//
//
// - void)myFunction
//{
//    DEBUGLog(@""); // This records the function name, which is handy
//    DEBUGLog(@"Display a message, with argument %d", 1);
//    ERRORLog(@"An error occurred: %@, [error description]);
//}

//Note (ex http://www.cimgf.com/2010/05/02/my-current-prefix-pch-file/ ):
/*
 As for the do {} while (0) instead of nothing is because there are a few rare code situations where replacing DLog(@”"); with ; can cause issues. Replacing it with do {} while(0); is safer in those rare cases and will get optimized out by the compiler anyway.
 */

#if (LOW_LEVEL_DEBUG == TRUE)
#define DEBUGLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DEBUGLog(...) do {} while(0);
#endif

#define ERRORLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
