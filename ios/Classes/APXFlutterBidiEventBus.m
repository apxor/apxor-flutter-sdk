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
#import "ApxorFlutterPlugin.h"
#import <Flutter/Flutter.h>

static FlutterBasicMessageChannel *card_channel = nil;
static NSObject<FlutterBinaryMessenger> *messenger = nil;
@implementation APXFlutterBidiEventBus {
    NSMutableDictionary *receivers;
}
- (void) sendAndGetWithData: (NSDictionary *)data receiver:(Receiver)receiver {
    id<APXBidiDelegate> otherBus = [[APXController sharedController] getBidiEventsBusWithKey:@"APXOR_FLUTTER_C"];
    if (nil != otherBus) {
        [otherBus receiveAndRespondWithData:data receiver:receiver];
    }
}

- (void)receiveAndRespondWithData:(NSMutableDictionary *)data receiver:(Receiver)receiver {
    NSString *eName = nil;
    Receiver eReceiver = receiver;
    NSString *name = [data valueForKey:@"n"];
    NSTimeInterval currentTimeMillis = [[NSDate date] timeIntervalSince1970] * 1000;
    long long time = (long long)currentTimeMillis;
    [data setValue:@(time) forKey:@"t"];
    NSString *eTime = [NSString stringWithFormat:@"%lld", time];
    
    if ([name isEqualToString:@"apx_d"]) {
        eName = @"d";
    } else if ([name isEqualToString:@"apx_f"]) {
        eName = @"f";
    } else if ([name isEqualToString:@"apx_avf"]) {
        eName = @"avf";
    } else if ([name isEqualToString:@"apx_iwv"]) {
        eName = @"iwv";
    } else if ([name isEqualToString:@"apx_ec"]){
        eName = @"EC";
    }
    
    if (nil != eName) {
        if (receivers == nil) {
            receivers = [NSMutableDictionary dictionary];
        }
        //add receivers to it
        [receivers setValue:eReceiver forKey:[[eName stringByAppendingString:@"_"] stringByAppendingString:eTime]];
        
        [[APXController sharedController] logInternalEventWithName:eName info:data];
        [[APXController sharedController] registerForEventWithType:APXEventTypeInternal listener:self];
    }
}

- (void)onEvent:(APXEvent *)event {
    NSDictionary *data = [event getAdditionalInfo];
    NSString *eventName = event.identifier;
    
    if ([receivers objectForKey:eventName]) {
        [[APXController sharedController] deregisterForEventWithType:APXEventTypeInternal listener:self];
        Receiver eventReceiver = [self->receivers objectForKey:eventName];
        eventReceiver([data valueForKey:@"r"]);
        
        [receivers removeObjectForKey:eventName];
    }
}

@end
