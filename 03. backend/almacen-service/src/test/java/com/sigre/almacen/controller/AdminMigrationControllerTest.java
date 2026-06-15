package com.sigre.almacen.controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AdminMigrationControllerTest {

    @Mock
    private EntityManager em;

    @Mock
    private Query query;

    @InjectMocks
    private AdminMigrationController controller;

    @BeforeEach
    void setUp() {
        when(em.createNativeQuery(anyString())).thenReturn(query);
        when(query.executeUpdate()).thenReturn(0);
    }

    @Test
    void migrate_runsAlterAndIndex() {
        var result = controller.migrate();

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).contains("Migración");
        verify(em, times(2)).createNativeQuery(anyString());
        verify(query, times(2)).executeUpdate();
    }
}
