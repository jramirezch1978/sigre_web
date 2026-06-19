import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { AdminProvisioningApiService } from '../../services/admin-provisioning-api.service';
import { ModalController } from '@ionic/angular';
import { ModalConfirmationComponent } from '@sigre-common';

@Component({
  selector: 'app-admin-empresa-provision',
  templateUrl: './admin-empresa-provision.component.html',
  styleUrls: ['./admin-empresa-provision.component.scss'],
  standalone: false,
})
export class AdminEmpresaProvisionComponent {

  private readonly fb = inject(FormBuilder);
  private readonly api = inject(AdminProvisioningApiService);
  private readonly modalController = inject(ModalController);

  readonly form: FormGroup = this.fb.group({
    provisionSecret: ['', [Validators.required]],
    sigla: ['', [Validators.required, Validators.maxLength(50)]],
    razonSocial: ['', [Validators.required, Validators.maxLength(200)]],
    ruc: ['', [Validators.required, Validators.maxLength(20)]],
    codigo: ['', [Validators.maxLength(20)]],
    nombreComercial: ['', [Validators.maxLength(200)]],
    email: ['', [Validators.required, Validators.email, Validators.maxLength(150)]],
    direccion: ['', [Validators.maxLength(300)]],
    dirUbigeo: ['', [Validators.maxLength(12)]],
    dbHost: ['', [Validators.maxLength(120)]],
    dbPort: [null as number | null],
    dbUser: ['', [Validators.maxLength(120)]],
    dbPassword: [''],
  });

  submitting = false;

  async enviar(): Promise<void> {
    if (this.form.invalid || this.submitting) {
      this.form.markAllAsTouched();
      return;
    }

    const v = this.form.getRawValue();
    this.submitting = true;

    this.api.provisionar(
      {
        sigla: v.sigla,
        razonSocial: v.razonSocial,
        ruc: v.ruc,
        codigo: v.codigo || undefined,
        nombreComercial: v.nombreComercial || undefined,
        email: v.email || undefined,
        correoContacto: v.email || undefined,
        direccion: v.direccion || undefined,
        dirUbigeo: v.dirUbigeo || undefined,
        dbHost: v.dbHost || undefined,
        dbPort: v.dbPort ?? undefined,
        dbUser: v.dbUser || undefined,
        dbPassword: v.dbPassword || undefined,
      },
    ).subscribe({
      next: async res => {
        this.submitting = false;
        const data = res.data;
        const msg = data?.mensaje ?? res.message ?? 'Operación completada';
        await this.modalOk(data?.exitoso !== false ? 'Aprovisionamiento' : 'Resultado', msg, data?.exitoso !== false ? 'success' : 'warning');
      },
      error: async err => {
        this.submitting = false;
        const body = err?.error;
        const message = body?.message ?? err?.message ?? 'Error al aprovisionar';
        await this.modalOk('Error', message, 'error');
      },
    });
  }

  private async modalOk(titulo: string, mensaje: string, tipo: 'success' | 'error' | 'warning'): Promise<void> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: '',
        tipemodal: tipo,
        title: titulo,
        message: mensaje,
        tipo,
        btnOkTxt: 'Aceptar',
        mostrarCancelar: false,
      },
    });
    await modal.present();
  }
}
