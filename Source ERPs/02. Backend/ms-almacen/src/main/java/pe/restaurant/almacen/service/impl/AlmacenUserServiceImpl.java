package pe.restaurant.almacen.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.almacen.entity.AlmacenUser;
import pe.restaurant.almacen.repository.AlmacenRepository;
import pe.restaurant.almacen.repository.AlmacenUserRepository;
import pe.restaurant.almacen.service.AlmacenUserService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AlmacenUserServiceImpl implements AlmacenUserService {

    private final AlmacenUserRepository repository;
    private final AlmacenRepository almacenRepository;
    private final JdbcTemplate jdbcTemplate;

    @Timed(value = "app.db.query", extraTags = {"table", "almacen_user", "operation", "listar"})
    @Override
    public List<AlmacenUser> listarPorAlmacenId(Long almacenId) {
        return listarPorAlmacenId(almacenId, null, null);
    }

    @Override
    public List<AlmacenUser> listarPorAlmacenId(Long almacenId, String flagEstado, Long usuarioId) {
        if (!almacenRepository.existsById(almacenId)) {
            throw new ResourceNotFoundException("Almacen", almacenId);
        }
        boolean hasFlag = flagEstado != null && !flagEstado.isBlank();
        boolean hasUsuario = usuarioId != null;
        if (!hasFlag && !hasUsuario) {
            return repository.findByAlmacenId(almacenId);
        }
        if (hasFlag && hasUsuario) {
            return repository.findByAlmacenIdAndFlagEstadoAndUsuarioId(almacenId, flagEstado, usuarioId);
        }
        if (hasFlag) {
            return repository.findByAlmacenIdAndFlagEstado(almacenId, flagEstado);
        }
        return repository.findAllByAlmacenIdAndUsuarioId(almacenId, usuarioId);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen_user", "operation", "asignar"})
    @Override
    @Transactional
    public AlmacenUser asignar(Long almacenId, Long usuarioId) {
        if (!almacenRepository.existsById(almacenId)) {
            throw new ResourceNotFoundException("Almacen", almacenId);
        }
        assertUsuarioExiste(usuarioId);

        Optional<AlmacenUser> existing = repository.findFirstByAlmacenIdAndUsuarioId(almacenId, usuarioId);
        if (existing.isPresent()) {
            if ("1".equals(existing.get().getFlagEstado())) {
                throw new BusinessException(
                        "El usuario ya está asignado a este almacén.",
                        HttpStatus.CONFLICT,
                        "ALMACEN_USUARIO_DUPLICADO");
            }
            AlmacenUser e = existing.get();
            e.setFlagEstado("1");
            return repository.save(e);
        }

        AlmacenUser row = new AlmacenUser();
        row.setAlmacenId(almacenId);
        row.setUsuarioId(usuarioId);
        row.setFlagEstado("1");
        return repository.save(row);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen_user", "operation", "desasignar"})
    @Override
    @Transactional
    public AlmacenUser desasignar(Long almacenId, Long usuarioId) {
        if (!almacenRepository.existsById(almacenId)) {
            throw new ResourceNotFoundException("Almacen", almacenId);
        }
        AlmacenUser row = repository
                .findFirstByAlmacenIdAndUsuarioId(almacenId, usuarioId)
                .orElseThrow(() -> new ResourceNotFoundException("Asignacion almacen-usuario", "almacenId+usuarioId", almacenId + "/" + usuarioId));
        row.setFlagEstado("0");
        return repository.save(row);
    }

    private void assertUsuarioExiste(Long usuarioId) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM auth.usuario WHERE id = ?",
                Integer.class,
                usuarioId);
        if (count == null || count == 0) {
            throw new ResourceNotFoundException("Usuario", usuarioId);
        }
    }
}
