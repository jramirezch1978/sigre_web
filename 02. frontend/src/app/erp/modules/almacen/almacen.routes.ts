import { Routes } from '@angular/router';
import { AlmacenTablaKey } from './config/almacen-tablas.config';

const tabla = (key: AlmacenTablaKey, path: string) => ({
  path,
  loadComponent: () =>
    import('./pages/almacen-tabla-page/almacen-tabla-page.component').then(m => m.AlmacenTablaPageComponent),
  data: { tablaKey: key },
});

export const almacenRoutes: Routes = [
  { path: '', redirectTo: 'tablas/almacenes', pathMatch: 'full' },
  tabla('almacenes', 'tablas/almacenes'),
  tabla('tipos-movimiento', 'tablas/tipos-movimiento'),
  tabla('ubicaciones', 'tablas/ubicaciones'),
  tabla('movimientos-almacen', 'tablas/movimientos-almacen'),
  tabla('posiciones', 'tablas/posiciones'),
  tabla('motivos-traslado', 'tablas/motivos-traslado'),
  tabla('lotes', 'tablas/lotes'),
  tabla('unidades-conversion', 'tablas/unidades-conversion'),
  tabla('numeracion-vales', 'tablas/numeracion-vales'),
  tabla('numeracion-otr', 'tablas/numeracion-otr'),
  tabla('parametros', 'tablas/parametros'),
  // Compatibilidad rutas legacy RestPE
  { path: 'tablas/tablas-almacenes', redirectTo: 'tablas/almacenes', pathMatch: 'full' },
  { path: 'tablas/almacenes-movimiento', redirectTo: 'tablas/movimientos-almacen', pathMatch: 'full' },
];
