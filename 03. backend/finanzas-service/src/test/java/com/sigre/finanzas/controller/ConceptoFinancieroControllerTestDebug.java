package com.sigre.finanzas.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import com.sigre.finanzas.dto.request.ConceptoFinancieroRequest;
import com.sigre.finanzas.dto.response.ConceptoFinancieroResponse;
import com.sigre.finanzas.entity.ConceptoFinanciero;
import com.sigre.finanzas.mapper.ConceptoFinancieroMapper;
import com.sigre.finanzas.service.ConceptoFinancieroService;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class ConceptoFinancieroControllerTestDebug {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ConceptoFinancieroService conceptoFinancieroService;

    @Autowired
    private ConceptoFinancieroMapper conceptoFinancieroMapper;


    // ==== testCreateDebug — otros ====

    @Test
    void testCreateDebug() throws Exception {
        // Arrange
        ConceptoFinancieroRequest request = new ConceptoFinancieroRequest();
        request.setCodigo("CF002");
        request.setNombre("TEST");

        ConceptoFinanciero entity = new ConceptoFinanciero();
        entity.setId(1L);
        entity.setCodigo("CF002");
        entity.setNombre("TEST");

        ConceptoFinancieroResponse response = new ConceptoFinancieroResponse();
        response.setId(1L);
        response.setCodigo("CF002");
        response.setNombre("TEST");
        response.setActivo(true);

        when(conceptoFinancieroService.create(any(ConceptoFinanciero.class))).thenReturn(entity);

        // Act & Then
        mockMvc.perform(post("/api/finanzas/conceptos-financieros")
                .contentType(MediaType.APPLICATION_JSON)
                .content(new ObjectMapper().writeValueAsString(request))
                .header("X-Empresa-Id", "1"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").exists())
                .andExpect(jsonPath("$.data.id").value(1));
    }
}
