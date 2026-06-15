package com.sigre.rrhh.dto.response;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Data
public class CtsResponse {
    private Long id;
    private Long trabajadorId;
    private Integer anio;
    private Long periodoCtsId;
    private BigDecimal remuneracionComputable;
    private Integer mesesComputables;
    private Integer diasComputables;
    private BigDecimal montoCts;
    private String entidadFinanciera;
    private String numeroCuentaCts;
    private LocalDate fechaDeposito;
    private String createdBy;
    private OffsetDateTime fecCreacion;
    private String updatedBy;
    private OffsetDateTime fecModificacion;
}
