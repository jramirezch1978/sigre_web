package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfSubClaseRequest;
import pe.restaurant.activos.dto.AfSubClaseResponse;
import pe.restaurant.activos.entity.AfSubClase;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfSubClaseMapperTest {

    private final AfSubClaseMapper mapper = Mappers.getMapper(AfSubClaseMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfSubClase entity = new AfSubClase();
        entity.setId(1L);
        entity.setAfClaseId(10L);
        entity.setCodigo("MAQ-IND");
        entity.setNombre("Maquinaria Industrial");
        entity.setVidaUtilMeses(120);
        entity.setFlagEstado("1");

        AfSubClaseResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getAfClaseId()).isEqualTo(10L);
        assertThat(response.getCodigo()).isEqualTo("MAQ-IND");
        assertThat(response.getNombre()).isEqualTo("Maquinaria Industrial");
        assertThat(response.getVidaUtilMeses()).isEqualTo(120);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfSubClase e1 = new AfSubClase();
        e1.setId(1L);
        e1.setCodigo("SC-01");
        AfSubClase e2 = new AfSubClase();
        e2.setId(2L);
        e2.setCodigo("SC-02");

        List<AfSubClaseResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getCodigo()).isEqualTo("SC-01");
        assertThat(result.get(1).getCodigo()).isEqualTo("SC-02");
    }

    @Test
    void toEntity_mapsAllFields() {
        AfSubClaseRequest request = new AfSubClaseRequest();
        request.setAfClaseId(10L);
        request.setCodigo("MAQ-IND");
        request.setNombre("Maquinaria Industrial");
        request.setVidaUtilMeses(120);

        AfSubClase entity = mapper.toEntity(request);

        assertThat(entity.getAfClaseId()).isEqualTo(10L);
        assertThat(entity.getCodigo()).isEqualTo("MAQ-IND");
        assertThat(entity.getNombre()).isEqualTo("Maquinaria Industrial");
        assertThat(entity.getVidaUtilMeses()).isEqualTo(120);
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
        assertThat(entity.getAfClase()).isNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfSubClase entity = new AfSubClase();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setCodigo("OLD");

        AfSubClaseRequest request = new AfSubClaseRequest();
        request.setAfClaseId(50L);
        request.setCodigo("VEH-LIV");
        request.setNombre("Vehículos Livianos");
        request.setVidaUtilMeses(60);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getAfClase()).isNull();
        assertThat(entity.getAfClaseId()).isEqualTo(50L);
        assertThat(entity.getCodigo()).isEqualTo("VEH-LIV");
        assertThat(entity.getNombre()).isEqualTo("Vehículos Livianos");
        assertThat(entity.getVidaUtilMeses()).isEqualTo(60);
    }
}
