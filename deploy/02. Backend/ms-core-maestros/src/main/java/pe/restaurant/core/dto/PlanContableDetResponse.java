package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Cuenta del plan contable detalle expuesta por core para selectores y para la
 * validación remota desde ms-finanzas (Feign). Mantiene la misma forma JSON que
 * espera el cliente Feign (id, cntaCtbl, nombre, tipo, naturaleza, flagEstado).
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PlanContableDetResponse {
    private Long id;
    private String cntaCtbl;
    private String nombre;
    private String tipo;
    private String naturaleza;
    private String flagEstado;
}
