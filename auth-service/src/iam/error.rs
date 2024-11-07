use std::error::Error;
use std::fmt::{Debug, Display, Formatter};

#[derive(Debug)]
pub struct IAMError {
    pub error_type: ErrorType,
    pub message: String,
}

#[derive(Debug, PartialEq)]
pub enum ErrorType {
    UserNotFound,
    UserAlreadyExists,
    InvalidPassword,
}

impl Error for IAMError {}

impl Display for IAMError {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "{:?}: {}", self.error_type, self.message)
    }
}
