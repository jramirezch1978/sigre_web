import {Injectable} from '@angular/core';
import { ALL_COUNTRIES, MESSAGE_VALIDATION, TIPOS_MENSAJE_MESSAGESERVICE, WHATSAPP_NUMBERS } from 'src/app/home/constans';
import { Observable, Subject } from 'rxjs';
import { HttpClient } from '@angular/common/http';
// import * as moment from 'moment';

@Injectable({
  providedIn: 'root'
})
export class CountryService {

    paisglobal: Subject<any> = new Subject();
    public WHATSAPP_NUMBERS = WHATSAPP_NUMBERS;

  constructor(
    private http: HttpClient
  ) {

  }
  botoncerrarwhatsapp=false;
  // static tropicalize(palabra: string) {
  //   let result = "";
  //   palabra = palabra.trim();
  //   let currentcode: any = localStorage.getItem("countryCode");
  //   const currentSymbol = ALL_COUNTRIES.find(a => a.codigo == currentcode)?.simbolo ?? "S/"
    
  //   // para que esto sirva debes colocar en el div padre la palabra tropicalize
  //   const vocabulario: any = {
  //       'CL': {
  //           "mesero.": 'garzón.',
  //           "mesero" : 'garzón',
  //           "meseros": 'garzones',
  //           "meseros.": 'garzones.',
  //           "almacenes": 'bodegas',
  //           "Almacenes": 'Bodegas',
  //           "almacén": 'bodega',
  //           "Almacene": 'Bodega',
  //           "Carta": 'Menú',
  //           "carta":'menú',
  //           "Digital":'Online',
  //           "digital":'online',
  //           "digital,":'online,',
  //       },
  //       'GT': {
  //           "almacenes": 'Bodegas',
  //           "almacén": 'bodega',
  //           "Almacenes": 'Bodegas'
  //       },
  //         'EC':
  //           {
  //             "almacenes": 'bodegas',
  //             "Almacenes": 'Bodegas',
  //             "almacenes,": 'bodegas,',
  //             "Almacenes,": 'Bodegas,',
  //             "almacén": 'bodega',
  //             "Almacén": 'Bodega',
  //             "mesero" : 'garzón',
  //             "mesero." : 'garzón.',
  //             "Mesero":'Garzon',
  //             "Mesero.":'Garzon.',
  //             "meseros": 'garzones',
  //             "meseros.": 'garzones.',
  //             "Meseros.": 'Garzones.',
  //             "Meseros": 'Garzones',
  //             "Carta" : 'E',
  //             "Digital":'- Commerce',
              
  //           },
  //           'CO':
  //           {
  //             "almacenes": 'bodegas',
  //             "Almacenes": 'Bodegas',
  //             "almacenes,": 'bodegas,',
  //             "Almacenes,": 'Bodegas,',
  //             "almacén": 'bodega',
  //             "Almacén": 'Bodega',
  //             "mesero" : 'garzón',
  //             "mesero." : 'garzón.',
  //             "Mesero":'Garzon',
  //             "Mesero.":'Garzon.',
  //             "meseros": 'garzones',
  //             "meseros.": 'garzones.',
  //             "Meseros.": 'Garzones.',
  //             "Meseros": 'Garzones',
  //             "Carta" : 'E',
  //             "Digital":'- Commerce',
  //           },
  //           'CR':
  //           {
  //             "almacenes": 'bodegas',
  //             "Almacenes": 'Bodegas',
  //             "almacenes,": 'bodegas,',
  //             "Almacenes,": 'Bodegas,',
  //             "almacén": 'bodega',
  //             "Almacén": 'Bodega',
  //             "mesero" : 'saloneros',
  //             "mesero." : 'saloneros.',
  //             "Mesero":'Saloneros',
  //             "Mesero.":'Saloneros.',
  //             "meseros": 'meseros',
  //             "meseros.": 'meseros.',
  //             "Meseros.": 'Meseros.',
  //             "Meseros": 'Meseros',
  //             "Carta": 'Menú',
  //             "carta": 'menú',
  //           },
  //           'DO':
  //           {
  //             "almacenes": 'bodegas',
  //             "Almacenes": 'Bodegas',
  //             "almacenes,": 'bodegas,',
  //             "Almacenes,": 'Bodegas,',
  //             "almacén": 'bodega',
  //             "Almacén": 'Bodega',
  //             "mesero" : 'salonero',
  //             "mesero." : 'salonero.',
  //             "Mesero":'Salonero',
  //             "Mesero.":'Salonero.',
  //             "meseros": 'mesero',
  //             "meseros.": 'mesero.',
  //             "Meseros.": 'Mesero.',
  //             "Meseros": 'Mesero',
  //             "Carta": 'Menú',
  //             "carta": 'menú',
              
