package pe.restaurant.auth.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Permiso de acción sobre una opción de menú asignada a un rol (RBAC).
 * Tabla {@code auth.rol_opcion_menu_accion}.
 * Estado por {@code flag_estado VARCHAR(1)} ('1' activo, '0' anulado).
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "rol_opcion_menu_accion", schema = "auth")
public class RolOpcionMenuAccion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "rol_opcion_menu_id", nullable = false)
    private Long rolOpcionMenuId;

    @Column(name = "accion_id", nullable = false)
    private Long accionId;

    @Column(nullable = false)
    private Boolean permitido = true;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    public Boolean getActivo() {
        return "1".equals(flagEstado);
    }

    public void setActivo(Boolean activo) {
        this.flagEstado = Boolean.TRUE.equals(activo) ? "1" : "0";
    }
}
