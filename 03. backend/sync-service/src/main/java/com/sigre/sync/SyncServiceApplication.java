package com.sigre.sync;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
@EnableScheduling
@EnableDiscoveryClient
public class SyncServiceApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(SyncServiceApplication.class, args);
    }
}