// Autogenerated from Pigeon (v4.2.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import "messages.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSDictionary<NSString *, id> *wrapResult(id result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = @{
        @"code": (error.code ?: [NSNull null]),
        @"message": (error.message ?: [NSNull null]),
        @"details": (error.details ?: [NSNull null]),
        };
  }
  return @{
      @"result": (result ?: [NSNull null]),
      @"error": errorDict,
      };
}
static id GetNullableObject(NSDictionary* dict, id key) {
  id result = dict[key];
  return (result == [NSNull null]) ? nil : result;
}
static id GetNullableObjectAtIndex(NSArray* array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}


@interface FLTSignInCallback ()
+ (FLTSignInCallback *)fromMap:(NSDictionary *)dict;
+ (nullable FLTSignInCallback *)nullableFromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;
@end

@implementation FLTSignInCallback
+ (instancetype)makeWithUri:(NSString *)uri {
  FLTSignInCallback* pigeonResult = [[FLTSignInCallback alloc] init];
  pigeonResult.uri = uri;
  return pigeonResult;
}
+ (FLTSignInCallback *)fromMap:(NSDictionary *)dict {
  FLTSignInCallback *pigeonResult = [[FLTSignInCallback alloc] init];
  pigeonResult.uri = GetNullableObject(dict, @"uri");
  NSAssert(pigeonResult.uri != nil, @"");
  return pigeonResult;
}
+ (nullable FLTSignInCallback *)nullableFromMap:(NSDictionary *)dict { return (dict) ? [FLTSignInCallback fromMap:dict] : nil; }
- (NSDictionary *)toMap {
  return @{
    @"uri" : (self.uri ?: [NSNull null]),
  };
}
@end

@interface FLTUtilsApiCodecReader : FlutterStandardReader
@end
@implementation FLTUtilsApiCodecReader
- (nullable id)readValueOfType:(UInt8)type 
{
  switch (type) {
    case 128:     
      return [FLTSignInCallback fromMap:[self readValue]];
    
    default:    
      return [super readValueOfType:type];
    
  }
}
@end

@interface FLTUtilsApiCodecWriter : FlutterStandardWriter
@end
@implementation FLTUtilsApiCodecWriter
- (void)writeValue:(id)value 
{
  if ([value isKindOfClass:[FLTSignInCallback class]]) {
    [self writeByte:128];
    [self writeValue:[value toMap]];
  } else 
{
    [super writeValue:value];
  }
}
@end

@interface FLTUtilsApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation FLTUtilsApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[FLTUtilsApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[FLTUtilsApiCodecReader alloc] initWithData:data];
}
@end


NSObject<FlutterMessageCodec> *FLTUtilsApiGetCodec() {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  static dispatch_once_t sPred = 0;
  dispatch_once(&sPred, ^{
    FLTUtilsApiCodecReaderWriter *readerWriter = [[FLTUtilsApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}

void FLTUtilsApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FLTUtilsApi> *api) {
    ///
  /// Opens web page with new activity on Android, with SFSafariViewController on iOS.
  /// On Android, [title] will be the title of activity. On iOS, [title] will be ignored.
  ///
{
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.UtilsApi.openWebPage"
        binaryMessenger:binaryMessenger
        codec:FLTUtilsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(openWebPageTitle:url:error:)], @"FLTUtilsApi api (%@) doesn't respond to @selector(openWebPageTitle:url:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_title = GetNullableObjectAtIndex(args, 0);
        NSString *arg_url = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        [api openWebPageTitle:arg_title url:arg_url error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
    ///
  /// Opens Custom Tab for signing in. Returns response URI with token query parameters.
  ///
{
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.UtilsApi.openSignInCustomTab"
        binaryMessenger:binaryMessenger
        codec:FLTUtilsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(openSignInCustomTabUrl:completion:)], @"FLTUtilsApi api (%@) doesn't respond to @selector(openSignInCustomTabUrl:completion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_url = GetNullableObjectAtIndex(args, 0);
        [api openSignInCustomTabUrl:arg_url completion:^(FLTSignInCallback *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
    ///
  /// Updates App Widgets on Android, WidgetKit on iOS.
  ///
{
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.UtilsApi.updateWidgets"
        binaryMessenger:binaryMessenger
        codec:FLTUtilsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(updateWidgetsWithError:)], @"FLTUtilsApi api (%@) doesn't respond to @selector(updateWidgetsWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api updateWidgetsWithError:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
    ///
  /// Requests iOS/macOS ATT permission. On Android, this method does nothing.
  ///
  /// Permission requesting result will be returned. On Android, always `true` will be returned.
  ///
{
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.UtilsApi.requestIDFA"
        binaryMessenger:binaryMessenger
        codec:FLTUtilsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(requestIDFAWithCompletion:)], @"FLTUtilsApi api (%@) doesn't respond to @selector(requestIDFAWithCompletion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        [api requestIDFAWithCompletion:^(NSNumber *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
    ///
  /// Sets wake lock mode.
  ///
{
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.UtilsApi.setWakeLock"
        binaryMessenger:binaryMessenger
        codec:FLTUtilsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setWakeLockWakeLock:error:)], @"FLTUtilsApi api (%@) doesn't respond to @selector(setWakeLockWakeLock:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_wakeLock = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api setWakeLockWakeLock:arg_wakeLock error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
    ///
  /// Sets fullscreen mode.
  ///
{
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.UtilsApi.setFullscreen"
        binaryMessenger:binaryMessenger
        codec:FLTUtilsApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setFullscreenFullscreen:error:)], @"FLTUtilsApi api (%@) doesn't respond to @selector(setFullscreenFullscreen:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_fullscreen = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api setFullscreenFullscreen:arg_fullscreen error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
NSObject<FlutterMessageCodec> *FLTAppLinkHandlerApiGetCodec() {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

@interface FLTAppLinkHandlerApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation FLTAppLinkHandlerApi

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)handleUriUri:(NSString *)arg_uri completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.AppLinkHandlerApi.handleUri"
      binaryMessenger:self.binaryMessenger
      codec:FLTAppLinkHandlerApiGetCodec()      ];  [channel sendMessage:@[arg_uri ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
@end
NSObject<FlutterMessageCodec> *FLTFirestoreApiGetCodec() {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

@interface FLTFirestoreApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation FLTFirestoreApi

- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}
- (void)saveMessagingTokenToken:(NSString *)arg_token completion:(void(^)(NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.FirestoreApi.saveMessagingToken"
      binaryMessenger:self.binaryMessenger
      codec:FLTFirestoreApiGetCodec()      ];  [channel sendMessage:@[arg_token ?: [NSNull null]] reply:^(id reply) {
    completion(nil);
  }];
}
@end
