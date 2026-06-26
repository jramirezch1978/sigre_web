package pe.restaurant.notificaciones;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.sql.init.SqlInitializationAutoConfiguration;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication(
        scanBasePackages = {"pe.restaurant.notificaciones", "pe.restaurant.common"},
        exclude = {DataSourceAutoConfiguration.class, SqlInitializationAutoConfiguration.class}
)
@EnableFeignClients
public class NotificacionesApplication {
    public static void main(String[] args) {
        SpringApplication.run(NotificacionesApplication.class, args);
    }
}
