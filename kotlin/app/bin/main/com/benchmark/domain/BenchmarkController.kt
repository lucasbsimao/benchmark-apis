package com.benchmark.domain

import kotlinx.coroutines.delay
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.io.File
import java.security.MessageDigest

@RestController()
class BenchmarkController {
    @GetMapping("/benchmark")
    suspend fun get(@RequestParam n: Int): String {
        val file = "/tmp/txt"

        val contents = File(file).readText(Charsets.UTF_8)

        for (i in 0..n) {
            val md = MessageDigest.getInstance("SHA-256")
            val bytes = md.digest(contents.toByteArray(Charsets.UTF_8))
        }

        return "OK"
    }

}