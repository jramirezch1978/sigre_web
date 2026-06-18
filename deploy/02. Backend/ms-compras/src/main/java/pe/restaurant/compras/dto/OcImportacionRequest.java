package pe.restaurant.compras.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
public class OcImportacionRequest {

    private String incoterm;
    private String puertoEmbarque;
    private String puertoDestino;
    private String agenteAduanas;
    private String nroDua;
    private LocalDate fechaEmbarque;
    private LocalDate fechaLlegadaEstimada;
    private String observaciones;
}
