package com.sigre.comercializacion.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "orden_venta_det", schema = "ventas")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class OrdenVentaDet extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "orden_venta_id", nullable = false)
    private OrdenVenta ordenVenta;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "linea_nro")
    private Integer lineaNro;

    @Column(name = "cant_proyectada", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantProyectada;

    @Column(name = "fec_proyectada")
    private LocalDate fecProyectada;

    @Column(name = "cant_procesada", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantProcesada = BigDecimal.ZERO;

    @Column(name = "cant_facturada", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantFacturada = BigDecimal.ZERO;

    @Column(name = "valor_unitario", nullable = false, precision = 18, scale = 6)
    private BigDecimal valorUnitario;

    @Column(name = "tipos_impuesto_id")
    private Long tiposImpuestoId;

    @Column(name = "valor_impuesto", precision = 18, scale = 4)
    private BigDecimal valorImpuesto = BigDecimal.ZERO;

    @Column(name = "subtotal", nullable = false, precision = 18, scale = 4)
    private BigDecimal subtotal = BigDecimal.ZERO;

    @Column(name = "almacen_id")
    private Long almacenId;

    @Column(name = "centros_costo_id")
    private Long centrosCostoId;
}
