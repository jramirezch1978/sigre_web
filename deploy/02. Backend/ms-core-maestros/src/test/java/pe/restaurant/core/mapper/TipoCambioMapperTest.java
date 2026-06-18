package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.TipoCambioRequest;
import pe.restaurant.core.dto.TipoCambioResponse;
import pe.restaurant.core.entity.TipoCambio;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class TipoCambioMapperTest {

    private final TipoCambioMapper mapper = Mappers.getMapper(TipoCambioMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        TipoCambio entity = new TipoCambio();
        entity.setId(1L);
        entity.setMonedaId(2L);
        entity.setFecha(LocalDate.of(2025, 6, 15));
        entity.setCompra(new BigDecimal("3.720000"));
        entity.setVenta(new BigDecimal("3.750000"));
        entity.setFlagEstado("1");

        TipoCambioResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getMonedaId()).isEqualTo(2L);
        assertThat(response.getFecha()).isEqualTo(LocalDate.of(2025, 6, 15));
        assertThat(response.getCompra()).isEqualByComparingTo(new BigDecimal("3.72"));
        assertThat(response.getVenta()).isEqualByComparingTo(new BigDecimal("3.75"));
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        TipoCambio e1 = new TipoCambio();
        e1.setId(1L);
        e1.setMonedaId(2L);
        e1.setFecha(LocalDate.of(2025, 6, 15));
        e1.setCompra(new BigDecimal("3.720000"));
        e1.setVenta(new BigDecimal("3.750000"));
        e1.setFlagEstado("1");

        TipoCambio e2 = new TipoCambio();
        e2.setId(2L);
        e2.setMonedaId(2L);
        e2.setFecha(LocalDate.of(2025, 6, 16));
        e2.setCompra(new BigDecimal("3.730000"));
        e2.setVenta(new BigDecimal("3.760000"));
        e2.setFlagEstado("1");

        List<TipoCambioResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getFecha()).isEqualTo(LocalDate.of(2025, 6, 15));
        assertThat(responses.get(1).getFecha()).isEqualTo(LocalDate.of(2025, 6, 16));
    }

    @Test
    void toEntity_mapsAllFields() {
        TipoCambioRequest request = new TipoCambioRequest();
        request.setMonedaId(2L);
        request.setFecha(LocalDate.of(2025, 6, 15));
        request.setCompra(new BigDecimal("3.72"));
        request.setVenta(new BigDecimal("3.75"));

        TipoCambio entity = mapper.toEntity(request);

        assertThat(entity.getMonedaId()).isEqualTo(2L);
        assertThat(entity.getFecha()).isEqualTo(LocalDate.of(2025, 6, 15));
        assertThat(entity.getCompra()).isEqualByComparingTo(new BigDecimal("3.72"));
        assertThat(entity.getVenta()).isEqualByComparingTo(new BigDecimal("3.75"));
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        TipoCambio entity = new TipoCambio();
        entity.setId(1L);
        entity.setMonedaId(2L);
        entity.setFecha(LocalDate.of(2025, 6, 15));
        entity.setCompra(new BigDecimal("3.720000"));
        entity.setVenta(new BigDecimal("3.750000"));
        entity.setFlagEstado("1");

        TipoCambioRequest request = new TipoCambioRequest();
        request.setMonedaId(2L);
        request.setFecha(LocalDate.of(2025, 6, 16));
        request.setCompra(new BigDecimal("3.73"));
        request.setVenta(new BigDecimal("3.76"));

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getFecha()).isEqualTo(LocalDate.of(2025, 6, 16));
        assertThat(entity.getCompra()).isEqualByComparingTo(new BigDecimal("3.73"));
        assertThat(entity.getVenta()).isEqualByComparingTo(new BigDecimal("3.76"));
    }
}
