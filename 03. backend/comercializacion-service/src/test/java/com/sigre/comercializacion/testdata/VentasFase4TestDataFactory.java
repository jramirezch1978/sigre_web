package com.sigre.comercializacion.testdata;

import com.sigre.comercializacion.dto.request.*;
import com.sigre.comercializacion.entity.CierreCaja;
import com.sigre.comercializacion.entity.DescuentoPromocion;
import com.sigre.comercializacion.entity.OrdenVenta;
import com.sigre.comercializacion.entity.OrdenVentaDet;
import com.sigre.comercializacion.entity.Proforma;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Builders para tests unitarios Fase 4 (OV, proforma, cierre caja, descuentos).
 * Los datos JDBC idempotentes viven en {@link VentasTestDataFactory} (componente Spring).
 */
public final class VentasFase4TestDataFactory {

    private VentasFase4TestDataFactory() {}

    public static OrdenVentaDetLineRequest ordenVentaLine(Long articuloId, BigDecimal cant, BigDecimal punit) {
        return OrdenVentaDetLineRequest.builder()
                .articuloId(articuloId)
                .lineaNro(1)
                .cantProyectada(cant)
                .valorUnitario(punit)
                .build();
    }

    public static OrdenVentaRequest ordenVentaRequest(String nroOpcional, Long articuloId) {
        return OrdenVentaRequest.builder()
                .sucursalId(1L)
                .nroOrdenVenta(nroOpcional)
                .fechaEmision(LocalDate.now())
                .detalles(List.of(ordenVentaLine(articuloId, new BigDecimal("2"), new BigDecimal("10"))))
                .build();
    }

    public static OrdenVenta ordenVentaStub(Long id) {
        OrdenVenta ov = new OrdenVenta();
        ov.setId(id);
        ov.setSucursalId(1L);
        ov.setNroOrdenVenta("OV-STUB-" + id);
        ov.setFechaEmision(LocalDate.now());
        ov.setMontoTotal(new BigDecimal("20.0000"));
        ov.setMontoFacturado(BigDecimal.ZERO);
        return ov;
    }

    public static OrdenVenta ordenVentaStubConDetalles(Long id, Long almacenId) {
        OrdenVenta ov = ordenVentaStub(id);
        OrdenVentaDet det = new OrdenVentaDet();
        det.setId(100L);
        det.setOrdenVenta(ov);
        det.setArticuloId(50L);
        det.setLineaNro(1);
        det.setCantProyectada(new BigDecimal("10"));
        det.setCantProcesada(BigDecimal.ZERO);
        det.setCantFacturada(BigDecimal.ZERO);
        det.setValorUnitario(new BigDecimal("2.0000"));
        det.setValorImpuesto(BigDecimal.ZERO);
        det.setSubtotal(new BigDecimal("20.0000"));
        det.setAlmacenId(almacenId);
        ov.getDetalles().add(det);
        return ov;
    }

    public static ProformaDetLineRequest proformaLine(Long articuloId, BigDecimal cant, BigDecimal precio) {
        return ProformaDetLineRequest.builder()
                .articuloId(articuloId)
                .descripcion("Test")
                .cantidad(cant)
                .precioUnitario(precio)
                .build();
    }

    public static ProformaRequest proformaRequest(String numeroOpcional, Long articuloId) {
        return ProformaRequest.builder()
                .sucursalId(1L)
                .numero(numeroOpcional)
                .fecha(LocalDate.now())
                .fechaValidez(LocalDate.now().plusDays(7))
                .detalles(List.of(proformaLine(articuloId, BigDecimal.ONE, new BigDecimal("100"))))
                .build();
    }

    public static Proforma proformaStub(Long id) {
        Proforma p = new Proforma();
        p.setId(id);
        p.setNumero("PF-STUB-" + id);
        p.setFecha(LocalDate.now());
        p.setSubtotal(BigDecimal.ZERO);
        p.setIgv(BigDecimal.ZERO);
        p.setTotal(BigDecimal.ZERO);
        return p;
    }

    public static CierreCajaRequest cierreAbiertoRequest(Long turnoId) {
        return CierreCajaRequest.builder()
                .turnoId(turnoId)
                .ventasEfectivo(new BigDecimal("10"))
                .ventasTotal(new BigDecimal("17"))
                .fondoInicial(new BigDecimal("100"))
                .observaciones("unit-test")
                .build();
    }

    public static CierreCajaCerrarRequest cierreCerrarRequest(BigDecimal fondoFinal) {
        return CierreCajaCerrarRequest.builder()
                .fondoFinal(fondoFinal)
                .diferencia(new BigDecimal("5.0000"))
                .build();
    }

    public static CierreCaja cierreAbiertoStub(Long id, Long turnoId) {
        CierreCaja c = new CierreCaja();
        c.setId(id);
        c.setTurnoId(turnoId);
        c.setFondoInicial(new BigDecimal("100.0000"));
        c.setVentasTotal(new BigDecimal("50.0000"));
        c.setFechaCierre(null);
        return c;
    }

    public static DescuentoPromocionRequest descuentoRequest(String nombre, String tipo) {
        return DescuentoPromocionRequest.builder()
                .nombre(nombre)
                .tipo(tipo)
                .valor(new BigDecimal("10"))
                .fechaInicio(LocalDate.now())
                .fechaFin(LocalDate.now().plusMonths(1))
                .build();
    }

    public static DescuentoPromocion descuentoStub(Long id, String flagEstado) {
        DescuentoPromocion d = new DescuentoPromocion();
        d.setId(id);
        d.setNombre("X");
        d.setTipo("PCT");
        d.setFlagEstado(flagEstado);
        return d;
    }
}
