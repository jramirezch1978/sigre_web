package com.sigre.core.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

/** Línea de crédito de una relación comercial (ventas.entidad_creditos_cxc). */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "entidad_creditos_cxc", schema = "ventas")
public class LineaCredito extends BaseEntity {

    @ManyToOne(optional = false)
    @JoinColumn(name = "entidad_contribuyente_id")
    private RelacionComercial relacionComercial;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "limite_credito", nullable = false, precision = 18, scale = 4)
    private BigDecimal limiteCredito = BigDecimal.ZERO;

    @Column(name = "dias_credito", nullable = false)
    private Integer diasCredito = 0;

    @Column(name = "fecha_vencimiento")
    private LocalDate fechaVencimiento;
}
