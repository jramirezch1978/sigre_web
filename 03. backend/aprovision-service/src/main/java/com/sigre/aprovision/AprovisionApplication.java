package com.sigre.aprovision;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class AprovisionApplication {
    public static void main(String[] args) {
        SpringApplication.run(AprovisionApplication.class, args);
        System.out.println("SIGRE 2.0 - Aprovisionamiento Service - Puerto: 8090");
    }
}

