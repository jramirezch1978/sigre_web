package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.ventas.VentasTestFixtures;
import pe.restaurant.ventas.dto.response.EntidadCreditosCxcResponse;
import pe.restaurant.ventas.dto.response.PropinaResponse;
import pe.restaurant.ventas.dto.response.ReservacionResponse;
import pe.restaurant.ventas.entity.EntidadCreditosCxc;
import pe.restaurant.ventas.entity.Mesa;
import pe.restaurant.ventas.entity.Propina;
import pe.restaurant.ventas.entity.Reservacion;
import pe.restaurant.ventas.repository.MesaRepository;
import pe.restaurant.ventas.repository.VentasFkValidator;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("VentasIssue5DtoMapper - Pruebas Unitarias")
class VentasIssue5DtoMapperTest {

    @Mock
    private VentasFkValidator fkValidator;
    @Mock
    private MesaRepository mesaRepository;
    @InjectMocks
    private VentasIssue5DtoMapper mapper;

    // ========== TESTS PARA PROPINA ==========

    @Test
    @DisplayName("toPropinaResponse() con entity válida -> mapea correctamente")
    void toPropinaResponse_conEntityValida_mapeaCorrectamente() {
        // Arrange
        Propina entity = VentasTestFixtures.propinaEntity(1L, "1");

        // Act
        PropinaResponse response = mapper.toPropinaResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getFsFacturaSimplId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getMonto()).isEqualByComparingTo("10.00");
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    // ========== TESTS PARA RESERVACION ==========

    @Test
    @DisplayName("toReservacionResponse() con entity válida sin items -> mapea correctamente")
    void toReservacionResponse_conEntityValidaSinItems_mapeaCorrectamente() {
        // Arrange
        Reservacion entity = VentasTestFixtures.reservacionEntity(1L, "1");
        entity.setItems(null);
        
        Mesa mesa = new Mesa();
        mesa.setNumero("M01");
        
        when(mesaRepository.findById(anyLong())).thenReturn(Optional.of(mesa));
        when(fkValidator.findSucursalNombre(anyLong())).thenReturn("Sucursal Test");
        when(fkValidator.findEntidadRazonSocial(anyLong())).thenReturn("Cliente Test");

        // Act
        ReservacionResponse response = mapper.toReservacionResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getSucursalId()).isEqualTo(1L);
        assertThat(response.getSucursalNombre()).isEqualTo("Sucursal Test");
        assertThat(response.getClienteId()).isEqualTo(1L);
        assertThat(response.getClienteRazonSocial()).isEqualTo("Cliente Test");
        assertThat(response.getMesaId()).isEqualTo(1L);
        assertThat(response.getMesaNumero()).isEqualTo("M01");
        assertThat(response.getComensales()).isEqualTo(4);
        assertThat(response.getEstado()).isEqualTo("CONFIRMADA");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getItems()).isNull();
    }

    @Test
    @DisplayName("toReservacionResponse() con entity válida con items -> mapea correctamente")
    void toReservacionResponse_conEntityValidaConItems_mapeaCorrectamente() {
        // Arrange
        Reservacion entity = VentasTestFixtures.reservacionEntity(1L, "1");
        entity.setItems(List.of(
            VentasTestFixtures.reservacionDetEntity(1L, entity, 100L),
            VentasTestFixtures.reservacionDetEntity(2L, entity, 200L)
        ));
        
        Mesa mesa = new Mesa();
        mesa.setNumero("M02");
        
        when(mesaRepository.findById(anyLong())).thenReturn(Optional.of(mesa));
        when(fkValidator.findSucursalNombre(anyLong())).thenReturn("Sucursal Test");
        when(fkValidator.findEntidadRazonSocial(anyLong())).thenReturn("Cliente Test");

        // Act
        ReservacionResponse response = mapper.toReservacionResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getItems()).hasSize(2);
        assertThat(response.getItems().get(0).getId()).isEqualTo(1L);
        assertThat(response.getItems().get(0).getArticuloId()).isEqualTo(100L);
        assertThat(response.getItems().get(0).getCantidad()).isEqualByComparingTo("2");
    }

    @Test
    @DisplayName("toReservacionResponse() con mesaId nulo -> mesaNumero es null")
    void toReservacionResponse_conMesaIdNulo_mesaNumeroEsNull() {
        // Arrange
        Reservacion entity = VentasTestFixtures.reservacionEntity(1L, "1");
        entity.setMesaId(null);
        
        when(fkValidator.findSucursalNombre(anyLong())).thenReturn("Sucursal Test");
        when(fkValidator.findEntidadRazonSocial(anyLong())).thenReturn("Cliente Test");

        // Act
        ReservacionResponse response = mapper.toReservacionResponse(entity);

        // Assert
        assertThat(response.getMesaId()).isNull();
        assertThat(response.getMesaNumero()).isNull();
    }

    @Test
    @DisplayName("toReservacionListItem() -> no incluye items")
    void toReservacionListItem_noIncluyeItems() {
        // Arrange
        Reservacion entity = VentasTestFixtures.reservacionEntity(1L, "1");
        entity.setItems(List.of(VentasTestFixtures.reservacionDetEntity(1L, entity, 100L)));
        
        Mesa mesa = new Mesa();
        mesa.setNumero("M03");
        
        when(mesaRepository.findById(anyLong())).thenReturn(Optional.of(mesa));
        when(fkValidator.findSucursalNombre(anyLong())).thenReturn("Sucursal Test");
        when(fkValidator.findEntidadRazonSocial(anyLong())).thenReturn("Cliente Test");

        // Act
        ReservacionResponse response = mapper.toReservacionListItem(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getItems()).isNull();
    }

    // ========== TESTS PARA ENTIDAD CREDITOS CXC ==========

    @Test
    @DisplayName("toCreditosResponse() con entity válida -> mapea correctamente")
    void toCreditosResponse_conEntityValida_mapeaCorrectamente() {
        // Arrange
        EntidadCreditosCxc entity = VentasTestFixtures.entidadCreditosCxcEntity(1L, "1");
        
        when(fkValidator.findEntidadRazonSocial(anyLong())).thenReturn("Cliente Crédito");
        when(fkValidator.findEntidadRuc(anyLong())).thenReturn("20123456789");
        when(fkValidator.findMonedaSimbolo(anyLong())).thenReturn("S/");

        // Act
        EntidadCreditosCxcResponse response = mapper.toCreditosResponse(entity);

        // Assert
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getEntidadContribuyenteId()).isEqualTo(1L);
        assertThat(response.getEntidadRazonSocial()).isEqualTo("Cliente Crédito");
        assertThat(response.getEntidadRuc()).isEqualTo("20123456789");
        assertThat(response.getMonedaId()).isEqualTo(1L);
        assertThat(response.getMonedaSimbolo()).isEqualTo("S/");
        assertThat(response.getLimiteCredito()).isEqualByComparingTo("5000.00");
        assertThat(response.getDiasCredito()).isEqualTo(30);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }
}
