package com.sigre.almacen.model.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "VALE_MOV_ALM")
@Data
public class ValeMovAlm {

    @EmbeddedId
    private ValeMovAlmId id;

    @Column(name = "FECHA_MOV")
    private LocalDate fechaMov;

    @Column(name = "TIPO_MOV", length = 10)
    private String tipoMov; // ING, SAL

    @Column(name = "ALMACEN", length = 10)
    private String almacen;

    @Column(name = "GLOSA", length = 500)
    private String glosa;

    @Column(name = "VALOR_TOTAL", precision = 18, scale = 2)
    private BigDecimal valorTotal;

    @Column(name = "FLAG_ESTADO", length = 1)
    private String flagEstado;

    @Column(name = "FLAG_CONTAB", length = 1)
    private String flagContabilizado;
}

