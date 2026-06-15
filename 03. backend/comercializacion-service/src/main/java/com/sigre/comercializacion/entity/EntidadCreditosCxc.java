package com.sigre.comercializacion.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;

@Entity
@Table(name = "entidad_creditos_cxc", schema = "ventas")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class EntidadCreditosCxc extends BaseEntity {

    @Column(name = "entidad_contribuyente_id", nullable = false)
    private Long entidadContribuyenteId;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "limite_credito", nullable = false, precision = 18, scale = 4)
    private BigDecimal limiteCredito = BigDecimal.ZERO;

    @Column(name = "dias_credito", nullable = false)
    private Integer diasCredito = 0;
}
