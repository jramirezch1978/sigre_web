import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { ISeleccionarCuentaContableRepository } from '../../domain/repositories/iseleccionar-cuenta-contable.repository';
import { SeleccionarCuentaContableEntity } from '../../domain/models/seleccionar-cuenta-contable.entity';

const ENTIDAD_VACIA: SeleccionarCuentaContableEntity = {
  items: [],
};

/**
 * SeleccionarCuentaContableRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso de lectura al catálogo de cuentas contables.
 * El JSON local simula una API REST del catálogo del plan contable.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class SeleccionarCuentaContableRepositoryImpl implements ISeleccionarCuentaContableRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/operaciones/seleccionar-cuenta-contable.json';

  /**
   * Obtiene el catálogo de cuentas contables desde el JSON
   * (simulación de GET /api/contabilidad/catalogo/cuentas-contables).
   */
  obtenerTodos(): Observable<SeleccionarCuentaContableEntity> {
    return this.http.get<SeleccionarCuentaContableEntity>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of(ENTIDAD_VACIA))
    );
  }
}
