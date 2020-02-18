#import "YunBasePlugin.h"
#if __has_include(<yun_base/yun_base-Swift.h>)
#import <yun_base/yun_base-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "yun_base-Swift.h"
#endif

@implementation YunBasePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYunBasePlugin registerWithRegistrar:registrar];
}
@end
