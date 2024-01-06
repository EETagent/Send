use std::os::unix::prelude::OsStrExt;
use std::path::PathBuf;
use std::sync::{Arc, Mutex};

use ffsend_api::action::params::ParamsData;
use ffsend_api::{action::upload::Upload, api::Version, client::ClientConfigBuilder, pipe::progress::ProgressReporter};
use url::Url;

use std::ffi::{CStr, CString, OsStr};
use std::os::raw::{c_char, c_int, c_longlong, c_ulonglong, c_uchar, c_void};
use std::ptr::null_mut;

//TODO: Configurable
const SEND_URL: &str = "https://send.vis.ee";
const SEND_VERSION: Version = Version::V3;

#[derive(Debug, Default)]
pub struct UploadedFile {
    id: String,
    expire_at: i64,
    url: String,
    secret: String,
}

impl UploadedFile {
    fn fill(&mut self, id: String, expire_at: i64, url: String, secret: String) {
        self.id = id;
        self.expire_at = expire_at;
        self.url = url;
        self.secret = secret;
    }
}

// Create a new struct to hold the data
#[no_mangle]
pub extern "C" fn uploaded_file_new() -> *mut UploadedFile {
    Box::into_raw(Box::new(UploadedFile::default()))
}


// Free the memory allocated for the UploadedFile
#[no_mangle]
pub extern "C" fn uploaded_file_free(ptr: *mut UploadedFile) {
    if ptr.is_null() {
        return;
    }
    unsafe {
        drop(Box::from_raw(ptr));
    }
}

// Get id from UploadedFile
#[no_mangle]
pub extern "C" fn uploaded_file_get_id(ptr: *const UploadedFile) -> *const c_char {
    let uploaded_file: &UploadedFile = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };
    CString::new(uploaded_file.id.to_owned()).unwrap().into_raw()
}

// Get expire_at from UploadedFile
#[no_mangle]
pub extern "C" fn uploaded_file_get_expire_at(ptr: *const UploadedFile) -> i64 {
    let uploaded_file: &UploadedFile = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };
    return uploaded_file.expire_at;
}

// Get url from UploadedFile
#[no_mangle]
pub extern "C" fn uploaded_file_get_url(ptr: *const UploadedFile) -> *const c_char {
    let uploaded_file: &UploadedFile = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };
    CString::new(uploaded_file.url.to_owned()).unwrap().into_raw()
}

// Get secret from UploadedFile
#[no_mangle]
pub extern "C" fn uploaded_file_get_secret(ptr: *const UploadedFile) -> *const c_char {
    let uploaded_file: &UploadedFile = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };
    CString::new(uploaded_file.secret.to_owned()).unwrap().into_raw()
}


// Every function that returns a string must be freed by the caller
#[no_mangle]
pub extern "C" fn uploaded_file_string_free(s: *mut c_char) {
    unsafe {
        if s.is_null() {
            return;
        }
        drop(CString::from_raw(s));
    };
}

#[derive(Default)]
pub struct Reporter {
    start: Option<extern fn (size: c_ulonglong, ctx: *mut c_void)>,
    progress: Option<extern fn (progress: c_ulonglong, ctx: *mut c_void)>,
    finish: Option<extern fn (ctx: *mut c_void)>,
    ctx: Option<*mut c_void>,
}
unsafe impl Send for Reporter {}

impl Reporter {
    fn fill(&mut self, start: Option<extern fn (size: c_ulonglong, ctx: *mut c_void)>, progress: Option<extern fn (progress: c_ulonglong, ctx: *mut c_void)>, finish: Option<extern fn (ctx: *mut c_void)>, ctx: Option<*mut c_void>) {
        self.start = start;
        self.progress = progress;
        self.finish = finish;
        self.ctx = ctx;
    }
}

impl ProgressReporter for Reporter {
    fn start(&mut self, size: u64) {
        if let Some(start) = self.start {
            start(size, self.ctx.unwrap_or_else(|| null_mut()));
        }
    }
    fn progress(&mut self, uploaded: u64) {
        if let Some(progress) = self.progress {
            progress(uploaded, self.ctx.unwrap_or_else(|| null_mut()));
        }
    }
    fn finish(&mut self) {
        if let Some(finish) = self.finish {
            finish(self.ctx.unwrap_or_else(|| null_mut()));
        }
    }
}

// Create a new multithread safe struct to hold the data
#[no_mangle]
pub extern "C" fn progress_reporter_new() -> *mut Arc<Mutex<Reporter>> {
    Box::into_raw(Box::new(Arc::new(Mutex::new(Reporter::default()))))
}

// Setups the reporter
#[no_mangle]
pub extern "C" fn progress_reporter_setup(ptr: *mut Arc<Mutex<Reporter>> , start: extern fn (size: u64, ctx: *mut c_void), progress: extern fn (progress: u64, ctx: *mut c_void), finish: extern fn (ctx: *mut c_void), ctx: *mut c_void) {
    let structure: &mut Arc<Mutex<Reporter>>  = unsafe {
        assert!(!ptr.is_null());
        &mut *ptr
    };
    let mut locked_reporter = structure.lock().unwrap();

    locked_reporter.fill(Some(start), Some(progress), Some(finish), Some(ctx));

    drop(locked_reporter);
}

