package com.sigre.comercializacion.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.dto.PageResponse;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.CuentaCobrarAnularRequest;
import com.sigre.comercializacion.dto.request.CuentaCobrarDetraccionRequest;
import com.sigre.comercializacion.dto.request.CuentaCobrarDirectoRequest;
import com.sigre.comercializacion.dto.request.CuentaCobrarMovimientoRequest;
import com.sigre.comercializacion.dto.request.CuentaCobrarNotaCreditoRequest;
import com.sigre.comercializacion.dto.request.CuentaCobrarRequest;
import com.sigre.comercializacion.dto.request.DetImpuestoRequest;
import com.sigre.comercializacion.dto.response.CuentaCobrarResponse;
import com.sigre.comercializacion.dto.response.PendientesCobrarResponse;
import com.sigre.comercializacion.dto.response.PendientesCobrarSimpleResponse;
import com.sigre.comercializacion.mapper.CuentaCobrarMapper;
import com.sigre.comercializacion.entity.CuentaCobrar;
import com.sigre.comercializacion.entity.CuentaCobrarDet;
import com.sigre.comercializacion.service.CuentaCobrarService;

import jakarta.validation.Valid;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Controller REST para Cuentas por Cobrar
 * Implementa todos los endpoints según contrato
 */
@RestController
@RequestMapping("/api/ventas/cuentas-cobrar")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Cuentas por Cobrar", description = "API para gestión de cuentas por cobrar")
@PreAuthorize("hasAnyAuthority('VENTAS_CONSULTAR', 'ADMIN')")
public class CuentaCobrarController {

    private final CuentaCobrarService cuentaCobrarService;
    private final CuentaCobrarMapper mapper;

