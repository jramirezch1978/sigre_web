package com.sigre.rrhh.entity;

import com.sigre.common.entity.AuditOnlyMappedEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "adelanto_quincena", schema = "rrhh")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class AdelantoQuincena extends AuditOnlyMappedEntity {

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "concepto_planilla_id", nullable = false)
    private Long conceptoPlanillaId;

    @Column(name = "fec_proceso", nullable = false)
    private LocalDate fecProceso;

    @Column(name = "imp_adelanto", nullable = false, precision = 13, scale = 2)
    private BigDecimal impAdelanto = BigDecimal.ZERO;

    @Column(name = "flag_replicacion", nullable = false, length = 1)
    private String flagReplicacion = "1";
}
