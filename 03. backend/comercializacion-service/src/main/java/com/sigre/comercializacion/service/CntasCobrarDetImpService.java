package com.sigre.comercializacion.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.DetImpuestoRequest;
import com.sigre.comercializacion.dto.response.DetImpuestoResponse;
import com.sigre.comercializacion.entity.CntasCobrarDetImp;
import com.sigre.comercializacion.entity.CuentaCobrarDet;
import com.sigre.comercializacion.repository.CntasCobrarDetImpRepository;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CntasCobrarDetImpService {

    private final CntasCobrarDetImpRepository repository;

    @Transactional
    public void guardarImpuestos(CuentaCobrarDet detalle, List<DetImpuestoRequest> impuestos) {
        if (impuestos == null || impuestos.isEmpty()) {
            return;
        }
        Long usuarioId = TenantContext.getUsuarioId();
        for (DetImpuestoRequest req : impuestos) {
            CntasCobrarDetImp imp = new CntasCobrarDetImp();
            imp.setCntasCobrarDet(detalle);
            imp.setTiposImpuestoId(req.getTiposImpuestoId());
            imp.setImporte(req.getImporte() != null ? req.getImporte() : BigDecimal.ZERO);
            imp.setCreatedBy(usuarioId);
            imp.setFecCreacion(Instant.now());
            repository.save(imp);
        }
    }

    public List<DetImpuestoResponse> listarPorDetalle(Long detalleId) {
        return repository.findByCntasCobrarDetId(detalleId).stream()
                .map(this::toResponse)
                .toList();
    }

    public Map<Long, List<DetImpuestoResponse>> listarPorDetalles(List<Long> detalleIds) {
        if (detalleIds == null || detalleIds.isEmpty()) {
            return Collections.emptyMap();
        }
        return repository.findByCntasCobrarDetIdIn(detalleIds).stream()
                .collect(Collectors.groupingBy(
                        imp -> imp.getCntasCobrarDet().getId(),
                        Collectors.mapping(this::toResponse, Collectors.toList())));
    }

    private DetImpuestoResponse toResponse(CntasCobrarDetImp entity) {
        DetImpuestoResponse response = new DetImpuestoResponse();
        response.setId(entity.getId());
        response.setTiposImpuestoId(entity.getTiposImpuestoId());
        response.setImporte(entity.getImporte());
        return response;
    }
}