    /**
     * GET /api/ventas/cuentas-cobrar
     * Lista paginada con filtros
     */
    @Operation(summary = "Listar cuentas por cobrar", description = "Lista paginada con filtros opcionales")
    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<CuentaCobrarResponse.CuentaCobrarListItemResponse>>> findAll(
            @Parameter(description = "Número de página (0-based)") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "Tamaño de página") @RequestParam(defaultValue = "20") int size,
            @Parameter(description = "Ordenamiento") @RequestParam(defaultValue = "fechaEmision,desc") String sort,
            @Parameter(description = "Filtrar por sucursal") @RequestParam(required = false) Long sucursalId,
            @Parameter(description = "Filtrar por cliente") @RequestParam(required = false) Long clienteId,
            @Parameter(description = "Filtrar por tipo de documento") @RequestParam(required = false) Long docTipoId,
            @Parameter(description = "Filtrar por flagEstado") @RequestParam(required = false) String flagEstado,
            @Parameter(description = "Fecha vencimiento desde (dd/MM/yyyy)") @RequestParam(required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") LocalDate fechaVencimientoDesde,
            @Parameter(description = "Fecha vencimiento hasta (dd/MM/yyyy)") @RequestParam(required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") LocalDate fechaVencimientoHasta) {

        log.info("Listando cuentas por cobrar con filtros: page={}, size={}, sucursalId={}, clienteId={}, docTipoId={}, flagEstado={}",
                page, size, sucursalId, clienteId, docTipoId, flagEstado);

        // Configurar paginación y ordenamiento
        String[] sortParams = sort.split(",");
        Sort.Direction direction = sortParams.length > 1 && "desc".equalsIgnoreCase(sortParams[1]) 
                ? Sort.Direction.DESC : Sort.Direction.ASC;
        Pageable pageable = PageRequest.of(page, size, Sort.by(direction, sortParams[0]));

        Page<CuentaCobrar> result = cuentaCobrarService.findAllWithFilters(
                sucursalId, clienteId, docTipoId, flagEstado,
                fechaVencimientoDesde, fechaVencimientoHasta, pageable);

        PageResponse<CuentaCobrarResponse.CuentaCobrarListItemResponse> pageResponse =
                PageResponse.<CuentaCobrarResponse.CuentaCobrarListItemResponse>builder()
                .content(mapper.toListItemResponseList(result.getContent()))
                .page(result.getNumber())
                .size(result.getSize())
                .totalElements(result.getTotalElements())
                .totalPages(result.getTotalPages())
                .build();

        return ResponseEntity.ok(ApiResponse.<PageResponse<CuentaCobrarResponse.CuentaCobrarListItemResponse>>builder()
                .success(true)
                .message("Operación exitosa")
                .data(pageResponse)
                .build());
    }

    /**
     * GET /api/ventas/cuentas-cobrar/{id}
     * Obtiene detalle por ID con movimientos
     */
    @Operation(summary = "Obtener cuenta por cobrar por ID", description = "Retorna detalle completo con movimientos")
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<CuentaCobrarResponse>> findById(
            @Parameter(description = "ID de cuenta por cobrar") @PathVariable Long id) {

        log.info("Buscando cuenta por cobrar por ID: {}", id);

        CuentaCobrar cab = cuentaCobrarService.findByIdWithMovimientos(id);
        List<CuentaCobrarDet> movimientos = cuentaCobrarService.findMovimientosByCuentaCobrarId(id);
        CuentaCobrarResponse result = mapper.toResponse(cab, movimientos);

        return ResponseEntity.ok(ApiResponse.<CuentaCobrarResponse>builder()
                .success(true)
                .message("Operación exitosa")
                .data(result)
                .build());
    }

    /**
     * POST /api/ventas/cuentas-cobrar
     * Crea cuenta por cobrar con movimientos iniciales
     */
    @Operation(summary = "Crear cuenta por cobrar", description = "Crea cabecera con movimientos iniciales")
    @PostMapping
    @PreAuthorize("hasAnyAuthority('VENTAS_CREAR', 'ADMIN')")
    public ResponseEntity<ApiResponse<CuentaCobrarResponse>> create(
            @Valid @RequestBody CuentaCobrarRequest request) {

        log.info("Creando cuenta por cobrar: cliente={}, docTipo={}, serie={}", 
                request.getClienteId(), request.getDocTipoId(), request.getSerie());

        // Convertir request a entidad
        CuentaCobrar cuentaCobrar = CuentaCobrar.builder()
                .sucursalId(request.getSucursalId())
                .clienteId(request.getClienteId())
                .docTipoId(request.getDocTipoId())
                .serie(request.getSerie())
                .numero(request.getNumero())
                .fechaEmision(request.getFechaEmision())
                .fechaVencimiento(request.getFechaVencimiento())
                .monedaId(request.getMonedaId())
                .total(request.getTotal())
                .saldo(request.getSaldo())
                .ano(request.getAno())
                .mes(request.getMes())
                .cntblLibroId(request.getCntblLibroId())
                .build();

        // Convertir movimientos
        List<CuentaCobrarDet> movimientos = null;
        List<List<DetImpuestoRequest>> impuestosPorMovimiento = null;
        if (request.getMovimientos() != null && !request.getMovimientos().isEmpty()) {
            movimientos = request.getMovimientos().stream()
                    .map(mov -> CuentaCobrarDet.builder()
                            .fechaMov(mov.getFechaMov())
                            .tipoMov(mov.getTipoMov())
                            .monto(mov.getMonto())
                            .referencia(mov.getReferencia())
                            .conceptoFinancieroId(mov.getConceptoFinancieroId())
                            .nroItem(mov.getNroItem() != null ? mov.getNroItem() : 1)
                            .descripcion(mov.getDescripcion())
                            .creditoFiscalId(mov.getCreditoFiscalId() != null ? mov.getCreditoFiscalId() : 1L)
                            .cantidad(mov.getCantidad() != null ? mov.getCantidad() : BigDecimal.ONE)
                            .precioUnitario(mov.getPrecioUnitario())
                            .build())
                    .toList();
            impuestosPorMovimiento = request.getMovimientos().stream()
                    .map(CuentaCobrarMovimientoRequest::getImpuestos)
                    .toList();
        }

        Long userId = TenantContext.getUsuarioId();
        CuentaCobrar saved = cuentaCobrarService.create(cuentaCobrar, movimientos, impuestosPorMovimiento, userId);
        List<CuentaCobrarDet> savedMovs = cuentaCobrarService.findMovimientosByCuentaCobrarId(saved.getId());
        CuentaCobrarResponse result = mapper.toResponse(saved, savedMovs);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.<CuentaCobrarResponse>builder()
                        .success(true)
                        .message("Cuenta por cobrar creada exitosamente")
                        .data(result)
                        .build());
    }

