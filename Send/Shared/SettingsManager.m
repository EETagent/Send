//
//  SettingsManager.m
//  Send
//

#import "SettingsManager.h"

NSString * const kSendInstanceURL = @"SendInstanceURL";
NSString * const kSendMaxDownloadLimit = @"SendMaxDownloadLimit";
NSString * const kSendMaxDurationMinutes = @"SendMaxDurationMinutes";
NSString * const kSendMaxFileSizeMB = @"SendMaxFileSizeMB";

static NSString * const kDefaultSendURL = @"https://upload.nolog.cz/";
static NSInteger const kDefaultMaxDownloadLimit = 500;
static NSInteger const kDefaultMaxDurationMinutes = 24*60*7;
static NSInteger const kDefaultMaxFileSizeMB = 5000;

@implementation SettingsManager {
    NSUserDefaults *_userDefaults;
}

+ (instancetype)sharedManager {
    static SettingsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"KSR6A94B7P.Send.Settings"];
        [self registerDefaults];
    }
    return self;
}

- (void)registerDefaults {
    NSDictionary *defaults = @{
        kSendInstanceURL: kDefaultSendURL,
        kSendMaxDownloadLimit: @(kDefaultMaxDownloadLimit),
        kSendMaxDurationMinutes: @(kDefaultMaxDurationMinutes),
        kSendMaxFileSizeMB: @(kDefaultMaxFileSizeMB)
    };
    [_userDefaults registerDefaults:defaults];
}

- (NSUserDefaults *)userDefaults {
    return _userDefaults;
}

// Send URL
- (NSURL *)sendURL {
    NSString *urlString = [_userDefaults stringForKey:kSendInstanceURL];
    if (urlString && [urlString containsString:@"://"]) {
         return [NSURL URLWithString:urlString];
    }
    return [NSURL URLWithString:kDefaultSendURL];
}

- (void)setSendURL:(NSURL *)url {
    if (url && url.absoluteString.length > 0) {
        if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
             [_userDefaults setObject:[url absoluteString] forKey:kSendInstanceURL];
        } else {
             [_userDefaults setObject:kDefaultSendURL forKey:kSendInstanceURL];
        }
    } else {
         [_userDefaults setObject:kDefaultSendURL forKey:kSendInstanceURL];
    }
     [_userDefaults synchronize];
}

- (NSInteger)maxDownloadLimit {
    NSInteger limit = [_userDefaults integerForKey:kSendMaxDownloadLimit];
    return (limit > 0) ? limit : kDefaultMaxDownloadLimit;
}

- (void)setMaxDownloadLimit:(NSInteger)limit {
    if (limit > 0) {
        [_userDefaults setInteger:limit forKey:kSendMaxDownloadLimit];
    } else {
        [_userDefaults setInteger:kDefaultMaxDownloadLimit forKey:kSendMaxDownloadLimit];
    }
     [_userDefaults synchronize];
}



- (NSInteger)maxDurationMinutes {
    NSInteger minutes = [_userDefaults integerForKey:kSendMaxDurationMinutes];
    return (minutes > 0) ? minutes : kDefaultMaxDurationMinutes;
}

- (void)setMaxDurationMinutes:(NSInteger)minutes {
     if (minutes > 0) {
        [_userDefaults setInteger:minutes forKey:kSendMaxDurationMinutes];
    } else {
        [_userDefaults setInteger:kDefaultMaxDurationMinutes forKey:kSendMaxDurationMinutes];
    }
     [_userDefaults synchronize];
}

- (NSInteger)maxFileSizeInMB {
    NSInteger size = [_userDefaults integerForKey:kSendMaxFileSizeMB];
    return (size > 0) ? size : kDefaultMaxFileSizeMB;
}

- (double)maxFileSizeInGB {
    NSInteger limitInMB = [self maxFileSizeInMB]; 
    return (double)limitInMB / 1000.0; 
}

- (void)setMaxFileSizeInMB:(NSInteger)size {
    if (size > 0) {
        [_userDefaults setInteger:size forKey:kSendMaxFileSizeMB];
    } else {
         [_userDefaults setInteger:kDefaultMaxFileSizeMB forKey:kSendMaxFileSizeMB];
    }
     [_userDefaults synchronize];
}

@end
