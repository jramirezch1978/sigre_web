package pe.restaurant.finanzas.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.dto.FlujoCajaNodo;
import pe.restaurant.finanzas.entity.ActividadFlujoCaja;
import pe.restaurant.finanzas.entity.CodigoFlujoCaja;
import pe.restaurant.finanzas.entity.GrupoCodigoFlujoCaja;
import pe.restaurant.finanzas.repository.ActividadFlujoCajaRepository;
import pe.restaurant.finanzas.repository.CodigoFlujoCajaRepository;
import pe.restaurant.finanzas.repository.GrupoCodigoFlujoCajaRepository;
import pe.restaurant.finanzas.service.FlujoCajaArbolService;

import java.math.BigDecimal;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class FlujoCajaArbolServiceImpl implements FlujoCajaArbolService {

    private static final String TIPO_ACTIVIDAD = "ACTIVIDAD";
    private static final String TIPO_GRUPO = "GRUPO";
    private static final String TIPO_CODIGO = "CODIGO";

    private final ActividadFlujoCajaRepository actividadRepository;
    private final GrupoCodigoFlujoCajaRepository grupoRepository;
    private final CodigoFlujoCajaRepository codigoRepository;

    // ========================================================================
    // GET — Construye el árbol desde BD
    // ========================================================================

    @Override
    @Transactional(readOnly = true)
    public List<FlujoCajaNodo> obtenerArbol() {
        log.debug("Obteniendo árbol completo de flujo de caja");
        List<ActividadFlujoCaja> actividades = actividadRepository.findAllByOrderByOrdenAsc();
        List<FlujoCajaNodo> arbol = new ArrayList<>();
        for (ActividadFlujoCaja actividad : actividades) {
            arbol.add(toNodoActividad(actividad));
        }
        log.debug("Árbol obtenido: {} actividades", actividades.size());
        return arbol;
    }

    private FlujoCajaNodo toNodoActividad(ActividadFlujoCaja entity) {
        FlujoCajaNodo nodo = new FlujoCajaNodo();
        nodo.setTipoNivel(TIPO_ACTIVIDAD);
        nodo.setId(entity.getId());
        nodo.setCodigo(entity.getCodigo());
        nodo.setNombre(entity.getNombre());
        nodo.setOrden(entity.getOrden());
        nodo.setFlagEstado(entity.getFlagEstado());
        nodo.setActivo("1".equals(entity.getFlagEstado()));
        nodo.setFlagTipoFlujo(entity.getFlagTipoFlujo());
        setAuditoria(nodo, entity.getCreatedBy(), entity.getFecCreacion(),
                entity.getUpdatedBy(), entity.getFecModificacion());

        List<GrupoCodigoFlujoCaja> grupos = grupoRepository
                .findByActividadFlujoCajaIdOrderByOrden(entity.getId());
        nodo.setHijos(new ArrayList<>());
        for (GrupoCodigoFlujoCaja grupo : grupos) {
            nodo.getHijos().add(toNodoGrupo(grupo, entity.getId()));
        }
        return nodo;
    }

    private FlujoCajaNodo toNodoGrupo(GrupoCodigoFlujoCaja entity, Long parentId) {
        FlujoCajaNodo nodo = new FlujoCajaNodo();
        nodo.setTipoNivel(TIPO_GRUPO);
        nodo.setId(entity.getId());
        nodo.setCodigo(entity.getCodigo());
        nodo.setNombre(entity.getNombre());
        nodo.setOrden(entity.getOrden());
        nodo.setFlagEstado(entity.getFlagEstado());
        nodo.setActivo("1".equals(entity.getFlagEstado()));
        nodo.setParentId(parentId);
        nodo.setFlagReporte(entity.getFlagReporte());
        nodo.setFactor(entity.getFactor());
        setAuditoria(nodo, entity.getCreatedBy(), entity.getFecCreacion(),
                entity.getUpdatedBy(), entity.getFecModificacion());

        List<CodigoFlujoCaja> codigos = codigoRepository
                .findByGrupoCodigoFlujoCajaIdOrderByOrden(entity.getId());
        nodo.setHijos(new ArrayList<>());
        for (CodigoFlujoCaja codigo : codigos) {
            nodo.getHijos().add(toNodoCodigo(codigo, entity.getId()));
        }
        return nodo;
    }

    private FlujoCajaNodo toNodoCodigo(CodigoFlujoCaja entity, Long parentId) {
        FlujoCajaNodo nodo = new FlujoCajaNodo();
        nodo.setTipoNivel(TIPO_CODIGO);
        nodo.setId(entity.getId());
        nodo.setCodigo(entity.getCodigo());
        nodo.setNombre(entity.getNombre());
        nodo.setOrden(entity.getOrden());
        nodo.setFlagEstado(entity.getFlagEstado());
        nodo.setActivo("1".equals(entity.getFlagEstado()));
        nodo.setParentId(parentId);
        nodo.setTipo(entity.getTipo());
        nodo.setFactor(entity.getFactor() != null ? entity.getFactor().toString() : null);
        nodo.setFactorFlujoCaja(entity.getFactorFlujoCaja() != null ? entity.getFactorFlujoCaja().intValue() : null);
        nodo.setCodUsr(entity.getCodUsr());
        setAuditoria(nodo, entity.getCreatedBy(), entity.getFecCreacion(),
                entity.getUpdatedBy(), entity.getFecModificacion());
        return nodo;
    }

    private void setAuditoria(FlujoCajaNodo nodo, Long createdBy, Object fecCreacion,
                               Long updatedBy, Object fecModificacion) {
        nodo.setCreatedBy(createdBy != null ? createdBy.toString() : null);
        nodo.setFecCreacion(fecCreacion != null ? fecCreacion.toString() : null);
        nodo.setUpdatedBy(updatedBy != null ? updatedBy.toString() : null);
        nodo.setFecModificacion(fecModificacion != null ? fecModificacion.toString() : null);
    }

    // ========================================================================
    // PUT — Reconciliación del árbol completo
    // ========================================================================

    @Override
    @Transactional
    public List<FlujoCajaNodo> guardarArbol(List<FlujoCajaNodo> arbolRequest) {
        log.info("Guardando árbol de flujo de caja — {} actividades en request", arbolRequest.size());

        for (FlujoCajaNodo nodoAct : arbolRequest) {
            validarEstructura(nodoAct);
            ActividadFlujoCaja actividad = procesarActividad(nodoAct);
            Long actividadId = actividad.getId();

            if (nodoAct.getHijos() != null) {
                for (FlujoCajaNodo nodoGrupo : nodoAct.getHijos()) {
                    nodoGrupo.setParentId(actividadId);
                    validarEstructura(nodoGrupo);
                    GrupoCodigoFlujoCaja grupo = procesarGrupo(nodoGrupo);
                    Long grupoId = grupo.getId();

                    if (nodoGrupo.getHijos() != null) {
                        for (FlujoCajaNodo nodoCodigo : nodoGrupo.getHijos()) {
                            nodoCodigo.setParentId(grupoId);
                            validarEstructura(nodoCodigo);
                            procesarCodigo(nodoCodigo);
                        }
                    }
                }
            }
        }

        log.info("Árbol guardado exitosamente — reconstruyendo respuesta");
        return obtenerArbol();
    }

    // ------------------------------------------------------------------------
    // Validaciones
    // ------------------------------------------------------------------------

    private void validarEstructura(FlujoCajaNodo nodo) {
        String tipo = nodo.getTipoNivel();
        if (tipo == null || (!tipo.equals(TIPO_ACTIVIDAD) && !tipo.equals(TIPO_GRUPO) && !tipo.equals(TIPO_CODIGO))) {
            throw new BusinessException("tipoNivel inválido: " + tipo, HttpStatus.BAD_REQUEST, "FIN-ARBOL-001");
        }
        if (nodo.getCodigo() == null || nodo.getCodigo().isBlank()) {
            throw new BusinessException("Código requerido para " + tipo, HttpStatus.BAD_REQUEST, "FIN-ARBOL-002");
        }
        if (nodo.getNombre() == null || nodo.getNombre().isBlank()) {
            throw new BusinessException("Nombre requerido para " + tipo, HttpStatus.BAD_REQUEST, "FIN-ARBOL-003");
        }
        if (nodo.getOrden() == null) {
            throw new BusinessException("Orden requerido para " + tipo, HttpStatus.BAD_REQUEST, "FIN-ARBOL-004");
        }

        // Forzar parentId según tipo
        if (TIPO_GRUPO.equals(tipo) && nodo.getParentId() == null) {
            throw new BusinessException(
                    "GRUPO debe pertenecer a una ACTIVIDAD (parentId requerido)",
                    HttpStatus.BAD_REQUEST, "FIN-ARBOL-005");
        }
        if (TIPO_CODIGO.equals(tipo) && nodo.getParentId() == null) {
            throw new BusinessException(
                    "CODIGO debe pertenecer a un GRUPO (parentId requerido)",
                    HttpStatus.BAD_REQUEST, "FIN-ARBOL-006");
        }

        // Validar factor según nivel
        if (TIPO_GRUPO.equals(tipo) && nodo.getFactor() != null
                && !nodo.getFactor().equals("I") && !nodo.getFactor().equals("E")) {
            throw new BusinessException(
                    "Factor de GRUPO debe ser 'I' (Ingreso) o 'E' (Egreso)",
                    HttpStatus.BAD_REQUEST, "FIN-ARBOL-007");
        }
        if (TIPO_CODIGO.equals(tipo) && nodo.getFactor() != null
                && !nodo.getFactor().equals("1") && !nodo.getFactor().equals("-1")) {
            throw new BusinessException(
                    "Factor de CODIGO debe ser '1' (Ingreso) o '-1' (Egreso)",
                    HttpStatus.BAD_REQUEST, "FIN-ARBOL-008");
        }
    }

    private void validarCodigoUnicoActividad(String codigo, Long excluirId) {
        boolean existe = (excluirId == null)
                ? actividadRepository.existsByCodigo(codigo)
                : actividadRepository.existsByCodigoAndIdNot(codigo, excluirId);
        if (existe) {
            throw new BusinessException(
                    "Ya existe una actividad con código: " + codigo,
                    HttpStatus.CONFLICT, "FIN-007");
        }
    }

    private void validarCodigoUnicoGrupo(String codigo, Long excluirId) {
        boolean existe = (excluirId == null)
                ? grupoRepository.existsByCodigo(codigo)
                : grupoRepository.existsByCodigoAndIdNot(codigo, excluirId);
        if (existe) {
            throw new BusinessException(
                    "Ya existe un grupo con código: " + codigo,
                    HttpStatus.CONFLICT, "FIN-001");
        }
    }

    private void validarCodigoUnicoCodigo(String codigo, Long excluirId) {
        boolean existe = (excluirId == null)
                ? codigoRepository.existsByCodigoIgnoreCase(codigo)
                : codigoRepository.existsByCodigoIgnoreCaseAndIdNot(codigo, excluirId);
        if (existe) {
            throw new BusinessException(
                    "Ya existe un código con código: " + codigo,
                    HttpStatus.CONFLICT, "FIN-002");
        }
    }

    // ------------------------------------------------------------------------
    // Procesamiento por nivel
    // ------------------------------------------------------------------------

    private ActividadFlujoCaja procesarActividad(FlujoCajaNodo nodo) {
        ActividadFlujoCaja entity;
        if (nodo.getId() == null) {
            validarCodigoUnicoActividad(nodo.getCodigo(), null);
            entity = new ActividadFlujoCaja();
            entity.setCodigo(nodo.getCodigo());
            entity.setNombre(nodo.getNombre());
            entity.setOrden(nodo.getOrden());
            entity.setFlagTipoFlujo(nodo.getFlagTipoFlujo() != null ? nodo.getFlagTipoFlujo() : "E");
            entity.setFlagEstado(nodo.getFlagEstado() != null ? nodo.getFlagEstado() : "1");
            entity.setCreatedBy(TenantContext.getUsuarioId());
            entity = actividadRepository.save(entity);
            log.info("Actividad creada: id={}, codigo={}", entity.getId(), entity.getCodigo());
        } else {
            entity = actividadRepository.findById(nodo.getId())
                    .orElseThrow(() -> new BusinessException(
                            "Actividad no encontrada: " + nodo.getId(),
                            HttpStatus.NOT_FOUND, "FIN-ARBOL-009"));
            validarCodigoUnicoActividad(nodo.getCodigo(), nodo.getId());
            entity.setCodigo(nodo.getCodigo());
            entity.setNombre(nodo.getNombre());
            entity.setOrden(nodo.getOrden());
            if (nodo.getFlagTipoFlujo() != null) {
                entity.setFlagTipoFlujo(nodo.getFlagTipoFlujo());
            }
            if (nodo.getFlagEstado() != null) {
                entity.setFlagEstado(nodo.getFlagEstado());
            }
            entity.setUpdatedBy(TenantContext.getUsuarioId());
            entity = actividadRepository.save(entity);
            log.debug("Actividad actualizada: id={}", entity.getId());
        }
        nodo.setId(entity.getId());
        return entity;
    }

    private GrupoCodigoFlujoCaja procesarGrupo(FlujoCajaNodo nodo) {
        GrupoCodigoFlujoCaja entity;
        if (nodo.getId() == null) {
            validarCodigoUnicoGrupo(nodo.getCodigo(), null);
            entity = new GrupoCodigoFlujoCaja();
            entity.setCodigo(nodo.getCodigo());
            entity.setNombre(nodo.getNombre());
            entity.setOrden(nodo.getOrden());
            entity.setActividadFlujoCajaId(nodo.getParentId());
            entity.setFlagReporte(nodo.getFlagReporte());
            entity.setFactor(nodo.getFactor());
            entity.setFlagEstado(nodo.getFlagEstado() != null ? nodo.getFlagEstado() : "1");
            entity.setFecRegistro(new java.util.Date());
            entity.setCreatedBy(TenantContext.getUsuarioId());
            entity = grupoRepository.save(entity);
            log.info("Grupo creado: id={}, codigo={}", entity.getId(), entity.getCodigo());
        } else {
            entity = grupoRepository.findById(nodo.getId())
                    .orElseThrow(() -> new BusinessException(
                            "Grupo no encontrado: " + nodo.getId(),
                            HttpStatus.NOT_FOUND, "FIN-ARBOL-010"));
            validarCodigoUnicoGrupo(nodo.getCodigo(), nodo.getId());
            entity.setCodigo(nodo.getCodigo());
            entity.setNombre(nodo.getNombre());
            entity.setOrden(nodo.getOrden());
            entity.setActividadFlujoCajaId(nodo.getParentId());
            if (nodo.getFlagReporte() != null) {
                entity.setFlagReporte(nodo.getFlagReporte());
            }
            if (nodo.getFactor() != null) {
                entity.setFactor(nodo.getFactor());
            }
            if (nodo.getFlagEstado() != null) {
                entity.setFlagEstado(nodo.getFlagEstado());
            }
            entity.setUpdatedBy(TenantContext.getUsuarioId());
            entity = grupoRepository.save(entity);
            log.debug("Grupo actualizado: id={}", entity.getId());
        }
        nodo.setId(entity.getId());
        return entity;
    }

    private CodigoFlujoCaja procesarCodigo(FlujoCajaNodo nodo) {
        CodigoFlujoCaja entity;
        if (nodo.getId() == null) {
            validarCodigoUnicoCodigo(nodo.getCodigo(), null);
            entity = new CodigoFlujoCaja();
            entity.setCodigo(nodo.getCodigo());
            entity.setNombre(nodo.getNombre());
            entity.setOrden(nodo.getOrden());
            entity.setTipo(nodo.getTipo());
            entity.setGrupoCodigoFlujoCajaId(nodo.getParentId());
            if (nodo.getFactor() != null) {
                entity.setFactor(new BigDecimal(nodo.getFactor()));
            }
            if (nodo.getFactorFlujoCaja() != null) {
                entity.setFactorFlujoCaja(nodo.getFactorFlujoCaja().shortValue());
            }
            entity.setFlagEstado(nodo.getFlagEstado() != null ? nodo.getFlagEstado() : "1");
            entity.setFecRegistro(new java.util.Date());
            entity.setCreatedBy(TenantContext.getUsuarioId());
            entity = codigoRepository.save(entity);
            log.info("Código creado: id={}, codigo={}", entity.getId(), entity.getCodigo());
        } else {
            entity = codigoRepository.findById(nodo.getId())
                    .orElseThrow(() -> new BusinessException(
                            "Código no encontrado: " + nodo.getId(),
                            HttpStatus.NOT_FOUND, "FIN-ARBOL-011"));
            validarCodigoUnicoCodigo(nodo.getCodigo(), nodo.getId());
            entity.setCodigo(nodo.getCodigo());
            entity.setNombre(nodo.getNombre());
            entity.setOrden(nodo.getOrden());
            entity.setTipo(nodo.getTipo());
            entity.setGrupoCodigoFlujoCajaId(nodo.getParentId());
            if (nodo.getFactor() != null) {
                entity.setFactor(new BigDecimal(nodo.getFactor()));
            }
            if (nodo.getFactorFlujoCaja() != null) {
                entity.setFactorFlujoCaja(nodo.getFactorFlujoCaja().shortValue());
            }
            if (nodo.getFlagEstado() != null) {
                entity.setFlagEstado(nodo.getFlagEstado());
            }
            entity.setUpdatedBy(TenantContext.getUsuarioId());
            entity = codigoRepository.save(entity);
            log.debug("Código actualizado: id={}", entity.getId());
        }
        nodo.setId(entity.getId());
        return entity;
    }
}
