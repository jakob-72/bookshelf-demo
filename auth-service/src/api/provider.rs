use crate::api::jwt::JWTEncoder;
use crate::iam::in_memory::InMemoryIAM;
use crate::iam::IdentityAndAccessManagement;
use chrono::Duration;

/// The Provider is a convenience struct that holds all the services needed by the API.
/// To swap out the trait implementations, simply change the type of e.g. iam to a different
/// struct that implements the IAM trait (e.g. a Keycloak-connector).
#[derive(Clone)]
pub struct Provider {
    iam: InMemoryIAM,
    jwt: JWTEncoder,
}

impl Provider {
    /// Create a new Provider with default implementations.
    /// JWT secret and validity are read from the environment variables JWT_SECRET and JWT_VALIDITY_SECONDS.
    /// The IAM implementation is an in-memory store.
    pub fn new() -> Self {
        let jwt_secret = std::env::var("JWT_SECRET").unwrap_or("secret".to_string());
        let jwt_validity = std::env::var("JWT_VALIDITY_SECONDS")
            .unwrap_or("3600".to_string())
            .parse::<u64>()
            .unwrap();
        Self {
            iam: InMemoryIAM {},
            jwt: JWTEncoder::new(jwt_secret, Duration::seconds(jwt_validity as i64)),
        }
    }

    pub fn iam(&self) -> impl IdentityAndAccessManagement {
        self.iam.clone()
    }

    pub fn jwt(&self) -> JWTEncoder {
        self.jwt.clone()
    }
}
