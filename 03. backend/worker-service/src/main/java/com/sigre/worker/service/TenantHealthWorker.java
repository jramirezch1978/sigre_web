package com.sigre.worker.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

/**
 * Dispara la verificación de disponibilidad de BDs tenant en seguridad-service (que es
 * el dueño de la conexión a cada tenant y del envío de correos) UNA sola vez, cuando
 * arranca worker-service — no de forma periódica. El worker solo agenda/dispara y
 * delega, igual que avisarRenovaciones() en LicenciaWorker.
 */
@Slf4j
@Service
public class TenantHealthWorker {

    private final RestClient restClient = RestClient.create();

    @Value("${worker.seguridad.base-url:http://seguridad-service:9001}")
    private String seguridadBaseUrl;

    private volatile java.time.OffsetDateTime ultimaCorrida;

    public java.time.OffsetDateTime getUltimaCorrida() { return ultimaCorrida; }

    /** ApplicationReadyEvent (no @PostConstruct): espera a que todo el contexto termine de
     * levantar antes de llamar a seguridad-service por HTTP. */
    @EventListener(ApplicationReadyEvent.class)
    public void verificarDisponibilidadTenantsAlArrancar() {
        this.ultimaCorrida = java.time.OffsetDateTime.now();
        try {
            restClient.post()
                    .uri(seguridadBaseUrl + "/api/internal/tenants/verificar-disponibilidad")
                    .retrieve()
                    .toBodilessEntity();
            log.info("[worker] Verificación de disponibilidad de tenants disparada al arrancar");
        } catch (Exception e) {
            log.error("[worker] Error verificando disponibilidad de tenants al arrancar: {}", e.getMessage());
        }
    }
}
