package com.sigre.rrhh.mapper;

import org.springframework.stereotype.Component;
import com.sigre.rrhh.dto.response.EvaluacionDesempenoResponse;
import com.sigre.rrhh.entity.EvaluacionDesempeno;
import java.time.ZoneOffset;

@Component
public class EvaluacionDesempenoMapper {

    public EvaluacionDesempenoResponse toResponse(EvaluacionDesempeno e) {
        if (e == null) return null;
        EvaluacionDesempenoResponse r = new EvaluacionDesempenoResponse();
        r.setId(e.getId());
        r.setTrabajadorId(e.getTrabajadorId());
        r.setPeriodoAnio(e.getPeriodoAnio());
        r.setPeriodoSemestre(e.getPeriodoSemestre());
        r.setCalificacion(e.getCalificacion());
        r.setObservaciones(e.getObservaciones());
        r.setEvaluadorId(e.getEvaluadorId());
        r.setFechaEvaluacion(e.getFechaEvaluacion() != null ? e.getFechaEvaluacion().toString() : null);
        r.setCreatedBy(e.getCreatedBy());
        r.setFecCreacion(e.getFecCreacion() != null ? e.getFecCreacion().atOffset(ZoneOffset.UTC) : null);
        r.setUpdatedBy(e.getUpdatedBy());
        r.setFecModificacion(e.getFecModificacion() != null ? e.getFecModificacion().atOffset(ZoneOffset.UTC) : null);
        return r;
    }
}
