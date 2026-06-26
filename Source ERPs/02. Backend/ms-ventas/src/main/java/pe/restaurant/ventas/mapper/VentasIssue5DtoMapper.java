package pe.restaurant.ventas.mapper;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import pe.restaurant.ventas.dto.response.EntidadCreditosCxcResponse;
import pe.restaurant.ventas.dto.response.PropinaResponse;
import pe.restaurant.ventas.dto.response.ReservacionResponse;
import pe.restaurant.ventas.entity.EntidadCreditosCxc;
import pe.restaurant.ventas.entity.Propina;
import pe.restaurant.ventas.entity.Reservacion;
import pe.restaurant.ventas.entity.ReservacionDet;
import pe.restaurant.ventas.repository.MesaRepository;
import pe.restaurant.ventas.repository.VentasFkValidator;

import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class VentasIssue5DtoMapper {

    private final VentasFkValidator fkValidator;
    private final MesaRepository mesaRepository;

    public PropinaResponse toPropinaResponse(Propina p) {
        return PropinaResponse.builder()
                .id(p.getId())
                .fsFacturaSimplId(p.getFsFacturaSimplId())
                .trabajadorId(p.getTrabajadorId())
                .monto(p.getMonto())
                .fecha(p.getFecha())
                .flagEstado(p.getFlagEstado())
                .createdBy(p.getCreatedBy())
                .fecCreacion(p.getFecCreacion())
                .updatedBy(p.getUpdatedBy())
                .fecModificacion(p.getFecModificacion())
                .build();
    }

    public ReservacionResponse toReservacionResponse(Reservacion r) {
        var b = baseReservacion(r);
        if (r.getItems() != null) {
            b.items(r.getItems().stream().map(this::toDet).collect(Collectors.toList()));
        } else {
            b.items(null);
        }
        return b.build();
    }

    public ReservacionResponse toReservacionListItem(Reservacion r) {
        return baseReservacion(r).items(null).build();
    }

    private ReservacionResponse.ReservacionResponseBuilder baseReservacion(Reservacion r) {
        String mesaNumero = null;
        if (r.getMesaId() != null) {
            mesaNumero = mesaRepository.findById(r.getMesaId()).map(m -> m.getNumero()).orElse(null);
        }
        return ReservacionResponse.builder()
                .id(r.getId())
                .sucursalId(r.getSucursalId())
                .sucursalNombre(fkValidator.findSucursalNombre(r.getSucursalId()))
                .clienteId(r.getClienteId())
                .clienteRazonSocial(fkValidator.findEntidadRazonSocial(r.getClienteId()))
                .mesaId(r.getMesaId())
                .mesaNumero(mesaNumero)
                .fsFacturaSimplId(r.getFsFacturaSimplId())
                .fecha(r.getFecha())
                .hora(r.getHora())
                .comensales(r.getComensales())
                .estado(r.getEstado())
                .observaciones(r.getObservaciones())
                .motivoCancelacion(r.getMotivoCancelacion())
                .flagEstado(r.getFlagEstado())
                .createdBy(r.getCreatedBy())
                .fecCreacion(r.getFecCreacion())
                .updatedBy(r.getUpdatedBy())
                .fecModificacion(r.getFecModificacion());
    }

    private ReservacionResponse.ReservacionDetResponse toDet(ReservacionDet d) {
        return ReservacionResponse.ReservacionDetResponse.builder()
                .id(d.getId())
                .articuloId(d.getArticuloId())
                .cantidad(d.getCantidad())
                .observacion(d.getObservacion())
                .build();
    }

    public EntidadCreditosCxcResponse toCreditosResponse(EntidadCreditosCxc e) {
        return EntidadCreditosCxcResponse.builder()
                .id(e.getId())
                .entidadContribuyenteId(e.getEntidadContribuyenteId())
                .entidadRazonSocial(fkValidator.findEntidadRazonSocial(e.getEntidadContribuyenteId()))
                .entidadRuc(fkValidator.findEntidadRuc(e.getEntidadContribuyenteId()))
                .monedaId(e.getMonedaId())
                .monedaSimbolo(fkValidator.findMonedaSimbolo(e.getMonedaId()))
                .limiteCredito(e.getLimiteCredito())
                .diasCredito(e.getDiasCredito())
                .flagEstado(e.getFlagEstado())
                .createdBy(e.getCreatedBy())
                .fecCreacion(e.getFecCreacion())
                .updatedBy(e.getUpdatedBy())
                .fecModificacion(e.getFecModificacion())
                .build();
    }
}
