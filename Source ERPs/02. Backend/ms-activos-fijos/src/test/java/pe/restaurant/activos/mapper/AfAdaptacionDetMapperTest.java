package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfAdaptacionDetRequest;
import pe.restaurant.activos.dto.AfAdaptacionDetResponse;
import pe.restaurant.activos.entity.AfAdaptacionDet;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfAdaptacionDetMapperTest {

    private final AfAdaptacionDetMapper mapper = Mappers.getMapper(AfAdaptacionDetMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfAdaptacionDet entity = new AfAdaptacionDet();
        entity.setId(1L);
        entity.setAfAdaptacionId(10L);
        entity.setDescripcion("Adaptación eléctrica");
        entity.setMonto(new BigDecimal("5000.0000"));
        entity.setUnidadMedidaId(3L);
        entity.setFlagEstado("1");

        AfAdaptacionDetResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfAdaptacionId()).isEqualTo(10L);
        assertThat(response.getDescripcion()).isEqualTo("Adaptación eléctrica");
        assertThat(response.getMonto()).isEqualByComparingTo(new BigDecimal("5000.0000"));
        assertThat(response.getUnidadMedidaId()).isEqualTo(3L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfAdaptacionDet e1 = new AfAdaptacionDet();
        e1.setId(1L);
        AfAdaptacionDet e2 = new AfAdaptacionDet();
        e2.setId(2L);

        List<AfAdaptacionDetResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        assertThat(result.get(1).getId()).isEqualTo(2L);
    }

    @Test
    void toEntity_mapsAllFields() {
        AfAdaptacionDetRequest request = new AfAdaptacionDetRequest();
        request.setAfAdaptacionId(10L);
        request.setDescripcion("Adaptación eléctrica");
        request.setMonto(new BigDecimal("5000.0000"));
        request.setUnidadMedidaId(3L);

        AfAdaptacionDet entity = mapper.toEntity(request);

        assertThat(entity.getAfAdaptacionId()).isEqualTo(10L);
        assertThat(entity.getDescripcion()).isEqualTo("Adaptación eléctrica");
        assertThat(entity.getMonto()).isEqualByComparingTo(new BigDecimal("5000.0000"));
        assertThat(entity.getUnidadMedidaId()).isEqualTo(3L);
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfAdaptacionDet entity = new AfAdaptacionDet();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setAfAdaptacionId(1L);

        AfAdaptacionDetRequest request = new AfAdaptacionDetRequest();
        request.setAfAdaptacionId(50L);
        request.setDescripcion("Nueva descripción");
        request.setMonto(new BigDecimal("7500.0000"));
        request.setUnidadMedidaId(5L);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getAfAdaptacionId()).isEqualTo(50L);
        assertThat(entity.getDescripcion()).isEqualTo("Nueva descripción");
        assertThat(entity.getMonto()).isEqualByComparingTo(new BigDecimal("7500.0000"));
        assertThat(entity.getUnidadMedidaId()).isEqualTo(5L);
    }
}
