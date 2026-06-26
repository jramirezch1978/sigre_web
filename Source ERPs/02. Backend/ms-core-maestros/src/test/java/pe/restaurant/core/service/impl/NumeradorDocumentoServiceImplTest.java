package pe.restaurant.core.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.entity.NumeradorDocumento;
import pe.restaurant.core.repository.NumeradorDocumentoRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class NumeradorDocumentoServiceImplTest {

    @Mock private NumeradorDocumentoRepository repository;
    @InjectMocks private NumeradorDocumentoServiceImpl service;

    private NumeradorDocumento entity;

    @BeforeEach
    void setUp() {
        entity = new NumeradorDocumento();
        entity.setNombreTabla("comprobante");
        entity.setSucursalId(1L);
        entity.setAno((short) 2026);
        entity.setUltNro(1L);
        entity.setFlagEstado("1");
    }

    private NumeradorDocumento.NumeradorDocumentoId id() {
        NumeradorDocumento.NumeradorDocumentoId id = new NumeradorDocumento.NumeradorDocumentoId();
        id.setNombreTabla("comprobante");
        id.setSucursalId(1L);
        id.setAno((short) 2026);
        return id;
    }

    @Test void findAll() {
        when(repository.findAll(PageRequest.of(0, 20))).thenReturn(new PageImpl<>(List.of(entity)));
        assertThat(service.findAll(PageRequest.of(0, 20)).getContent()).hasSize(1);
    }

    @Test void findByIdNotFound() {
        when(repository.findById(any())).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.findById(id())).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test void createSuccess() {
        when(repository.findById(any())).thenReturn(Optional.empty());
        when(repository.save(entity)).thenReturn(entity);
        assertThat(service.create(entity)).isNotNull();
    }

    @Test void createDuplicate() {
        when(repository.findById(any())).thenReturn(Optional.of(entity));
        assertThatThrownBy(() -> service.create(entity)).isInstanceOf(BusinessException.class);
    }

    @Test void update() {
        when(repository.save(entity)).thenReturn(entity);
        assertThat(service.update(entity)).isNotNull();
    }

    @Test void deactivate() {
        when(repository.findById(any())).thenReturn(Optional.of(entity));
        when(repository.save(any())).thenReturn(entity);
        service.deactivate(id());
        assertThat(entity.getFlagEstado()).isEqualTo("0");
    }

    @Test void delete() {
        when(repository.findById(any())).thenReturn(Optional.of(entity));
        service.delete(id());
    }
}
