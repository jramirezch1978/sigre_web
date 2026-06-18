import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ModalController } from '@ionic/angular';
import { UtilityService } from 'src/app/services/utility.service';
import { ModalAyudaPrincipalComponent } from 'src/app/ui/modal-ayuda-principal/modal-ayuda-principal.component';
import { StorageService } from 'src/app/core/services/storage.service';
import { LoginData } from 'src/app/auth/services/auth.service';
import { NotificacionApiItem, NotificacionesApiService } from './services/notificaciones-api.service';

// Font Awesome Icons
import { faBuilding, faGear, faHistory, faHome, faNetworkWired, faUser, faCircleQuestion, faSignOut,
  faExclamationTriangle, faCalendar, faClock
 } from '@fortawesome/pro-regular-svg-icons';
import { faTasks, faAngleDown,  } from '@fortawesome/pro-solid-svg-icons';
import { IconDefinition } from '@fortawesome/fontawesome-svg-core';


// Font Awesome Icons

// Font Awesome Icons

@Component({
  selector: 'app-apartado-notificaciones',
  templateUrl: './apartado-notificaciones.page.html',
  styleUrls: ['./apartado-notificaciones.page.scss'],
  standalone: false,
})
export class ApartadoNotificacionesPage implements OnInit {
  // Font Awesome Icons
  farBuilding = faBuilding;
  farGear = faGear;
  farHistory = faHistory;
  farHome = faHome;
  farNetworkWired = faNetworkWired;
  farUser = faUser;
  fasTasks = faTasks;
  fasAngleDown = faAngleDown;
  farCircleQuestion = faCircleQuestion;
  farSignOut = faSignOut;
  farExclamationTriangle = faExclamationTriangle;
  farCalendar = faCalendar;
  farClock = faClock;


  tabSeleccionado: string = 'todos';
  categoriaSeleccionada: string = 'todos';
  empresaNombre = '';
  empresaRuc = '';
  usuarioNombre = '';
  
  categorias = [
    { value: 'todos', label: 'Todas las categorías' },
    { value: 'rrhh', label: 'Recursos Humanos' },
    { value: 'contabilidad', label: 'Contabilidad' },
    { value: 'finanzas', label: 'Finanzas' },
  ];

  opciones=[
    {nombre: 'Inicio', icono: faHome},
    {nombre: 'Mi perfil', icono: faUser},
    {nombre: 'Historial de actividades', icono: faHistory},
    {nombre: 'Tareas pendientes', icono: faTasks},
    {nombre: 'Configuraciones', icono: faGear},
    {nombre: 'Mi empresa', icono: faBuilding},
    {nombre: 'Integraciones', icono: faNetworkWired},
  ]
  // MOCK anterior deshabilitado. Ahora se consume endpoint real en cargarNotificaciones().
  private notificaciones: NotificacionApiItem[] = [];

  alertasHoy: NotificacionApiItem[] = [];
  alertasAyer: NotificacionApiItem[] = [];
  alertasUltimos7Dias: NotificacionApiItem[] = [];
  alertasMesActual: NotificacionApiItem[] = [];
  alertasAntiguas: NotificacionApiItem[] = [];

  constructor(
    private modalController: ModalController,
    private utilityService: UtilityService,
    private router: Router,
    private storageService: StorageService,
    private notificacionesApiService: NotificacionesApiService
  ) { }

  ngOnInit() {
    this.cargarDatosSesion();
    this.cargarNotificaciones();
  }
  async modalayuda(){
      const modal= await this.modalController.create({
        component: ModalAyudaPrincipalComponent,
        cssClass: 'promo2'
      });
      return await modal.present();
    }
    public logout(): void {
     console.log('🚪 Cerrando sesión...');
      this.utilityService.signOut();
      this.router.navigateByUrl('/auth/signin');
    }

  private cargarDatosSesion(): void {
    const user = this.storageService.getUser<LoginData>();
    if (!user) return;
    this.empresaNombre = user.empresaNombre || '';
    this.empresaRuc = user.empresaRuc || '';
    this.usuarioNombre = user.nombreCompleto || `${user.nombres ?? ''} ${user.apellidos ?? ''}`.trim();
  }

  private cargarNotificaciones(): void {
    this.notificacionesApiService.listar().subscribe({
      next: (response) => {
        this.notificaciones = response.data ?? [];
        this.aplicarFiltrosYAgrupacion();
      },
      error: () => {
        this.notificaciones = [];
        this.aplicarFiltrosYAgrupacion();
      }
    });
  }

  aplicarFiltrosYAgrupacion(): void {
    const base = this.filtrarPorTab(this.notificaciones);
    const now = new Date();
    const inicioHoy = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const inicioAyer = new Date(inicioHoy);
    inicioAyer.setDate(inicioAyer.getDate() - 1);
    const inicioUltimos7 = new Date(inicioHoy);
    inicioUltimos7.setDate(inicioUltimos7.getDate() - 7);
    const inicioMes = new Date(now.getFullYear(), now.getMonth(), 1);

    this.alertasHoy = [];
    this.alertasAyer = [];
    this.alertasUltimos7Dias = [];
    this.alertasMesActual = [];
    this.alertasAntiguas = [];

    base.forEach(item => {
      const fecha = new Date(item.creadoEn);
      if (fecha >= inicioHoy) {
        this.alertasHoy.push(item);
      } else if (fecha >= inicioAyer && fecha < inicioHoy) {
        this.alertasAyer.push(item);
      } else if (fecha >= inicioUltimos7 && fecha < inicioAyer) {
        this.alertasUltimos7Dias.push(item);
      } else if (fecha >= inicioMes && fecha < inicioUltimos7) {
        this.alertasMesActual.push(item);
      } else {
        this.alertasAntiguas.push(item);
      }
    });
  }

  private filtrarPorTab(items: NotificacionApiItem[]): NotificacionApiItem[] {
    if (this.tabSeleccionado === 'noleidas') {
      return items.filter(i => !i.leido);
    }
    if (this.tabSeleccionado === 'leidas') {
      return items.filter(i => i.leido);
    }
    return items;
  }

  marcarComoLeida(alerta: NotificacionApiItem): void {
    if (alerta.leido) return;

    this.notificacionesApiService.marcarComoLeida(alerta.id).subscribe({
      next: () => {
        this.notificaciones = this.notificaciones.map(item =>
          item.id === alerta.id ? { ...item, leido: true } : item
        );
        this.aplicarFiltrosYAgrupacion();
      },
      error: () => {
        // Sin bloqueo de UI; el usuario puede continuar y reintentar.
      }
    });
  }

  get noLeidasCount(): number {
    return this.notificaciones.filter(i => !i.leido).length;
  }

  formatearFecha(fechaIso: string): string {
    return new Date(fechaIso).toLocaleDateString('es-PE');
  }

  formatearHora(fechaIso: string): string {
    return new Date(fechaIso).toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit' });
  }
} 
