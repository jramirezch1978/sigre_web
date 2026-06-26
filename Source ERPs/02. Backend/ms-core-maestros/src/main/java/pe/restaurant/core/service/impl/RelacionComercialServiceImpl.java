package pe.restaurant.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.entity.Contacto;
import pe.restaurant.core.entity.CuentaBancaria;
import pe.restaurant.core.entity.EntidadContribuyenteRepresentante;
import pe.restaurant.core.entity.EntidadContribuyenteTelefono;
import pe.restaurant.core.entity.EntidadTienda;
import pe.restaurant.core.entity.EntidadTransporte;
import pe.restaurant.core.entity.RelacionComercial;
import pe.restaurant.core.mapper.EntidadContribuyenteRepresentanteMapper;
import pe.restaurant.core.mapper.EntidadContribuyenteTelefonoMapper;
import pe.restaurant.core.mapper.EntidadTiendaMapper;
import pe.restaurant.core.mapper.EntidadTransporteMapper;
import pe.restaurant.core.mapper.RelacionComercialMapper;
import pe.restaurant.core.repository.ArticuloProveedorRepository;
import pe.restaurant.core.repository.ContactoRepository;
import pe.restaurant.core.repository.CuentaBancariaRepository;
import pe.restaurant.core.repository.EntidadContribuyenteRepresentanteRepository;
import pe.restaurant.core.repository.EntidadContribuyenteTelefonoRepository;
import pe.restaurant.core.repository.EntidadTiendaRepository;
import pe.restaurant.core.repository.EntidadTransporteRepository;
import pe.restaurant.core.repository.MonedaRepository;
import pe.restaurant.core.repository.RelacionComercialRepository;
import pe.restaurant.core.service.RelacionComercialService;

