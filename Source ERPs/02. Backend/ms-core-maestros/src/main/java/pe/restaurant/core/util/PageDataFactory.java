package pe.restaurant.core.util;

import org.springframework.data.domain.Page;
import pe.restaurant.core.dto.PageDataDto;
import pe.restaurant.core.dto.PageInfoDto;

import java.util.List;

public final class PageDataFactory {
    private PageDataFactory() {
    }

    public static <T> PageDataDto<T> fromPage(Page<T> page) {
        return new PageDataDto<>(
                page.getContent(),
                new PageInfoDto(page.getNumber(), page.getSize(), page.getTotalElements(), page.getTotalPages())
        );
    }

    public static <T> PageDataDto<T> fromList(List<T> content) {
        return new PageDataDto<>(content, new PageInfoDto(0, content.size(), content.size(), 1));
    }
}
