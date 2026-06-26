package pe.restaurant.ventas.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.EntidadCreditosCxcRequest;
import pe.restaurant.ventas.entity.EntidadCreditosCxc;
import pe.restaurant.ventas.repository.EntidadCreditosCxcRepository;
import pe.restaurant.ventas.repository.VentasFkValidator;
import pe.restaurant.ventas.service.EntidadCreditosCxcService;
import pe.restaurant.ventas.service.VentasErrorCodes;
import pe.restaurant.ventas.specification.EntidadCreditosCxcSpecifications;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class EntidadCreditosCxcServiceImpl implements EntidadCreditosCxcService {

    private final EntidadCreditosCxcRepository repository;
    private final VentasFkValidator fkValidator;

    @Override
    public Page<EntidadCreditosCxc> findAll(Long entidadContribuyenteId, Long monedaId, String flagEstado, Pageable pageable) {
        return repository.findAll(
                EntidadCreditosCxcSpecifications.filtered(entidadContribuyenteId, monedaId, flagEstado),
                pageable);
    }

    @Override
    public EntidadCreditosCxc findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("EntidadCreditosCxc", id));
    }

    @Override
    @Transactional
    public EntidadCreditosCxc create(EntidadCreditosCxcRequest request) {
        Long uid = requireUsuario();
        validarFk(request);
        validarMontos(request.getLimiteCredito(), request.getDiasCredito());
        if (repository.existsActiveDuplicate(request.getEntidadContribuyenteId(), request.getMonedaId(), null)) {
            throw new BusinessException("Ya existe un registro activo para la misma entidad y moneda",
                    HttpStatus.CONFLICT, VentasErrorCodes.CREDITOS_CXC_DUPLICATE);
        }
        EntidadCreditosCxc e = new EntidadCreditosCxc();
        e.setEntidadContribuyenteId(request.getEntidadContribuyenteId());
        e.setMonedaId(request.getMonedaId());
        e.setLimiteCredito(request.getLimiteCredito());
        e.setDiasCredito(request.getDiasCredito());
        e.setCreatedBy(uid);
        e.setFlagEstado("1");
        return repository.save(e);
    }

    @Override
    @Transactional
    public EntidadCreditosCxc update(Long id, EntidadCreditosCxcRequest request) {
        Long uid = requireUsuario();
        validarFk(request);
        validarMontos(request.getLimiteCredito(), request.getDiasCredito());
        if (repository.existsActiveDuplicate(request.getEntidadContribuyenteId(), request.getMonedaId(), id)) {
            throw new BusinessException("Ya existe otro registro activo para la misma entidad y moneda",
                    HttpStatus.CONFLICT, VentasErrorCodes.CREDITOS_CXC_DUPLICATE);
        }
        EntidadCreditosCxc e = findById(id);
        e.setEntidadContribuyenteId(request.getEntidadContribuyenteId());
        e.setMonedaId(request.getMonedaId());
        e.setLimiteCredito(request.getLimiteCredito());
        e.setDiasCredito(request.getDiasCredito());
        e.setUpdatedBy(uid);
        return repository.save(e);
    }

    @Override
    @Transactional
    public EntidadCreditosCxc activar(Long id) {
        EntidadCreditosCxc e = findById(id);
        e.setFlagEstado("1");
        e.setUpdatedBy(requireUsuario());
        return repository.save(e);
    }

    @Override
    @Transactional
    public EntidadCreditosCxc desactivar(Long id) {
        EntidadCreditosCxc e = findById(id);
        e.setFlagEstado("0");
        e.setUpdatedBy(requireUsuario());
        return repository.save(e);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        desactivar(id);
    }

    private void validarFk(EntidadCreditosCxcRequest request) {
        if (!fkValidator.existsEntidadContribuyenteActiva(request.getEntidadContribuyenteId())) {
            throw new BusinessException("Entidad contribuyente no válida",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CREDITOS_CXC_FK);
        }
        if (request.getMonedaId() != null && !fkValidator.existsMonedaActiva(request.getMonedaId())) {
            throw new BusinessException("Moneda no válida", HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CREDITOS_CXC_FK);
        }
    }

    private static void validarMontos(BigDecimal limite, Integer dias) {
        if (limite != null && limite.compareTo(BigDecimal.ZERO) < 0) {
            throw new BusinessException("limiteCredito no puede ser negativo",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CREDITOS_CXC_VALIDATION);
        }
        if (dias != null && dias < 0) {
            throw new BusinessException("diasCredito no puede ser negativo",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CREDITOS_CXC_VALIDATION);
        }
    }

    private static Long requireUsuario() {
        Long uid = TenantContext.getUsuarioId();
        if (uid == null) {
            throw new BusinessException("Usuario no disponible en el contexto",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.CREDITOS_CXC_VALIDATION);
        }
        return uid;
    }
}
