use std::io;

mod error;
mod jwt;
mod provider;
mod routes;
mod server;

const PORT: u16 = 8091;

/// Starts the server on the specified port.
/// # Errors
/// Returns an `io::Error` if the server fails to start.
pub async fn start_server() -> io::Result<()> {
    server::start(("0.0.0.0", PORT)).await
}