  //           }

  //       // 'SV': {
  //       //     "S/": currentSymbol
  //       // },
  //       // 'MX': {
  //       //     "S/": currentSymbol
  //       // },
  //       // 'NI': {
  //       //     "S/": currentSymbol
  //       // },
  //   }

  //   if(currentcode && vocabulario[currentcode]) {
      
  //       result = vocabulario[currentcode][palabra] ? vocabulario[currentcode][palabra] : palabra;
  //   }
  //   else {
  //       result = palabra;
  //   }

  //   return result;
  // }

  setCountryGlobal(data: any) {
    this.paisglobal.next(data);
  }

  getCountryGlobal() {
    return this.paisglobal.asObservable();
  }

  injectPixel(countryCode: string) {
    const pixelCode = this.getPixelByCountry(countryCode);
    if (pixelCode) {
      const script = document.createElement('script');
      script.innerHTML = pixelCode;
      document.head.appendChild(script);
    }
  }

  getWhatsAppNumber(countryCode: any): any {
    return WHATSAPP_NUMBERS?.[countryCode] ?? WHATSAPP_NUMBERS.DEFAULT;
  }

  getPixelByCountry(countryCode: string): string {
    switch (countryCode) {
      case 'PE': // Perú
        return `
          !function(f,b,e,v,n,t,s)
          {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
          n.callMethod.apply(n,arguments):n.queue.push(arguments)};
          if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
          n.queue=[];t=b.createElement(e);t.async=!0;
          t.src=v;s=b.getElementsByTagName(e)[0];
          s.parentNode.insertBefore(t,s)}(window, document,'script',
          'https://connect.facebook.net/en_US/fbevents.js');
          fbq('init', '541128865200351');
          fbq('track', 'PageView');
        `;
        case 'CR':
        return `
        !function(f,b,e,v,n,t,s)
        {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
        n.callMethod.apply(n,arguments):n.queue.push(arguments)};
        if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
        n.queue=[];t=b.createElement(e);t.async=!0;
        t.src=v;s=b.getElementsByTagName(e)[0];
        s.parentNode.insertBefore(t,s)}(window, document,'script',
        'https://connect.facebook.net/en_US/fbevents.js');
        fbq('init', '926129299035947');
        fbq('track', 'PageView');
      `;
      case 'GT': // Guatemala
        return `
        !function(f,b,e,v,n,t,s)
        {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
        n.callMethod.apply(n,arguments):n.queue.push(arguments)};
        if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
        n.queue=[];t=b.createElement(e);t.async=!0;
        t.src=v;s=b.getElementsByTagName(e)[0];
        s.parentNode.insertBefore(t,s)}(window, document,'script',
        'https://connect.facebook.net/en_US/fbevents.js');
        fbq('init', '1023571146193068');
        fbq('track', 'PageView');
        `;
        case 'CO': // Colombia
        return `
        !function(f,b,e,v,n,t,s)
        {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
        n.callMethod.apply(n,arguments):n.queue.push(arguments)};
        if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
        n.queue=[];t=b.createElement(e);t.async=!0;
        t.src=v;s=b.getElementsByTagName(e)[0];
        s.parentNode.insertBefore(t,s)}(window, document,'script',
        'https://connect.facebook.net/en_US/fbevents.js');
        fbq('init', '1116377250096410');
        fbq('track', 'PageView');
        `;
      case 'DO': // Repulica dominicana
          return `
          !function(f,b,e,v,n,t,s)
          {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
          n.callMethod.apply(n,arguments):n.queue.push(arguments)};
          if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
          n.queue=[];t=b.createElement(e);t.async=!0;
          t.src=v;s=b.getElementsByTagName(e)[0];
          s.parentNode.insertBefore(t,s)}(window, document,'script',
          'https://connect.facebook.net/en_US/fbevents.js');
          fbq('init', '1115522413273804');
          fbq('track', 'PageView');
          `;
      case 'CL': // Chile
          return `
          !function(f,b,e,v,n,t,s)
          {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
          n.callMethod.apply(n,arguments):n.queue.push(arguments)};
          if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
          n.queue=[];t=b.createElement(e);t.async=!0;
          t.src=v;s=b.getElementsByTagName(e)[0];
          s.parentNode.insertBefore(t,s)}(window, document,'script',
          'https://connect.facebook.net/en_US/fbevents.js');
          fbq('init', '637815388706877');
          fbq('track', 'PageView');
          `;
      case 'MX': // Repulica dominicana
          return `
          !function(f,b,e,v,n,t,s)
          {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
          n.callMethod.apply(n,arguments):n.queue.push(arguments)};
          if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
          n.queue=[];t=b.createElement(e);t.async=!0;
          t.src=v;s=b.getElementsByTagName(e)[0];
          s.parentNode.insertBefore(t,s)}(window, document,'script',
          'https://connect.facebook.net/en_US/fbevents.js');
          fbq('init', '871631761715185');
          fbq('track', 'PageView');
          `;
      case 'EC': // Ecuador
          return `
          !function(f,b,e,v,n,t,s)
          {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
          n.callMethod.apply(n,arguments):n.queue.push(arguments)};
          if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
          n.queue=[];t=b.createElement(e);t.async=!0;
          t.src=v;s=b.getElementsByTagName(e)[0];
          s.parentNode.insertBefore(t,s)}(window, document,'script',
          'https://connect.facebook.net/en_US/fbevents.js');
          fbq('init', '656262587112020');
          fbq('track', 'PageView');
          `;
      case 'SV': // El salvador
          return `
          !function(f,b,e,v,n,t,s)
          {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
          n.callMethod.apply(n,arguments):n.queue.push(arguments)};
          if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
          n.queue=[];t=b.createElement(e);t.async=!0;
          t.src=v;s=b.getElementsByTagName(e)[0];
          s.parentNode.insertBefore(t,s)}(window, document,'script',
          'https://connect.facebook.net/en_US/fbevents.js');
          fbq('init', '1088515190028831');
          fbq('track', 'PageView');
          `;
      default:
        return `
          !function(f,b,e,v,n,t,s)
          {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
          n.callMethod.apply(n,arguments):n.queue.push(arguments)};
          if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
          n.queue=[];t=b.createElement(e);t.async=!0;
          t.src=v;s=b.getElementsByTagName(e)[0];
          s.parentNode.insertBefore(t,s)}(window, document,'script',
          'https://connect.facebook.net/en_US/fbevents.js');
          fbq('init', '541128865200351');
          fbq('track', 'PageView');
      `;
    }
  }

