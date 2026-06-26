package pe.restaurant.auth.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Opción de menú (RBAC). Tabla {@code auth.opcion_menu}.
 * Estado por {@code flag_estado VARCHAR(1)} ('1' activo, '0' anulado).
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "opcion_menu", schema = "auth")
public class OpcionMenu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "modulo_id", nullable = false)
    private Long moduloId;

    @Column(nullable = false, unique = true, length = 80)
    private String codigo;

    @Column(nullable = false, length = 160)
    private String nombre;

    @Column(name = "ruta_frontend", length = 250)
    private String rutaFrontend;

    @Column(name = "opcion_padre_id")
    private Long opcionPadreId;

    @Column(nullable = false)
    private Integer orden = 0;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    public Boolean getActivo() {
        return "1".equals(flagEstado);
    }

    public void setActivo(Boolean activo) {
        this.flagEstado = Boolean.TRUE.equals(activo) ? "1" : "0";
    }
}
