package com.sigre.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.core.dto.EntidadContribuyenteTelefonoRequest;
import com.sigre.core.dto.EntidadContribuyenteTelefonoResponse;
import com.sigre.core.entity.EntidadContribuyenteTelefono;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class EntidadContribuyenteTelefonoMapperTest {

    private final EntidadContribuyenteTelefonoMapper mapper = Mappers.getMapper(EntidadContribuyenteTelefonoMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        EntidadContribuyenteTelefono entity = new EntidadContribuyenteTelefono();
        entity.setId(1L);
        entity.setEntidadContribuyenteId(10L);
        entity.setItem((short) 1);
        entity.setDescripcion("Telefono principal");
        entity.setCodigoPais("51");
        entity.setCodigoCiudad("01");
        entity.setNumero("4567890");
        entity.setFlagFax("0");
        entity.setFlagEstado("1");

        EntidadContribuyenteTelefonoResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getEntidadContribuyenteId()).isEqualTo(10L);
        assertThat(response.getItem()).isEqualTo((short) 1);
        assertThat(response.getDescripcion()).isEqualTo("Telefono principal");
        assertThat(response.getCodigoPais()).isEqualTo("51");
        assertThat(response.getCodigoCiudad()).isEqualTo("01");
        assertThat(response.getNumero()).isEqualTo("4567890");
        assertThat(response.getFlagFax()).isEqualTo("0");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        EntidadContribuyenteTelefono e1 = new EntidadContribuyenteTelefono();
        e1.setId(1L);
        e1.setEntidadContribuyenteId(10L);
        e1.setItem((short) 1);
        e1.setNumero("4567890");
        e1.setFlagEstado("1");

        EntidadContribuyenteTelefono e2 = new EntidadContribuyenteTelefono();
        e2.setId(2L);
        e2.setEntidadContribuyenteId(10L);
        e2.setItem((short) 2);
        e2.setNumero("9876543");
        e2.setFlagEstado("1");

        List<EntidadContribuyenteTelefonoResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getNumero()).isEqualTo("4567890");
        assertThat(responses.get(1).getNumero()).isEqualTo("9876543");
    }

    @Test
    void toEntity_mapsAllFields() {
        EntidadContribuyenteTelefonoRequest request = new EntidadContribuyenteTelefonoRequest();
        request.setDescripcion("Telefono principal");
        request.setCodigoPais("51");
        request.setCodigoCiudad("01");
        request.setNumero("4567890");
        request.setFlagFax("0");

        EntidadContribuyenteTelefono entity = mapper.toEntity(request);

        assertThat(entity.getDescripcion()).isEqualTo("Telefono principal");
        assertThat(entity.getCodigoPais()).isEqualTo("51");
        assertThat(entity.getCodigoCiudad()).isEqualTo("01");
        assertThat(entity.getNumero()).isEqualTo("4567890");
        assertThat(entity.getFlagFax()).isEqualTo("0");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_ignoresNullFields() {
        EntidadContribuyenteTelefono entity = new EntidadContribuyenteTelefono();
        entity.setId(1L);
        entity.setEntidadContribuyenteId(10L);
        entity.setItem((short) 1);
        entity.setDescripcion("Telefono principal");
        entity.setCodigoPais("51");
        entity.setCodigoCiudad("01");
        entity.setNumero("4567890");
        entity.setFlagFax("0");
        entity.setFlagEstado("1");

        EntidadContribuyenteTelefonoRequest request = new EntidadContribuyenteTelefonoRequest();
        request.setNumero("9999999");
        request.setDescripcion(null);
        request.setCodigoPais(null);
        request.setCodigoCiudad(null);
        request.setFlagFax(null);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getNumero()).isEqualTo("9999999");
        assertThat(entity.getDescripcion()).isEqualTo("Telefono principal");
        assertThat(entity.getCodigoPais()).isEqualTo("51");
    }
}
