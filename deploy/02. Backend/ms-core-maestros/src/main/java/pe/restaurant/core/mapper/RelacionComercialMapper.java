package pe.restaurant.core.mapper;

import org.springframework.stereotype.Component;
import pe.restaurant.core.dto.ContactoResponse;
import pe.restaurant.core.dto.CuentaBancariaResponse;
import pe.restaurant.core.dto.RelacionComercialResponse;
import pe.restaurant.core.entity.Contacto;
import pe.restaurant.core.entity.CuentaBancaria;
import pe.restaurant.core.entity.RelacionComercial;

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

    private Long parseTipoDoc(String tipoDocumento) {
        try {
            return tipoDocumento == null ? null : Long.parseLong(tipoDocumento);
        } catch (NumberFormatException ex) {
            return null;
        }
    }
}
