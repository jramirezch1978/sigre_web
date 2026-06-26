package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;
import pe.restaurant.common.entity.BaseEntity;

/**
 * Entidad que representa un área organizacional en la estructura jerárquica de la empresa.
 * Soporta relaciones padre-hijo para formar un árbol N-ario de áreas.
 * Extiende de BaseEntity para heredar campos de auditoría y flag_estado.
 */
@Entity
@Table(name = "area", schema = "rrhh")
@Data
@ToString(callSuper = true)
@EqualsAndHashCode(callSuper = false)
@NoArgsConstructor
@AllArgsConstructor
public class Area extends BaseEntity {

    /** Código SIGRE (negocio); la PK es {@code id}. */
    @Column(name = "codigo", length = 10)
    private String codigo;
    
    @Column(name = "nombre", nullable = false, length = 120)
    private String nombre;
    
    @Column(name = "padre_id")
    private Long padreId;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "padre_id", insertable = false, updatable = false)
    private Area padre;
    
    @Column(name = "responsable_id")
    private Long responsableId;
}
