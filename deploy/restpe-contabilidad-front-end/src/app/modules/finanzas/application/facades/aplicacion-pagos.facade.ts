import { Injectable, inject } from '@angular/core';
import { AplicacionPagosStore } from '../../store/aplicacion-pagos.store';
import { ObtenerAplicacionPagosUseCase } from '../usecases/obtener-aplicacion-pagos.usecase';
import { GuardarAplicacionPagosUseCase } from '../usecases/guardar-aplicacion-pagos.usecase';
import { ActualizarAplicacionPagosUseCase } from '../usecases/actualizar-aplicacion-pagos.usecase';
import { ObtenerAplicacionPagosPlanillaUseCase } from '../usecases/obtener-aplicacion-pagos-planilla.usecase';
import { ObtenerAplicacionPagosTrabajadoresUseCase } from '../usecases/obtener-aplicacion-pagos-trabajadores.usecase';
import { AplicacionPagosEntity } from '../../domain/models/aplicacion-pagos.entity';
import { Observable } from 'rxjs';
import { IAplicacionPagosRepository, OpcionPago, PagoConsolidado } from '../../domain/repositories/iaplicacion-pagos.repository';

@Injectable()
export class AplicacionPagosFacade {
  private readonly store = inject(AplicacionPagosStore);
  private readonly obtenerUC = inject(ObtenerAplicacionPagosUseCase);
  private readonly guardarUC = inject(GuardarAplicacionPagosUseCase);
  private readonly actualizarUC = inject(ActualizarAplicacionPagosUseCase);
  private readonly obtenerPlanillaUC = inject(ObtenerAplicacionPagosPlanillaUseCase);
  private readonly obtenerTrabajadoresUC = inject(ObtenerAplicacionPagosTrabajadoresUseCase);
  private readonly repo = inject(IAplicacionPagosRepository);

  // ── Selectores públicos ──────────────────────────────────────────────────
  readonly registros = this.store.registros;
  readonly planillas = this.store.planillas;
  readonly trabajadores = this.store.trabajadores;
  readonly isLoading = this.store.isLoading;
  readonly loadingPlanillas = this.store.loadingPlanillas;
  readonly loadingTrabajadores = this.store.loadingTrabajadores;
  readonly errorObtener = this.store.errorObtener;
  readonly errorGuardar = this.store.errorGuardar;
  readonly errorActualizar = this.store.errorActualizar;
  readonly errorPlanillas = this.store.errorPlanillas;
  readonly errorTrabajadores = this.store.errorTrabajadores;
  readonly guardadoOk = this.store.guardadoOk;
  readonly actualizadoOk = this.store.actualizadoOk;

  // ── Acciones ─────────────────────────────────────────────────────────────
  cargarDatos(): void {
    this.obtenerUC.execute();
  }

  cargarPlanillas(): void {
    this.obtenerPlanillaUC.execute();
  }

  cargarTrabajadores(): void {
    this.obtenerTrabajadoresUC.execute();
  }

  guardar(entity: AplicacionPagosEntity): void {
    this.guardarUC.execute(entity);
  }

  actualizar(entity: AplicacionPagosEntity): void {
    this.actualizarUC.execute(entity);
  }

  limpiarErrores(): void {
    this.store.setErrorObtener(null);
    this.store.setErrorGuardar(null);
    this.store.setErrorActualizar(null);
    this.store.setErrorPlanillas(null);
    this.store.setErrorTrabajadores(null);
  }

  resetState(): void {
    this.store.reset();
  }

  // ── Cartera de pagos (HU-23) ───────────────────────────────────────────────
  pagarDocumentos(pago: PagoConsolidado): Observable<number> {
    return this.repo.pagarDocumentos(pago);
  }
  ejecutarPago(id: number): Observable<boolean> {
    return this.repo.ejecutar(id);
  }
  anularPago(id: number): Observable<boolean> {
    return this.repo.anular(id);
  }
  listarBancos(): Observable<OpcionPago[]> {
    return this.repo.listarBancos();
  }
  listarConceptos(): Observable<OpcionPago[]> {
    return this.repo.listarConceptos();
  }
}
