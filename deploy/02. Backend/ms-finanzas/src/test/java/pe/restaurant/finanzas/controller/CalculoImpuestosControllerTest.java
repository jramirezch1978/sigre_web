package pe.restaurant.finanzas.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import pe.restaurant.finanzas.dto.request.CalcularImpuestosRequest;
import pe.restaurant.finanzas.dto.request.ImpuestoItemRequest;
import pe.restaurant.finanzas.dto.request.ItemCalculoRequest;
import pe.restaurant.finanzas.dto.response.CalcularImpuestosResponse;
import pe.restaurant.finanzas.dto.response.ConsolidadoResponse;
import pe.restaurant.finanzas.dto.response.ImpuestoCalculadoResponse;
import pe.restaurant.finanzas.dto.response.ItemCalculoResponse;
import pe.restaurant.finanzas.service.CalculoImpuestosService;

import java.math.BigDecimal;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class CalculoImpuestosControllerTest {

    private MockMvc mockMvc;

    @Mock
    private CalculoImpuestosService service;

    @InjectMocks
    private CalculoImpuestosController controller;

    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setMessageConverters(new MappingJackson2HttpMessageConverter(objectMapper))
                .build();
    }

    @Test
    void calcular_DebeRetornar200YResponse() throws Exception {
        // Arrange
        CalcularImpuestosRequest request = new CalcularImpuestosRequest();
        var tax = new ImpuestoItemRequest(1L, 1);
        tax.setTasa(new BigDecimal("18.00"));
        tax.setEsFiscalizado(true);
        tax.setNombre("IGV");
        request.setItems(List.of(
                new ItemCalculoRequest(1, new BigDecimal("118.00"), new BigDecimal("2"),
                        true, BigDecimal.ZERO, "$", // dsctoTipo
                        List.of(tax),
                        null)
        ));

        CalcularImpuestosResponse response = CalcularImpuestosResponse.builder()
                .pais("PE")
                .items(List.of(
                        ItemCalculoResponse.builder()
                                .item(1)
                                .baseImponible(new BigDecimal("200.00"))
                                .montoTotal(new BigDecimal("236.00"))
                                .esGravado(true)
                                .impuestos(List.of(
                                        ImpuestoCalculadoResponse.builder()
                                                .tipoImpuestoId(1L)
                                                .nombre("IGV")
                                                .tasa(new BigDecimal("18.00"))
                                                .importe(new BigDecimal("36.00"))
                                                .esFiscalizado(true)
                                                .build()
                                ))
                                .build()
                ))
                .consolidado(ConsolidadoResponse.builder()
                        .subtotal(new BigDecimal("200.00"))
                        .totalIgv(new BigDecimal("36.00"))
                        .totalConImpuestos(new BigDecimal("236.00"))
                        .build())
                .build();

        when(service.calcular(any())).thenReturn(response);

        // Act & Assert
        mockMvc.perform(post("/api/finanzas/calcular-impuestos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.pais").value("PE"))
                .andExpect(jsonPath("$.data.items[0].item").value(1))
                .andExpect(jsonPath("$.data.items[0].baseImponible").value(200.00))
                .andExpect(jsonPath("$.data.items[0].montoTotal").value(236.00))
                .andExpect(jsonPath("$.data.items[0].esGravado").value(true))
                .andExpect(jsonPath("$.data.items[0].impuestos[0].nombre").value("IGV"))
                .andExpect(jsonPath("$.data.items[0].impuestos[0].importe").value(36.00))
                .andExpect(jsonPath("$.data.consolidado.subtotal").value(200.00))
                .andExpect(jsonPath("$.data.consolidado.totalIgv").value(36.00));

        verify(service).calcular(any());
    }

    @Test
    void calcular_conRequestInvalido_retorna400() throws Exception {
        // Invalid: null items list violates @NotNull
        CalcularImpuestosRequest request = new CalcularImpuestosRequest();
        request.setItems(null);

        mockMvc.perform(post("/api/finanzas/calcular-impuestos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());

        verify(service, never()).calcular(any());
    }

    @Test
    void calcular_conItemsVacios_delegaAlServicio() throws Exception {
        CalcularImpuestosRequest request = new CalcularImpuestosRequest();
        request.setItems(List.of());

        CalcularImpuestosResponse response = CalcularImpuestosResponse.builder()
                .pais("PE")
                .items(List.of())
                .consolidado(ConsolidadoResponse.builder()
                        .subtotal(BigDecimal.ZERO)
                        .totalConImpuestos(BigDecimal.ZERO)
                        .build())
                .build();

        when(service.calcular(any())).thenReturn(response);

        mockMvc.perform(post("/api/finanzas/calcular-impuestos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.items").isEmpty());

        verify(service).calcular(any());
    }

    @Test
    void calcular_sinBody_retorna400() throws Exception {
        mockMvc.perform(post("/api/finanzas/calcular-impuestos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(""))
                .andExpect(status().isBadRequest());

        verify(service, never()).calcular(any());
    }
}
