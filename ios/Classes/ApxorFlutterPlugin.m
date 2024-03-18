//
//  ApxorFlutterPlugin.m
//  ApxorSDK
//
//  Created by Ramcharan  on 20/07/23.
//  Copyright © 2023 Apxor. All rights reserved.
//

#import "ApxorFlutterPlugin.h"
#import "ApxorSDK/ApxorSDK.h"
#import "ApxorSDK/APXController.h"
#import "ApxorSDK/APXBidiDelegate.h"
#import "APXFlutterBidiEventBus.h"

static FlutterBasicMessageChannel *command_channel = nil;

@implementation ApxorFlutterPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        [[APXController sharedController] registerForEventWithType:APXEventTypeInternal listener:self];
        [[APXController sharedController] markAsFlutter];
        id<APXBidiDelegate> bus = [[APXFlutterBidiEventBus alloc] init];
        [[APXController sharedController] registerForBidiEventsBus:bus WithKey:@"APXOR_FLUTTER_W"];
    }
    return self;
}

+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

    // method channel for communication between flutter and ApxorSDK
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugins.flutter.io/apxor_flutter"
            binaryMessenger:[registrar messenger]];
    ApxorFlutterPlugin* instance = [[ApxorFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    // basic message channel for communication between ApxorSDK and flutter
    command_channel = [FlutterBasicMessageChannel messageChannelWithName:@"plugins.flutter.io/apxor_commands" binaryMessenger:[registrar messenger] codec:[FlutterJSONMessageCodec sharedInstance]];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"logAppEvent" isEqualToString:call.method]) {
        NSDictionary *info;
        if ([call.arguments valueForKey:@"attrs"] != [NSNull null]) {
            info = [call.arguments valueForKey:@"attrs"];
        } else {
            info = nil;
        }
        [ApxorSDK logAppEventWithName:[call.arguments valueForKey:@"name"] info:info];
        [command_channel sendMessage:@{@"name" : @"hello"}];
        result(nil);
    } else if ([@"logClientEvent" isEqualToString:call.method]) {
        NSDictionary *info;
        if ([call.arguments valueForKey:@"attrs"] != [NSNull null]) {
            info = [call.arguments valueForKey:@"attrs"];
        } else {
            info = nil;
        }
        [ApxorSDK logClientEventWithName:[call.arguments valueForKey:@"name"] info:info];
        result(nil);
    }  else if ([@"logInternalEvent" isEqualToString:call.method]) {
        NSDictionary *info;
        if ([call.arguments valueForKey:@"attrs"] != [NSNull null]) {
            info = [call.arguments valueForKey:@"attrs"];
        } else {
            info = nil;
        }
        [[APXController sharedController] logInternalEventWithName:[call.arguments valueForKey:@"name"] info:info];
        result(nil);
    } else if ([@"setUserIdentifier" isEqualToString:call.method]) {
        [ApxorSDK setUserIdentifier: [call.arguments valueForKey:@"userId"]];
        result(nil);
    } else if ([@"setUserAttributes" isEqualToString:call.method]) {
        [ApxorSDK setUserCustomInfo: call.arguments];
        result(nil);
    } else if ([@"setSessionAttributes" isEqualToString:call.method]) {
        [ApxorSDK setSessionCustomInfo: call.arguments];
        result(nil);
    } else if ([@"setCurrentScreenName" isEqualToString:call.method]) {
        [ApxorSDK logScreenWithName:[call.arguments valueForKey:@"name"]];
        result(nil);
    } else if ([@"trackScreen" isEqualToString:call.method]){
        [ApxorSDK logScreenWithName:[call.arguments valueForKey:@"name"]];
        result(nil);
    } else if ([@"getDeviceId" isEqualToString:call.method]) {
        if ([ApxorSDK getDeviceID]){
            result([ApxorSDK getDeviceID]);
        } else {
            result(nil);
        }
    } else if ([@"gfn" isEqualToString:call.method]) {
        result(@(0));
    } else {
        NSArray *layout = [call.arguments valueForKey:@"r"];
        NSNumber *time = [call.arguments valueForKey:@"t"];
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        [data setValue:layout forKey:@"r"];
        if ([@"dr" isEqualToString:call.method]) {
            [[APXController sharedController] logInternalEventWithName:[@"d_" stringByAppendingString:[time stringValue]] info:data];
        } else if ([@"fr" isEqualToString:call.method]) {
            [[APXController sharedController] logInternalEventWithName:[@"f_" stringByAppendingString:[time stringValue]] info:data];
        } else if ([@"avf" isEqualToString:call.method]) {
            [[APXController sharedController] logInternalEventWithName:[@"avf_" stringByAppendingString:[time stringValue]] info:data];
        }
    }
}

- (void)onEvent:(APXEvent *)event {
    NSMutableDictionary *data = [[event getAdditionalInfo] mutableCopy];
    NSString *eName = event.identifier;
    [data setValue:eName forKey:@"name"];
    if ([eName isEqualToString:@"d"] || [eName isEqualToString:@"f"] || [eName isEqualToString:@"iwv"] || [eName isEqualToString:@"avf"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [command_channel sendMessage:data];
        });
    } else if ([eName isEqualToString:@"apx_redirection"]) {
        NSMutableDictionary *eData = [NSMutableDictionary dictionary];
        [eData setValue:data[@"url"] forKey:@"u"];
        [eData setValue:@(-1) forKey:@"t"];
        [eData setValue:@"redirect" forKey:@"name"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [command_channel sendMessage:eData];
        });
    }
}

@end
