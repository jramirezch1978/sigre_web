package pe.restaurant.ventas.mapper;

import org.springframework.stereotype.Component;
import pe.restaurant.ventas.dto.response.*;
import pe.restaurant.ventas.entity.*;

import java.time.LocalDate;
import java.util.stream.Collectors;

@Component
public class VentasResponseMapper {

    /** Códigos de lectura para API (no etiquetas locales). */
    private static final String CIERRE_OPEN = "OPEN";
    private static final String CIERRE_CLOSED = "CLOSED";
    private static final String PROMO_VIGENCIA_OFF = "OFF";
    private static final String PROMO_VIGENCIA_SCHEDULED = "SCHEDULED";
    private static final String PROMO_VIGENCIA_EXPIRED = "EXPIRED";
    private static final String PROMO_VIGENCIA_ON = "ON";

    public OrdenVentaResponse toOrdenVentaResponse(OrdenVenta e) {
        if (e == null) {
            return null;
        }
        return OrdenVentaResponse.builder()
                .id(e.getId())
                .sucursalId(e.getSucursalId())
                .nroOrdenVenta(e.getNroOrdenVenta())
                .clienteId(e.getClienteId())
                .vendedorId(e.getVendedorId())
                .fechaEmision(e.getFechaEmision())
                .montoTotal(e.getMontoTotal())
                .flagEstado(e.getFlagEstado())
                .detalles(e.getDetalles() == null ? null : e.getDetalles().stream().map(this::toOvDet).collect(Collectors.toList()))
                .build();
    }

    private OrdenVentaDetResponse toOvDet(OrdenVentaDet d) {
        return OrdenVentaDetResponse.builder()
                .id(d.getId())
                .articuloId(d.getArticuloId())
                .lineaNro(d.getLineaNro())
                .cantProyectada(d.getCantProyectada())
                .valorUnitario(d.getValorUnitario())
                .subtotal(d.getSubtotal())
                .almacenId(d.getAlmacenId())
                .flagEstado(d.getFlagEstado())
                .build();
    }

    /** Listados: sin líneas para no tocar la colección lazy fuera de la transacción ({@code open-in-view=false}). */
    public ProformaResponse toProformaResponseForList(Proforma e) {
        return mapProforma(e, false);
    }

    /** Detalle completo (tras {@code findByIdWithDetalles}). */
    public ProformaResponse toProformaResponse(Proforma e) {
        return mapProforma(e, true);
    }

    private ProformaResponse mapProforma(Proforma e, boolean includeDetalles) {
        if (e == null) {
            return null;
        }
        var b = ProformaResponse.builder()
                .id(e.getId())
                .sucursalId(e.getSucursalId())
                .clienteId(e.getClienteId())
                .numero(e.getNumero())
                .fecha(e.getFecha())
                .fechaValidez(e.getFechaValidez())
                .monedaId(e.getMonedaId())
                .subtotal(e.getSubtotal())
                .igv(e.getIgv())
                .total(e.getTotal())
                .flagEstado(e.getFlagEstado());
        if (includeDetalles) {
            b.detalles(e.getDetalles() == null ? null
                    : e.getDetalles().stream().map(this::toPfDet).collect(Collectors.toList()));
        } else {
            b.detalles(null);
        }
        return b.build();
    }

    private ProformaDetResponse toPfDet(ProformaDet d) {
        return ProformaDetResponse.builder()
                .id(d.getId())
                .articuloId(d.getArticuloId())
                .descripcion(d.getDescripcion())
                .cantidad(d.getCantidad())
                .precioUnitario(d.getPrecioUnitario())
                .descuento(d.getDescuento())
                .subtotal(d.getSubtotal())
                .build();
    }

    public CierreCajaResponse toCierreCajaResponse(CierreCaja c) {
        if (c == null) {
            return null;
        }
        String estadoCierre = c.getFechaCierre() == null ? CIERRE_OPEN : CIERRE_CLOSED;
        return CierreCajaResponse.builder()
                .id(c.getId())
                .turnoId(c.getTurnoId())
                .ventasEfectivo(c.getVentasEfectivo())
                .ventasTarjeta(c.getVentasTarjeta())
                .ventasDigital(c.getVentasDigital())
                .ventasTotal(c.getVentasTotal())
                .propinasTotal(c.getPropinasTotal())
                .fondoInicial(c.getFondoInicial())
                .fondoFinal(c.getFondoFinal())
                .diferencia(c.getDiferencia())
                .observaciones(c.getObservaciones())
                .fechaCierre(c.getFechaCierre())
                .estadoCierre(estadoCierre)
                .flagEstado(c.getFlagEstado())
                .build();
    }

    public DescuentoPromocionResponse toDescuentoResponse(DescuentoPromocion d) {
        if (d == null) {
            return null;
        }
        return DescuentoPromocionResponse.builder()
                .id(d.getId())
                .nombre(d.getNombre())
                .tipo(d.getTipo())
                .valor(d.getValor())
                .fechaInicio(d.getFechaInicio())
                .fechaFin(d.getFechaFin())
                .diasAplicacion(d.getDiasAplicacion())
                .horaInicio(d.getHoraInicio())
                .horaFin(d.getHoraFin())
                .montoMinimo(d.getMontoMinimo())
                .flagEstado(d.getFlagEstado())
                .vigenciaDerivada(calcularVigencia(d))
                .build();
    }

    private String calcularVigencia(DescuentoPromocion d) {
        if (!"1".equals(d.getFlagEstado())) {
            return PROMO_VIGENCIA_OFF;
        }
        LocalDate hoy = LocalDate.now();
        if (d.getFechaInicio() != null && hoy.isBefore(d.getFechaInicio())) {
            return PROMO_VIGENCIA_SCHEDULED;
        }
        if (d.getFechaFin() != null && hoy.isAfter(d.getFechaFin())) {
            return PROMO_VIGENCIA_EXPIRED;
        }
        return PROMO_VIGENCIA_ON;
    }
}
