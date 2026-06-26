package pe.restaurant.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageData<T> {

    private List<T> content;
    private PageMeta page;

    public static <T> PageData<T> of(org.springframework.data.domain.Page<T> springPage) {
        return PageData.<T>builder()
                .content(springPage.getContent())
                .page(PageMeta.builder()
                        .number(springPage.getNumber())
                        .size(springPage.getSize())
                        .totalElements(springPage.getTotalElements())
                        .totalPages(springPage.getTotalPages())
                        .build())
                .build();
    }
}
