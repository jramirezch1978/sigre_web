package pe.restaurant.contabilidad.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.contabilidad.dto.request.AsientoDetalleRequest;
import pe.restaurant.contabilidad.dto.request.AsientoManualDetalleRequest;
import pe.restaurant.contabilidad.dto.request.AsientoManualRequest;
import pe.restaurant.contabilidad.dto.request.AsientoRequest;
import pe.restaurant.contabilidad.entity.CntblAsiento;
import pe.restaurant.contabilidad.enums.TipoOperacionContable;
import pe.restaurant.contabilidad.service.AsientoManualService;
import pe.restaurant.contabilidad.service.AsientoService;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AsientoManualServiceImpl implements AsientoManualService {

    private final AsientoService asientoService;

    @Override
    @Transactional
    public CntblAsiento crear(AsientoManualRequest request) {
        log.info("Creando asiento manual - fecha: {}, libroId: {}, monedaId: {}",
                request.getFechaContable(), request.getLibroId(), request.getMonedaId());

        AsientoRequest internalRequest = mapToInternalRequest(request);
        return asientoService.crear(internalRequest);
    }

    @Override
    @Transactional
    public CntblAsiento actualizar(Long id, AsientoManualRequest request) {
        log.info("Actualizando asiento manual id: {} - fecha: {}, libroId: {}, monedaId: {}",
                id, request.getFechaContable(), request.getLibroId(), request.getMonedaId());

        AsientoRequest internalRequest = mapToInternalRequest(request);
        return asientoService.actualizar(id, internalRequest);
    }

    private AsientoRequest mapToInternalRequest(AsientoManualRequest request) {
        AsientoRequest target = new AsientoRequest();

        TipoOperacionContable tipo = determinarTipoOperacion(
                request.getTipoOperacion(), request.getDetalles());

        target.setSucursalId(TenantContext.getSucursalId());
        target.setNaturalezaAsiento(tipo.getTipoOperacion());
        target.setModuloOrigen(tipo.getModulo());
        target.setCntblPreasientoId(null);

        target.setFecha(request.getFechaContable());
        target.setAno(request.getFechaContable().getYear());
        target.setMes(request.getFechaContable().getMonthValue());

        target.setLibroId(request.getLibroId());
        target.setMonedaId(request.getMonedaId());
        target.setTasaCambio(request.getTasaCambio());
        target.setGlosa(request.getGlosa());

        target.setDetalles(mapDetalles(request.getDetalles()));

        return target;
    }

    private TipoOperacionContable determinarTipoOperacion(
            String tipoOperacionStr,
            List<AsientoManualDetalleRequest> detalles) {

        if (tipoOperacionStr != null && !tipoOperacionStr.isBlank()) {
            try {
                return TipoOperacionContable.valueOf(tipoOperacionStr);
            } catch (IllegalArgumentException e) {
                throw new BusinessException(
                        "Tipo de operación inválido: " + tipoOperacionStr
                                + ". Valores permitidos: CARTERA_PAGOS, CARTERA_COBROS, TRANSFERENCIA, "
                                + "LIQUIDACION_GIRO, APLICACION_DOCUMENTOS, CANJE_DOCUMENTOS, "
                                + "REGISTRO_CNTAS_PAGAR, REGISTRO_CNTAS_COBRAR",
                        HttpStatus.UNPROCESSABLE_ENTITY,
                        "CONT-123");
            }
        }

        for (AsientoManualDetalleRequest det : detalles) {
            if (det.getCajaBancosId() != null) return TipoOperacionContable.TRANSFERENCIA;
            if (det.getSolicitudGiroId() != null) return TipoOperacionContable.LIQUIDACION_GIRO;
            if (det.getLiquidacionId() != null) return TipoOperacionContable.LIQUIDACION_GIRO;
            if (det.getCntasPagarId() != null) return TipoOperacionContable.CARTERA_PAGOS;
            if (det.getCntasCobrarId() != null) return TipoOperacionContable.CARTERA_COBROS;
        }

        return TipoOperacionContable.MANUAL;
    }

    private List<AsientoDetalleRequest> mapDetalles(List<AsientoManualDetalleRequest> detalles) {
        if (detalles == null) {
            return new ArrayList<>();
        }

        List<AsientoDetalleRequest> result = new ArrayList<>(detalles.size());
        for (AsientoManualDetalleRequest det : detalles) {
            AsientoDetalleRequest detTarget = new AsientoDetalleRequest();
            detTarget.setPlanContableDetId(det.getPlanContableDetId());
            detTarget.setCentrosCostoId(det.getCentrosCostoId());
            detTarget.setEntidadContribuyenteId(det.getEntidadContribuyenteId());
            detTarget.setGlosaDetalle(det.getGlosaDetalle());
            detTarget.setDocTipoId(det.getDocTipoId());
            detTarget.setNroReferencia(det.getNroReferencia());
            detTarget.setCajaBancosId(det.getCajaBancosId());
            detTarget.setSolicitudGiroId(det.getSolicitudGiroId());
            detTarget.setLiquidacionId(det.getLiquidacionId());
            detTarget.setAfMaestroId(det.getAfMaestroId());
            detTarget.setCntasPagarId(det.getCntasPagarId());
            detTarget.setCntasCobrarId(det.getCntasCobrarId());
            detTarget.setBancoCtaId(det.getBancoCtaId());
            detTarget.setFlagDebeHaber(det.getFlagDebeHaber());
            detTarget.setImporteSol(det.getImporteSol());
            detTarget.setImporteDol(det.getImporteDol());
            result.add(detTarget);
        }
        return result;
    }
}
