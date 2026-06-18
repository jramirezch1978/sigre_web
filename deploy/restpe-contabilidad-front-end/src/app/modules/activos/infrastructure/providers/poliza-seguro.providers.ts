import { Provider } from '@angular/core';
import { IPolizaSeguroRepository } from '../../domain/repositories/ipoliza-seguro.repository';
import { ReportesRepositoryImpl } from '../repository/reportes.repository.impl';
import { PolizaSeguroStore } from '../../store/poliza-seguro.store';
import { ObtenerPolizasSeguroUseCase } from '../../application/usecases/obtener-polizas-seguro.usecase';
import { PolizaSeguroFacade } from '../../application/facades/poliza-seguro.facade';

export const POLIZA_SEGURO_PROVIDERS: Provider[] = [
  { provide: IPolizaSeguroRepository, useClass: ReportesRepositoryImpl },
  PolizaSeguroStore,
  ObtenerPolizasSeguroUseCase,
  PolizaSeguroFacade,
];
