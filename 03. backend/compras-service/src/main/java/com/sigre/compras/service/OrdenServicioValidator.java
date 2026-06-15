package com.sigre.compras.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import com.sigre.compras.dto.OrdenServicioCabeceraRequest;
import com.sigre.compras.dto.OrdenServicioLineaRequest;
import com.sigre.compras.entity.AprobadorConfigurado;
import com.sigre.compras.entity.DocTipoRef;
import com.sigre.compras.entity.OrdenServicio;
import com.sigre.compras.entity.OrdenServicioDet;
import com.sigre.compras.repository.*;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;

import java.math.BigDecimal;
import java.util.List;

/**
 * HU §6-§9 — Validaciones de negocio para órdenes de servicio.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class OrdenServicioValidator {

    private static final String DOC_TIPO_CODIGO = "OS";
    private static final Long MONEDA_BASE_PEN = 1L;

    private final CompradorRepository compradorRepository;
    private final AprobadorConfiguradoRepository aprobadorConfiguradoRepository;
    private final EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    private final MonedaRefRepository monedaRefRepository;
    private final SucursalRefRepository sucursalRefRepository;
    private final ConfiguracionRefRepository configuracionRefRepository;
    private final JdbcTemplate jdbcTemplate;

    @Autowired(required = false)
    private DocTipoRefRepository docTipoRefRepository;

    // ── §6 Verificar comprador activo ───────────────────────────────────────

    public Long verificarCompradorActivo() {
        Long usuarioId = TenantContext.getUsuarioId();
        if (usuarioId == null) {
            throw new BusinessException("Usuario no autenticado",
                    HttpStatus.UNAUTHORIZED, "TOKEN_REQUERIDO");
        }
        return compradorRepository.findByUsuarioIdAndFlagEstado(usuarioId, "1")
                .orElseThrow(() -> new BusinessException(
                        "El usuario actual no está registrado como comprador activo",
                        HttpStatus.UNPROCESSABLE_ENTITY, "COM-102"))
                .getId();
    }

    // ── §7 Validaciones de cabecera ─────────────────────────────────────────

    public void validarCabecera(OrdenServicioCabeceraRequest request) {
        validarProveedorExiste(request.getProveedorId());
        validarMonedaExiste(request.getMonedaId());
        validarSucursalExiste(request.getSucursalId());

        if (request.getMonedaId() != null && !MONEDA_BASE_PEN.equals(request.getMonedaId())) {
            if (request.getTipoCambio() == null || request.getTipoCambio().signum() <= 0) {
                throw new BusinessException(
                        "El tipo de cambio es obligatorio para moneda extranjera",
                        HttpStatus.UNPROCESSABLE_ENTITY, "COM-103");
            }
        }
    }

    // ── §8 Validaciones de detalle ──────────────────────────────────────────

    public void validarDetalle(List<OrdenServicioLineaRequest> lineas) {
        if (lineas == null || lineas.isEmpty()) {
            throw new BusinessException(
                    "La orden de servicio debe tener al menos una línea",
                    HttpStatus.BAD_REQUEST, "COM-106");
        }
        for (int i = 0; i < lineas.size(); i++) {
            OrdenServicioLineaRequest l = lineas.get(i);
            int n = i + 1;

            validarServicioActivo(l.getServicioId(), n);

            if (l.getImporte() == null || l.getImporte().compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException(
                        "El importe debe ser mayor a cero (línea " + n + ")",
                        HttpStatus.BAD_REQUEST, "COM-108");
            }

            if (l.getFecProyect() == null) {
                throw new BusinessException(
                        "La fecha proyectada es obligatoria (línea " + n + ")",
                        HttpStatus.BAD_REQUEST, "COM-109");
            }

            if (l.getTiposImpuesto2Id() != null) {
                if (l.getTiposImpuestoId() == null) {
                    throw new BusinessException(
                            "No se puede indicar impuesto 2 sin impuesto 1 (línea " + n + ")",
                            HttpStatus.BAD_REQUEST, "COM-111");
                }
            }

            if (l.getDsctoPorcentaje() != null && l.getDsctoPorcentaje().compareTo(new BigDecimal("100")) > 0) {
                throw new BusinessException(
                        "El porcentaje de descuento no puede superar 100% (línea " + n + ")",
                        HttpStatus.BAD_REQUEST, "COM-112");
            }
        }
    }

    private void validarServicioActivo(Long servicioId, int numLinea) {
        if (servicioId == null) return;
        try {
            String flag = jdbcTemplate.queryForObject(
                    "SELECT flag_estado FROM compras.servicio WHERE id = ?",
                    String.class, servicioId);
            if (!"1".equals(flag)) {
                throw new BusinessException(
                        "El servicio id " + servicioId + " no está activo (línea " + numLinea + ")",
                        HttpStatus.BAD_REQUEST, "COM-107");
            }
        } catch (BusinessException be) {
            throw be;
        } catch (org.springframework.dao.EmptyResultDataAccessException e) {
            throw new BusinessException(
                    "El servicio id " + servicioId + " no existe (línea " + numLinea + ")",
                    HttpStatus.BAD_REQUEST, "COM-107");
        } catch (Exception e) {
            log.warn("No se pudo validar servicio id={}: {}", servicioId, e.getMessage());
        }
    }

    // ── §9 Verificación de precios ──────────────────────────────────────────

    public void verificarPrecios(OrdenServicio os) {
        if ("0".equals(os.getFlagEstado())) return;
        for (OrdenServicioDet linea : os.getLineas()) {
            if ("0".equals(linea.getFlagEstado())) continue;
            if (linea.getImporte() == null || linea.getImporte().signum() == 0) {
                throw new BusinessException(
                        "No se permite importe cero en línea activa (servicio id: "
                                + linea.getServicioId() + ")",
                        HttpStatus.UNPROCESSABLE_ENTITY, "COM-117");
            }
        }
    }

    // ── Validar aprobador configurado ────────────────────────────────────────

    public void validarAprobadorConfigurado(Long usuarioId, BigDecimal montoTotal) {
        List<AprobadorConfigurado> aprobadores = aprobadorConfiguradoRepository.findAll().stream()
                .filter(a -> resolveDocTipoId().equals(a.getDocTipoId())
                        && usuarioId.equals(a.getAprobadorId())
                        && "1".equals(a.getFlagEstado()))
                .toList();

        if (aprobadores.isEmpty()) {
            throw new BusinessException(
                    "El usuario no es aprobador configurado para este documento",
                    HttpStatus.FORBIDDEN, "COM-130");
        }

        boolean dentroDeRango = aprobadores.stream().anyMatch(a -> {
            boolean minOk = a.getMontoMinimo() == null
                    || montoTotal.compareTo(a.getMontoMinimo()) >= 0;
            boolean maxOk = a.getMontoMaximo() == null
                    || montoTotal.compareTo(a.getMontoMaximo()) <= 0;
            return minOk && maxOk;
        });

        if (!dentroDeRango) {
            throw new BusinessException(
                    "El monto de la OS está fuera del rango autorizado del aprobador",
                    HttpStatus.FORBIDDEN, "COM-131");
        }
    }

    // ── §19 Validar límite OT ───────────────────────────────────────────────

    public void validarLimiteOT(OrdenServicioDet linea, BigDecimal nuevoImporte) {
        if (linea.getOperacionesDetId() == null) return;
        if (!isValidaLimiteOs()) return;
        try {
            BigDecimal aprobado = jdbcTemplate.queryForObject(
                    "SELECT COALESCE(importe_aprobado, 0) FROM produccion.operaciones_det WHERE id = ?",
                    BigDecimal.class, linea.getOperacionesDetId());
            BigDecimal comprometido = jdbcTemplate.queryForObject(
                    "SELECT COALESCE(SUM(osd.subtotal), 0) FROM compras.orden_servicio_det osd " +
                    "JOIN compras.orden_servicio os ON os.id = osd.orden_servicio_id " +
                    "WHERE osd.operaciones_det_id = ? AND osd.flag_estado = '1' AND os.flag_estado != '0' " +
                    "AND osd.id != ?",
                    BigDecimal.class, linea.getOperacionesDetId(), linea.getId() != null ? linea.getId() : -1L);
            if (comprometido != null && aprobado != null
                    && comprometido.add(nuevoImporte).compareTo(aprobado) > 0) {
                throw new BusinessException(
                        "El importe supera el límite aprobado de la OT (operaciones_det_id: "
                                + linea.getOperacionesDetId() + ", aprobado: " + aprobado + ")",
                        HttpStatus.UNPROCESSABLE_ENTITY, "COM-116");
            }
        } catch (BusinessException be) {
            throw be;
        } catch (Exception e) {
            log.warn("No se pudo validar límite OT para operaciones_det_id={}: {}", linea.getOperacionesDetId(), e.getMessage());
        }
    }

    private boolean isValidaLimiteOs() {
        return configuracionRefRepository.findFirstByParametro("FLAG_VALIDA_LIMITE_OS")
                .map(c -> "1".equals(c.getValorTexto()))
                .orElse(false);
    }

    // ── §20 Restricción cencos por usuario ──────────────────────────────────

    public void validarCencosUsuario(Long centrosCostoId, Long usuarioId) {
        if (centrosCostoId == null) return;
        if (!isRestriccionCencosActiva()) return;
        try {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM compras.presup_usr_autorizdos " +
                    "WHERE usuario_id = ? AND centros_costo_id = ? AND flag_estado = '1'",
                    Integer.class, usuarioId, centrosCostoId);
            if (count == null || count == 0) {
                throw new BusinessException(
                        "El usuario no tiene autorización para el centro de costos id: " + centrosCostoId,
                        HttpStatus.FORBIDDEN, "COM-114");
            }
        } catch (BusinessException be) {
            throw be;
        } catch (Exception e) {
            log.warn("No se pudo validar centros_costo_id usuario: {}", e.getMessage());
        }
    }

    private boolean isRestriccionCencosActiva() {
        return configuracionRefRepository.findFirstByParametro("flag_restr_cencos_usr")
                .map(c -> "1".equals(c.getValorTexto()))
                .orElse(false);
    }

    // ── §15 Validaciones de anulación ────────────────────────────────────────

    public void verificarSinProvisionesAprovisionamiento(Long osId) {
        try {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM compras.ap_pd_descarga_det WHERE orden_servicio_id = ?",
                    Integer.class, osId);
            if (count != null && count > 0) {
                throw new BusinessException(
                        "No se puede anular: la OS tiene descargas de aprovisionamiento",
                        HttpStatus.CONFLICT, "COM-123");
            }
        } catch (BusinessException be) {
            throw be;
        } catch (Exception e) {
            log.warn("No se pudo verificar aprovisionamiento para OS {}: {}", osId, e.getMessage());
        }
    }

    public void verificarSinGastosFlota(Long osId) {
        try {
            Integer count = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM compras.fl_gtos_drcts_bahia_det WHERE orden_servicio_id = ?",
                    Integer.class, osId);
            if (count != null && count > 0) {
                throw new BusinessException(
                        "No se puede anular: la OS tiene gastos de flota vinculados",
                        HttpStatus.CONFLICT, "COM-124");
            }
        } catch (BusinessException be) {
            throw be;
        } catch (Exception e) {
            log.warn("No se pudo verificar flota para OS {}: {}", osId, e.getMessage());
        }
    }

    // ── Conformidad: operaciones + log_diario ───────────────────────────────

    public void actualizarOperacionesConformidad(Long operacionesDetId, BigDecimal monto) {
        if (operacionesDetId == null) return;
        try {
            jdbcTemplate.update(
                    "UPDATE produccion.operaciones_det SET imp_consumido = COALESCE(imp_consumido, 0) + ? " +
                    "WHERE id = ?",
                    monto, operacionesDetId);
        } catch (Exception e) {
            log.warn("No se pudo actualizar operaciones para operaciones_det_id={}: {}", operacionesDetId, e.getMessage());
        }
    }

    public void revertirOperacionesConformidad(Long operacionesDetId, BigDecimal monto) {
        if (operacionesDetId == null) return;
        try {
            jdbcTemplate.update(
                    "UPDATE produccion.operaciones_det SET imp_consumido = GREATEST(COALESCE(imp_consumido, 0) - ?, 0) " +
                    "WHERE id = ?",
                    monto, operacionesDetId);
        } catch (Exception e) {
            log.warn("No se pudo revertir operaciones para operaciones_det_id={}: {}", operacionesDetId, e.getMessage());
        }
    }

    public void insertarLogDiario(Long osId, Long lineaId, String accion, Long usuarioId, String observacion) {
        try {
            jdbcTemplate.update(
                    "INSERT INTO compras.log_diario (tipo_documento, documento_id, detalle_id, accion, usuario_id, fecha, observacion) " +
                    "VALUES ('ORDEN_SERVICIO', ?, ?, ?, ?, NOW(), ?)",
                    osId, lineaId, accion, usuarioId, observacion);
        } catch (Exception e) {
            log.warn("No se pudo insertar log_diario: {}", e.getMessage());
        }
    }

    // ── Utilidades ──────────────────────────────────────────────────────────

    private void validarProveedorExiste(Long id) {
        if (id == null) return;
        if (!entidadContribuyenteRefRepository.existsById(id)) {
            throw new BusinessException("Proveedor con id " + id + " no existe",
                    HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
        }
    }

    private void validarMonedaExiste(Long id) {
        if (id == null) return;
        if (!monedaRefRepository.existsById(id)) {
            throw new BusinessException("Moneda con id " + id + " no existe",
                    HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
        }
    }

    private void validarSucursalExiste(Long id) {
        if (id == null) return;
        if (!sucursalRefRepository.existsById(id)) {
            throw new BusinessException("Sucursal con id " + id + " no existe",
                    HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
        }
    }

    private Long resolveDocTipoId() {
        if (docTipoRefRepository != null) {
            return docTipoRefRepository.findFirstByCodigoAndFlagEstado(DOC_TIPO_CODIGO, "1")
                    .map(DocTipoRef::getId)
                    .orElseThrow(() -> new BusinessException(
                            "No existe tipo de documento activo para codigo " + DOC_TIPO_CODIGO,
                            HttpStatus.UNPROCESSABLE_ENTITY, "COM-132"));
        }
        return jdbcTemplate.queryForObject(
                "SELECT id FROM core.doc_tipo WHERE codigo = ? AND flag_estado = '1'",
                Long.class, DOC_TIPO_CODIGO);
    }
}
