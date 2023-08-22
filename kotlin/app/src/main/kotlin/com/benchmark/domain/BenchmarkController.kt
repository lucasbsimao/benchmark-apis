package com.benchmark.domain

import kotlinx.coroutines.delay
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class BenchmarkController {
    @GetMapping("/")
    suspend fun get(): String {
        println("   'runBlocking': I'm working in thread ${Thread.currentThread().name}")
        delay(3000)
        return "blog"
    }

}