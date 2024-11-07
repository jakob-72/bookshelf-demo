use crate::models::user::User;

pub mod error;
pub mod in_memory;

/// Convenience type for IAM results.
type Result<T> = std::result::Result<T, error::IAMError>;

/// The IAM trait defines a very basic interface for the Identity and Access Management service.
/// In this demo, the IAM implementation is a simple in-memory store.
/// In a real-world application, the IAM implementation would likely be a database or could be
/// easily connected to an identity provider like Keycloak or AWS Cognito.
pub trait IdentityAndAccessManagement {
    async fn login(&self, username: &str, password: &str) -> Result<User>;
    async fn logout(&self, user_id: String) -> Result<()>;
    async fn create_user(&self, user: User) -> Result<()>;
}
