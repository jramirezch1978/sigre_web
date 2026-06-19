import { Injectable, inject } from '@angular/core';
import { ModalController } from '@ionic/angular';
import { Observable, from } from 'rxjs';
import { ModalConfirmationComponent } from './modal-confirmation.component';
import { SigreModalOptions, SigreModalTipo } from './sigre-modal.types';

/** Extrae el mensaje legible de una respuesta HTTP de error. */
export function extraerMensajeErrorApi(err: unknown, fallback = 'Ocurrió un error'): string {
  const e = err as { error?: { message?: string; data?: Array<{ message?: string }> }; message?: string };
  const detalle = e?.error?.data?.[0]?.message;
  if (detalle) return detalle;
  if (e?.error?.message) return e.error.message;
  if (e?.message) return e.message;
  return fallback;
}

@Injectable({ providedIn: 'root' })
export class SigreModalService {
  private readonly modalCtrl = inject(ModalController);

  /** Confirmación con botones Cancelar / Confirmar. Resuelve true si el usuario confirma. */
  confirm(options: SigreModalOptions): Promise<boolean> {
    return this.presentConfirmacion(options);
  }

  confirm$(options: SigreModalOptions): Observable<boolean> {
    return from(this.confirm(options));
  }

  confirmAnular(nombre: string): Promise<boolean> {
    return this.confirm({
      titulo: 'Anular registro',
      mensaje: `¿Anular «${this.escapeHtml(nombre)}»?`,
      tipo: 'warning',
      textoConfirmar: 'Anular',
      textoCancelar: 'Cancelar',
      conCancelar: true,
    });
  }

  confirmAnular$(nombre: string): Observable<boolean> {
    return from(this.confirmAnular(nombre));
  }

  confirmEliminar(nombre: string): Promise<boolean> {
    return this.confirm({
      titulo: 'Eliminar registro',
      mensaje: `¿Eliminar permanentemente «${this.escapeHtml(nombre)}»?`,
      submensaje: 'Esta acción no se puede deshacer.',
      tipo: 'warning',
      textoConfirmar: 'Eliminar',
      textoCancelar: 'Cancelar',
      conCancelar: true,
    });
  }

  confirmEliminar$(nombre: string): Observable<boolean> {
    return from(this.confirmEliminar(nombre));
  }

  /** Modal informativo de error (solo Aceptar). */
  error(mensaje: string, titulo = 'Error'): Promise<void> {
    return this.alert({ titulo, mensaje, tipo: 'error' });
  }

  /** Modal de advertencia (solo Aceptar). */
  warning(mensaje: string, titulo = 'Advertencia'): Promise<void> {
    return this.alert({ titulo, mensaje, tipo: 'warning' });
  }

  /** Modal de éxito (solo Aceptar). */
  success(titulo: string, mensaje: string): Promise<void> {
    return this.alert({ titulo, mensaje, tipo: 'success' });
  }

  /** Modal informativo (solo Aceptar). */
  info(titulo: string, mensaje: string, textoConfirmar = 'Aceptar'): Promise<void> {
    return this.alert({ titulo, mensaje, tipo: 'info', textoConfirmar });
  }

  /** Modal de solo lectura sin cancelar. */
  alert(options: SigreModalOptions): Promise<void> {
    return this.presentAlerta(options);
  }

  private async presentConfirmacion(options: SigreModalOptions): Promise<boolean> {
    const modal = await this.modalCtrl.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: this.toComponentProps(options, true),
    });
    await modal.present();
    const { data } = await modal.onDidDismiss<boolean>();
    return data === true;
  }

  private async presentAlerta(options: SigreModalOptions): Promise<void> {
    const modal = await this.modalCtrl.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: this.toComponentProps({ ...options, conCancelar: false }),
    });
    await modal.present();
    await modal.onDidDismiss();
  }

  private toComponentProps(options: SigreModalOptions, esConfirmacion = false): Record<string, string> {
    const tipo: SigreModalTipo = options.tipo ?? (esConfirmacion ? 'warning' : 'error');
    const conCancelar = options.conCancelar ?? esConfirmacion;
    const textoOk =
      options.textoConfirmar ??
      (tipo === 'error' || tipo === 'warning' ? 'Aceptar' : tipo === 'success' ? 'Aceptar' : 'Confirmar');

    return {
      titlemodal: '',
      tipemodal: tipo,
      title: options.titulo,
      message: options.mensaje,
      submessage: options.submensaje ?? '',
      btnCancelTxt: conCancelar ? (options.textoCancelar ?? 'Cancelar') : '',
      btnOkTxt: textoOk,
    };
  }

  private escapeHtml(value: string): string {
    return value.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
  }
}
