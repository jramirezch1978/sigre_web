package com.sigre.comercializacion.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "fs_factura_simpl", schema = "ventas",
       uniqueConstraints = @UniqueConstraint(columnNames = {"doc_tipo_id", "serie", "numero"}))
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"detalles", "pagos"})
public class FsFacturaSimpl extends BaseEntity {

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "punto_venta_id")
    private Long puntoVentaId;

    @Column(name = "cliente_id", nullable = false)
    private Long clienteId;

    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;

    @Column(name = "serie", nullable = false, length = 10)
    private String serie;

    @Column(name = "numero", nullable = false, length = 20)
    private String numero;

    @Column(name = "fecha_emision", nullable = false)
    private LocalDate fechaEmision;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "subtotal", nullable = false, precision = 18, scale = 4)
    private BigDecimal subtotal = BigDecimal.ZERO;

    @Column(name = "impuesto", nullable = false, precision = 18, scale = 4)
    private BigDecimal impuesto = BigDecimal.ZERO;

    @Column(name = "total", nullable = false, precision = 18, scale = 4)
    private BigDecimal total = BigDecimal.ZERO;

    @Column(name = "ano", nullable = false)
    private Integer ano;

    @Column(name = "mes", nullable = false)
    private Integer mes;

    @Column(name = "cntbl_libro_id", nullable = false)
    private Long cntblLibroId;

    @Column(name = "cntas_cobrar_id")
    private Long cntasCobrarId;

    @OneToMany(mappedBy = "factura", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<FsFacturaSimplDet> detalles = new ArrayList<>();

    @OneToMany(mappedBy = "factura", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<FsFacturaSimplPago> pagos = new ArrayList<>();
}
