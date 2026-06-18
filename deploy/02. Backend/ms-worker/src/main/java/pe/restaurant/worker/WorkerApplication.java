package pe.restaurant.worker;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Microservicio de procesos en segundo plano.
 * Centraliza: jobs programados (cron), procesos batch, reportes pesados, consumo de colas RabbitMQ.
 */
@SpringBootApplication(scanBasePackages = {"pe.restaurant.worker", "pe.restaurant.common"})
@EnableFeignClients(basePackages = "pe.restaurant.worker.client")
@EnableScheduling
public class WorkerApplication {
    public static void main(String[] args) {
        SpringApplication.run(WorkerApplication.class, args);
    }
}
