package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfAdaptacionDepRequest;
import pe.restaurant.activos.dto.AfAdaptacionDepResponse;
import pe.restaurant.activos.entity.AfAdaptacionDep;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfAdaptacionDepMapperTest {

    private final AfAdaptacionDepMapper mapper = Mappers.getMapper(AfAdaptacionDepMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfAdaptacionDep entity = new AfAdaptacionDep();
        entity.setId(1L);
        entity.setAfAdaptacionId(10L);
        entity.setAnio(2025);
        entity.setMes(6);
        entity.setDepreciacionPeriodo(new BigDecimal("1500.5000"));
        entity.setDepreciacionAcumulada(new BigDecimal("9000.0000"));
        entity.setFlagEstado("1");

        AfAdaptacionDepResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfAdaptacionId()).isEqualTo(10L);
        assertThat(response.getAnio()).isEqualTo(2025);
        assertThat(response.getMes()).isEqualTo(6);
        assertThat(response.getDepreciacionPeriodo()).isEqualByComparingTo(new BigDecimal("1500.5000"));
        assertThat(response.getDepreciacionAcumulada()).isEqualByComparingTo(new BigDecimal("9000.0000"));
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfAdaptacionDep e1 = new AfAdaptacionDep();
        e1.setId(1L);
        e1.setAfAdaptacionId(10L);

        AfAdaptacionDep e2 = new AfAdaptacionDep();
        e2.setId(2L);
        e2.setAfAdaptacionId(20L);

        List<AfAdaptacionDepResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        assertThat(result.get(1).getId()).isEqualTo(2L);
    }

    @Test
    void toEntity_mapsAllFields() {
        AfAdaptacionDepRequest request = new AfAdaptacionDepRequest();
        request.setAfAdaptacionId(10L);
        request.setAnio(2025);
        request.setMes(6);
        request.setDepreciacionPeriodo(new BigDecimal("1500.5000"));
        request.setDepreciacionAcumulada(new BigDecimal("9000.0000"));

        AfAdaptacionDep entity = mapper.toEntity(request);

        assertThat(entity.getAfAdaptacionId()).isEqualTo(10L);
        assertThat(entity.getAnio()).isEqualTo(2025);
        assertThat(entity.getMes()).isEqualTo(6);
        assertThat(entity.getDepreciacionPeriodo()).isEqualByComparingTo(new BigDecimal("1500.5000"));
        assertThat(entity.getDepreciacionAcumulada()).isEqualByComparingTo(new BigDecimal("9000.0000"));
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfAdaptacionDep entity = new AfAdaptacionDep();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setAfAdaptacionId(1L);

        AfAdaptacionDepRequest request = new AfAdaptacionDepRequest();
        request.setAfAdaptacionId(50L);
        request.setAnio(2026);
        request.setMes(3);
        request.setDepreciacionPeriodo(new BigDecimal("200.0000"));
        request.setDepreciacionAcumulada(new BigDecimal("600.0000"));

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getAfAdaptacionId()).isEqualTo(50L);
        assertThat(entity.getAnio()).isEqualTo(2026);
        assertThat(entity.getMes()).isEqualTo(3);
        assertThat(entity.getDepreciacionPeriodo()).isEqualByComparingTo(new BigDecimal("200.0000"));
        assertThat(entity.getDepreciacionAcumulada()).isEqualByComparingTo(new BigDecimal("600.0000"));
    }
}
