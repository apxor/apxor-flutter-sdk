//
//  APXECFactory.h
//  apxor_flutter
//
//  Created by Dasari Kousik on 27/03/24.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface APXECFactory : NSObject<FlutterPlatformViewFactory>

@property (nonatomic) NSObject<FlutterBinaryMessenger> *channelMessanger;
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
- (FlutterBasicMessageChannel*)createMessageChannel:(NSString*)channelName;

@end

@interface APXEmbeddedView : NSObject <FlutterPlatformView>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;
@end

NS_ASSUME_NONNULL_END
