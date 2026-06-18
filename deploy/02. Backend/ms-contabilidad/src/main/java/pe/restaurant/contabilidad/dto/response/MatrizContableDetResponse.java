package pe.restaurant.contabilidad.dto.response;

import lombok.Builder;
import lombok.Getter;

import java.time.Instant;

@Getter
@Builder
public class MatrizContableDetResponse {

    private final Long id;
    private final Long matrizContableId;
    private final Integer secuencia;
    private final Long planContableDetId;
    private final String flagDebHab;
    private final String referenciaCampo;
    private final String campo;
    private final String formula;
    private final String glosaTexto;
    private final String glosaCampo;
    private final String flagCencos;
    private final String flagCtabco;
    private final String flagDocref;
    private final Long createdBy;
    private final Instant fecCreacion;
    private final Long updatedBy;
    private final Instant fecModificacion;
}
