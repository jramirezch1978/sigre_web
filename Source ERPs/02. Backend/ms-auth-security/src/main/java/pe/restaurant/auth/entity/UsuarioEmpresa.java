package pe.restaurant.auth.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Relación usuario-empresa (RBAC / multiempresa). Tabla {@code auth.usuario_empresa}.
 * Estado por {@code flag_estado VARCHAR(1)} ('1' activo, '0' anulado).
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "usuario_empresa", schema = "auth")
public class UsuarioEmpresa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(name = "empresa_id", nullable = false)
    private Long empresaId;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    public Boolean getActivo() {
        return "1".equals(flagEstado);
    }

    public void setActivo(Boolean activo) {
        this.flagEstado = Boolean.TRUE.equals(activo) ? "1" : "0";
    }
}
