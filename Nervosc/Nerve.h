//
//  Nerve.h
//  NervoscDaemon
//
//  Created by julien@macmini on 26/02/16.
//  Copyright © 2016 jbloit. All rights reserved.
//

#ifndef Nerve_h
#define Nerve_h

#import "PTExampleProtocol.h"
#include "PTChannel.h"

@interface Nerve :  NSObject <PTChannelDelegate>

+ (instancetype) sharedInstance;
- (void)sendMessage:(NSString*)message;

@end




#endif /* Nerve_h */
