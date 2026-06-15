package com.sigre.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;
import java.util.Date;

@Entity
@Table(name = "codigo_flujo_caja", schema = "finanzas",
        uniqueConstraints = @UniqueConstraint(columnNames = {"codigo"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class CodigoFlujoCaja extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "codigo", nullable = false, length = 20, unique = true)
    private String codigo;

    @Column(name = "grupo_codigo_flujo_caja_id")
    private Long grupoCodigoFlujoCajaId;  // FK interna a grupo_codigo_flujo_caja

    @Column(name = "nombre", nullable = false, length = 150)
    private String nombre;

    @Column(name = "tipo", nullable = false, length = 20)
    private String tipo;

    @Column(name = "factor", precision = 12, scale = 3)
    private java.math.BigDecimal factor;

    @Column(name = "factor_flujo_caja")
    private Short factorFlujoCaja = 0;

    @Column(name = "orden", nullable = false)
    private Integer orden = 0;

    @Column(name = "cod_usr", length = 20)
    private String codUsr;

    @Column(name = "fec_registro", nullable = false)
    private Date fecRegistro = new Date();

}
