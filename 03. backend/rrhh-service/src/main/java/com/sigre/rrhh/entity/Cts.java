package com.sigre.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.AuditOnlyMappedEntity;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data @EqualsAndHashCode(callSuper = true)
@NoArgsConstructor @AllArgsConstructor
@Entity @Table(name = "cts", schema = "rrhh",
       uniqueConstraints = @UniqueConstraint(columnNames = {"trabajador_id", "anio", "periodo_cts_id"}))
public class Cts extends AuditOnlyMappedEntity {

    @Column(name = "trabajador_id", nullable = false) private Long trabajadorId;
    @Column(name = "anio", nullable = false) private Integer anio;
    @Column(name = "periodo_cts_id", nullable = false) private Long periodoCtsId;
    @Column(name = "remuneracion_computable", nullable = false, precision = 18, scale = 4) private BigDecimal remuneracionComputable;
    @Column(name = "meses_computables", nullable = false) private Integer mesesComputables;
    @Column(name = "dias_computables", nullable = false) private Integer diasComputables;
    @Column(name = "monto_cts", nullable = false, precision = 18, scale = 4) private BigDecimal montoCts;
    @Column(name = "entidad_financiera", length = 120) private String entidadFinanciera;
    @Column(name = "numero_cuenta_cts", length = 30) private String numeroCuentaCts;
    @Column(name = "fecha_deposito") private LocalDate fechaDeposito;
}
