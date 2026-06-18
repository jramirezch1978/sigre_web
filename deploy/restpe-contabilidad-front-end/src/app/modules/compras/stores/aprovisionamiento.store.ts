import { Injectable, signal, computed } from '@angular/core';
import { PlanAbastecimientoEntity } from '../domain/models/plan-abastecimiento.entity';
import { AprovisionamientoState, initialAprovisionamientoState } from './aprovisionamiento.state';

/**
 * Store de Aprovisionamiento usando Angular Signals
 * Gestiona el estado reactivo de los planes de abastecimiento
 */
@Injectable()
export class AprovisionamientoStore {
  private readonly state = signal<AprovisionamientoState>(initialAprovisionamientoState);

  // Selectores computados (solo lectura)
  readonly planes = computed(() => this.state().planes);
  readonly planSeleccionado = computed(() => this.state().planSeleccionado);
  readonly loading = computed(() => this.state().loading);
  readonly loadingObtener = computed(() => this.state().loadingObtener);
  readonly loadingGuardar = computed(() => this.state().loadingGuardar);
  readonly loadingActualizar = computed(() => this.state().loadingActualizar);
  readonly loadingEliminar = computed(() => this.state().loadingEliminar);
  readonly error = computed(() => this.state().error);
  readonly errorObtener = computed(() => this.state().errorObtener);
  readonly errorGuardar = computed(() => this.state().errorGuardar);
  readonly errorActualizar = computed(() => this.state().errorActualizar);
  readonly errorEliminar = computed(() => this.state().errorEliminar);

  // ============ Setters para Planes ============
  setPlanes(planes: PlanAbastecimientoEntity[]): void {
    this.state.update((state) => ({ ...state, planes }));
  }

  setPlanSeleccionado(plan: PlanAbastecimientoEntity | null): void {
    this.state.update((state) => ({ ...state, planSeleccionado: plan }));
  }

  agregarPlan(plan: PlanAbastecimientoEntity): void {
    this.state.update((state) => ({
      ...state,
      planes: [...state.planes, plan],
    }));
  }

  actualizarPlanEnStore(planActualizado: PlanAbastecimientoEntity): void {
    this.state.update((state) => ({
      ...state,
      planes: state.planes.map((p) =>
        p.plan_abastecimiento_numero === planActualizado.plan_abastecimiento_numero ? planActualizado : p
      ),
    }));
  }

  eliminarPlanDelStore(numeroPlan: string): void {
    this.state.update((state) => ({
      ...state,
      planes: state.planes.filter((p) => p.plan_abastecimiento_numero !== numeroPlan),
    }));
  }

  // ============ Setters para Loading ============
  setLoading(loading: boolean): void {
    this.state.update((state) => ({ ...state, loading }));
  }

  setLoadingObtener(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingObtener: loading }));
  }

  setLoadingGuardar(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingGuardar: loading }));
  }

  setLoadingActualizar(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingActualizar: loading }));
  }

  setLoadingEliminar(loading: boolean): void {
    this.state.update((state) => ({ ...state, loadingEliminar: loading }));
  }

  // ============ Setters para Errores ============
  setError(error: string | null): void {
    this.state.update((state) => ({ ...state, error }));
  }

  setErrorObtener(error: string | null): void {
    this.state.update((state) => ({ ...state, errorObtener: error }));
  }

  setErrorGuardar(error: string | null): void {
    this.state.update((state) => ({ ...state, errorGuardar: error }));
  }

  setErrorActualizar(error: string | null): void {
    this.state.update((state) => ({ ...state, errorActualizar: error }));
  }

  setErrorEliminar(error: string | null): void {
    this.state.update((state) => ({ ...state, errorEliminar: error }));
  }

  resetState(): void {
    this.state.set(initialAprovisionamientoState);
  }
}
