//
//  SettingsManager.h
//  Send
//

#import <Foundation/Foundation.h>

extern NSString * const kSendInstanceURL;
extern NSString * const kSendMaxUploadLimit; 
extern NSString * const kSendMaxDurationMinutes;
extern NSString * const kSendMaxFileSizeMB;

@interface SettingsManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) NSURL *sendURL; // Renamed property
@property (nonatomic, assign) NSInteger maxDownloadLimit;
@property (nonatomic, assign) NSInteger maxDurationMinutes;
@property (nonatomic, assign) NSInteger maxFileSizeInMB;

- (double)maxFileSizeInGB;
- (void)setMaxFileSizeInMB:(NSInteger)size;

- (NSUserDefaults *)userDefaults;

@end
