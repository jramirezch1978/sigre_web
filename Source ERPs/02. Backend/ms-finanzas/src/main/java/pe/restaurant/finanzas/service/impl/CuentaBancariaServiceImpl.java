package pe.restaurant.finanzas.service.impl;

import feign.FeignException;
import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.response.MonedaResponse;
import pe.restaurant.finanzas.dto.response.PlanContableDetResponse;
import pe.restaurant.finanzas.entity.BancoCnta;
import pe.restaurant.finanzas.repository.BancoCntaRepository;
import pe.restaurant.finanzas.repository.BancoRepository;
import pe.restaurant.finanzas.service.CuentaBancariaService;
import pe.restaurant.finanzas.service.FinanzasErrorCodes;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.math.BigDecimal;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CuentaBancariaServiceImpl implements CuentaBancariaService {

    private final BancoCntaRepository repository;
    private final BancoRepository bancoRepository;
    private final JdbcTemplate jdbcTemplate;
    private final CoreMaestrosClient coreMaestrosClient;

    @Timed(value = "app.db.query", extraTags = {"table", "banco_cnta", "operation", "findAll"})
    @Override
    public Page<BancoCnta> findAll(Pageable pageable) {
        log.info("Listando cuentas bancarias - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<BancoCnta> page = repository.findAll(pageable);
        log.info("Cuentas bancarias encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco_cnta", "operation", "findById"})
    @Override
    public BancoCnta findById(Long id) {
        log.info("Buscando cuenta bancaria con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Cuenta bancaria no encontrada con id: {}", id);
                    return new ResourceNotFoundException("CuentaBancaria", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco_cnta", "operation", "getSaldoActual"})
    @Override
    public BigDecimal getSaldoActual(Long id) {
        log.info("Consultando saldo actual de cuenta bancaria con id: {}", id);
        // Get the saldo only for active accounts
        BigDecimal saldo = repository.findSaldoContableById(id);
        if (saldo == null) {
            // Account doesn't exist or is inactive
            throw new ResourceNotFoundException("Cuenta Bancaria activa", id);
        }
        log.info("Saldo actual de cuenta {}: {}", id, saldo);
        return saldo;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco_cnta", "operation", "create"})
    @Override
    @Transactional
    public BancoCnta create(BancoCnta entity) {
        log.info("Creando cuenta bancaria con codigo: {}", entity.getCodigo());
        validateForeignKeys(entity);
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        BancoCnta saved = repository.save(entity);
        log.info("Cuenta bancaria creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco_cnta", "operation", "update"})
    @Override
    @Transactional
    public BancoCnta update(Long id, BancoCnta entity) {
        log.info("Actualizando cuenta bancaria con id: {}", id);
        BancoCnta existing = findById(id);
        validateForeignKeys(entity);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setPlanContableDetId(entity.getPlanContableDetId());
        existing.setBancoId(entity.getBancoId());
        existing.setTipoCtaBco(entity.getTipoCtaBco());
        existing.setDescripcion(entity.getDescripcion());
        existing.setCorrelativoCheque(entity.getCorrelativoCheque());
        existing.setMonedaId(entity.getMonedaId());
        existing.setSaldoContable(entity.getSaldoContable());
        existing.setNroCci(entity.getNroCci());
        existing.setNroCuenta(entity.getNroCuenta());
        existing.setSucursalId(entity.getSucursalId());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        BancoCnta updated = repository.save(existing);
        log.info("Cuenta bancaria actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco_cnta", "operation", "activate"})
    @Override
    @Transactional
    public BancoCnta activate(Long id) {
        log.info("Activando cuenta bancaria con id: {}", id);
        BancoCnta existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        BancoCnta activated = repository.save(existing);
        log.info("Cuenta bancaria activada exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco_cnta", "operation", "deactivate"})
    @Override
    @Transactional
    public BancoCnta deactivate(Long id) {
        log.info("Desactivando cuenta bancaria con id: {}", id);
        BancoCnta existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        BancoCnta deactivated = repository.save(existing);
        log.info("Cuenta bancaria desactivada exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco_cnta", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando cuenta bancaria con id: {}", id);
        BancoCnta existing = findById(id);
        repository.delete(existing);
        log.info("Cuenta bancaria eliminada exitosamente con id: {}", id);
    }

    private void validateForeignKeys(BancoCnta entity) {
        if (entity.getPlanContableDetId() == null) {
            throw new BusinessException(
                "El detalle de plan contable (plan_contable_det_id) es obligatorio",
                HttpStatus.BAD_REQUEST,
                FinanzasErrorCodes.PLAN_CONTABLE_DET_NO_ENCONTRADO);
        }
        validarPlanContableDetExistente(entity.getPlanContableDetId());

        // Validar banco (local - misma BD) - usando JPA repository
        if (entity.getBancoId() != null) {
            try {
                bancoRepository.findById(entity.getBancoId())
                    .orElseThrow(() -> new ResourceNotFoundException("Banco", entity.getBancoId()));
            } catch (Exception e) {
                log.error("Error validando banco con id {}: {}", entity.getBancoId(), e.getMessage());
                throw new ResourceNotFoundException("Banco", entity.getBancoId());
            }
        }
        
        // Validar moneda (externa - ms-core-maestros)
        if (entity.getMonedaId() != null) {
            validarMonedaExistente(entity.getMonedaId());
        }
    }

    /**
     * Plan contable detalle vía ms-core-maestros.
     */
    private void validarPlanContableDetExistente(Long planContableDetId) {
        try {
            log.debug("Validando existencia de plan contable detalle con id: {}", planContableDetId);
            ApiResponse<PlanContableDetResponse> response =
                    coreMaestrosClient.obtenerPlanContableDetPorId(planContableDetId);

            if (response == null || response.getData() == null) {
                log.warn("Plan contable detalle no encontrado con id: {}", planContableDetId);
                throw new BusinessException(
                        "El detalle de plan contable con ID " + planContableDetId + " no existe en el sistema",
                        HttpStatus.NOT_FOUND,
                        FinanzasErrorCodes.PLAN_CONTABLE_DET_NO_ENCONTRADO);
            }

            PlanContableDetResponse det = response.getData();
            if (!"1".equals(det.getFlagEstado())) {
                log.warn("Plan contable detalle inactivo con id: {}", planContableDetId);
                throw new BusinessException(
                        "El detalle de plan contable está inactivo",
                        HttpStatus.BAD_REQUEST,
                        FinanzasErrorCodes.PLAN_CONTABLE_DET_INACTIVO);
            }
        } catch (FeignException.NotFound e) {
            log.warn("Plan contable detalle no encontrado con id: {} - {}", planContableDetId, e.getMessage());
            throw new BusinessException(
                    "El detalle de plan contable con ID " + planContableDetId + " no existe en el sistema",
                    HttpStatus.NOT_FOUND,
                    FinanzasErrorCodes.PLAN_CONTABLE_DET_NO_ENCONTRADO);
        } catch (BusinessException e) {
            throw e;
        } catch (FeignException e) {
            log.error("Error al comunicarse con ms-core-maestros para validar plan contable detalle {}: {}",
                    planContableDetId, e.getMessage());
            throw new BusinessException(
                    "Error al validar el detalle del plan contable. Por favor, intente nuevamente",
                    HttpStatus.SERVICE_UNAVAILABLE,
                    FinanzasErrorCodes.ERROR_COMUNICACION_CORE_MAESTROS);
        }
    }

    /**
     * Valida que la moneda exista y esté activa en ms-core-maestros
     * 
     * @param monedaId ID de la moneda a validar
     * @throws BusinessException si la moneda no existe o está inactiva
     */
    private void validarMonedaExistente(Long monedaId) {
        try {
            log.debug("Validando existencia de moneda con id: {}", monedaId);
            ApiResponse<MonedaResponse> response = coreMaestrosClient.obtenerMonedaPorId(monedaId);
            
            // Validar que la respuesta contenga datos
            if (response == null || response.getData() == null) {
                log.warn("Moneda no encontrada con id: {}", monedaId);
                throw new BusinessException(
                    "La moneda con ID " + monedaId + " no existe en el sistema",
                    HttpStatus.NOT_FOUND,
                    FinanzasErrorCodes.MONEDA_NO_ENCONTRADA
                );
            }
            
            // Validar que la moneda esté activa
            MonedaResponse moneda = response.getData();
            if (!"1".equals(moneda.getFlagEstado())) {
                log.warn("Moneda inactiva con id: {}", monedaId);
                throw new BusinessException(
                    "La moneda '" + moneda.getNombre() + "' está inactiva. Debe activarla antes de usarla",
                    HttpStatus.BAD_REQUEST,
                    FinanzasErrorCodes.MONEDA_INACTIVA
                );
            }
            
            log.debug("Moneda validada exitosamente: {} - {}", moneda.getCodigo(), moneda.getNombre());
            
        } catch (FeignException.NotFound e) {
            // El endpoint retornó 404
            log.warn("Moneda no encontrada con id: {} - Error: {}", monedaId, e.getMessage());
            throw new BusinessException(
                "La moneda con ID " + monedaId + " no existe en el sistema",
                HttpStatus.NOT_FOUND,
                FinanzasErrorCodes.MONEDA_NO_ENCONTRADA
            );
        } catch (FeignException e) {
            // Otro error de comunicación (timeout, 500, etc.)
            log.error("Error al comunicarse con ms-core-maestros para validar moneda {}: {}", 
                    monedaId, e.getMessage());
            throw new BusinessException(
                "Error al validar la moneda. Por favor, intente nuevamente",
                HttpStatus.SERVICE_UNAVAILABLE,
                FinanzasErrorCodes.ERROR_COMUNICACION_CORE_MAESTROS
            );
        }
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByCodigoIgnoreCase(codigo)
                : repository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de cuenta bancaria: {}", codigo);
            throw new BusinessException(
                    "Ya existe una cuenta bancaria con código: " + codigo,
                    org.springframework.http.HttpStatus.CONFLICT, 
                    FinanzasErrorCodes.CUENTA_BANCARIA_CODIGO_DUPLICADO);
        }
    }
}