  public getCountryCode() {
    let p = localStorage.getItem("countryCode");
    if(p) {
        return p;
    }
    else {
        return null;
    }
  }

   public getCountry() {
    // return this.http.get("https://ipwhois.app/json/");
    let $key = "1b423b048094058033ce00a32627848eef653089f964b5870868e95f";
    return this.http.get(`https://api.ipdata.co?api-key=${$key}`);
  }

  // public messageError(message: any, title: string = "") {
  //   this.messageService.clear()
  //   this.messageService.add(
  //     {
  //       severity: 'error',
  //       summary: title,
  //       detail: message
  //     })
  // }

  // public messageWarning(message: any, title: string = "") {
  //   this.messageService.clear()
  //   this.messageService.add(
  //     {
  //       severity: 'warn',
  //       summary: title,
  //       detail: message
  //     })
  // }

  // public messageSuccess(message: any, title: string = "") {
  //   this.messageService.clear()
  //   this.messageService.add(
  //     {
  //       severity: 'success',
  //       summary: title,
  //       detail: message
  //     })
  // }

  // public mensajeSimple(tipo: any = '', titulo: any = '', mensaje: any = '', tiempo: number = 5000) {
  //   switch (tipo) {
  //     case TIPOS_MENSAJE_MESSAGESERVICE.EXITOSO:
  //       this.messageSuccess(mensaje, titulo);
  //       break;
  //     case TIPOS_MENSAJE_MESSAGESERVICE.ADVERTENCIA:
  //       this.messageWarning(mensaje, titulo);
  //       break;
  //     case TIPOS_MENSAJE_MESSAGESERVICE.ERROR:
  //       this.messageError(mensaje, titulo);
  //       break;
  //   }
  // }

