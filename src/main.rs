#[macro_use] extern crate nickel;

use nickel::{Nickel, HttpRouter, StaticFilesHandler};
use std::path::Path;

fn main() {
  let mut server = Nickel::new();

  server.get("/", middleware! { |_request, response|
    return response.send_file(&Path::new("frontend/index.html"))
  });
  server.utilize(StaticFilesHandler::new("frontend/"));
  server.listen("127.0.0.1:3000")
}
