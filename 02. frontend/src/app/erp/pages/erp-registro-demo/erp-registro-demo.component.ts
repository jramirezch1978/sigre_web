import { Component, OnDestroy, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { Subscription } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { ErpConsultaRucService } from '../../services/erp-consulta-ruc.service';
import { ErpUbigeoService, UbigeoItem } from '../../services/erp-ubigeo.service';

interface UsuarioDemo {
  username: string;
  email: string;
  password: string;
  nombres: string;
  apellidos: string;
}

interface RegistroDemoRequest {
  empresa: {
    ruc: string;
    razonSocial: string;
    nombreComercial: string;
    direccionFiscal: string;
    ubigeo: string;
    distritoId: number | null;
    representanteLegal: string;
    dniRepresentanteLegal: string;
    correoContacto: string;
    telefonoContacto: string;
  };
  adminUser: {
    username: string;
    email: string;
    password: string;
    nombres: string;
    apellidos: string;
  };
  usuariosAdicionales: UsuarioDemo[];
}

@Component({
  selector: 'app-erp-registro-demo',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './erp-registro-demo.component.html',
  styleUrls: ['./erp-registro-demo.component.scss'],
})
export class ErpRegistroDemoComponent implements OnInit, OnDestroy {

  private readonly router = inject(Router);
  private readonly http = inject(HttpClient);
  private readonly consultaRucService = inject(ErpConsultaRucService);
  private readonly ubigeoService = inject(ErpUbigeoService);

  paso = 1;
  cargando = false;
  consultandoRuc = false;
  rucMensaje = '';
  error = '';
  registroExitoso = false;

  departamentos: UbigeoItem[] = [];
  provincias: UbigeoItem[] = [];
  distritos: UbigeoItem[] = [];

  private rucConsultaTimer?: ReturnType<typeof setTimeout>;
  private rucConsultaSub?: Subscription;
  private ultimoRucConsultado = '';

  empresa = {
    ruc: '',
    razonSocial: '',
    nombreComercial: '',
    direccionFiscal: '',
    ubigeo: '',
    departamentoId: null as number | null,
    provinciaId: null as number | null,
    distritoId: null as number | null,
    representanteLegal: '',
    dniRepresentanteLegal: '',
    correoContacto: '',
    telefonoContacto: '',
    estadoSunat: '',
    condicionSunat: '',
  };

  adminUser: UsuarioDemo = {
    username: '',
    email: '',
    password: '',
    nombres: '',
    apellidos: '',
  };

  confirmPassword = '';

  usuariosAdicionales: UsuarioDemo[] = [];

  ngOnInit(): void {
    this.ubigeoService.listarDepartamentos().subscribe({
      next: (items) => { this.departamentos = items; },
    });
  }

  get totalUsuarios(): number {
    return 1 + this.usuariosAdicionales.length;
  }

  get puedeAgregarUsuario(): boolean {
    return this.totalUsuarios < 5;
  }

  agregarUsuario(): void {
    if (!this.puedeAgregarUsuario) return;
    this.usuariosAdicionales.push({
      username: '',
      email: '',
      password: '',
      nombres: '',
      apellidos: '',
    });
  }

  eliminarUsuario(index: number): void {
    this.usuariosAdicionales.splice(index, 1);
  }

  ngOnDestroy(): void {
    if (this.rucConsultaTimer) {
      clearTimeout(this.rucConsultaTimer);
    }
    this.rucConsultaSub?.unsubscribe();
  }

  onRucChange(value: string): void {
    const ruc = (value ?? '').replace(/\D/g, '').slice(0, 11);
    this.empresa.ruc = ruc;
    this.rucMensaje = '';

    if (this.rucConsultaTimer) {
      clearTimeout(this.rucConsultaTimer);
    }

    if (ruc.length !== 11) {
      this.consultandoRuc = false;
      this.rucConsultaSub?.unsubscribe();
      this.ultimoRucConsultado = '';
      return;
    }

    if (ruc === this.ultimoRucConsultado) {
      return;
    }

    this.rucConsultaTimer = setTimeout(() => this.consultarRucSunat(ruc), 450);
  }

  onDepartamentoChange(): void {
    this.empresa.provinciaId = null;
    this.empresa.distritoId = null;
    this.provincias = [];
    this.distritos = [];
    if (!this.empresa.departamentoId) return;

    this.ubigeoService.listarProvincias(this.empresa.departamentoId).subscribe({
      next: (items) => { this.provincias = items; },
    });
  }

  onProvinciaChange(): void {
    this.empresa.distritoId = null;
    this.distritos = [];
    if (!this.empresa.provinciaId) return;

    this.ubigeoService.listarDistritos(this.empresa.provinciaId).subscribe({
      next: (items) => { this.distritos = items; },
    });
  }

  onDistritoChange(): void {
    const distrito = this.distritos.find(d => d.id === this.empresa.distritoId);
    this.empresa.ubigeo = distrito?.codigo ?? this.empresa.ubigeo;
  }

  onDniRepresentanteChange(value: string): void {
    this.empresa.dniRepresentanteLegal = (value ?? '').replace(/\D/g, '').slice(0, 8);
  }

  private consultarRucSunat(ruc: string): void {
    this.rucConsultaSub?.unsubscribe();
    this.consultandoRuc = true;
    this.rucMensaje = '';

    this.rucConsultaSub = this.consultaRucService.consultarRuc(ruc).subscribe({
      next: (data) => {
        this.consultandoRuc = false;
        this.ultimoRucConsultado = ruc;
        this.empresa.razonSocial = data.razonSocial ?? '';
        if (!this.empresa.nombreComercial.trim()) {
          this.empresa.nombreComercial = data.nombreComercial ?? data.razonSocial ?? '';
        }
        this.empresa.direccionFiscal = data.direccionFiscal ?? '';
        this.empresa.ubigeo = data.ubigeo ?? '';
        this.empresa.estadoSunat = data.estado ?? '';
        this.empresa.condicionSunat = data.condicion ?? '';

        if (ruc.startsWith('10') && !this.empresa.representanteLegal.trim()) {
          this.empresa.representanteLegal = data.razonSocial ?? '';
          this.empresa.dniRepresentanteLegal = ruc.substring(2, 10);
        }

        if (data.ubigeo) {
          this.aplicarUbigeoPorCodigo(data.ubigeo);
        }
      },
      error: (err) => {
        this.consultandoRuc = false;
        this.ultimoRucConsultado = '';
        this.rucMensaje = err.error?.message || err.message || 'No se encontró información para este RUC.';
      },
    });
  }

  private aplicarUbigeoPorCodigo(codigo: string): void {
    this.ubigeoService.obtenerPorCodigo(codigo).subscribe({
      next: (lookup) => {
        this.empresa.ubigeo = lookup.ubigeo;
        this.empresa.departamentoId = lookup.departamentoId;
        this.ubigeoService.listarProvincias(lookup.departamentoId).subscribe({
          next: (provincias) => {
            this.provincias = provincias;
            this.empresa.provinciaId = lookup.provinciaId;
            this.ubigeoService.listarDistritos(lookup.provinciaId).subscribe({
              next: (distritos) => {
                this.distritos = distritos;
                this.empresa.distritoId = lookup.distritoId;
              },
            });
          },
        });
      },
    });
  }

  irAPaso(paso: number): void {
    this.error = '';
    if (paso === 2 && !this.validarPaso1()) return;
    if (paso === 3 && !this.validarPaso2()) return;
    this.paso = paso;
  }

  private validarPaso1(): boolean {
    if (!this.empresa.ruc || this.empresa.ruc.length !== 11) {
      this.error = 'El RUC debe tener 11 dígitos.';
      return false;
    }
    if (!this.empresa.razonSocial.trim()) {
      this.error = 'La razón social es obligatoria.';
      return false;
    }
    if (!this.empresa.direccionFiscal.trim()) {
      this.error = 'La dirección fiscal es obligatoria.';
      return false;
    }
    if (!this.empresa.distritoId) {
      this.error = 'Seleccione departamento, provincia y distrito.';
      return false;
    }
    if (!this.empresa.representanteLegal.trim()) {
      this.error = 'El representante legal es obligatorio.';
      return false;
    }
    if (!this.empresa.dniRepresentanteLegal.trim() || this.empresa.dniRepresentanteLegal.length !== 8) {
      this.error = 'El DNI del representante legal debe tener 8 dígitos.';
      return false;
    }
    if (!this.empresa.correoContacto.trim() || !this.empresa.correoContacto.includes('@')) {
      this.error = 'Ingrese un correo de contacto válido.';
      return false;
    }
    return true;
  }

  private validarPaso2(): boolean {
    if (!this.adminUser.username.trim()) {
      this.error = 'El nombre de usuario es obligatorio.';
      return false;
    }
    if (!this.adminUser.email.trim() || !this.adminUser.email.includes('@')) {
      this.error = 'Ingrese un email válido.';
      return false;
    }
    if (!this.adminUser.password || this.adminUser.password.length < 6) {
      this.error = 'La contraseña debe tener al menos 6 caracteres.';
      return false;
    }
    if (this.adminUser.password !== this.confirmPassword) {
      this.error = 'Las contraseñas no coinciden.';
      return false;
    }
    if (!this.adminUser.nombres.trim()) {
      this.error = 'El nombre es obligatorio.';
      return false;
    }
    return true;
  }

  registrar(): void {
    this.error = '';
    this.cargando = true;

    const body: RegistroDemoRequest = {
      empresa: {
        ruc: this.empresa.ruc,
        razonSocial: this.empresa.razonSocial,
        nombreComercial: this.empresa.nombreComercial,
        direccionFiscal: this.empresa.direccionFiscal,
        ubigeo: this.empresa.ubigeo,
        distritoId: this.empresa.distritoId,
        representanteLegal: this.empresa.representanteLegal,
        dniRepresentanteLegal: this.empresa.dniRepresentanteLegal,
        correoContacto: this.empresa.correoContacto,
        telefonoContacto: this.empresa.telefonoContacto,
      },
      adminUser: { ...this.adminUser },
      usuariosAdicionales: this.usuariosAdicionales.filter(u => u.username.trim()),
    };

    this.http.post(`${environment.apiUrl}/auth/seguridad/registro-demo`, body).subscribe({
      next: () => {
        this.cargando = false;
        this.registroExitoso = true;
      },
      error: (err) => {
        this.cargando = false;
        this.error = err.error?.message || err.error?.error || 'Error al registrar. Intente nuevamente.';
      },
    });
  }

  irALogin(): void {
    void this.router.navigateByUrl('/auth/signin');
  }

  volver(): void {
    void this.router.navigateByUrl('/sigre/inicio');
  }
}