  // public handleError(errorServidor: any) {
  //   let mensajeError: any;
  //   if (errorServidor.error instanceof ErrorEvent) {
  //     mensajeError = `Ocurrio un error: ${errorServidor.error.message}`;

  //   }else if(errorServidor && errorServidor.length && errorServidor.length>0){
  //     mensajeError = errorServidor;
  //   }else {
  //     mensajeError = `Backend retorno el codigo de error ${errorServidor.status}: ${errorServidor.message}`;
  //   }
  //   //console.log('message,error',mensajeError);
  //   // this.messageError(mensajeError);
  // }
  public async handleError(errorServidor: any) {

    let mensajeError: string;

    if (errorServidor.error instanceof ErrorEvent) {

      mensajeError = `Ocurrio un error: ${errorServidor.error.message}`;
      //this.toastrService.error(mensajeError);
    } else {
      // mensajeError = `Backend retorno el codigo de error ${errorServidor.status}: ${errorServidor.message}`;
    }
  }



  public validadorFormularioGeneral(currentVariables: any, formulario: any) {

    let hasError: boolean = false;
    Object.keys(formulario.controls).forEach(key => {
      const control: any = formulario.get(key)
      if (control.errors != null && hasError == false) {
        hasError = true;
        currentVariables[key].error = true;
       // console.log("aqui", currentVariables)
        if (control.errors.required) {
          currentVariables[key].message = MESSAGE_VALIDATION.IS_REQUIRED;
        }
        if (control.errors.minlength) {
          currentVariables[key].message = '' + MESSAGE_VALIDATION.MIN + '' + control.errors.minlength.requiredLength + '' + MESSAGE_VALIDATION.CHARACTERS + '.';
        }
        if (control.errors.maxlength) {
          currentVariables[key].message = '' + MESSAGE_VALIDATION.MAX + '' + control.errors.maxlength.requiredLength + '' + MESSAGE_VALIDATION.CHARACTERS + '.';
        }
        // this.mensajeSimple(TIPOS_MENSAJE_MESSAGESERVICE.ERROR, currentVariables[key].label, currentVariables[key].message);
      } else {
        currentVariables[key].error = false;
        currentVariables[key].message = '';
      }
    });

    return currentVariables;
  }

  public limpiarFormularioGeneral(currentVariables: any,error = false){
    Object.keys(currentVariables).forEach(key => {
      currentVariables[key].error = false;
      currentVariables[key].message = '';
      if(error == false){
        currentVariables[key].value = null;
      }
    });
    return currentVariables;
  }

  public  parseDataFromRequest(currentVariables : any,currentDatos : any) {

    Object.keys(currentVariables).forEach(key => {
      currentVariables[key].value = currentDatos[key];
    });
    return currentVariables;
  }

  public parseDataToRequest(currentVariables : any) {
    let params: any = {}
    Object.keys(currentVariables).forEach(key => {
      params[key] = this.parseFormatToBDDate(key,currentVariables[key].value)
    });
    params['celularvalidar'] = params['celular'];
    params['celular'] = params['pais']["code"]+params['celular'];
    params.subdominio = params.nombrecomercial.toLowerCase();
    params.dominio    = "restaurant.pe";
    // params.apellidos  = "";
    params.ciudad     = "";
    params.idioma     = '';
    params.usuario    = '';

    return params;
  }

  public parseFormatToBDDate(nameKey : string, valor : any){
    // if(nameKey.includes('fecha') && valor!=null && valor!=""){
    //   const valorEntrada = valor;
    //   try{
    //     return moment(valor).format('YYYY-MM-DD');
    //   }catch(e){
    //     return valorEntrada;
    //   }
    // }

    if(nameKey.includes('codigopaistelefono') && valor!=null && valor!="")
    {
      const valorEntrada = this.getNombreArea(valor.code);
      return valorEntrada;
    }


    return valor;
  }


  // public convertDateToOnlyHour(fecha : string){
  //     const valorEntrada = fecha;
  //     try{
  //       return moment(fecha).format('HH:mm:ss');
  //     }catch(e){
  //       return valorEntrada;
  //     }
  //   return valorEntrada;
  // }


  public listDeleteValueDuplicateByKey(list : any,key : any){

    const removeDuplicates = (array : any, key : any) => {
      return array.reduce((arr:any, item: any) => {
        const removed = arr.filter((i:any) => i[key] !== item[key]);
        return [...removed, item];
      }, []);
    };

    return removeDuplicates(list, key)

  }

