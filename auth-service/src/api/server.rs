use crate::api::provider::Provider;
use crate::api::routes;
use actix_web::middleware::{DefaultHeaders, Logger};
use actix_web::{web, App, HttpServer};
use std::{io, net};

pub async fn start<A: net::ToSocketAddrs>(addr: A) -> io::Result<()> {
    let provider = Provider::new();
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(provider.clone()))
            .wrap(Logger::default())
            .wrap(DefaultHeaders::new().add(("Access-Control-Allow-Origin", "*")))
            .service(routes::health)
            .service(routes::login)
            .service(routes::logout)
            .service(routes::register)
    })
    .bind(addr)?
    .run()
    .await
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::models::auth_request::AuthRequest;
    use actix_web::test;

    #[actix_web::test]
    async fn health() {
        let app = test::init_service(App::new().service(routes::health)).await;
        let req = test::TestRequest::get().uri("/health").to_request();
        let resp = test::call_service(&app, req).await;
        assert!(resp.status().is_success());
    }

    #[actix_web::test]
    async fn login_successful() {
        let provider = Provider::new();
        let app = test::init_service(
            App::new()
                .app_data(web::Data::new(provider.clone()))
                .service(routes::login),
        )
        .await;
        let req = test::TestRequest::post()
            .uri("/login")
            .set_json(AuthRequest {
                username: "admin".to_string(),
                password: "admin".to_string(),
            })
            .to_request();
        let resp = test::call_service(&app, req).await;
        assert!(resp.status().is_success());
        let body = String::from_utf8(test::read_body(resp).await.to_vec()).unwrap();
        assert!(body.contains("token"));
    }

    #[actix_web::test]
    async fn login_user_not_found() {
        let provider = Provider::new();
        let app = test::init_service(
            App::new()
                .app_data(web::Data::new(provider.clone()))
                .service(routes::login),
        )
        .await;
        let req = test::TestRequest::post()
            .uri("/login")
            .set_json(AuthRequest {
                username: "unknown".to_string(),
                password: "password".to_string(),
            })
            .to_request();
        let resp = test::call_service(&app, req).await;
        assert_eq!(resp.status(), 404);
    }

    #[actix_web::test]
    async fn login_invalid_password() {
        let provider = Provider::new();
        let app = test::init_service(
            App::new()
                .app_data(web::Data::new(provider.clone()))
                .service(routes::login),
        )
        .await;
        let req = test::TestRequest::post()
            .uri("/login")
            .set_json(AuthRequest {
                username: "admin".to_string(),
                password: "wrong".to_string(),
            })
            .to_request();
        let resp = test::call_service(&app, req).await;
        assert_eq!(resp.status(), 401);
    }

    #[actix_web::test]
    async fn register_successful() {
        let provider = Provider::new();
        let app = test::init_service(
            App::new()
                .app_data(web::Data::new(provider.clone()))
                .service(routes::register),
        )
        .await;
        let req = test::TestRequest::post()
            .uri("/register")
            .set_json(AuthRequest {
                username: "new user".to_string(),
                password: "password".to_string(),
            })
            .to_request();
        let resp = test::call_service(&app, req).await;
        assert_eq!(resp.status(), 201);
    }

    #[actix_web::test]
    async fn register_user_already_exists() {
        let provider = Provider::new();
        let app = test::init_service(
            App::new()
                .app_data(web::Data::new(provider.clone()))
                .service(routes::register),
        )
        .await;
        let req = test::TestRequest::post()
            .uri("/register")
            .set_json(AuthRequest {
                username: "admin".to_string(),
                password: "password".to_string(),
            })
            .to_request();
        let resp = test::call_service(&app, req).await;
        assert_eq!(resp.status(), 409);
    }
}
