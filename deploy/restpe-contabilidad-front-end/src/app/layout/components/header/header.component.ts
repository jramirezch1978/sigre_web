import { Component, ViewChild, OnInit, inject } from '@angular/core';
import { Router } from '@angular/router';
import { UtilityService } from '../../../services/utility.service';
import { Observable } from 'rxjs';
import { SessionData } from '../../../services/utility.service';
import { ALL_COUNTRIES } from 'src/app/home/constans';
import { ModalController } from '@ionic/angular';
import { ModalAyudaPrincipalComponent } from '../../../ui/modal-ayuda-principal/modal-ayuda-principal.component';
import { ModalConfirmationComponent } from '@ui/modal-confirmation/modal-confirmation.component';
import { faCircleQuestion } from '@fortawesome/pro-regular-svg-icons';
import { faAngleDown, faArrowRightToBracket, faBell, faBuilding as fasBuilding, faChevronDown, faGear, faListUl, faLocationDot, faRightFromBracket, faStore, faUser, faUserCircle } from '@fortawesome/pro-solid-svg-icons';
import { RazonSocialFacade } from 'src/app/auth/application/facades/razon-social.facade';
import { RazonSocialEntity } from 'src/app/auth/domain/models/razon-social.entity';
import { ToastService } from '@ui/services/toast.service';
import { StorageService } from 'src/app/core/services/storage.service';
import { AuthService, LoginData } from 'src/app/auth/services/auth.service';
import { faBuilding } from '@fortawesome/pro-light-svg-icons';
import { environment } from 'src/environments/environment';


@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss'],
  standalone: false
})
export class HeaderComponent implements OnInit {
  falBuilding = faBuilding;
  fasBuilding = fasBuilding;
  farCircleQuestion = faCircleQuestion;
  fasAngleDown = faAngleDown;
  fasArrowRightToBracket = faArrowRightToBracket;
  fasChevronDown = faChevronDown;
  fasUserCircle = faUserCircle;
  fasUser = faUser;
  fasGear = faGear;
  fasRightFromBracket = faRightFromBracket;
  fasStore = faStore;
  fasLocationDot = faLocationDot;
  fasListUl = faListUl;
  fasBell = faBell;

  @ViewChild('popover') popover!: HTMLIonPopoverElement;
  @ViewChild('popover2') popover2!: HTMLIonPopoverElement;
  @ViewChild('popoverUser') popoverUser!: HTMLIonPopoverElement;
  @ViewChild('popoverEmpresa') popoverEmpresa!: HTMLIonPopoverElement;
  private readonly router = inject(Router);
  private readonly utilityService = inject(UtilityService);
  private readonly razonSocialFacade = inject(RazonSocialFacade);
  private readonly storageService = inject(StorageService);
  private readonly authService = inject(AuthService);

  isOpen = false;
  isOpen2 = false;
  isOpenUserMenu = false;
  isOpenEmpresaMenu = false;
  nombreUsuario = 'Jean Piere Santillán';
  emailUsuario = '';
  empresaNombre = 'Distribuidora Norte S.A. de C.V.';
  imagenUsuario = '';
  empresaRuc = '';
  sucursalNombre = '';
  searchQuery = '';
  paisseleccionado: string ='';

  countries = ALL_COUNTRIES;
  readonly razones = this.razonSocialFacade.razones;

  readonly razonSocialSeleccionada = this.razonSocialFacade.seleccionada;

  paises : any[] = [];
  /** Visible si el backend indica flag administrador de sistema (login / selección empresa). */
  mostrarAdministracionEmpresas = false;
  // Obtener datos de la sesión actual
  public readonly session$: Observable<SessionData | null> = this.utilityService.session$;

  constructor(
    private modalController: ModalController,
    private toast: ToastService,
  ) { }

  ngOnInit() {
    this.cargarDatosUsuario();
    this.razonSocialFacade.cargarRazonesSociales();
    this.countries.map(c => {
      if(c.codigo === 'PE' || c.codigo === 'EC' || c.codigo === 'CO' || c.codigo === 'GT'){
        this.paises.push({
      codigo: c.codigo,
      nombre: c.nombre
    });
  }
      console.log(`País disponible: ${c.nombre} (${c.codigo})`);
    });
    this.paisseleccionado = localStorage.getItem("countryCode") || 'PE';
    // localStorage.getItem("paisseleccionado");
    // console.log('paises que estan en el local', this.paisseleccionado);
  }
  async modalayuda(){
    const modal= await this.modalController.create({
      component: ModalAyudaPrincipalComponent,
      cssClass: 'promo2'
    });
    return await modal.present();
  }

