use crate::api::error::ApiError;
use crate::api::provider::Provider;
use crate::iam::IdentityAndAccessManagement;
use crate::models::auth_request::AuthRequest;
use crate::models::auth_response::AuthResponse;
use crate::models::user::User;
use actix_web::http::StatusCode;
use actix_web::web::{Data, Json, Path};
use actix_web::{get, options, post, HttpResponse};
use std::result;

/// Convenience type for handling API results.
type Result<T> = result::Result<T, ApiError>;

/// Health check endpoint.
/// # Success
/// - Returns a `200 OK` response with the message "OK".
#[get("/health")]
pub async fn health() -> Result<&'static str> {
    Ok("OK")
}

/// Login endpoint.
/// # Parameters
/// - `auth_request`: `AuthRequest`-DTO that contains username and password of the user.
/// # Success
/// - Returns a `200 OK` response with a `AuthResponse`-DTO that contains a JWT token.
/// # Errors
/// - Returns a `400 Bad Request` response if the request body is invalid.
/// - Returns a `401 Unauthorized` response if the username or password is incorrect.
/// - Returns a `404 Not Found` response if the user does not exist.
#[post("/login")]
pub async fn login(
    auth_request: Json<AuthRequest>,
    provider: Data<Provider>,
) -> Result<Json<AuthResponse>> {
    let iam = provider.iam();
    let jwt = provider.jwt();

    let user = iam
        .login(&auth_request.username, &auth_request.password)
        .await?;
    let token = jwt.generate_token(user)?;

    Ok(Json(AuthResponse { token }))
}

/// Logout endpoint.
/// # Parameters
/// - `user_id`: The ID of the user that should be logged out.
/// # Success
/// - Returns a `200 OK` response.
/// # Errors
/// - Returns a `404 Not Found` response if the user does not exist.
#[get("/logout/{user_id}")]
pub async fn logout(path: Path<String>, provider: Data<Provider>) -> Result<HttpResponse> {
    let iam = provider.iam();
    let user_id = path.into_inner();
    iam.logout(user_id).await?;
    Ok(HttpResponse::Ok().finish())
}

/// Endpoint to register a new user.
/// For Demo purposes, this endpoint is not protected and can be accessed by anyone.
/// # Parameters
/// - `auth_request`: `AuthRequest`-DTO that contains username and password of the user.
/// # Success
/// - Returns an empty `201 Created` response.
/// # Errors
/// - Returns a `400 Bad Request` response if the request body is invalid.
/// - Returns a `409 Conflict` response if the user already exists.
#[post("/register")]
pub async fn register(
    request: Json<AuthRequest>,
    provider: Data<Provider>,
) -> Result<HttpResponse> {
    let iam = provider.iam();
    let username = request.username.to_owned();
    let password = request.password.to_owned();
    let user = match User::create_new(username, password) {
        Ok(user) => user,
        Err(e) => {
            return Err(ApiError {
                status: StatusCode::BAD_REQUEST,
                message: e.to_string(),
            })
        }
    };

    iam.create_user(user).await?;
    Ok(HttpResponse::build(StatusCode::CREATED).finish())
}

/// Options endpoint for any path.
/// # Success
/// - Returns a `200 OK` response.
#[options("/{tail:.*}")]
pub async fn preflight() -> HttpResponse {
    HttpResponse::Ok().finish()
}
