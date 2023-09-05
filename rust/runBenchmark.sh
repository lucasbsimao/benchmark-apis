#!/bin/bash

rustup default nightly
cargo run --release > /dev/null 2>&1 &

echo $!