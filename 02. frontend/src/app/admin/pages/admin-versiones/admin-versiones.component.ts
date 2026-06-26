import { Component, OnInit, inject } from '@angular/core';
import { VersionService, VersionInfo } from '../../../services/version.service';

interface ComponenteSistema {
  nombre: string;
  detalle: string;
  icono: string;
}

@Component({
  selector: 'app-admin-versiones',
  templateUrl: './admin-versiones.component.html',
  styleUrls: ['../admin-page-common.scss', './admin-versiones.component.scss'],
  standalone: false,
})
export class AdminVersionesComponent implements OnInit {

  private readonly versionService = inject(VersionService);

  info: VersionInfo | null = null;
  cargando = true;

  readonly componentes: ComponenteSistema[] = [
    { nombre: 'ERP', detalle: 'Aplicación principal de gestión empresarial', icono: 'grid_view' },
    { nombre: 'Consola de administración', detalle: 'Seguridad, usuarios y empresas', icono: 'admin_panel_settings' },
    { nombre: 'Asistencia', detalle: 'Control de asistencia y comedor', icono: 'schedule' },
  ];

  ngOnInit(): void {
    this.versionService.getVersionInfo().subscribe({
      next: info => { this.info = info; this.cargando = false; },
      error: () => { this.cargando = false; },
    });
  }

  get fechaBuild(): string {
    if (!this.info) return '—';
    return this.info.buildDate.toLocaleString('es-PE', {
      day: '2-digit', month: '2-digit', year: 'numeric',
      hour: '2-digit', minute: '2-digit',
    });
  }
}
