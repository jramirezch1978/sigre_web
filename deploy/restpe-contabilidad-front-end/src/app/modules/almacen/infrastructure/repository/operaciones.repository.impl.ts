import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { IOperacionesRepository } from '../../domain/repositories/ioperaciones.repository';
import { RecepcionAlmacenamientoEntity } from '../../domain/models/recepcion-almacenamiento.entity';
import { AlmacenHttpService } from '../http/almacen-http.service';
import { ALMACEN_ENDPOINTS } from '../http/almacen-api.config';
import { BackendMovimientoListItem } from '../../application/dto/almacen-backend.types';

/**
 * Operaciones de almacén contra `ms-almacen`.
 *
 * `obtenerRecepcionesAlmacenamiento` se deriva de `GET /movimientos` filtrando
 * los ingresos originados en orden de compra (`tipoReferenciaOrigen = OC`).
 * El backend expone ids (no nombres) en la cabecera, por lo que el mapeo es
 * best-effort.
 */
@Injectable({ providedIn: 'root' })
export class OperacionesRepositoryImpl implements IOperacionesRepository {

  private readonly api = inject(AlmacenHttpService);

  obtenerRecepcionesAlmacenamiento(): Observable<RecepcionAlmacenamientoEntity[]> {
    return this.api
      .getList<BackendMovimientoListItem>(ALMACEN_ENDPOINTS.movimientos, {
        tipoReferenciaOrigen: 'OC',
        size: 1000,
        sort: 'fechaMov,desc',
      })
      .pipe(map((rows) => rows.map((r) => this.toRecepcion(r))));
  }

  private toRecepcion(r: BackendMovimientoListItem): RecepcionAlmacenamientoEntity {
    return {
      codigoRecepcion: r.nroVale ?? (r.id != null ? String(r.id) : ''),
      fechaRecepcion: r.fechaMov ?? '',
      ordenCompra: r.ordenCompraId != null ? String(r.ordenCompraId) : '',
      recepcion_almacenamiento_proveedor: '',
      cantidadSolicitada: 0,
      cantidadEntregada: 0,
      diferencia: 0,
      almacenDestino: r.almacenId != null ? String(r.almacenId) : '',
      nroFactura: '',
      nroGuia: '',
      usuario: '',
      recepcion_almacenamiento_estado: r.flagEstado ?? '',
      moneda: '',
    };
  }
}
