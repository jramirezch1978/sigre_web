package com.sigre.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.core.dto.TipoDocIdentidadRequest;
import com.sigre.core.dto.TipoDocIdentidadResponse;
import com.sigre.core.entity.TipoDocIdentidad;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class TipoDocIdentidadMapperTest {

    private final TipoDocIdentidadMapper mapper = Mappers.getMapper(TipoDocIdentidadMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        TipoDocIdentidad entity = new TipoDocIdentidad();
        entity.setId(1L);
        entity.setCodigo("6");
        entity.setNombre("RUC");
        entity.setFlagEstado("1");

        TipoDocIdentidadResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("6");
        assertThat(response.getNombre()).isEqualTo("RUC");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        TipoDocIdentidad e1 = new TipoDocIdentidad();
        e1.setId(1L);
        e1.setCodigo("6");
        e1.setNombre("RUC");
        e1.setFlagEstado("1");

        TipoDocIdentidad e2 = new TipoDocIdentidad();
        e2.setId(2L);
        e2.setCodigo("1");
        e2.setNombre("DNI");
        e2.setFlagEstado("1");

        List<TipoDocIdentidadResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("6");
        assertThat(responses.get(1).getCodigo()).isEqualTo("1");
    }

    @Test
    void toEntity_mapsAllFields() {
        TipoDocIdentidadRequest request = new TipoDocIdentidadRequest();
        request.setCodigo("6");
        request.setNombre("RUC");
        request.setFlagEstado("1");

        TipoDocIdentidad entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("6");
        assertThat(entity.getNombre()).isEqualTo("RUC");
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        TipoDocIdentidad entity = new TipoDocIdentidad();
        entity.setId(1L);
        entity.setCodigo("6");
        entity.setNombre("RUC");
        entity.setFlagEstado("1");

        TipoDocIdentidadRequest request = new TipoDocIdentidadRequest();
        request.setCodigo("1");
        request.setNombre("DNI");
        request.setFlagEstado("1");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("1");
        assertThat(entity.getNombre()).isEqualTo("DNI");
    }
}
