package pe.restaurant.core.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "grupo_tipo_doc_det", schema = "core")
public class GrupoTipoDocDet extends BaseEntity {

    @Column(name = "grupo_tipo_doc_id", nullable = false)
    private Long grupoTipoDocId;

    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;
}
