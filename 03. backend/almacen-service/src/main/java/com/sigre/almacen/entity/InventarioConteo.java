package com.sigre.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "inventario_conteo", schema = "almacen")
public class InventarioConteo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "almacen_id", nullable = false)
    private Long almacenId;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "fecha_conteo", nullable = false)
    private LocalDate fechaConteo;

    @Column(name = "nro_conteo", nullable = false)
    private Integer nroConteo = 1;

    @Column(name = "saldo_sistema", precision = 18, scale = 4)
    private BigDecimal saldoSistema;

    @Column(name = "cantidad_conteo_1", precision = 18, scale = 4)
    private BigDecimal cantidadConteo1;

    @Column(name = "auditor_conteo_1", length = 120)
    private String auditorConteo1;

    @Column(name = "nro_ficha_conteo_1", length = 30)
    private String nroFichaConteo1;

    @Column(name = "cantidad_conteo_2", precision = 18, scale = 4)
    private BigDecimal cantidadConteo2;

    @Column(name = "auditor_conteo_2", length = 120)
    private String auditorConteo2;

    @Column(name = "nro_ficha_conteo_2", length = 30)
    private String nroFichaConteo2;

    @Column(name = "costo_unitario", precision = 18, scale = 6)
    private BigDecimal costoUnitario;

    @Column(precision = 18, scale = 4)
    private BigDecimal diferencia;

    @Column(name = "vale_mov_ajuste_id")
    private Long valeMovAjusteId;

    @Column(name = "lote_pallet_id")
    private Long lotePalletId;

    @Column(name = "ubicacion_id")
    private Long ubicacionId;

    @Column(name = "usuario_id")
    private Long usuarioId;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private OffsetDateTime fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private OffsetDateTime fecModificacion;

    @PrePersist
    void prePersist() {
        fecCreacion = OffsetDateTime.now();
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
    }
}
