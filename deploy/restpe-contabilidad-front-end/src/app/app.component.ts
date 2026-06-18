import { Component, OnInit, inject } from '@angular/core';
import { NavigationEnd, Router } from '@angular/router';
import { ALL_COUNTRIES } from './home/constans';
import { CountryService } from './ui/services/countryservice.service';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.scss'],
  standalone: false,
})
export class AppComponent implements OnInit {
  private readonly router = inject(Router);
  countries = ALL_COUNTRIES;
  constructor (
        private utilityService: CountryService,
    ){
    }
  ngOnInit() {
    // Configurar eventos de navegación
      this.router.events.subscribe(event => {
        if (event instanceof NavigationEnd) {
          // this.triggerAnimation();
          this.getCountry(); // Usar nuestro método mejorado
        }
      });
    // Inicializar detección de país y pixel tracking
      this.initializeCountryAndPixel();
  }
  loadHubSpotChat(countryCode: string) {
      const existingScript = document.getElementById('hs-script-loader');

      if (countryCode === 'PE') {
        // Cargar el script solo si no existe
        if (!existingScript) {
          const script = document.createElement('script');
          script.type = 'text/javascript';
          script.id = 'hs-script-loader';
          script.async = true;
          script.defer = true;
          script.src = '//js.hs-scripts.com/44735304.js';
          document.body.appendChild(script);
        }
      } else {
        // Eliminar el script si el país no es Perú
        if (existingScript) {
          existingScript.remove();
        }
      }
    }
  setDefaultCountry() {
      console.log('Estableciendo país por defecto: Perú');
      let c: any = this.countries.find(a => a.codigo == 'PE') || this.countries[0];
      
      localStorage.setItem("country", c.nombre);
      localStorage.setItem("countryCode", c.codigo);

      // c.servicios = c.servicios.map((a: any) => {
      //   let servicio = this.serviciosbase.find(b => b.titulo == a.titulo);
      //   return { ...servicio, precio: a.precio };
      // });

      this.utilityService.setCountryGlobal(c);
      this.loadHubSpotChat(c.codigo);
    }
  async getCountry() {
      console.log('getCountry() - Iniciando proceso de detección de país...');
      
      try {
        // Verificar si ya existe un código de país
        let countryCode = this.utilityService.getCountryCode() || 'PE';
        
        if (!localStorage.getItem("countryCode")) {
          // Si no existe en localStorage, obtener desde la API
          console.log('getCountry() - Obteniendo desde API...');
          const response: any = await this.utilityService.getCountry().toPromise();
          
          if (response && response.country_code) {
            const detectedCountry = response.country_code;
            
            // Verificar si el país está en nuestra lista soportada
            const supportedCountries = ['PE', 'CO', 'CR', 'CL', 'EC', 'DO', 'GT', 'MX', 'SV'];
            countryCode = supportedCountries.includes(detectedCountry) ? detectedCountry : 'PE';
          }
          
          localStorage.setItem("countryCode", countryCode);
        }
        
        console.log('getCountry() - País obtenido:', countryCode);
        
        // Buscar el país en nuestra configuración
        let c: any = this.countries.find(a => a.codigo == countryCode);
        
        if (!c) {
          console.log('getCountry() - País no encontrado en configuración, usando PE');
          c = this.countries.find(a => a.codigo == 'PE') || this.countries[0];
        }

        console.log('getCountry() - Configurando país:', c.nombre, c.codigo);

        // Configurar servicios con precios locales
        // c.servicios = c.servicios.map((a: any) => {
          // let servicio = this.serviciosbase.find(b => b.titulo == a.titulo);
          // return { ...servicio, precio: a.precio };
        // });

        // Establecer país global y cargar chat
        this.utilityService.setCountryGlobal(c);
        this.loadHubSpotChat(c.codigo);
        
        console.log('getCountry() - Proceso completado exitosamente');
      } catch (error) {
        console.error('getCountry() - Error en proceso:', error);
        this.setDefaultCountry();
      }
    }
    

  async initializeCountryAndPixel() {
      try {
        // Verificar si ya existe un código de país
        let countryCode = this.utilityService.getCountryCode() || 'PE';
        
        if (countryCode === 'PE' && !localStorage.getItem("countryCode")) {
          // Si no existe, obtener desde la API
          console.log('ngOnInit - Obteniendo país desde API...');
          const response: any = await this.utilityService.getCountry().toPromise();
          
          if (response && response.country_code) {
            const detectedCountry = response.country_code;
            
            // Verificar si el país está en nuestra lista soportada
            const supportedCountries = ['PE', 'CO', 'CR', 'CL', 'EC', 'DO', 'GT', 'MX', 'SV'];
            countryCode = supportedCountries.includes(detectedCountry) ? detectedCountry : 'PE';
          }
          
          localStorage.setItem("countryCode", countryCode);
        }
        
        console.log('ngOnInit - País inicializado:', countryCode);
        this.utilityService.injectPixel(countryCode);
      } catch (error) {
        console.error('ngOnInit - Error inicializando país:', error);
        // Fallback a PE si hay error
        localStorage.setItem("countryCode", "PE");
        this.utilityService.injectPixel('PE');
      }
    }
}
