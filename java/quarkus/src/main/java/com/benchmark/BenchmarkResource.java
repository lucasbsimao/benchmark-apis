package com.benchmark;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.Response;

@Path("/benchmark")
public class BenchmarkResource {

    private double compute(int n) {
        double result = 0.0;
        double[] temp = new double[n];

        for (int i = 0; i < n; i++) {
            temp[i] = Math.sqrt(i * i + i);
            result += temp[i];
        }

        return result;
    }

    @GET
    public Response  benchmark(@QueryParam("n") Integer n) throws Exception {
        double result = compute(n);

        return Response.ok("OK")
                .header("X-Benchmark-Result", Double.toString(result))
                .build();
    }
}
