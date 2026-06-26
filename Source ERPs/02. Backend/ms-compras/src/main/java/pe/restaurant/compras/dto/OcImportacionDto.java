package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OcImportacionDto {

    private Long id;
    private String incoterm;
    private String puertoEmbarque;
    private String puertoDestino;
    private String agenteAduanas;
    private String nroDua;
    private LocalDate fechaEmbarque;
    private LocalDate fechaLlegadaEst;
    private String observaciones;
}
