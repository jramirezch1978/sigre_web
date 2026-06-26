package pe.restaurant.rrhh.controller;

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
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.rrhh.dto.request.TurnoRequest;
import pe.restaurant.rrhh.dto.response.TurnoResponse;
import pe.restaurant.rrhh.service.TurnoService;

import java.time.LocalTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
@DisplayName("TurnoController - Pruebas Unitarias")
class TurnoControllerTest {

    @Mock private TurnoService turnoService;
    @InjectMocks private TurnoController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna pagina exitosamente")
    void listar_sinFiltros_retornaPagina() throws Exception {
        TurnoResponse turno = crearTurnoResponseMock(1L, "Turno Manana");
        Page<TurnoResponse> page = new PageImpl<>(List.of(turno));
        when(turnoService.listar(isNull(), isNull(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/turnos")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk());

        verify(turnoService).listar(isNull(), isNull(), any());
    }

    @Test
    @DisplayName("listar() con filtro por nombre -> retorna pagina filtrada")
    void listar_conNombre_retornaPaginaFiltrada() throws Exception {
        TurnoResponse turno = crearTurnoResponseMock(1L, "Turno Noche");
        Page<TurnoResponse> page = new PageImpl<>(List.of(turno));
        when(turnoService.listar(eq("Noche"), isNull(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/turnos")
                .param("nombre", "Noche")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk());

        verify(turnoService).listar(eq("Noche"), isNull(), any());
    }

    @Test
    @DisplayName("obtener() con ID existente -> retorna turno")
    void obtener_idExistente_retornaTurno() throws Exception {
        TurnoResponse turno = crearTurnoResponseMock(1L, "Turno Manana");
        when(turnoService.obtenerPorId(1L)).thenReturn(turno);

        mockMvc.perform(get("/api/rrhh/turnos/1"))
                .andExpect(status().isOk());

        verify(turnoService).obtenerPorId(1L);
    }

    @Test
    @DisplayName("obtener() con ID inexistente -> lanza excepcion")
    void obtener_idInexistente_lanzaExcepcion() throws Exception {
        when(turnoService.obtenerPorId(999L))
                .thenThrow(new ResourceNotFoundException("Turno", 999L));

        assertThatThrownBy(() -> mockMvc.perform(get("/api/rrhh/turnos/999")))
                .hasCauseInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("crear() con datos validos -> crea turno exitosamente")
    void crear_datosValidos_creaExitosamente() throws Exception {
        TurnoRequest request = crearTurnoRequestMock("Turno Tarde");
        TurnoResponse response = crearTurnoResponseMock(2L, "Turno Tarde");
        when(turnoService.crear(any())).thenReturn(response);

        mockMvc.perform(post("/api/rrhh/turnos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated());

        verify(turnoService).crear(any());
    }

    @Test
    @DisplayName("actualizar() con datos validos -> actualiza exitosamente")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        TurnoRequest request = crearTurnoRequestMock("Turno Actualizado");
        TurnoResponse response = crearTurnoResponseMock(1L, "Turno Actualizado");
        when(turnoService.actualizar(eq(1L), any())).thenReturn(response);

        mockMvc.perform(put("/api/rrhh/turnos/1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk());

        verify(turnoService).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("desactivar() con ID valido -> desactiva exitosamente")
    void desactivar_idValido_desactivaExitosamente() throws Exception {
        when(turnoService.desactivar(1L)).thenReturn(crearTurnoResponseMock(1L, "Turno Manana"));

        mockMvc.perform(patch("/api/rrhh/turnos/1/desactivar"))
                .andExpect(status().isOk());

        verify(turnoService).desactivar(1L);
    }

    private TurnoResponse crearTurnoResponseMock(Long id, String nombre) {
        return TurnoResponse.builder()
                .id(id).nombre(nombre)
                .horaEntrada(LocalTime.of(8, 0)).horaSalida(LocalTime.of(16, 0))
                .minutosTolerancia(10)
                .aplicaLunes(true).aplicaMartes(true).aplicaMiercoles(true)
                .aplicaJueves(true).aplicaViernes(true)
                .aplicaSabado(false).aplicaDomingo(false)
                .build();
    }

    private TurnoRequest crearTurnoRequestMock(String nombre) {
        return TurnoRequest.builder()
                .nombre(nombre)
                .horaEntrada(LocalTime.of(8, 0)).horaSalida(LocalTime.of(16, 0))
                .minutosTolerancia(10)
                .aplicaLunes(true).aplicaMartes(true).aplicaMiercoles(true)
                .aplicaJueves(true).aplicaViernes(true)
                .aplicaSabado(false).aplicaDomingo(false)
                .build();
    }
}
