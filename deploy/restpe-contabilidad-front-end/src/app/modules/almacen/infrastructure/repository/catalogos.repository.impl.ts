import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { ICatalogosRepository } from '../../domain/repositories/icatalogos.repository';
import {
  CatalogoItemEntity,
  CatalogosEntity,
  TransferenciaEntity,
} from '../../domain/models/catalogo.entity';
import { AlmacenHttpService } from '../http/almacen-http.service';
import { ALMACEN_ENDPOINTS } from '../http/almacen-api.config';
import {
  BackendArticuloMovTipoResponse,
  BackendOrdenTrasladoResponse,
} from '../../application/dto/almacen-backend.types';

/**
 * Catálogos del módulo de almacén.
 *
 * Cobertura real del backend (`ms-almacen`):
 *  - `catalogos_tipos_movimiento` ← `GET /tipos-movimiento`.
 *  - `obtenerTransferencias`      ← `GET /ordenes-traslado` (best-effort).
 *
 * GAP: tipos de documento, estados de operación, tipos de despacho, estados de
 * producto y unidades de medida NO existen en `ms-almacen` (son de
 * `ms-core-maestros` o catálogos estáticos). Se devuelven vacíos.
 */
@Injectable()
export class CatalogosRepositoryImpl extends ICatalogosRepository {

  private readonly api = inject(AlmacenHttpService);

  constructor() {
    super();
  }

  obtenerCatalogos(): Observable<CatalogosEntity> {
    return this.api
      .getList<BackendArticuloMovTipoResponse>(ALMACEN_ENDPOINTS.tiposMovimiento, { size: 500 })
      .pipe(
        map((tipos): CatalogosEntity => ({
          catalogos_tipos_movimiento: tipos.map((t) => this.toItem(t)),
          catalogos_tipos_documento: [],
          catalogos_estados_operacion: [],
          catalogos_tipos_despacho: [],
          catalogos_estados_producto: [],
          catalogos_unidades_medida: [],
        })),
      );
  }

  obtenerTransferencias(): Observable<TransferenciaEntity[]> {
    return this.api
      .getList<BackendOrdenTrasladoResponse>(ALMACEN_ENDPOINTS.ordenesTraslado, { size: 500, sort: 'id,desc' })
      .pipe(map((ordenes) => ordenes.map((o) => this.toTransferencia(o))));
  }

  private toItem(t: BackendArticuloMovTipoResponse): CatalogoItemEntity {
    return {
      catalogo_item_id: String(t.id),
      catalogo_item_nombre: t.descTipoMov || t.tipoMov || `Tipo ${t.id}`,
    };
  }

  private toTransferencia(o: BackendOrdenTrasladoResponse): TransferenciaEntity {
    return {
      transferencia_nro: o.numero ?? String(o.id),
      transferencia_fecha_envio: o.fecha ?? '',
      transferencia_fecha_recepcion: '',
      transferencia_cantidad_enviada: 0,
      transferencia_cantidad_recibida: 0,
      transferencia_diferencia: 0,
      transferencia_origen: o.almacenOrigenId != null ? String(o.almacenOrigenId) : '',
      transferencia_destino: o.almacenDestinoId != null ? String(o.almacenDestinoId) : '',
      transferencia_estado: o.flagEstado ?? '',
    };
  }
}
