package com.sigre.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TrabajadorDetailResponse {
    private Long id;
    private RefResponse entidadContribuyente;
    private String codigoTrabajador;
    private String nombres;
    private String nombre1;
    private String nombre2;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private RefResponse tipoDocIdentidad;
    private String numeroDocumento;
    private String fechaNacimiento;
    private RefResponse sexo;
    private RefResponse estadoCivil;
    private String direccion;
    private String telefonoFijo;
    private String celular1;
    private String celular2;
    private String codigoTelCiudad;
    private String email;
    private String alergias;
    private RefResponse tipoSangre;
    private String nroBrevete;
    private String autogeneradoEssalud;
    private String flagDiscapacidad;
    private String flagDomiciliado;
    private String flagComisionAfp;
    private String flagPensionista;
    private String flagAfiliadoEps;
    private String flagEssaludVida;
    private String flagSctrPension;
    private String flagSctrSalud;
    private String flagQuintaExonerado;
    private RefResponse distrito;
    private RefResponse tipoVia;
    private String nombreVia;
    private String numeroVia;
    private RefResponse tipoZona;
    private String nombreZona;
    private RefResponse tipoVivienda;
    private String interior;
    private String referencia;
    private String cuentaBancariaSueldo;
    private String cuentaCts;
    private RefResponse adminAfp;
    private String cuspp;
    private RefResponse pensionRtps;
    private RefResponse regimenPensionario;
    private String fecIniAfilAfp;
    private String fecFinAfilAfp;
    private RefResponse regimenLaboral;
    private RefResponse tipoTrabajador;
    private RefResponse tipoTrabajadorRtps;
    private RefResponse ocupacionRtps;
    private RefResponse area;
    private RefResponse seccion;
    private RefResponse cargo;
    private RefResponse centroCosto;
    private RefResponse sucursal;
    private RefResponse bancoSueldo;
    private RefResponse bancoCts;
    private RefResponse monedaSueldo;
    private RefResponse monedaCts;
    private String fechaIngreso;
    private String fechaCese;
    private RefResponse motivoCeseRef;
    private String motivoCese;
    private String comentario;
    private String procedencia;
    private String flagEstado;
    private Long createdBy;
    private String fecCreacion;
    private Long updatedBy;
    private String fecModificacion;
    private List<ContratoResponse> contratos;
    private List<HorarioResponse> horarios;
    private String fotoBlobBase64;
    private String dniBlobBase64;
}
