package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfCalculoCntblRequest;
import pe.restaurant.activos.dto.AfCalculoCntblResponse;
import pe.restaurant.activos.entity.AfCalculoCntbl;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfCalculoCntblMapperTest {

    private final AfCalculoCntblMapper mapper = Mappers.getMapper(AfCalculoCntblMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfCalculoCntbl entity = new AfCalculoCntbl();
        entity.setId(1L);
        entity.setAfMaestroId(10L);
        entity.setAnio(2025);
        entity.setMes(6);
        entity.setDepreciacionPeriodo(new BigDecimal("500.0000"));
        entity.setDepreciacionAcumulada(new BigDecimal("3000.0000"));
        entity.setValorNeto(new BigDecimal("47000.0000"));
        entity.setCntblAsientoId(100L);
        entity.setFlagEstado("1");

        AfCalculoCntblResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfMaestroId()).isEqualTo(10L);
        assertThat(response.getAnio()).isEqualTo(2025);
        assertThat(response.getMes()).isEqualTo(6);
        assertThat(response.getDepreciacionPeriodo()).isEqualByComparingTo(new BigDecimal("500.0000"));
        assertThat(response.getDepreciacionAcumulada()).isEqualByComparingTo(new BigDecimal("3000.0000"));
        assertThat(response.getValorNeto()).isEqualByComparingTo(new BigDecimal("47000.0000"));
        assertThat(response.getCntblAsientoId()).isEqualTo(100L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfCalculoCntbl e1 = new AfCalculoCntbl();
        e1.setId(1L);
        AfCalculoCntbl e2 = new AfCalculoCntbl();
        e2.setId(2L);

        List<AfCalculoCntblResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        assertThat(result.get(1).getId()).isEqualTo(2L);
    }

    @Test
    void toEntity_mapsAllFields() {
        AfCalculoCntblRequest request = new AfCalculoCntblRequest();
        request.setAfMaestroId(10L);
        request.setAnio(2025);
        request.setMes(6);
        request.setDepreciacionPeriodo(new BigDecimal("500.0000"));
        request.setDepreciacionAcumulada(new BigDecimal("3000.0000"));
        request.setValorNeto(new BigDecimal("47000.0000"));

        AfCalculoCntbl entity = mapper.toEntity(request);

        assertThat(entity.getAfMaestroId()).isEqualTo(10L);
        assertThat(entity.getAnio()).isEqualTo(2025);
        assertThat(entity.getMes()).isEqualTo(6);
        assertThat(entity.getDepreciacionPeriodo()).isEqualByComparingTo(new BigDecimal("500.0000"));
        assertThat(entity.getDepreciacionAcumulada()).isEqualByComparingTo(new BigDecimal("3000.0000"));
        assertThat(entity.getValorNeto()).isEqualByComparingTo(new BigDecimal("47000.0000"));
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfCalculoCntbl entity = new AfCalculoCntbl();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setAfMaestroId(1L);

        AfCalculoCntblRequest request = new AfCalculoCntblRequest();
        request.setAfMaestroId(50L);
        request.setAnio(2026);
        request.setMes(1);
        request.setDepreciacionPeriodo(new BigDecimal("600.0000"));
        request.setDepreciacionAcumulada(new BigDecimal("3600.0000"));
        request.setValorNeto(new BigDecimal("46400.0000"));

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getAfMaestroId()).isEqualTo(50L);
        assertThat(entity.getAnio()).isEqualTo(2026);
        assertThat(entity.getMes()).isEqualTo(1);
        assertThat(entity.getDepreciacionPeriodo()).isEqualByComparingTo(new BigDecimal("600.0000"));
        assertThat(entity.getDepreciacionAcumulada()).isEqualByComparingTo(new BigDecimal("3600.0000"));
        assertThat(entity.getValorNeto()).isEqualByComparingTo(new BigDecimal("46400.0000"));
    }
}
