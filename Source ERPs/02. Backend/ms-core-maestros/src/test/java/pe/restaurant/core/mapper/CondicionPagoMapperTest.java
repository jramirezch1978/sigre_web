package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.CondicionPagoRequest;
import pe.restaurant.core.dto.CondicionPagoResponse;
import pe.restaurant.core.entity.CondicionPago;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class CondicionPagoMapperTest {

    private final CondicionPagoMapper mapper = Mappers.getMapper(CondicionPagoMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        CondicionPago entity = new CondicionPago();
        entity.setId(1L);
        entity.setCodigo("CP001");
        entity.setNombre("Contado");
        entity.setDiasPlazo(0);
        entity.setFlagEstado("1");

        CondicionPagoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("CP001");
        assertThat(response.getNombre()).isEqualTo("Contado");
        assertThat(response.getDiasPlazo()).isEqualTo(0);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        CondicionPago e1 = new CondicionPago();
        e1.setId(1L);
        e1.setCodigo("CP001");
        e1.setNombre("Contado");
        e1.setDiasPlazo(0);
        e1.setFlagEstado("1");

        CondicionPago e2 = new CondicionPago();
        e2.setId(2L);
        e2.setCodigo("CP002");
        e2.setNombre("Credito 30");
        e2.setDiasPlazo(30);
        e2.setFlagEstado("1");

        List<CondicionPagoResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("CP001");
        assertThat(responses.get(1).getCodigo()).isEqualTo("CP002");
    }

    @Test
    void toEntity_mapsAllFields() {
        CondicionPagoRequest request = new CondicionPagoRequest();
        request.setCodigo("CP001");
        request.setNombre("Contado");
        request.setDiasPlazo(0);
        request.setFlagEstado("1");

        CondicionPago entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("CP001");
        assertThat(entity.getNombre()).isEqualTo("Contado");
        assertThat(entity.getDiasPlazo()).isEqualTo(0);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        CondicionPago entity = new CondicionPago();
        entity.setId(1L);
        entity.setCodigo("CP001");
        entity.setNombre("Contado");
        entity.setDiasPlazo(0);
        entity.setFlagEstado("1");

        CondicionPagoRequest request = new CondicionPagoRequest();
        request.setCodigo("CP002");
        request.setNombre("Credito 30");
        request.setDiasPlazo(30);
        request.setFlagEstado("1");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("CP002");
        assertThat(entity.getNombre()).isEqualTo("Credito 30");
        assertThat(entity.getDiasPlazo()).isEqualTo(30);
    }
}
