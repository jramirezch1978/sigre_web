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

@Data @EqualsAndHashCode(callSuper = true)
@NoArgsConstructor @AllArgsConstructor
@Entity @Table(name = "prestamo", schema = "rrhh")
public class Prestamo extends BaseEntity {

    @Column(name = "trabajador_id", nullable = false) private Long trabajadorId;
    @Column(name = "monto_total", nullable = false, precision = 18, scale = 4) private BigDecimal montoTotal;
    @Column(name = "cuotas", nullable = false) private Integer cuotas;
    @Column(name = "cuota_mensual", precision = 18, scale = 4) private BigDecimal cuotaMensual;
    @Column(name = "saldo", precision = 18, scale = 4) private BigDecimal saldo;
}
