package pe.restaurant.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.core.dto.FormaPagoRequest;
import pe.restaurant.core.dto.FormaPagoResponse;
import pe.restaurant.core.entity.FormaPago;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class FormaPagoMapperTest {

    private final FormaPagoMapper mapper = Mappers.getMapper(FormaPagoMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        FormaPago entity = new FormaPago();
        entity.setId(1L);
        entity.setCodigo("EFE");
        entity.setNombre("Efectivo");
        entity.setTipo("CONTADO");
        entity.setFlagEstado("1");

        FormaPagoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("EFE");
        assertThat(response.getNombre()).isEqualTo("Efectivo");
        assertThat(response.getTipo()).isEqualTo("CONTADO");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        FormaPago e1 = new FormaPago();
        e1.setId(1L);
        e1.setCodigo("EFE");
        e1.setNombre("Efectivo");
        e1.setTipo("CONTADO");
        e1.setFlagEstado("1");

        FormaPago e2 = new FormaPago();
        e2.setId(2L);
        e2.setCodigo("TRF");
        e2.setNombre("Transferencia");
        e2.setTipo("CREDITO");
        e2.setFlagEstado("1");

        List<FormaPagoResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("EFE");
        assertThat(responses.get(1).getCodigo()).isEqualTo("TRF");
    }

    @Test
    void toEntity_mapsAllFields() {
        FormaPagoRequest request = new FormaPagoRequest();
        request.setCodigo("EFE");
        request.setNombre("Efectivo");
        request.setTipo("CONTADO");
        request.setFlagEstado("1");

        FormaPago entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("EFE");
        assertThat(entity.getNombre()).isEqualTo("Efectivo");
        assertThat(entity.getTipo()).isEqualTo("CONTADO");
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        FormaPago entity = new FormaPago();
        entity.setId(1L);
        entity.setCodigo("EFE");
        entity.setNombre("Efectivo");
        entity.setTipo("CONTADO");
        entity.setFlagEstado("1");

        FormaPagoRequest request = new FormaPagoRequest();
        request.setCodigo("TRF");
        request.setNombre("Transferencia");
        request.setTipo("CREDITO");
        request.setFlagEstado("1");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("TRF");
        assertThat(entity.getNombre()).isEqualTo("Transferencia");
        assertThat(entity.getTipo()).isEqualTo("CREDITO");
    }
}
