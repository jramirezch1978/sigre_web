package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfValuacionRequest;
import pe.restaurant.activos.dto.AfValuacionResponse;
import pe.restaurant.activos.entity.AfValuacion;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfValuacionMapperTest {

    private final AfValuacionMapper mapper = Mappers.getMapper(AfValuacionMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfValuacion entity = new AfValuacion();
        entity.setId(1L);
        entity.setAfMaestroId(10L);
        entity.setFechaValuacion(LocalDate.of(2025, 6, 30));
        entity.setValorAnterior(new BigDecimal("50000.00"));
        entity.setValorNuevo(new BigDecimal("55000.00"));
        entity.setMetodoValuacion("PERITO_TASADOR");
        entity.setResponsableId(5L);
        entity.setObservaciones("Revaluación anual");
        entity.setFechaAprobacion(LocalDate.of(2025, 7, 5));
        entity.setAprobadorId(6L);
        entity.setEstado("APROBADO");
        entity.setTipoRevaluacion("MEJORA");
        entity.setFuenteRevaluacion("PERITO_EXTERNO");
        entity.setFactorRevaluacion(new BigDecimal("1.100000"));
        entity.setDocumentoSoporte("INF-2025-0045");
        entity.setNuevaVidaUtil(96);
        entity.setValorResidual(new BigDecimal("5000.0000"));

        AfValuacionResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfMaestroId()).isEqualTo(10L);
        assertThat(response.getFechaValuacion()).isEqualTo(LocalDate.of(2025, 6, 30));
        assertThat(response.getValorAnterior()).isEqualByComparingTo(new BigDecimal("50000.00"));
        assertThat(response.getValorNuevo()).isEqualByComparingTo(new BigDecimal("55000.00"));
        assertThat(response.getMetodoValuacion()).isEqualTo("PERITO_TASADOR");
        assertThat(response.getResponsableId()).isEqualTo(5L);
        assertThat(response.getObservaciones()).isEqualTo("Revaluación anual");
        assertThat(response.getFechaAprobacion()).isEqualTo(LocalDate.of(2025, 7, 5));
        assertThat(response.getAprobadorId()).isEqualTo(6L);
        assertThat(response.getEstado()).isEqualTo("APROBADO");
        assertThat(response.getTipoRevaluacion()).isEqualTo("MEJORA");
        assertThat(response.getFuenteRevaluacion()).isEqualTo("PERITO_EXTERNO");
        assertThat(response.getFactorRevaluacion()).isEqualByComparingTo(new BigDecimal("1.100000"));
        assertThat(response.getDocumentoSoporte()).isEqualTo("INF-2025-0045");
        assertThat(response.getNuevaVidaUtil()).isEqualTo(96);
        assertThat(response.getValorResidual()).isEqualByComparingTo(new BigDecimal("5000.0000"));
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfValuacion e1 = new AfValuacion();
        e1.setId(1L);
        e1.setEstado("EN_PROCESO");
        AfValuacion e2 = new AfValuacion();
        e2.setId(2L);
        e2.setEstado("APROBADO");

        List<AfValuacionResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getEstado()).isEqualTo("EN_PROCESO");
        assertThat(result.get(1).getEstado()).isEqualTo("APROBADO");
    }

    @Test
    void toEntity_mapsAllFields() {
        AfValuacionRequest request = new AfValuacionRequest();
        request.setAfMaestroId(10L);
        request.setFechaValuacion(LocalDate.of(2025, 6, 30));
        request.setValorAnterior(new BigDecimal("50000.00"));
        request.setValorNuevo(new BigDecimal("55000.00"));
        request.setMetodoValuacion("PERITO_TASADOR");
        request.setResponsableId(5L);
        request.setObservaciones("Revaluación anual");
        request.setFechaAprobacion(LocalDate.of(2025, 7, 5));
        request.setAprobadorId(6L);
        request.setTipoRevaluacion("MEJORA");
        request.setFuenteRevaluacion("PERITO_EXTERNO");
        request.setFactorRevaluacion(new BigDecimal("1.100000"));
        request.setDocumentoSoporte("INF-2025-0045");
        request.setNuevaVidaUtil(96);
        request.setValorResidual(new BigDecimal("5000.0000"));

        AfValuacion entity = mapper.toEntity(request);

        assertThat(entity.getAfMaestroId()).isEqualTo(10L);
        assertThat(entity.getFechaValuacion()).isEqualTo(LocalDate.of(2025, 6, 30));
        assertThat(entity.getValorAnterior()).isEqualByComparingTo(new BigDecimal("50000.00"));
        assertThat(entity.getValorNuevo()).isEqualByComparingTo(new BigDecimal("55000.00"));
        assertThat(entity.getMetodoValuacion()).isEqualTo("PERITO_TASADOR");
        assertThat(entity.getResponsableId()).isEqualTo(5L);
        assertThat(entity.getObservaciones()).isEqualTo("Revaluación anual");
        assertThat(entity.getFechaAprobacion()).isEqualTo(LocalDate.of(2025, 7, 5));
        assertThat(entity.getAprobadorId()).isEqualTo(6L);
        assertThat(entity.getTipoRevaluacion()).isEqualTo("MEJORA");
        assertThat(entity.getFuenteRevaluacion()).isEqualTo("PERITO_EXTERNO");
        assertThat(entity.getFactorRevaluacion()).isEqualByComparingTo(new BigDecimal("1.100000"));
        assertThat(entity.getDocumentoSoporte()).isEqualTo("INF-2025-0045");
        assertThat(entity.getNuevaVidaUtil()).isEqualTo(96);
        assertThat(entity.getValorResidual()).isEqualByComparingTo(new BigDecimal("5000.0000"));
        assertThat(entity.getId()).isNull();
        assertThat(entity.getEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfValuacion entity = new AfValuacion();
        entity.setId(99L);
        entity.setEstado("EN_PROCESO");
        entity.setAfMaestroId(1L);

        AfValuacionRequest request = new AfValuacionRequest();
        request.setAfMaestroId(50L);
        request.setFechaValuacion(LocalDate.of(2026, 1, 15));
        request.setValorAnterior(new BigDecimal("60000.00"));
        request.setValorNuevo(new BigDecimal("70000.00"));
        request.setMetodoValuacion("COSTO_REPOSICION");
        request.setResponsableId(8L);
        request.setObservaciones("Ajuste por inflación");
        request.setFechaAprobacion(LocalDate.of(2026, 1, 20));
        request.setAprobadorId(9L);
        request.setTipoRevaluacion("INFLACION");
        request.setFuenteRevaluacion("INDICE_OFICIAL");
        request.setFactorRevaluacion(new BigDecimal("1.050000"));
        request.setDocumentoSoporte("RES-2026-001");
        request.setNuevaVidaUtil(84);
        request.setValorResidual(new BigDecimal("7000.0000"));

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getEstado()).isEqualTo("EN_PROCESO");
        assertThat(entity.getAfMaestroId()).isEqualTo(50L);
        assertThat(entity.getFechaValuacion()).isEqualTo(LocalDate.of(2026, 1, 15));
        assertThat(entity.getValorAnterior()).isEqualByComparingTo(new BigDecimal("60000.00"));
        assertThat(entity.getValorNuevo()).isEqualByComparingTo(new BigDecimal("70000.00"));
        assertThat(entity.getMetodoValuacion()).isEqualTo("COSTO_REPOSICION");
        assertThat(entity.getResponsableId()).isEqualTo(8L);
        assertThat(entity.getObservaciones()).isEqualTo("Ajuste por inflación");
        assertThat(entity.getFechaAprobacion()).isEqualTo(LocalDate.of(2026, 1, 20));
        assertThat(entity.getAprobadorId()).isEqualTo(9L);
        assertThat(entity.getTipoRevaluacion()).isEqualTo("INFLACION");
        assertThat(entity.getFuenteRevaluacion()).isEqualTo("INDICE_OFICIAL");
        assertThat(entity.getFactorRevaluacion()).isEqualByComparingTo(new BigDecimal("1.050000"));
        assertThat(entity.getDocumentoSoporte()).isEqualTo("RES-2026-001");
        assertThat(entity.getNuevaVidaUtil()).isEqualTo(84);
        assertThat(entity.getValorResidual()).isEqualByComparingTo(new BigDecimal("7000.0000"));
    }
}
