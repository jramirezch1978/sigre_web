package com.sigre.core.entity;

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
@Table(name = "detr_bien_serv", schema = "core")
public class Detraccion extends BaseEntity {

    @Column(name = "bien_serv", nullable = false, unique = true, length = 3)
    private String bienServ;

    @Column(length = 100)
    private String descripcion;

    @Column(name = "cod_sunat_pdbe", length = 2)
    private String codSunatPdbe;

    @Column(name = "tasa_pdbe", nullable = false, precision = 4, scale = 2)
    private BigDecimal tasaPdbe = BigDecimal.ZERO;

    @Column(name = "flag_ind_imp", length = 1)
    private String flagIndImp;

    @Column(name = "cntbl_tipo_detraccion_id")
    private Long cntblTipoDetraccionId;

    @Column(name = "monto_min_depre", nullable = false, precision = 6, scale = 2)
    private BigDecimal montoMinDepre = BigDecimal.ZERO;
}
