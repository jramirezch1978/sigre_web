import { Injectable } from '@angular/core';
import { Observable, forkJoin, map, of, switchMap } from 'rxjs';
import { IAprobarCompraRepository } from '../../domain/repositories/iaprobar-compra.repository';
import { OrdenCompraEntity } from '../../domain/models/orden-compra.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { OrdenesCompraRepositoryImpl } from '../repositories/ordenes-de-compra.repository.impl';

@Injectable({ providedIn: 'root' })
export class AprobarCompraRepositoryImpl
  extends OrdenesCompraRepositoryImpl
  implements IAprobarCompraRepository
{
  obtenerOrdenesPendientes(): Observable<OrdenCompraEntity[]> {
    return this.obtenerDetallesDesdeRuta('/compras/ordenes-compra/pendientes-aprobacion');
  }

  obtenerTodasLasOrdenes(): Observable<OrdenCompraEntity[]> {
    return this.obtenerOrdenesCompra();
  }

  obtenerPorNumero(numeroOrden: string): Observable<OrdenCompraEntity> {
    return this.resolverOrdenPorIdentificador(numeroOrden).pipe(
      map((orden) => {
        if (!orden) {
          throw new Error(`Orden de compra ${numeroOrden} no encontrada`);
        }
        return orden;
      })
    );
  }

  aprobarOrden(numeroOrden: string, observacion?: string): Observable<ApiResponse<OrdenCompraEntity>> {
    return this.ejecutarAccion(numeroOrden, 'aprobar', observacion?.trim() ? { observacion } : {});
  }

  rechazarOrden(numeroOrden: string, motivo: string): Observable<ApiResponse<OrdenCompraEntity>> {
    return this.ejecutarAccion(numeroOrden, 'rechazar', { motivo });
  }

  retornarOrden(numeroOrden: string, motivo: string): Observable<ApiResponse<OrdenCompraEntity>> {
    return this.ejecutarAccion(numeroOrden, 'devolver', { motivo });
  }

  aprobarOrdenesMasivo(numerosOrden: string[]): Observable<ApiResponse<OrdenCompraEntity[]>> {
    if (!numerosOrden.length) {
      return of({
        success: true,
        message: 'No hay órdenes para aprobar',
        data: [],
      });
    }

    return forkJoin(numerosOrden.map((numeroOrden) => this.aprobarOrden(numeroOrden))).pipe(
      map((resultados) => ({
        success: true,
        message: `${resultados.length} orden(es) aprobada(s) exitosamente`,
        data: resultados
          .map((resultado) => resultado.data)
          .filter((orden): orden is OrdenCompraEntity => !!orden),
      }))
    );
  }

  private ejecutarAccion(
    numeroOrden: string,
    accion: 'aprobar' | 'rechazar' | 'devolver',
    body: Record<string, unknown>
  ): Observable<ApiResponse<OrdenCompraEntity>> {
    return this.obtenerPorNumero(numeroOrden).pipe(
      switchMap((orden) =>
        this.api.post<any>(`/compras/ordenes-compra/${orden['id']}/${accion}`, body).pipe(
          map((response) => ({
            success: true,
            message: `Operación ${accion} ejecutada correctamente`,
            data: this.mapOrdenDetalle(response),
          }))
        )
      )
    );
  }
}
