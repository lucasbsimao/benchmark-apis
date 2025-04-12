package com.benchmark.domain

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
class BenchmarkController {

    private fun compute(n: Int): Double {
        var result = 0.0
        val temp = DoubleArray(n)

        for (i in 0 until n) {
            temp[i] = kotlin.math.sqrt((i * i + i).toDouble())
            result += temp[i]
        }

        return result
    }

    @GetMapping("/benchmark")
    suspend fun get(@RequestParam n: Int): ResponseEntity<String> {
        val result = compute(n)

        return ResponseEntity.ok()
            .header("X-Benchmark-Result", result.toString())
            .body("OK")
    }
}