FROM rust:1.72.1

WORKDIR /app

COPY . .
COPY txt /tmp/txt

RUN rustup default nightly

CMD cargo run --release