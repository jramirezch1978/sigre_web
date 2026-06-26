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
@Table(name = "doc_tipo_num_serie", schema = "core")
public class DocTipoNumSerie extends BaseEntity {

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;

    @Column(name = "serie", nullable = false, length = 10)
    private String serie;

    @Column(name = "ultimo_numero", nullable = false)
    private Long ultimoNumero = 0L;
}
