package pe.restaurant.produccion.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.AuditOnlyMappedEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "articulo_doc_tecnica_caract_det", schema = "produccion")
public class ArticuloDocTecnicaCaractDet extends AuditOnlyMappedEntity {

    @Column(name = "articulo_doc_tecnica_id", nullable = false)
    private Long articuloDocTecnicaId;

    @Column(name = "caracteristica", nullable = false, length = 120)
    private String caracteristica;

    @Column(name = "valor", nullable = false, length = 220)
    private String valor;

    @Column(name = "unidad_medida_id")
    private Long unidadMedidaId;
}
