package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EntidadDireccionResponse {
    private Long id;
    private Long entidadContribuyenteId;
    private Short item;
    private String descripcion;
    private String dirPais;
    private String dirDepEstado;
    private String dirProvincia;
    private String dirCiudad;
    private String dirDistrito;
    private String dirUrbanizacion;
    private String dirDireccion;
    private String dirDireccion2;
    private String dirMnz;
    private String dirLote;
    private String dirNumero;
    private String dirInterior;
    private String dirCodPostal;
    private String dirReferencia;
    private String ubigeo;
    private String codPais;
    private String codDpto;
    private String codProv;
    private String codDistr;
    private String dirSiglasPais;
    private String codPaisSunat;
    private String cep;
    private String flagUso;
    private String flagDirComercial;
    private Boolean esPrincipal;
    private BigDecimal latitud;
    private BigDecimal longitud;
    private String zonaVenta;
    private String zonaDespacho;
    private String nombreTienda;
    private String codTienda;
    private String flagEstado;
}
