package com.sigre.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TrabajadorListResponse {
    private Long id;
    private String codigoTrabajador;
    private String nombres;
    private String nombre1;
    private String nombre2;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private RefResponse tipoDocIdentidad;
    private String numeroDocumento;
    private RefResponse area;
    private RefResponse seccion;
    private RefResponse cargo;
    private RefResponse centroCosto;
    private RefResponse sucursal;
    private RefResponse tipoTrabajador;
    private RefResponse adminAfp;
    private String fecIniAfilAfp;
    private String fechaIngreso;
    private String flagEstado;
    private String fecCreacion;
}
