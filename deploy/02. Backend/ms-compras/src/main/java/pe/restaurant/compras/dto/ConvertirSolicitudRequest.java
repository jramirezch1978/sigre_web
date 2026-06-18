package pe.restaurant.compras.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConvertirSolicitudRequest {
    @NotBlank
    private String destino;
    @NotEmpty
    private List<Long> proveedorIds;
    private Long monedaId;
}
