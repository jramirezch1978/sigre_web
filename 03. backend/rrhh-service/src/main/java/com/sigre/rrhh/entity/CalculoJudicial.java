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
@Table(name = "calculo_judicial", schema = "rrhh")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class CalculoJudicial extends AuditOnlyMappedEntity {

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "concepto_planilla_id", nullable = false)
    private Long conceptoPlanillaId;

    @Column(name = "secuencia", nullable = false)
    private Short secuencia;

    @Column(name = "fec_proceso", nullable = false)
    private LocalDate fecProceso;

    @Column(name = "imp_dolar", nullable = false, precision = 15, scale = 4)
    private BigDecimal impDolar = BigDecimal.ZERO;

    @Column(name = "imp_soles", nullable = false, precision = 15, scale = 4)
    private BigDecimal impSoles = BigDecimal.ZERO;

    @Column(name = "imp_bruto", nullable = false, precision = 15, scale = 4)
    private BigDecimal impBruto = BigDecimal.ZERO;

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "tipo_trabajador_id", nullable = false)
    private Long tipoTrabajadorId;

    @Column(name = "tipo_planilla_id", nullable = false)
    private Long tipoPlanillaId;
}
