package pe.restaurant.core.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.io.Serializable;
import java.time.Instant;
import java.util.Objects;

/**
 * core.numerador_documento — correlativo por (nombre_tabla, sucursalId, ano).
 * PK compuesta. El correlativo se gestiona vía funciones de BD (core.fn_*).
 */
@Getter
@Setter
@NoArgsConstructor
@Entity
@EntityListeners(AuditingEntityListener.class)
@IdClass(NumeradorDocumento.NumeradorDocumentoId.class)
@Table(name = "numerador_documento", schema = "core")
public class NumeradorDocumento {

    @Id
    @Column(name = "nombre_tabla", nullable = false, length = 128)
    private String nombreTabla;

    @Id
    @Column(name = "sucursalid", nullable = false)
    private Long sucursalId;

    @Id
    @Column(name = "ano", nullable = false)
    private Short ano;

    @Column(name = "ult_nro", nullable = false)
    private Long ultNro = 1L;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    @CreatedBy
    @Column(name = "created_by", updatable = false)
    private Long createdBy;

    @CreatedDate
    @Column(name = "fec_creacion", updatable = false)
    private Instant fecCreacion;

    @LastModifiedBy
    @Column(name = "updated_by")
    private Long updatedBy;

    @LastModifiedDate
    @Column(name = "fec_modificacion")
    private Instant fecModificacion;

    @Getter
    @Setter
    @NoArgsConstructor
    public static class NumeradorDocumentoId implements Serializable {
        private String nombreTabla;
        private Long sucursalId;
        private Short ano;

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof NumeradorDocumentoId that)) return false;
            return Objects.equals(nombreTabla, that.nombreTabla)
                    && Objects.equals(sucursalId, that.sucursalId)
                    && Objects.equals(ano, that.ano);
        }

        @Override
        public int hashCode() {
            return Objects.hash(nombreTabla, sucursalId, ano);
        }
    }
}
