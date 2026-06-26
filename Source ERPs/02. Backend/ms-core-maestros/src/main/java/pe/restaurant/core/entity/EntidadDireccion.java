package pe.restaurant.core.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "entidad_direccion", schema = "core")
public class EntidadDireccion extends BaseEntity {

    @Column(name = "entidad_contribuyente_id", nullable = false)
    private Long entidadContribuyenteId;

    @Column(name = "item", nullable = false)
    private Short item = 1;

    @Column(name = "descripcion", length = 60)
    private String descripcion;

    @Column(name = "dir_pais", length = 40)
    private String dirPais;

    @Column(name = "dir_dep_estado", length = 40)
    private String dirDepEstado;

    @Column(name = "dir_provincia", length = 40)
    private String dirProvincia;

    @Column(name = "dir_ciudad", length = 40)
    private String dirCiudad;

    @Column(name = "dir_distrito", length = 40)
    private String dirDistrito;

    @Column(name = "dir_urbanizacion", length = 40)
    private String dirUrbanizacion;

    @Column(name = "dir_direccion", nullable = false, length = 300)
    private String dirDireccion;

    @Column(name = "dir_direccion2", length = 300)
    private String dirDireccion2;

    @Column(name = "dir_mnz", columnDefinition = "char(4)")
    private String dirMnz;

    @Column(name = "dir_lote", columnDefinition = "char(4)")
    private String dirLote;

    @Column(name = "dir_numero", length = 10)
    private String dirNumero;

    @Column(name = "dir_interior", length = 40)
    private String dirInterior;

    @Column(name = "dir_cod_postal", length = 10)
    private String dirCodPostal;

    @Column(name = "dir_referencia", length = 250)
    private String dirReferencia;

    @Column(name = "ubigeo", length = 12)
    private String ubigeo;

    @Column(name = "cod_pais", length = 4)
    private String codPais;

    @Column(name = "cod_dpto", length = 3)
    private String codDpto;

    @Column(name = "cod_prov", length = 3)
    private String codProv;

    @Column(name = "cod_distr", length = 4)
    private String codDistr;

    @Column(name = "dir_siglas_pais", columnDefinition = "char(2)")
    private String dirSiglasPais;

    @Column(name = "cod_pais_sunat", length = 4)
    private String codPaisSunat;

    @Column(name = "cep", length = 40)
    private String cep;

    @Column(name = "flag_uso", nullable = false, columnDefinition = "char(1)")
    private String flagUso = "1";

    @Column(name = "flag_dir_comercial", nullable = false, columnDefinition = "char(1)")
    private String flagDirComercial = "0";

    @Column(name = "es_principal", nullable = false)
    private Boolean esPrincipal = false;

    @Column(name = "latitud", nullable = false, precision = 20, scale = 16)
    private BigDecimal latitud = BigDecimal.ZERO;

    @Column(name = "longitud", nullable = false, precision = 20, scale = 16)
    private BigDecimal longitud = BigDecimal.ZERO;

    @Column(name = "zona_venta", length = 8)
    private String zonaVenta;

    @Column(name = "zona_despacho", length = 8)
    private String zonaDespacho;

    @Column(name = "nombre_tienda", length = 120)
    private String nombreTienda;

    @Column(name = "cod_tienda", length = 10)
    private String codTienda;
}
