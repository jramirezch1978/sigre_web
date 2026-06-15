package com.sigre.finanzas.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import com.sigre.finanzas.entity.ConceptoFinanciero;
import com.sigre.finanzas.mapper.ConceptoFinancieroMapper;
import com.sigre.finanzas.service.ConceptoFinancieroService;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class ConceptoFinancieroControllerTestSimple {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ConceptoFinancieroService conceptoFinancieroService;

    @MockBean
    private ConceptoFinancieroMapper conceptoFinancieroMapper;


    // ==== testSimpleRequest — otros ====

    @Test
    void testSimpleRequest() throws Exception {
        // Arrange
        ConceptoFinanciero entity = new ConceptoFinanciero();
        entity.setId(1L);
        entity.setCodigo("CF001");
        entity.setNombre("TEST");
        
        when(conceptoFinancieroService.findById(1L)).thenReturn(entity);
        when(conceptoFinancieroMapper.toResponse(entity)).thenReturn(null); // No configurar respuesta

        // Act & Then - Solo verificar que no sea 400
        mockMvc.perform(get("/api/finanzas/conceptos-financieros/1")
                .header("X-Empresa-Id", "1"))
                .andExpect(status().isOk());
    }
}
