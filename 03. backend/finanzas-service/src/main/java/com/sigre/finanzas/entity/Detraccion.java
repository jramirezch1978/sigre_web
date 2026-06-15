package com.sigre.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "detraccion", schema = "finanzas",
        uniqueConstraints = @UniqueConstraint(name = "UQ_DETRACCION_01", columnNames = "nro_detraccion"))
@EntityListeners(AuditingEntityListener.class)
public class Detraccion extends BaseEntity {

    @Column(name = "cntas_pagar_id")
    private Long cntasPagarId;

    @Column(name = "nro_detraccion", nullable = false, length = 10)
    private String nroDetraccion;

    @Column(name = "fecha_registro")
    private LocalDate fechaRegistro;

    @Column(name = "nro_deposito", length = 15)
    private String nroDeposito;

    @Column(name = "fecha_deposito")
    private LocalDate fechaDeposito;

    @Column(name = "cod_usr", length = 6)
    private String codUsr;

    @Column(nullable = false, precision = 13, scale = 2)
    private BigDecimal importe = BigDecimal.ZERO;

    @Column(name = "flag_tabla", length = 1)
    private String flagTabla;

    @Column(name = "org_caja_banc", length = 2)
    private String orgCajaBanc;

    @Column(name = "nro_reg_caja_banc", precision = 10, scale = 0)
    private Long nroRegCajaBanc;

    @Column(name = "tipo_doc_cxc", length = 4)
    private String tipoDocCxc;

    @Column(name = "nro_doc_cxc", length = 10)
    private String nroDocCxc;
}
