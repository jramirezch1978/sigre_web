package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfPrimaDevengoResponse;
import pe.restaurant.activos.entity.AfPrimaDevengo;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfPrimaDevengoMapperTest {

    private final AfPrimaDevengoMapper mapper = Mappers.getMapper(AfPrimaDevengoMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfPrimaDevengo entity = new AfPrimaDevengo();
        entity.setId(1L);
        entity.setAfPolizaSeguroId(10L);
        entity.setAnio(2025);
        entity.setMes(6);
        entity.setImporteDevengado(new BigDecimal("416.6700"));
        entity.setMesesVigenciaPoliza(12);
        entity.setCntblAsientoId(100L);
        entity.setFlagEstado("1");

        AfPrimaDevengoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfPolizaSeguroId()).isEqualTo(10L);
        assertThat(response.getAnio()).isEqualTo(2025);
        assertThat(response.getMes()).isEqualTo(6);
        assertThat(response.getImporteDevengado()).isEqualByComparingTo(new BigDecimal("416.6700"));
        assertThat(response.getMesesVigenciaPoliza()).isEqualTo(12);
        assertThat(response.getCntblAsientoId()).isEqualTo(100L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfPrimaDevengo e1 = new AfPrimaDevengo();
        e1.setId(1L);
        e1.setMes(1);
        AfPrimaDevengo e2 = new AfPrimaDevengo();
        e2.setId(2L);
        e2.setMes(2);

        List<AfPrimaDevengoResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getMes()).isEqualTo(1);
        assertThat(result.get(1).getMes()).isEqualTo(2);
    }

    @Test
    void toResponseList_nullReturnsNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }
}
