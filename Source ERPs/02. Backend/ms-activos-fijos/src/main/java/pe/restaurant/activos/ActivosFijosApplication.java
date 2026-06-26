package pe.restaurant.activos;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.sql.init.SqlInitializationAutoConfiguration;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication(
        scanBasePackages = {"pe.restaurant.activos", "pe.restaurant.common"},
        exclude = {DataSourceAutoConfiguration.class, SqlInitializationAutoConfiguration.class})
@EnableFeignClients
@EnableJpaAuditing
public class ActivosFijosApplication {
    public static void main(String[] args) {
        SpringApplication.run(ActivosFijosApplication.class, args);
    }
}
