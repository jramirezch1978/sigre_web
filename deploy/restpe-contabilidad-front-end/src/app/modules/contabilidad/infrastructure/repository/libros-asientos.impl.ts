import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { ILibrosAsientosRepository } from '../../domain/repositories/ilibros-asientos.repository';
import { LibroMayorEntity, LibroDiarioEntity, BalanceComprobEntity } from '../../domain/models/libros-asientos.entity';

/**
 * LibrosAsientosRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso de lectura a los JSONs de libros y asientos.
 * Cada tipo de reporte tiene su propio JSON independiente.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class LibrosAsientosRepositoryImpl implements ILibrosAsientosRepository {

  private readonly http = inject(HttpClient);
  private readonly BASE_PATH = 'assets/data/contabilidad/reporte/libros-contables';

  obtenerLibroMayor(): Observable<LibroMayorEntity> {
    return this.http.get<LibroMayorEntity>(`${this.BASE_PATH}/libro-mayor.json`).pipe(
      delay(300),
      catchError(() => of([]))
    );
  }

  obtenerLibroDiario(): Observable<LibroDiarioEntity> {
    return this.http.get<LibroDiarioEntity>(`${this.BASE_PATH}/libro-diario.json`).pipe(
      delay(300),
      catchError(() => of([]))
    );
  }

  obtenerBalanceComprobacion(): Observable<BalanceComprobEntity> {
    return this.http.get<BalanceComprobEntity>(`${this.BASE_PATH}/balance-comprobacion.json`).pipe(
      delay(300),
      catchError(() => of([]))
    );
  }
}
