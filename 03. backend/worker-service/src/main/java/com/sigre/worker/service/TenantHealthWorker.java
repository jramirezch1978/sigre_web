package com.sigre.worker.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

/**
 * Dispara la verificación de BDs tenant en seguridad-service:
 * <ul>
 *   <li>Una vez al arrancar ({@code modo=arranque}).</li>
 *   <li>Cada 30 minutos ({@code modo=periodico}) para detectar desconexiones.</li>
 * </ul>
 * El worker solo agenda/dispara; seguridad-service hace el ping JDBC y envía los correos.
 */
@Slf4j
@Service
public class TenantHealthWorker {

    private final RestClient restClient = RestClient.create();

    @Value("${worker.seguridad.base-url:http://seguridad-service:9001}")
    private String seguridadBaseUrl;

    private volatile java.time.OffsetDateTime ultimaCorridaArranque;
    private volatile java.time.OffsetDateTime ultimaCorridaPeriodica;

    public java.time.OffsetDateTime getUltimaCorridaArranque() {
        return ultimaCorridaArranque;
    }

    public java.time.OffsetDateTime getUltimaCorridaPeriodica() {
        return ultimaCorridaPeriodica;
    }

    /** Espera a que el contexto termine de levantar antes de llamar a seguridad-service. */
    @EventListener(ApplicationReadyEvent.class)
    public void verificarDisponibilidadTenantsAlArrancar() {
        this.ultimaCorridaArranque = java.time.OffsetDateTime.now();
        disparar("arranque");
    }

    /** Monitoreo continuo: cada 30 minutos (configurable). */
    @Scheduled(cron = "${worker.tenants.cron-salud:0 0/30 * * * *}")
    public void verificarDisponibilidadTenantsPeriodico() {
        this.ultimaCorridaPeriodica = java.time.OffsetDateTime.now();
        disparar("periodico");
    }

    private void disparar(String modo) {
        try {
            restClient.post()
                    .uri(seguridadBaseUrl + "/api/internal/tenants/verificar-disponibilidad?modo=" + modo)
                    .retrieve()
                    .toBodilessEntity();
            log.info("[worker] Verificación de tenants disparada (modo={})", modo);
        } catch (Exception e) {
            log.error("[worker] Error verificando disponibilidad de tenants (modo={}): {}", modo, e.getMessage());
        }
    }
}
