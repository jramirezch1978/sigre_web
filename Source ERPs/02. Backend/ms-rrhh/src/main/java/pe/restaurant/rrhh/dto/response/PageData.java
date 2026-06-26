package pe.restaurant.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;

import java.util.List;

/**
 * Wrapper para respuestas paginadas.
 * Encapsula el contenido y los metadatos de paginación.
 * 
 * @param <T> Tipo de contenido de la página
 * @author Equipo de Desarrollo RRHH
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageData<T> {

    private List<T> content;
    private PageMeta page;

    /**
     * Crea un PageData a partir de una Page de Spring.
     * 
     * @param springPage Página de Spring con metadatos
     * @param content Contenido de la página
     * @param <T> Tipo de contenido
     * @return PageData con contenido y metadatos
     */
    public static <T> PageData<T> of(Page<?> springPage, List<T> content) {
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

    /**
     * Metadatos de paginación.
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PageMeta {
        private int number;
        private int size;
        private long totalElements;
        private int totalPages;
    }
}
