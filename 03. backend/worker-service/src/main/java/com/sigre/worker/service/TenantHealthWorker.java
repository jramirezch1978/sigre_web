package com.sigre.worker.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

/**
 * Dispara la verificación de disponibilidad de BDs tenant en seguridad-service (que es
 * el dueño de la conexión a cada tenant y del envío de correos). El worker solo agenda
 * y delega, igual que avisarRenovaciones() en LicenciaWorker.
 */
@Slf4j
@Service
public class TenantHealthWorker {

    private final RestClient restClient = RestClient.create();

    @Value("${worker.seguridad.base-url:http://seguridad-service:9001}")
    private String seguridadBaseUrl;

    private volatile java.time.OffsetDateTime ultimaCorrida;

    public java.time.OffsetDateTime getUltimaCorrida() { return ultimaCorrida; }

    @Scheduled(cron = "${worker.tenant-health.cron:0 */5 * * * *}")
    public void verificarDisponibilidadTenants() {
        this.ultimaCorrida = java.time.OffsetDateTime.now();
        try {
            restClient.post()
                    .uri(seguridadBaseUrl + "/api/internal/tenants/verificar-disponibilidad")
                    .retrieve()
                    .toBodilessEntity();
        } catch (Exception e) {
            log.error("[worker] Error verificando disponibilidad de tenants: {}", e.getMessage());
        }
    }
}
