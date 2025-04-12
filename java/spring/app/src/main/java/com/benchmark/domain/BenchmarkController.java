package com.benchmark.domain;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;

import java.io.*;
import org.springframework.http.HttpHeaders;
import java.nio.file.Files;
import java.security.MessageDigest;

@RestController
class BenchmarkController {

    private double compute(int n) {
        double result = 0.0;
        double[] temp = new double[n];

        for (int i = 0; i < n; i++) {
            temp[i] = Math.sqrt(i * i + i);
            result += temp[i];
        }

        return result;
    }

    @GetMapping("/benchmark")
    public ResponseEntity<String> get(@RequestParam Integer n) throws Exception {
        double result = compute(n);

        HttpHeaders headers = new HttpHeaders();
        headers.add("X-Benchmark-Result", Double.toString(result));

        return ResponseEntity.ok()
                .headers(headers)
                .body("OK");
    }

}