  public listDeleteValueDuplicate(list : any){

    const removeDuplicates = (array : any) => {
      return array.reduce((arr:any, item: any) => {
        const removed = arr.filter((i:any) => i !== item);
        return [...removed, item];
      }, []);
    };

    return removeDuplicates(list)

  }

  public getNombreArea(area : any){
    let nombreArea = "";
    switch(area){
      // peru
      case '+51':
        nombreArea = "51";
        break;
        // chile
      case '+56':
        nombreArea = "56";
          break;
        // colombia
      case '+57':
        nombreArea = "57";
          break;
        // costarica
      case '+506':
        nombreArea = "506";
          break;
        // ecuador
      case '+593':
        nombreArea = "593";
          break;
        // elsavador
      case '+503':
        nombreArea = "503";
          break;
        // guatemala
      case '+502':
        nombreArea = "502";
          break;
        // mexico
      case '+52':
        nombreArea = "52";
          break;
        // nicaragua
      case '+505':
        nombreArea = "505";
          break;
        // repdominic
      case '+1':
        nombreArea = "1";
          break;
        // venezuela
      case '+58':
        nombreArea = "58";
          break;
        // honduras
      case '+504':
        nombreArea = "504";
          break;
    }
    return nombreArea;
  }

  public getIdPais(num : any){
    let idpais = "";
    switch(num){
      // peru
      case '51':
        idpais = "1";
        break;
        // chile
      case '56':
        idpais = "8";
          break;
        // colombia
      case '57':
        idpais = "9";
          break;
        // costarica
      case '506':
        idpais = "3";
          break;
        // ecuador
      case '593':
        idpais = "10";
          break;
        // elsavador
      case '503':
        idpais = "11";
          break;
        // guatemala
      case '502':
        idpais = "13";
          break;
        // mexico
      case '52':
        idpais = "2";
          break;
        // nicaragua
      case '505':
        idpais = "4";
          break;
        // repdominic
      case '1':
        idpais = "12";
          break;
        // venezuela
      case '58':
        idpais = "15";
          break;
        // honduras
      case '504':
        idpais = "16";
          break;
          
    }
    return idpais;
  }


  public getpaisselected(num : any){
    let idpais = "PE";
    switch(num){
      case 'PE':
        idpais = "PE";
        break;
      case 'EC':
        idpais = "EC";
          break;
      case 'CL':
        idpais = "CL";
          break;
      case 'MX':
        idpais = "MX";
        break;
    }
    return idpais;
  }


  public validarCantidadDigitosNumeros(paisId: any, numero: any){

    let esunnumerovalido = true;

    switch(paisId){
      // PERU
      case '1':
        if(numero.length!=9){
          // this.messageError("El numero ingresado debe tener 9 digitos");
          esunnumerovalido = false;
        }
        break;

      // CHILE
      case '8':

        if(numero.length!=9){
          // this.messageError("El numero ingresado debe tener 9 digitos.");
          esunnumerovalido = false;
        }
        break;

      // COLOMBIA
      case '9':
        if(numero.length!=10){
          // this.messageError("El numero ingresado debe tener 10 digitos .");
          esunnumerovalido = false;
        }
        break;

      // GUATEMALA
      case '13':
        if(numero.length!=8){
          // this.messageError("El numero ingresado debe tener 8 digitos");
          esunnumerovalido = false;
        }
        break;

      // ECUADOR
      case '10':
        if(numero.length!=9){
          // this.messageError("El numero ingresado debe tener 9 digitos .");
          esunnumerovalido = false;
        }
        break;

      // COSTA RICA
      case '3':
        if(numero.length!=8){
          // this.messageError("El numero ingresado debe tener 8 digitos.");
          esunnumerovalido = false;
        }
        break;

      // REPUBLICA DOMINICANA
      case '12':
        if(numero.length!=10){
          // this.messageError("El numero ingresado debe tener 10 digitos");
          esunnumerovalido = false;
        }
        break;

      // MEXICO
      case '2':
        if(numero.length!=10){
          // this.messageError("El numero ingresado debe tener 10 digitos.");
          esunnumerovalido = false;
        }
        break;

    }
    return esunnumerovalido;
  }

}