    /**
     * PUT /api/ventas/cuentas-cobrar/{id}
     * Actualiza cuenta por cobrar
     */
    @Operation(summary = "Actualizar cuenta por cobrar", description = "Actualiza todos los campos editables")
    @PutMapping("/{id}")
    @PreAuthorize("hasAnyAuthority('VENTAS_EDITAR', 'ADMIN')")
    public ResponseEntity<ApiResponse<CuentaCobrarResponse>> update(
            @Parameter(description = "ID de cuenta por cobrar") @PathVariable Long id,
            @Valid @RequestBody CuentaCobrarRequest request) {

        log.info("Actualizando cuenta por cobrar: {}", id);

        CuentaCobrar cuentaCobrar = CuentaCobrar.builder()
                .sucursalId(request.getSucursalId())
                .clienteId(request.getClienteId())
                .docTipoId(request.getDocTipoId())
                .serie(request.getSerie())
                .numero(request.getNumero())
                .fechaEmision(request.getFechaEmision())
                .fechaVencimiento(request.getFechaVencimiento())
                .monedaId(request.getMonedaId())
                .total(request.getTotal())
                .saldo(request.getSaldo())
                .ano(request.getAno())
                .mes(request.getMes())
                .cntblLibroId(request.getCntblLibroId())
                .build();

        Long userId = TenantContext.getUsuarioId();
        CuentaCobrar saved = cuentaCobrarService.update(id, cuentaCobrar, userId);
        List<CuentaCobrarDet> movs = cuentaCobrarService.findMovimientosByCuentaCobrarId(saved.getId());
        CuentaCobrarResponse result = mapper.toResponse(saved, movs);

        return ResponseEntity.ok(ApiResponse.<CuentaCobrarResponse>builder()
                .success(true)
                .message("Cuenta por cobrar actualizada exitosamente")
                .data(result)
                .build());
    }

    /**
     * PATCH /api/ventas/cuentas-cobrar/{id}/activar
     * Activa cuenta por cobrar
     */
    @Operation(summary = "Activar cuenta por cobrar", description = "Activa una cuenta por cobrar inactiva")
    @PatchMapping("/{id}/activar")
    @PreAuthorize("hasAnyAuthority('VENTAS_EDITAR', 'ADMIN')")
    public ResponseEntity<ApiResponse<CuentaCobrarResponse>> activar(
            @Parameter(description = "ID de cuenta por cobrar") @PathVariable Long id) {

        log.info("Activando cuenta por cobrar: {}", id);

        Long userId = TenantContext.getUsuarioId();
        CuentaCobrar saved = cuentaCobrarService.activar(id, userId);
        List<CuentaCobrarDet> movs = cuentaCobrarService.findMovimientosByCuentaCobrarId(saved.getId());
        CuentaCobrarResponse result = mapper.toResponse(saved, movs);

        return ResponseEntity.ok(ApiResponse.<CuentaCobrarResponse>builder()
                .success(true)
                .message("Cuenta por cobrar activada exitosamente")
                .data(result)
                .build());
    }

