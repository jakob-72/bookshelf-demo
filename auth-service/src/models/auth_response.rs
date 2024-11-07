use serde::Serialize;

/// DTO for the response to a successful authentication request.
#[derive(Debug, Serialize)]
pub struct AuthResponse {
    pub token: String,
}
