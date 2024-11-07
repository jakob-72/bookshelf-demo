use serde::{Deserialize, Serialize};

/// DTO that represents a request to authenticate a user.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AuthRequest {
    pub username: String,
    pub password: String,
}
