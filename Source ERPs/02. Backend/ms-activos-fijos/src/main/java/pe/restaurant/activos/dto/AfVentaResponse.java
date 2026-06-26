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
    private Long cntasCobrarId;
    private Long docTipoId;
    private String serieDoc;
    private String nroDoc;
    private LocalDate fechaBaja;
    private String motivo;
    private BigDecimal valorVenta;
    private BigDecimal depreciacionAcumulada;
    private BigDecimal valorNetoContable;
    private String comprador;
    private String flagEstado;
}
