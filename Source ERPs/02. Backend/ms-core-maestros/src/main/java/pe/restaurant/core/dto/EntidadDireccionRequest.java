package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EntidadDireccionRequest {

    @NotNull
    private Long entidadContribuyenteId;

    private Short item = 1;

    @Size(max = 60)
    private String descripcion;

    @Size(max = 40)
    private String dirPais;

    @Size(max = 40)
    private String dirDepEstado;

    @Size(max = 40)
    private String dirProvincia;

    @Size(max = 40)
    private String dirCiudad;

    @Size(max = 40)
    private String dirDistrito;

    @Size(max = 40)
    private String dirUrbanizacion;

    @NotBlank
    @Size(max = 300)
    private String dirDireccion;

    @Size(max = 300)
    private String dirDireccion2;

    @Size(max = 4)
    private String dirMnz;

    @Size(max = 4)
    private String dirLote;

    @Size(max = 10)
    private String dirNumero;

    @Size(max = 40)
    private String dirInterior;

    @Size(max = 10)
    private String dirCodPostal;

    @Size(max = 250)
    private String dirReferencia;

    @Size(max = 12)
    private String ubigeo;

    @Size(max = 4)
    private String codPais;

    @Size(max = 3)
    private String codDpto;

    @Size(max = 3)
    private String codProv;

    @Size(max = 4)
    private String codDistr;

    @Size(max = 2)
    private String dirSiglasPais;

    @Size(max = 4)
    private String codPaisSunat;

    @Size(max = 40)
    private String cep;

    private String flagUso = "1";

    private String flagDirComercial = "0";

    private Boolean esPrincipal = false;

    private BigDecimal latitud = BigDecimal.ZERO;

    private BigDecimal longitud = BigDecimal.ZERO;

    @Size(max = 8)
    private String zonaVenta;

    @Size(max = 8)
    private String zonaDespacho;

    @Size(max = 120)
    private String nombreTienda;

    @Size(max = 10)
    private String codTienda;

    private String flagEstado = "1";
}
