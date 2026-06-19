import { Injectable, inject } from '@angular/core';
import { Observable, of } from 'rxjs';
import { TablaCrudConfig } from '../config/almacen-tabla-crud.config';
import { VistaCrudConfig } from '../config/almacen-vista-crud.config';
import { AlmacenApiService } from './almacen-api.service';
import { CoreApiService } from './core-api.service';

export type CrudConfig = TablaCrudConfig | VistaCrudConfig;

@Injectable({ providedIn: 'root' })
export class AlmacenCrudService {
  private readonly almacenApi = inject(AlmacenApiService);
  private readonly coreApi = inject(CoreApiService);

  guardar(config: CrudConfig, registro: Record<string, unknown> | null, body: Record<string, unknown>): Observable<unknown> {
    const id = Number(registro?.['id'] ?? 0);
    const handler = config.handler ?? 'standard';

    switch (handler) {
      case 'ubicacion':
        return id
          ? this.almacenApi.actualizarUbicacion(id, body)
          : this.almacenApi.crearUbicacion(Number(body['almacenId']), body);
      case 'tipo-mov-asignacion':
        return this.almacenApi.asignarTipoMovimiento(
          Number(body['almacenId']),
          Number(body['articuloMovTipoId'])
        );
      case 'conversion-unidad':
        return id
          ? this.coreApi.actualizarConversionUnidad(id, body)
          : this.coreApi.crearConversionUnidad(body);
      case 'numerador-doc':
        return this.coreApi.guardarNumeradorDocumento({
          nombreTabla: String(config.nombreTablaDocumento ?? registro?.['nombreTabla'] ?? ''),
          sucursalId: Number(body['sucursalId'] ?? registro?.['sucursalId']),
          ano: Number(body['ano'] ?? registro?.['ano']),
          ultNro: Number(body['ultNro']),
        });
      case 'parametro':
        return this.coreApi.guardarParametroEmpresa(String(registro?.['clave'] ?? body['clave']), body['valor']);
      case 'movimiento':
        return id
          ? this.almacenApi.actualizarMovimiento(id, this.bodyMovimiento(body, config as VistaCrudConfig))
          : this.almacenApi.crearMovimiento(this.bodyMovimiento(body, config as VistaCrudConfig));
      case 'otr':
        return id
          ? this.almacenApi.actualizarOrdenTraslado(id, this.bodyOtr(body))
          : this.almacenApi.crearOrdenTraslado(this.bodyOtr(body));
      case 'inventario':
        return id
          ? this.almacenApi.actualizarTomaInventario(id, this.bodyInventario(body))
          : this.almacenApi.crearTomaInventario(this.bodyInventario(body));
      default:
        if (config.apiSource === 'core') {
          return id
            ? this.coreApi.actualizarRegistroCore(config.basePath, id, body)
            : this.coreApi.crearRegistroCore(config.basePath, body);
        }
        return id
          ? this.almacenApi.actualizarRegistro(config.basePath, id, body)
          : this.almacenApi.crearRegistro(config.basePath, body);
    }
  }

  anular(config: CrudConfig, registro: Record<string, unknown>): Observable<unknown> {
    const handler = config.handler ?? 'standard';
    const id = Number(registro['id']);

    switch (handler) {
      case 'numerador-doc':
        return this.coreApi.desactivarNumeradorDocumento(
          String(registro['nombreTabla'] ?? config.nombreTablaDocumento),
          Number(registro['sucursalId']),
          Number(registro['ano'])
        );
      case 'movimiento':
        return this.almacenApi.anularMovimiento(id);
      case 'otr':
        return this.almacenApi.anularOrdenTraslado(id);
      case 'inventario':
        return this.almacenApi.anularTomaInventario(id);
      case 'tipo-mov-asignacion':
        return this.almacenApi.desasignarTipoMovimiento(
          Number(registro['almacenId']),
          Number(registro['articuloMovTipoId'])
        );
      case 'conversion-unidad':
        return this.coreApi.desactivarConversionUnidad(id);
      default:
        if (config.apiSource === 'core') {
          return id ? this.coreApi.desactivarRegistroCore(config.basePath, id) : of(null);
        }
        return this.almacenApi.desactivarRegistro(config.basePath, id);
    }
  }

  eliminar(config: CrudConfig, registro: Record<string, unknown>): Observable<unknown> {
    const handler = config.handler ?? 'standard';
    const id = Number(registro['id']);

    switch (handler) {
      case 'ubicacion':
        return this.almacenApi.eliminarUbicacion(id);
      case 'tipo-mov-asignacion':
        return this.almacenApi.desasignarTipoMovimiento(
          Number(registro['almacenId']),
          Number(registro['articuloMovTipoId'])
        );
      case 'conversion-unidad':
        return this.coreApi.eliminarConversionUnidad(id);
      case 'movimiento':
        return this.almacenApi.anularMovimiento(id);
      case 'otr':
        return this.almacenApi.anularOrdenTraslado(id);
      default:
        if (config.apiSource === 'core') {
          return this.coreApi.eliminarRegistroCore(config.basePath, id);
        }
        return this.almacenApi.eliminarRegistro(config.basePath, id);
    }
  }

  permiteAnular(config: CrudConfig): boolean {
    if (config.permiteAnular === false) return false;
    return true;
  }

  permiteEliminar(config: CrudConfig): boolean {
    if (config.permiteEliminar === false) return false;
    const handler = config.handler ?? 'standard';
    return handler !== 'numerador-doc' && handler !== 'parametro';
  }

  private bodyMovimiento(body: Record<string, unknown>, config: VistaCrudConfig): Record<string, unknown> {
    const cantidad = Number(body['cantProcesada'] ?? 1);
    return {
      sucursalId: body['sucursalId'],
      almacenId: body['almacenId'],
      articuloMovTipoId: body['articuloMovTipoId'],
      fechaMov: body['fechaMov'],
      observaciones: body['observaciones'] ?? null,
      tipoReferenciaOrigen: config.movimientoDefaults?.['tipoReferenciaOrigen'] ?? null,
      lineas: [{ articuloId: body['articuloId'], cantProcesada: cantidad }],
    };
  }

  private bodyOtr(body: Record<string, unknown>): Record<string, unknown> {
    return {
      almacenOrigenId: body['almacenOrigenId'],
      almacenDestinoId: body['almacenDestinoId'],
      fecha: body['fecha'],
      observacion: body['observacion'] ?? null,
      lineas: [{ articuloId: body['articuloId'], cantidad: body['cantidad'] }],
    };
  }

  private bodyInventario(body: Record<string, unknown>): Record<string, unknown> {
    return {
      almacenId: body['almacenId'],
      articuloId: body['articuloId'],
      fechaConteo: body['fechaConteo'],
      saldoSistema: body['saldoSistema'] ?? null,
      cantidadConteo1: body['cantidadConteo1'],
    };
  }
}
