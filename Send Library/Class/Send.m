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

void uploadCompleted (void *ctx) {
    //Send* send = (__bridge Send *)(ctx);
    //[[send delegate] sendUploadCompleted];
}

- (void)uploadFileWithPath:(NSString*)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir])
        //TODO: Normal errors
        return;
    
    const char *pathString = [path UTF8String];
    
    progress_reporter_setup(self->progressReporter, uploadStarted, uploadProgress, uploadCompleted, (__bridge void *)(self));
    
    const char *password = [self password] ? [[self password] UTF8String] : nil;
    
    if (isDir) {
        const NSString *archiveName = @"Send-Archive.zip";
        NSString *tempZIP = [NSTemporaryDirectory() stringByAppendingPathComponent:(NSString *)archiveName];
        BOOL createZIP = [SSZipArchive createZipFileAtPath:tempZIP withContentsOfDirectory:path keepParentDirectory:YES];
        if (createZIP) {
            [self uploadFileWithPath:tempZIP];
            [fileManager removeItemAtPath:tempZIP error:nil];
        }
        return;
    }
    
    NSInteger status = upload_file(pathString, password, [self limit], [self expiry], self->progressReporter, self->uploadedFile);
    [[self delegate] sendUploadCompletedWithStatus:status];
}

- (void)uploadFileWithURLPath:(NSURL *)urlPath {
    NSString *path = [urlPath path];
    return [self uploadFileWithPath:path];
}

- (void)uploadFilesWithPaths:(NSArray<NSString *> *)files tempFileCreatedAtBlock:(void (^)(NSString *path))tempFileBlock {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSMutableArray<NSString *> *mutableFiles = [files mutableCopy];
    
    // Create main ZIP archive
    const NSString *archiveName = @"Send-Archive.zip";
    NSString *tempZIP = [NSTemporaryDirectory() stringByAppendingPathComponent:(NSString *)archiveName];
    // ZIP each directory in provided paths
    // Nested directories are not supported yet!
    NSMutableArray<NSString *> *zipDirectories = [NSMutableArray new];
    for (int index = 0; index < [mutableFiles count]; index++) {
        NSString *path = [mutableFiles objectAtIndex:index];
        
        BOOL isDir = NO;
        [fileManager fileExistsAtPath:path isDirectory:&isDir];
        if (!isDir)
            continue;
        
        NSString *fileName = [[path lastPathComponent] stringByDeletingPathExtension];
        NSString *subZIP = [NSTemporaryDirectory() stringByAppendingFormat:@"%@-%i.zip",fileName, index];
        BOOL createSubZIP = [SSZipArchive createZipFileAtPath:subZIP withContentsOfDirectory:path keepParentDirectory:NO];
        
        if (createSubZIP) {
            [zipDirectories addObject:subZIP];
            [mutableFiles replaceObjectAtIndex:index withObject:subZIP];
        }
    }
    
    BOOL createZIP = [SSZipArchive createZipFileAtPath:tempZIP withFilesAtPaths:mutableFiles];
    if (createZIP) {
        tempFileBlock(tempZIP);
        [self uploadFileWithPath:tempZIP];
        // Clean ZIP file
        [fileManager removeItemAtPath:tempZIP error:nil];
    }
    // Clean ZIP files
    for (NSString *zipDir in zipDirectories)
        [fileManager removeItemAtPath:zipDir error:nil];
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
