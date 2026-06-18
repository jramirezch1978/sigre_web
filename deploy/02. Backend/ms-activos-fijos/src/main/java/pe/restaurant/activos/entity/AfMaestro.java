package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "af_maestro", schema = "activos")
public class AfMaestro extends BaseEntity {

    @Column(nullable = false, unique = true, length = 30)
    private String codigo;

    @Column(nullable = false, length = 220)
    private String nombre;

    @Column(name = "af_sub_clase_id", nullable = false)
    private Long afSubClaseId;

    @Column(name = "af_ubicacion_id")
    private Long afUbicacionId;

    @Column(name = "fecha_adquisicion", nullable = false)
    private LocalDate fechaAdquisicion;

    @Column(name = "valor_adquisicion", nullable = false, precision = 18, scale = 4)
    private BigDecimal valorAdquisicion;

    @Column(name = "valor_residual", nullable = false, precision = 18, scale = 4)
    private BigDecimal valorResidual = BigDecimal.ZERO;

    @Column(name = "proveedor_id")
    private Long proveedorId;

    @Transient
    private Integer unidadesProduccionTotales;

    @Transient
    private Integer unidadesProduccionPeriodo;

    @Transient
    private Long ordenCompraId;

    @Transient
    private Long ordenCompraLineaId;

    @Transient
    private Long recepcionCompraId;

    @Column(name = "factura_proveedor_serie", length = 20)
    private String facturaProveedorSerie;

    @Column(name = "factura_proveedor_numero", length = 30)
    private String facturaProveedorNumero;

    @Column(name = "factura_proveedor_fecha")
    private LocalDate facturaProveedorFecha;

    @Transient
    private Long cntblAsientoId;
}
