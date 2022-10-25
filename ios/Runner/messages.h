// Autogenerated from Pigeon (v4.2.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import <Foundation/Foundation.h>
@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

@class FLTSignInCallback;

@interface FLTSignInCallback : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithUri:(NSString *)uri;
@property(nonatomic, copy) NSString * uri;
@end

/// The codec used by FLTUtilsApi.
NSObject<FlutterMessageCodec> *FLTUtilsApiGetCodec(void);

@protocol FLTUtilsApi
///
/// Opens web page with new activity on Android, with SFSafariViewController on iOS.
/// On Android, [title] will be the title of activity. On iOS, [title] will be ignored.
///
- (void)openWebPageTitle:(NSString *)title url:(NSString *)url error:(FlutterError *_Nullable *_Nonnull)error;
///
/// Opens Custom Tab for signing in. Returns response URI with token query parameters.
///
- (void)openSignInCustomTabUrl:(NSString *)url completion:(void(^)(FLTSignInCallback *_Nullable, FlutterError *_Nullable))completion;
///
/// Updates App Widgets on Android, WidgetKit on iOS.
///
- (void)updateWidgetsWithError:(FlutterError *_Nullable *_Nonnull)error;
///
/// Requests iOS/macOS ATT permission. On Android, this method does nothing.
///
/// Permission requesting result will be returned. On Android, always `true` will be returned.
///
- (void)requestIDFAWithCompletion:(void(^)(NSNumber *_Nullable, FlutterError *_Nullable))completion;
///
/// Sets wake lock mode.
///
- (void)setWakeLockWakeLock:(NSNumber *)wakeLock error:(FlutterError *_Nullable *_Nonnull)error;
///
/// Sets fullscreen mode.
///
- (void)setFullscreenFullscreen:(NSNumber *)fullscreen error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void FLTUtilsApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FLTUtilsApi> *_Nullable api);

/// The codec used by FLTAppLinkHandlerApi.
NSObject<FlutterMessageCodec> *FLTAppLinkHandlerApiGetCodec(void);

@interface FLTAppLinkHandlerApi : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)handleUriUri:(NSString *)uri completion:(void(^)(NSError *_Nullable))completion;
@end
/// The codec used by FLTFirestoreApi.
NSObject<FlutterMessageCodec> *FLTFirestoreApiGetCodec(void);

@interface FLTFirestoreApi : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)saveMessagingTokenToken:(NSString *)token completion:(void(^)(NSError *_Nullable))completion;
@end
NS_ASSUME_NONNULL_END
