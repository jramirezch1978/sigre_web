package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "aprobador_configurado", schema = "compras")
public class AprobadorConfigurado {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;

    @Column(nullable = false)
    private Integer nivel;

    @Column(name = "aprobador_id", nullable = false)
    private Long aprobadorId;

    @Column(name = "monto_minimo", precision = 18, scale = 4)
    private BigDecimal montoMinimo;

    @Column(name = "monto_maximo", precision = 18, scale = 4)
    private BigDecimal montoMaximo;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";
}
