FROM rust:1.72.1

WORKDIR /app

COPY . .

RUN rustup default nightly

CMD cargo run --release