    /**
     * PATCH /api/ventas/cuentas-cobrar/{id}/desactivar
     * Desactiva cuenta por cobrar
     */
    @Operation(summary = "Desactivar cuenta por cobrar", description = "Desactiva una cuenta por cobrar activa")
    @PatchMapping("/{id}/desactivar")
    @PreAuthorize("hasAnyAuthority('VENTAS_EDITAR', 'ADMIN')")
    public ResponseEntity<ApiResponse<CuentaCobrarResponse>> desactivar(
            @Parameter(description = "ID de cuenta por cobrar") @PathVariable Long id) {

        log.info("Desactivando cuenta por cobrar: {}", id);

        Long userId = TenantContext.getUsuarioId();
        CuentaCobrar saved = cuentaCobrarService.desactivar(id, userId);
        List<CuentaCobrarDet> movs = cuentaCobrarService.findMovimientosByCuentaCobrarId(saved.getId());
        CuentaCobrarResponse result = mapper.toResponse(saved, movs);

        return ResponseEntity.ok(ApiResponse.<CuentaCobrarResponse>builder()
                .success(true)
                .message("Cuenta por cobrar desactivada exitosamente")
                .data(result)
                .build());
    }

    /**
     * DELETE /api/ventas/cuentas-cobrar/{id}
     * Elimina cuenta por cobrar (baja lógica)
     */
    @Operation(summary = "Eliminar cuenta por cobrar", description = "Realiza baja lógica de la cuenta por cobrar")
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyAuthority('VENTAS_ELIMINAR', 'ADMIN')")
    public ResponseEntity<ApiResponse<Void>> delete(
            @Parameter(description = "ID de cuenta por cobrar") @PathVariable Long id) {

        log.info("Eliminando cuenta por cobrar: {}", id);

        Long userId = TenantContext.getUsuarioId();
        cuentaCobrarService.delete(id, userId);

        return ResponseEntity.ok(ApiResponse.<Void>builder()
                .success(true)
                .message("Cuenta por cobrar eliminada exitosamente")
                .data(null)
                .build());
    }

    /**
     * POST /api/ventas/cuentas-cobrar/{id}/movimientos
     * Registra movimiento en cuenta por cobrar
     */
    @Operation(summary = "Registrar movimiento", description = "Registra cargo, abono o ajuste en cuenta por cobrar")
    @PostMapping("/{id}/movimientos")
    @PreAuthorize("hasAnyAuthority('VENTAS_EDITAR', 'ADMIN')")
    public ResponseEntity<ApiResponse<CuentaCobrarResponse>> registrarMovimiento(
            @Parameter(description = "ID de cuenta por cobrar") @PathVariable Long id,
            @Valid @RequestBody CuentaCobrarMovimientoRequest request) {

        log.info("Registrando movimiento en cuenta por cobrar: {}, tipo={}, monto={}", 
                id, request.getTipoMov(), request.getMonto());

        CuentaCobrarDet movimiento = CuentaCobrarDet.builder()
                .fechaMov(request.getFechaMov())
                .tipoMov(request.getTipoMov())
                .monto(request.getMonto())
                .referencia(request.getReferencia())
                .conceptoFinancieroId(request.getConceptoFinancieroId())
                .nroItem(request.getNroItem() != null ? request.getNroItem() : 1)
                .descripcion(request.getDescripcion())
                .creditoFiscalId(request.getCreditoFiscalId() != null ? request.getCreditoFiscalId() : 1L)
                .cantidad(request.getCantidad() != null ? request.getCantidad() : BigDecimal.ONE)
                .precioUnitario(request.getPrecioUnitario())
                .build();

        Long userId = TenantContext.getUsuarioId();
        CuentaCobrar saved = cuentaCobrarService.registrarMovimiento(id, movimiento, userId);
        List<CuentaCobrarDet> movs = cuentaCobrarService.findMovimientosByCuentaCobrarId(saved.getId());
        CuentaCobrarResponse result = mapper.toResponse(saved, movs);

        return ResponseEntity.ok(ApiResponse.<CuentaCobrarResponse>builder()
                .success(true)
                .message("Movimiento registrado exitosamente")
                .data(result)
                .build());
    }

