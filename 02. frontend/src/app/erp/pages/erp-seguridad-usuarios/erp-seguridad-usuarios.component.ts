import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SigreModalService } from '@sigre-common';
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
  private readonly modal = inject(SigreModalService);

  info: EmpresaDemoInfo | null = null;
  cargando = true;
  guardando = false;
  error = '';
  exito = '';

  nuevo: NuevoUsuarioDemo = this.usuarioVacio();

  private usuarioVacio(): NuevoUsuarioDemo {
    return { username: '', email: '', password: '', nombres: '', apellidos: '', numeroDocumento: '' };
  }

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
    if (!this.info) return false;
    // Demo: límite duro. Pago: siempre puede (con advertencia de costo si excede).
    return this.info.esDemo ? this.info.usados < this.info.maxUsuarios : true;
  }

  /** True si el siguiente usuario excederá el límite incluido (solo aplica a empresas de pago). */
  get proximoConCosto(): boolean {
    return !!this.info && !this.info.esDemo && this.info.proximoExcede;
  }

  agregar(): void {
    this.error = '';
    this.exito = '';
    if (!this.nuevo.username || !this.nuevo.nombres || !this.nuevo.password) {
      this.error = 'Usuario, nombres y contraseña son obligatorios.';
      return;
    }
    this.enviar(false);
  }

  private enviar(confirmarExceso: boolean): void {
    this.guardando = true;
    const username = this.nuevo.username;
    this.api.agregarUsuario(this.nuevo, confirmarExceso).subscribe({
      next: () => {
        this.guardando = false;
        this.exito = `Usuario "${username}" agregado.`;
        this.nuevo = this.usuarioVacio();
        this.cargar();
      },
      error: (e: { error?: { message?: string; errorCode?: string } }) => {
        this.guardando = false;
        // El backend pide confirmar el exceso de usuarios: mostrar advertencia clara en modal.
        if (e?.error?.errorCode === 'EXCESO_REQUIERE_CONFIRMACION') {
          void this.confirmarExcesoYReintentar(e.error.message);
          return;
        }
        this.error = e?.error?.message ?? 'No se pudo agregar el usuario.';
      },
    });
  }

  private async confirmarExcesoYReintentar(mensaje?: string): Promise<void> {
    const ok = await this.modal.confirm({
      titulo: 'Usuario adicional con costo',
      mensaje: mensaje ?? 'Agregar este usuario supera el límite de su licencia y tendrá un costo adicional este mes.',
      submensaje: 'El cargo se aplica solo al mes en que el usuario está activo.',
      tipo: 'warning',
      textoConfirmar: 'Sí, agregar y aceptar el costo',
      textoCancelar: 'Cancelar',
      conCancelar: true,
    });
    if (ok) {
      this.enviar(true);
    }
  }
}
