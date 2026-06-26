package pe.restaurant.rrhh.dto.response;

public record SaldoVacacionDto(
    Long trabajadorId,
    String trabajadorNombres,
    Integer periodoAnio,
    Integer diasDerecho,
    Integer diasGozados,
    Integer diasPendientes,
    Integer diasProgramados
) {}
