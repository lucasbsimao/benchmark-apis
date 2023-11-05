package com.benchmark.domain

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.nio.file.Files
import java.nio.file.Paths
import java.security.MessageDigest

@RestController()
class BenchmarkController {
    @GetMapping("/benchmark")
    suspend fun get(@RequestParam n: Int): String {
        val file = "/tmp/txt"

        val fileContents = Files.readAllBytes(Paths.get(file))

        for (i in 1..n) {
            val md = MessageDigest.getInstance("SHA-256")
            md.digest(fileContents)
        }

        return "OK"
    }

}