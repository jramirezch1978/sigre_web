package pe.restaurant.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatCode;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.finanzas.dto.request.BancoRequest;
import pe.restaurant.finanzas.dto.response.BancoResponse;
import pe.restaurant.finanzas.entity.Banco;


@DisplayName("Pruebas Unitarias - BancoMapper")
class BancoMapperTest {

    private BancoMapper bancoMapper;

    @BeforeEach
    void setUp() {
        bancoMapper = Mappers.getMapper(BancoMapper.class);
    }


    // ==== toEntity — escenarios felices ====

    @Test
    @DisplayName("toEntity - Debe convertir BancoRequest a Banco entity")
    void toEntity_conRequestValido_retornaEntity() {
        // Arrange
        BancoRequest request = new BancoRequest();
        request.setCodBanco("001");
        request.setNomBanco("BANCO DE LA NACION");
        request.setProveedor("BANCO001");
        request.setSwift("BNANPEPL");
        request.setCodBancoSunat("01");
        request.setDireccion("Av. Javier Prado 1234");

        // Act
        Banco entity = bancoMapper.toEntity(request);

        // Assert
        assertThat(entity).isNotNull();
        assertThat(entity.getCodBanco()).isEqualTo("001");
        assertThat(entity.getNomBanco()).isEqualTo("BANCO DE LA NACION");
        assertThat(entity.getProveedor()).isEqualTo("BANCO001");
        assertThat(entity.getSwift()).isEqualTo("BNANPEPL");
        assertThat(entity.getCodBancoSunat()).isEqualTo("01");
        assertThat(entity.getDireccion()).isEqualTo("Av. Javier Prado 1234");
        assertThat(entity.getId()).isNull(); // ID se genera automáticamente
    }


    // ==== toResponse — escenarios felices ====

    @Test
    @DisplayName("toResponse - Debe convertir Banco entity a BancoResponse")
    void toResponse_conEntityValida_retornaResponse() {
        // Arrange
        Banco entity = new Banco();
        entity.setId(1L);
        entity.setCodBanco("001");
        entity.setNomBanco("BANCO DE LA NACION");
        entity.setProveedor("BANCO001");
        entity.setSwift("BNANPEPL");
        entity.setCodBancoSunat("01");
        entity.setDireccion("Av. Javier Prado 1234");

        // Act
        BancoResponse response = bancoMapper.toResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodBanco()).isEqualTo("001");
        assertThat(response.getNomBanco()).isEqualTo("BANCO DE LA NACION");
        assertThat(response.getProveedor()).isEqualTo("BANCO001");
        assertThat(response.getSwift()).isEqualTo("BNANPEPL");
        assertThat(response.getCodBancoSunat()).isEqualTo("01");
        assertThat(response.getDireccion()).isEqualTo("Av. Javier Prado 1234");
        assertThat(response.getFlagEstado()).isEqualTo("1"); // heredado de BaseEntity, mapper ahora lo incluye
    }


    // ==== toResponseList — escenarios felices ====

    @Test
    @DisplayName("toResponseList - Debe convertir lista de entidades a lista de responses")
    void toResponseList_conListaValida_retornaLista() {
        // Arrange
        Banco entity1 = new Banco();
        entity1.setId(1L);
        entity1.setCodBanco("001");
        entity1.setNomBanco("BANCO DE LA NACION");

        Banco entity2 = new Banco();
        entity2.setId(2L);
        entity2.setCodBanco("002");
        entity2.setNomBanco("BANCO DE CREDITO");

        java.util.List<Banco> entities = java.util.List.of(entity1, entity2);

        // Act
        java.util.List<BancoResponse> responses = bancoMapper.toResponseList(entities);

        // Assert
        assertThat(responses).isNotNull();
        assertThat(responses.size()).isEqualTo(2);
        
        BancoResponse response1 = responses.get(0);
        assertThat(response1.getId()).isEqualTo(1L);
        assertThat(response1.getCodBanco()).isEqualTo("001");
        assertThat(response1.getNomBanco()).isEqualTo("BANCO DE LA NACION");

        BancoResponse response2 = responses.get(1);
        assertThat(response2.getId()).isEqualTo(2L);
        assertThat(response2.getCodBanco()).isEqualTo("002");
        assertThat(response2.getNomBanco()).isEqualTo("BANCO DE CREDITO");
    }


    // ==== toResponseList — otros ====

    @Test
    @DisplayName("toResponseList - Debe retornar lista vacía cuando input es nulo")
    void toResponseList_conInputNulo_retornaListaVacia() {
        // Act
        java.util.List<BancoResponse> responses = bancoMapper.toResponseList(null);

        // Assert
        assertThat(responses).isNull();
    }


    // ==== updateEntity — escenarios felices ====

    @Test
    @DisplayName("updateEntity - Debe actualizar entidad con datos del request")
    void updateEntity_conDatosValidos_actualizaEntity() {
        // Arrange
        Banco entity = new Banco();
        entity.setId(1L);
        entity.setCodBanco("001");
        entity.setNomBanco("BANCO ANTIGUO");
        entity.setProveedor("OLD001");
        entity.setSwift("OLDPEPL");
        entity.setCodBancoSunat("99");
        entity.setDireccion("Direccion Antigua");

        BancoRequest request = new BancoRequest();
        request.setCodBanco("002");
        request.setNomBanco("BANCO ACTUALIZADO");
        request.setProveedor("NEW001");
        request.setSwift("NEWPEPL");
        request.setCodBancoSunat("01");
        request.setDireccion("Direccion Nueva");

        // Act
        bancoMapper.updateEntity(request, entity);

        // Assert
        assertThat(entity.getId()).isEqualTo(1L); // ID no debe cambiar
        assertThat(entity.getCodBanco()).isEqualTo("002");
        assertThat(entity.getNomBanco()).isEqualTo("BANCO ACTUALIZADO");
        assertThat(entity.getProveedor()).isEqualTo("NEW001");
        assertThat(entity.getSwift()).isEqualTo("NEWPEPL");
        assertThat(entity.getCodBancoSunat()).isEqualTo("01");
        assertThat(entity.getDireccion()).isEqualTo("Direccion Nueva");
    }


    // ==== toEntity — otros ====

    @Test
    @DisplayName("toEntity - Debe manejar request nulo")
    void toEntity_conRequestNulo_retornaNull() {
        // Act
        Banco entity = bancoMapper.toEntity(null);

        // Assert
        assertThat(entity).isNull();
    }


    // ==== toResponse — otros ====

    @Test
    @DisplayName("toResponse - Debe manejar entidad nula")
    void toResponse_conEntityNula_retornaNull() {
        // Act
        BancoResponse response = bancoMapper.toResponse(null);

        // Assert
        assertThat(response).isNull();
    }


    // ==== updateEntity — edge cases ====

    @Test
    @DisplayName("updateEntity - No debe lanzar excepción con request nulo")
    void updateEntity_conRequestNulo_noLanzaExcepcion() {
        // Arrange
        Banco entity = new Banco();
        entity.setId(1L);
        entity.setCodBanco("001");
        entity.setNomBanco("BANCO TEST");

        // Act & Then - No debe lanzar excepción
        assertThatCode(() -> {
            bancoMapper.updateEntity(null, entity);
        }).doesNotThrowAnyException();

        // Verificar que la entidad no fue modificada
        assertThat(entity.getCodBanco()).isEqualTo("001");
        assertThat(entity.getNomBanco()).isEqualTo("BANCO TEST");
    }
}