    /**
     * POST /api/ventas/cuentas-cobrar/{id}/anular
     * Anula cuenta por cobrar
     */
    @Operation(summary = "Anular cuenta por cobrar", description = "Anula cuenta por cobrar sin abonos aplicados")
    @PostMapping("/{id}/anular")
    @PreAuthorize("hasAnyAuthority('VENTAS_EDITAR', 'ADMIN')")
    public ResponseEntity<ApiResponse<CuentaCobrarResponse>> anular(
            @Parameter(description = "ID de cuenta por cobrar") @PathVariable Long id,
            @RequestBody(required = false) CuentaCobrarAnularRequest request) {

        log.info("Anulando cuenta por cobrar: {}", id);

        String motivo = request != null ? request.getMotivo() : null;
        Long userId = TenantContext.getUsuarioId();
        CuentaCobrar saved = cuentaCobrarService.anular(id, motivo, userId);
        List<CuentaCobrarDet> movs = cuentaCobrarService.findMovimientosByCuentaCobrarId(saved.getId());
        CuentaCobrarResponse result = mapper.toResponse(saved, movs);

        return ResponseEntity.ok(ApiResponse.<CuentaCobrarResponse>builder()
                .success(true)
                .message("Cuenta por cobrar anulada exitosamente")
                .data(result)
                .build());
    }

    /**
     * GET /api/ventas/cuentas-cobrar/{id}/movimientos
     * Lista movimientos de cuenta por cobrar
     */
    @Operation(summary = "Listar movimientos", description = "Retorna todos los movimientos de una cuenta por cobrar")
    @GetMapping("/{id}/movimientos")
    public ResponseEntity<ApiResponse<List<CuentaCobrarDet>>> findMovimientos(
            @Parameter(description = "ID de cuenta por cobrar") @PathVariable Long id) {

        log.info("Listando movimientos de cuenta por cobrar: {}", id);

        List<CuentaCobrarDet> result = cuentaCobrarService.findMovimientosByCuentaCobrarId(id);

        return ResponseEntity.ok(ApiResponse.<List<CuentaCobrarDet>>builder()
                .success(true)
                .message("Operación exitosa")
                .data(result)
                .build());
    }