// Free the memory allocated for the Reporter
#[no_mangle]
pub extern "C" fn progress_reporter_free(ptr: *mut Arc<Mutex<Reporter>>) {
    if ptr.is_null() {
        return;
    }
    unsafe {
        drop(Box::from_raw(ptr));
    }
}

// Upload a file
#[no_mangle]
pub extern "C" fn upload_file(
    path: *const c_char,
    password: *const c_char,
    limit: c_uchar,
    expiriry: c_longlong,
    reporter: *const Arc<Mutex<Reporter>>,
    ptr: *mut UploadedFile,
) -> c_int {

    if let Ok(client_config) = ClientConfigBuilder::default().build() {
        let client = client_config.client(true);

        // From c_char to PathBuf
        let c_str_path: &CStr = unsafe { CStr::from_ptr(path) };
        let os_str_path: &OsStr = OsStr::from_bytes(c_str_path.to_bytes());
        let path_buffer: PathBuf = PathBuf::from(os_str_path);

        let c_str_password: Option<&CStr> = unsafe { 
            if !password.is_null() {
                Some(CStr::from_ptr(password))
            }
            else {
                None
            }
        };
       
        let password: Option<String> = match c_str_password {
            Some(s) => match s.to_str() {
                Ok(s) => Some(s.to_owned()),
                Err(_) => None,
            },
            None => None,
        };

        // From u64 long long to usize, unwrap is safe on 64 bit
        let params: ParamsData = ParamsData::from(Some(limit), Some(expiriry.try_into().unwrap()));

        let upload: Upload = Upload::new(
            SEND_VERSION,
            Url::parse(SEND_URL).unwrap(),
            path_buffer,
            None,
            password,
            Some(params),
        );

        let progress_reporter: Option<Arc<Mutex<dyn ProgressReporter>>> = unsafe {
            if !reporter.is_null() {
                let progress_reporter: Arc<Mutex<dyn ProgressReporter>> = (&*reporter).to_owned();
                Some(progress_reporter)
            } else {
                None
            }
        };

        if let Ok(result) = Upload::invoke(upload, &client, progress_reporter.as_ref()) {
            let structure: &mut UploadedFile = unsafe {
                assert!(!ptr.is_null());
                &mut *ptr
            };

            #[cfg(debug_assertions)] {
                println!("URL: {:?} SECRET: {:?}", result.url().to_string(), result.secret());
            }

            structure.fill(
                result.id().to_string(),
                result.expire_at().timestamp(),
                result.url().to_string(),
                result.secret(),
            );
            
            //progress_reporter.unwrap().lock().unwrap().finish();
        } else {
            // Upload failure
            return -2;
        }
    } else {
        // File path failure
        return -1;
    }
    return 0;
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_upload_file() {
        use super::*;
        use std::ffi::CString;
        use std::io::Write;
        use std::os::raw::c_void;
        use std::ptr::null_mut;

        use tempfile::NamedTempFile;

        const PASSWORD: &str = "password";
        const FILE_CONTENT: &str = "Ahoj!";
        const LIMIT: u8 = 2;
        const EXPIRY: i64 = 5*60;

        let mut file = NamedTempFile::new().unwrap();

        file.write_all(FILE_CONTENT.as_bytes()).unwrap();

        let path = file.into_temp_path();

        let uploaded_file: *mut UploadedFile = uploaded_file_new();
        let reporter: *mut Arc<Mutex<Reporter>> = progress_reporter_new();

        extern "C" fn start(size: u64, ctx: *mut c_void) {
            println!("Start: {} {}", size, ctx as u64);
        }
        extern "C" fn progress(progress: u64, ctx: *mut c_void) {
            println!("Progress: {} {}", progress, ctx as u64);
        }
        extern "C" fn finish(ctx: *mut c_void) {
            println!("Finish: {}", ctx as u64);
        }

        progress_reporter_setup(reporter, start, progress, finish, null_mut());

        let path_string = CString::new(path.to_str().unwrap()).unwrap();
        let password = CString::new(PASSWORD).unwrap();

        let result = upload_file(
            path_string.as_ptr(),
            password.as_ptr(),
            LIMIT,
            EXPIRY,
            reporter,
            uploaded_file,
        );

        path.close().unwrap();

        assert_eq!(result, 0);

        let id = uploaded_file_get_id(uploaded_file);
        let url = uploaded_file_get_url(uploaded_file);
        let secret = uploaded_file_get_secret(uploaded_file);
        let expire_at = dbg!(uploaded_file_get_expire_at(uploaded_file));

        let id = dbg!(unsafe { CString::from_raw(id as *mut c_char) });
        let url = dbg!(unsafe { CString::from_raw(url as *mut c_char) });
        let secret = dbg!(unsafe { CString::from_raw(secret as *mut c_char) });

        assert!(id.to_str().unwrap().len() > 0);
        assert!(expire_at > 0);

        let url_parsed = url.to_str().unwrap();
        let url_parsed = Url::parse(url_parsed);
        assert!(url_parsed.is_ok());

        assert!(secret.to_str().unwrap().len() > 0);

        uploaded_file_string_free(id.into_raw());
        uploaded_file_string_free(url.into_raw());
        uploaded_file_string_free(secret.into_raw());

        uploaded_file_free(uploaded_file);
        progress_reporter_free(reporter);
    }
}
