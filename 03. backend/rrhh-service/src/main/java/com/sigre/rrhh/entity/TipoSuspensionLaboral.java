package com.sigre.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tipo_suspension_laboral", schema = "rrhh")
public class TipoSuspensionLaboral extends BaseEntity {

    @Column(name = "codigo", length = 10, nullable = false, unique = true)
    private String codigo;

    @Column(name = "nombre", length = 150, nullable = false)
    private String nombre;

    @Column(name = "flag_tipo_susp", length = 1)
    private String flagTipoSusp;

    @Column(name = "tipo_subsidio_id")
    private Long tipoSubsidioId;

    @Column(name = "flag_citt", length = 1, nullable = false)
    private String flagCitt = "0";

    @Column(name = "flag_datos_lesion", length = 1, nullable = false)
    private String flagDatosLesion = "0";
}
