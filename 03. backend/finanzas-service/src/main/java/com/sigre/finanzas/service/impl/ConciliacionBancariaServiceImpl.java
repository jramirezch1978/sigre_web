package com.sigre.finanzas.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.finanzas.dto.request.ConciliacionBancariaRequest;
import com.sigre.finanzas.dto.request.ConciliacionDetRequest;
import com.sigre.finanzas.dto.request.ConciliarPartidasRequest;
import com.sigre.finanzas.dto.response.CerrarConciliacionResponse;
import com.sigre.finanzas.dto.response.ConciliacionBancariaResponse;
import com.sigre.finanzas.dto.response.ConciliarPartidasResponse;
import com.sigre.finanzas.entity.ConciliacionBancaria;
import com.sigre.finanzas.entity.ConciliacionDet;
import com.sigre.finanzas.mapper.ConciliacionBancariaMapper;
import com.sigre.finanzas.mapper.ConciliacionDetMapper;
import com.sigre.finanzas.repository.BancoCntaRepository;
import com.sigre.finanzas.repository.CajaBancosRepository;
import com.sigre.finanzas.repository.ConciliacionBancariaRepository;
import com.sigre.finanzas.repository.ConciliacionDetRepository;
import com.sigre.finanzas.service.ConciliacionBancariaService;
import com.sigre.finanzas.service.FinanzasErrorCodes;

