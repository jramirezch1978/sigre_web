package pe.restaurant.ventas.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.ventas.client.ContabilidadGenerarAsientoClient;
import pe.restaurant.ventas.client.CoreMaestrosClient;
import pe.restaurant.ventas.client.FinanzasClient;
import pe.restaurant.ventas.client.dto.CntasCobrarAsientoRequest;
import pe.restaurant.ventas.client.dto.CntasCobrarDetAsientoRequest;
import pe.restaurant.ventas.client.dto.LiquidacionDTO;
import pe.restaurant.ventas.client.dto.SolicitudGiroDTO;
import pe.restaurant.ventas.dto.request.CuentaCobrarDetraccionRequest;
import pe.restaurant.ventas.dto.request.CuentaCobrarDirectoRequest;
import pe.restaurant.ventas.dto.request.CuentaCobrarNotaCreditoRequest;
import pe.restaurant.ventas.dto.request.DetImpuestoRequest;
import pe.restaurant.ventas.dto.response.DetImpuestoResponse;
import pe.restaurant.ventas.dto.response.PendientesCobrarResponse;
import pe.restaurant.ventas.dto.response.PendientesCobrarSimpleResponse;
import pe.restaurant.ventas.entity.CuentaCobrar;
import pe.restaurant.ventas.entity.CuentaCobrarDet;
import pe.restaurant.ventas.entity.EntidadCreditosCxc;
import pe.restaurant.ventas.entity.ServiciosCxC;
import pe.restaurant.ventas.repository.CuentaCobrarDetRepository;
import pe.restaurant.ventas.repository.CuentaCobrarRepository;
import pe.restaurant.ventas.repository.EntidadCreditosCxcRepository;
import pe.restaurant.ventas.repository.ServiciosCxCRepository;
import pe.restaurant.ventas.service.VentasErrorCodes;
import pe.restaurant.ventas.support.CuentaCobrarCabeceraValidator;
import pe.restaurant.ventas.support.CuentaCobrarReferencias;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Service para gestión de Cuentas por Cobrar
 * Implementa toda la lógica de negocio según contrato
 */