  seleccionarRazon(razon: RazonSocialEntity) {
    if (razon.estado != 'Activo') {
      this.toast.warning('La razón social seleccionada está inactiva.',' Por favor, elige otra razón social.');
      return;
    }
    this.razonSocialFacade.seleccionarRazon(razon);
    this.presentPopoverUser(null as any); // Cerrar el popover
  }
  ircambiarrazon() {
    this.isOpen2 = false;
    setTimeout(() => {
      this.router.navigateByUrl('/auth/seleccion-razon-social');
    }, 150); // Pequeño delay para animación de cierre
  }
  /**
   * Cerrar sesión del usuario
   */
  onPaisChange(value: string) {
    localStorage.setItem("countryCode", value);
    console.log('Cambio:', value);
    console.log('País seleccionado en el local');
    location.reload();
  }
  public async logout(): Promise<void> {
    console.log('🚪 Cerrando sesión...');
    await this.authService.signOut();
  }

  private async confirmarCierreSesion(): Promise<boolean> {
    const modal = await this.modalController.create({
      component: ModalConfirmationComponent,
      cssClass: 'promo',
      componentProps: {
        titlemodal: 'Confirmación',
        tipemodal: 'confirm',
        title: 'Cerrar sesión',
        message: '¿Desea cerrar sesión?',
        btnCancelTxt: 'Cancelar',
        btnOkTxt: 'Aceptar'
      }
    });

    await modal.present();
    const { data } = await modal.onDidDismiss();
    return !!data;
  }

  public cerrarPopoverYLogout(): void {
    this.isOpen2 = false;
    setTimeout(async () => {
      const confirmar = await this.confirmarCierreSesion();
      if (!confirmar) return;
      await this.logout();
    }, 150); // Pequeño delay para animación de cierre
  }
  public openHelpPopover(): void {
  }

  private cargarDatosUsuario(): void {
    const user = this.storageService.getUser<LoginData>();
    if (user) {
      this.nombreUsuario = user.nombreCompleto || `${user.nombres ?? ''} ${user.apellidos ?? ''}`.trim() || user.username || '';
      this.emailUsuario = user.email || '';
      this.empresaNombre = user.empresaNombre || '';
      this.empresaRuc = user.empresaRuc || '';
      this.sucursalNombre = user.sucursalNombre || '';
      this.mostrarAdministracionEmpresas = user.adminSistema === true;
      // cargar imagen de perfil, lo comenté porque no se está enviando en el login
      // this.imagenUsuario = user.imagenUsuario || '';
    }
  }

  presentPopoverUser(triggerEl: HTMLElement): void {
    this.popoverUser.event = { target: triggerEl } as any;
    this.isOpenUserMenu = !this.isOpenUserMenu;
  }

  irAPerfil(): void {
    this.isOpenUserMenu = false;
    setTimeout(() => this.router.navigateByUrl('/configuracion/perfil'), 150);
  }

  irAConfiguracion(): void {
    this.isOpenUserMenu = false;
    setTimeout(() => this.router.navigateByUrl('/configuracion'), 150);
  }

  irANotificaciones(): void {
    this.isOpenUserMenu = false;
    setTimeout(() => this.router.navigateByUrl('/notificaciones'), 150);
  }

  /** Admin de sistema: misma sesión en esta SPA o redirección si `adminExternalBaseUrl` está definida. */
  irAAdministracionEmpresas(): void {
    this.isOpenUserMenu = false;
    const external = environment.adminExternalBaseUrl?.trim() ?? '';
    setTimeout(() => {
      if (external) {
        const base = external.replace(/\/+$/, '');
        window.location.href = `${base}/inicio`;
        return;
      }
      this.router.navigateByUrl('/admin/inicio');
    }, 150);
  }

  cerrarSesionDesdeMenu(): void {
    this.isOpenUserMenu = false;
    setTimeout(async () => {
      const confirmar = await this.confirmarCierreSesion();
      if (!confirmar) return;
      await this.logout();
    }, 150);
  }

  presentPopoverEmpresa(e: Event): void {
    this.popoverEmpresa.event = e;
    this.isOpenEmpresaMenu = !this.isOpenEmpresaMenu;
  }

  irASeleccionarSucursal(): void {
    this.isOpenEmpresaMenu = false;
    setTimeout(() => this.router.navigateByUrl('/auth/seleccion-razon-social'), 150);
  }

  irAListarSucursales(): void {
    this.isOpenEmpresaMenu = false;
    setTimeout(() => this.router.navigateByUrl('/configuracion/sucursales'), 150);
  }
}
