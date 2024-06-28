//
//  APXStoryFactory.m
//  apxor_flutter
//
//  Created by Dasari Kousik on 03/05/24.
//

#import "APXStoryFactory.h"
#import "APXRTAPlugin/APXRTAPlugin.h"

@implementation APXStoryFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    return [[APXStoryView alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

@end

@implementation APXStoryView {
    UIView *_view;
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self = [super init];
    if (self) {
        NSInteger tag = [[args objectForKey:@"id"] integerValue];
        _view = [APXRTAPlugin initStoriesWithId:tag];
    }
    return self;
}

- (UIView *)view {
    return _view;
}

@end
