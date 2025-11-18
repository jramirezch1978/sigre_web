package com.sigre.sig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class SigApplication {
    public static void main(String[] args) {
        SpringApplication.run(SigApplication.class, args);
        System.out.println("SIGRE 2.0 - SIG Service - Puerto: 8098");
    }
}

