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
@Entity @Table(name = "novedad_rrhh_det", schema = "rrhh")
public class NovedadRrhhDet extends BaseEntity {

    @Column(name = "novedad_rrhh_id", nullable = false) private Long novedadRrhhId;
    @Column(name = "fecha_proceso", nullable = false) private LocalDate fechaProceso;
    @Column(name = "monto_planilla", precision = 18, scale = 4) private BigDecimal montoPlanilla;
    @Column(name = "monto_seguro", precision = 18, scale = 4) private BigDecimal montoSeguro;
    @Column(name = "referencia_doc", length = 80) private String referenciaDoc;
}
