package com.sigre.core.mapper;

import org.springframework.stereotype.Component;
import com.sigre.core.dto.ContactoResponse;
import com.sigre.core.dto.CuentaBancariaResponse;
import com.sigre.core.dto.LineaCreditoResponse;
import com.sigre.core.dto.RelacionComercialResponse;
import com.sigre.core.entity.Contacto;
import com.sigre.core.entity.CuentaBancaria;
import com.sigre.core.entity.LineaCredito;
import com.sigre.core.entity.RelacionComercial;

@Component
public class RelacionComercialMapper {
    public RelacionComercialResponse toRelacionResponse(RelacionComercial entity) {
        Long tipoDocId = entity.getTipoDocIdentidadId() != null
                ? entity.getTipoDocIdentidadId()
                : parseTipoDoc(entity.getTipoDocumento());
        return new RelacionComercialResponse(
                entity.getId(),
                entity.getRazonSocial(),
                entity.getNombreComercial(),
                tipoDocId,
                entity.getNroDocumento(),
                entity.getDireccion(),
                entity.getTelefono(),
                entity.getEmail(),
                entity.getEsProveedor(),
                entity.getEsCliente(),
                entity.getTipoEntidadContribuyenteId(),
                entity.getFlagEstado()
        );
    }

    public ContactoResponse toContactoResponse(Contacto entity) {
        return new ContactoResponse(
                entity.getId(),
                entity.getNombre(),
                entity.getCargo(),
                entity.getTelefono(),
                entity.getEmail()
        );
    }

    public CuentaBancariaResponse toCuentaResponse(CuentaBancaria entity) {
        return new CuentaBancariaResponse(
                entity.getId(),
                entity.getCodBanco(),
                entity.getNumeroCuenta(),
                entity.getCci(),
                entity.getMonedaId(),
                null
        );
    }

    public LineaCreditoResponse toLineaResponse(LineaCredito entity) {
        return new LineaCreditoResponse(
                entity.getId(),
                entity.getMonedaId(),
                entity.getLimiteCredito(),
                entity.getDiasCredito(),
                entity.getFechaVencimiento(),
                entity.getFlagEstado()
        );
    }

    private Long parseTipoDoc(String tipoDocumento) {
        try {
            return tipoDocumento == null ? null : Long.parseLong(tipoDocumento);
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
