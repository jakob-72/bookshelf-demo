use log::warn;
use serde::{Deserialize, Serialize};
use std::io;
use std::io::ErrorKind;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct User {
    pub id: uuid::Uuid,
    pub username: String,
    pub hashed_password: String,
}

impl User {
    /// Create a new user with a hashed password.
    /// Returns an `io::error` if the password hashing fails.
    pub fn create_new(username: String, password: String) -> io::Result<Self> {
        let hashed_password = match bcrypt::hash(&password, bcrypt::DEFAULT_COST) {
            Ok(hash) => hash,
            Err(e) => return Err(io::Error::new(ErrorKind::InvalidData, e)),
        };

        Ok(Self {
            id: uuid::Uuid::new_v4(),
            username,
            hashed_password,
        })
    }

    /// Verify a password against the stored hashed password.
    pub fn verify_password(&self, password: &str) -> bool {
        bcrypt::verify(password, &self.hashed_password).unwrap_or_else(|e| {
            warn!("Failed to verify password: {}", e);
            false
        })
    }
}
