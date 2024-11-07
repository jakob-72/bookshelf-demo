use serde::Deserialize;

/// DTO that represents a request to authenticate a user.
#[derive(Debug, Clone, Deserialize)]
pub struct AuthRequest {
    pub username: String,
    pub password: String,
}
