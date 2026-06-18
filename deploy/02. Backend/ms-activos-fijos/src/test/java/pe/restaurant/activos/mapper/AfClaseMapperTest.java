package pe.restaurant.activos.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.activos.dto.AfClaseRequest;
import pe.restaurant.activos.dto.AfClaseResponse;
import pe.restaurant.activos.entity.AfClase;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AfClaseMapperTest {

    private final AfClaseMapper mapper = Mappers.getMapper(AfClaseMapper.class);

    @Test
    void toResponse_mapsAllFields() {
        AfClase entity = new AfClase();
        entity.setId(1L);
        entity.setCodigo("MAQ");
        entity.setNombre("Maquinaria");
        entity.setMetodoDepreciacion("LINEA_RECTA");
        entity.setVidaUtilMeses(120);
        entity.setFlagEstado("1");

        AfClaseResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodigo()).isEqualTo("MAQ");
        assertThat(response.getNombre()).isEqualTo("Maquinaria");
        assertThat(response.getMetodoDepreciacion()).isEqualTo("LINEA_RECTA");
        assertThat(response.getVidaUtilMeses()).isEqualTo(120);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toResponse_nullReturnsNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toResponseList_mapsAll() {
        AfClase e1 = new AfClase();
        e1.setId(1L);
        e1.setCodigo("MAQ");
        AfClase e2 = new AfClase();
        e2.setId(2L);
        e2.setCodigo("VEH");

        List<AfClaseResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getCodigo()).isEqualTo("MAQ");
        assertThat(result.get(1).getCodigo()).isEqualTo("VEH");
    }

    @Test
    void toEntity_mapsAllFields() {
        AfClaseRequest request = new AfClaseRequest();
        request.setCodigo("MAQ");
        request.setNombre("Maquinaria");
        request.setMetodoDepreciacion("LINEA_RECTA");
        request.setVidaUtilMeses(120);

        AfClase entity = mapper.toEntity(request);

        assertThat(entity.getCodigo()).isEqualTo("MAQ");
        assertThat(entity.getNombre()).isEqualTo("Maquinaria");
        assertThat(entity.getMetodoDepreciacion()).isEqualTo("LINEA_RECTA");
        assertThat(entity.getVidaUtilMeses()).isEqualTo(120);
        assertThat(entity.getId()).isNull();
        assertThat(entity.getFlagEstado()).isNotNull();
    }

    @Test
    void toEntity_nullReturnsNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void updateEntity_mapsFieldsExceptIgnored() {
        AfClase entity = new AfClase();
        entity.setId(99L);
        entity.setFlagEstado("1");
        entity.setCodigo("OLD");

        AfClaseRequest request = new AfClaseRequest();
        request.setCodigo("NEW");
        request.setNombre("Vehículos");
        request.setMetodoDepreciacion("SUMA_DIGITOS");
        request.setVidaUtilMeses(60);

        mapper.updateEntity(request, entity);

        assertThat(entity.getId()).isEqualTo(99L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCodigo()).isEqualTo("NEW");
        assertThat(entity.getNombre()).isEqualTo("Vehículos");
        assertThat(entity.getMetodoDepreciacion()).isEqualTo("SUMA_DIGITOS");
        assertThat(entity.getVidaUtilMeses()).isEqualTo(60);
    }
}
