import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { map, tap } from 'rxjs/operators';
import { OrdenCompraEntity } from '../../domain/models/orden-compra.entity';

@Injectable({ providedIn: 'root' })
export class OrdenCompraMemoryDataSource {
  private readonly http = inject(HttpClient);
  private readonly jsonPath = 'assets/data/compras/operaciones/ordenes-de-compra.json';

  private cache: OrdenCompraEntity[] | null = null;

  obtenerTodas(): Observable<OrdenCompraEntity[]> {
    if (this.cache) {
      return of(this.clonarListado(this.cache));
    }

    return this.http.get<OrdenCompraEntity[]>(this.jsonPath).pipe(
      tap((ordenes) => {
        this.cache = this.clonarListado(ordenes);
      }),
      map((ordenes) => this.clonarListado(ordenes))
    );
  }

  obtenerPorNumero(numeroOrden: string): Observable<OrdenCompraEntity | null> {
    return this.obtenerTodas().pipe(
      map((ordenes) => ordenes.find((orden) => orden.orden_compra_numero === numeroOrden) ?? null)
    );
  }

  guardar(orden: OrdenCompraEntity): Observable<OrdenCompraEntity> {
    return this.obtenerTodas().pipe(
      map((ordenes) => {
        const numeroOrden = orden.orden_compra_numero?.trim()
          ? orden.orden_compra_numero
          : `OC-${new Date().getFullYear()}-${String(this.obtenerSiguienteCorrelativo(ordenes)).padStart(4, '0')}`;

        const nuevaOrden = this.clonarOrden({
          ...orden,
          orden_compra_numero: numeroOrden,
        });

        this.cache = [...ordenes, nuevaOrden];
        return this.clonarOrden(nuevaOrden);
      })
    );
  }

  actualizar(orden: OrdenCompraEntity): Observable<OrdenCompraEntity> {
    return this.obtenerTodas().pipe(
      map((ordenes) => {
        const indice = ordenes.findIndex((item) => item.orden_compra_numero === orden.orden_compra_numero);
        if (indice === -1) {
          throw new Error(`No se encontró la orden ${orden.orden_compra_numero}`);
        }

        const actualizada = this.clonarOrden(orden);
        const siguienteListado = [...ordenes];
        siguienteListado[indice] = actualizada;
        this.cache = siguienteListado;

        return this.clonarOrden(actualizada);
      })
    );
  }

  eliminar(numeroOrden: string): Observable<boolean> {
    return this.obtenerTodas().pipe(
      map((ordenes) => {
        const siguienteListado = ordenes.filter((orden) => orden.orden_compra_numero !== numeroOrden);
        const eliminado = siguienteListado.length !== ordenes.length;
        this.cache = siguienteListado;
        return eliminado;
      })
    );
  }

  private obtenerSiguienteCorrelativo(ordenes: OrdenCompraEntity[]): number {
    if (!ordenes.length) {
      return 1;
    }

    return Math.max(
      ...ordenes.map((orden) => {
        const match = orden.orden_compra_numero?.match(/OC-\d{4}-(\d+)/);
        return match ? Number.parseInt(match[1], 10) : 0;
      })
    ) + 1;
  }

  private clonarListado(ordenes: OrdenCompraEntity[]): OrdenCompraEntity[] {
    return ordenes.map((orden) => this.clonarOrden(orden));
  }

  private clonarOrden(orden: OrdenCompraEntity): OrdenCompraEntity {
    return {
      ...orden,
      orden_compra_articulos: orden.orden_compra_articulos?.map((articulo) => ({ ...articulo })) ?? [],
    };
  }
}
