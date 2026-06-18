import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of, delay, map } from 'rxjs';
import { IMatrizContableRepository } from '../../domain/repositories/imatriz-contable.repository';
import { MatrizContableEntity } from '../../domain/models/matriz-contable.entity';
import { ApiResponse } from '../../../../shared/models/api-response.model';
import { SimulationService } from '../../../../simulation/simulation.service';
import { BackendMatrizContable } from '@modules/activos/application/dto/activos-backend.types';

const MATRIZ_CONTABLE_JSON_PATH =
  'assets/data/activo-fijo/tabla/matriz-contable.json';
const MATRIZ_CONTABLE_LS_KEY = 'matrizContable';

interface ApiResponseBack<T> {
  success: boolean;
  data?: T;
  message?: string;
}

interface PaginatedResponse<T> {
  content: T[];
  page: {
    size: number;
    totalElements: number;
    totalPages: number;
    number: number;
  };
}

/**
 * Implementación del repositorio de Matriz Contable.
 * SRP: únicamente acceso y persistencia de la matriz contable.
 *
 * Estrategia de datos:
 * - Lectura: combina JSON seed (assets) + registros del usuario (localStorage).
 * - Escritura: persiste en localStorage via SimulationService.
 */
@Injectable()
export class MatrizContableRepositoryImpl extends IMatrizContableRepository {
  private readonly http = inject(HttpClient);
  private readonly simulation = inject(SimulationService);

  // ─────────────────────────────────────────────
  // Lectura
  // ─────────────────────────────────────────────

  obtenerTodos(): Observable<MatrizContableEntity[]> {
    return this.http
      .get<
        ApiResponseBack<PaginatedResponse<BackendMatrizContable>>
      >('/api/contabilidad/matriz-contable', { params: { page: '0', size: '1000' } })
      .pipe(
        map(
          (
            response: ApiResponseBack<PaginatedResponse<BackendMatrizContable>>,
          ) => {
            if (response.success && response.data) {
              return response.data.content.map(this.toDomainEntity);
            }
            throw new Error(
              response.message || 'Error al cargar matriz contable',
            );
          },
        ),
      );
  }

  obtenerPorCodigo(codigo: string): Observable<MatrizContableEntity> {
    return this.http
      .get<MatrizContableEntity[]>(MATRIZ_CONTABLE_JSON_PATH)
      .pipe(
        delay(200),
        map((jsonItems: MatrizContableEntity[]) => {
          const localItems: MatrizContableEntity[] =
            this.simulation.list(MATRIZ_CONTABLE_LS_KEY) || [];
          const todos = [...localItems, ...jsonItems];
          const encontrado = todos.find(
            (a) => a.matriz_contable_codigo === codigo,
          );
          if (!encontrado)
            throw new Error(`Configuración con código ${codigo} no encontrada`);
          return encontrado;
        }),
      );
  }

  // ─────────────────────────────────────────────
  // Escritura
  // ─────────────────────────────────────────────

  guardar(matriz: MatrizContableEntity): Observable<ApiResponse> {
    this.simulation.save(MATRIZ_CONTABLE_LS_KEY, matriz);
    return of({
      success: true,
      message: 'Configuración contable guardada correctamente',
      data: matriz,
    }).pipe(delay(400));
  }

  actualizar(matriz: MatrizContableEntity): Observable<ApiResponse> {
    const todos: MatrizContableEntity[] =
      this.simulation.list(MATRIZ_CONTABLE_LS_KEY) || [];
    const idx = todos.findIndex(
      (a) => a.matriz_contable_codigo === matriz.matriz_contable_codigo,
    );

    if (idx !== -1) {
      todos[idx] = matriz;
      this.simulation.replace(MATRIZ_CONTABLE_LS_KEY, todos);
    } else {
      // Viene del JSON — persiste como nuevo registro en localStorage
      this.simulation.save(MATRIZ_CONTABLE_LS_KEY, matriz);
    }

    return of({
      success: true,
      message: 'Configuración contable actualizada correctamente',
      data: matriz,
    }).pipe(delay(400));
  }

  eliminar(codigo: string): Observable<ApiResponse> {
    const todos: MatrizContableEntity[] =
      this.simulation.list(MATRIZ_CONTABLE_LS_KEY) || [];
    const filtrado = todos.filter((a) => a.matriz_contable_codigo !== codigo);
    this.simulation.replace(MATRIZ_CONTABLE_LS_KEY, filtrado);
    return of({
      success: true,
      message: 'Configuración contable eliminada correctamente',
      data: true,
    }).pipe(delay(300));
  }

  toDomainEntity(matriz: BackendMatrizContable): MatrizContableEntity {
    return {
      id: matriz.id ? matriz.id : undefined,
      matriz_contable_codigo: matriz.codigo,
      matriz_contable_descripcion: matriz.descripcion,
      matriz_contable_estado: matriz.flagEstado,
      matriz_contable_grupo_id: matriz.grupoMatrizCntblId,
      matriz_contable_created_by: matriz.createdBy,
      matriz_contable_fecha_creacion: matriz.fecCreacion,
      matriz_contable_updated_by: matriz.updatedBy,
      matriz_contable_fec_modificacion: matriz.fecModificacion,
      matriz_contable_detalles: matriz.detalles,

      // Propiedades del formulario Frontend que no existen en Backend
      matriz_contable_cta_activo: '',
      matriz_contable_nombre: '',
      matriz_contable_cta_depreciacion: '',
      matriz_contable_cta_gasto: '',
      matriz_contable_centro_costo: '',
    };
  }

  /**
   * Transforma el modelo de Dominio (Frontend) al formato que espera el Backend
   */
  toBackendEntity(matriz: MatrizContableEntity): BackendMatrizContable {
    return {
      id: matriz.id ? Number(matriz.id) : 0,
      grupoMatrizCntblId: matriz.matriz_contable_grupo_id || 0,
      codigo: matriz.matriz_contable_codigo,
      descripcion: matriz.matriz_contable_descripcion || '',
      flagEstado: matriz.matriz_contable_estado,
      createdBy: matriz.matriz_contable_created_by || 0,
      fecCreacion:
        matriz.matriz_contable_fecha_creacion || new Date().toISOString(),
      updatedBy: matriz.matriz_contable_updated_by || 0,
      fecModificacion: matriz.matriz_contable_fec_modificacion,
      detalles: matriz.matriz_contable_detalles || [],
    };
  }
}
