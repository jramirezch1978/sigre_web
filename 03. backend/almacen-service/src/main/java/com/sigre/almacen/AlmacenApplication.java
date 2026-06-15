package com.sigre.almacen;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.sql.init.SqlInitializationAutoConfiguration;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication(
        scanBasePackages = {"com.sigre.almacen", "com.sigre.common"},
        exclude = {DataSourceAutoConfiguration.class, SqlInitializationAutoConfiguration.class})
@EnableFeignClients
public class AlmacenApplication {
    public static void main(String[] args) {
        SpringApplication.run(AlmacenApplication.class, args);
    }
}
