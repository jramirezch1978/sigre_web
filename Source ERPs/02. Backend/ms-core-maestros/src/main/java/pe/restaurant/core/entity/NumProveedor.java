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

import java.time.Instant;

/**
 * core.num_proveedor — correlativo por (sucursal, serie, año).
 * Nota: el DDL NO define flag_estado, por eso no extiende BaseEntity.
 */
@Getter
@Setter
@NoArgsConstructor
@Entity
@EntityListeners(AuditingEntityListener.class)
@Table(name = "num_proveedor", schema = "core")
public class NumProveedor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "serie", nullable = false, length = 10)
    private String serie;

    @Column(name = "anio", nullable = false)
    private Integer anio;

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
}
