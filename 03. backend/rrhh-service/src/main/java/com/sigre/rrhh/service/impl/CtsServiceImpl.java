package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import jakarta.persistence.criteria.Predicate;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.CtsProcesarRequest;
import com.sigre.rrhh.dto.response.CtsResponse;
import com.sigre.rrhh.entity.Cts;
import com.sigre.rrhh.mapper.CtsMapper;
import com.sigre.rrhh.repository.CtsRepository;
import com.sigre.rrhh.repository.PeriodoCtsRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;
import com.sigre.rrhh.service.CtsService;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CtsServiceImpl implements CtsService {

    private static final int MESES_SEMESTRE = 6;
    private static final int DIAS_ANIO = 360;

    private final CtsRepository repository;
    private final CtsMapper mapper;
    private final PeriodoCtsRepository periodoRepository;
    private final TrabajadorRepository trabajadorRepository;

    @Override
    @Transactional
    @Timed("rrhh.cts.procesar")
    public List<CtsResponse> procesar(CtsProcesarRequest request) {
        log.info("Procesando CTS - anio: {}, periodo: {}", request.getAnio(), request.getPeriodoCtsId());
        periodoRepository.findById(request.getPeriodoCtsId())
                .orElseThrow(() -> new BusinessException("Período CTS no encontrado.", HttpStatus.NOT_FOUND, "RH-CT-002"));

        List<Long> trabajadoresIds = trabajadorRepository.findActivosIds();
        if (trabajadoresIds.isEmpty()) {
            throw new BusinessException("No hay trabajadores activos.", HttpStatus.BAD_REQUEST, "RH-CT-003");
        }

        Long usuarioId = TenantContext.getUsuarioId();
        for (Long tid : trabajadoresIds) {
            BigDecimal rem = repository.findRemuneracionByTrabajadorId(tid);
            if (rem == null || rem.compareTo(BigDecimal.ZERO) <= 0) continue;
            
            int meses = MESES_SEMESTRE;
            int dias = 0;
            BigDecimal montoCts = rem.multiply(BigDecimal.valueOf(meses))
                    .divide(BigDecimal.valueOf(12), 4, RoundingMode.HALF_UP);
            
            // Buscar registro existente o crear nuevo
            Cts cts = repository.findByTrabajadorIdAndAnioAndPeriodoCtsId(tid, request.getAnio(), request.getPeriodoCtsId())
                    .orElse(new Cts());
            
            cts.setTrabajadorId(tid);
            cts.setAnio(request.getAnio());
            cts.setPeriodoCtsId(request.getPeriodoCtsId());
            cts.setRemuneracionComputable(rem);
            cts.setMesesComputables(meses);
            cts.setDiasComputables(dias);
            cts.setMontoCts(montoCts);
            
            // Asignar fechas de auditoría manualmente
            if (cts.getId() == null) {
                cts.setCreatedBy(usuarioId);
                cts.setFecCreacion(java.time.Instant.now());
            } else {
                cts.setUpdatedBy(usuarioId);
                cts.setFecModificacion(java.time.Instant.now());
            }
            
            repository.save(cts);
        }

        return mapper.toResponseList(repository.findAll(especificacion(null, request.getAnio(), request.getPeriodoCtsId())));
    }

    @Override @Timed("rrhh.cts.listar")
    public Page<CtsResponse> listar(Long trabajadorId, Integer anio, Long periodoCtsId, Pageable pageable) {
        return repository.findAll(especificacion(trabajadorId, anio, periodoCtsId), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.cts.obtener")
    public CtsResponse obtenerPorId(Long id) {
        return mapper.toResponse(repository.findById(id)
                .orElseThrow(() -> new BusinessException("CTS no encontrado.", HttpStatus.NOT_FOUND, "RH-CT-004")));
    }

    private Specification<Cts> especificacion(Long trabajadorId, Integer anio, Long periodoCtsId) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (trabajadorId != null) predicates.add(cb.equal(root.get("trabajadorId"), trabajadorId));
            if (anio != null) predicates.add(cb.equal(root.get("anio"), anio));
            if (periodoCtsId != null) predicates.add(cb.equal(root.get("periodoCtsId"), periodoCtsId));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
