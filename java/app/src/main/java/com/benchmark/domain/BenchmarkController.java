package com.benchmark.domain;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class BenchmarkController {
    @GetMapping("/")
    public String get() {
        
        return "blog";
    }

}