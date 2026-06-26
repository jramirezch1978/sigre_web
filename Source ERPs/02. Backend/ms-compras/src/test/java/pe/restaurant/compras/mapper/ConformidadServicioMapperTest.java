package pe.restaurant.compras.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.compras.dto.ConformidadServicioDetRequest;
import pe.restaurant.compras.dto.ConformidadServicioDetResponse;
import pe.restaurant.compras.dto.ConformidadServicioDetalleResponse;
import pe.restaurant.compras.dto.ConformidadServicioResponse;
import pe.restaurant.compras.entity.ConformidadServicio;
import pe.restaurant.compras.entity.ConformidadServicioDet;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class ConformidadServicioMapperTest {

    private final ConformidadServicioMapper mapper = Mappers.getMapper(ConformidadServicioMapper.class);

    private ConformidadServicio crearConformidad() {
        ConformidadServicio cs = new ConformidadServicio();
        cs.setId(1L);
        cs.setOrdenServicioId(10L);
        cs.setFecha(LocalDate.of(2026, 5, 1));
        cs.setObservacion("Conforme");
        cs.setAprobado(true);
        cs.setFlagEstado("1");
        cs.setCreatedBy(1L);
        cs.setFecCreacion(OffsetDateTime.now());

        ConformidadServicioDet det = new ConformidadServicioDet();
        det.setId(100L);
        det.setSecuencia(1);
        det.setDescripcion("Servicio A");
        det.setCantidad(new BigDecimal("1"));
        det.setPrecioUnitario(new BigDecimal("500"));
        det.setSubtotal(new BigDecimal("500"));
        det.setConformidadServicio(cs);
        cs.getLineas().add(det);
        return cs;
    }

    @Test
    void toResponse_mapeaCamposPrincipales() {
        ConformidadServicio cs = crearConformidad();

        ConformidadServicioResponse resp = mapper.toResponse(cs);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getOrdenServicioId()).isEqualTo(10L);
        assertThat(resp.getFecha()).isEqualTo(LocalDate.of(2026, 5, 1));
        assertThat(resp.getObservacion()).isEqualTo("Conforme");
        assertThat(resp.getAprobado()).isTrue();
        assertThat(resp.getFlagEstado()).isEqualTo("1");
        assertThat(resp.getCreatedBy()).isEqualTo(1L);
    }

    @Test
    void toResponseList_convierteMultiples() {
        ConformidadServicio cs1 = crearConformidad();
        ConformidadServicio cs2 = crearConformidad();
        cs2.setId(2L);

        List<ConformidadServicioResponse> result = mapper.toResponseList(List.of(cs1, cs2));

        assertThat(result).hasSize(2);
    }

    @Test
    void toDetalleResponse_incluyeLineas() {
        ConformidadServicio cs = crearConformidad();

        ConformidadServicioDetalleResponse resp = mapper.toDetalleResponse(cs);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getLineas()).hasSize(1);
        assertThat(resp.getLineas().get(0).getSecuencia()).isEqualTo(1);
        assertThat(resp.getLineas().get(0).getDescripcion()).isEqualTo("Servicio A");
    }

    @Test
    void toDetResponse_mapeaTodosCampos() {
        ConformidadServicioDet det = new ConformidadServicioDet();
        det.setId(100L);
        det.setSecuencia(1);
        det.setDescripcion("Test");
        det.setCantidad(new BigDecimal("2"));
        det.setPrecioUnitario(new BigDecimal("250"));
        det.setSubtotal(new BigDecimal("500"));

        ConformidadServicioDetResponse resp = mapper.toDetResponse(det);

        assertThat(resp.getId()).isEqualTo(100L);
        assertThat(resp.getSecuencia()).isEqualTo(1);
        assertThat(resp.getDescripcion()).isEqualTo("Test");
        assertThat(resp.getCantidad()).isEqualByComparingTo(new BigDecimal("2"));
        assertThat(resp.getPrecioUnitario()).isEqualByComparingTo(new BigDecimal("250"));
        assertThat(resp.getSubtotal()).isEqualByComparingTo(new BigDecimal("500"));
    }

    @Test
    void toDetResponseList_convierteMultiples() {
        ConformidadServicioDet d1 = new ConformidadServicioDet();
        d1.setId(1L);
        d1.setSecuencia(1);
        ConformidadServicioDet d2 = new ConformidadServicioDet();
        d2.setId(2L);
        d2.setSecuencia(2);

        List<ConformidadServicioDetResponse> result = mapper.toDetResponseList(List.of(d1, d2));

        assertThat(result).hasSize(2);
    }

    @Test
    void toDetEntity_mapeaCamposYOmiteSubtotalYConformidad() {
        ConformidadServicioDetRequest req = new ConformidadServicioDetRequest();
        req.setSecuencia(1);
        req.setDescripcion("Servicio B");
        req.setCantidad(new BigDecimal("3"));
        req.setPrecioUnitario(new BigDecimal("100"));

        ConformidadServicioDet entity = mapper.toDetEntity(req);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getConformidadServicio()).isNull();
        assertThat(entity.getSubtotal()).isNull();
        assertThat(entity.getSecuencia()).isEqualTo(1);
        assertThat(entity.getDescripcion()).isEqualTo("Servicio B");
        assertThat(entity.getCantidad()).isEqualByComparingTo(new BigDecimal("3"));
        assertThat(entity.getPrecioUnitario()).isEqualByComparingTo(new BigDecimal("100"));
    }

    @Test
    void toResponse_conNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    void toDetalleResponse_conLineasNull_retornaDetalleSinLineas() {
        ConformidadServicio cs = crearConformidad();
        cs.setLineas(null);

        ConformidadServicioDetalleResponse resp = mapper.toDetalleResponse(cs);

        assertThat(resp).isNotNull();
        assertThat(resp.getLineas()).isNull();
    }

    @Test
    void toDetResponseList_conNull_retornaNull() {
        assertThat(mapper.toDetResponseList(null)).isNull();
    }
}
