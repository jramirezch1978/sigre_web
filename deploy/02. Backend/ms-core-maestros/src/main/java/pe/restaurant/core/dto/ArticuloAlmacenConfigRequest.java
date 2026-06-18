package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArticuloAlmacenConfigRequest {
    @NotNull
    private Long almacenId;
    private BigDecimal stockMin;
    private BigDecimal stockMax;
}
