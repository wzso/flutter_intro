#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <Flutter/Flutter.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    FlutterViewController *controller = (FlutterViewController*)self.window.rootViewController;

    FlutterMethodChannel *batteryChannel =
        [FlutterMethodChannel methodChannelWithName:@"samples.flutter.dev/battery"
                                    binaryMessenger:controller];
    
    __weak typeof(self) weakSelf = self;
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
        // 直接把flutter 中 foo传过来的值返回给flutter
        if ([@"getBatteryLevel" isEqualToString:call.method]) {
            [batteryChannel invokeMethod:@"foo" arguments:nil result:^(id  _Nullable resultFromFlutter) {
                if ([resultFromFlutter isKindOfClass:[NSNumber class]]) {
                    result(resultFromFlutter);
                } else {
                    FlutterError *error = [FlutterError errorWithCode:@"no int returned from flutter"
                                                              message:@"no int returned from flutter `foo`"
                                                              details:nil];
                    result(error);
                }
            }];
            
//            int batteryLevel = [weakSelf getBatteryLevel];
//            if (batteryLevel == -1) {
//                result([FlutterError errorWithCode:@"UNAVAILABLE"
//                                   message:@"Battery info unavailable"
//                                   details:nil]);
//            } else {
//                result(@(batteryLevel));
//            }
        } else {
            result(FlutterMethodNotImplemented);
        }
  }];


  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (int)getBatteryLevel {
  UIDevice* device = UIDevice.currentDevice;
  device.batteryMonitoringEnabled = YES;
  if (device.batteryState == UIDeviceBatteryStateUnknown) {
    return -1;
  } else {
    return (int)(device.batteryLevel * 100);
  }
}


@end
