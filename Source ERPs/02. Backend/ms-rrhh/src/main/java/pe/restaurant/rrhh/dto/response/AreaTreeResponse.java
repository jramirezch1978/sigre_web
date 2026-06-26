package pe.restaurant.rrhh.dto.response;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

/**
 * DTO de salida para representar un área en formato de árbol jerárquico.
 * Incluye la lista de sub-áreas (hijos) de forma recursiva.
 */
@Data
public class AreaTreeResponse {
    
    private Long id;
    private String nombre;
    private Long padreId;
    private Long responsableId;
    private List<AreaTreeResponse> hijos = new ArrayList<>();
}
