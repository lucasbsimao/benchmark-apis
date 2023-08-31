#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;

use std::fs;
use sha256::{digest};

#[get("/?<n>")]
fn hello(n: u8) -> String {
    let contents = fs::read_to_string("txt")
        .expect("Should have been able to read the file");

    //println!("With text:\n{contents}");
    //println!("{}", n);

    for _ in 0..n {
        let _ = digest(&contents);
        //println!("With sha256:\n{val}");
    }

    format!("OK")
}

fn main() {
    let cfg = rocket::config::Config::build(rocket::config::Environment::Development)
        .address("localhost")
        .port(8080)
        .unwrap();

    rocket::custom(cfg).
        mount("/benchmark", routes![hello]).
        launch();
}