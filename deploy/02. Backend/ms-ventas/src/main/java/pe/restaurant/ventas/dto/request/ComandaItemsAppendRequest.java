package pe.restaurant.ventas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class ComandaItemsAppendRequest {

    @NotNull
    @NotEmpty
    @Valid
    private List<ComandaItemRequest> items;
}
