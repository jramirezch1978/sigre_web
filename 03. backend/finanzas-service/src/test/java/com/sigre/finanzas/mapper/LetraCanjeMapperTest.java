package com.sigre.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import com.sigre.finanzas.dto.response.DestinoCanjeResponse;
import com.sigre.finanzas.dto.response.LetraCanjeDetalleResponse;
import com.sigre.finanzas.dto.response.LetraCanjeResponse;
import com.sigre.finanzas.dto.response.OrigenCanjeResponse;
import com.sigre.finanzas.entity.CntasPagar;
import com.sigre.finanzas.entity.CntasPagarDet;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


class LetraCanjeMapperTest {

    private LetraCanjeMapper mapper;
    private CntasPagar documentoOrigen;
    private CntasPagar documentoDestino;
    private List<CntasPagar> origenes;
    private List<CntasPagar> destinos;

    @BeforeEach
    void setUp() {
        mapper = new LetraCanjeMapper();

        documentoOrigen = new CntasPagar();
        documentoOrigen.setId(1L);
        documentoOrigen.setProveedorId(100L);
        documentoOrigen.setSerie("F001");
        documentoOrigen.setNumero("00001");
        documentoOrigen.setTotal(new BigDecimal("1000.00"));
        documentoOrigen.setSaldo(new BigDecimal("300.00"));
        documentoOrigen.setDetalles(new ArrayList<>());

        CntasPagarDet detalleCanje = new CntasPagarDet();
        detalleCanje.setReferencia("CANJE-2026-001");
        detalleCanje.setTipoMov("CANJE_ORIGEN");
        detalleCanje.setMonto(new BigDecimal("700.00"));
        detalleCanje.setFechaMov(LocalDate.of(2026, 4, 27));
        detalleCanje.setCreatedBy(10L);
        detalleCanje.setFecCreacion(java.time.Instant.parse("2026-04-27T10:30:00Z"));
        documentoOrigen.getDetalles().add(detalleCanje);

        documentoDestino = new CntasPagar();
        documentoDestino.setId(2L);
        documentoDestino.setDocTipoId(40L);
        documentoDestino.setSerie("LT01");
        documentoDestino.setNumero("000001");
        documentoDestino.setFechaEmision(LocalDate.of(2026, 4, 27));
        documentoDestino.setFechaVencimiento(LocalDate.of(2026, 5, 27));
        documentoDestino.setMonedaId(1L);
        documentoDestino.setTotal(new BigDecimal("350.00"));
        documentoDestino.setSaldo(new BigDecimal("350.00"));
        documentoDestino.setFlagEstado("1");

        origenes = Arrays.asList(documentoOrigen);
        destinos = Arrays.asList(documentoDestino);
    }


    // ==== toResponse — otros ====

    @Test
    void toResponse_ConDatosCompletos_MapeaCorrectamente() {
        LetraCanjeResponse response = mapper.toResponse("CANJE-2026-001", origenes, destinos);

        assertThat(response).isNotNull();
        assertThat(response.getReferencia()).isEqualTo("CANJE-2026-001");
        assertThat(response.getProveedorId()).isEqualTo(100L);
        assertThat(response.getMontoCanjeado()).isEqualTo(new BigDecimal("700.00"));
        assertThat(response.getCantidadOrigenes()).isEqualTo(1);
        assertThat(response.getCantidadDestinos()).isEqualTo(1);
        assertThat(response.getFechaCanje()).isEqualTo(LocalDate.of(2026, 4, 27));
        assertThat(response.getCreatedBy()).isEqualTo(10L);
    }


    // ==== toDetalleResponse — otros ====

    @Test
    void toDetalleResponse_ConOrigenesYDestinos_MapeaCorrectamente() {
        LetraCanjeDetalleResponse response = mapper.toDetalleResponse("CANJE-2026-001", origenes, destinos);

        assertThat(response).isNotNull();
        assertThat(response.getReferencia()).isEqualTo("CANJE-2026-001");
        assertThat(response.getProveedorId()).isEqualTo(100L);
        assertThat(response.getMontoCanjeado()).isEqualTo(new BigDecimal("700.00"));
        assertThat(response.getFechaCanje()).isEqualTo(LocalDate.of(2026, 4, 27));
        
        assertThat(response.getOrigenes()).isNotNull();
        assertThat(response.getOrigenes().size()).isEqualTo(1);
        
        assertThat(response.getDestinos()).isNotNull();
        assertThat(response.getDestinos().size()).isEqualTo(1);
    }


    // ==== toOrigenResponse — otros ====

    @Test
    void toOrigenResponse_ConDocumento_MapeaCorrectamente() {
        OrigenCanjeResponse response = mapper.toOrigenResponse(documentoOrigen, new BigDecimal("700.00"));

        assertThat(response).isNotNull();
        assertThat(response.getCntasPagarId()).isEqualTo(1L);
        assertThat(response.getSerie()).isEqualTo("F001");
        assertThat(response.getNumero()).isEqualTo("00001");
        assertThat(response.getTotalOriginal()).isEqualTo(new BigDecimal("1000.00"));
        assertThat(response.getMontoCanjeado()).isEqualTo(new BigDecimal("700.00"));
        assertThat(response.getSaldoFinal()).isEqualTo(new BigDecimal("300.00"));
    }


    // ==== toDestinoResponse — otros ====

    @Test
    void toDestinoResponse_ConDocumento_MapeaCorrectamente() {
        DestinoCanjeResponse response = mapper.toDestinoResponse(documentoDestino);

        assertThat(response).isNotNull();
        assertThat(response.getCntasPagarId()).isEqualTo(2L);
        assertThat(response.getDocTipoId()).isEqualTo(40L);
        assertThat(response.getSerie()).isEqualTo("LT01");
        assertThat(response.getNumero()).isEqualTo("000001");
        assertThat(response.getFechaEmision()).isEqualTo(LocalDate.of(2026, 4, 27));
        assertThat(response.getFechaVencimiento()).isEqualTo(LocalDate.of(2026, 5, 27));
        assertThat(response.getMonedaId()).isEqualTo(1L);
        assertThat(response.getTotal()).isEqualTo(new BigDecimal("350.00"));
        assertThat(response.getSaldo()).isEqualTo(new BigDecimal("350.00"));
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }
}
