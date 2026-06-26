package pe.restaurant.produccion.dto.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FichaTecnicaRequest {

    private String alergenos;
    private BigDecimal calorias;
    private BigDecimal proteinasG;
    private BigDecimal carbohidratosG;
    private BigDecimal grasasG;
    private BigDecimal fibraG;
    private BigDecimal sodioMg;
    private String flagTipoDieta;
    private String fotoPresentacionUrl;
    private byte[] fotoBlob;
    private String instruccionesEmplatado;
    private Integer tiempoPreparacionMin;
    private Integer tiempoCoccionMin;
    private String flagTemperaturaServicio;
}
