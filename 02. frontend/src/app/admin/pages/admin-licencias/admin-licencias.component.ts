import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { SigreModalService } from '@sigre-common';
import { StorageService } from '../../../core/services/storage.service';
import { LoginData } from '../../../auth/services/auth.service';
import { AdminLicenciasService, LicenciaAdminDto } from '../../services/admin-licencias.service';

@Component({
  selector: 'app-admin-licencias',
  templateUrl: './admin-licencias.component.html',
  styleUrls: ['./admin-licencias.component.scss'],
  standalone: false,
})
export class AdminLicenciasComponent implements OnInit {

  private readonly api = inject(AdminLicenciasService);
  private readonly fb = inject(FormBuilder);
  private readonly modal = inject(SigreModalService);
  private readonly storage = inject(StorageService);

  licencias: LicenciaAdminDto[] = [];
  cargando = true;
  guardando = false;
  filtro = '';
  tipoSales: string | null = null;

  mostrarRenovar = false;
  mostrarAmpliar = false;
  seleccion: LicenciaAdminDto | null = null;

  readonly formRenovar: FormGroup = this.fb.group({
    fechaPago: [this.hoy(), Validators.required],
    voucher: ['', [Validators.required, Validators.maxLength(80)]],
  });
  readonly formAmpliar: FormGroup = this.fb.group({
    nuevaFecha: ['', Validators.required],
  });

  get esLicensing(): boolean {
    return this.tipoSales === 'LICENSING';
  }

  ngOnInit(): void {
    this.tipoSales = this.storage.getUser<LoginData>()?.tipoSales ?? null;
    this.cargar();
  }

  get licenciasFiltradas(): LicenciaAdminDto[] {
    const q = this.filtro.trim().toLowerCase();
    if (!q) {
      return this.licencias;
    }
    return this.licencias.filter(l =>
      `${l.razon_social} ${l.codigo_licencia} ${l.edicion_codigo}`.toLowerCase().includes(q));
  }

  cargar(): void {
    this.cargando = true;
    this.api.listar().subscribe({
      next: r => { this.licencias = r.data ?? []; this.cargando = false; },
      error: () => { this.cargando = false; void this.modal.error('No se pudieron cargar las licencias.'); },
    });
  }

  // ── Renovar (LICENSING o SALES) ──
  abrirRenovar(l: LicenciaAdminDto): void {
    this.seleccion = l;
    this.formRenovar.reset({ fechaPago: this.hoy(), voucher: '' });
    this.mostrarRenovar = true;
  }
  cerrarRenovar(): void { this.mostrarRenovar = false; this.seleccion = null; }

  confirmarRenovar(): void {
    if (this.formRenovar.invalid || !this.seleccion) { this.formRenovar.markAllAsTouched(); return; }
    this.guardando = true;
    const { fechaPago, voucher } = this.formRenovar.value;
    this.api.renovar(this.seleccion.empresa_id, fechaPago, voucher).subscribe({
      next: () => {
        this.guardando = false;
        this.cerrarRenovar();
        void this.modal.success('Licencia renovada', 'La renovación se registró correctamente.');
        this.cargar();
      },
      error: e => { this.guardando = false; void this.modal.error(e?.error?.message ?? 'No se pudo renovar.'); },
    });
  }

  // ── Ampliar demo (solo LICENSING) ──
  abrirAmpliar(l: LicenciaAdminDto): void {
    this.seleccion = l;
    this.formAmpliar.reset({ nuevaFecha: '' });
    this.mostrarAmpliar = true;
  }
  cerrarAmpliar(): void { this.mostrarAmpliar = false; this.seleccion = null; }

  confirmarAmpliar(): void {
    if (this.formAmpliar.invalid || !this.seleccion) { this.formAmpliar.markAllAsTouched(); return; }
    this.guardando = true;
    const iso = new Date(this.formAmpliar.value.nuevaFecha).toISOString();
    this.api.ampliarDemo(this.seleccion.empresa_id, iso).subscribe({
      next: () => {
        this.guardando = false;
        this.cerrarAmpliar();
        void this.modal.success('Demo ampliada', 'El vencimiento se amplió correctamente.');
        this.cargar();
      },
      error: e => { this.guardando = false; void this.modal.error(e?.error?.message ?? 'No se pudo ampliar.'); },
    });
  }

  esDemo(l: LicenciaAdminDto): boolean { return l.tipo === 'D'; }

  private hoy(): string { return new Date().toISOString().slice(0, 10); }
}
