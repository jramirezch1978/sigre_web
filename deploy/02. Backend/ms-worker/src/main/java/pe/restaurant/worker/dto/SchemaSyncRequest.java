package pe.restaurant.worker.dto;

import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SchemaSyncRequest {

    private boolean dryRun = true;
    private boolean allowDestructive = false;
    private boolean failFast = false;

    /**
     * Token de doble confirmacion requerido cuando allowDestructive=true.
     * Debe coincidir con el admin-secret para autorizar operaciones destructivas.
     */
    private String destructiveConfirmationToken;

    @Size(max = 100)
    private List<String> tenantDbNames = new ArrayList<>();

    public boolean targetsAllTenants() {
        return tenantDbNames == null || tenantDbNames.isEmpty();
    }
}
