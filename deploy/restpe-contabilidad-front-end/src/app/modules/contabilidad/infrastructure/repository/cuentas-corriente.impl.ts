import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, catchError, of } from 'rxjs';
import { ICuentasCorrienteRepository } from '../../domain/repositories/icuentas-corriente.repository';
import { CuentasCorrienteEntity } from '../../domain/models/cuentas-corriente.entity';

const REPORTE_VACIO: CuentasCorrienteEntity = {
  items: [],
};

/**
 * CuentasCorrienteRepositoryImpl — Capa de Infraestructura.
 * Responsabilidad única: acceso de lectura al JSON de cuentas corriente.
 * El JSON local simula una API REST de consulta.
 * Cumple con el principio de responsabilidad única (SRP).
 */
@Injectable()
export class CuentasCorrienteRepositoryImpl implements ICuentasCorrienteRepository {

  private readonly http = inject(HttpClient);
  private readonly JSON_PATH = 'assets/data/contabilidad/consultas/cuentas-corriente.json';

  /**
   * Obtiene los movimientos de cuentas corriente desde el JSON
   * (simulación de GET /api/contabilidad/consultas/cuentas-corriente).
   */
  obtenerTodos(): Observable<CuentasCorrienteEntity> {
    return this.http.get<CuentasCorrienteEntity>(this.JSON_PATH).pipe(
      delay(300),
      catchError(() => of(REPORTE_VACIO))
    );
  }
}
