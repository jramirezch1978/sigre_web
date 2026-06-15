package com.sigre.contabilidad.dto.response;

import lombok.Builder;
import lombok.Getter;

import java.time.Instant;

@Getter
@Builder
public class CentrosCostoResponse {

    private final Long id;
    private final Long cencosNiv3Id;
    private final String cencos;
    private final String descCencos;
    private final String flagEstado;
    private final Long createdBy;
    private final Instant fecCreacion;
    private final Long updatedBy;
    private final Instant fecModificacion;
}
