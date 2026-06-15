package com.sigre.auth.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * Alta de empresa: datos compatibles con maestros SIGRE.
 * La sigla ({@code SIGLA}) es obligatoria y define {@code sigre_emp_<slug>}.
 * <p>
 * {@code dbUser} / {@code dbPassword} son opcionales en {@code master.empresa}: si no se envían, usuario y contraseña
 * son la sigla normalizada en minúsculas (ej. {@code cantabria} / {@code cantabria}).
 * Si solo va {@code dbUser}, la contraseña se iguala al usuario. Si van ambos, se usan tal cual.
 * Si solo va {@code dbPassword}, el usuario es la sigla normalizada y la contraseña la enviada.
 */
@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class ProvisionEmpresaRequest {

    @Size(max = 20)
    @JsonAlias({"COD_EMPRESA"})
    private String codigo;

    @NotBlank
    @Size(max = 200)
    @JsonAlias({"NOMBRE"})
    private String razonSocial;

    /** Nombre comercial (opcional; distinto de la sigla). */
    @Size(max = 200)
    @JsonAlias({"NOMBRE_COMERCIAL"})
    private String nombreComercial;

    @NotBlank(message = "La sigla (SIGLA) es obligatoria: define el nombre de la BD tenant sigre_emp_<sigla normalizada>")
    @Size(max = 50)
    @JsonAlias({"SIGLA"})
    private String sigla;

    @NotBlank
    @Size(max = 20)
    @JsonAlias({"RUC"})
    private String ruc;

    @Size(max = 1)
    @JsonAlias({"PERSONERIA"})
    private String personeria;

    @Size(max = 1)
    @JsonAlias({"TIPO_IDENTIF"})
    private String tipoIdentif;

    @Size(max = 20)
    @JsonAlias({"IDENTIFICACION"})
    private String identificacion;

    @Size(max = 300)
    @JsonAlias({"DIR_CALLE"})
    private String dirCalle;

    @Size(max = 20)
    @JsonAlias({"DIR_NUMERO"})
    private String dirNumero;

    @Size(max = 20)
    @JsonAlias({"DIR_LOTE"})
    private String dirLote;

    @Size(max = 20)
    @JsonAlias({"DIR_MNZ"})
    private String dirMnz;

    @Size(max = 10)
    @JsonAlias({"DIR_COD_POSTAL"})
    private String dirCodPostal;

    @Size(max = 250)
    @JsonAlias({"DIR_URBANIZACION"})
    private String dirUrbanizacion;

    @Size(max = 120)
    @JsonAlias({"DIR_DISTRITO"})
    private String dirDistrito;

    @Size(max = 10)
    @JsonAlias({"COD_CIUDAD"})
    private String codCiudad;

    @Size(max = 4)
    @JsonAlias({"CIU_COD_PAIS"})
    private String ciuCodPais;

    @Size(max = 3)
    @JsonAlias({"CIU_COD_DPTO"})
    private String ciuCodDpto;

    @Size(max = 3)
    @JsonAlias({"CIU_COD_PROV"})
    private String ciuCodProv;

    @Size(max = 4)
    @JsonAlias({"CIU_COD_DISTR"})
    private String ciuCodDistr;

    @JsonAlias({"LOGO"})
    private String logo;

    @Size(max = 200)
    @JsonAlias({"REPRESENTANTE"})
    private String representante;

    @Size(max = 1)
    @JsonAlias({"FLAG_CNTRL_CD"})
    private String flagCntrlCd;

    @Size(max = 200)
    @JsonAlias({"REPRES_LEGAL"})
    private String represLegal;

    @Size(max = 20)
    @JsonAlias({"COD_ACTIVIDAD"})
    private String codActividad;

    @Size(max = 1)
    @JsonAlias({"FLAG_ENVIA_PERSONAL"})
    private String flagEnviaPersonal;

    @Size(max = 300)
    @JsonAlias({"DIRECCION"})
    private String direccion;

    @Size(max = 120)
    @JsonAlias({"DIR_PROVINCIA"})
    private String dirProvincia;

    @Size(max = 120)
    @JsonAlias({"DIR_DEPARTAMENTO"})
    private String dirDepartamento;

    @Size(max = 120)
    @JsonAlias({"DIR_PAIS"})
    private String dirPais;

    @Size(max = 12)
    @JsonAlias({"DIR_UBIGEO"})
    private String dirUbigeo;

    @Size(max = 30)
    @JsonAlias({"FONO_FIJO"})
    private String fonoFijo;

    @Size(max = 30)
    @JsonAlias({"CELULAR"})
    private String celular;

    @Size(max = 150)
    @JsonAlias({"EMAIL"})
    private String email;

    @Size(max = 150)
    @JsonAlias({"CORREO_CONTACTO"})
    private String correoContacto;

    /** Si no se envía, se usa variable de entorno / configuración por defecto. */
    @Size(max = 120)
    private String dbHost;

    /** Si no se envía, 5432. */
    private Integer dbPort;

    /** Opcional. Si no hay usuario ni contraseña, se usan las siglas normalizadas para ambos. */
    @Size(max = 120)
    private String dbUser;

    /** Opcional. Si hay usuario pero no contraseña, la contraseña será igual al usuario. */
    private String dbPassword;
}
