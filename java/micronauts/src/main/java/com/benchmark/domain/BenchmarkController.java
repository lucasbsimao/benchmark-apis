package com.benchmark.domain;

import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.QueryValue;
import io.micronaut.http.HttpResponse;
@Controller("/benchmark")
public class BenchmarkController {

    private double compute(int n) {
        double result = 0.0;
        double[] temp = new double[n];

        for (int i = 0; i < n; i++) {
            temp[i] = Math.sqrt(i * i + i);
            result += temp[i];
        }

        return result;
    }

    @Get
    public HttpResponse<String> get(@QueryValue Integer n) throws Exception {
        double result = compute(n);

        return HttpResponse.ok("OK")
                .header("X-Benchmark-Result", Double.toString(result));
    }

}