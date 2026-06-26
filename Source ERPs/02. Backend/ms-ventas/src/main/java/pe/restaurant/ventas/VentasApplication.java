package pe.restaurant.ventas;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.sql.init.SqlInitializationAutoConfiguration;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication(
        scanBasePackages = {"pe.restaurant.ventas", "pe.restaurant.common"},
        exclude = {DataSourceAutoConfiguration.class, SqlInitializationAutoConfiguration.class})
@EnableFeignClients
@EnableJpaAuditing
public class VentasApplication {
    public static void main(String[] args) {
        SpringApplication.run(VentasApplication.class, args);
    }
}
