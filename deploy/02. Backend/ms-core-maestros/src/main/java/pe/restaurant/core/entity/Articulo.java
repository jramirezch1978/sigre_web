package pe.restaurant.core.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "articulo", schema = "core")
public class Articulo extends BaseEntity {

    @Column(nullable = false, length = 30)
    private String codigo;

    @Column(nullable = false, length = 220)
    private String nombre;

    @Column(nullable = false, length = 20)
    private String tipo;

    @Column(name = "unidad_medida_id", nullable = false)
    private Long unidadMedidaId;

    @Column(name = "articulo_categ_id")
    private Long articuloCategId;

    @Column(name = "articulo_sub_categ_id")
    private Long articuloSubCategId;

    @Column(name = "marca_id")
    private Long marcaId;

    @Column(name = "color_id")
    private Long colorId;

    @Column(name = "precio_venta", precision = 18, scale = 4)
    private java.math.BigDecimal precioVenta;

    @Column(name = "codigo_barras", length = 80)
    private String codigoBarras;

    @Column(name = "imagen_blob", columnDefinition = "bytea")
    private byte[] imagenBlob;

    @Column(name = "imagen_url")
    private String imagenUrl;

    @Column(name = "es_ventable", nullable = false)
    private Boolean esVentable = true;

    @Transient
    private Long articuloClaseId;

    @Transient
    private Long naturalezaContableId;

    @Transient
    private String descripcion;
}
