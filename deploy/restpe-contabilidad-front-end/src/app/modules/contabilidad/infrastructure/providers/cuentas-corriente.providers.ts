import { Provider } from '@angular/core';
import { ICuentasCorrienteRepository } from '../../domain/repositories/icuentas-corriente.repository';
import { CuentasCorrienteRepositoryImpl } from '../repository/cuentas-corriente.impl';
import { CuentasCorrienteStore } from '../../store/cuentas-corriente.store';
import { CuentasCorrienteFacade } from '../../application/facades/cuentas-corriente.facade';
import { ObtenerCuentasCorrienteUseCase } from '../../application/usecases/obtener-cuentas-corriente.usecase';
import { CuentasCorrienteFeedbackEffects } from '../../effects/cuentas-corriente-feedback.effect';

export const CUENTAS_CORRIENTE_PROVIDERS: Provider[] = [
  { provide: ICuentasCorrienteRepository, useClass: CuentasCorrienteRepositoryImpl },
  CuentasCorrienteStore,
  CuentasCorrienteFacade,
  ObtenerCuentasCorrienteUseCase,
  CuentasCorrienteFeedbackEffects,
];
