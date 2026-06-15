package com.sigre.compras.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.compras.dto.ServicioCatalogoRequest;
import com.sigre.compras.dto.ServicioCatalogoResponse;
import com.sigre.compras.entity.ServicioCatalogo;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("ServicioCatalogoMapper — Pruebas Unitarias")
class ServicioCatalogoMapperTest {

    private final ServicioCatalogoMapper mapper = Mappers.getMapper(ServicioCatalogoMapper.class);

    @Test
    @DisplayName("toEntity() mapea campos y omite id")
    void toEntity_mapeaCamposYOmiteId() {
        ServicioCatalogoRequest req = new ServicioCatalogoRequest(
                "SRV01", "1", 5L, "Servicio de limpieza",
                new BigDecimal("200"), 1L);

        ServicioCatalogo entity = mapper.toEntity(req);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getServicio()).isEqualTo("SRV01");
        assertThat(entity.getDescripcion()).isEqualTo("Servicio de limpieza");
        assertThat(entity.getTarifaEstd()).isEqualByComparingTo(new BigDecimal("200"));
        assertThat(entity.getUnidadMedidaId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("toResponse() mapea todos campos")
    void toResponse_mapeaTodosCampos() {
        ServicioCatalogo entity = new ServicioCatalogo();
        entity.setId(1L);
        entity.setServicio("SRV01");
        entity.setFlagEstado("1");
        entity.setDescripcion("Desc");
        entity.setTarifaEstd(new BigDecimal("150"));
        entity.setUnidadMedidaId(2L);
        entity.setArticuloSubCategId(5L);

        ServicioCatalogoResponse resp = mapper.toResponse(entity);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getServicio()).isEqualTo("SRV01");
        assertThat(resp.getFlagEstado()).isEqualTo("1");
        assertThat(resp.getDescripcion()).isEqualTo("Desc");
        assertThat(resp.getTarifaEstd()).isEqualByComparingTo(new BigDecimal("150"));
        assertThat(resp.getUnidadMedidaId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("toResponseList() convierte multiples")
    void toResponseList_convierteMultiples() {
        ServicioCatalogo e1 = new ServicioCatalogo();
        e1.setId(1L);
        e1.setServicio("S1");
        ServicioCatalogo e2 = new ServicioCatalogo();
        e2.setId(2L);
        e2.setServicio("S2");

        List<ServicioCatalogoResponse> result = mapper.toResponseList(List.of(e1, e2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getServicio()).isEqualTo("S1");
    }

    @Test
    @DisplayName("updateEntity() ignora nulls y preserva id")
    void updateEntity_ignoraNullsYPreservaId() {
        ServicioCatalogo entity = new ServicioCatalogo();
        entity.setId(1L);
        entity.setServicio("SRV01");
        entity.setDescripcion("Original");

        ServicioCatalogoRequest req = new ServicioCatalogoRequest();
        req.setDescripcion("Actualizada");

        mapper.updateEntity(req, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getServicio()).isEqualTo("SRV01");
        assertThat(entity.getDescripcion()).isEqualTo("Actualizada");
    }

    @Test
    @DisplayName("toEntity() con null -> retorna null")
    void toEntity_conNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    @DisplayName("toResponse() con null -> retorna null")
    void toResponse_conNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() con null -> retorna null")
    void toResponseList_conNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }

    @Test
    @DisplayName("updateEntity() con request null no altera entidad")
    void updateEntity_conRequestNull_noAlteraEntidad() {
        ServicioCatalogo entity = new ServicioCatalogo();
        entity.setId(1L);
        entity.setServicio("SRV01");
        entity.setDescripcion("Original");

        mapper.updateEntity(null, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getServicio()).isEqualTo("SRV01");
        assertThat(entity.getDescripcion()).isEqualTo("Original");
    }
}
