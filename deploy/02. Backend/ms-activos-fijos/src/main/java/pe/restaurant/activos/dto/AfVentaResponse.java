package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfVentaResponse {

    private Long id;
    private Long afMaestroId;
    private LocalDate fechaBaja;
    private String motivo;
    private BigDecimal valorVenta;
    private String comprador;
    private String estado;
    private String tipoBaja;
    private String tipoDocumentoVenta;
    private String numeroDocumento;
    private BigDecimal depreciacionAcumulada;
    private BigDecimal valorNetoContable;
    private BigDecimal resultadoBaja;
    private String tipoSiniestro;
    private BigDecimal montoIndemnizacion;
    private String motivoObsolescencia;
    private String descripcionDetalle;
}
