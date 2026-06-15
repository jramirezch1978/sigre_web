package com.sigre.compras.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.compras.dto.ProgramacionComprasDetRequest;
import com.sigre.compras.dto.ProgramacionComprasDetResponse;
import com.sigre.compras.dto.ProgramacionComprasDetalleResponse;
import com.sigre.compras.dto.ProgramacionComprasResponse;
import com.sigre.compras.entity.ProgramacionCompras;
import com.sigre.compras.entity.ProgramacionComprasDet;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("ProgramacionComprasMapper — Pruebas Unitarias")
class ProgramacionComprasMapperTest {

    private final ProgramacionComprasMapper mapper = Mappers.getMapper(ProgramacionComprasMapper.class);

    private ProgramacionCompras crearProgramacion() {
        ProgramacionCompras p = new ProgramacionCompras();
        p.setId(1L);
        p.setSucursalId(1L);
        p.setNroProgramacion("PC-001");
        p.setAnio(2026);
        p.setMes(5);
        p.setFlagEstado("1");
        p.setCreatedBy(1L);
        p.setFecCreacion(OffsetDateTime.now());

        ProgramacionComprasDet det = new ProgramacionComprasDet();
        det.setId(100L);
        det.setArticuloId(50L);
        det.setCantidad(new BigDecimal("20"));
        det.setPrecioEstimado(new BigDecimal("100"));
        det.setProgramacionCompras(p);
        p.getLineas().add(det);
        return p;
    }

    @Test
    @DisplayName("toResponse() mapea nro programación a número")
    void toResponse_mapeaNroProgramacionANumero() {
        ProgramacionCompras p = crearProgramacion();

        ProgramacionComprasResponse resp = mapper.toResponse(p);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getNumero()).isEqualTo("PC-001");
        assertThat(resp.getSucursalId()).isEqualTo(1L);
        assertThat(resp.getAnio()).isEqualTo(2026);
        assertThat(resp.getMes()).isEqualTo(5);
        assertThat(resp.getFlagEstado()).isEqualTo("1");
        assertThat(resp.getCreatedBy()).isEqualTo(1L);
    }

    @Test
    @DisplayName("toResponseList() convierte multiples")
    void toResponseList_convierteMultiples() {
        ProgramacionCompras p1 = crearProgramacion();
        ProgramacionCompras p2 = crearProgramacion();
        p2.setId(2L);
        p2.setNroProgramacion("PC-002");

        List<ProgramacionComprasResponse> result = mapper.toResponseList(List.of(p1, p2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getNumero()).isEqualTo("PC-001");
        assertThat(result.get(1).getNumero()).isEqualTo("PC-002");
    }

    @Test
    @DisplayName("toDetalleResponse() incluye número y líneas")
    void toDetalleResponse_incluyeNumeroYLineas() {
        ProgramacionCompras p = crearProgramacion();

        ProgramacionComprasDetalleResponse resp = mapper.toDetalleResponse(p);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getNumero()).isEqualTo("PC-001");
        assertThat(resp.getLineas()).hasSize(1);
        assertThat(resp.getLineas().get(0).getArticuloId()).isEqualTo(50L);
    }

    @Test
    @DisplayName("toDetResponse() mapea todos campos")
    void toDetResponse_mapeaTodosCampos() {
        ProgramacionComprasDet det = new ProgramacionComprasDet();
        det.setId(100L);
        det.setArticuloId(50L);
        det.setCantidad(new BigDecimal("20"));
        det.setPrecioEstimado(new BigDecimal("100"));

        ProgramacionComprasDetResponse resp = mapper.toDetResponse(det);

        assertThat(resp.getId()).isEqualTo(100L);
        assertThat(resp.getArticuloId()).isEqualTo(50L);
        assertThat(resp.getCantidad()).isEqualByComparingTo(new BigDecimal("20"));
        assertThat(resp.getPrecioEstimado()).isEqualByComparingTo(new BigDecimal("100"));
    }

    @Test
    @DisplayName("toDetResponseList() convierte multiples")
    void toDetResponseList_convierteMultiples() {
        ProgramacionComprasDet d1 = new ProgramacionComprasDet();
        d1.setId(1L);
        d1.setArticuloId(10L);
        d1.setCantidad(BigDecimal.ONE);
        ProgramacionComprasDet d2 = new ProgramacionComprasDet();
        d2.setId(2L);
        d2.setArticuloId(20L);
        d2.setCantidad(BigDecimal.TEN);

        List<ProgramacionComprasDetResponse> result = mapper.toDetResponseList(List.of(d1, d2));

        assertThat(result).hasSize(2);
    }

    @Test
    @DisplayName("toDetEntity() mapea campos y omite programación y auditoria")
    void toDetEntity_mapeaCamposYOmiteProgramacionYAuditoria() {
        ProgramacionComprasDetRequest req = new ProgramacionComprasDetRequest(50L, new BigDecimal("30"), new BigDecimal("200"));

        ProgramacionComprasDet entity = mapper.toDetEntity(req);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getProgramacionCompras()).isNull();
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getArticuloId()).isEqualTo(50L);
        assertThat(entity.getCantidad()).isEqualByComparingTo(new BigDecimal("30"));
        assertThat(entity.getPrecioEstimado()).isEqualByComparingTo(new BigDecimal("200"));
    }

    @Test
    @DisplayName("toResponse() con null -> retorna null")
    void toResponse_conNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toDetalleResponse() con lineas null conserva detalle")
    void toDetalleResponse_conLineasNull_conservaDetalle() {
        ProgramacionCompras p = crearProgramacion();
        p.setLineas(null);

        ProgramacionComprasDetalleResponse resp = mapper.toDetalleResponse(p);

        assertThat(resp).isNotNull();
        assertThat(resp.getNumero()).isEqualTo("PC-001");
        assertThat(resp.getLineas()).isNull();
    }

    @Test
    @DisplayName("toDetResponseList() con null -> retorna null")
    void toDetResponseList_conNull_retornaNull() {
        assertThat(mapper.toDetResponseList(null)).isNull();
    }
}
