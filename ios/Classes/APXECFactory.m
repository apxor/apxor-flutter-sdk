//
//  APXECFactory.m
//  apxor_flutter
//
//  Created by Dasari Kousik on 27/03/24.
//

#import "APXECFactory.h"
#import "APXRTAPlugin/APXRTAPlugin.h"

@implementation APXECFactory{
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (nonnull instancetype)initWithMessenger:(nonnull NSObject<FlutterBinaryMessenger> *)messenger {
    self = [self init];
    if(self){
        _messenger = messenger;
    }
    return self;
}


- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    return [[APXEmbeddedView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec{
    return FlutterStandardMessageCodec.sharedInstance;
}

@end

@implementation APXEmbeddedView{
    UIView *_view;
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger{
    if(self = [super init]){
        NSInteger tag = [[args objectForKey:@"id"] integerValue];
        _view = [APXRTAPlugin initEmbedCardWithId:tag];
    }
    return self;
}

- (nonnull UIView *)view {
    return _view;
}

@end
