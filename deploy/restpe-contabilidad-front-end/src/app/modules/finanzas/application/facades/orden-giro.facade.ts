import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';
import { OrdenGiroStore } from '../../store/orden-giro.store';
import { ObtenerOrdenGiroUseCase } from '../usecases/obtener-orden-giro.usecase';
import { GuardarOrdenGiroUseCase } from '../usecases/guardar-orden-giro.usecase';
import { ActualizarOrdenGiroUseCase } from '../usecases/actualizar-orden-giro.usecase';
import { OrdenGiroEntity } from '../../domain/models/orden-giro.entity';
import { IOrdenGiroRepository, OrdenGiroFiltros } from '../../domain/repositories/iorden-giro.repository';

@Injectable()
export class OrdenGiroFacade {
  private readonly store = inject(OrdenGiroStore);
  private readonly obtenerUC = inject(ObtenerOrdenGiroUseCase);
  private readonly guardarUC = inject(GuardarOrdenGiroUseCase);
  private readonly actualizarUC = inject(ActualizarOrdenGiroUseCase);
  private readonly repo = inject(IOrdenGiroRepository);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly ordenes = this.store.ordenes;
  readonly isLoading = this.store.isLoading;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly guardadoOk = this.store.guardadoOk;
  readonly actualizadoOk = this.store.actualizadoOk;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarDatos(filtros?: OrdenGiroFiltros): void {
    this.obtenerUC.execute(filtros);
  }

  /** Anula una solicitud (POST /{id}/anular). Devuelve el observable para recargar al completar. */
  anular(id: number): Observable<boolean> {
    return this.repo.anular(id);
  }

  /** Catálogo de sucursales para el selector. */
  listarSucursales(): Observable<{ id: number; nombre: string }[]> {
    return this.repo.listarSucursales();
  }

  /** Catálogo de centros de costo para el selector. */
  listarCentrosCosto(): Observable<{ id: number; nombre: string }[]> {
    return this.repo.listarCentrosCosto();
  }

  guardar(entity: OrdenGiroEntity, esEdicion: boolean): void {
    this.guardarUC.execute(entity, esEdicion);
  }

  actualizar(entity: OrdenGiroEntity): void {
    this.actualizarUC.execute(entity);
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorGuardar(null);
    this.store.setErrorActualizar(null);
  }

  resetState(): void {
    this.store.reset();
  }
}
