package pe.restaurant.activos.service.impl;

import feign.FeignException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.client.ContabilidadAsientosClient;
import pe.restaurant.activos.client.dto.contabilidad.AsientoDetalleRequest;
import pe.restaurant.activos.client.dto.contabilidad.AsientoRequest;
import pe.restaurant.activos.client.dto.contabilidad.AsientoResponse;
import pe.restaurant.activos.config.IntegracionProperties;
import pe.restaurant.activos.dto.IntegracionContabilidadResult;
import pe.restaurant.activos.entity.AfAdaptacion;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfMatrizSubClase;
import pe.restaurant.activos.entity.AfPolizaActivo;
import pe.restaurant.activos.entity.AfPrimaDevengo;
import pe.restaurant.activos.entity.AfValuacion;
import pe.restaurant.activos.entity.AfVenta;
import pe.restaurant.activos.entity.AfMaestroCcDistrib;
import pe.restaurant.activos.integracion.AfIntegracionContableModulo;
import pe.restaurant.activos.repository.AfAdaptacionRepository;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfMatrizSubClaseRepository;
import pe.restaurant.activos.repository.AfPolizaActivoRepository;
import pe.restaurant.activos.repository.AfPrimaDevengoRepository;
import pe.restaurant.activos.repository.AfMaestroCcDistribRepository;
import pe.restaurant.activos.repository.AfValuacionRepository;
import pe.restaurant.activos.repository.AfVentaRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.activos.service.AfHistorialRegistroService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ContabilidadIntegracionServiceImpl implements ContabilidadIntegracionService {

    private final IntegracionProperties integracionProperties;
    private final ContabilidadAsientosClient contabilidadClient;
    private final AfAdaptacionRepository adaptacionRepository;
    private final AfCalculoCntblRepository calculoRepository;
    private final AfPrimaDevengoRepository devengoRepository;
    private final AfVentaRepository ventaRepository;
    private final AfValuacionRepository valuacionRepository;
    private final AfMaestroRepository maestroRepository;
    private final AfMatrizSubClaseRepository matrizRepository;
    private final AfPolizaActivoRepository polizaActivoRepository;
    private final AfMaestroCcDistribRepository maestroCcDistribRepository;
    private final AfHistorialRegistroService historialRegistroService;

    @Override
    @Transactional
    public IntegracionContabilidadResult contabilizarDepreciacion(Long calculoId) {
        verificarContabilidadHabilitada();
        AfCalculoCntbl calculo = calculoRepository.findById(calculoId)
                .orElseThrow(() -> new ResourceNotFoundException("Cálculo de depreciación", calculoId));

        if (calculo.getCntblAsientoId() != null) {
            return resultadoExistente(AfIntegracionContableModulo.MODULO, calculoId, calculo.getCntblAsientoId(),
                    correlacionDepreciacion(calculo));
        }

        BigDecimal monto = calculo.getDepreciacionPeriodo();
        validarMontoPositivo(monto);

        AfMaestro activo = maestroRepository.findById(calculo.getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", calculo.getAfMaestroId()));
        AfMatrizSubClase matriz = requireMatrizDepreciacion(activo.getAfSubClaseId());

        String correlacion = correlacionDepreciacion(calculo);
        IntegracionContabilidadResult existente = resolverIdempotencia(
                AfIntegracionContableModulo.MODULO, calculoId, correlacion);
        if (existente != null) {
            calculo.setCntblAsientoId(existente.getAsientoId());
            calculo.setUpdatedBy(TenantContext.getUsuarioId());
            calculoRepository.save(calculo);
            return existente;
        }

        List<AsientoDetalleRequest> detalles = construirDetallesDepreciacion(activo, matriz, monto, correlacion);

        Long asientoId = crearAsientoRemoto(
                AfIntegracionContableModulo.DEPRECIACION,
                calculoId,
                fechaPeriodo(calculo.getAnio(), calculo.getMes()),
                "Depreciación AF activo " + activo.getCodigo() + " " + calculo.getMes() + "/" + calculo.getAnio(),
                detalles);

        calculo.setCntblAsientoId(asientoId);
        calculo.setUpdatedBy(TenantContext.getUsuarioId());
        calculoRepository.save(calculo);
        registrarHistorialContable(activo.getId(), "DEPRECIACION_CONTABILIZADA", asientoId, correlacion);
        return IntegracionContabilidadResult.builder()
                .asientoId(asientoId)
                .moduloOrigen(AfIntegracionContableModulo.MODULO)
                .documentoOrigenId(calculoId)
                .correlacion(correlacion)
                .yaExistia(false)
                .build();
    }

    @Override
    @Transactional
    public IntegracionContabilidadResult contabilizarDevengoPrima(Long devengoId) {
        verificarContabilidadHabilitada();
        AfPrimaDevengo devengo = devengoRepository.findById(devengoId)
                .orElseThrow(() -> new ResourceNotFoundException("Devengo de prima", devengoId));

        if (devengo.getCntblAsientoId() != null) {
            return resultadoExistente(AfIntegracionContableModulo.MODULO, devengoId, devengo.getCntblAsientoId(),
                    correlacionDevengo(devengo));
        }

        BigDecimal monto = devengo.getImporteDevengado();
        validarMontoPositivo(monto);

        AfMatrizSubClase matriz = resolveMatrizParaPoliza(devengo.getAfPolizaSeguroId());
        requireCuentasDevengo(matriz);

        String correlacion = correlacionDevengo(devengo);
        IntegracionContabilidadResult existente = resolverIdempotencia(
                AfIntegracionContableModulo.MODULO, devengoId, correlacion);
        if (existente != null) {
            devengo.setCntblAsientoId(existente.getAsientoId());
            devengo.setUpdatedBy(TenantContext.getUsuarioId());
            devengoRepository.save(devengo);
            return existente;
        }

        Long cuentaGasto = cuentaGastoSeguro(matriz);
        Long cuentaPasivo = cuentaPasivoSeguro(matriz);
        List<AsientoDetalleRequest> detalles = List.of(
                detalle(cuentaGasto, matriz.getCentroCostoId(), monto, BigDecimal.ZERO,
                        "Devengo prima seguro", correlacion),
                detalle(cuentaPasivo, matriz.getCentroCostoId(), BigDecimal.ZERO, monto,
                        "Contrapartida devengo prima", correlacion));

        Long asientoId = crearAsientoRemoto(
                AfIntegracionContableModulo.DEVENGO_PRIMA,
                devengoId,
                fechaPeriodo(devengo.getAnio(), devengo.getMes()),
                "Devengo prima póliza " + devengo.getAfPolizaSeguroId() + " " + devengo.getMes() + "/" + devengo.getAnio(),
                detalles);

        devengo.setCntblAsientoId(asientoId);
        devengo.setUpdatedBy(TenantContext.getUsuarioId());
        devengoRepository.save(devengo);

        polizaActivoRepository.findByAfPolizaSeguroId(devengo.getAfPolizaSeguroId()).stream()
                .findFirst()
                .ifPresent(pa -> registrarHistorialContable(pa.getAfMaestroId(), "DEVENGO_PRIMA_CONTABILIZADO",
                        asientoId, correlacion));

        return IntegracionContabilidadResult.builder()
                .asientoId(asientoId)
                .moduloOrigen(AfIntegracionContableModulo.MODULO)
                .documentoOrigenId(devengoId)
                .correlacion(correlacion)
                .yaExistia(false)
                .build();
    }

    @Override
    @Transactional
    public IntegracionContabilidadResult contabilizarVenta(Long ventaId) {
        verificarContabilidadHabilitada();
        AfVenta venta = ventaRepository.findById(ventaId)
                .orElseThrow(() -> new ResourceNotFoundException("Venta/baja", ventaId));

        String correlacion = correlacionVenta(venta);
        IntegracionContabilidadResult existente = resolverIdempotencia(
                AfIntegracionContableModulo.MODULO, ventaId, correlacion);
        if (existente != null) {
            return existente;
        }

        AfMaestro activo = maestroRepository.findById(venta.getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", venta.getAfMaestroId()));
        AfMatrizSubClase matriz = requireMatrizVenta(activo.getAfSubClaseId());

        BigDecimal costo = activo.getValorAdquisicion();
        BigDecimal depAcum = calculoRepository.obtenerUltimaDepreciacion(activo.getId())
                .map(AfCalculoCntbl::getDepreciacionAcumulada)
                .orElse(BigDecimal.ZERO);
        BigDecimal valorVenta = venta.getValorVenta() != null ? venta.getValorVenta() : BigDecimal.ZERO;
        BigDecimal valorNeto = costo.subtract(depAcum);
        BigDecimal resultado = valorVenta.subtract(valorNeto);

        List<AsientoDetalleRequest> detalles = new ArrayList<>();
        if (depAcum.compareTo(BigDecimal.ZERO) > 0) {
            detalles.add(detalle(matriz.getCuentaDepAcumId(), matriz.getCentroCostoId(), depAcum, BigDecimal.ZERO,
                    "Baja dep. acumulada", correlacion));
        }
        if (valorVenta.compareTo(BigDecimal.ZERO) > 0) {
            detalles.add(detalle(matriz.getCuentaActivoId(), matriz.getCentroCostoId(), valorVenta, BigDecimal.ZERO,
                    "Ingreso por venta", correlacion));
        }
        detalles.add(detalle(matriz.getCuentaActivoId(), matriz.getCentroCostoId(), BigDecimal.ZERO, costo,
                "Baja del activo", correlacion));

        BigDecimal absResultado = resultado.abs();
        if (absResultado.compareTo(BigDecimal.ZERO) > 0) {
            if (resultado.compareTo(BigDecimal.ZERO) > 0) {
                detalles.add(detalle(matriz.getCuentaResVentaId(), matriz.getCentroCostoId(), BigDecimal.ZERO,
                        absResultado, "Utilidad en venta", correlacion));
            } else {
                detalles.add(detalle(matriz.getCuentaBajaId(), matriz.getCentroCostoId(), absResultado, BigDecimal.ZERO,
                        "Pérdida en venta", correlacion));
            }
        }

        Long asientoId = crearAsientoRemoto(
                AfIntegracionContableModulo.VENTA,
                ventaId,
                venta.getFechaBaja(),
                "Baja/venta activo " + activo.getCodigo(),
                detalles);

        registrarHistorialContable(activo.getId(), "VENTA_CONTABILIZADA", asientoId, correlacion);

        return IntegracionContabilidadResult.builder()
                .asientoId(asientoId)
                .moduloOrigen(AfIntegracionContableModulo.MODULO)
                .documentoOrigenId(ventaId)
                .correlacion(correlacion)
                .yaExistia(false)
                .build();
    }

    @Override
    @Transactional
    public IntegracionContabilidadResult contabilizarValuacion(Long valuacionId) {
        verificarContabilidadHabilitada();
        AfValuacion valuacion = valuacionRepository.findById(valuacionId)
                .orElseThrow(() -> new ResourceNotFoundException("Valuación", valuacionId));

        if (valuacion.getFechaAprobacion() == null) {
            throw new BusinessException(
                    "La valuación debe estar aprobada antes de contabilizar",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.VALUACION_NO_APROBADA);
        }

        if (valuacion.getCntblAsientoId() != null) {
            return resultadoExistente(AfIntegracionContableModulo.MODULO, valuacionId, valuacion.getCntblAsientoId(),
                    correlacionValuacion(valuacion));
        }

        BigDecimal delta = valuacion.getValorNuevo().subtract(valuacion.getValorAnterior());
        if (delta.compareTo(BigDecimal.ZERO) == 0) {
            throw new BusinessException(
                    "No hay diferencia de valor para contabilizar",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.MONTO_CERO_NO_CONTABILIZABLE);
        }

        AfMaestro activo = maestroRepository.findById(valuacion.getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", valuacion.getAfMaestroId()));
        AfMatrizSubClase matriz = requireMatrizValuacion(activo.getAfSubClaseId());

        String correlacion = correlacionValuacion(valuacion);
        IntegracionContabilidadResult existente = resolverIdempotencia(
                AfIntegracionContableModulo.MODULO, valuacionId, correlacion);
        if (existente != null) {
            valuacion.setCntblAsientoId(existente.getAsientoId());
            valuacion.setUpdatedBy(TenantContext.getUsuarioId());
            valuacionRepository.save(valuacion);
            return existente;
        }

        BigDecimal monto = delta.abs();
        List<AsientoDetalleRequest> detalles;
        if (delta.compareTo(BigDecimal.ZERO) > 0) {
            detalles = List.of(
                    detalle(matriz.getCuentaActivoId(), matriz.getCentroCostoId(), monto, BigDecimal.ZERO,
                            "Revaluación al alza", correlacion),
                    detalle(matriz.getCuentaResVentaId(), matriz.getCentroCostoId(), BigDecimal.ZERO, monto,
                            "Reserva revaluación", correlacion));
        } else {
            detalles = List.of(
                    detalle(matriz.getCuentaBajaId(), matriz.getCentroCostoId(), monto, BigDecimal.ZERO,
                            "Revaluación a la baja", correlacion),
                    detalle(matriz.getCuentaActivoId(), matriz.getCentroCostoId(), BigDecimal.ZERO, monto,
                            "Reducción valor activo", correlacion));
        }

        Long asientoId = crearAsientoRemoto(
                AfIntegracionContableModulo.VALUACION,
                valuacionId,
                valuacion.getFechaValuacion(),
                "Revaluación activo " + activo.getCodigo(),
                detalles);

        valuacion.setCntblAsientoId(asientoId);
        valuacion.setUpdatedBy(TenantContext.getUsuarioId());
        valuacionRepository.save(valuacion);
        registrarHistorialContable(activo.getId(), "VALUACION_CONTABILIZADA", asientoId, correlacion);

        return IntegracionContabilidadResult.builder()
                .asientoId(asientoId)
                .moduloOrigen(AfIntegracionContableModulo.MODULO)
                .documentoOrigenId(valuacionId)
                .correlacion(correlacion)
                .yaExistia(false)
                .build();
    }

    @Override
    @Transactional
    public IntegracionContabilidadResult contabilizarAltaActivo(Long maestroId) {
        verificarContabilidadHabilitada();
        AfMaestro activo = maestroRepository.findById(maestroId)
                .orElseThrow(() -> new ResourceNotFoundException("Activo", maestroId));

        if (activo.getCntblAsientoId() != null) {
            return resultadoExistente(AfIntegracionContableModulo.MODULO, maestroId, activo.getCntblAsientoId(),
                    correlacionAlta(activo));
        }

        BigDecimal monto = activo.getValorAdquisicion();
        validarMontoPositivo(monto);
        AfMatrizSubClase matriz = requireMatrizAlta(activo.getAfSubClaseId());
        Long cuentaCredito = cuentaCreditoAlta(matriz);

        String correlacion = correlacionAlta(activo);
        IntegracionContabilidadResult existente = resolverIdempotencia(
                AfIntegracionContableModulo.MODULO, maestroId, correlacion);
        if (existente != null) {
            activo.setCntblAsientoId(existente.getAsientoId());
            activo.setUpdatedBy(TenantContext.getUsuarioId());
            maestroRepository.save(activo);
            return existente;
        }

        List<AsientoDetalleRequest> detalles = List.of(
                detalle(matriz.getCuentaActivoId(), matriz.getCentroCostoId(), monto, BigDecimal.ZERO,
                        "Alta activo fijo", correlacion),
                detalle(cuentaCredito, matriz.getCentroCostoId(), BigDecimal.ZERO, monto,
                        "Contrapartida alta activo", correlacion));

        Long asientoId = crearAsientoRemoto(
                AfIntegracionContableModulo.ALTA_ACTIVO,
                maestroId,
                activo.getFechaAdquisicion(),
                "Alta activo fijo " + activo.getCodigo(),
                detalles);

        activo.setCntblAsientoId(asientoId);
        activo.setUpdatedBy(TenantContext.getUsuarioId());
        maestroRepository.save(activo);
        registrarHistorialContable(activo.getId(), "ALTA_CONTABILIZADA", asientoId, correlacion);

        return IntegracionContabilidadResult.builder()
                .asientoId(asientoId)
                .moduloOrigen(AfIntegracionContableModulo.MODULO)
                .documentoOrigenId(maestroId)
                .correlacion(correlacion)
                .yaExistia(false)
                .build();
    }

    @Override
    @Transactional
    public IntegracionContabilidadResult contabilizarAdaptacion(Long adaptacionId) {
        verificarContabilidadHabilitada();
        AfAdaptacion adaptacion = adaptacionRepository.findById(adaptacionId)
                .orElseThrow(() -> new ResourceNotFoundException("Adaptación", adaptacionId));

        BigDecimal monto = adaptacion.getMontoTotal();
        validarMontoPositivo(monto);
        AfMaestro activo = maestroRepository.findById(adaptacion.getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", adaptacion.getAfMaestroId()));
        AfMatrizSubClase matriz = requireMatrizAlta(activo.getAfSubClaseId());
        Long cuentaCredito = cuentaCreditoCapitalizacion(matriz);

        String correlacion = correlacionAdaptacion(adaptacion);
        IntegracionContabilidadResult existente = resolverIdempotencia(
                AfIntegracionContableModulo.MODULO, adaptacionId, correlacion);
        if (existente != null) {
            return existente;
        }

        List<AsientoDetalleRequest> detalles = List.of(
                detalle(matriz.getCuentaActivoId(), matriz.getCentroCostoId(), monto, BigDecimal.ZERO,
                        "Capitalización mejora", correlacion),
                detalle(cuentaCredito, matriz.getCentroCostoId(), BigDecimal.ZERO, monto,
                        "Contrapartida capitalización", correlacion));

        Long asientoId = crearAsientoRemoto(
                AfIntegracionContableModulo.ADAPTACION,
                adaptacionId,
                adaptacion.getFecha(),
                "Capitalización adaptación activo " + activo.getCodigo(),
                detalles);

        registrarHistorialContable(activo.getId(), "ADAPTACION_CONTABILIZADA", asientoId, correlacion);

        return IntegracionContabilidadResult.builder()
                .asientoId(asientoId)
                .moduloOrigen(AfIntegracionContableModulo.MODULO)
                .documentoOrigenId(adaptacionId)
                .correlacion(correlacion)
                .yaExistia(false)
                .build();
    }

    @Override
    @Transactional
    public IntegracionContabilidadResult contabilizarBajaActivo(Long maestroId) {
        verificarContabilidadHabilitada();
        if (ventaRepository.existsByAfMaestroId(maestroId)) {
            throw new BusinessException(
                    "El activo tiene registro de venta; use contabilizar venta en su lugar",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.ACTIVO_YA_VENDIDO);
        }

        AfMaestro activo = maestroRepository.findById(maestroId)
                .orElseThrow(() -> new ResourceNotFoundException("Activo", maestroId));

        Optional<AsientoResponse> asientoBajaExistente = buscarAsientoRemoto(
                AfIntegracionContableModulo.MODULO, maestroId);
        if (asientoBajaExistente.isPresent()) {
            return resultadoExistente(AfIntegracionContableModulo.MODULO, maestroId,
                    asientoBajaExistente.get().getId(), correlacionBaja(activo));
        }

        AfMatrizSubClase matriz = requireMatrizVenta(activo.getAfSubClaseId());
        BigDecimal costo = activo.getValorAdquisicion();
        BigDecimal depAcum = calculoRepository.obtenerUltimaDepreciacion(maestroId)
                .map(AfCalculoCntbl::getDepreciacionAcumulada)
                .orElse(BigDecimal.ZERO);
        BigDecimal valorNeto = costo.subtract(depAcum);
        BigDecimal resultado = valorNeto.negate();

        String correlacion = correlacionBaja(activo);
        IntegracionContabilidadResult existente = resolverIdempotencia(
                AfIntegracionContableModulo.MODULO, maestroId, correlacion);
        if (existente != null) {
            return existente;
        }

        List<AsientoDetalleRequest> detalles = new ArrayList<>();
        if (depAcum.compareTo(BigDecimal.ZERO) > 0) {
            detalles.add(detalle(matriz.getCuentaDepAcumId(), matriz.getCentroCostoId(), depAcum, BigDecimal.ZERO,
                    "Baja dep. acumulada", correlacion));
        }
        detalles.add(detalle(matriz.getCuentaActivoId(), matriz.getCentroCostoId(), BigDecimal.ZERO, costo,
                "Baja del activo", correlacion));
        BigDecimal absResultado = resultado.abs();
        if (absResultado.compareTo(BigDecimal.ZERO) > 0) {
            detalles.add(detalle(matriz.getCuentaBajaId(), matriz.getCentroCostoId(), absResultado, BigDecimal.ZERO,
                    "Pérdida por baja de activo", correlacion));
        }

        Long asientoId = crearAsientoRemoto(
                AfIntegracionContableModulo.BAJA_ACTIVO,
                maestroId,
                LocalDate.now(),
                "Baja activo fijo " + activo.getCodigo(),
                detalles);

        registrarHistorialContable(activo.getId(), "BAJA_CONTABILIZADA", asientoId, correlacion);

        return IntegracionContabilidadResult.builder()
                .asientoId(asientoId)
                .moduloOrigen(AfIntegracionContableModulo.MODULO)
                .documentoOrigenId(maestroId)
                .correlacion(correlacion)
                .yaExistia(false)
                .build();
    }

    @Override
    public IntegracionContabilidadResult consultarTrazabilidad(String moduloOrigen, Long documentoOrigenId) {
        verificarContabilidadHabilitada();
        AsientoResponse asiento = buscarAsientoRemoto(moduloOrigen, documentoOrigenId)
                .orElseThrow(() -> new ResourceNotFoundException("Asiento contable por origen", documentoOrigenId));
        return IntegracionContabilidadResult.builder()
                .asientoId(asiento.getId())
                .moduloOrigen(moduloOrigen)
                .documentoOrigenId(documentoOrigenId)
                .correlacion(asiento.getGlosa())
                .yaExistia(true)
                .build();
    }

    private void verificarContabilidadHabilitada() {
        if (!integracionProperties.getContabilidad().isHabilitada()) {
            throw new BusinessException(
                    "Integración con contabilidad deshabilitada",
                    HttpStatus.SERVICE_UNAVAILABLE,
                    ActivosErrorCodes.INTEGRACION_CONTABILIDAD_DESHABILITADA);
        }
    }

    private IntegracionContabilidadResult resolverIdempotencia(String modulo, Long docId, String correlacion) {
        return buscarAsientoRemoto(modulo, docId)
                .map(a -> IntegracionContabilidadResult.builder()
                        .asientoId(a.getId())
                        .moduloOrigen(modulo)
                        .documentoOrigenId(docId)
                        .correlacion(correlacion)
                        .yaExistia(true)
                        .build())
                .orElse(null);
    }

    private IntegracionContabilidadResult resultadoExistente(String modulo, Long docId, Long asientoId, String correlacion) {
        return IntegracionContabilidadResult.builder()
                .asientoId(asientoId)
                .moduloOrigen(modulo)
                .documentoOrigenId(docId)
                .correlacion(correlacion)
                .yaExistia(true)
                .build();
    }

    private Long crearAsientoRemoto(String tipoOperacion, Long docId, LocalDate fecha, String glosa,
                                    List<AsientoDetalleRequest> detalles) {
        var cfg = integracionProperties.getContabilidad();
        AsientoRequest request = AsientoRequest.builder()
                .libroId(cfg.getLibroId())
                .fecha(fecha)
                .tipo(tipoOperacion)
                .glosa(glosa)
                .moduloOrigen(AfIntegracionContableModulo.MODULO)
                .documentoOrigenId(docId)
                .monedaId(cfg.getMonedaId())
                .detalles(detalles)
                .build();
        try {
            ApiResponse<AsientoResponse> response = contabilidadClient.crear(request);
            if (response == null || response.getData() == null || response.getData().getId() == null) {
                throw new BusinessException(
                        "ms-contabilidad no devolvió ID de asiento",
                        HttpStatus.BAD_GATEWAY,
                        ActivosErrorCodes.CONTABILIDAD_NO_DISPONIBLE);
            }
            log.info("Asiento creado id={} tipo={} doc={}", response.getData().getId(), tipoOperacion, docId);
            return response.getData().getId();
        } catch (FeignException e) {
            log.error("Error Feign al crear asiento: {}", e.getMessage());
            throw new BusinessException(
                    "No fue posible crear el asiento en contabilidad: " + e.getMessage(),
                    HttpStatus.BAD_GATEWAY,
                    ActivosErrorCodes.CONTABILIDAD_NO_DISPONIBLE);
        }
    }

    private Optional<AsientoResponse> buscarAsientoRemoto(String modulo, Long docId) {
        try {
            ApiResponse<AsientoResponse> response = contabilidadClient.buscarPorOrigen(modulo, docId);
            return Optional.ofNullable(response).map(ApiResponse::getData);
        } catch (FeignException.NotFound e) {
            return Optional.empty();
        } catch (FeignException e) {
            log.warn("Error al buscar asiento por origen: {}", e.getMessage());
            return Optional.empty();
        }
    }

    private AfMatrizSubClase requireMatrizDepreciacion(Long subClaseId) {
        AfMatrizSubClase matriz = requireMatriz(subClaseId);
        if (matriz.getCuentaGastoDepId() == null || matriz.getCuentaDepAcumId() == null) {
            throw matrizIncompleta();
        }
        return matriz;
    }

    private AfMatrizSubClase requireMatrizVenta(Long subClaseId) {
        AfMatrizSubClase matriz = requireMatriz(subClaseId);
        if (matriz.getCuentaActivoId() == null || matriz.getCuentaDepAcumId() == null
                || matriz.getCuentaBajaId() == null || matriz.getCuentaResVentaId() == null) {
            throw matrizIncompleta();
        }
        return matriz;
    }

    private AfMatrizSubClase requireMatrizValuacion(Long subClaseId) {
        AfMatrizSubClase matriz = requireMatriz(subClaseId);
        if (matriz.getCuentaActivoId() == null || matriz.getCuentaBajaId() == null
                || matriz.getCuentaResVentaId() == null) {
            throw matrizIncompleta();
        }
        return matriz;
    }

    private void requireCuentasDevengo(AfMatrizSubClase matriz) {
        if (cuentaGastoSeguro(matriz) == null || cuentaPasivoSeguro(matriz) == null) {
            throw matrizIncompleta();
        }
    }

    private AfMatrizSubClase requireMatrizAlta(Long subClaseId) {
        AfMatrizSubClase matriz = requireMatriz(subClaseId);
        if (matriz.getCuentaActivoId() == null || cuentaCreditoAlta(matriz) == null) {
            throw matrizIncompleta();
        }
        return matriz;
    }

    private Long cuentaGastoSeguro(AfMatrizSubClase matriz) {
        return matriz.getCuentaGastoSeguroId() != null
                ? matriz.getCuentaGastoSeguroId()
                : matriz.getCuentaGastoDepId();
    }

    private Long cuentaPasivoSeguro(AfMatrizSubClase matriz) {
        return matriz.getCuentaPasivoSeguroId() != null
                ? matriz.getCuentaPasivoSeguroId()
                : matriz.getCuentaActivoId();
    }

    private Long cuentaCreditoAlta(AfMatrizSubClase matriz) {
        if (matriz.getCuentaProveedorTransitoriaId() != null) {
            return matriz.getCuentaProveedorTransitoriaId();
        }
        return matriz.getCuentaBajaId();
    }

    private Long cuentaCreditoCapitalizacion(AfMatrizSubClase matriz) {
        if (matriz.getCuentaCapitalizacionId() != null) {
            return matriz.getCuentaCapitalizacionId();
        }
        return cuentaCreditoAlta(matriz);
    }

    private AfMatrizSubClase requireMatriz(Long subClaseId) {
        return matrizRepository.findByAfSubClaseId(subClaseId)
                .orElseThrow(() -> matrizIncompleta());
    }

    private AfMatrizSubClase resolveMatrizParaPoliza(Long polizaId) {
        List<AfPolizaActivo> activos = polizaActivoRepository.findByAfPolizaSeguroId(polizaId);
        if (activos.isEmpty()) {
            throw new BusinessException(
                    "La póliza no tiene activos asociados para resolver la matriz contable",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.MATRIZ_INCOMPLETA_INTEGRACION);
        }
        AfMaestro maestro = maestroRepository.findById(activos.get(0).getAfMaestroId())
                .orElseThrow(() -> new ResourceNotFoundException("Activo", activos.get(0).getAfMaestroId()));
        AfMatrizSubClase matriz = requireMatriz(maestro.getAfSubClaseId());
        requireCuentasDevengo(matriz);
        return matriz;
    }

    private BusinessException matrizIncompleta() {
        return new BusinessException(
                "Matriz contable incompleta para la integración",
                HttpStatus.BAD_REQUEST,
                ActivosErrorCodes.MATRIZ_INCOMPLETA_INTEGRACION);
    }

    private void validarMontoPositivo(BigDecimal monto) {
        if (monto == null || monto.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException(
                    "El monto a contabilizar debe ser mayor a cero",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.MONTO_CERO_NO_CONTABILIZABLE);
        }
    }

    private AsientoDetalleRequest detalle(Long cuentaId, Long centroCostoId, BigDecimal debe, BigDecimal haber,
                                          String glosaDetalle, String referencia) {
        return AsientoDetalleRequest.builder()
                .planContableDetId(cuentaId)
                .centrosCostoId(centroCostoId)
                .debe(debe.setScale(4, RoundingMode.HALF_UP))
                .haber(haber.setScale(4, RoundingMode.HALF_UP))
                .glosaDetalle(glosaDetalle)
                .referencia(referencia)
                .build();
    }

    private LocalDate fechaPeriodo(Integer anio, Integer mes) {
        return LocalDate.of(anio, mes, 1).withDayOfMonth(
                LocalDate.of(anio, mes, 1).lengthOfMonth());
    }

    private void registrarHistorialContable(Long maestroId, String tipo, Long asientoId, String correlacion) {
        historialRegistroService.registrar(
                maestroId,
                tipo,
                "Asiento contable id=" + asientoId,
                null,
                correlacion,
                "AF_CONTABILIDAD");
    }

    private static String correlacionDepreciacion(AfCalculoCntbl c) {
        return "AF|MAESTRO=" + c.getAfMaestroId() + "|PER=" + c.getAnio() + "-" + c.getMes() + "|CALC=" + c.getId();
    }

    private static String correlacionDevengo(AfPrimaDevengo d) {
        return "AF|POLIZA=" + d.getAfPolizaSeguroId() + "|PER=" + d.getAnio() + "-" + d.getMes() + "|DEV=" + d.getId();
    }

    private static String correlacionVenta(AfVenta v) {
        return "AF|MAESTRO=" + v.getAfMaestroId() + "|VENTA=" + v.getId();
    }

    private static String correlacionValuacion(AfValuacion v) {
        return "AF|MAESTRO=" + v.getAfMaestroId() + "|VAL=" + v.getId();
    }

    private static String correlacionAlta(AfMaestro m) {
        return "AF|MAESTRO=" + m.getId() + "|ALTA";
    }

    private static String correlacionAdaptacion(AfAdaptacion a) {
        return "AF|MAESTRO=" + a.getAfMaestroId() + "|ADP=" + a.getId();
    }

    private static String correlacionBaja(AfMaestro m) {
        return "AF|MAESTRO=" + m.getId() + "|BAJA";
    }

    private BigDecimal obtenerValorNetoActivo(Long maestroId, BigDecimal valorAdquisicion) {
        return calculoRepository.obtenerUltimaDepreciacion(maestroId)
                .map(AfCalculoCntbl::getValorNeto)
                .orElse(valorAdquisicion);
    }

    private List<AsientoDetalleRequest> construirDetallesDepreciacion(
            AfMaestro activo, AfMatrizSubClase matriz, BigDecimal monto, String correlacion) {
        List<AfMaestroCcDistrib> distrib = maestroCcDistribRepository.findByAfMaestroIdOrderByIdAsc(activo.getId());
        if (distrib.isEmpty()) {
            return List.of(
                    detalle(matriz.getCuentaGastoDepId(), matriz.getCentroCostoId(), monto, BigDecimal.ZERO,
                            "Depreciación período", correlacion),
                    detalle(matriz.getCuentaDepAcumId(), matriz.getCentroCostoId(), BigDecimal.ZERO, monto,
                            "Depreciación acumulada", correlacion));
        }
        List<AsientoDetalleRequest> detalles = new ArrayList<>();
        BigDecimal asignado = BigDecimal.ZERO;
        for (int i = 0; i < distrib.size(); i++) {
            AfMaestroCcDistrib d = distrib.get(i);
            BigDecimal parte = (i == distrib.size() - 1)
                    ? monto.subtract(asignado)
                    : monto.multiply(d.getPorcentaje()).divide(new BigDecimal("100"), 4, RoundingMode.HALF_UP);
            asignado = asignado.add(parte);
            detalles.add(detalle(matriz.getCuentaGastoDepId(), d.getCentroCostoId(), parte, BigDecimal.ZERO,
                    "Depreciación período", correlacion));
            detalles.add(detalle(matriz.getCuentaDepAcumId(), d.getCentroCostoId(), BigDecimal.ZERO, parte,
                    "Depreciación acumulada", correlacion));
        }
        return detalles;
    }
}
