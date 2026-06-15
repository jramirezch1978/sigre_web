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
@Table(name = "ot_administracion", schema = "produccion")
public class OtAdministracion extends AuditOnlyMappedEntity {

    @Column(name = "codigo", nullable = false, unique = true, length = 20)
    private String codigo;

    @Column(name = "nombre", nullable = false, length = 150)
    private String nombre;

    @Column(name = "flag_tipo_costo", nullable = false, length = 1)
    private String flagTipoCosto = "0";

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";
}
