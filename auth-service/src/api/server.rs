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
