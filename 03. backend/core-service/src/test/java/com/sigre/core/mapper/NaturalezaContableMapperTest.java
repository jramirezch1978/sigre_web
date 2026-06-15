package com.sigre.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.core.dto.NaturalezaContableRequest;
import com.sigre.core.dto.NaturalezaContableResponse;
import com.sigre.core.entity.NaturalezaContable;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class NaturalezaContableMapperTest {

    private final NaturalezaContableMapper mapper = Mappers.getMapper(NaturalezaContableMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        NaturalezaContable entity = new NaturalezaContable();
        entity.setId(1L);
        entity.setCodigo("NC001");
        entity.setNombre("Mercaderia");
        entity.setCuentaContable("6011");
        entity.setFlagEstado("1");

        NaturalezaContableResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("NC001");
        assertThat(response.getNombre()).isEqualTo("Mercaderia");
        assertThat(response.getCuentaContable()).isEqualTo("6011");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        NaturalezaContable e1 = new NaturalezaContable();
        e1.setId(1L);
        e1.setCodigo("NC001");
        e1.setNombre("Mercaderia");
        e1.setFlagEstado("1");

        NaturalezaContable e2 = new NaturalezaContable();
        e2.setId(2L);
        e2.setCodigo("NC002");
        e2.setNombre("Suministros");
        e2.setFlagEstado("1");

        List<NaturalezaContableResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("NC001");
        assertThat(responses.get(1).getCodigo()).isEqualTo("NC002");
    }

    @Test
    void toEntity_mapsAllFields() {
        NaturalezaContableRequest request = new NaturalezaContableRequest();
        request.setCodigo("NC001");
        request.setNombre("Mercaderia");
        request.setCuentaContable("6011");
        request.setFlagEstado("1");

        NaturalezaContable entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("NC001");
        assertThat(entity.getNombre()).isEqualTo("Mercaderia");
        assertThat(entity.getCuentaContable()).isEqualTo("6011");
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        NaturalezaContable entity = new NaturalezaContable();
        entity.setId(1L);
        entity.setCodigo("NC001");
        entity.setNombre("Mercaderia");
        entity.setCuentaContable("6011");
        entity.setFlagEstado("1");

        NaturalezaContableRequest request = new NaturalezaContableRequest();
        request.setCodigo("NC002");
        request.setNombre("Suministros");
        request.setCuentaContable("6012");
        request.setFlagEstado("1");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("NC002");
        assertThat(entity.getNombre()).isEqualTo("Suministros");
        assertThat(entity.getCuentaContable()).isEqualTo("6012");
    }
}
