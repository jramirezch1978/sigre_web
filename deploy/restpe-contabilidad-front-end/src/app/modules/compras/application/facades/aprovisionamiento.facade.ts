import { Injectable, inject } from '@angular/core';
import { PlanAbastecimientoEntity } from '../../domain/models/plan-abastecimiento.entity';
import { AprovisionamientoStore } from '../../stores/aprovisionamiento.store';
import { ObtenerPlanesAbastecimientoUseCase } from '../use-cases/aprovisionamiento/obtener-planes-abastecimiento.usecase';
import { GuardarPlanAbastecimientoUseCase } from '../use-cases/aprovisionamiento/guardar-plan-abastecimiento.usecase';
import { ActualizarPlanAbastecimientoUseCase } from '../use-cases/aprovisionamiento/actualizar-plan-abastecimiento.usecase';
import { EliminarPlanAbastecimientoUseCase } from '../use-cases/aprovisionamiento/eliminar-plan-abastecimiento.usecase';

/**
 * Facade de Aprovisionamiento
 * Proporciona una interfaz simplificada para interactuar con el sistema de planes de abastecimiento
 * Oculta la complejidad de los use cases y el store
 */
@Injectable()
export class AprovisionamientoFacade {
  private readonly store = inject(AprovisionamientoStore);
  private readonly obtenerPlanesUseCase = inject(ObtenerPlanesAbastecimientoUseCase);
  private readonly guardarPlanUseCase = inject(GuardarPlanAbastecimientoUseCase);
  private readonly actualizarPlanUseCase = inject(ActualizarPlanAbastecimientoUseCase);
  private readonly eliminarPlanUseCase = inject(EliminarPlanAbastecimientoUseCase);

  // ============ Selectores del Store (Reactivos) ============
  readonly planes = this.store.planes;
  readonly planSeleccionado = this.store.planSeleccionado;
  readonly loading = this.store.loading;
  readonly loadingObtener = this.store.loadingObtener;
  readonly loadingGuardar = this.store.loadingGuardar;
  readonly loadingActualizar = this.store.loadingActualizar;
  readonly loadingEliminar = this.store.loadingEliminar;
  readonly error = this.store.error;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly errorEliminar = this.store.errorEliminar;

  // ============ Métodos Públicos ============

  /**
   * Carga todos los planes de abastecimiento desde el repositorio
   */
  cargarPlanes(): void {
    this.obtenerPlanesUseCase.execute().subscribe();
  }

  /**
   * Guarda un nuevo plan de abastecimiento
   */
  guardarPlan(plan: PlanAbastecimientoEntity): void {
    this.guardarPlanUseCase.execute(plan).subscribe();
  }

  /**
   * Actualiza un plan de abastecimiento existente
   */
  actualizarPlan(plan: PlanAbastecimientoEntity): void {
    this.actualizarPlanUseCase.execute(plan).subscribe();
  }

  /**
   * Elimina un plan de abastecimiento por su número
   */
  eliminarPlan(numeroPlan: string): void {
    this.eliminarPlanUseCase.execute(numeroPlan).subscribe();
  }

  /**
   * Selecciona un plan para trabajar con él
   */
  seleccionarPlan(plan: PlanAbastecimientoEntity | null): void {
    this.store.setPlanSeleccionado(plan);
  }

  /**
   * Resetea el estado del store
   */
  resetearEstado(): void {
    this.store.resetState();
  }
}
