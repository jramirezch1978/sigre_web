package com.sigre.compras.dto;

import lombok.*;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageData<T> {

    private List<T> content;
    private PageMeta page;

    public static <T> PageData<T> of(org.springframework.data.domain.Page<?> springPage, List<T> content) {
        return PageData.<T>builder()
                .content(content)
                .page(PageMeta.builder()
                        .number(springPage.getNumber())
                        .size(springPage.getSize())
                        .totalElements(springPage.getTotalElements())
                        .totalPages(springPage.getTotalPages())
                        .build())
                .build();
    }
}
