package com.sigre.produccion.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.AuditOnlyMappedEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "ot_admin_uder", schema = "produccion")
public class OtAdminUder extends AuditOnlyMappedEntity {

    @Column(name = "ot_administracion_id", nullable = false)
    private Long otAdministracionId;

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";
}
