package com.sigre.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.core.dto.DocTipoRequest;
import com.sigre.core.dto.DocTipoResponse;
import com.sigre.core.entity.DocTipo;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class DocTipoMapperTest {

    private final DocTipoMapper mapper = Mappers.getMapper(DocTipoMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        DocTipo entity = new DocTipo();
        entity.setId(1L);
        entity.setCodigo("FAC");
        entity.setNombre("Factura");
        entity.setSunatCodigo("01");
        entity.setFlagSigno("+");
        entity.setFlagEstado("1");

        DocTipoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("FAC");
        assertThat(response.getNombre()).isEqualTo("Factura");
        assertThat(response.getSunatCodigo()).isEqualTo("01");
        assertThat(response.getFlagSigno()).isEqualTo("+");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        DocTipo e1 = new DocTipo();
        e1.setId(1L);
        e1.setCodigo("FAC");
        e1.setNombre("Factura");
        e1.setFlagEstado("1");

        DocTipo e2 = new DocTipo();
        e2.setId(2L);
        e2.setCodigo("BOL");
        e2.setNombre("Boleta");
        e2.setFlagEstado("1");

        List<DocTipoResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodigo()).isEqualTo("FAC");
        assertThat(responses.get(1).getCodigo()).isEqualTo("BOL");
    }

    @Test
    void toEntity_mapsAllFields() {
        DocTipoRequest request = new DocTipoRequest();
        request.setCodigo("FAC");
        request.setNombre("Factura");
        request.setSunatCodigo("01");
        request.setFlagSigno("+");
        request.setFlagEstado("1");

        DocTipo entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("FAC");
        assertThat(entity.getNombre()).isEqualTo("Factura");
        assertThat(entity.getSunatCodigo()).isEqualTo("01");
        assertThat(entity.getFlagSigno()).isEqualTo("+");
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        DocTipo entity = new DocTipo();
        entity.setId(1L);
        entity.setCodigo("FAC");
        entity.setNombre("Factura");
        entity.setSunatCodigo("01");
        entity.setFlagSigno("+");
        entity.setFlagEstado("1");

        DocTipoRequest request = new DocTipoRequest();
        request.setCodigo("BOL");
        request.setNombre("Boleta");
        request.setSunatCodigo("03");
        request.setFlagSigno("-");
        request.setFlagEstado("1");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodigo()).isEqualTo("BOL");
        assertThat(entity.getNombre()).isEqualTo("Boleta");
        assertThat(entity.getSunatCodigo()).isEqualTo("03");
        assertThat(entity.getFlagSigno()).isEqualTo("-");
    }
}
