package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfPolizaActivoRequest;
import pe.restaurant.activos.dto.AfPolizaActivoResponse;
import pe.restaurant.activos.entity.AfPolizaActivo;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfPolizaActivoMapperTest {

    private final AfPolizaActivoMapper mapper = Mappers.getMapper(AfPolizaActivoMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfPolizaActivo entity = new AfPolizaActivo();
        entity.setId(1L);
        entity.setAfPolizaSeguroId(10L);
        entity.setAfMaestroId(20L);
        entity.setValorAsegurado(new BigDecimal("75000.0000"));
        entity.setFlagEstado("1");

        AfPolizaActivoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfPolizaSeguroId()).isEqualTo(10L);
        assertThat(response.getAfMaestroId()).isEqualTo(20L);
        assertThat(response.getValorAsegurado()).isEqualByComparingTo(new BigDecimal("75000.0000"));
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfPolizaActivo e1 = new AfPolizaActivo();
        e1.setId(1L);
        e1.setAfMaestroId(10L);
        AfPolizaActivo e2 = new AfPolizaActivo();
        e2.setId(2L);
        e2.setAfMaestroId(20L);

        List<AfPolizaActivoResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getAfMaestroId()).isEqualTo(10L);
        assertThat(result.get(1).getAfMaestroId()).isEqualTo(20L);
    }

    @Test
    void toEntity_mapsAllFields() {
        AfPolizaActivoRequest request = new AfPolizaActivoRequest();
        request.setAfPolizaSeguroId(10L);
        request.setAfMaestroId(20L);
        request.setValorAsegurado(new BigDecimal("75000.0000"));

        AfPolizaActivo entity = mapper.toEntity(request);

        assertThat(entity.getAfPolizaSeguroId()).isEqualTo(10L);
        assertThat(entity.getAfMaestroId()).isEqualTo(20L);
        assertThat(entity.getValorAsegurado()).isEqualByComparingTo(new BigDecimal("75000.0000"));
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfPolizaActivo entity = new AfPolizaActivo();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setAfMaestroId(1L);

        AfPolizaActivoRequest request = new AfPolizaActivoRequest();
        request.setAfPolizaSeguroId(50L);
        request.setAfMaestroId(60L);
        request.setValorAsegurado(new BigDecimal("120000.0000"));

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getAfPolizaSeguroId()).isEqualTo(50L);
        assertThat(entity.getAfMaestroId()).isEqualTo(60L);
        assertThat(entity.getValorAsegurado()).isEqualByComparingTo(new BigDecimal("120000.0000"));
    }
}
