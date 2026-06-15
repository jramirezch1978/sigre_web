package com.sigre.contabilidad.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ImportarPreasientoResponse {

    private int totalPreasientosImportados;
    private int totalAsientosGenerados;
    private List<AsientoImportado> asientos = new ArrayList<>();

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AsientoImportado {
        private Long preasientoId;
        private String preasientoVoucher;
        private Long asientoId;
        private String asientoVoucher;
        private int lineasDetalle;
    }
}
