import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../../environments/environment';

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
export class ErpRegistroDemoComponent {

  private readonly router = inject(Router);
  private readonly http = inject(HttpClient);

  paso = 1;
  cargando = false;
  error = '';
  registroExitoso = false;

  empresa = {
    ruc: '',
    razonSocial: '',
    nombreComercial: '',
    direccionFiscal: '',
    correoContacto: '',
    telefonoContacto: '',
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
      empresa: { ...this.empresa },
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
