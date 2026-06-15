package com.sigre.core.mapper;

import org.junit.jupiter.api.Test;
import com.sigre.core.dto.ContactoResponse;
import com.sigre.core.dto.CuentaBancariaResponse;
import com.sigre.core.dto.RelacionComercialResponse;
import com.sigre.core.entity.Contacto;
import com.sigre.core.entity.CuentaBancaria;
import com.sigre.core.entity.RelacionComercial;

import static org.assertj.core.api.Assertions.assertThat;

class RelacionComercialMapperTest {

    private final RelacionComercialMapper mapper = new RelacionComercialMapper();

    @Test
    void toRelacionResponse_mapsAllFields() {
        RelacionComercial entity = new RelacionComercial();
        entity.setId(1L);
        entity.setRazonSocial("Empresa SAC");
        entity.setNombreComercial("Comercial SAC");
        entity.setTipoDocIdentidadId(6L);
        entity.setNroDocumento("20123456789");
        entity.setDireccion("Av. Peru 123");
        entity.setTelefono("014567890");
        entity.setEmail("empresa@mail.com");
        entity.setEsProveedor(true);
        entity.setEsCliente(false);
        entity.setTipoEntidadContribuyenteId(2L);
        entity.setFlagEstado("1");

        RelacionComercialResponse response = mapper.toRelacionResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getRazonSocial()).isEqualTo("Empresa SAC");
        assertThat(response.getNombreComercial()).isEqualTo("Comercial SAC");
        assertThat(response.getTipoDocIdentidadId()).isEqualTo(6L);
        assertThat(response.getNroDocumento()).isEqualTo("20123456789");
        assertThat(response.getDireccion()).isEqualTo("Av. Peru 123");
        assertThat(response.getTelefono()).isEqualTo("014567890");
        assertThat(response.getEmail()).isEqualTo("empresa@mail.com");
        assertThat(response.getEsProveedor()).isTrue();
        assertThat(response.getEsCliente()).isFalse();
        assertThat(response.getTipoEntidadContribuyenteId()).isEqualTo(2L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void toRelacionResponse_fallsBackToTipoDocumento() {
        RelacionComercial entity = new RelacionComercial();
        entity.setId(1L);
        entity.setRazonSocial("Empresa SAC");
        entity.setTipoDocIdentidadId(null);
        entity.setTipoDocumento("6");
        entity.setNroDocumento("20123456789");
        entity.setEsProveedor(false);
        entity.setEsCliente(true);
        entity.setFlagEstado("1");

        RelacionComercialResponse response = mapper.toRelacionResponse(entity);

        assertThat(response.getTipoDocIdentidadId()).isEqualTo(6L);
    }

    @Test
    void toRelacionResponse_invalidTipoDocumentoReturnsNull() {
        RelacionComercial entity = new RelacionComercial();
        entity.setId(1L);
        entity.setRazonSocial("Empresa SAC");
        entity.setTipoDocIdentidadId(null);
        entity.setTipoDocumento("INVALID");
        entity.setNroDocumento("20123456789");
        entity.setEsProveedor(false);
        entity.setEsCliente(false);
        entity.setFlagEstado("1");

        RelacionComercialResponse response = mapper.toRelacionResponse(entity);

        assertThat(response.getTipoDocIdentidadId()).isNull();
    }

    @Test
    void toContactoResponse_mapsAllFields() {
        Contacto entity = new Contacto();
        entity.setId(1L);
        entity.setNombre("Juan Perez");
        entity.setCargo("Gerente");
        entity.setTelefono("999888777");
        entity.setEmail("juan@empresa.com");

        ContactoResponse response = mapper.toContactoResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Juan Perez");
        assertThat(response.getCargo()).isEqualTo("Gerente");
        assertThat(response.getTelefono()).isEqualTo("999888777");
        assertThat(response.getEmail()).isEqualTo("juan@empresa.com");
    }

    @Test
    void toCuentaResponse_mapsAllFields() {
        CuentaBancaria entity = new CuentaBancaria();
        entity.setId(1L);
        entity.setCodBanco("002");
        entity.setNumeroCuenta("1234567890");
        entity.setCci("00212345678901234567");
        entity.setMonedaId(1L);

        CuentaBancariaResponse response = mapper.toCuentaResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCodBanco()).isEqualTo("002");
        assertThat(response.getNumeroCuenta()).isEqualTo("1234567890");
        assertThat(response.getCci()).isEqualTo("00212345678901234567");
        assertThat(response.getMonedaId()).isEqualTo(1L);
        assertThat(response.getTipoCuenta()).isNull();
    }
}
