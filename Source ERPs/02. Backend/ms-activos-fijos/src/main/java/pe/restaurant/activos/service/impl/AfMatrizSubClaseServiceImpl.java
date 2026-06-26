package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfMatrizSubClase;
import pe.restaurant.activos.repository.AfMatrizSubClaseRepository;
import pe.restaurant.activos.repository.AfSubClaseRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.service.AfMatrizSubClaseService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfMatrizSubClaseServiceImpl implements AfMatrizSubClaseService {

    private final AfMatrizSubClaseRepository repository;
    private final AfSubClaseRepository subClaseRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "af_matriz_sub_clase", "operation", "findAll"})
    @Override
    public Page<AfMatrizSubClase> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_matriz_sub_clase", "operation", "findById"})
    @Override
    public AfMatrizSubClase findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Matriz contable por subclase", id));
    }

    @Override
    public java.util.Optional<AfMatrizSubClase> findBySubClaseId(Long afSubClaseId) {
        return repository.findByAfSubClaseId(afSubClaseId);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_matriz_sub_clase", "operation", "create"})
    @Override
    @Transactional
    public AfMatrizSubClase create(AfMatrizSubClase entity) {
        log.info("Creando matriz contable para subclase {}", entity.getAfSubClaseId());
        subClaseRepository.findById(entity.getAfSubClaseId())
                .orElseThrow(() -> new ResourceNotFoundException("Sub-clase", entity.getAfSubClaseId()));
        if (repository.existsByAfSubClaseId(entity.getAfSubClaseId())) {
            throw new BusinessException(
                    "Ya existe matriz contable para la subclase indicada",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.MATRIZ_SUB_CLASE_DUPLICADA);
        }
        validarCuentasPlan(entity);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_matriz_sub_clase", "operation", "update"})
    @Override
    @Transactional
    public AfMatrizSubClase update(Long id, AfMatrizSubClase entity) {
        log.info("Actualizando matriz contable id {}", id);
        AfMatrizSubClase existing = findById(id);
        if (!existing.getAfSubClaseId().equals(entity.getAfSubClaseId())
                && repository.existsByAfSubClaseId(entity.getAfSubClaseId())) {
            throw new BusinessException(
                    "Ya existe matriz contable para la subclase indicada",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.MATRIZ_SUB_CLASE_DUPLICADA);
        }
        subClaseRepository.findById(entity.getAfSubClaseId())
                .orElseThrow(() -> new ResourceNotFoundException("Sub-clase", entity.getAfSubClaseId()));
        validarCuentasPlan(entity);
        existing.setAfSubClaseId(entity.getAfSubClaseId());
        existing.setCuentaActivoId(entity.getCuentaActivoId());
        existing.setCuentaDepAcumId(entity.getCuentaDepAcumId());
        existing.setCuentaGastoDepId(entity.getCuentaGastoDepId());
        existing.setCuentaBajaId(entity.getCuentaBajaId());
        existing.setCuentaResVentaId(entity.getCuentaResVentaId());
        existing.setCentroCostoId(entity.getCentroCostoId());
        existing.setCuentaGastoSeguroId(entity.getCuentaGastoSeguroId());
        existing.setCuentaPasivoSeguroId(entity.getCuentaPasivoSeguroId());
        existing.setCuentaProveedorTransitoriaId(entity.getCuentaProveedorTransitoriaId());
        existing.setCuentaCapitalizacionId(entity.getCuentaCapitalizacionId());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_matriz_sub_clase", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        AfMatrizSubClase existing = findById(id);
        repository.delete(existing);
    }

    private void validarCuentasPlan(AfMatrizSubClase entity) {
        validarCuenta(entity.getCuentaActivoId());
        validarCuenta(entity.getCuentaDepAcumId());
        validarCuenta(entity.getCuentaGastoDepId());
        validarCuenta(entity.getCuentaBajaId());
        validarCuenta(entity.getCuentaResVentaId());
        validarCuenta(entity.getCuentaGastoSeguroId());
        validarCuenta(entity.getCuentaPasivoSeguroId());
        validarCuenta(entity.getCuentaProveedorTransitoriaId());
        validarCuenta(entity.getCuentaCapitalizacionId());
    }

    private void validarCuenta(Long cuentaId) {
        if (cuentaId == null) {
            return;
        }
        try {
            if (repository.countPlanContableDetActivo(cuentaId) < 1) {
                throw new BusinessException(
                        "La cuenta del plan contable no existe o no está activa: " + cuentaId,
                        HttpStatus.UNPROCESSABLE_ENTITY,
                        ActivosErrorCodes.CUENTA_PLAN_NO_ACTIVA);
            }
        } catch (DataAccessException e) {
            log.warn("No se pudo validar cuenta {} contra contabilidad.plan_contable_det: {}", cuentaId, e.getMessage());
            throw new BusinessException(
                    "No se pudo validar la cuenta contable (verifique esquema contabilidad en el tenant): " + cuentaId,
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ActivosErrorCodes.CUENTA_PLAN_NO_ACTIVA);
        }
    }
}
