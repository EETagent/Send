//
//  Send.m
//  Send
//

#import "Send.h"

#import "../libffsend/src/ffsend.h"

#import <libzip/SSZipArchive.h>

@implementation Send {
    uploaded_file_t *uploadedFile;
    progress_reporter_t *progressReporter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self->uploadedFile = uploaded_file_new();
        self->progressReporter = progress_reporter_new();
    }
    return self;
}

- (void)dealloc {
    uploaded_file_free(self->uploadedFile);
    progress_reporter_free(self->progressReporter);
}

void uploadStarted (unsigned long long size, void *ctx) {
    Send* send = (__bridge Send *)(ctx);
    [[send delegate] sendUploadStartedWithSize:size];
}

void uploadProgress (unsigned long long bytes, void *ctx) {
    Send* send = (__bridge Send *)(ctx);
    [[send delegate] sendUploadProgressWithTotalBytesUploaded:bytes];
}

void uploadCompleted (void *ctx) {}

- (void)uploadFileWithPath:(NSString*)path {
    [self uploadFileWithPath:path tempFileCreatedAtBlock:nil];
}

- (void)uploadFileWithPath:(NSString*)path tempFileCreatedAtBlock:(void (^)(NSString *path))tempFileBlock {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [[self delegate] sendUploadFailedWithError:[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                                       code:1000
                                                                   userInfo:@{
            NSLocalizedDescriptionKey:NSLocalizedString(@"File not found", @"")
        }]];
        return;
    }
    
    const char *pathString = [path UTF8String];
    
    progress_reporter_setup(self->progressReporter, uploadStarted, uploadProgress, uploadCompleted, (__bridge void *)(self));
    
    const char *password = [self password] ? [[self password] UTF8String] : nil;
    
    // If path is directory, create ZIP archive
    if (isDir) {
        const NSString *archiveName = @"Send-Archive.zip";
        NSString *tempArchive = [NSTemporaryDirectory() stringByAppendingPathComponent:(NSString *)archiveName];
        
        if ([fileManager fileExistsAtPath:tempArchive isDirectory:nil])
            [fileManager removeItemAtPath:tempArchive error:nil];
        
        BOOL archiveCreated = [SSZipArchive createZipFileAtPath:tempArchive withContentsOfDirectory:path keepParentDirectory:YES];
        if (archiveCreated) {
            // File object callback
            if (tempFileBlock)
                tempFileBlock(tempArchive);
            // Recursion (Now path is not dir)
            [self uploadFileWithPath:tempArchive];
            [fileManager removeItemAtPath:tempArchive error:nil];
        } else {
            [[self delegate] sendUploadFailedWithError:[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
                                                                           code:1001
                                                                       userInfo:@{
                NSLocalizedDescriptionKey:NSLocalizedString(@"Failed to create ZIP archive", @"")
            }]];
        }
        return;
    }
    
    NSInteger status = upload_file(pathString, password, [self limit], [self expiry], self->progressReporter, self->uploadedFile);
    
    switch (status) {
        case 0:
            [[self delegate] sendUploadCompleted];
            break;
        case -1:
            [[self delegate] sendUploadFailedWithError:[NSError errorWithDomain:[NSString stringWithFormat:@"%@.libffsend", [[NSBundle mainBundle] bundleIdentifier]]
                                                                           code:1002
                                                                       userInfo:@{
                NSLocalizedDescriptionKey:NSLocalizedString(@"Internal file path error", @"")
            }]];
            return;
        case -2:
            [[self delegate] sendUploadFailedWithError:[NSError errorWithDomain:[NSString stringWithFormat:@"%@.libffsend", [[NSBundle mainBundle] bundleIdentifier]]
                                                                           code:1003
                                                                       userInfo:@{
                NSLocalizedDescriptionKey:NSLocalizedString(@"Internal upload error", @"")
            }]];
            return;
    }
}

- (void)uploadFileWithURLPath:(NSURL *)urlPath {
    NSString *path = [urlPath path];
    return [self uploadFileWithPath:path];
}

- (void)uploadFilesWithPaths:(NSArray<NSString *> *)files tempFileCreatedAtBlock:(void (^)(NSString *path))tempFileBlock {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // NSString *uuid = [[NSUUID UUID] UUIDString];
    
    const NSString *uploadFolder = @"Send-Upload";
    NSString *tempFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:(NSString *)uploadFolder];
    
    if ([fileManager fileExistsAtPath:tempFolder])
        [fileManager removeItemAtPath:tempFolder error:nil];
    
    [fileManager createDirectoryAtPath:tempFolder withIntermediateDirectories:YES attributes:nil error:nil];
    
    // Copy files and folders
    for (NSString *file in files) {
        NSString *fileName = [file lastPathComponent];
        
        NSString *original = [fileName copy];
        unsigned long fileIndex = 1;
        while ([fileManager fileExistsAtPath:[tempFolder stringByAppendingPathComponent:fileName]]) {
            fileName = [NSString stringWithFormat:@"%lu-%@", fileIndex, original];
            fileIndex++;
        }
        
        [fileManager copyItemAtPath:file toPath:[tempFolder stringByAppendingPathComponent:fileName] error:nil];
    }
    // Upload as only one path
    [self uploadFileWithPath:tempFolder tempFileCreatedAtBlock:^(NSString *path) {
        // File object callback
        tempFileBlock(path);
    }];
    
    // Delete temp folder
    [fileManager removeItemAtPath:tempFolder error:nil];
}

- (NSString *)uploadedFileGetId {
    if (!self->uploadedFile)
        return nil;
    const char *uploadedId = uploaded_file_get_id(self->uploadedFile);
    NSString *objectiveString = [NSString stringWithUTF8String:uploadedId];
    uploaded_file_string_free((char*)uploadedId);
    return objectiveString;
}

- (long long)uploadedFileGetExpireAt {
    if (!self->uploadedFile)
        return 0;
    long long uploadedExpireAt = uploaded_file_get_expire_at(self->uploadedFile);
    return uploadedExpireAt;
}

- (NSString *)uploadedFileGetURL {
    if (!self->uploadedFile)
        return nil;
    const char *uploadedUrl = uploaded_file_get_url(self->uploadedFile);
    NSString *objectiveString = [NSString stringWithUTF8String:uploadedUrl];
    uploaded_file_string_free((char*)uploadedUrl);
    return objectiveString;
}

- (NSString *)uploadedFileGetSecret {
    if (!self->uploadedFile)
        return nil;
    const char *uploadedSecret = uploaded_file_get_secret(self->uploadedFile);
    NSString *objectiveString = [NSString stringWithUTF8String:uploadedSecret];
    uploaded_file_string_free((char*)uploadedSecret);
    return objectiveString;
}

- (NSURL *)uploadedFileGetLink {
    if (!self->uploadedFile)
        return nil;
    
    NSString *url = [self uploadedFileGetURL];
    NSString *secret = [self uploadedFileGetSecret];
    
    if (!url || !secret)
        return nil;
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@#%@", url, secret]];
}

@end
