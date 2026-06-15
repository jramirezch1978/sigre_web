package com.sigre.core.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.core.dto.ArticuloClaseRequest;
import com.sigre.core.dto.ArticuloClaseResponse;
import com.sigre.core.entity.ArticuloClase;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class ArticuloClaseMapperTest {

    private final ArticuloClaseMapper mapper = Mappers.getMapper(ArticuloClaseMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        ArticuloClase entity = new ArticuloClase();
        entity.setId(1L);
        entity.setCodClase("CLS01");
        entity.setDescClase("Clase Uno");
        entity.setFlagEstado("1");

        ArticuloClaseResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodClase()).isEqualTo("CLS01");
        assertThat(response.getDescClase()).isEqualTo("Clase Uno");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        ArticuloClase e1 = new ArticuloClase();
        e1.setId(1L);
        e1.setCodClase("CLS01");
        e1.setDescClase("Clase Uno");
        e1.setFlagEstado("1");

        ArticuloClase e2 = new ArticuloClase();
        e2.setId(2L);
        e2.setCodClase("CLS02");
        e2.setDescClase("Clase Dos");
        e2.setFlagEstado("1");

        List<ArticuloClaseResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getCodClase()).isEqualTo("CLS01");
        assertThat(responses.get(1).getCodClase()).isEqualTo("CLS02");
    }

    @Test
    void toEntity_mapsAllFields() {
        ArticuloClaseRequest request = new ArticuloClaseRequest();
        request.setCodClase("CLS01");
        request.setDescClase("Clase Uno");

        ArticuloClase entity = mapper.toEntity(request);

        assertThat(entity.getCodClase()).isEqualTo("CLS01");
        assertThat(entity.getDescClase()).isEqualTo("Clase Uno");
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsAllFields() {
        ArticuloClase entity = new ArticuloClase();
        entity.setId(1L);
        entity.setCodClase("CLS01");
        entity.setDescClase("Clase Uno");
        entity.setFlagEstado("1");

        ArticuloClaseRequest request = new ArticuloClaseRequest();
        request.setCodClase("CLS02");
        request.setDescClase("Clase Dos");

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCodClase()).isEqualTo("CLS02");
        assertThat(entity.getDescClase()).isEqualTo("Clase Dos");
    }
}
