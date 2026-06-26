package pe.restaurant.finanzas.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import pe.restaurant.common.exception.GlobalExceptionHandler;
import pe.restaurant.finanzas.dto.request.BancoRequest;
import pe.restaurant.finanzas.dto.response.BancoResponse;
import pe.restaurant.finanzas.entity.Banco;
import pe.restaurant.finanzas.mapper.BancoMapper;
import pe.restaurant.finanzas.service.BancoService;

import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Tests de BancoController")
class BancoControllerTest {

    @Mock
    private BancoService bancoService;

    @Mock
    private BancoMapper mapper;

    @InjectMocks
    private BancoController controller;
    
    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    
    private Banco banco;
    private BancoResponse bancoResponse;
    private Pageable pageable;
    private BancoRequest bancoRequest;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler())
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        // Setup pageable
        pageable = PageRequest.of(0, 10);

        // Setup test data
        banco = new Banco();
        banco.setId(1L);
        banco.setCodBanco("001");
        banco.setNomBanco("BANCO DE LA NACION");
        banco.setProveedor("BANCO001");
        banco.setSwift("BNANPEPL");
        banco.setCodBancoSunat("01");
        banco.setDireccion("Av. Javier Prado 1234");

        bancoResponse = new BancoResponse();
        bancoResponse.setId(1L);
        bancoResponse.setCodBanco("001");
        bancoResponse.setNomBanco("BANCO DE LA NACION");
        bancoResponse.setProveedor("BANCO001");
        bancoResponse.setSwift("BNANPEPL");
        bancoResponse.setCodBancoSunat("01");
        bancoResponse.setDireccion("Av. Javier Prado 1234");

        bancoRequest = new BancoRequest();
        bancoRequest.setCodBanco("001");
        bancoRequest.setNomBanco("BANCO DE LA NACION");
        bancoRequest.setProveedor("BANCO001");
        bancoRequest.setSwift("BNANPEPL");
        bancoRequest.setCodBancoSunat("01");
        bancoRequest.setDireccion("Av. Javier Prado 1234");

        // Setup mapper mocks
        lenient().when(mapper.toResponse(any(Banco.class))).thenReturn(bancoResponse);
        lenient().when(mapper.toResponseList(anyList())).thenReturn(List.of(bancoResponse));
        lenient().when(mapper.toEntity(any(BancoRequest.class))).thenReturn(banco);
        lenient().doNothing().when(mapper).updateEntity(any(BancoRequest.class), any(Banco.class));
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("Debe listar bancos paginados")
    void listar_retornaPagina() throws Exception {
        // Arrange
        Page<Banco> bancoPage = new PageImpl<>(List.of(banco), pageable, 1);
        when(bancoService.findAll(any(Pageable.class))).thenReturn(bancoPage);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/bancos")
                .param("page", "0")
                .param("size", "20"))
                .andExpect(status().isOk());

        verify(bancoService).findAll(any(Pageable.class));
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("Debe obtener banco por ID")
    void obtenerPorId_cuandoExiste_retornaBanco_WhenValidId() throws Exception {
        // Arrange
        when(bancoService.findById(1L)).thenReturn(banco);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/bancos/{id}", 1L))
                .andExpect(status().isOk());

        verify(bancoService).findById(1L);
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("Debe crear nuevo banco con éxito")
    void crear_conDatosValidos_creaBanco() throws Exception {
        // Arrange
        when(bancoService.create(any(Banco.class))).thenReturn(banco);

        String jsonRequest = objectMapper.writeValueAsString(bancoRequest);

        // Act & Then
        mockMvc.perform(post("/api/finanzas/bancos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonRequest))
                .andExpect(status().isCreated());

        verify(bancoService).create(any(Banco.class));
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("Debe actualizar banco existente con éxito")
    void actualizar_conDatosValidos_actualizaBanco() throws Exception {
        // Arrange
        when(bancoService.findById(1L)).thenReturn(banco);
        when(bancoService.update(eq(1L), any(Banco.class))).thenReturn(banco);

        String jsonRequest = objectMapper.writeValueAsString(bancoRequest);

        // Act & Then
        mockMvc.perform(put("/api/finanzas/bancos/{id}", 1L)
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonRequest))
                .andExpect(status().isOk());

        verify(bancoService).findById(1L);
        verify(bancoService).update(eq(1L), any(Banco.class));
    }


    // ==== eliminar — escenarios felices ====

    @Test
    @DisplayName("Debe eliminar banco")
    void eliminar_cuandoExiste_eliminaBanco() throws Exception {
        // Arrange
        doNothing().when(bancoService).delete(1L);

        // Act & Then
        mockMvc.perform(delete("/api/finanzas/bancos/{id}", 1L))
                .andExpect(status().isOk());

        verify(bancoService).delete(1L);
    }


    // ==== activar — escenarios felices ====

    @Test
    @DisplayName("Debe activar banco")
    void activar_conIdValido_activaBanco_WhenValidId() throws Exception {
        // Arrange
        when(bancoService.activate(1L)).thenReturn(banco);

        // Act & Then
        mockMvc.perform(patch("/api/finanzas/bancos/{id}/activar", 1L))
                .andExpect(status().isOk());

        verify(bancoService).activate(1L);
    }


    // ==== desactivar — escenarios felices ====

    @Test
    @DisplayName("Debe desactivar banco")
    void desactivar_conIdValido_desactivaBanco_WhenValidId() throws Exception {
        // Arrange
        when(bancoService.deactivate(1L)).thenReturn(banco);

        // Act & Then
        mockMvc.perform(patch("/api/finanzas/bancos/{id}/desactivar", 1L))
                .andExpect(status().isOk());

        verify(bancoService).deactivate(1L);
    }
}
