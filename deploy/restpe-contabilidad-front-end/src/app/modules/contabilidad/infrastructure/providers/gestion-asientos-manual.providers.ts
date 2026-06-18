import { Provider } from '@angular/core';
import { IGestionAsientosManualesRepository } from '../../domain/repositories/igestion-asientos-manuales.repository';
import { GestionAsientosManualesRepositoryImpl } from '../repository/gestion-asientos-manual.impl';
import { ISeleccionarCuentaContableRepository } from '../../domain/repositories/iseleccionar-cuenta-contable.repository';
import { SeleccionarCuentaContableRepositoryImpl } from '../repository/seleccionar-cuenta-contable.impl';
import { GestionAsientosManualesStore } from '../../store/gestion-asientos-manuales.store';
import { SeleccionarCuentaContableStore } from '../../store/seleccionar-cuenta-contable.store';
import { GestionAsientosManualesFacade } from '../../application/facades/gestion-asientos-manuales.facade';
import { SeleccionarCuentaContableFacade } from '../../application/facades/seleccionar-cuenta-contable.facade';
import { ObtenerGestionAsientosManualesUseCase } from '../../application/usecases/obtener-gestion-asientos-manuales.usecase';
import { GuardarAsientoManualUseCase } from '../../application/usecases/guardar-asiento-manual.usecase';
import { ActualizarAsientoManualUseCase } from '../../application/usecases/actualizar-asiento-manual.usecase';
import { AnularAsientoManualUseCase } from '../../application/usecases/anular-asiento-manual.usecase';
import { ObtenerSeleccionarCuentaContableUseCase } from '../../application/usecases/obtener-seleccionar-cuenta-contable.usecase';
import { GestionAsientosManualesFeedbackEffects } from '../../effects/gestion-asientos-manuales-feedback.effect';
import { GestionAsientosManualesSyncEffects } from '../../effects/gestion-asientos-manuales-sync.effect';
import { SeleccionarCuentaContableFeedbackEffects } from '../../effects/seleccionar-cuenta-contable-feedback.effect';

export const GESTION_ASIENTOS_MANUAL_PROVIDERS: Provider[] = [
  { provide: IGestionAsientosManualesRepository, useClass: GestionAsientosManualesRepositoryImpl },
  { provide: ISeleccionarCuentaContableRepository, useClass: SeleccionarCuentaContableRepositoryImpl },
  GestionAsientosManualesStore,
  SeleccionarCuentaContableStore,
  GestionAsientosManualesFacade,
  SeleccionarCuentaContableFacade,
  ObtenerGestionAsientosManualesUseCase,
  GuardarAsientoManualUseCase,
  ActualizarAsientoManualUseCase,
  AnularAsientoManualUseCase,
  ObtenerSeleccionarCuentaContableUseCase,
  GestionAsientosManualesFeedbackEffects,
  GestionAsientosManualesSyncEffects,
  SeleccionarCuentaContableFeedbackEffects,
];

