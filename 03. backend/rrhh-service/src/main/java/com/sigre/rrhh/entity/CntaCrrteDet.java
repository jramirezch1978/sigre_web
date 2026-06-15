package com.sigre.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data @EqualsAndHashCode(callSuper = true)
@NoArgsConstructor @AllArgsConstructor
@Entity @Table(name = "cnta_crrte_det", schema = "rrhh")
public class CntaCrrteDet extends BaseEntity {

    @Column(name = "cnta_crrte_id", nullable = false) private Long cntaCrrteId;
    @Column(name = "fecha_movimiento", nullable = false) private LocalDate fechaMovimiento;
    @Column(name = "tipo_movimiento_cnta_crrte_id", nullable = false) private Long tipoMovimientoCntaCrrteId;
    @Column(name = "concepto", columnDefinition = "TEXT") private String concepto;
    @Column(name = "monto", nullable = false, precision = 18, scale = 4) private BigDecimal monto;
    @Column(name = "referencia", length = 120) private String referencia;
}
