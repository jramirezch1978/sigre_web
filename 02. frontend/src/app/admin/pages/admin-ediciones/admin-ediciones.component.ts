import { Component, OnInit, inject } from '@angular/core';
import { AdminSeguridadApiService } from '../../services/admin-seguridad-api.service';
import { EdicionErpDto } from '../../models/admin.models';

interface TemaEdicion {
  c1: string;
  c2: string;
  estrellas: number;
  etiqueta: string;
}

@Component({
  selector: 'app-admin-ediciones',
  templateUrl: './admin-ediciones.component.html',
  styleUrls: ['../admin-page-common.scss', './admin-ediciones.component.scss'],
  standalone: false,
})
export class AdminEdicionesComponent implements OnInit {

  private readonly api = inject(AdminSeguridadApiService);

  /** Logo base de SIGRE (Pegaso) sobre el que se construye cada medalla de edición. */
  readonly logoSigre = 'assets/imagenes/auth/logo-sigre.png';

  ediciones: EdicionErpDto[] = [];
  loading = true;

  /** Tema por edición: aro de color escalado por nivel + estrellas de tier. */
  private readonly temas: Record<string, TemaEdicion> = {
    MYPE:           { c1: '#60a5fa', c2: '#2563eb', estrellas: 1, etiqueta: 'Esencial' },
    SMALL_BUSINESS: { c1: '#34d399', c2: '#059669', estrellas: 2, etiqueta: 'Crecimiento' },
    PROFESSIONAL:   { c1: '#a78bfa', c2: '#7c3aed', estrellas: 3, etiqueta: 'Profesional' },
    ENTERPRISE:     { c1: '#fbbf24', c2: '#d97706', estrellas: 4, etiqueta: 'Corporativo' },
    HORECA:         { c1: '#fdba74', c2: '#ea580c', estrellas: 3, etiqueta: 'Hotelería' },
    HEALTH:         { c1: '#67e8f9', c2: '#0891b2', estrellas: 3, etiqueta: 'Salud' },
  };

  ngOnInit(): void {
    this.api.listarEdiciones().subscribe({
      next: r => {
        this.loading = false;
        this.ediciones = (r.data ?? []).sort((a, b) => (a.orden ?? 0) - (b.orden ?? 0));
      },
      error: () => { this.loading = false; },
    });
  }

  /** Logo PNG generado por edición (basado en el logo SIGRE + color + nombre). */
  private readonly archivos: Record<string, string> = {
    MYPE: 'mype',
    SMALL_BUSINESS: 'small-business',
    PROFESSIONAL: 'professional',
    ENTERPRISE: 'enterprise',
    HORECA: 'horeca',
    HEALTH: 'healthcare',
  };

  iconoEdicion(codigo: string): string {
    const slug = this.archivos[codigo];
    return slug ? `assets/imagenes/ediciones/${slug}.png` : this.logoSigre;
  }

  tema(codigo: string): TemaEdicion {
    return this.temas[codigo] ?? { c1: '#94a3b8', c2: '#475569', estrellas: 0, etiqueta: '' };
  }

  /** [true,true,false,false] => 2 de 4 estrellas llenas. */
  estrellas(n: number): boolean[] {
    return [0, 1, 2, 3].map(i => i < n);
  }
}
