package com.benchmark.domain;

import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.QueryValue;


import java.io.*;
import java.security.MessageDigest;

@Controller("/benchmark")
public class BenchmarkController {

    @Get
    public String get(@QueryValue Integer n) throws Exception {
        String file = "/tmp/txt";
        FileInputStream fis = new FileInputStream(file);

        for (int i = 0; i < n; i++) {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.digest(fis.readAllBytes());
        }

        return "OK";
    }

}