import pe.restaurant.common.security.TenantContext;
import java.time.Instant;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class RelacionComercialServiceImpl implements RelacionComercialService {
    private final RelacionComercialRepository repository;
    private final ContactoRepository contactoRepository;
    private final CuentaBancariaRepository cuentaBancariaRepository;
    private final EntidadTiendaRepository entidadTiendaRepository;
    private final EntidadTransporteRepository entidadTransporteRepository;
    private final ArticuloProveedorRepository articuloProveedorRepository;
    private final EntidadContribuyenteTelefonoRepository telefonoRepository;
    private final EntidadContribuyenteRepresentanteRepository representanteRepository;
    private final MonedaRepository monedaRepository;
    private final RelacionComercialMapper mapper;
    private final EntidadTiendaMapper tiendaMapper;
    private final EntidadTransporteMapper transporteMapper;
    private final EntidadContribuyenteTelefonoMapper telefonoMapper;
    private final EntidadContribuyenteRepresentanteMapper representanteMapper;
    private final pe.restaurant.core.mapper.ArticuloProveedorMapper articuloProveedorMapper;

    @Override
    public Page<RelacionComercial> list(Boolean esProveedor, Boolean esCliente, String nroDocumento, String razonSocial, Boolean activo, Pageable pageable) {
        // Por defecto (activo == null) lista todo (activos e inactivos).
        Specification<RelacionComercial> spec = Specification.where(null);
        if (activo != null) {
            spec = spec.and((root, query, cb) -> activo
                    ? cb.equal(root.get("flagEstado"), "1")
                    : cb.notEqual(root.get("flagEstado"), "1"));
        }
        if (esProveedor != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("esProveedor"), esProveedor));
        }
        if (esCliente != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("esCliente"), esCliente));
        }
        if (nroDocumento != null && !nroDocumento.isBlank()) {
            spec = spec.and((root, query, cb) -> cb.like(cb.lower(root.get("nroDocumento")), "%" + nroDocumento.toLowerCase() + "%"));
        }
        if (razonSocial != null && !razonSocial.isBlank()) {
            spec = spec.and((root, query, cb) -> cb.like(cb.lower(root.get("razonSocial")), "%" + razonSocial.toLowerCase() + "%"));
        }
        return repository.findAll(spec, pageable);
    }

    @Override
    public RelacionComercialDetalleResponse getById(Long id) {
        RelacionComercial entity = getEntity(id);
        RelacionComercialDetalleResponse response = new RelacionComercialDetalleResponse();
        RelacionComercialResponse base = mapper.toRelacionResponse(entity);
        response.setId(base.getId());
        response.setRazonSocial(base.getRazonSocial());
        response.setNombreComercial(base.getNombreComercial());
        response.setTipoDocIdentidadId(base.getTipoDocIdentidadId());
        response.setNroDocumento(base.getNroDocumento());
        response.setDireccion(base.getDireccion());
        response.setTelefono(base.getTelefono());
        response.setEmail(base.getEmail());
        response.setEsProveedor(base.getEsProveedor());
        response.setEsCliente(base.getEsCliente());
        response.setTipoEntidadContribuyenteId(base.getTipoEntidadContribuyenteId());
        response.setFlagEstado(base.getFlagEstado());
        response.setContactos(listContactos(id));
        response.setCuentasBancarias(listCuentas(id));
        response.setTelefonos(listTelefonos(id));
        response.setRepresentantes(listRepresentantes(id));
        return response;
    }

    @Override
    @Transactional
    public RelacionComercialResponse create(RelacionComercialRequest request) {
        if (repository.existsByNroDocumento(request.getNroDocumento())) {
            throw new BusinessException("Ya existe una relacion comercial con el mismo numero de documento", HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        RelacionComercial entity = toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toRelacionResponse(repository.save(entity));
    }

    @Override
    @Transactional
    public RelacionComercialResponse update(Long id, RelacionComercialRequest request) {
        RelacionComercial entity = getEntity(id);
        if (repository.existsByNroDocumentoAndIdNot(request.getNroDocumento(), id)) {
            throw new BusinessException("Ya existe una relacion comercial con el mismo numero de documento", HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        entity.setTipoDocIdentidadId(request.getTipoDocIdentidadId());
        entity.setTipoDocumento(request.getTipoDocIdentidadId() != null
                ? String.valueOf(request.getTipoDocIdentidadId()) : null);
        entity.setNroDocumento(request.getNroDocumento());
        entity.setRazonSocial(request.getRazonSocial());
        entity.setNombreComercial(request.getNombreComercial());
        entity.setDireccion(request.getDireccion());
        entity.setTelefono(request.getTelefono());
        entity.setEmail(request.getEmail());
        entity.setEsProveedor(Boolean.TRUE.equals(request.getEsProveedor()));
        entity.setEsCliente(Boolean.TRUE.equals(request.getEsCliente()));
        entity.setTipoEntidadContribuyenteId(request.getTipoEntidadContribuyenteId());
        entity.setFlagEstado(request.getFlagEstado() == null ? "1" : request.getFlagEstado());
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toRelacionResponse(repository.save(entity));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando RelacionComercial con id: {}", id);
        getEntity(id);
        repository.deleteById(id);
        log.info("RelacionComercial eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "relacion_comercial", "operation", "activate"})
    @Override
    @Transactional
    public RelacionComercial activate(Long id) {
        log.info("Activando RelacionComercial con id: {}", id);
        RelacionComercial existing = getEntity(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "relacion_comercial", "operation", "deactivate"})
    @Override
    @Transactional
    public RelacionComercial deactivate(Long id) {
        log.info("Desactivando RelacionComercial con id: {}", id);
        RelacionComercial existing = getEntity(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Override
    public List<ContactoResponse> listContactos(Long relacionId) {
        getEntity(relacionId);
        return contactoRepository.findByRelacionComercialIdAndFlagEstado(relacionId, "1").stream()
                .map(mapper::toContactoResponse)
                .toList();
    }

    @Override
    @Transactional
    public ContactoResponse createContacto(Long relacionId, ContactoRequest request) {
        RelacionComercial relacion = getEntity(relacionId);
        String nombre = request.getNombre() != null ? request.getNombre().trim() : null;
        if (nombre != null && contactoRepository
                .existsByRelacionComercialIdAndNombreIgnoreCaseAndFlagEstado(relacionId, nombre, "1")) {
            throw new BusinessException(
                    "Ya existe un contacto con el mismo nombre para esta relacion comercial",
                    HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        Contacto contacto = new Contacto();
        contacto.setRelacionComercial(relacion);
        contacto.setNombre(nombre);
        contacto.setCargo(request.getCargo());
        contacto.setTelefono(request.getTelefono());
        contacto.setEmail(request.getEmail());
        contacto.setCreatedBy(TenantContext.getUsuarioId());
        contacto.setFecCreacion(Instant.now());
        return mapper.toContactoResponse(contactoRepository.save(contacto));
    }

    @Override
    @Transactional
    public ContactoResponse updateContacto(Long relacionId, Long contactoId, ContactoRequest request) {
        getEntity(relacionId);
        Contacto contacto = contactoRepository.findById(contactoId)
                .filter(c -> c.getRelacionComercial() != null
                        && relacionId.equals(c.getRelacionComercial().getId()))
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Contacto", "id (relacion " + relacionId + ")", String.valueOf(contactoId)));
        String nombre = request.getNombre() != null ? request.getNombre().trim() : null;
        if (nombre != null && !nombre.equalsIgnoreCase(contacto.getNombre())
                && contactoRepository
                        .existsByRelacionComercialIdAndNombreIgnoreCaseAndFlagEstado(relacionId, nombre, "1")) {
            throw new BusinessException(
                    "Ya existe un contacto con el mismo nombre para esta relacion comercial",
                    HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        contacto.setNombre(nombre);
        contacto.setCargo(request.getCargo());
        contacto.setTelefono(request.getTelefono());
        contacto.setEmail(request.getEmail());
        contacto.setUpdatedBy(TenantContext.getUsuarioId());
        contacto.setFecModificacion(Instant.now());
        return mapper.toContactoResponse(contactoRepository.save(contacto));
    }

    @Override
    public List<CuentaBancariaResponse> listCuentas(Long relacionId) {
        getEntity(relacionId);
        return cuentaBancariaRepository.findByRelacionComercialIdAndFlagEstado(relacionId, "1").stream()
                .map(mapper::toCuentaResponse)
                .toList();
    }

    @Override
    @Transactional
    public CuentaBancariaResponse createCuenta(Long relacionId, CuentaBancariaRequest request) {
        RelacionComercial relacion = getEntity(relacionId);
        if (request.getMonedaId() != null && !monedaRepository.existsById(request.getMonedaId())) {
            throw new ResourceNotFoundException("Moneda", request.getMonedaId());
        }
        CuentaBancaria cuenta = new CuentaBancaria();
        cuenta.setRelacionComercial(relacion);
        cuenta.setCodBanco(request.getCodBanco());
        cuenta.setNumeroCuenta(request.getNumeroCuenta());
        cuenta.setCci(request.getCci());
        cuenta.setMonedaId(request.getMonedaId());
        cuenta.setCreatedBy(TenantContext.getUsuarioId());
        cuenta.setFecCreacion(Instant.now());
        return mapper.toCuentaResponse(cuentaBancariaRepository.save(cuenta));
    }

    @Override
    @Transactional
    public CuentaBancariaResponse updateCuenta(Long relacionId, Long cuentaId, CuentaBancariaRequest request) {
        getEntity(relacionId);
        CuentaBancaria cuenta = cuentaBancariaRepository.findById(cuentaId)
                .filter(c -> c.getRelacionComercial() != null
                        && relacionId.equals(c.getRelacionComercial().getId()))
                .orElseThrow(() -> new ResourceNotFoundException(
                        "CuentaBancaria", "id (relacion " + relacionId + ")", String.valueOf(cuentaId)));
        if (request.getMonedaId() != null && !monedaRepository.existsById(request.getMonedaId())) {
            throw new ResourceNotFoundException("Moneda", request.getMonedaId());
        }
        cuenta.setCodBanco(request.getCodBanco());
        cuenta.setNumeroCuenta(request.getNumeroCuenta());
        cuenta.setCci(request.getCci());
        cuenta.setMonedaId(request.getMonedaId());
        cuenta.setUpdatedBy(TenantContext.getUsuarioId());
        cuenta.setFecModificacion(Instant.now());
        return mapper.toCuentaResponse(cuentaBancariaRepository.save(cuenta));
    }

    @Override
    @Transactional
    public void deleteCuenta(Long relacionId, Long cuentaId) {
        getEntity(relacionId);
        CuentaBancaria cuenta = cuentaBancariaRepository.findById(cuentaId)
                .filter(c -> c.getRelacionComercial() != null
                        && relacionId.equals(c.getRelacionComercial().getId()))
                .orElseThrow(() -> new ResourceNotFoundException(
                        "CuentaBancaria", "id (relacion " + relacionId + ")", String.valueOf(cuentaId)));
        cuenta.setFlagEstado("0");
        cuenta.setUpdatedBy(TenantContext.getUsuarioId());
        cuenta.setFecModificacion(Instant.now());
        cuentaBancariaRepository.save(cuenta);
    }

    @Override
    public List<pe.restaurant.core.dto.EntidadTiendaResponse> listTiendas(Long relacionId) {
        getEntity(relacionId);
        return tiendaMapper.toResponseList(
                entidadTiendaRepository.findByEntidadContribuyenteId(relacionId));
    }

    @Override
    @Transactional
    public pe.restaurant.core.dto.EntidadTiendaResponse createTienda(Long relacionId, pe.restaurant.core.dto.EntidadTiendaRequest request) {
        getEntity(relacionId);
        EntidadTienda tienda = tiendaMapper.toEntity(request);
        tienda.setEntidadContribuyenteId(relacionId);
        tienda.setCreatedBy(TenantContext.getUsuarioId());
        tienda.setFecCreacion(Instant.now());
        return tiendaMapper.toResponse(entidadTiendaRepository.save(tienda));
    }

    @Override
    public List<pe.restaurant.core.dto.EntidadTransporteResponse> listTransportes(Long relacionId) {
        getEntity(relacionId);
        return transporteMapper.toResponseList(
                entidadTransporteRepository.findByEntidadContribuyenteId(relacionId));
    }

    @Override
    @Transactional
    public pe.restaurant.core.dto.EntidadTransporteResponse createTransporte(Long relacionId, pe.restaurant.core.dto.EntidadTransporteRequest request) {
        getEntity(relacionId);
        EntidadTransporte transporte = transporteMapper.toEntity(request);
        transporte.setEntidadContribuyenteId(relacionId);
        transporte.setCreatedBy(TenantContext.getUsuarioId());
        transporte.setFecCreacion(Instant.now());
        return transporteMapper.toResponse(entidadTransporteRepository.save(transporte));
    }

    @Override
    public List<pe.restaurant.core.dto.ArticuloProveedorResponse> listArticulos(Long relacionId) {
        getEntity(relacionId);
        return articuloProveedorRepository.findByProveedorIdAndFlagEstado(relacionId, "1").stream()
                .map(articuloProveedorMapper::toResponse)
                .toList();
    }

    @Override
    @Transactional
    public pe.restaurant.core.dto.ArticuloProveedorResponse createArticulo(Long relacionId, Long articuloId) {
        getEntity(relacionId);
        var existing = articuloProveedorRepository.findByArticuloIdAndProveedorId(articuloId, relacionId);
        if (existing.isPresent()) {
            throw new BusinessException("El artículo ya está asociado a este proveedor", HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        pe.restaurant.core.entity.ArticuloProveedor ap = new pe.restaurant.core.entity.ArticuloProveedor();
        ap.setArticuloId(articuloId);
        ap.setProveedorId(relacionId);
        ap.setFlagEstado("1");
        ap.setCreatedBy(TenantContext.getUsuarioId());
        ap.setFecCreacion(Instant.now());
        return articuloProveedorMapper.toResponse(articuloProveedorRepository.save(ap));
    }

    @Override
    public List<pe.restaurant.core.dto.EntidadContribuyenteTelefonoResponse> listTelefonos(Long relacionId) {
        getEntity(relacionId);
        return telefonoMapper.toResponseList(
                telefonoRepository.findByEntidadContribuyenteIdAndFlagEstado(relacionId, "1"));
    }

    @Override
    @Transactional
    public pe.restaurant.core.dto.EntidadContribuyenteTelefonoResponse createTelefono(Long relacionId, pe.restaurant.core.dto.EntidadContribuyenteTelefonoRequest request) {
        getEntity(relacionId);
        EntidadContribuyenteTelefono entity = telefonoMapper.toEntity(request);
        entity.setEntidadContribuyenteId(relacionId);
        Short nextItem = (short) (telefonoRepository.findByEntidadContribuyenteId(relacionId).size() + 1);
        entity.setItem(nextItem);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return telefonoMapper.toResponse(telefonoRepository.save(entity));
    }

    @Override
    public List<pe.restaurant.core.dto.EntidadContribuyenteRepresentanteResponse> listRepresentantes(Long relacionId) {
        getEntity(relacionId);
        return representanteMapper.toResponseList(
                representanteRepository.findByEntidadContribuyenteIdAndFlagEstado(relacionId, "1"));
    }

    @Override
    @Transactional
    public pe.restaurant.core.dto.EntidadContribuyenteRepresentanteResponse createRepresentante(Long relacionId, pe.restaurant.core.dto.EntidadContribuyenteRepresentanteRequest request) {
        getEntity(relacionId);
        EntidadContribuyenteRepresentante entity = representanteMapper.toEntity(request);
        entity.setEntidadContribuyenteId(relacionId);
        Short nextItem = (short) (representanteRepository.findByEntidadContribuyenteId(relacionId).size() + 1);
        entity.setItem(nextItem);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return representanteMapper.toResponse(representanteRepository.save(entity));
    }

    private RelacionComercial getEntity(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("RelacionComercial", id));
    }

    private RelacionComercial toEntity(RelacionComercialRequest request) {
        RelacionComercial entity = new RelacionComercial();
        entity.setTipoPersona("JURIDICA");
        entity.setTipoDocIdentidadId(request.getTipoDocIdentidadId());
        entity.setTipoDocumento(request.getTipoDocIdentidadId() != null
                ? String.valueOf(request.getTipoDocIdentidadId()) : null);
        entity.setNroDocumento(request.getNroDocumento());
        entity.setRazonSocial(request.getRazonSocial());
        entity.setNombreComercial(request.getNombreComercial());
        entity.setDireccion(request.getDireccion());
        entity.setTelefono(request.getTelefono());
        entity.setEmail(request.getEmail());
        entity.setEsProveedor(Boolean.TRUE.equals(request.getEsProveedor()));
        entity.setEsCliente(Boolean.TRUE.equals(request.getEsCliente()));
        entity.setTipoEntidadContribuyenteId(request.getTipoEntidadContribuyenteId());
        entity.setFlagEstado(request.getFlagEstado() == null ? "1" : request.getFlagEstado());
        return entity;
    }
}
