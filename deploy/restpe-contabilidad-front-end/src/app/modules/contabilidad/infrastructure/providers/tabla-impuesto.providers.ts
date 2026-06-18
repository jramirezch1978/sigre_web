import { Provider } from '@angular/core';
import { ITablaImpuestoRepository } from '../../domain/repositories/itable-impuesto.repository';
import { TablaImpuestoRepositoryImpl } from '../repository/tabla-impuesto.impl';
import { TablaImpuestoStore } from '../../store/tabla-impuesto.store';
import { TablaImpuestoFacade } from '../../application/facades/tabla-impuesto.facade';
import { ObtenerTablaImpuestosUseCase } from '../../application/usecases/obtener-tabla-impuestos.usecase';
import { GuardarTablaImpuestoUseCase } from '../../application/usecases/guardar-tabla-impuesto.usecase';
import { ActualizarTablaImpuestoUseCase } from '../../application/usecases/actualizar-tabla-impuesto.usecase';
import { TablaImpuestoFeedbackEffects } from '../../effects/tabla-impuesto-feedback.effect';
import { TablaImpuestoSyncEffects } from '../../effects/tabla-impuesto-sync.effect';

export const TABLA_IMPUESTO_PROVIDERS: Provider[] = [
  { provide: ITablaImpuestoRepository, useClass: TablaImpuestoRepositoryImpl },
  TablaImpuestoStore,
  TablaImpuestoFacade,
  ObtenerTablaImpuestosUseCase,
  GuardarTablaImpuestoUseCase,
  ActualizarTablaImpuestoUseCase,
  TablaImpuestoFeedbackEffects,
  TablaImpuestoSyncEffects,
];