@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class CuentaCobrarService {

    /** Movimientos generados por backend (ej. anulación) usan el mismo código que aplicación/canje CF004 si existe en catálogo. */
    private static final String CONCEPTO_FINANCIERO_MOVIMIENTO_SISTEMA = "CF004";
    
    // Constantes descriptivas
    private static final String MONEDA_SOLES = "PEN";
    private static final String MONEDA_DOLARES = "USD";
    private static final String CONCEPTO_DIRECTO = "FI-108";
    private static final String CONCEPTO_DETRACCION = "FI-098";
    private static final String DOC_TIPO_DTRC = "DTRC";
    private static final String DOC_TIPO_NCC = "NCC";
    private static final BigDecimal DETRACCION_MONTO_MINIMO = new BigDecimal("700");
    private static final BigDecimal DETRACCION_TASA_DEFAULT = new BigDecimal("0.12");

    private final CuentaCobrarRepository cuentaCobrarRepository;
    private final CuentaCobrarDetRepository cuentaCobrarDetRepository;
    private final CntasCobrarDetImpService cntasCobrarDetImpService;
    private final ContabilidadGenerarAsientoClient contabilidadClient;
    private final CoreMaestrosClient coreMaestrosClient;
    private final FinanzasClient finanzasClient;
    private final EntidadCreditosCxcRepository entidadCreditosCxcRepository;
    private final ServiciosCxCRepository serviciosCxCRepository;
    private final CuentaCobrarCabeceraValidator cabeceraValidator;

    /**
     * Listar cuentas por cobrar con filtros y paginación
     */
    public Page<CuentaCobrar> findAllWithFilters(
            Long sucursalId,
            Long clienteId,
            Long docTipoId,
            String flagEstado,
            LocalDate fechaVencimientoDesde,
            LocalDate fechaVencimientoHasta,
            Pageable pageable) {

        log.info("Buscando cuentas por cobrar con filtros: sucursal={}, cliente={}, docTipo={}, flagEstado={}",
                sucursalId, clienteId, docTipoId, flagEstado);

        return cuentaCobrarRepository.findAllWithFilters(
                sucursalId, clienteId, docTipoId, flagEstado, fechaVencimientoDesde,
                fechaVencimientoHasta, pageable);
    }

    /**
     * Obtener cuenta por cobrar con sus movimientos
     */
    public CuentaCobrar findByIdWithMovimientos(Long id) {
        log.info("Buscando cuenta por cobrar con movimientos: {}", id);

        return cuentaCobrarRepository.findByIdWithMovimientos(id)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Cuenta por cobrar", id));
    }

    /**
     * Crear cuenta por cobrar con movimientos iniciales
     */
    @Transactional
    public CuentaCobrar create(CuentaCobrar cuentaCobrar, List<CuentaCobrarDet> movimientos, Long userId) {
        return create(cuentaCobrar, movimientos, null, userId);
    }

    /**
     * Crear cuenta por cobrar con movimientos iniciales e impuestos por movimiento.
     */
    @Transactional
    public CuentaCobrar create(CuentaCobrar cuentaCobrar, List<CuentaCobrarDet> movimientos,
                               List<List<DetImpuestoRequest>> impuestosPorMovimiento, Long userId) {
        log.info("Creando cuenta por cobrar: cliente={}, docTipo={}, serie={}, numero={}",
                cuentaCobrar.getClienteId(), cuentaCobrar.getDocTipoId(),
                cuentaCobrar.getSerie(), cuentaCobrar.getNumero());

        // Validaciones de negocio
        validarCreacion(cuentaCobrar);

        // Configurar auditoría
        cuentaCobrar.setCreatedBy(userId);
        cuentaCobrar.setFlagEstado("1");

        // Calcular totales si no vienen
        if (cuentaCobrar.getTotal() == null) {
            cuentaCobrar.setTotal(calcularTotalMovimientos(movimientos));
        }
        if (cuentaCobrar.getSaldo() == null) {
            cuentaCobrar.setSaldo(cuentaCobrar.getTotal());
        }

        // Calcular tasa de cambio
        if (cuentaCobrar.getTasaCambio() == null) {
            cuentaCobrar.setTasaCambio(obtenerTasaCambio(cuentaCobrar.getFechaEmision(), cuentaCobrar.getMonedaId()));
        }

        // Validar que el saldo no sea negativo
        if (cuentaCobrar.getSaldo().compareTo(BigDecimal.ZERO) < 0) {
            throw new BusinessException("El saldo no puede ser negativo", "VEN-VALIDATION");
        }

        // Guardar cabecera
        CuentaCobrar saved = cuentaCobrarRepository.save(cuentaCobrar);

        // Guardar movimientos
        List<CuentaCobrarDet> savedMovimientos = new ArrayList<>();
        if (movimientos != null && !movimientos.isEmpty()) {
            for (int i = 0; i < movimientos.size(); i++) {
                CuentaCobrarDet movimiento = movimientos.get(i);
                validarMovimiento(saved, movimiento);
                movimiento.setCuentaCobrar(saved);
                movimiento.setCntasCobrarId(saved.getId());
                movimiento.setCreatedBy(userId);
                movimiento.setFlagEstado("1");
                CuentaCobrarDet savedDet = cuentaCobrarDetRepository.save(movimiento);
                List<DetImpuestoRequest> impuestos = impuestosPorMovimiento != null && i < impuestosPorMovimiento.size()
                        ? impuestosPorMovimiento.get(i)
                        : null;
                cntasCobrarDetImpService.guardarImpuestos(savedDet, impuestos);
                savedMovimientos.add(savedDet);
            }
        }

        // Actualizar estado según saldo
        actualizarEstadoPorSaldo(saved);

        // Generar asiento contable (cuando aplique) y vincularlo a cntas_cobrar
        if (saved.getCntblAsientoId() == null) {
            Long asientoId = generarAsientoRegistroCntasCobrar(saved, savedMovimientos);
            if (asientoId != null) {
                saved.setCntblAsientoId(asientoId);
            }
        }

        saved = cuentaCobrarRepository.save(saved);

        log.info("Cuenta por cobrar creada exitosamente: ID={}", saved.getId());
        return saved;
    }

    /**
     * Actualizar cuenta por cobrar
     */
    @Transactional
    public CuentaCobrar update(Long id, CuentaCobrar cuentaCobrar, Long userId) {
        log.info("Actualizando cuenta por cobrar: {}", id);

        CuentaCobrar existing = cuentaCobrarRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Cuenta por cobrar", id));

        // Validaciones de negocio
        validarActualizacion(existing, cuentaCobrar);

        // Actualizar campos permitidos
        existing.setSucursalId(cuentaCobrar.getSucursalId());
        existing.setClienteId(cuentaCobrar.getClienteId());
        existing.setDocTipoId(cuentaCobrar.getDocTipoId());
        existing.setSerie(cuentaCobrar.getSerie());
        existing.setNumero(cuentaCobrar.getNumero());
        existing.setFechaEmision(cuentaCobrar.getFechaEmision());
        existing.setFechaVencimiento(cuentaCobrar.getFechaVencimiento());
        existing.setMonedaId(cuentaCobrar.getMonedaId());
        existing.setTotal(cuentaCobrar.getTotal());
        existing.setSaldo(cuentaCobrar.getSaldo());
        existing.setAno(cuentaCobrar.getAno());
        existing.setMes(cuentaCobrar.getMes());
        existing.setCntblLibroId(cuentaCobrar.getCntblLibroId());
        existing.setUpdatedBy(userId);

        // Validar que el saldo no sea negativo
        if (existing.getSaldo().compareTo(BigDecimal.ZERO) < 0) {
            throw new BusinessException("El saldo no puede ser negativo", "VEN-VALIDATION");
        }

        // Actualizar estado según saldo
        actualizarEstadoPorSaldo(existing);

        CuentaCobrar saved = cuentaCobrarRepository.save(existing);
        log.info("Cuenta por cobrar actualizada exitosamente: ID={}", saved.getId());
        return saved;
    }

    /**
     * Activar cuenta por cobrar
     */
    @Transactional
    public CuentaCobrar activar(Long id, Long userId) {
        log.info("Activando cuenta por cobrar: {}", id);

        CuentaCobrar cuentaCobrar = cuentaCobrarRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Cuenta por cobrar", id));

        cuentaCobrar.setFlagEstado("1");
        cuentaCobrar.setUpdatedBy(userId);

        return cuentaCobrarRepository.save(cuentaCobrar);
    }

    /**
     * Desactivar cuenta por cobrar
     */
    @Transactional
    public CuentaCobrar desactivar(Long id, Long userId) {
        log.info("Desactivando cuenta por cobrar: {}", id);

        CuentaCobrar cuentaCobrar = cuentaCobrarRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Cuenta por cobrar", id));

        // Validar que no tenga abonos aplicados
        if (cuentaCobrarRepository.existsAbonosAplicadosById(id)) {
            throw new BusinessException(
                    "No se puede desactivar cuenta con abonos aplicados", "VEN-STATE");
        }

        cuentaCobrar.setFlagEstado("0");
        cuentaCobrar.setUpdatedBy(userId);

        return cuentaCobrarRepository.save(cuentaCobrar);
    }

    /**
     * Eliminar cuenta por cobrar (baja lógica)
     */
    @Transactional
    public void delete(Long id, Long userId) {
        log.info("Eliminando cuenta por cobrar: {}", id);

        CuentaCobrar cuentaCobrar = cuentaCobrarRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Cuenta por cobrar", id));

        // Validar que no tenga abonos aplicados
        if (cuentaCobrarRepository.existsAbonosAplicadosById(id)) {
            throw new BusinessException(
                    "No se puede eliminar cuenta con abonos aplicados", "VEN-STATE");
        }

        // Baja lógica de movimientos
        cuentaCobrarDetRepository.deleteMovimientosByCuentaCobrarId(id, userId);

        // Baja lógica de cabecera
        cuentaCobrar.setFlagEstado("0");
        cuentaCobrar.setUpdatedBy(userId);
        cuentaCobrarRepository.save(cuentaCobrar);

        log.info("Cuenta por cobrar eliminada exitosamente: ID={}", id);
    }

    /**
     * Registrar movimiento en cuenta por cobrar
     */
    @Transactional
    public CuentaCobrar registrarMovimiento(Long id, CuentaCobrarDet movimiento, Long userId) {
        log.info("Registrando movimiento en cuenta por cobrar: {}, tipo={}, monto={}",
                id, movimiento.getTipoMov(), movimiento.getMonto());

        CuentaCobrar cuentaCobrar = cuentaCobrarRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Cuenta por cobrar", id));

        // Validar movimiento
        validarMovimiento(cuentaCobrar, movimiento);

        // Calcular nuevo saldo
        BigDecimal nuevoSaldo = calcularNuevoSaldo(cuentaCobrar.getSaldo(), movimiento);

        // Validar que el saldo no sea negativo
        if (nuevoSaldo.compareTo(BigDecimal.ZERO) < 0) {
            throw new BusinessException(
                    "El movimiento generaría saldo negativo", "VEN-VALIDATION");
        }

        // Guardar movimiento
        movimiento.setCuentaCobrar(cuentaCobrar);
        movimiento.setCntasCobrarId(id);
        movimiento.setCreatedBy(userId);
        movimiento.setFlagEstado("1");
        cuentaCobrarDetRepository.save(movimiento);

        // Actualizar saldo y estado
        cuentaCobrar.setSaldo(nuevoSaldo);
        cuentaCobrar.setUpdatedBy(userId);
        actualizarEstadoPorSaldo(cuentaCobrar);
        cuentaCobrarRepository.save(cuentaCobrar);

        log.info("Movimiento registrado exitosamente: nuevo saldo={}", nuevoSaldo);
        return cuentaCobrar;
    }

    /**
     * Anular cuenta por cobrar
     */
    @Transactional
    public CuentaCobrar anular(Long id, String motivo, Long userId) {
        log.info("Anulando cuenta por cobrar: {}, motivo={}", id, motivo);

        CuentaCobrar cuentaCobrar = cuentaCobrarRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Cuenta por cobrar", id));

        // Validar que no tenga abonos aplicados
        if (cuentaCobrarRepository.existsAbonosAplicadosById(id)) {
            throw new BusinessException(
                    "No se puede anular cuenta con abonos aplicados", "VEN-STATE");
        }

        if ("0".equals(cuentaCobrar.getFlagEstado())) {
            throw new BusinessException(
                    "La cuenta ya está anulada", "VEN-STATE");
        }

        cuentaCobrar.setFlagEstado("0");
        cuentaCobrar.setSaldo(BigDecimal.ZERO);
        cuentaCobrar.setUpdatedBy(userId);

        // Registrar movimiento de anulación si hay motivo
        if (motivo != null && !motivo.trim().isEmpty()) {
            Long conceptoSistema = cuentaCobrarRepository
                    .findConceptoFinancieroIdByCodigo(CONCEPTO_FINANCIERO_MOVIMIENTO_SISTEMA)
                    .orElseThrow(() -> new BusinessException(
                            "No existe concepto financiero " + CONCEPTO_FINANCIERO_MOVIMIENTO_SISTEMA
                                    + " activo en catálogo; requerido para registrar anulación",
                            "VEN-CONFIG"));
            CuentaCobrarDet movimientoAnulacion = new CuentaCobrarDet();
            movimientoAnulacion.setCuentaCobrar(cuentaCobrar);
            movimientoAnulacion.setCntasCobrarId(id);
            movimientoAnulacion.setFechaMov(LocalDate.now());
            movimientoAnulacion.setTipoMov(CuentaCobrarDet.TipoMovimiento.AJUSTE);
            movimientoAnulacion.setMonto(cuentaCobrar.getTotal());
            movimientoAnulacion.setReferencia("ANULACIÓN: " + motivo);
            movimientoAnulacion.setConceptoFinancieroId(conceptoSistema);
            movimientoAnulacion.setCreatedBy(userId);
            movimientoAnulacion.setFlagEstado("1");
            cuentaCobrarDetRepository.save(movimientoAnulacion);
        }

        CuentaCobrar saved = cuentaCobrarRepository.save(cuentaCobrar);
        log.info("Cuenta por cobrar anulada exitosamente: ID={}", saved.getId());
        return saved;
    }

    /**
     * Obtener movimientos de una cuenta por cobrar
     */
    public List<CuentaCobrarDet> findMovimientosByCuentaCobrarId(Long cuentaCobrarId) {
        log.info("Buscando movimientos de cuenta por cobrar: {}", cuentaCobrarId);

        // Validar que exista la cuenta
        if (!cuentaCobrarRepository.existsById(cuentaCobrarId)) {
            throw new ResourceNotFoundException(
                    "Cuenta por cobrar", cuentaCobrarId);
        }

        return cuentaCobrarDetRepository.findWithCuentaCobrarByCuentaCobrarIdAndFlagEstadoOrderByFechaMovDesc(
                cuentaCobrarId, "1");
    }

    /**
     * Documento por cobrar directo — ingresos no originados en venta POS/OV (HU-FIN-OP-CC-003).
     */
    @Transactional
    public CuentaCobrar crearDocumentoDirecto(CuentaCobrarDirectoRequest request, Long userId) {
        validarLimiteCredito(request.getClienteId(), request.getMonedaId(), request.getMonto());

        ServiciosCxC servicio = null;
        if (request.getServicioCxcId() != null) {
            servicio = serviciosCxCRepository.findById(request.getServicioCxcId())
                    .filter(s -> "1".equals(s.getFlagEstado()))
                    .orElseThrow(() -> new BusinessException(
                            "Servicio CxC inexistente o inactivo", HttpStatus.UNPROCESSABLE_ENTITY,
                            VentasErrorCodes.CXC_SERVICIO_INVALIDO));
        }

        Long conceptoId = request.getConceptoFinancieroId();
        if (conceptoId == null) {
            conceptoId = cuentaCobrarRepository.findConceptoFinancieroIdByCodigo(CONCEPTO_DIRECTO)
                    .orElseThrow(() -> new BusinessException(
                            "No existe concepto financiero " + CONCEPTO_DIRECTO,
                            HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CXC_DOC_TIPO_NO_CONFIGURADO));
        }

        CuentaCobrar cab = CuentaCobrar.builder()
                .sucursalId(request.getSucursalId())
                .clienteId(request.getClienteId())
                .docTipoId(request.getDocTipoId())
                .serie(request.getSerie())
                .numero(request.getNumero())
                .fechaEmision(request.getFechaEmision())
                .fechaVencimiento(request.getFechaVencimiento())
                .monedaId(request.getMonedaId())
                .total(request.getMonto())
                .saldo(request.getMonto())
                .ano(request.getAno())
                .mes(request.getMes())
                .cntblLibroId(request.getCntblLibroId())
                .build();

        String descripcion = request.getDescripcion();
        if (descripcion == null && servicio != null) {
            descripcion = servicio.getDescServicio();
        }

        CuentaCobrarDet cargo = CuentaCobrarDet.builder()
                .fechaMov(request.getFechaEmision())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                .monto(request.getMonto())
                .conceptoFinancieroId(conceptoId)
                .referencia(CuentaCobrarReferencias.directo(
                        request.getServicioCxcId(), descripcion))
                .build();

        return create(cab, List.of(cargo), userId);
    }

    /**
     * Genera detracción por cobrar (doc_tipo DTRC) desde una CxC de factura cuando el total supera el umbral.
     */
    @Transactional
    public CuentaCobrar generarDetraccionPorCobrar(Long cuentaOrigenId, CuentaCobrarDetraccionRequest request, Long userId) {
        CuentaCobrar origen = cuentaCobrarRepository.findById(cuentaOrigenId)
                .orElseThrow(() -> new ResourceNotFoundException("Cuenta por cobrar", cuentaOrigenId));

        if ("0".equals(origen.getFlagEstado())) {
            throw new BusinessException("La cuenta origen está anulada", HttpStatus.CONFLICT, VentasErrorCodes.CXC_VALIDATION);
        }
        if (origen.getTotal().compareTo(DETRACCION_MONTO_MINIMO) < 0) {
            throw new BusinessException(
                    "El documento origen no alcanza el monto mínimo para detracción (S/ 700)",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CXC_DETRACCION_MONTO_MINIMO);
        }
        if (cuentaCobrarRepository.existsDetraccionPorOrigen(cuentaOrigenId)) {
            throw new BusinessException(
                    "Ya existe una detracción registrada para este documento",
                    HttpStatus.CONFLICT, VentasErrorCodes.CXC_DETRACCION_YA_EXISTE);
        }

        BigDecimal tasa = request != null && request.getTasa() != null
                ? request.getTasa() : DETRACCION_TASA_DEFAULT;
        if (tasa.compareTo(BigDecimal.ZERO) <= 0 || tasa.compareTo(BigDecimal.ONE) > 0) {
            throw new BusinessException("Tasa de detracción inválida", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CXC_VALIDATION);
        }

        BigDecimal importeDetraccion = origen.getTotal().multiply(tasa).setScale(4, RoundingMode.HALF_UP);
        if (importeDetraccion.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException("Importe de detracción inválido", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CXC_VALIDATION);
        }

        Long docTipoDtrc = cuentaCobrarRepository.findDocTipoIdByCodigo(DOC_TIPO_DTRC)
                .orElseThrow(() -> new BusinessException(
                        "Tipo de documento " + DOC_TIPO_DTRC + " no configurado",
                        HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CXC_DOC_TIPO_NO_CONFIGURADO));

        Long conceptoId = request != null && request.getConceptoFinancieroId() != null
                ? request.getConceptoFinancieroId()
                : cuentaCobrarRepository.findConceptoFinancieroIdByCodigo(CONCEPTO_DETRACCION)
                        .orElseThrow(() -> new BusinessException(
                                "No existe concepto financiero " + CONCEPTO_DETRACCION,
                                HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CXC_DOC_TIPO_NO_CONFIGURADO));

        String serie = request != null && request.getSerie() != null ? request.getSerie() : "DTR";
        String numero = request != null && request.getNumero() != null
                ? request.getNumero()
                : String.format("%08d", cuentaOrigenId);

        CuentaCobrar detraccion = CuentaCobrar.builder()
                .sucursalId(origen.getSucursalId())
                .clienteId(origen.getClienteId())
                .docTipoId(docTipoDtrc)
                .serie(serie)
                .numero(numero)
                .fechaEmision(LocalDate.now())
                .fechaVencimiento(origen.getFechaVencimiento())
                .monedaId(origen.getMonedaId())
                .total(importeDetraccion)
                .saldo(importeDetraccion)
                .build();
        cabeceraValidator.copiarPeriodoContable(detraccion, origen);

        CuentaCobrarDet cargo = CuentaCobrarDet.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                .monto(importeDetraccion)
                .conceptoFinancieroId(conceptoId)
                .referencia(CuentaCobrarReferencias.detraccion(cuentaOrigenId, tasa.toPlainString()))
                .build();

        return create(detraccion, List.of(cargo), userId);
    }

    /**
     * Emite nota de crédito por cobrar (NCC) y aplica abono a la CxC origen.
     */
    @Transactional
    public CuentaCobrar crearNotaCreditoPorCobrar(CuentaCobrarNotaCreditoRequest request, Long userId) {
        CuentaCobrar origen = cuentaCobrarRepository.findById(request.getCuentaCobrarOrigenId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Cuenta por cobrar origen", request.getCuentaCobrarOrigenId()));

        if ("0".equals(origen.getFlagEstado())) {
            throw new BusinessException("La cuenta origen está anulada", HttpStatus.CONFLICT, VentasErrorCodes.CXC_VALIDATION);
        }
        if (origen.getSaldo().compareTo(request.getMonto()) < 0) {
            throw new BusinessException(
                    "El monto de la nota de crédito supera el saldo pendiente del documento origen",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CXC_NC_SALDO_INSUFICIENTE);
        }

        Long docTipoNcc = cuentaCobrarRepository.findDocTipoIdByCodigo(DOC_TIPO_NCC)
                .orElseThrow(() -> new BusinessException(
                        "Tipo de documento " + DOC_TIPO_NCC + " no configurado",
                        HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CXC_DOC_TIPO_NO_CONFIGURADO));

        CuentaCobrar nc = CuentaCobrar.builder()
                .sucursalId(origen.getSucursalId())
                .clienteId(origen.getClienteId())
                .docTipoId(docTipoNcc)
                .serie(request.getSerie())
                .numero(request.getNumero())
                .fechaEmision(request.getFechaEmision())
                .fechaVencimiento(origen.getFechaVencimiento())
                .monedaId(origen.getMonedaId())
                .total(request.getMonto())
                .saldo(request.getMonto())
                .build();
        cabeceraValidator.copiarPeriodoContable(nc, origen);

        CuentaCobrarDet cargoNc = CuentaCobrarDet.builder()
                .fechaMov(request.getFechaEmision())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                .monto(request.getMonto())
                .conceptoFinancieroId(request.getConceptoFinancieroId())
                .referencia(CuentaCobrarReferencias.notaCredito(origen.getId(), request.getMotivo()))
                .build();

        CuentaCobrar ncGuardada = create(nc, List.of(cargoNc), userId);

        CuentaCobrarDet abonoOrigen = CuentaCobrarDet.builder()
                .fechaMov(request.getFechaEmision())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.ABONO)
                .monto(request.getMonto())
                .conceptoFinancieroId(request.getConceptoFinancieroId())
                .referencia("ABONO NC " + request.getSerie() + "-" + request.getNumero())
                .build();
        registrarMovimiento(origen.getId(), abonoOrigen, userId);

        return ncGuardada;
    }

    // ==================== MÉTODOS PRIVADOS ====================

    private void validarCreacion(CuentaCobrar cuentaCobrar) {
        // Validar FKs
        if (!cuentaCobrarRepository.existsSucursalActivaById(cuentaCobrar.getSucursalId())) {
            throw new BusinessException("Sucursal inexistente o inactiva", "VEN-FK");
        }
        if (!cuentaCobrarRepository.existsClienteActivoById(cuentaCobrar.getClienteId())) {
            throw new BusinessException("Cliente inexistente o inactivo", "VEN-FK");
        }
        if (!cuentaCobrarRepository.existsDocTipoActivoById(cuentaCobrar.getDocTipoId())) {
            throw new BusinessException("Tipo de documento inexistente o inactivo", "VEN-FK");
        }
        if (cuentaCobrar.getMonedaId() != null && 
            !cuentaCobrarRepository.existsMonedaActivaById(cuentaCobrar.getMonedaId())) {
            throw new BusinessException("Moneda inexistente o inactiva", "VEN-FK");
        }
        cabeceraValidator.validar(cuentaCobrar.getAno(), cuentaCobrar.getMes(), cuentaCobrar.getCntblLibroId());

        // Validar unicidad
        if (cuentaCobrarRepository.existsByClienteIdAndDocTipoIdAndSerieAndNumeroAndFlagEstado(
                cuentaCobrar.getClienteId(), cuentaCobrar.getDocTipoId(),
                cuentaCobrar.getSerie(), cuentaCobrar.getNumero(), "1")) {
            throw new BusinessException(
                    "Ya existe una cuenta por cobrar con la misma clave natural", "VEN-DUPLICATE");
        }
    }

    private void validarActualizacion(CuentaCobrar existing, CuentaCobrar cuentaCobrar) {
        if ("0".equals(existing.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede modificar cuenta anulada", "VEN-STATE");
        }

        // Validar FKs
        if (!cuentaCobrarRepository.existsSucursalActivaById(cuentaCobrar.getSucursalId())) {
            throw new BusinessException("Sucursal inexistente o inactiva", "VEN-FK");
        }
        if (!cuentaCobrarRepository.existsClienteActivoById(cuentaCobrar.getClienteId())) {
            throw new BusinessException("Cliente inexistente o inactivo", "VEN-FK");
        }
        if (!cuentaCobrarRepository.existsDocTipoActivoById(cuentaCobrar.getDocTipoId())) {
            throw new BusinessException("Tipo de documento inexistente o inactivo", "VEN-FK");
        }
        if (cuentaCobrar.getMonedaId() != null && 
            !cuentaCobrarRepository.existsMonedaActivaById(cuentaCobrar.getMonedaId())) {
            throw new BusinessException("Moneda inexistente o inactiva", "VEN-FK");
        }
        cabeceraValidator.validar(cuentaCobrar.getAno(), cuentaCobrar.getMes(), cuentaCobrar.getCntblLibroId());

        // Validar unicidad (si cambia la clave natural)
        if (!existing.getClienteId().equals(cuentaCobrar.getClienteId()) ||
            !existing.getDocTipoId().equals(cuentaCobrar.getDocTipoId()) ||
            !Objects.equals(existing.getSerie(), cuentaCobrar.getSerie()) ||
            !Objects.equals(existing.getNumero(), cuentaCobrar.getNumero())) {
            
            if (cuentaCobrarRepository.existsByClienteIdAndDocTipoIdAndSerieAndNumeroAndFlagEstado(
                    cuentaCobrar.getClienteId(), cuentaCobrar.getDocTipoId(),
                    cuentaCobrar.getSerie(), cuentaCobrar.getNumero(), "1")) {
                throw new BusinessException(
                        "Ya existe una cuenta por cobrar con la misma clave natural", "VEN-DUPLICATE");
            }
        }
    }

    private void validarMovimiento(CuentaCobrar cuentaCobrar, CuentaCobrarDet movimiento) {
        if (movimiento.getConceptoFinancieroId() == null) {
            throw new BusinessException("El concepto financiero es obligatorio", "VEN-VALIDATION");
        }
        if (!cuentaCobrarRepository.existsConceptoFinancieroActivoById(movimiento.getConceptoFinancieroId())) {
            throw new BusinessException("Concepto financiero inexistente o inactivo", "VEN-FK");
        }

        if ("0".equals(cuentaCobrar.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede registrar movimiento en cuenta anulada", "VEN-STATE");
        }

        if (cuentaCobrarDetRepository.existsMovimientoDuplicado(
                cuentaCobrar.getId(), movimiento.getFechaMov(),
                movimiento.getTipoMov(), movimiento.getMonto())) {
            throw new BusinessException(
                    "Ya existe un movimiento con las mismas características", "VEN-DUPLICATE");
        }
    }

    private void validarLimiteCredito(Long clienteId, Long monedaId, BigDecimal montoNuevo) {
        if (montoNuevo == null || montoNuevo.compareTo(BigDecimal.ZERO) <= 0) {
            return;
        }
        Optional<EntidadCreditosCxc> credito = entidadCreditosCxcRepository.findActiveByEntidadAndMoneda(clienteId, monedaId);
        if (credito.isEmpty() || credito.get().getLimiteCredito() == null) {
            return;
        }
        BigDecimal saldoActual = cuentaCobrarRepository.sumSaldoPendienteByCliente(clienteId, monedaId);
        BigDecimal proyectado = saldoActual.add(montoNuevo);
        if (proyectado.compareTo(credito.get().getLimiteCredito()) > 0) {
            throw new BusinessException(
                    "El monto excede el límite de crédito del cliente",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CXC_CREDITO_EXCEDIDO);
        }
    }

    private BigDecimal calcularTotalMovimientos(List<CuentaCobrarDet> movimientos) {
        return movimientos.stream()
                .filter(m -> m.getTipoMov() == CuentaCobrarDet.TipoMovimiento.CARGO)
                .map(CuentaCobrarDet::getMonto)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private BigDecimal calcularNuevoSaldo(BigDecimal saldoActual, CuentaCobrarDet movimiento) {
        switch (movimiento.getTipoMov()) {
            case CARGO:
                return saldoActual.add(movimiento.getMonto());
            case ABONO:
                return saldoActual.subtract(movimiento.getMonto());
            case AJUSTE:
                return movimiento.getMonto(); // Los ajustes definen el nuevo saldo directamente
            default:
                return saldoActual;
        }
    }

    private void actualizarEstadoPorSaldo(CuentaCobrar cuentaCobrar) {
        if (cuentaCobrar.getSaldo().compareTo(BigDecimal.ZERO) == 0) {
            cuentaCobrar.setFlagEstado("5");
        } else if (cuentaCobrar.getSaldo().compareTo(cuentaCobrar.getTotal()) < 0) {
            cuentaCobrar.setFlagEstado("4");
        } else {
            cuentaCobrar.setFlagEstado("1");
        }
    }

    /**
     * Genera asiento contable en ms-contabilidad para el registro de CxC (REGISTRO_CNTAS_COBRAR).
     *
     * <p>Regla: si contabilidad responde error, la creación de la CxC debe fallar para mantener
     * consistencia contable (transacción completa).</p>
     */
    private Long generarAsientoRegistroCntasCobrar(CuentaCobrar cab, List<CuentaCobrarDet> movimientos) {
        // Se genera con el documento (cabecera) y sus "movimientos" como detalles.
        if (movimientos == null || movimientos.isEmpty()) {
            // Si no hay detalle, contabilidad lo rechazará; no forzamos asiento.
            return null;
        }

        CntasCobrarAsientoRequest request = CntasCobrarAsientoRequest.builder()
                .id(cab.getId())
                .fechaEmision(cab.getFechaEmision() != null ? cab.getFechaEmision() : LocalDate.now())
                .sucursalId(cab.getSucursalId())
                .monedaId(cab.getMonedaId())
                .tasaCambio(cab.getTasaCambio() != null ? cab.getTasaCambio() : BigDecimal.ONE)
                .total(cab.getTotal())
                .saldo(cab.getSaldo())
                .clienteId(cab.getClienteId())
                .docTipoId(cab.getDocTipoId())
                .serie(cab.getSerie())
                .numero(cab.getNumero())
                .ano(cab.getAno())
                .mes(cab.getMes())
                .cntblLibroId(cab.getCntblLibroId())
                .glosa("Registro CxC ventas " + (cab.getSerie() != null ? cab.getSerie() : "") + "-" + (cab.getNumero() != null ? cab.getNumero() : ""))
                .detalles(toDetallesAsiento(movimientos))
                .build();

        try {
            var resp = contabilidadClient.generarRegistroCntasCobrar(request);
            if (resp == null || !resp.isSuccess() || resp.getData() == null) {
                throw new BusinessException("No se pudo generar asiento contable para la cuenta por cobrar",
                        HttpStatus.UNPROCESSABLE_ENTITY, "VEN-CONTABILIDAD");
            }
            return resp.getData().getAsientoId();
        } catch (feign.FeignException ex) {
            String url = ex.request() != null ? ex.request().url() : "unknown";
            log.error("Error Feign al conectar con ms-contabilidad. URL: {}, status: {}", url, ex.status());
            throw new BusinessException("No se pudo conectar con contabilidad para generar asiento [URL: " + url + "]",
                    HttpStatus.SERVICE_UNAVAILABLE, "SERVICE_UNAVAILABLE");
        }
    }

    private List<CntasCobrarDetAsientoRequest> toDetallesAsiento(List<CuentaCobrarDet> movimientos) {
        java.util.ArrayList<CntasCobrarDetAsientoRequest> out = new java.util.ArrayList<>();
        for (CuentaCobrarDet m : movimientos) {
            out.add(CntasCobrarDetAsientoRequest.builder()
                    .id(m.getId())
                    .conceptoFinancieroId(m.getConceptoFinancieroId())
                    .fechaMov(m.getFechaMov())
                    .tipoMov(m.getTipoMov() != null ? m.getTipoMov().name() : null)
                    .monto(m.getMonto())
                    .impuestos(toImpuestoRequests(cntasCobrarDetImpService.listarPorDetalle(m.getId())))
                    .referencia(m.getReferencia())
                    .glosa(m.getReferencia())
                    .build());
        }
        return out;
    }

    private List<DetImpuestoRequest> toImpuestoRequests(List<DetImpuestoResponse> impuestos) {
        if (impuestos == null || impuestos.isEmpty()) {
            return List.of();
        }
        return impuestos.stream()
                .map(r -> new DetImpuestoRequest(r.getTiposImpuestoId(), r.getImporte()))
                .toList();
    }

    // ==================== MÉTODOS DE PENDIENTES POR COBRAR ====================

    /**
     * Lista todos los documentos pendientes por cobrar agrupados por tipo.
     * Consulta cuentas por cobrar locales y obtiene liquidaciones/órdenes de giro desde ms-finanzas.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param clienteId ID de cliente (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Respuesta agrupada con listas por tipo y totales
     */
    public PendientesCobrarResponse listarPendientesPorCobrarAgrupado(
            Long sucursalId, Long clienteId, LocalDate fechaDesde, LocalDate fechaHasta) {
        
        log.info("Listando pendientes por cobrar agrupados - sucursal: {}, cliente: {}, fechas: {} - {}", 
                sucursalId, clienteId, fechaDesde, fechaHasta);

        List<CuentaCobrar> pendientes = cuentaCobrarRepository.findPendientesPorCobrar(
                sucursalId, clienteId, fechaDesde, fechaHasta);

        Long docTipoDtrc = cuentaCobrarRepository.findDocTipoIdByCodigo(DOC_TIPO_DTRC).orElse(null);
        Long docTipoNcc = cuentaCobrarRepository.findDocTipoIdByCodigo(DOC_TIPO_NCC).orElse(null);

        List<PendientesCobrarResponse.CuentaCobrarItem> cuentasNegocio = new ArrayList<>();
        List<PendientesCobrarResponse.CuentaCobrarItem> documentosDirecto = new ArrayList<>();
        List<PendientesCobrarResponse.NotaCreditoItem> notasCredito = new ArrayList<>();
        List<PendientesCobrarResponse.DetraccionItem> detraccionesItems = new ArrayList<>();

        for (CuentaCobrar c : pendientes) {
            Optional<String> ref = cuentaCobrarRepository.findPrimeraReferenciaMovimiento(c.getId());
            String referencia = ref.orElse("");

            if (esDetraccion(c, docTipoDtrc, referencia)) {
                detraccionesItems.add(mapearDetraccion(c, referencia));
            } else if (esNotaCredito(c, docTipoNcc, referencia)) {
                notasCredito.add(mapearNotaCredito(c, referencia));
            } else if (esDocumentoDirecto(c, referencia)) {
                documentosDirecto.add(mapearCuentaCobrarItem(c, true));
            } else {
                cuentasNegocio.add(mapearCuentaCobrarItem(c, false));
            }
        }

        List<LiquidacionDTO> liquidaciones = obtenerLiquidacionesDesdeFinanzas(sucursalId, clienteId, fechaDesde, fechaHasta);
        List<SolicitudGiroDTO> ordenesGiro = obtenerOrdenesGiroDesdeFinanzas(sucursalId, clienteId, fechaDesde, fechaHasta);

        List<PendientesCobrarResponse.LiquidacionItem> liquidacionesItems = mapearLiquidaciones(liquidaciones);
        List<PendientesCobrarResponse.OrdenGiroItem> ordenesGiroItems = mapearOrdenesGiro(ordenesGiro);

        PendientesCobrarResponse.Totales totales = calcularTotalesCobrar(
                cuentasNegocio, documentosDirecto, notasCredito, liquidacionesItems, ordenesGiroItems, detraccionesItems);

        return PendientesCobrarResponse.builder()
                .cuentasCobrar(cuentasNegocio)
                .documentosDirecto(documentosDirecto)
                .notasCreditoCobrar(notasCredito)
                .liquidaciones(liquidacionesItems)
                .ordenesGiro(ordenesGiroItems)
                .detraccionesCobrar(detraccionesItems)
                .totales(totales)
                .build();
    }

    /**
     * Lista todos los documentos pendientes por cobrar en formato simple unificado.
     * Combina todos los tipos de documentos en una lista plana.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param clienteId ID de cliente (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista simple unificada de pendientes
     */
    public PendientesCobrarSimpleResponse listarPendientesPorCobrarSimple(
            Long sucursalId, Long clienteId, LocalDate fechaDesde, LocalDate fechaHasta) {
        
        log.info("Listando pendientes por cobrar simple - sucursal: {}, cliente: {}, fechas: {} - {}", 
                sucursalId, clienteId, fechaDesde, fechaHasta);

        PendientesCobrarResponse agrupado = listarPendientesPorCobrarAgrupado(sucursalId, clienteId, fechaDesde, fechaHasta);
        List<PendientesCobrarSimpleResponse.PendienteCobrarItem> items = new ArrayList<>();

        agrupado.getCuentasCobrar().forEach(c ->
                items.add(toSimpleItem(PendientesCobrarSimpleResponse.TipoDocumentoCobrar.CUENTA_COBRAR, c)));
        agrupado.getDocumentosDirecto().forEach(c ->
                items.add(toSimpleItem(PendientesCobrarSimpleResponse.TipoDocumentoCobrar.DOCUMENTO_DIRECTO, c)));
        agrupado.getNotasCreditoCobrar().forEach(nc -> items.add(
                PendientesCobrarSimpleResponse.PendienteCobrarItem.builder()
                        .tipoDocumento(PendientesCobrarSimpleResponse.TipoDocumentoCobrar.NOTA_CREDITO)
                        .id(nc.getId())
                        .numero(nc.getSerie() + "-" + nc.getNumero())
                        .fecha(nc.getFechaEmision())
                        .cliente(nc.getClienteRazonSocial())
                        .total(nc.getTotal())
                        .saldo(nc.getSaldo())
                        .moneda(nc.getMonedaCodigo())
                        .observacion(nc.getMotivo())
                        .build()));
        agrupado.getDetraccionesCobrar().forEach(d -> items.add(
                PendientesCobrarSimpleResponse.PendienteCobrarItem.builder()
                        .tipoDocumento(PendientesCobrarSimpleResponse.TipoDocumentoCobrar.DETRACCION)
                        .id(d.getId())
                        .numero(d.getNroDetraccion())
                        .fecha(d.getFechaRegistro())
                        .cliente(d.getClienteRazonSocial())
                        .total(d.getImporte())
                        .saldo(d.getImporte())
                        .moneda(MONEDA_SOLES)
                        .observacion("Detracción origen CxC " + d.getCuentaCobrarOrigenId())
                        .build()));

        List<LiquidacionDTO> liquidaciones = obtenerLiquidacionesDesdeFinanzas(sucursalId, clienteId, fechaDesde, fechaHasta);
        items.addAll(mapearLiquidacionesSimple(liquidaciones));

        List<SolicitudGiroDTO> ordenesGiro = obtenerOrdenesGiroDesdeFinanzas(sucursalId, clienteId, fechaDesde, fechaHasta);
        items.addAll(mapearOrdenesGiroSimple(ordenesGiro));

        BigDecimal totalPendiente = items.stream()
                .map(PendientesCobrarSimpleResponse.PendienteCobrarItem::getSaldo)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return PendientesCobrarSimpleResponse.builder()
                .content(items)
                .totalPendiente(totalPendiente)
                .build();
    }

    // ==================== MÉTODOS AUXILIARES - COMUNICACIÓN CON MS-FINANZAS ====================

    /**
     * Obtiene liquidaciones con saldo positivo desde ms-finanzas vía Feign.
     * Maneja errores de comunicación retornando lista vacía.
     */
    private List<LiquidacionDTO> obtenerLiquidacionesDesdeFinanzas(
            Long sucursalId, Long clienteId, LocalDate fechaDesde, LocalDate fechaHasta) {
        try {
            return finanzasClient.obtenerLiquidacionesPendientesCobrar(sucursalId, clienteId, fechaDesde, fechaHasta);
        } catch (Exception e) {
            log.warn("Error al obtener liquidaciones desde ms-finanzas: {}", e.getMessage());
            return new ArrayList<>();
        }
    }

    private List<SolicitudGiroDTO> obtenerOrdenesGiroDesdeFinanzas(
            Long sucursalId, Long clienteId, LocalDate fechaDesde, LocalDate fechaHasta) {
        try {
            return finanzasClient.obtenerOrdenesGiroPendientesCobrar(sucursalId, clienteId, fechaDesde, fechaHasta);
        } catch (Exception e) {
            log.warn("Error al obtener órdenes de giro desde ms-finanzas: {}", e.getMessage());
            return new ArrayList<>();
        }
    }

    // ==================== MÉTODOS AUXILIARES DE MAPEO - VERSIÓN AGRUPADA ====================

    private boolean esDetraccion(CuentaCobrar c, Long docTipoDtrc, String referencia) {
        return (docTipoDtrc != null && docTipoDtrc.equals(c.getDocTipoId()))
                || CuentaCobrarReferencias.esDetraccion(referencia);
    }

    private boolean esNotaCredito(CuentaCobrar c, Long docTipoNcc, String referencia) {
        return (docTipoNcc != null && docTipoNcc.equals(c.getDocTipoId()))
                || CuentaCobrarReferencias.esNotaCredito(referencia);
    }

    private boolean esDocumentoDirecto(CuentaCobrar c, String referencia) {
        return CuentaCobrarReferencias.esDirecto(referencia);
    }

    private PendientesCobrarResponse.CuentaCobrarItem mapearCuentaCobrarItem(CuentaCobrar c, boolean esDirecto) {
        return PendientesCobrarResponse.CuentaCobrarItem.builder()
                .id(c.getId())
                .clienteId(c.getClienteId())
                .clienteRazonSocial(obtenerRazonSocialCliente(c.getClienteId()))
                .docTipoId(c.getDocTipoId())
                .docTipoNombre(obtenerNombreDocTipo(c.getDocTipoId()))
                .serie(c.getSerie())
                .numero(c.getNumero())
                .fechaEmision(c.getFechaEmision())
                .fechaVencimiento(c.getFechaVencimiento())
                .monedaCodigo(obtenerCodigoMoneda(c.getMonedaId()))
                .total(c.getTotal())
                .saldo(c.getSaldo())
                .esDirecto(esDirecto)
                .build();
    }

    private PendientesCobrarResponse.DetraccionItem mapearDetraccion(CuentaCobrar c, String referencia) {
        Long origenId = extraerValorReferencia(referencia, "origenId");
        BigDecimal tasa = extraerValorReferencia(referencia, "tasa") != null
                ? new BigDecimal(extraerValorReferencia(referencia, "tasa"))
                : DETRACCION_TASA_DEFAULT;
        return PendientesCobrarResponse.DetraccionItem.builder()
                .id(c.getId())
                .cuentaCobrarOrigenId(origenId)
                .nroDetraccion(c.getSerie() + "-" + c.getNumero())
                .fechaRegistro(c.getFechaEmision())
                .clienteId(c.getClienteId())
                .clienteRazonSocial(obtenerRazonSocialCliente(c.getClienteId()))
                .importe(c.getSaldo())
                .tasa(tasa)
                .build();
    }

    private PendientesCobrarResponse.NotaCreditoItem mapearNotaCredito(CuentaCobrar c, String referencia) {
        Long origenId = extraerValorReferencia(referencia, "origenId");
        String motivo = extraerTextoReferencia(referencia, "motivo");
        return PendientesCobrarResponse.NotaCreditoItem.builder()
                .id(c.getId())
                .cuentaCobrarOrigenId(origenId)
                .clienteId(c.getClienteId())
                .clienteRazonSocial(obtenerRazonSocialCliente(c.getClienteId()))
                .serie(c.getSerie())
                .numero(c.getNumero())
                .fechaEmision(c.getFechaEmision())
                .monedaCodigo(obtenerCodigoMoneda(c.getMonedaId()))
                .total(c.getTotal())
                .saldo(c.getSaldo())
                .motivo(motivo)
                .build();
    }

    private PendientesCobrarSimpleResponse.PendienteCobrarItem toSimpleItem(
            PendientesCobrarSimpleResponse.TipoDocumentoCobrar tipo,
            PendientesCobrarResponse.CuentaCobrarItem c) {
        return PendientesCobrarSimpleResponse.PendienteCobrarItem.builder()
                .tipoDocumento(tipo)
                .id(c.getId())
                .numero(c.getSerie() + "-" + c.getNumero())
                .fecha(c.getFechaEmision())
                .cliente(c.getClienteRazonSocial())
                .total(c.getTotal())
                .saldo(c.getSaldo())
                .moneda(c.getMonedaCodigo())
                .observacion(Boolean.TRUE.equals(c.getEsDirecto()) ? "Documento directo" : null)
                .build();
    }

    private String obtenerRazonSocialCliente(Long clienteId) {
        return cuentaCobrarRepository.findClienteRazonSocialById(clienteId)
                .orElse("Cliente " + clienteId);
    }

    private String obtenerNombreDocTipo(Long docTipoId) {
        return cuentaCobrarRepository.findDocTipoNombreById(docTipoId)
                .orElse("DocTipo " + docTipoId);
    }

    private Long extraerValorReferencia(String referencia, String clave) {
        String prefijo = clave + "=";
        if (referencia == null || !referencia.contains(prefijo)) {
            return null;
        }
        try {
            int start = referencia.indexOf(prefijo) + prefijo.length();
            int end = referencia.indexOf('|', start);
            String raw = end >= 0 ? referencia.substring(start, end) : referencia.substring(start);
            return Long.parseLong(raw.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private String extraerTextoReferencia(String referencia, String clave) {
        String prefijo = clave + "=";
        if (referencia == null || !referencia.contains(prefijo)) {
            return null;
        }
        int start = referencia.indexOf(prefijo) + prefijo.length();
        int end = referencia.indexOf('|', start);
        return end >= 0 ? referencia.substring(start, end) : referencia.substring(start);
    }

    private List<PendientesCobrarResponse.LiquidacionItem> mapearLiquidaciones(List<LiquidacionDTO> liquidaciones) {
        return liquidaciones.stream()
                .map(l -> PendientesCobrarResponse.LiquidacionItem.builder()
                        .id(l.getId())
                        .nroLiquidacion(l.getNroLiquidacion())
                        .fechaRegistro(l.getFechaRegistro())
                        .proveedorId(l.getProveedorId())
                        .proveedorRazonSocial("Proveedor " + l.getProveedorId())
                        .monedaCodigo(obtenerCodigoMoneda(l.getMonedaId()))
                        .importeNeto(l.getImporteNeto())
                        .saldo(l.getSaldo())
                        .build())
                .collect(Collectors.toList());
    }

    private List<PendientesCobrarResponse.OrdenGiroItem> mapearOrdenesGiro(List<SolicitudGiroDTO> ordenes) {
        return ordenes.stream()
                .map(o -> PendientesCobrarResponse.OrdenGiroItem.builder()
                        .id(o.getId())
                        .numero(o.getNumero())
                        .fecha(o.getFecha())
                        .solicitanteId(o.getSolicitanteId())
                        .solicitanteNombre("Usuario " + o.getSolicitanteId())
                        .monto(o.getMonto())
                        .motivo(o.getMotivo())
                        .tipoSolicitud(o.getTipoSolicitud())
                        .build())
                .collect(Collectors.toList());
    }

    // ==================== MÉTODOS AUXILIARES DE MAPEO - VERSIÓN SIMPLE ====================

    private List<PendientesCobrarSimpleResponse.PendienteCobrarItem> mapearLiquidacionesSimple(List<LiquidacionDTO> liquidaciones) {
        return liquidaciones.stream()
                .map(l -> PendientesCobrarSimpleResponse.PendienteCobrarItem.builder()
                        .tipoDocumento(PendientesCobrarSimpleResponse.TipoDocumentoCobrar.LIQUIDACION)
                        .id(l.getId())
                        .numero(l.getNroLiquidacion())
                        .fecha(l.getFechaRegistro())
                        .cliente("Proveedor " + l.getProveedorId())
                        .total(l.getImporteNeto())
                        .saldo(l.getSaldo())
                        .moneda(obtenerCodigoMoneda(l.getMonedaId()))
                        .observacion(l.getObservacion())
                        .build())
                .collect(Collectors.toList());
    }

    private List<PendientesCobrarSimpleResponse.PendienteCobrarItem> mapearOrdenesGiroSimple(List<SolicitudGiroDTO> ordenes) {
        return ordenes.stream()
                .map(o -> PendientesCobrarSimpleResponse.PendienteCobrarItem.builder()
                        .tipoDocumento(PendientesCobrarSimpleResponse.TipoDocumentoCobrar.ORDEN_GIRO)
                        .id(o.getId())
                        .numero(o.getNumero())
                        .fecha(o.getFecha())
                        .cliente("Solicitante: Usuario " + o.getSolicitanteId())
                        .total(o.getMonto())
                        .saldo(o.getMonto())
                        .moneda(MONEDA_SOLES)
                        .observacion(o.getMotivo())
                        .build())
                .collect(Collectors.toList());
    }

    // ==================== MÉTODOS AUXILIARES DE CÁLCULO ====================

    private PendientesCobrarResponse.Totales calcularTotalesCobrar(
            List<PendientesCobrarResponse.CuentaCobrarItem> cuentasCobrar,
            List<PendientesCobrarResponse.CuentaCobrarItem> documentosDirecto,
            List<PendientesCobrarResponse.NotaCreditoItem> notasCredito,
            List<PendientesCobrarResponse.LiquidacionItem> liquidaciones,
            List<PendientesCobrarResponse.OrdenGiroItem> ordenesGiro,
            List<PendientesCobrarResponse.DetraccionItem> detracciones) {

        BigDecimal totalCuentasCobrar = sumSaldoItems(cuentasCobrar);
        BigDecimal totalDirecto = sumSaldoItems(documentosDirecto);
        BigDecimal totalNotasCredito = notasCredito.stream()
                .map(PendientesCobrarResponse.NotaCreditoItem::getSaldo)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalLiquidaciones = liquidaciones.stream()
                .map(PendientesCobrarResponse.LiquidacionItem::getSaldo)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalOrdenesGiro = ordenesGiro.stream()
                .map(PendientesCobrarResponse.OrdenGiroItem::getMonto)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalDetracciones = detracciones.stream()
                .map(PendientesCobrarResponse.DetraccionItem::getImporte)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal totalGeneral = totalCuentasCobrar
                .add(totalDirecto)
                .add(totalNotasCredito)
                .add(totalLiquidaciones)
                .add(totalOrdenesGiro)
                .add(totalDetracciones);

        return PendientesCobrarResponse.Totales.builder()
                .cuentasCobrar(totalCuentasCobrar)
                .documentosDirecto(totalDirecto)
                .notasCreditoCobrar(totalNotasCredito)
                .liquidaciones(totalLiquidaciones)
                .ordenesGiro(totalOrdenesGiro)
                .detraccionesCobrar(totalDetracciones)
                .totalGeneral(totalGeneral)
                .build();
    }

    private BigDecimal sumSaldoItems(List<PendientesCobrarResponse.CuentaCobrarItem> items) {
        return items.stream()
                .map(PendientesCobrarResponse.CuentaCobrarItem::getSaldo)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    private BigDecimal obtenerTasaCambio(LocalDate fecha, Long monedaId) {
        if (monedaId == null) {
            return BigDecimal.ONE;
        }
        try {
            var monedaResponse = coreMaestrosClient.obtenerMonedaPorId(monedaId);
            if (monedaResponse != null && monedaResponse.isSuccess() && monedaResponse.getData() != null) {
                String codigo = monedaResponse.getData().getCodigo();
                if ("PEN".equals(codigo) || "SOL".equals(codigo)) {
                    return BigDecimal.ONE;
                }
            }
        } catch (Exception e) {
            log.warn("No se pudo obtener monedaId {}, consultando tipo de cambio directamente", monedaId, e);
        }
        try {
            var response = coreMaestrosClient.obtenerUltimoTipoCambioPorFecha(fecha, monedaId);
            if (response != null && response.isSuccess() && response.getData() != null && response.getData().getCompra() != null) {
                return response.getData().getCompra();
            }
        } catch (Exception e) {
            log.error("Error al obtener tipo de cambio para fecha {} y monedaId {}", fecha, monedaId, e);
        }
        throw new BusinessException("No se encontró una tasa de cambio activa para la moneda y fecha especificada",
                "VEN-TIPO-CAMBIO");
    }

    private String obtenerCodigoMoneda(Long monedaId) {
        if (monedaId == null) {
            return MONEDA_SOLES;
        }
        return monedaId == 1L ? MONEDA_SOLES : MONEDA_DOLARES;
    }
}
