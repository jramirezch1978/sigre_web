package com.sigre.sync.entity.remote;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Entidad que mapea la tabla CONFIGURACION en Oracle (bd_remota).
 * Estructura: PARAMETRO (PK), VALOR_INT, VALOR_DEC, VALOR_CHAR, VALOR_DATE, FEC_REGISTRO
 */
@Entity
@Table(name = "configuracion")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ConfiguracionRemote {

    @Id
    @Column(name = "PARAMETRO", length = 50, nullable = false)
    private String parametro;

    @Column(name = "VALOR_INT", precision = 13, scale = 0)
    private Long valorInt;

    @Column(name = "VALOR_DEC", precision = 16, scale = 6)
    private BigDecimal valorDec;

    @Column(name = "VALOR_CHAR", length = 3000)
    private String valorChar;

    @Column(name = "VALOR_DATE")
    private LocalDateTime valorDate;

    @Column(name = "FEC_REGISTRO", nullable = false)
    private LocalDateTime fecRegistro;
}
