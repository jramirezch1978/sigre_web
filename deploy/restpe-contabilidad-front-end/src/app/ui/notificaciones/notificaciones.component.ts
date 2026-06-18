import { Component, ElementRef, HostListener, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { NotificacionApiItem, NotificacionesApiService } from 'src/app/modules/notificaciones/services/notificaciones-api.service';

// Font Awesome Icons
import { faCalendar, faClock, faExclamationTriangle } from '@fortawesome/pro-regular-svg-icons';
import { faBell, faEye } from '@fortawesome/pro-solid-svg-icons';



@Component({
  selector: 'app-notificaciones',
  templateUrl: './notificaciones.component.html',
  styleUrls: ['./notificaciones.component.scss'],
  standalone: false,
})
export class NotificacionesComponent  implements OnInit {
  // Font Awesome Icons
  farCalendar = faCalendar;
  farClock = faClock;
  farExclamationTriangle = faExclamationTriangle;
  fasBell = faBell;
  fasEye = faEye;
  showDropdown: boolean = false;
  cargando = false;
  notificaciones: NotificacionApiItem[] = [];

  constructor(
    private eRef : ElementRef,
    private router: Router,
    private notificacionesApiService: NotificacionesApiService
  ) { }

  ngOnInit() {
    this.cargarNotificaciones();
  }

  @HostListener('document:click', ['$event'])
  clickOutside(event: Event) {
    if (!this.eRef.nativeElement.contains(event.target)) {
      this.showDropdown = false;
    }
  }

  toggleDropdown() {
    this.showDropdown = !this.showDropdown;
    if (this.showDropdown) {
      this.cargarNotificaciones();
    }
  }

  get noLeidasCount(): number {
    return this.notificaciones.filter(item => !item.leido).length;
  }

  get notificacionesPreview(): NotificacionApiItem[] {
    return this.notificaciones.slice(0, 5);
  }

  marcarComoLeida(alerta: NotificacionApiItem): void {
    if (alerta.leido) return;

    this.notificacionesApiService.marcarComoLeida(alerta.id).subscribe({
      next: () => {
        this.notificaciones = this.notificaciones.map(item =>
          item.id === alerta.id ? { ...item, leido: true } : item
        );
      },
      error: () => {
        // Silencioso: no bloquear navegación/uso del dropdown por una falla puntual.
      }
    });
  }

  private cargarNotificaciones(): void {
    this.cargando = true;
    this.notificacionesApiService.listar().subscribe({
      next: (response) => {
        this.notificaciones = response.data ?? [];
        this.cargando = false;
      },
      error: () => {
        this.notificaciones = [];
        this.cargando = false;
      }
    });
  }

  formatearFecha(fechaIso: string): string {
    return new Date(fechaIso).toLocaleDateString('es-PE');
  }

  formatearHora(fechaIso: string): string {
    return new Date(fechaIso).toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit' });
  }
  apartadonotificaciones(){
    this.router.navigate(['notificaciones'])
  }

}
