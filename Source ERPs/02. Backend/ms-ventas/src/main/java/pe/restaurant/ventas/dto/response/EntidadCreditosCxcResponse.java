package pe.restaurant.ventas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EntidadCreditosCxcResponse {
    private Long id;
    private Long entidadContribuyenteId;
    private String entidadRazonSocial;
    private String entidadRuc;
    private Long monedaId;
    private String monedaSimbolo;
    private BigDecimal limiteCredito;
    private Integer diasCredito;
    private String flagEstado;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
