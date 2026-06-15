package com.sigre.almacen.event.publisher;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import com.sigre.almacen.client.ContabilidadPreAsientoClient;
import com.sigre.almacen.entity.ArticuloMovTipo;
import com.sigre.almacen.entity.ValeMov;
import com.sigre.almacen.entity.ValeMovDet;
import com.sigre.almacen.event.CosteoPeriodoProcesadoEvent;
import com.sigre.almacen.messaging.AlmacenMessagingConstants;
import com.sigre.common.event.PreAsientoEvent;
import com.sigre.common.security.TenantContext;
import com.sigre.common.util.Constants;

import java.math.BigDecimal;
import java.time.YearMonth;

/**
 * Emite los pre-asientos de almacén hacia contabilidad-service por HTTP (Feign), no por RabbitMQ.
 * La invocación se ejecuta tras el commit de la transacción y es best-effort: cualquier error
 * solo se registra como advertencia para no afectar la operación de almacén.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class HttpAlmacenPreAsientoPublisher implements AlmacenPreAsientoPublisher {

    private final ContabilidadPreAsientoClient contabilidadPreAsientoClient;

    @Override
    public void publicarCosteoProduccion(CosteoPeriodoProcesadoEvent evento, int costeosEnPeriodo,
                                         int lineasValeActualizadas) {
        YearMonth periodo = YearMonth.of(evento.getAnio(), evento.getMes());
        PreAsientoEvent payload = PreAsientoEvent.builder()
                .eventType(AlmacenMessagingConstants.ROUTING_PRE_ASIENTO_COSTEO)
                .empresaId(evento.getEmpresaId())
                .sucursalId(evento.getSucursalId() != null ? evento.getSucursalId() : evento.getSucursalFiltroId())
                .usuarioId(evento.getUsuarioId())
                .moduloOrigen(Constants.MODULO_ALMACEN)
                .tipoDocumento("COSTEO_PRODUCCION")
                .numeroDocumento(periodo.toString())
                .fechaContable(periodo.atEndOfMonth())
                .glosa("Costeo producción %s — %d OTs, %d líneas vale actualizadas"
                        .formatted(periodo, costeosEnPeriodo, lineasValeActualizadas))
                .build();
        invocarContabilidad(payload, "costeo producción " + periodo);
    }

    @Override
    public void publicarMovimientoConfirmado(ValeMov mov, ArticuloMovTipo tipo) {
        if (!PreAsientoMovimientoClasificador.contabiliza(tipo)) {
            return;
        }
        var tipoAsiento = PreAsientoMovimientoClasificador.clasificar(mov);
        if (tipoAsiento == null) {
            log.debug("Movimiento valeId={} clase={} no genera asiento de ingreso/consumo.",
                    mov.getId(), mov.getTipoReferenciaOrigen());
            return;
        }

        BigDecimal importe = calcularImporteTotal(mov);
        PreAsientoEvent payload = PreAsientoEvent.builder()
                .eventType(tipoAsiento.routingKey)
                .sucursalId(mov.getSucursalId())
                .usuarioId(TenantContext.getUsuarioId())
                .moduloOrigen(Constants.MODULO_ALMACEN)
                .tipoDocumento(tipoAsiento.tipoDocumento)
                .numeroDocumento(mov.getNroVale())
                .fechaContable(mov.getFechaMov())
                .glosa("%s almacén vale %s (almacenId=%d) por %s"
                        .formatted(tipoAsiento.tipoDocumento, mov.getNroVale(), mov.getAlmacenId(),
                                importe.toPlainString()))
                .build();
        invocarContabilidad(payload, "movimiento valeId=" + mov.getId());
    }

    private void invocarContabilidad(PreAsientoEvent payload, String descripcion) {
        ejecutarDespuesDeCommit(() -> {
            try {
                var response = contabilidadPreAsientoClient.registrarPreAsiento(payload);
                if (response != null && response.isSuccess()) {
                    log.info("Pre-asiento {} registrado en contabilidad (HTTP). tipoDocumento={}",
                            descripcion, payload.getTipoDocumento());
                } else {
                    log.warn("Contabilidad respondió sin éxito al pre-asiento {}: {}",
                            descripcion, response != null ? response.getMessage() : "sin respuesta");
                }
            } catch (Exception e) {
                log.warn("No se pudo registrar pre-asiento {} en contabilidad (HTTP): {}",
                        descripcion, e.getMessage());
            }
        });
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

    private BigDecimal calcularImporteTotal(ValeMov mov) {
        if (mov.getLineas() == null) {
            return BigDecimal.ZERO;
        }
        BigDecimal total = BigDecimal.ZERO;
        for (ValeMovDet linea : mov.getLineas()) {
            BigDecimal cantidad = linea.getCantProcesada() != null ? linea.getCantProcesada() : BigDecimal.ZERO;
            BigDecimal costo = linea.getCostoUnitario() != null ? linea.getCostoUnitario() : BigDecimal.ZERO;
            total = total.add(cantidad.multiply(costo));
        }
        return total;
    }
}