    /**
     * POST /api/ventas/cuentas-cobrar/directo
     * Registra documento por cobrar directo (ingresos fuera de venta POS/OV).
     */
    @Operation(summary = "Crear documento por cobrar directo")
    @PostMapping("/directo")
    @PreAuthorize("hasAnyAuthority('VENTAS_CREAR', 'ADMIN')")
    public ResponseEntity<ApiResponse<CuentaCobrarResponse>> crearDirecto(
            @Valid @RequestBody CuentaCobrarDirectoRequest request) {

        Long userId = TenantContext.getUsuarioId();
        CuentaCobrar saved = cuentaCobrarService.crearDocumentoDirecto(request, userId);
        List<CuentaCobrarDet> movs = cuentaCobrarService.findMovimientosByCuentaCobrarId(saved.getId());
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.<CuentaCobrarResponse>builder()
                        .success(true)
                        .message("Documento directo registrado")
                        .data(mapper.toResponse(saved, movs))
                        .build());
    }

    /**
     * POST /api/ventas/cuentas-cobrar/{id}/detraccion
     * Genera detracción por cobrar vinculada a una CxC de factura (monto origen ≥ S/ 700).
     */
    @Operation(summary = "Generar detracción por cobrar")
    @PostMapping("/{id}/detraccion")
    @PreAuthorize("hasAnyAuthority('VENTAS_CREAR', 'ADMIN')")
    public ResponseEntity<ApiResponse<CuentaCobrarResponse>> generarDetraccion(
            @PathVariable Long id,
            @RequestBody(required = false) CuentaCobrarDetraccionRequest request) {

        Long userId = TenantContext.getUsuarioId();
        CuentaCobrar saved = cuentaCobrarService.generarDetraccionPorCobrar(id, request, userId);
        List<CuentaCobrarDet> movs = cuentaCobrarService.findMovimientosByCuentaCobrarId(saved.getId());
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.<CuentaCobrarResponse>builder()
                        .success(true)
                        .message("Detracción por cobrar generada")
                        .data(mapper.toResponse(saved, movs))
                        .build());
    }

    /**
     * POST /api/ventas/cuentas-cobrar/notas-credito
     * Emite nota de crédito por cobrar (NCC) contra documento origen.
     */
    @Operation(summary = "Crear nota de crédito por cobrar")
    @PostMapping("/notas-credito")
    @PreAuthorize("hasAnyAuthority('VENTAS_CREAR', 'ADMIN')")
    public ResponseEntity<ApiResponse<CuentaCobrarResponse>> crearNotaCredito(
            @Valid @RequestBody CuentaCobrarNotaCreditoRequest request) {

        Long userId = TenantContext.getUsuarioId();
        CuentaCobrar saved = cuentaCobrarService.crearNotaCreditoPorCobrar(request, userId);
        List<CuentaCobrarDet> movs = cuentaCobrarService.findMovimientosByCuentaCobrarId(saved.getId());
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.<CuentaCobrarResponse>builder()
                        .success(true)
                        .message("Nota de crédito por cobrar registrada")
                        .data(mapper.toResponse(saved, movs))
                        .build());
    }

    /**
     * Lista todos los documentos pendientes por cobrar agrupados por tipo.
     * Incluye: Cuentas por Cobrar, Liquidaciones, Órdenes de Giro y Detracciones.
     * Retorna listas separadas por tipo de documento con totales calculados.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param clienteId ID de cliente (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Respuesta agrupada con listas por tipo y totales
     */
    @GetMapping("/pendientes/agrupado")
    @Operation(summary = "Listar pendientes por cobrar agrupados", 
               description = "Lista todos los documentos pendientes de cobro agrupados por tipo con totales calculados")
    public ResponseEntity<ApiResponse<PendientesCobrarResponse>> listarPendientesPorCobrarAgrupado(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long clienteId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") LocalDate fechaHasta) {
        
        log.info("GET /api/ventas/cuentas-cobrar/pendientes/agrupado - sucursal: {}, cliente: {}, fechas: {} - {}", 
                sucursalId, clienteId, fechaDesde, fechaHasta);
        
        PendientesCobrarResponse response = cuentaCobrarService.listarPendientesPorCobrarAgrupado(
                sucursalId, clienteId, fechaDesde, fechaHasta);
        
        return ResponseEntity.ok(ApiResponse.<PendientesCobrarResponse>builder()
                .success(true)
                .message("Operación exitosa")
                .data(response)
                .build());
    }

    /**
     * Lista todos los documentos pendientes por cobrar en formato simple unificado.
     * Combina todos los tipos de documentos en una lista plana con estructura común.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param clienteId ID de cliente (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista simple unificada de pendientes
     */
    @GetMapping("/pendientes/simple")
    @Operation(summary = "Listar pendientes por cobrar simple", 
               description = "Lista todos los documentos pendientes de cobro en formato unificado")
    public ResponseEntity<ApiResponse<PendientesCobrarSimpleResponse>> listarPendientesPorCobrarSimple(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long clienteId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") LocalDate fechaHasta) {
        
        log.info("GET /api/ventas/cuentas-cobrar/pendientes/simple - sucursal: {}, cliente: {}, fechas: {} - {}", 
                sucursalId, clienteId, fechaDesde, fechaHasta);
        
        PendientesCobrarSimpleResponse response = cuentaCobrarService.listarPendientesPorCobrarSimple(
                sucursalId, clienteId, fechaDesde, fechaHasta);
        
        return ResponseEntity.ok(ApiResponse.<PendientesCobrarSimpleResponse>builder()
                .success(true)
                .message("Operación exitosa")
                .data(response)
                .build());
    }
}
