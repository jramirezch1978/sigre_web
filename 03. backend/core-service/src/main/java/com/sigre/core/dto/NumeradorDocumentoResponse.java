package com.sigre.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NumeradorDocumentoResponse {

    /** Tabla destino del documento (PK): ej. almacen.vale_mov */
    private String nombreTabla;
    private Long sucursalId;
    private String sucursalCodigo;
    private String sucursalNombre;
    private Integer ano;
    /** Próximo número a emitir (ult_nro en core.numerador_documento). */
    private Long ultNro;
    private String flagEstado;
}
