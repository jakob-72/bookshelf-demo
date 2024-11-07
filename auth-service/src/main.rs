mod api;
mod iam;
mod models;

use env_logger::Env;
use std::io;

#[actix_web::main]
async fn main() -> io::Result<()> {
    env_logger::init_from_env(Env::default().default_filter_or("info"));
    api::start_server().await
}
