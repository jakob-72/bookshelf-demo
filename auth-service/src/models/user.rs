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

#[cfg(test)]
mod tests {
    use super::*;

    const HASHED_TEST: &'static str =
        "$2b$12$0VMPpuAbIef9G4LNRPOKbOah5BclZ4BPeMs/pYhYBXO3WK8Au/FGW";

    #[test]
    fn create_new() {
        let user = User::create_new("test".to_string(), "test".to_string())
            .expect("Failed to create user");
        assert_eq!(user.username, "test");
        assert_ne!(user.hashed_password, "test");
    }

    #[test]
    fn verify_password() {
        let user = User {
            id: uuid::Uuid::new_v4(),
            username: "test".to_string(),
            hashed_password: HASHED_TEST.to_string(),
        };
        assert!(user.verify_password("test"));
        assert!(!user.verify_password("wrong"));
    }
}
