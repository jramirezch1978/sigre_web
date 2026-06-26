package pe.restaurant.auth.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Opción de menú habilitada directamente a un usuario en una empresa (RBAC).
 * Tabla {@code auth.usuario_opcion_menu}.
 * Estado por {@code flag_estado VARCHAR(1)} ('1' activo, '0' anulado).
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "usuario_opcion_menu", schema = "auth")
public class UsuarioOpcionMenu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(name = "empresa_id", nullable = false)
    private Long empresaId;

    @Column(name = "opcion_menu_id", nullable = false)
    private Long opcionMenuId;

    @Column(nullable = false)
    private Boolean habilitado = true;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    public Boolean getActivo() {
        return "1".equals(flagEstado);
    }

    public void setActivo(Boolean activo) {
        this.flagEstado = Boolean.TRUE.equals(activo) ? "1" : "0";
    }
}
