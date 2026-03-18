package com.sigre.sync;

import com.sigre.config.SigreConfigAutoConfiguration;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class, SigreConfigAutoConfiguration.class})
@EnableDiscoveryClient
public class SyncServiceApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(SyncServiceApplication.class, args);
    }
}