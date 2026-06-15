package com.sigre.comercializacion.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.comercializacion.VentasTestFixtures;
import com.sigre.comercializacion.dto.request.ServiciosCxCRequest;
import com.sigre.comercializacion.dto.response.ServiciosCxCResponse;
import com.sigre.comercializacion.entity.ServiciosCxC;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("ServiciosCxCMapper — Pruebas Unitarias")
class ServiciosCxCMapperTest {

    private final ServiciosCxCMapper mapper = Mappers.getMapper(ServiciosCxCMapper.class);

    @Test
    @DisplayName("toEntity() con request válido -> mapea correctamente para CREATE")
    void toEntity_conRequestValido_mapeaCorrectamenteParaCreate() {
        // Arrange
        ServiciosCxCRequest request = VentasTestFixtures.serviciosCxCRequest();

        // Act
        ServiciosCxC entity = mapper.toEntity(request);

        // Assert
        assertThat(entity).isNotNull();
        assertThat(entity.getId()).isNull(); // No se mapea en CREATE
        assertThat(entity.getCodServicio()).isEqualTo(request.getCodServicio());
        assertThat(entity.getDescServicio()).isEqualTo(request.getDescServicio());
        assertThat(entity.getTarifa()).isEqualByComparingTo(request.getTarifa());
        assertThat(entity.getCodMoneda()).isEqualTo(request.getCodMoneda());
        assertThat(entity.getFlagAfectoIgv()).isEqualTo(request.getFlagAfectoIgv());
        
        // Campos que deben ser ignorados en CREATE
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
        assertThat(entity.getUpdatedBy()).isNull();
        assertThat(entity.getFecModificacion()).isNull();
        // flagEstado puede tener valor por defecto del constructor
        // assertThat(entity.getFlagEstado()).isNull();
    }

    @Test
    @DisplayName("toEntity() con request nulo -> retorna null")
    void toEntity_conRequestNulo_retornaNull() {
        // Act
        ServiciosCxC entity = mapper.toEntity(null);

        // Assert
        assertThat(entity).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity válida -> mapea correctamente")
    void toResponse_conEntityValida_mapeaCorrectamente() {
        // Arrange
        ServiciosCxC entity = VentasTestFixtures.serviciosCxCEntity(1L, "1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-05-22T15:00:00Z")); // UTC
        entity.setUpdatedBy(2L);
        entity.setFecModificacion(Instant.parse("2026-05-22T16:00:00Z")); // UTC

        // Act
        ServiciosCxCResponse response = mapper.toResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodServicio()).isEqualTo("S01");
        assertThat(response.getDescServicio()).isEqualTo("Servicio Test");
        assertThat(response.getTarifa()).isEqualByComparingTo("100.00");
        assertThat(response.getCodMoneda()).isEqualTo("PEN");
        assertThat(response.getFlagAfectoIgv()).isEqualTo("1");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isEqualTo("22/05/2026 10:00:00"); // America/Lima (UTC-5)
        assertThat(response.getUpdatedBy()).isEqualTo(2L);
        assertThat(response.getFecModificacion()).isEqualTo("22/05/2026 11:00:00"); // America/Lima (UTC-5)
        
