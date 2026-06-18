package pe.restaurant.compras.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.compras.dto.TipoEntidadContribuyenteRequest;
import pe.restaurant.compras.dto.TipoEntidadContribuyenteResponse;
import pe.restaurant.compras.entity.TipoEntidadContribuyente;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TipoEntidadContribuyenteMapper — Pruebas Unitarias")
class TipoEntidadContribuyenteMapperTest {

    private final TipoEntidadContribuyenteMapper mapper =
            Mappers.getMapper(TipoEntidadContribuyenteMapper.class);

    @Test
    @DisplayName("toEntity() mapea campos y omite id y flag")
    void toEntity_mapeaCamposYOmiteIdYFlag() {
        TipoEntidadContribuyenteRequest req = new TipoEntidadContribuyenteRequest("PROVEEDOR", "Entidad proveedora");

        TipoEntidadContribuyente entity = mapper.toEntity(req);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getTipo()).isEqualTo("PROVEEDOR");
        assertThat(entity.getDescripcion()).isEqualTo("Entidad proveedora");
    }

    @Test
    @DisplayName("toResponse() mapea todos campos")
    void toResponse_mapeaTodosCampos() {
        TipoEntidadContribuyente entity = new TipoEntidadContribuyente();
        entity.setId(1L);
        entity.setTipo("CLIENTE");
        entity.setDescripcion("Entidad cliente");
        entity.setFlagEstado("1");

        TipoEntidadContribuyenteResponse resp = mapper.toResponse(entity);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getTipo()).isEqualTo("CLIENTE");
        assertThat(resp.getDescripcion()).isEqualTo("Entidad cliente");
        assertThat(resp.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() convierte multiples")
    void toResponseList_convierteMultiples() {
        TipoEntidadContribuyente e1 = new TipoEntidadContribuyente();
        e1.setId(1L);
        e1.setTipo("PROVEEDOR");
        e1.setDescripcion("Entidad proveedora");
        TipoEntidadContribuyente e2 = new TipoEntidadContribuyente();
        e2.setId(2L);
        e2.setTipo("CLIENTE");
        e2.setDescripcion("Entidad cliente");

        List<TipoEntidadContribuyenteResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getTipo()).isEqualTo("PROVEEDOR");
        assertThat(result.get(1).getTipo()).isEqualTo("CLIENTE");
    }

    @Test
    @DisplayName("updateEntity() ignora nulls y preserva id y flag")
    void updateEntity_ignoraNullsYPreservaIdYFlag() {
        TipoEntidadContribuyente entity = new TipoEntidadContribuyente();
        entity.setId(1L);
        entity.setTipo("PROVEEDOR");
        entity.setDescripcion("Entidad proveedora");
        entity.setFlagEstado("1");

        TipoEntidadContribuyenteRequest req = new TipoEntidadContribuyenteRequest();
        req.setTipo("CLIENTE");

        mapper.updateEntity(req, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getTipo()).isEqualTo("CLIENTE");
        assertThat(entity.getDescripcion()).isEqualTo("Entidad proveedora");
    }

    @Test
    @DisplayName("toEntity() con null -> retorna null")
    void toEntity_conNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }
}
