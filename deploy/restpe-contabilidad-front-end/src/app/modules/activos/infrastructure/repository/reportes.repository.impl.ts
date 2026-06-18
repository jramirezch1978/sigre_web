import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, delay, map } from 'rxjs';
import { IPolizaSeguroRepository } from '../../domain/repositories/ipoliza-seguro.repository';
import { PolizaSeguroEntity } from '../../domain/models/poliza-seguro.entity';
import { IRecepcionTrasladoRepository } from '../../domain/repositories/irecepcion-traslado.repository';
import { RecepcionTrasladoEntity } from '../../domain/models/recepcion-traslado.entity';
import { IRegistroTrasladoRepository } from '../../domain/repositories/iregistro-traslado.repository';
import { RegistroTrasladoEntity } from '../../domain/models/registro-traslado.entity';
import { IRevaluacionRepository } from '../../domain/repositories/irevaluacion.repository';
import { RevaluacionEntity } from '../../domain/models/revaluacion.entity';
import { IVentaActivoRepository } from '../../domain/repositories/iventa-activo.repository';
import { VentaActivoEntity } from '../../domain/models/venta-activo.entity';
import { IRegistroOperacionActivoRepository } from '../../domain/repositories/iregistro-operacion-activo.repository';
import { RegistroOperacionActivoEntity } from '../../domain/models/registro-operacion-activo.entity';
import { SimulationService } from '../../../../simulation/simulation.service';

const POLIZA_SEGURO_JSON_PATH      = 'assets/data/activo-fijo/operaciones/polizas-seguro.json';
const RECEPCION_TRASLADO_JSON_PATH = 'assets/data/activo-fijo/operaciones/recepcion-traslados.json';
const REGISTRO_TRASLADO_JSON_PATH  = 'assets/data/activo-fijo/operaciones/registro-traslados.json';
const REGISTRO_TRASLADO_LS_KEY     = 'traslados';
const REVALUACION_JSON_PATH        = 'assets/data/activo-fijo/operaciones/revaluaciones.json';
const VENTA_ACTIVO_JSON_PATH        = 'assets/data/activo-fijo/operaciones/ventas-activos.json';
const REGISTRO_OP_ACTIVO_JSON_PATH   = 'assets/data/activo-fijo/operaciones/registro-operaciones-activo.json';
const REGISTRO_OP_ACTIVO_LS_KEY      = 'registro-operacion-activo';

/**
 * Implementación del repositorio de Pólizas de Seguro.
 * SRP: responsable exclusivamente de obtener el listado de pólizas
 * desde el origen de datos (JSON / API futura).
 */
@Injectable()
export class ReportesRepositoryImpl extends IPolizaSeguroRepository {

  private readonly http = inject(HttpClient);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<PolizaSeguroEntity[]> {
    return this.http
      .get<PolizaSeguroEntity[]>(POLIZA_SEGURO_JSON_PATH)
      .pipe(delay(600));
  }
}

/**
 * Implementación del repositorio de Recepción de Traslados de Activos Fijos.
 * SRP: responsable exclusivamente de obtener el listado de traslados
 * desde el origen de datos (JSON / API futura).
 */
@Injectable()
export class RecepcionTrasladoRepositoryImpl extends IRecepcionTrasladoRepository {

  private readonly http = inject(HttpClient);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<RecepcionTrasladoEntity[]> {
    return this.http
      .get<RecepcionTrasladoEntity[]>(RECEPCION_TRASLADO_JSON_PATH)
      .pipe(delay(600));
  }
}

/**
 * Implementación del repositorio de Registro de Traslados de Activos Fijos.
 * SRP: responsable de obtener el listado de traslados desde JSON (seed)
 * combinado con los registros creados/modificados vía SimulationService.
 */
@Injectable()
export class RegistroTrasladoRepositoryImpl extends IRegistroTrasladoRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<RegistroTrasladoEntity[]> {
    return this.http
      .get<RegistroTrasladoEntity[]>(REGISTRO_TRASLADO_JSON_PATH)
      .pipe(
        delay(600),
        map((jsonItems: RegistroTrasladoEntity[]) => {
          const localItems: RegistroTrasladoEntity[] =
            (this.simulation.list(REGISTRO_TRASLADO_LS_KEY) || [])
              .filter((r: RegistroTrasladoEntity) => !!r.registro_traslado_codigo);

          const codigosLocal = new Set(
            localItems.map((r: RegistroTrasladoEntity) => r.registro_traslado_codigo)
          );
          const soloJson = jsonItems.filter(
            r => !codigosLocal.has(r.registro_traslado_codigo)
          );
          return [...localItems, ...soloJson];
        })
      );
  }
}

/**
 * Implementación del repositorio de Revaluaciones de Activos Fijos.
 * SRP: responsable exclusivamente de obtener el listado de revaluaciones
 * desde el origen de datos (JSON / API futura).
 */
@Injectable()
export class RevaluacionRepositoryImpl extends IRevaluacionRepository {

  private readonly http = inject(HttpClient);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<RevaluacionEntity[]> {
    return this.http
      .get<RevaluacionEntity[]>(REVALUACION_JSON_PATH)
      .pipe(delay(600));
  }
}

/**
 * Implementación del repositorio de Ventas/Bajas de Activos Fijos.
 * SRP: responsable exclusivamente de obtener el listado de ventas/bajas
 * desde el origen de datos (JSON / API futura).
 */
@Injectable()
export class VentaActivoRepositoryImpl extends IVentaActivoRepository {

  private readonly http = inject(HttpClient);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<VentaActivoEntity[]> {
    return this.http
      .get<VentaActivoEntity[]>(VENTA_ACTIVO_JSON_PATH)
      .pipe(delay(600));
  }
}

/**
 * Implementación del repositorio de Registro de Operaciones de Activos Fijos.
 * SRP: responsable de obtener el listado de operaciones desde JSON (seed)
 * combinado con los registros creados/modificados vía SimulationService.
 */
@Injectable()
export class RegistroOperacionActivoRepositoryImpl extends IRegistroOperacionActivoRepository {

  private readonly http       = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ── Lectura ─────────────────────────────────────────────────────────────────

  obtenerTodos(): Observable<RegistroOperacionActivoEntity[]> {
    return this.http
      .get<RegistroOperacionActivoEntity[]>(REGISTRO_OP_ACTIVO_JSON_PATH)
      .pipe(
        delay(600),
        map((jsonItems: RegistroOperacionActivoEntity[]) => {
          const localItems: RegistroOperacionActivoEntity[] =
            (this.simulation.list(REGISTRO_OP_ACTIVO_LS_KEY) || [])
              .filter((r: RegistroOperacionActivoEntity) => !!r.registro_op_codigo);

          const codigosLocal = new Set(
            localItems.map((r: RegistroOperacionActivoEntity) => r.registro_op_codigo)
          );
          const soloJson = jsonItems.filter(
            r => !codigosLocal.has(r.registro_op_codigo)
          );
          return [...localItems, ...soloJson];
        })
      );
  }
}
