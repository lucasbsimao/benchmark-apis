package com.benchmark.domain;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.*;
import java.nio.file.Files;
import java.security.MessageDigest;

@RestController
class BenchmarkController {
    @GetMapping("/benchmark")
    public String get(@RequestParam Integer n) throws Exception {
        String file = "/tmp/txt";

        byte[] fileContents = Files.readAllBytes(new File(file).toPath());

        for (int i = 0; i < n; i++) {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.digest(fileContents);
        }

        return "OK";
    }

}