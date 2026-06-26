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
 * core.num_tablas — correlativo genérico por (nombre_tabla, cod_origen).
 * PK compuesta; sin id ni flag_estado en el DDL.
 */
@Getter
@Setter
@NoArgsConstructor
@Entity
@EntityListeners(AuditingEntityListener.class)
@IdClass(NumTablas.NumTablasId.class)
@Table(name = "num_tablas", schema = "core")
public class NumTablas {

    @Id
    @Column(name = "nombre_tabla", nullable = false, length = 120)
    private String nombreTabla;

    @Id
    @Column(name = "cod_origen", nullable = false, length = 20)
    private String codOrigen = "XX";

    @Column(name = "ultimo_numero", nullable = false)
    private Long ultimoNumero = 0L;

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
    public static class NumTablasId implements Serializable {
        private String nombreTabla;
        private String codOrigen;

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof NumTablasId that)) return false;
            return Objects.equals(nombreTabla, that.nombreTabla)
                    && Objects.equals(codOrigen, that.codOrigen);
        }

        @Override
        public int hashCode() {
            return Objects.hash(nombreTabla, codOrigen);
        }
    }
}
