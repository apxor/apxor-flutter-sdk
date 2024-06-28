//
//  APXStoryFactory.h
//  apxor_flutter
//
//  Created by Dasari Kousik on 03/05/24.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>


@interface APXStoryFactory : NSObject <FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

@interface APXStoryView : NSObject <FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*_Nullable)messenger;

- (UIView*_Nonnull)view;

@end


