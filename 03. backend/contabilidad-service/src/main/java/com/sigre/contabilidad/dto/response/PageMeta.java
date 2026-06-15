package com.sigre.contabilidad.dto.response;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageMeta {

    private int number;
    private int size;
    private long totalElements;
    private int totalPages;
}
