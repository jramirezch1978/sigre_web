package pe.restaurant.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.finanzas.dto.request.ConciliacionDetRequest;
import pe.restaurant.finanzas.dto.response.ConciliacionDetResponse;
import pe.restaurant.finanzas.entity.ConciliacionDet;

import java.util.ArrayList;
import java.util.List;

@DisplayName("Pruebas Unitarias - ConciliacionDetMapper")
class ConciliacionDetMapperTest {

    private ConciliacionDetMapper mapper;
    private ConciliacionDet entity;
    private ConciliacionDetRequest request;

    @BeforeEach
    void setUp() {
        mapper = Mappers.getMapper(ConciliacionDetMapper.class);

        entity = new ConciliacionDet();
        entity.setId(1L);
        entity.setCajaBancosId(10L);
        entity.setConciliado(true);
        entity.setObservacion("Test");
        entity.setFlagEstado("1");

        request = new ConciliacionDetRequest();
        request.setCajaBancosId(10L);
        request.setConciliado(true);
        request.setObservacion("Test");
    }

    @Test
    @DisplayName("toEntity() con request valido -> retorna entity")
    void toEntity_conRequestValido_retornaEntity() {
        ConciliacionDet result = mapper.toEntity(request);

        assertThat(result).isNotNull();
        assertThat(result.getCajaBancosId()).isEqualTo(10L);
        assertThat(result.getConciliado()).isTrue();
        assertThat(result.getObservacion()).isEqualTo("Test");
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity valida -> retorna response")
    void toResponse_conEntityValida_retornaResponse() {
        ConciliacionDetResponse result = mapper.toResponse(entity);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCajaBancosId()).isEqualTo(10L);
        assertThat(result.getConciliado()).isTrue();
        assertThat(result.getObservacion()).isEqualTo("Test");
    }

    @Test
    @DisplayName("toResponse() con entity null -> retorna null")
    void toResponse_conEntityNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista valida -> retorna lista")
    void toResponseList_conListaValida_retornaLista() {
        List<ConciliacionDetResponse> result = mapper.toResponseList(List.of(entity, entity));

        assertThat(result).hasSize(2);
    }

    @Test
    @DisplayName("toResponseList() con lista vacia -> retorna lista vacia")
    void toResponseList_conListaVacia_retornaListaVacia() {
        assertThat(mapper.toResponseList(new ArrayList<>())).isEmpty();
    }
}
