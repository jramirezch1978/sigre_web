package com.sigre.produccion.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DocTecnicaResponse {

    private Long id;
    private Long articuloId;
    private String articuloCodigo;
    private String articuloDescripcion;
    private Long docTipoId;
    private String docTipoCodigo;
    private String docTipoNombre;
    private String nombreDocumento;
    private String documentoExtension;
    private String archivoUrl;
    private Boolean tieneDocumentoBlob;
    private String observacion;
    private String flagEstado;
    private List<CaractDetResponse> caracteristicas;
    private Long createdBy;
    private Instant fecCreacion;
    private Long updatedBy;
    private Instant fecModificacion;
}
