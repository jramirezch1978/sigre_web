import { Provider } from '@angular/core';
import { IProveedorActivoRepository } from '../../domain/repositories/iproveedor-activo.repository';
import { ProveedorActivoRepositoryImpl } from '../repository/proveedor-activo.repository.impl';
import { ProveedorActivoStore } from '../../store/proveedor-activo.store';
import { ProveedorActivoFacade } from '../../application/facades/proveedor-activo.facade';
import { ObtenerProveedoresActivoUseCase } from '../../application/usecases/obtener-proveedores-activo.usecase';

export const PROVEEDOR_ACTIVO_PROVIDERS: Provider[] = [
  { provide: IProveedorActivoRepository, useClass: ProveedorActivoRepositoryImpl },
  ProveedorActivoStore,
  ObtenerProveedoresActivoUseCase,
  ProveedorActivoFacade,
];
