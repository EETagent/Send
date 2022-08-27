typedef struct uploaded_file uploaded_file_t;

typedef struct progress_reporter progress_reporter_t;

/**
 * Creates new UploadedFile struct
 * @return UploadedFile struct pointer
 */
extern uploaded_file_t * uploaded_file_new(void);

/**
 * Free UploadedFile struct from memory
 */
extern void uploaded_file_free(uploaded_file_t *ptr);

/**
 * Creates new UploadedFile struct
 * @param[in] ptr UploadedFile struct pointer
 * @return Id of the uploaded file
 */
extern const char* uploaded_file_get_id(const uploaded_file_t *ptr);
/**
 * Creates new UploadedFile struct
 * @param[in] ptr UploadedFile struct pointer
 * @return ExpireAt of the uploaded file
 */
extern long long uploaded_file_get_expire_at(const uploaded_file_t *ptr);
/**
 * Creates new UploadedFile struct
 * @param[in] ptr UploadedFile struct pointer
 * @return URL of the uploaded file
 */
extern const char* uploaded_file_get_url(const uploaded_file_t *ptr);
/**
 * Creates new UploadedFile struct
 * @param[in] ptr UploadedFile struct pointer
 * @return Secret of the uploaded file
 */
extern const char* uploaded_file_get_secret(const uploaded_file_t *ptr);

/**
 * Free uploaded_file_get_* string from the memory
 */
extern void uploaded_file_string_free(char *s);


/**
 * Creates new ProgressReporter struct
 * @return ProgressReporter struct pointer
 */
extern progress_reporter_t * progress_reporter_new(void);

/**
 * Fills ProgressReporter struct with callbacks and context
 * @param[out] ptr ProgressReporter struct pointer
 * @param[in] start Callback for download started event
 * @param[in] progress Callback for downloading progress event
 * @param[in] finish Callback for download completed event
 * @param[in] ctx Optional context
 */
extern void progress_reporter_setup(progress_reporter_t *ptr, void start(unsigned long long size, void *ctx), void progress(unsigned long long bytes, void *ctx), void finish(void *ctx), void *ctx);

/**
 * Free ProgressReporter struct from the memory
 */
extern void progress_reporter_free(progress_reporter_t *ptr);

/**
 * Upload file using Firefox Send
 * @param[in] path File path
 * @param[in] password Optional password
 * @param[in] limit Number of downloads limit
 * @param[in] expiry Expiry limit in u64 seconds
 * @param[in] reporter ProgressReporter for callbacks
 * @param[out] ptr UploadedFile
 */
extern int upload_file(const char* path, const char *password, unsigned char limit, long long expiry, progress_reporter_t *reporter, uploaded_file_t *ptr);
