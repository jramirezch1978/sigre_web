import { AlmacenEntity } from '../../domain/models/almacen.entity';
import { AlmacenHttpService } from '../http/almacen-http.service';
import { BackendAlmacenRequest, BackendAlmacenResponse } from '../../application/dto/almacen-backend.types';

/**
 * Conversión entre el contrato del backend (`AlmacenResponse`/`AlmacenRequest`)
 * y la entidad de dominio del front (`AlmacenEntity`).
 *
 * El backend de almacén es más simple que el modelo del front: no persiste
 * dirección, ciudad, responsable, capacidad ni distrito. Esos campos se exponen
 * vacíos al leer y se ignoran al escribir (no existen en el contrato del backend).
 */
export class AlmacenMapper {

  /** Backend → entidad de dominio. */
  static toEntity(res: BackendAlmacenResponse): AlmacenEntity {
    return {
      id: res.id,
      sucursalId: res.sucursalId,
      almacen_tipo_id: res.almacenTipoId,
      almacen_codigo: res.codigo ?? '',
      almacen_nombre: res.nombre ?? '',
      almacen_tipo: res.almacenTipoNombre ?? '',
      // flag_estado ('1'/'0') → etiqueta que usan grilla y form ('Activo'/'Inactivo').
      almacen_estado: res.flagEstado === '0' ? 'Inactivo' : 'Activo',
      // Campos sin equivalente en el backend (se exponen vacíos):
      almacen_direccion: '',
      almacen_ciudad: '',
      almacen_responsable: '',
      almacen_capacidad: '',
      almacen_distrito: '',
      almacen_fecha: res.fecModificacion,
      almacen_fecha_creacion: res.fecCreacion,
    };
  }

  static toEntityList(list: BackendAlmacenResponse[]): AlmacenEntity[] {
    return (list ?? []).map((r) => AlmacenMapper.toEntity(r));
  }

  /** Entidad de dominio → cuerpo de creación/actualización del backend. */
  static toRequest(entity: AlmacenEntity): BackendAlmacenRequest {
    return {
      sucursalId: entity.sucursalId ?? AlmacenHttpService.getSucursalId(),
      almacenTipoId: entity.almacen_tipo_id ?? null,
      codigo: entity.almacen_codigo,
      nombre: entity.almacen_nombre,
    };
  }
}
