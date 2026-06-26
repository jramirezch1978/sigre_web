package pe.restaurant.activos.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfTipoOperacion;
import pe.restaurant.activos.repository.AfMatrizSubClaseRepository;
import pe.restaurant.activos.repository.AfTipoOperacionRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.service.AfTipoOperacionService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfTipoOperacionServiceImpl implements AfTipoOperacionService {

    private final AfTipoOperacionRepository repository;
    private final AfMatrizSubClaseRepository matrizRepository;

    @Override
    public Page<AfTipoOperacion> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Override
    public AfTipoOperacion findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Tipo de operación", id));
    }

    @Override
    @Transactional
    public AfTipoOperacion create(AfTipoOperacion entity) {
        validarCodigoUnico(entity.getCodigo(), null);
        validarCuenta(entity.getCuentaContableId());
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public AfTipoOperacion update(Long id, AfTipoOperacion entity) {
        AfTipoOperacion existing = findById(id);
        validarCodigoUnico(entity.getCodigo(), id);
        validarCuenta(entity.getCuentaContableId());
        existing.setCodigo(entity.getCodigo());
        existing.setDescripcion(entity.getDescripcion());
        existing.setNaturaleza(entity.getNaturaleza());
        existing.setTipoCalculo(entity.getTipoCalculo());
        existing.setCuentaContableId(entity.getCuentaContableId());
        existing.setCentroCostoId(entity.getCentroCostoId());
        existing.setAfectaContabilidad(entity.getAfectaContabilidad());
        existing.setMetodoCalculo(entity.getMetodoCalculo());
        existing.setObservaciones(entity.getObservaciones());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(existing);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        repository.delete(findById(id));
    }

    @Override
    @Transactional
    public AfTipoOperacion activate(Long id) {
        AfTipoOperacion e = findById(id);
        e.setFlagEstado(ActivosFlagEstado.ACTIVO);
        e.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(e);
    }

    @Override
    @Transactional
    public AfTipoOperacion deactivate(Long id) {
        AfTipoOperacion e = findById(id);
        e.setFlagEstado(ActivosFlagEstado.INACTIVO);
        e.setUpdatedBy(TenantContext.getUsuarioId());
        return repository.save(e);
    }

    private void validarCodigoUnico(String codigo, Long excludeId) {
        boolean dup = excludeId == null
                ? repository.existsByCodigoIgnoreCase(codigo)
                : repository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (dup) {
            throw new BusinessException(
                    "Código de tipo de operación duplicado",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.TIPO_OPERACION_CODIGO_DUPLICADO);
        }
    }

    private void validarCuenta(Long cuentaId) {
        if (cuentaId != null && matrizRepository.countPlanContableDetActivo(cuentaId) == 0) {
            throw new BusinessException(
                    "Cuenta contable no activa en el plan del tenant",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.CUENTA_PLAN_NO_ACTIVA);
        }
    }
}
