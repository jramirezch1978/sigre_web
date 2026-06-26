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
@Table(name = "doc_tipo_usuario", schema = "core")
public class DocTipoUsuario extends BaseEntity {

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;

    @Column(name = "sucursal_id")
    private Long sucursalId;
}
