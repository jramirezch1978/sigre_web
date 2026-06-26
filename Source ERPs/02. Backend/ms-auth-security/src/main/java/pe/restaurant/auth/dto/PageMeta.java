package pe.restaurant.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

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
