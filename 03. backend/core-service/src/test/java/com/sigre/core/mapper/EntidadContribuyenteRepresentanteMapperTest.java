package com.sigre.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.core.dto.EntidadContribuyenteRepresentanteRequest;
import com.sigre.core.dto.EntidadContribuyenteRepresentanteResponse;
import com.sigre.core.entity.EntidadContribuyenteRepresentante;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class EntidadContribuyenteRepresentanteMapperTest {

    private final EntidadContribuyenteRepresentanteMapper mapper = Mappers.getMapper(EntidadContribuyenteRepresentanteMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        EntidadContribuyenteRepresentante entity = new EntidadContribuyenteRepresentante();
        entity.setId(1L);
        entity.setEntidadContribuyenteId(10L);
        entity.setItem((short) 1);
        entity.setNombre("Juan Perez");
        entity.setCargo("Gerente");
        entity.setTelefono("999888777");
        entity.setEmail("juan@empresa.com");
        entity.setFlagEstado("1");

        EntidadContribuyenteRepresentanteResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getEntidadContribuyenteId()).isEqualTo(10L);
        assertThat(response.getItem()).isEqualTo((short) 1);
        assertThat(response.getNombre()).isEqualTo("Juan Perez");
        assertThat(response.getCargo()).isEqualTo("Gerente");
        assertThat(response.getTelefono()).isEqualTo("999888777");
        assertThat(response.getEmail()).isEqualTo("juan@empresa.com");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        EntidadContribuyenteRepresentante e1 = new EntidadContribuyenteRepresentante();
        e1.setId(1L);
        e1.setEntidadContribuyenteId(10L);
        e1.setItem((short) 1);
        e1.setNombre("Juan Perez");
        e1.setFlagEstado("1");

        EntidadContribuyenteRepresentante e2 = new EntidadContribuyenteRepresentante();
        e2.setId(2L);
        e2.setEntidadContribuyenteId(10L);
        e2.setItem((short) 2);
        e2.setNombre("Maria Lopez");
        e2.setFlagEstado("1");

        List<EntidadContribuyenteRepresentanteResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getNombre()).isEqualTo("Juan Perez");
        assertThat(responses.get(1).getNombre()).isEqualTo("Maria Lopez");
    }

    @Test
    void toEntity_mapsAllFields() {
        EntidadContribuyenteRepresentanteRequest request = new EntidadContribuyenteRepresentanteRequest();
        request.setNombre("Juan Perez");
        request.setCargo("Gerente");
        request.setTelefono("999888777");
        request.setEmail("juan@empresa.com");

        EntidadContribuyenteRepresentante entity = mapper.toEntity(request);

        assertThat(entity.getNombre()).isEqualTo("Juan Perez");
        assertThat(entity.getCargo()).isEqualTo("Gerente");
        assertThat(entity.getTelefono()).isEqualTo("999888777");
        assertThat(entity.getEmail()).isEqualTo("juan@empresa.com");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_ignoresNullFields() {
        EntidadContribuyenteRepresentante entity = new EntidadContribuyenteRepresentante();
        entity.setId(1L);
        entity.setEntidadContribuyenteId(10L);
        entity.setItem((short) 1);
        entity.setNombre("Juan Perez");
        entity.setCargo("Gerente");
        entity.setTelefono("999888777");
        entity.setEmail("juan@empresa.com");
        entity.setFlagEstado("1");

        EntidadContribuyenteRepresentanteRequest request = new EntidadContribuyenteRepresentanteRequest();
        request.setNombre("Carlos Garcia");
        request.setCargo(null);
        request.setTelefono(null);
        request.setEmail(null);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getNombre()).isEqualTo("Carlos Garcia");
        assertThat(entity.getCargo()).isEqualTo("Gerente");
        assertThat(entity.getTelefono()).isEqualTo("999888777");
        assertThat(entity.getEmail()).isEqualTo("juan@empresa.com");
    }
}
