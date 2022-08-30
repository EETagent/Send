//
//  Send.m
//  Send
//

#import "Send.h"

#import "../../../libffsend/src/ffsend.h"

#import "../../../libzip/SSZipArchive/SSZipArchive.h"

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

void uploadCompleted (void *ctx) {
    //Send* send = (__bridge Send *)(ctx);
    //[[send delegate] sendUploadCompleted];
}


- (void)uploadFileWithPath:(NSString*)path {
    const char *pathString = [path UTF8String];
    
    progress_reporter_setup(self->progressReporter, uploadStarted, uploadProgress, uploadCompleted, (__bridge void *)(self));
    
    NSInteger status = upload_file(pathString, nil, [self limit], [self expiry], self->progressReporter, self->uploadedFile);
    [[self delegate] sendUploadCompletedWithStatus:status];
}

- (void)uploadFileWithURLPath:(NSURL *)urlPath {
    NSString *path = [urlPath path];
    return [self uploadFileWithPath:path];
}

- (void)uploadFilesWithPaths:(NSArray<NSString *> *)files tempFileBlock:(void (^)(NSString *path))tempFileBlock {
    const NSString *archiveName = @"Send-Archive.zip";
    NSString *tempZIP = [NSTemporaryDirectory() stringByAppendingPathComponent:(NSString *)archiveName];
    BOOL createZIP = [SSZipArchive createZipFileAtPath:tempZIP withFilesAtPaths:files];
    if (createZIP) {
        tempFileBlock(tempZIP);
        [self uploadFileWithPath:tempZIP];
        [[NSFileManager defaultManager] removeItemAtPath:tempZIP error:nil];
    }
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
