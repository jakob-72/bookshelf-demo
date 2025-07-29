use crate::api::error::ApiError;
use crate::models::user::User;
use actix_web::http::StatusCode;
use chrono::{Duration, Utc};
use jsonwebtoken::{encode, EncodingKey, Header};
use serde::Serialize;

#[derive(Clone)]
pub struct JWTEncoder {
    secret: String,
    validity: Duration,
}

#[derive(Serialize)]
struct Claims {
    sub: String,
    name: String,
    iat: usize,
    exp: usize,
}

impl JWTEncoder {
    pub fn new(secret: String, validity: Duration) -> Self {
        Self { secret, validity }
    }

    pub fn generate_token(&self, user: User) -> Result<String, ApiError> {
        let claims = Claims {
            sub: user.id.to_string(),
            name: user.username,
            iat: Utc::now().timestamp() as usize,
            exp: (Utc::now() + self.validity).timestamp() as usize,
        };

        match encode(
            &Header::default(),
            &claims,
            &EncodingKey::from_secret(self.secret.as_bytes()),
        ) {
            Ok(token) => Ok(token),
            Err(e) => Err(ApiError {
                status: StatusCode::INTERNAL_SERVER_ERROR,
                message: format!("Failed to generate token: {e}"),
            }),
        }
    }
}
