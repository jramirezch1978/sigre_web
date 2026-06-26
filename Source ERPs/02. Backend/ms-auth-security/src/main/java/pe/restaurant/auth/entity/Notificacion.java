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
@Table(name = "notificacion", schema = "auth")
public class Notificacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(name = "empresa_id", nullable = false)
    private Long empresaId;

    @Column(nullable = false, length = 220)
    private String titulo;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String descripcion;

    @Column(nullable = false, length = 30)
    private String tipo = "INFO";

    @Column(name = "destino_tipo", nullable = false, length = 20)
    private String destinoTipo = "USUARIO";

    @Column(name = "grupo_codigo", length = 80)
    private String grupoCodigo;

    @Column(name = "origen_usuario_id")
    private Long origenUsuarioId;

    @Column(nullable = false)
    private Boolean leido = false;

    @Column(name = "leido_en")
    private OffsetDateTime leidoEn;

    @Column(name = "enviado_en", nullable = false)
    private OffsetDateTime enviadoEn;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    @PrePersist
    protected void onCreate() {
        if (enviadoEn == null) {
            enviadoEn = OffsetDateTime.now();
        }
    }

    public Boolean getActivo() {
        return "1".equals(flagEstado);
    }

    public void setActivo(Boolean activo) {
        this.flagEstado = Boolean.TRUE.equals(activo) ? "1" : "0";
    }
}
