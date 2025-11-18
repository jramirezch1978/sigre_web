package com.sigre.campo;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class CampoApplication {
    public static void main(String[] args) {
        SpringApplication.run(CampoApplication.class, args);
        System.out.println("SIGRE 2.0 - Campo Service - Puerto: 8095");
    }
}

