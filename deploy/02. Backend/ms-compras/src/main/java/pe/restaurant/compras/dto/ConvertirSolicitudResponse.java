package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConvertirSolicitudResponse {
    private Long solicitudId;
    private String destino;
    private List<Long> documentosGenerados;
}
