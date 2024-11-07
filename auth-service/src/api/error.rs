use crate::iam::error::{ErrorType, IAMError};
use actix_web::http::StatusCode;
use actix_web::ResponseError;
use std::error::Error;
use std::fmt::Display;

/// A simple custom error type that can be converted into an `actix_web::HttpResponse`.
#[derive(Debug, Clone)]
pub struct ApiError {
    pub status: StatusCode,
    pub message: String,
}

impl Error for ApiError {}

impl Display for ApiError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.message)
    }
}

impl ResponseError for ApiError {
    fn status_code(&self) -> StatusCode {
        self.status
    }

    fn error_response(&self) -> actix_web::HttpResponse {
        actix_web::HttpResponse::build(self.status_code()).body(self.to_owned().message)
    }
}

impl From<IAMError> for ApiError {
    fn from(value: IAMError) -> Self {
        let status_code = match value.error_type {
            ErrorType::UserNotFound => StatusCode::NOT_FOUND,
            ErrorType::UserAlreadyExists => StatusCode::CONFLICT,
            ErrorType::InvalidPassword => StatusCode::UNAUTHORIZED,
        };
        Self {
            status: status_code,
            message: format!("{}", value),
        }
    }
}
