package pe.restaurant.finanzas.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FlujoCajaNodo {
    // Discriminador: ACTIVIDAD | GRUPO | CODIGO
    private String tipoNivel;

    // Comunes a los 3 niveles
    private Long id;
    private String codigo;
    private String nombre;
    private Integer orden;
    private String flagEstado;

    // ACTIVIDAD only
    private String flagTipoFlujo;

    // GRUPO only
    private String flagReporte;
    private String factor;

    // CODIGO only
    private String tipo;
    private Integer factorFlujoCaja;
    private String codUsr;

    // Árbol (recursivo)
    private List<FlujoCajaNodo> hijos;

    // Response only — se ignoran en request
    private Long parentId;
    private Boolean activo;
    private String createdBy;
    private String fecCreacion;
    private String updatedBy;
    private String fecModificacion;
}
