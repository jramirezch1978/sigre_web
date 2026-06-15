package com.sigre.comercializacion.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.ProformaRequest;
import com.sigre.comercializacion.dto.response.ProformaResponse;
import com.sigre.comercializacion.entity.Proforma;
import com.sigre.comercializacion.mapper.VentasResponseMapper;
import com.sigre.comercializacion.service.ProformaService;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProformaControllerTest {

    @Mock
    private ProformaService service;
    @Mock
    private VentasResponseMapper mapper;
    @InjectMocks
    private ProformaController controller;

    @Test
    void list() {
        when(service.findAll(any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(new Proforma())));
        when(mapper.toProformaResponseForList(any())).thenReturn(ProformaResponse.builder().id(1L).build());
        assertThat(controller.list(Pageable.unpaged(), null, null, null).isSuccess()).isTrue();
    }

    @Test
    void getById() {
        when(service.findById(1L)).thenReturn(new Proforma());
        when(mapper.toProformaResponse(any())).thenReturn(ProformaResponse.builder().id(1L).build());
        assertThat(controller.get(1L).isSuccess()).isTrue();
    }

    @Test
    void anular() {
        when(service.anular(2L)).thenReturn(new Proforma());
        when(mapper.toProformaResponse(any())).thenReturn(ProformaResponse.builder().id(2L).build());
        assertThat(controller.anular(2L).isSuccess()).isTrue();
    }

    @Test
    void create() {
        var req = ProformaRequest.builder()
                .sucursalId(1L)
                .fecha(LocalDate.now())
                .fechaValidez(LocalDate.now().plusDays(7))
                .build();
        when(service.create(any())).thenReturn(new Proforma());
        when(mapper.toProformaResponse(any())).thenReturn(ProformaResponse.builder().id(3L).build());
        assertThat(controller.create(req).isSuccess()).isTrue();
    }
}
