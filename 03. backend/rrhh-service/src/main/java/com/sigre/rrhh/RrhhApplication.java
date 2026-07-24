package com.sigre.rrhh;

import com.sigre.common.maestro.EnableSigreRepositories;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.sql.init.SqlInitializationAutoConfiguration;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication(
        scanBasePackages = {"com.sigre.rrhh", "com.sigre.common"},
        exclude = {DataSourceAutoConfiguration.class, SqlInitializationAutoConfiguration.class})
@EnableSigreRepositories("com.sigre.rrhh")
@EnableFeignClients
public class RrhhApplication {
    public static void main(String[] args) {
        SpringApplication.run(RrhhApplication.class, args);
    }
}
