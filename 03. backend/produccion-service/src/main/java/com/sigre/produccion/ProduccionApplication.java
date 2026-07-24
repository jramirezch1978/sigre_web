package com.sigre.produccion;

import com.sigre.common.maestro.EnableSigreRepositories;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.sql.init.SqlInitializationAutoConfiguration;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication(
        scanBasePackages = {"com.sigre.produccion", "com.sigre.common"},
        exclude = {DataSourceAutoConfiguration.class, SqlInitializationAutoConfiguration.class})
@EnableSigreRepositories("com.sigre.produccion")
@EnableJpaAuditing
@EnableFeignClients
public class ProduccionApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProduccionApplication.class, args);
    }
}