        // Campos ignorados
        assertThat(response.getActivo()).isNull();
        assertThat(response.getCreatedAt()).isNull();
        assertThat(response.getUpdatedAt()).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity nula -> retorna null")
    void toResponse_conEntityNula_retornaNull() {
        // Act
        ServiciosCxCResponse response = mapper.toResponse(null);

        // Assert
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity sin timestamps -> maneja correctamente")
    void toResponse_conEntitySinTimestamps_manejaCorrectamente() {
        // Arrange
        ServiciosCxC entity = VentasTestFixtures.serviciosCxCEntity(1L, "1");
        // Sin timestamps

        // Act
        ServiciosCxCResponse response = mapper.toResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isNull();
        assertThat(response.getFecModificacion()).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista válida -> mapea correctamente")
    void toResponseList_conListaValida_mapeaCorrectamente() {
        // Arrange
        ServiciosCxC entity1 = VentasTestFixtures.serviciosCxCEntity(1L, "1");
        ServiciosCxC entity2 = VentasTestFixtures.serviciosCxCEntity(2L, "1");
        List<ServiciosCxC> entities = List.of(entity1, entity2);

        // Act
        List<ServiciosCxCResponse> responses = mapper.toResponseList(entities);

        // Assert
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("toResponseList() con lista nula -> retorna null")
    void toResponseList_conListaNula_retornaNull() {
        // Act
        List<ServiciosCxCResponse> responses = mapper.toResponseList(null);

        // Assert
        assertThat(responses).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista vacía -> retorna lista vacía")
    void toResponseList_conListaVacia_retornaListaVacia() {
        // Act
        List<ServiciosCxCResponse> responses = mapper.toResponseList(List.of());

        // Assert
        assertThat(responses).isEmpty();
    }

    @Test
    @DisplayName("updateEntity() con request válido -> actualiza correctamente")
    void updateEntity_conRequestValido_actualizaCorrectamente() {
        // Arrange
        ServiciosCxC entity = VentasTestFixtures.serviciosCxCEntity(1L, "1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-05-22T10:00:00Z"));
        
        ServiciosCxCRequest request = new ServiciosCxCRequest(
                "S02",
                "Servicio Actualizado",
                new BigDecimal("200.00"),
                "1",
                "USD"
        );

        // Act
        mapper.updateEntity(request, entity);

        // Assert
        assertThat(entity.getId()).isEqualTo(1L); // No se modifica
        assertThat(entity.getCodServicio()).isEqualTo("S02");
        assertThat(entity.getDescServicio()).isEqualTo("Servicio Actualizado");
        assertThat(entity.getTarifa()).isEqualByComparingTo("200.00");
        assertThat(entity.getFlagAfectoIgv()).isEqualTo("1");
        assertThat(entity.getCodMoneda()).isEqualTo("USD");
        
        // Campos que deben mantenerse en UPDATE
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getFecCreacion()).isEqualTo(Instant.parse("2026-05-22T10:00:00Z"));
        
        // Campos que no se deben modificar (se ignoran)
        assertThat(entity.getUpdatedBy()).isNull();
        assertThat(entity.getFecModificacion()).isNull();
        assertThat(entity.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("updateEntity() con request nulo -> no modifica entity")
    void updateEntity_conRequestNulo_noModificaEntity() {
        // Arrange
        ServiciosCxC entity = VentasTestFixtures.serviciosCxCEntity(1L, "1");
        String servicioOriginal = entity.getCodServicio();

        // Act
        mapper.updateEntity(null, entity);

        // Assert
        assertThat(entity.getCodServicio()).isEqualTo(servicioOriginal);
    }

    @Test
    @DisplayName("updateEntity() con entity nula -> lanza NullPointerException")
    void updateEntity_conEntityNula_lanzaNullPointerException() {
        // Arrange
        ServiciosCxCRequest request = VentasTestFixtures.serviciosCxCRequest();

        // Act & Assert - MapStruct lanza NullPointerException
        org.junit.jupiter.api.Assertions.assertThrows(NullPointerException.class, () -> {
            mapper.updateEntity(request, null);
        });
    }

    @Test
    @DisplayName("formatTimestamp() con timestamp válido -> formatea correctamente")
    void formatTimestamp_conTimestampValido_formateaCorrectamente() {
        // Arrange
        Instant timestamp = Instant.parse("2026-05-22T15:30:45Z");

        // Act
        String formatted = mapper.formatTimestamp(timestamp);

        // Assert
        assertThat(formatted).isEqualTo("22/05/2026 10:30:45"); // America/Lima (UTC-5)
    }

    @Test
    @DisplayName("formatTimestamp() con timestamp nulo -> retorna null")
    void formatTimestamp_conTimestampNulo_retornaNull() {
        // Act
        String formatted = mapper.formatTimestamp(null);

        // Assert
        assertThat(formatted).isNull();
    }

    @Test
    @DisplayName("mapeo completo de campos contractuales -> todos los campos se mapean correctamente")
    void mapeoCompletoCamposContractuales_todosCamposSeMapeanCorrectamente() {
        // Arrange
        ServiciosCxCRequest request = new ServiciosCxCRequest(
                "S03",
                "Servicio Completo",
                new BigDecimal("500.50"),
                "1",
                "EUR"
        );

        // Act
        ServiciosCxC entity = mapper.toEntity(request);

        // Assert - Verificar todos los campos
        assertThat(entity.getCodServicio()).isEqualTo("S03");
        assertThat(entity.getDescServicio()).isEqualTo("Servicio Completo");
        assertThat(entity.getTarifa()).isEqualByComparingTo("500.50");
        assertThat(entity.getFlagAfectoIgv()).isEqualTo("1");
        assertThat(entity.getCodMoneda()).isEqualTo("EUR");
    }
}
