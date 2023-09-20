//
//  APXFlutterBidiEventBus.m
//  ApxorSDK
//
//  Created by Ramcharan  on 20/07/23.
//  Copyright © 2023 Apxor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APXFlutterBidiEventBus.h"
#import "ApxorSDK/APXController.h"

@implementation APXFlutterBidiEventBus {
    NSString *eName;
    NSString *eTime;
    Receiver eReceiver;
}

- (void) sendAndGetWithData: (NSDictionary *)data receiver:(Receiver)receiver {
    id<APXBidiDelegate> otherBus = [[APXController sharedController] getBidiEventsBusWithKey:@"APXOR_FLUTTER_C"];
    if (nil != otherBus) {
        [otherBus receiveAndRespondWithData:data receiver:receiver];
    }
}

- (void)receiveAndRespondWithData:(NSMutableDictionary *)data receiver:(Receiver)receiver {
    eName = nil;
    eReceiver = receiver;
    NSString *name = [data valueForKey:@"n"];
    NSTimeInterval currentTimeMillis = [[NSDate date] timeIntervalSince1970] * 1000;
    long long time = (long long)currentTimeMillis;
    [data setValue:@(time) forKey:@"t"];
    eTime = [NSString stringWithFormat:@"%lld", time];
    
    if ([name isEqualToString:@"apx_d"]) {
        eName = @"d";
    } else if ([name isEqualToString:@"apx_f"]) {
        eName = @"f";
    } else if ([name isEqualToString:@"apx_iwv"]) {
        eName = @"iwv";
    }
    
    if (nil != eName) {
        [[APXController sharedController] logInternalEventWithName:eName info:data];
        [[APXController sharedController] registerForEventWithType:APXEventTypeInternal listener:self];
    }
}

- (void)onEvent:(APXEvent *)event {
    NSDictionary *data = [event getAdditionalInfo];
    NSString *eventName = event.identifier;
    if ([eventName isEqualToString:[[eName stringByAppendingString:@"_"] stringByAppendingString:eTime]]) {
        [[APXController sharedController] deregisterForEventWithType:APXEventTypeInternal listener:self];
        eReceiver([data valueForKey:@"r"]);
    }
}

@end
