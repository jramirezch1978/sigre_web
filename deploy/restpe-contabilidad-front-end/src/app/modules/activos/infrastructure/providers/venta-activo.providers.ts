import { Provider } from '@angular/core';
import { IVentaActivoRepository } from '../../domain/repositories/iventa-activo.repository';
import { VentaActivoRepositoryImpl } from '../repository/reportes.repository.impl';
import { VentaActivoStore } from '../../store/venta-activo.store';
import { ObtenerVentasActivosUseCase } from '../../application/usecases/obtener-ventas-activos.usecase';
import { VentaActivoFacade } from '../../application/facades/venta-activo.facade';

export const VENTA_ACTIVO_PROVIDERS: Provider[] = [
  { provide: IVentaActivoRepository, useClass: VentaActivoRepositoryImpl },
  VentaActivoStore,
  ObtenerVentasActivosUseCase,
  VentaActivoFacade,
];
