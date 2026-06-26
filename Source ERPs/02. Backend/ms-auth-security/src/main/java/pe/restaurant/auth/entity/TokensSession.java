package pe.restaurant.auth.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tokens_session", schema = "auth")
public class TokensSession {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(name = "empresa_id", nullable = false)
    private Long empresaId;

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "jwt_compacto", columnDefinition = "TEXT")
    private String jwtCompacto;

    @Column(name = "expira_en", nullable = false)
    private OffsetDateTime expiraEn;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    @Column(name = "fec_creacion", nullable = false, updatable = false)
    private OffsetDateTime fecCreacion;

    @Column(name = "cerrado_en")
    private OffsetDateTime cerradoEn;

    @PrePersist
    protected void onCreate() {
        if (fecCreacion == null) {
            fecCreacion = OffsetDateTime.now();
        }
    }

    public Boolean getActivo() {
        return "1".equals(flagEstado);
    }

    public void setActivo(Boolean activo) {
        this.flagEstado = Boolean.TRUE.equals(activo) ? "1" : "0";
    }
}
