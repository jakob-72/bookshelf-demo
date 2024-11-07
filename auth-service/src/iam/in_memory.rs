use crate::iam;
use crate::iam::error::{ErrorType, IAMError};
use crate::iam::IdentityAndAccessManagement;
use crate::models::user::User;
use async_std::sync::RwLock;
use lazy_static::lazy_static;
use log::debug;
use uuid::Uuid;

lazy_static! {
    static ref USERS: RwLock<Vec<User>> = RwLock::new(vec![User {
        id: Uuid::new_v4(),
        username: "admin".to_string(),
        hashed_password: "$2b$12$YbjndrLEQYCTYJwcZ8gdJ.6qywkAChSnZ2hSZ2pomFKQl3/VFuSy6".to_string(), // admin
    },]);
}

#[derive(Clone)]
pub struct InMemoryIAM;

impl IdentityAndAccessManagement for InMemoryIAM {
    async fn login(&self, username: &str, password: &str) -> iam::Result<User> {
        let user = match self.find_user_by_username(username).await {
            Some(user) => user,
            None => {
                return Err(IAMError {
                    error_type: ErrorType::UserNotFound,
                    message: "User not found".to_string(),
                });
            }
        };

        match user.verify_password(password) {
            true => {
                debug!("User logged in: {:?}", user);
                Ok(user)
            }
            false => Err(IAMError {
                error_type: ErrorType::InvalidPassword,
                message: "Invalid password".to_string(),
            }),
        }
    }

    async fn logout(&self, _user_id: String) -> iam::Result<()> {
        Ok(()) // No-op
    }

    async fn create_user(&self, user: User) -> iam::Result<()> {
        let existing_user = self.find_user_by_username(&user.username).await;
        if existing_user.is_some() {
            return Err(IAMError {
                error_type: ErrorType::UserAlreadyExists,
                message: "User already exists".to_string(),
            });
        }
        let mut lock = USERS.write().await;
        lock.push(user);
        drop(lock);
        debug!("User created - new length: {}", USERS.read().await.len());
        Ok(())
    }
}

impl InMemoryIAM {
    async fn find_user_by_username(&self, username: &str) -> Option<User> {
        USERS
            .read()
            .await
            .iter()
            .find(|u| u.username == username)
            .cloned()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[actix_web::test]
    async fn login_successful() {
        let iam = InMemoryIAM;
        let result = iam.login("admin", "admin").await;
        assert!(result.is_ok());
        let user = result.unwrap();
        assert_eq!(user.username, "admin");
    }

    #[actix_web::test]
    async fn login_invalid_password() {
        let iam = InMemoryIAM;
        let result = iam.login("admin", "wrong").await;
        assert!(result.is_err());
        let error = result.unwrap_err();
        assert_eq!(error.error_type, ErrorType::InvalidPassword);
    }

    #[actix_web::test]
    async fn login_user_not_found() {
        let iam = InMemoryIAM;
        let result = iam.login("unknown", "password").await;
        assert!(result.is_err());
        let error = result.unwrap_err();
        assert_eq!(error.error_type, ErrorType::UserNotFound);
    }

    #[actix_web::test]
    async fn create_user() {
        let iam = InMemoryIAM;
        let user = User::create_new("test".to_string(), "password".to_string()).unwrap();
        let result = iam.create_user(user.clone()).await;
        assert!(result.is_ok());
        let users = USERS.read().await;
        let created_user = users.iter().find(|u| u.username == "test").unwrap();
        assert_eq!(created_user.username, user.username);
        drop(users);
        clean_up().await;
    }

    #[actix_web::test]
    async fn create_user_already_exists() {
        let iam = InMemoryIAM;
        let user = User::create_new("admin".to_string(), "password".to_string()).unwrap();
        let result = iam.create_user(user).await;
        assert!(result.is_err());
        let error = result.unwrap_err();
        assert_eq!(error.error_type, ErrorType::UserAlreadyExists);
    }

    async fn clean_up() {
        let mut users = USERS.write().await;
        users.clear();
        users.push(User {
            id: Uuid::new_v4(),
            username: "admin".to_string(),
            hashed_password: "$2b$12$YbjndrLEQYCTYJwcZ8gdJ.6qywkAChSnZ2hSZ2pomFKQl3/VFuSy6"
                .to_string(), // admin
        });
    }
}
