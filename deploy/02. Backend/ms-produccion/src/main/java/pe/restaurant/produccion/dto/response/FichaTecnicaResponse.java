package pe.restaurant.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FichaTecnicaResponse {

    private Long id;
    private String alergenos;
    private BigDecimal calorias;
    private BigDecimal proteinasG;
    private BigDecimal carbohidratosG;
    private BigDecimal grasasG;
    private BigDecimal fibraG;
    private BigDecimal sodioMg;
    private String tipoDieta;
    private String fotoPresentacionUrl;
    private Boolean tieneFotoBlob;
    private String instruccionesEmplatado;
    private Integer tiempoPreparacionMin;
    private Integer tiempoCoccionMin;
    private String temperaturaServicio;
}
