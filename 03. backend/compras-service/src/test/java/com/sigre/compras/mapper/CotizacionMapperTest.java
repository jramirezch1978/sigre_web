package com.sigre.compras.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.compras.dto.CotizacionDetRequest;
import com.sigre.compras.dto.CotizacionRequest;
import com.sigre.compras.entity.Cotizacion;
import com.sigre.compras.entity.CotizacionDet;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

import static org.assertj.core.api.Assertions.assertThat;

class CotizacionMapperTest {

    private final CotizacionMapper mapper = Mappers.getMapper(CotizacionMapper.class);

    @Test
    void toEntity_mapeaCamposYOmiteCamposIgnorados() {
        CotizacionRequest req = new CotizacionRequest();
        req.setProveedorId(10L);
        req.setFecha(LocalDate.of(2026, 5, 1));
        req.setMonedaId(1L);

        Cotizacion entity = mapper.toEntity(req);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getSucursalId()).isNull();
        assertThat(entity.getTotal()).isEqualByComparingTo(BigDecimal.ZERO);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getProveedorId()).isEqualTo(10L);
        assertThat(entity.getFecha()).isEqualTo(LocalDate.of(2026, 5, 1));
        assertThat(entity.getMonedaId()).isEqualTo(1L);
    }

    @Test
    void toDetEntity_mapeaCamposYOmiteCotizacion() {
        CotizacionDetRequest req = new CotizacionDetRequest();
        req.setArticuloId(100L);
        req.setCantidad(new BigDecimal("5"));
        req.setPrecioUnitario(new BigDecimal("100"));

        CotizacionDet entity = mapper.toDetEntity(req);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getCotizacion()).isNull();
        assertThat(entity.getArticuloId()).isEqualTo(100L);
        assertThat(entity.getCantidad()).isEqualByComparingTo(new BigDecimal("5"));
        assertThat(entity.getPrecioUnitario()).isEqualByComparingTo(new BigDecimal("100"));
    }

    @Test
    void updateEntity_soloActualizaCamposMapeados() {
        Cotizacion entity = new Cotizacion();
        entity.setId(1L);
        entity.setSucursalId(1L);
        entity.setProveedorId(10L);
        entity.setFecha(LocalDate.of(2026, 1, 1));
        entity.setMonedaId(1L);
        entity.setTotal(new BigDecimal("500"));
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(OffsetDateTime.now());

        CotizacionRequest req = new CotizacionRequest();
        req.setProveedorId(20L);
        req.setFecha(LocalDate.of(2026, 6, 15));
        req.setMonedaId(2L);

        mapper.updateEntity(req, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getSucursalId()).isEqualTo(1L);
        assertThat(entity.getTotal()).isEqualByComparingTo(new BigDecimal("500"));
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getProveedorId()).isEqualTo(20L);
        assertThat(entity.getFecha()).isEqualTo(LocalDate.of(2026, 6, 15));
        assertThat(entity.getMonedaId()).isEqualTo(2L);
    }

    @Test
    void toEntity_conNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    @Test
    void toDetEntity_conNull_retornaNull() {
        assertThat(mapper.toDetEntity(null)).isNull();
    }

    @Test
    void updateEntity_conRequestNull_preservaEntidad() {
        Cotizacion entity = new Cotizacion();
        entity.setId(1L);
        entity.setProveedorId(10L);
        entity.setMonedaId(2L);

        mapper.updateEntity(null, entity);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getProveedorId()).isEqualTo(10L);
        assertThat(entity.getMonedaId()).isEqualTo(2L);
    }
}
