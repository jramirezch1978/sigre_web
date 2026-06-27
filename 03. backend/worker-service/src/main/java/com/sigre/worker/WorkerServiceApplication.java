package com.sigre.worker;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * worker-service: procesos en segundo plano de SIGRE.
 * Hoy: vencimiento de licencias (15 días) y eliminación de la BD demo (20 días).
 */
@SpringBootApplication
@EnableScheduling
public class WorkerServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(WorkerServiceApplication.class, args);
    }
}
