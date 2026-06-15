package com.sigre.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "programacion_pago_det", schema = "finanzas")
public class ProgramacionPagoDet extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "programacion_id", nullable = false)
    private ProgramacionPago programacionPago;

    @Column(name = "cntas_pagar_id")
    private Long cntasPagarId;

    @Column(name = "monto_programado", nullable = false, precision = 18, scale = 4)
    private BigDecimal montoProgramado;
}