import jakarta.persistence.criteria.Predicate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ConciliacionBancariaServiceImpl implements ConciliacionBancariaService {

    private static final String FLAG_ESTADO_ACTIVO = "1";
    private static final String FLAG_ESTADO_CERRADO = "2";

    private final ConciliacionBancariaRepository repository;
    private final ConciliacionDetRepository detalleRepository;
    private final BancoCntaRepository bancoCntaRepository;
    private final CajaBancosRepository cajaBancosRepository;
    private final ConciliacionBancariaMapper mapper;
    private final ConciliacionDetMapper detalleMapper;

    @Override
    public Page<ConciliacionBancariaResponse> listar(Long bancoCntaId, Integer periodoAnio,
                                                      Integer periodoMes, String estado, Pageable pageable) {
        log.info("Listando conciliaciones bancarias - banco: {}, periodo: {}/{}, estado: {}",
                bancoCntaId, periodoAnio, periodoMes, estado);

        Specification<ConciliacionBancaria> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            predicates.add(cb.equal(root.get("flagEstado"), FLAG_ESTADO_ACTIVO));

            if (bancoCntaId != null) {
                predicates.add(cb.equal(root.get("bancoCntaId"), bancoCntaId));
            }
            if (periodoAnio != null) {
                predicates.add(cb.equal(root.get("periodoAnio"), periodoAnio));
            }
            if (periodoMes != null) {
                predicates.add(cb.equal(root.get("periodoMes"), periodoMes));
            }
            if (estado != null && !estado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), estado));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<ConciliacionBancaria> page = repository.findAll(spec, pageable);
        return page.map(mapper::toResponse);
    }

    @Override
    public ConciliacionBancariaResponse obtenerPorId(Long id) {
        log.info("Obteniendo conciliación bancaria por ID: {}", id);

        ConciliacionBancaria conciliacion = repository.findByIdWithDetalles(id)
                .orElseThrow(() -> new ResourceNotFoundException("Conciliación bancaria", id));

        return mapper.toResponse(conciliacion);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "conciliacion_bancaria", "operation", "create"})
    @Override
    @Transactional
    public ConciliacionBancariaResponse crear(ConciliacionBancariaRequest request) {
        log.info("Creando conciliación bancaria - banco: {}, periodo: {}/{}",
                request.getBancoCntaId(), request.getPeriodoAnio(), request.getPeriodoMes());

        validarPeriodo(request.getPeriodoMes());
        validarCuentaBancaria(request.getBancoCntaId());
        validarNoDuplicado(request.getBancoCntaId(), request.getPeriodoAnio(), request.getPeriodoMes());
        validarDetalles(request.getDetalles());

        ConciliacionBancaria conciliacion = mapper.toEntity(request);
        conciliacion.setFlagEstado(FLAG_ESTADO_ACTIVO);
        conciliacion.setCreatedBy(TenantContext.getUsuarioId());
        conciliacion.calcularDiferencia();

        request.getDetalles().forEach(detRequest -> {
            ConciliacionDet detalle = detalleMapper.toEntity(detRequest);
            detalle.setFlagEstado(FLAG_ESTADO_ACTIVO);
            detalle.setCreatedBy(TenantContext.getUsuarioId());
            conciliacion.addDetalle(detalle);
        });

        ConciliacionBancaria saved = repository.save(conciliacion);
        log.info("Conciliación bancaria creada con ID: {}", saved.getId());

        return mapper.toResponse(saved);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "conciliacion_bancaria", "operation", "update"})
    @Override
    @Transactional
    public ConciliacionBancariaResponse actualizar(Long id, ConciliacionBancariaRequest request) {
        log.info("Actualizando conciliación bancaria ID: {}", id);

        ConciliacionBancaria conciliacion = repository.findByIdWithDetalles(id)
                .orElseThrow(() -> new ResourceNotFoundException("Conciliación bancaria", id));

        validarEstadoEditable(conciliacion);
        validarPeriodo(request.getPeriodoMes());

        conciliacion.setSaldoBanco(request.getSaldoBanco());
        conciliacion.setSaldoLibros(request.getSaldoLibros());
        conciliacion.calcularDiferencia();
        conciliacion.setUpdatedBy(TenantContext.getUsuarioId());

        conciliacion.getDetalles().clear();
        request.getDetalles().forEach(detRequest -> {
            ConciliacionDet detalle = detalleMapper.toEntity(detRequest);
            detalle.setFlagEstado(FLAG_ESTADO_ACTIVO);
            detalle.setCreatedBy(conciliacion.getCreatedBy());
            detalle.setUpdatedBy(TenantContext.getUsuarioId());
            conciliacion.addDetalle(detalle);
        });

        ConciliacionBancaria updated = repository.save(conciliacion);
        log.info("Conciliación bancaria actualizada: {}", id);

        return mapper.toResponse(updated);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "conciliacion_bancaria", "operation", "conciliar"})
    @Override
    @Transactional
    public ConciliarPartidasResponse conciliar(Long id, ConciliarPartidasRequest request) {
        log.info("Conciliando partidas para conciliación ID: {}", id);

        ConciliacionBancaria conciliacion = repository.findByIdWithDetalles(id)
                .orElseThrow(() -> new ResourceNotFoundException("Conciliación bancaria", id));

        validarEstadoEditable(conciliacion);

        List<ConciliacionDet> detalles = detalleRepository.findByConciliacionIdAndIdIn(id, request.getDetalleIds());

        if (detalles.size() != request.getDetalleIds().size()) {
            throw new BusinessException(
                    "Algunos IDs de detalle no pertenecen a esta conciliación",
                    FinanzasErrorCodes.CONCILIACION_PARTIDAS_INVALIDAS);
        }

        detalles.forEach(detalle -> {
            detalle.setConciliado(true);
            detalle.setUpdatedBy(TenantContext.getUsuarioId());
        });

        detalleRepository.saveAll(detalles);
        conciliacion.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(conciliacion);

        log.info("Partidas conciliadas: {}", detalles.size());

        ConciliarPartidasResponse response = new ConciliarPartidasResponse();
        response.setConciliacionId(id);
        response.setPartidasConciliadas(detalles.size());
        response.setMensaje("Partidas conciliadas exitosamente");

        return response;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "conciliacion_bancaria", "operation", "cerrar"})
    @Override
    @Transactional
    public CerrarConciliacionResponse cerrar(Long id) {
        log.info("Cerrando conciliación bancaria ID: {}", id);

        ConciliacionBancaria conciliacion = repository.findByIdWithDetalles(id)
                .orElseThrow(() -> new ResourceNotFoundException("Conciliación bancaria", id));

        validarEstadoEditable(conciliacion);

        long pendientes = conciliacion.getDetalles().stream()
                .filter(d -> !d.getConciliado())
                .count();

        if (pendientes > 0) {
            throw new BusinessException(
                    "Existen " + pendientes + " partidas sin conciliar",
                    FinanzasErrorCodes.CONCILIACION_PARTIDAS_PENDIENTES);
        }

        conciliacion.setFlagEstado(FLAG_ESTADO_CERRADO);
        conciliacion.setUpdatedBy(TenantContext.getUsuarioId());
        repository.save(conciliacion);

        log.info("Conciliación bancaria cerrada: {}", id);

        CerrarConciliacionResponse response = new CerrarConciliacionResponse();
        response.setConciliacionId(id);
        response.setDiferencia(conciliacion.getDiferencia());
        response.setMensaje("Conciliación cerrada exitosamente");

        return response;
    }

    private void validarPeriodo(Integer mes) {
        if (mes < 1 || mes > 12) {
            throw new BusinessException(
                    "El mes debe estar entre 1 y 12",
                    FinanzasErrorCodes.CONCILIACION_PERIODO_INVALIDO);
        }
    }

    private void validarCuentaBancaria(Long bancoCntaId) {
        if (!bancoCntaRepository.existsById(bancoCntaId)) {
            throw new BusinessException(
                    "La cuenta bancaria con ID " + bancoCntaId + " no existe. Verifique que la cuenta esté registrada y activa.",
                    FinanzasErrorCodes.CUENTA_BANCARIA_NO_ACTIVA);
        }
    }

    private void validarNoDuplicado(Long bancoCntaId, Integer periodoAnio, Integer periodoMes) {
        boolean existe = repository.existsByBancoCntaIdAndPeriodoAnioAndPeriodoMesAndFlagEstado(
                bancoCntaId, periodoAnio, periodoMes, FLAG_ESTADO_ACTIVO);

        if (existe) {
            throw new BusinessException(
                    "Ya existe una conciliación en proceso para este banco y periodo",
                    FinanzasErrorCodes.CONCILIACION_DUPLICADA);
        }
    }

    private void validarDetalles(List<ConciliacionDetRequest> detalles) {
        if (detalles == null || detalles.isEmpty()) {
            throw new BusinessException(
                    "Debe incluir al menos un detalle en la conciliación",
                    FinanzasErrorCodes.CONCILIACION_PARTIDAS_INVALIDAS);
        }

        // Validar que existan los IDs de caja_bancos
        List<Long> cajaBancosIds = detalles.stream()
                .map(ConciliacionDetRequest::getCajaBancosId)
                .toList();

        List<Long> idsNoExisten = cajaBancosIds.stream()
                .filter(id -> !cajaBancosRepository.existsById(id))
                .toList();

        if (!idsNoExisten.isEmpty()) {
            throw new BusinessException(
                    "Los siguientes IDs de movimientos de caja no existen: " + idsNoExisten + 
                    ". Verifique que los movimientos estén registrados.",
                    FinanzasErrorCodes.CONCILIACION_PARTIDAS_INVALIDAS);
        }
    }

    private void validarEstadoEditable(ConciliacionBancaria conciliacion) {
        if (FLAG_ESTADO_CERRADO.equals(conciliacion.getFlagEstado())) {
            throw new BusinessException(
                    "No se puede modificar una conciliación cerrada",
                    FinanzasErrorCodes.CONCILIACION_ESTADO_INVALIDO);
        }
    }
}
