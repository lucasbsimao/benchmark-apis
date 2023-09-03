package com.benchmark;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;

import java.io.*;
import java.security.MessageDigest;

@Path("/benchmark")
public class BenchmarkResource {

    @GET
    public String benchmark(@QueryParam("n") Integer n) throws Exception {
        String file = "/tmp/txt";

        FileInputStream fis = new FileInputStream(file);

        for (int i = 0; i < n; i++) {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = fis.readAllBytes();
            md.digest(bytes);
        }

        fis.close();

        return "OK";
    }
}
