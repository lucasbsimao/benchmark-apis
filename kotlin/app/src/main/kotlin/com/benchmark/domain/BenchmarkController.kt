package com.benchmark.domain

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

        for (i in 1..n) {
            val md = MessageDigest.getInstance("SHA-256")
            md.digest(contents.toByteArray(Charsets.UTF_8))
        }

        return "OK"
    }

    private fun bytesToHex(bytes: ByteArray): String? {
        val result = StringBuilder()
        for (b in bytes) {
            result.append(String.format("%02x", b))
        }
        return result.toString()
    }

}