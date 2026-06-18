package pe.restaurant.produccion.event.publisher;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.util.Constants;
import pe.restaurant.produccion.client.AlmacenCosteoIntegracionClient;
import pe.restaurant.produccion.entity.OrdenTrabajo;
import pe.restaurant.produccion.event.CosteoPeriodoProcesadoEvent;

@Slf4j
@Service
@RequiredArgsConstructor
public class HttpProduccionEventPublisher implements ProduccionEventPublisher {

    private final AlmacenCosteoIntegracionClient almacenCosteoIntegracionClient;

    @Override
    public void publicarCosteoCompletado(Integer anio, Integer mes, Long sucursalId, Long almacenId,
                                         int totalOts, int creadas, int actualizadas) {
        CosteoPeriodoProcesadoEvent payload = CosteoPeriodoProcesadoEvent.builder()
                .eventType("produccion.costeo.completado")
                .empresaId(TenantContext.getEmpresaId())
                .sucursalId(TenantContext.getSucursalId())
                .usuarioId(TenantContext.getUsuarioId())
                .moduloOrigen(Constants.MODULO_PRODUCCION)
                .anio(anio)
                .mes(mes)
                .sucursalFiltroId(sucursalId)
                .almacenFiltroId(almacenId)
                .totalOtsProcesadas(totalOts)
                .totalCreadas(creadas)
                .totalActualizadas(actualizadas)
                .build();

        ejecutarDespuesDeCommit(() -> invocarAlmacenCosteo(payload, anio, mes));
        log.debug("Evento produccion.costeada (auditoría HTTP pendiente): {}-{}", anio, mes);
    }

    @Override
    public void publicarOrdenCompletada(OrdenTrabajo ordenTrabajo) {
        log.debug("Evento produccion.completada (auditoría HTTP pendiente): OT id={}",
                ordenTrabajo != null ? ordenTrabajo.getId() : null);
    }

    @Override
    public void publicarOrdenCancelada(OrdenTrabajo ordenTrabajo) {
        log.debug("Evento produccion.cancelada (auditoría HTTP pendiente): OT id={}",
                ordenTrabajo != null ? ordenTrabajo.getId() : null);
    }

    private void invocarAlmacenCosteo(CosteoPeriodoProcesadoEvent payload, Integer anio, Integer mes) {
        try {
            var response = almacenCosteoIntegracionClient.aplicarCosteo(payload);
            if (response != null && response.isSuccess()) {
                log.info("Integración costeo→almacén HTTP OK {}-{}: {}",
                        anio, mes,
                        response.getData() != null ? response.getData().getMensaje() : response.getMessage());
            } else {
                log.warn("Integración costeo→almacén HTTP respondió sin éxito {}-{}: {}",
                        anio, mes, response != null ? response.getMessage() : "sin respuesta");
            }
        } catch (Exception e) {
            log.warn("No se pudo invocar ms-almacen tras costeo {}-{}: {}", anio, mes, e.getMessage());
        }
    }

    private void ejecutarDespuesDeCommit(Runnable action) {
        if (TransactionSynchronizationManager.isSynchronizationActive()) {
            TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                @Override
                public void afterCommit() {
                    action.run();
                }
            });
        } else {
            action.run();
        }
    }
}
