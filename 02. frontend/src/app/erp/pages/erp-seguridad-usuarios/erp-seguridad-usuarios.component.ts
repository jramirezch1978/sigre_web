import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ErpEmpresaDemoService, EmpresaDemoInfo, NuevoUsuarioDemo } from '../../services/erp-empresa-demo.service';

@Component({
  selector: 'app-erp-seguridad-usuarios',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './erp-seguridad-usuarios.component.html',
  styleUrls: ['./erp-seguridad-usuarios.component.scss'],
})
export class ErpSeguridadUsuariosComponent implements OnInit {

  private readonly api = inject(ErpEmpresaDemoService);

  info: EmpresaDemoInfo | null = null;
  cargando = true;
  guardando = false;
  error = '';
  exito = '';

  nuevo: NuevoUsuarioDemo = { username: '', email: '', password: '', nombres: '', apellidos: '' };

  ngOnInit(): void {
    this.cargar();
  }

  private cargar(): void {
    this.cargando = true;
    this.api.getInfo().subscribe({
      next: info => { this.info = info; this.cargando = false; },
      error: () => { this.cargando = false; this.error = 'No se pudo cargar la información de la empresa.'; },
    });
  }

  get puedeAgregar(): boolean {
    return !!this.info && this.info.esDemo && this.info.usados < this.info.maxUsuarios;
  }

  agregar(): void {
    this.error = '';
    this.exito = '';
    if (!this.nuevo.username || !this.nuevo.nombres || !this.nuevo.password) {
      this.error = 'Usuario, nombres y contraseña son obligatorios.';
      return;
    }
    this.guardando = true;
    this.api.agregarUsuario(this.nuevo).subscribe({
      next: () => {
        this.guardando = false;
        this.exito = `Usuario "${this.nuevo.username}" agregado.`;
        this.nuevo = { username: '', email: '', password: '', nombres: '', apellidos: '' };
        this.cargar();
      },
      error: (e: { error?: { message?: string } }) => {
        this.guardando = false;
        this.error = e?.error?.message ?? 'No se pudo agregar el usuario.';
      },
    });
  }
}
