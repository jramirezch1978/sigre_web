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
@Table(name = "doc_tipo_num", schema = "core")
public class DocTipoNum extends BaseEntity {

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;

    @Column(name = "origen_id", nullable = false)
    private Long origenId = 0L;

    @Column(name = "anio", nullable = false)
    private Integer anio;

    @Column(name = "ultimo_numero", nullable = false)
    private Long ultimoNumero = 0L;
}
