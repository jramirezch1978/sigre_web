package com.sigre.compras.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.compras.dto.SolicitudCompraDetResponse;
import com.sigre.compras.dto.SolicitudCompraDetalleResponse;
import com.sigre.compras.dto.SolicitudCompraResponse;
import com.sigre.compras.entity.SolicitudCompra;
import com.sigre.compras.entity.SolicitudCompraDet;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("SolicitudCompraMapper — Pruebas Unitarias")
class SolicitudCompraMapperTest {

    private final SolicitudCompraMapper mapper = Mappers.getMapper(SolicitudCompraMapper.class);

    private SolicitudCompra crearSolicitud() {
        SolicitudCompra sc = new SolicitudCompra();
        sc.setId(1L);
        sc.setSucursalId(1L);
        sc.setNroSolicitud("SC-001");
        sc.setFecha(LocalDate.of(2026, 5, 1));
        sc.setSolicitanteId(10L);
        sc.setPrioridad("ALTA");
        sc.setFlagEstado("1");
        sc.setJustificacion("Urgente");

        SolicitudCompraDet det = new SolicitudCompraDet();
        det.setId(100L);
        det.setArticuloId(50L);
        det.setCantidad(new BigDecimal("20"));
        det.setEspecificaciones("Marca X");
        det.setSolicitudCompra(sc);
        sc.getLineas().add(det);
        return sc;
    }

    @Test
    @DisplayName("toResponse() mapea nro solicitud a número y calcula total items")
    void toResponse_mapeaNroSolicitudANumeroYCalculaTotalItems() {
        SolicitudCompra sc = crearSolicitud();

        SolicitudCompraResponse resp = mapper.toResponse(sc);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getNumero()).isEqualTo("SC-001");
        assertThat(resp.getFecha()).isEqualTo(LocalDate.of(2026, 5, 1));
        assertThat(resp.getPrioridad()).isEqualTo("ALTA");
        assertThat(resp.getFlagEstado()).isEqualTo("1");
        assertThat(resp.getTotalItems()).isEqualTo(1);
        assertThat(resp.getSolicitanteId()).isEqualTo(10L);
        assertThat(resp.getSucursalId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("toResponse() con líneas null total items cero")
    void toResponse_conLineasNull_totalItemsCero() {
        SolicitudCompra sc = crearSolicitud();
        sc.setLineas(null);

        SolicitudCompraResponse resp = mapper.toResponse(sc);

        assertThat(resp.getTotalItems()).isEqualTo(0);
    }

    @Test
    @DisplayName("toResponseList() convierte multiples")
    void toResponseList_convierteMultiples() {
        SolicitudCompra sc1 = crearSolicitud();
        SolicitudCompra sc2 = crearSolicitud();
        sc2.setId(2L);
        sc2.setNroSolicitud("SC-002");

        List<SolicitudCompraResponse> result = mapper.toResponseList(List.of(sc1, sc2));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getNumero()).isEqualTo("SC-001");
        assertThat(result.get(1).getNumero()).isEqualTo("SC-002");
    }

    @Test
    @DisplayName("toDetalleResponse() incluye número y líneas")
    void toDetalleResponse_incluyeNumeroYLineas() {
        SolicitudCompra sc = crearSolicitud();

        SolicitudCompraDetalleResponse resp = mapper.toDetalleResponse(sc);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getNumero()).isEqualTo("SC-001");
        assertThat(resp.getSucursalId()).isEqualTo(1L);
        assertThat(resp.getJustificacion()).isEqualTo("Urgente");
    }

    @Test
    @DisplayName("toDetResponse() mapea campos artículo")
    void toDetResponse_mapeaCamposArticulo() {
        SolicitudCompraDet det = new SolicitudCompraDet();
        det.setId(100L);
        det.setArticuloId(50L);
        det.setCantidad(new BigDecimal("20"));
        det.setEspecificaciones("Marca X");

        SolicitudCompraDetResponse resp = mapper.toDetResponse(det);

        assertThat(resp.getId()).isEqualTo(100L);
        assertThat(resp.getArticuloId()).isEqualTo(50L);
        assertThat(resp.getCantidad()).isEqualByComparingTo(new BigDecimal("20"));
        assertThat(resp.getEspecificaciones()).isEqualTo("Marca X");
        assertThat(resp.getArticuloCodigo()).isNull();
        assertThat(resp.getArticuloDescripcion()).isNull();
    }

    @Test
    @DisplayName("toDetResponseList() convierte multiples")
    void toDetResponseList_convierteMultiples() {
        SolicitudCompraDet d1 = new SolicitudCompraDet();
        d1.setId(1L);
        d1.setArticuloId(10L);
        d1.setCantidad(BigDecimal.ONE);
        SolicitudCompraDet d2 = new SolicitudCompraDet();
        d2.setId(2L);
        d2.setArticuloId(20L);
        d2.setCantidad(BigDecimal.TEN);

        List<SolicitudCompraDetResponse> result = mapper.toDetResponseList(List.of(d1, d2));

        assertThat(result).hasSize(2);
    }

    @Test
    @DisplayName("toResponse() con null -> retorna null")
    void toResponse_conNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toDetalleResponse() con null -> retorna null")
    void toDetalleResponse_conNull_retornaNull() {
        assertThat(mapper.toDetalleResponse(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() con null -> retorna null")
    void toResponseList_conNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }

    @Test
    @DisplayName("toDetResponseList() con null -> retorna null")
    void toDetResponseList_conNull_retornaNull() {
        assertThat(mapper.toDetResponseList(null)).isNull();
    }
}
