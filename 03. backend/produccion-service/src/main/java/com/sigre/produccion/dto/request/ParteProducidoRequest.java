package com.sigre.produccion.dto.request;

import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ParteProducidoRequest {

    @NotNull(message = "El artículo es requerido")
    private Long articuloId;

    private Long unidadMedidaId;

    @NotNull(message = "La cantidad producida es requerida")
    @Digits(integer = 18, fraction = 4, message = "Cantidad inválida")
    private BigDecimal cantidadProducida;
}
