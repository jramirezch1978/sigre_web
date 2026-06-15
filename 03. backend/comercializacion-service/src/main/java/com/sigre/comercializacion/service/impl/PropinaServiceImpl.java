package com.sigre.comercializacion.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.PropinaRequest;
import com.sigre.comercializacion.entity.Propina;
import com.sigre.comercializacion.repository.FsFacturaSimplRepository;
import com.sigre.comercializacion.repository.PropinaRepository;
import com.sigre.comercializacion.repository.VentasFkValidator;
import com.sigre.comercializacion.service.PropinaService;
import com.sigre.comercializacion.service.VentasErrorCodes;
import com.sigre.comercializacion.specification.PropinaSpecifications;

import java.time.LocalDate;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PropinaServiceImpl implements PropinaService {

    private final PropinaRepository repository;
    private final FsFacturaSimplRepository facturaRepository;
    private final VentasFkValidator fkValidator;

    @Override
    public Page<Propina> findAll(Long fsFacturaSimplId, Long trabajadorId, LocalDate fechaDesde,
                                 LocalDate fechaHasta, String flagEstado, Pageable pageable) {
        return repository.findAll(
                PropinaSpecifications.filtered(fsFacturaSimplId, trabajadorId, fechaDesde, fechaHasta, flagEstado),
                pageable);
    }

    @Override
    public Propina findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Propina", id));
    }

    @Override
    @Transactional
    public Propina create(PropinaRequest request) {
        Long uid = requireUsuario();
        validateFacturaActiva(request.getFsFacturaSimplId());
        validateTrabajador(request.getTrabajadorId());
        validateFechaNoFutura(request.getFecha());

        Propina p = new Propina();
        p.setFsFacturaSimplId(request.getFsFacturaSimplId());
        p.setTrabajadorId(request.getTrabajadorId());
        p.setMonto(request.getMonto());
        p.setFecha(request.getFecha());
        p.setCreatedBy(uid);
        p.setFlagEstado("1");
        return repository.save(p);
    }

    @Override
    @Transactional
    public Propina update(Long id, PropinaRequest request) {
        Long uid = requireUsuario();
        Propina p = findById(id);
        validateFacturaActiva(request.getFsFacturaSimplId());
        validateTrabajador(request.getTrabajadorId());
        validateFechaNoFutura(request.getFecha());

        p.setFsFacturaSimplId(request.getFsFacturaSimplId());
        p.setTrabajadorId(request.getTrabajadorId());
        p.setMonto(request.getMonto());
        p.setFecha(request.getFecha());
        p.setUpdatedBy(uid);
        return repository.save(p);
    }

    @Override
    @Transactional
    public Propina activar(Long id) {
        Propina p = findById(id);
        p.setFlagEstado("1");
        p.setUpdatedBy(requireUsuario());
        return repository.save(p);
    }

    @Override
    @Transactional
    public Propina desactivar(Long id) {
        Propina p = findById(id);
        p.setFlagEstado("0");
        p.setUpdatedBy(requireUsuario());
        return repository.save(p);
    }

    private void validateFacturaActiva(Long fsId) {
        if (!facturaRepository.existsByIdAndNotAnulada(fsId)) {
            throw new BusinessException("La factura simplificada no existe o está anulada/inactiva",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.PROPINA_FK);
        }
    }

    private void validateTrabajador(Long trabajadorId) {
        if (trabajadorId == null) {
            return;
        }
        if (!fkValidator.existsTrabajadorActivo(trabajadorId)) {
            throw new BusinessException("Trabajador no válido o inactivo",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.PROPINA_FK);
        }
    }

    private static void validateFechaNoFutura(LocalDate fecha) {
        if (fecha.isAfter(LocalDate.now())) {
            throw new BusinessException("La fecha de propina no puede ser futura",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.PROPINA_VALIDATION);
        }
    }

    private static Long requireUsuario() {
        Long uid = TenantContext.getUsuarioId();
        if (uid == null) {
            throw new BusinessException("Usuario no disponible en el contexto",
                    HttpStatus.UNPROCESSABLE_ENTITY, VentasErrorCodes.PROPINA_VALIDATION);
        }
        return uid;
    }
}
