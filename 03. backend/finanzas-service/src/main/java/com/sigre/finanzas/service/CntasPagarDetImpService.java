package com.sigre.finanzas.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.security.TenantContext;
import com.sigre.finanzas.dto.request.DetImpuestoRequest;
import com.sigre.finanzas.dto.response.DetImpuestoResponse;
import com.sigre.finanzas.entity.CntasPagarDet;
import com.sigre.finanzas.entity.CntasPagarDetImp;
import com.sigre.finanzas.repository.CntasPagarDetImpRepository;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CntasPagarDetImpService {

    private final CntasPagarDetImpRepository repository;

    @Transactional
    public void eliminarPorCntasPagarId(Long cxpId) {
        repository.deleteByCntasPagarId(cxpId);
    }

    @Transactional
    public void guardarImpuestos(CntasPagarDet detalle, List<DetImpuestoRequest> impuestos) {
        if (impuestos == null || impuestos.isEmpty()) {
            return;
        }
        Long usuarioId = TenantContext.getUsuarioId();
        for (DetImpuestoRequest req : impuestos) {
            CntasPagarDetImp imp = new CntasPagarDetImp();
            imp.setCntasPagarDet(detalle);
            imp.setTiposImpuestoId(req.getTiposImpuestoId());
            imp.setImporte(req.getImporte() != null ? req.getImporte() : BigDecimal.ZERO);
            imp.setCreatedBy(usuarioId);
            imp.setFecCreacion(Instant.now());
            repository.save(imp);
        }
    }

    public List<DetImpuestoResponse> listarPorDetalle(Long detalleId) {
        return repository.findByCntasPagarDetId(detalleId).stream()
                .map(this::toResponse)
                .toList();
    }

    public Map<Long, List<DetImpuestoResponse>> listarPorDetalles(List<Long> detalleIds) {
        if (detalleIds == null || detalleIds.isEmpty()) {
            return Collections.emptyMap();
        }
        return repository.findByCntasPagarDetIdIn(detalleIds).stream()
                .collect(Collectors.groupingBy(
                        imp -> imp.getCntasPagarDet().getId(),
                        Collectors.mapping(this::toResponse, Collectors.toList())));
    }

    private DetImpuestoResponse toResponse(CntasPagarDetImp entity) {
        DetImpuestoResponse response = new DetImpuestoResponse();
        response.setId(entity.getId());
        response.setTiposImpuestoId(entity.getTiposImpuestoId());
        response.setImporte(entity.getImporte());
        return response;
    }
}
