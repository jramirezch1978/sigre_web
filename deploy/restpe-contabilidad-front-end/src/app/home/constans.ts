export const HTTP_RESPONSE = {
    SUCCESS: '1',
    WARNING: '2',
    ERROR: '3',
    INFO: '4',
    HTTP_200_OK: '200',
    PERMISION_ERROR: '401',
    CODE_NOT_DEFINED: '601',
    MALFORMED_JSON: '701',
    ACCESS_DENIED: '403'
};


export enum PETICION {
    SIN_INICIALIZAR = '1',
    EN_PROCESO = '2',
    FINALIZADA = '3'
}

export const ENDPOINT = {
    /* REGISTER */
    POST_USER_TO_ZAPIER_AUX : "https://hooks.zapier.com/hooks/catch/16330533/2wv3e44/",
    // POST_USER_TO_ZAPIER : "https://aespinoza.app.n8n.cloud/webhook/88622eea-d5e4-4bcf-909c-a14608ca0aa9",
    POST_USER_TO_ZAPIER : "https://n8n.restaurant.pe/webhook/88622eea-d5e4-4bcf-909c-a14608ca0aa9",
    POST_REGISTER_USER : "https://billing.restaurant.pe/billing/m/rest/suscripcion/crearRestaurantMobile",
    // POST_REGISTER_USER: "https://hooks.zapier.com/hooks/catch/16330533/21rgdxn",
    POST_PUSH_COD: "https://billing.restaurant.pe/billing/public/rest/mobile/enviarCodigo",
    GET_PAISES: "https://billing.restaurant.pe/billing/public/rest/pais/getPaisesParaMobile",
    POST_WHAT: 'http://microservicechat.quipupos.com/service/public/rest/common/sendWhatAppMessage',
    GET_PAIS_TRAZA_ID: "https://web.restaurant.pe/trazabilidad/public/rest/common/getCountryByCode"
}

export const TIPOS_MENSAJE_MESSAGESERVICE = {
    ERROR: 'error',
    EXITOSO: 'success',
    ADVERTENCIA: 'warn',
};
    export const WHATSAPP_NUMBERS:any = {
        PE: "51984996941", // Perú
        DO: "18093963686", // República Dominicana
        CO: "573213922620", // Colombia
        CR: "50671053662", // Costa Rica
        EC: "593986449445", // Ecuador
        GT: "50239057991", // Guatemala
        MX: "50239057991", // México
        HD: "50239057991", // Honduras
        SV: "50366801187", // Nicaragua

        VN: "573153457744", // Venezuela
        NC: "573153457744", // Nicaragua

        DEFAULT: "51984996941" // Número por defecto (Perú en este caso)
  };

export enum MESSAGE_VALIDATION {
    DOCUMENT_LADO = 'Falta Imagen en el documento',
    ONE_IMAGE = 'Ingrese solo una Imagen para el documento : ',
    TWO_IMAGE = 'Solo puede seleccionar un maximo de dos imagenes para el documento : ',
    IMAGE_TITLE = 'IMAGEN',
    FORMAT_IMAGE = "Solo puede subir imagenes en formato '.jpg', '.jpeg', '.png' ",
    SIZE_LIMIT_IMAGE = 'La imagen no debe exceder el tamaño de ',
    FORMAT_SIZE = 'mb',
    REGISTER_TITLE = 'REGISTRO',
    INCOMPLETE_DATA = 'Complete los datos.',
    IS_REQUIRED = 'Es obligatorio.',
    MAX = 'Maximo',
    MIN = 'Minimo',
    DIGITS = 'digitos',
    CHARACTERS = 'caracteres',
    PASSWORD_TITLE = 'Contraseña',
    PASSWORD_MESSAGE = 'Contraseña incorrecta .',
    CONFIRM = 'Aceptar',
    CANCEL = 'Cancelar',
    CONFIRM_STATUS_MESSAGE_CANCEL = '¿ Seguro que desea rechazar la solicitud ? ',
    CONFIRM_STATUS_MESSAGE_OK = '¿ Seguro que desea aceptar la solicitud ? ',
    FECHA = 'Ingrese todas las fechas',
    FECHAS_DINAMIC_EMPTY = 'Debe ingresar al menos una fecha',
    UNIDADES_TRABAJO_DINAMIC_EMPTY = 'Debe ingresar al menos una unidad de trabajo',
    UNIDADES_TRABAJO = 'Ingrese todas las unidades de trabajo',
    EMAIL_PASSWORD_MESSAGE = 'Ingrese un email valido y una contraseña mayor a 6 caracteres',
    EMAIL_PASSWORD = 'Email / Password',
    GRUPO_LV_DINAMIC_EMPTY = 'Debe ingresar al menos un Grupo de Lista Verificacion',
    LV_DINAMIC_EMPTY = 'Debe ingresar al menos una lista verificacion',
    GRUPO_LISTAS_VERIFICACION = 'Ingrese todas los Grupos de Lv',


}


export const ALL_COUNTRIES = [
    {
        nombre: "Perú",
        imagen: "assets/images/header/desktop/bandera.svg",
        codigo: "PE",
        entidad: "SUNAT",
        simboloMoneda: "S/",
        tipoImpuesto: "IGV",
        valortributario: "UIT",
        tiposTributoSunat: [
            { value: 'igv', label: 'IGV' },
            { value: 'renta', label: 'Renta' },
            { value: 'essalud', label: 'ESSALUD' },
            { value: 'retenciones', label: 'Retenciones' },
            { value: 'onp', label: 'ONP' }
        ],
        regimenesdesalud:[
            { value: 'essalud', label: 'ESSALUD' },
            { value: 'eps', label: 'EPS' },
        ],
        tipoISelect: [
            { id: 'igv', nombre: 'IGV - Impuesto general a ventas' },
            { id: 'retenciones', nombre: 'Retenciones' },
            { id: 'percepciones', nombre: 'Percepciones' }
        ],
        jornadasLaborales: [
            { value: 'trabajo_maximo', label: 'Trabajo máximo' },
            { value: 'atipica_acumulativa', label: 'Atípica o acumulativa' },
            { value: 'horario_nocturno', label: 'Horario nocturno' },
        ],
        tiposIncidencia: [
            { label: 'Injustificada', value: 'Injustificada' },
            { label: 'Justificada', value: 'Justificada' },
            { label: 'Descanso médico', value: 'Descanso méd.' },
        ],
        libroscontables: [
            { label: 'Registro de ventas e ingresos', value: '014' },
            { label: 'Registro de compras', value: '008' },
            { label: 'Libro diario', value: '005' },
            { label: 'libro mayor', value: '006' },
            { label: 'Registro asientos auxiliares y cuentas corrientes', value: '001' }, 
        ],
        tiposCuenta: [
            { value: 'sueldo', label: 'Sueldo' },
            { value: 'cts', label: 'CTS' },
            { value: 'corriente', label: 'Corriente' },
            { value: 'ahorros', label: 'Ahorros' },
            { value: 'linea', label: 'Línea de crédito' },
            { value: 'otros', label: 'Otros' }
        ],
        tipoprovision:[
            {value:'1', label:'Vacaciones'},
            {value:'2', label:'Gratificación'},
            {value:'3', label:'CTS'},
            {value:'4', label:'Bonificaciones'},
        ],
        regimenesLaborales:[
            { value: '1', label: 'Regimen RUS' },
            { value: '2', label: 'Regimen MYPE' },
            { value: '3', label: 'Regimen Especial' },
            { value: '4', label: 'Regimen General' }
        ],
        archivoregulatorio: [
            {value: "1", label: 'Renta de 5ta'},
            {value: "2", label: 'Renta de 4ta'},
            {value: "3", label: 'Plame'},
            {value: "4", label: 'AFP net'},
        ],
        impuestosContribuciones: [
            { value: 'afp', label: 'Fondo de pensiones' },
            { value: 'quintaCategoria', label: 'Impuesto a la Renta - Quinta Categoría' },
        ],
        departamentos: [
            // { label: 'Lima', value: 'Lima' },
            // { label: 'Arequipa', value: 'Arequipa' },
            // { label: 'Cusco', value: 'Cusco' },
            // { label: 'Trujillo', value: 'Trujillo' },
            // { label: 'Chiclayo', value: 'Chiclayo' },
            { label: 'Piura', value: 'Piura',
                distritos: [
                    {value: 'talara', label: 'Talara'},
                    {value: 'sullana', label: 'Sullana'},
                ]
             },
            // { label: 'Iquitos', value: 'Iquitos' },
            // { label: 'Huancayo', value: 'Huancayo' },
            // { label: 'Tacna', value: 'Tacna' },
            // { label: 'Puno', value: 'Puno' }
        ],
        beneficiosasociados:[
            {value: '1',nombre: 'CTS'},
            {value: '2',nombre: 'Gratificación'},
            {value: '3',nombre: 'Vacaciones'},
        ],
        retencionesaltrabajador:[
            {value: 1 ,nombre: 'Renta 5ta categoria'},
            {value: 2 ,nombre: 'Renta 4ta categoria'},
            {value: 3 ,nombre: 'AFP/ONP'},
        ],
        aportesdelempleador:[
            // {value: '1' ,nombre: 'ESSALUD'},
            // {value: '2' ,nombre: 'SCRT'},
            { value: 1, nombre: 'Essalud' },
            { value: 2, nombre: 'EPS' },
            { value: 3, nombre: 'SCRT' },
        ],
        tiposjustificacion:[
            { label: 'Vacaciones', value: 'vacaciones' },
            { label: 'Permiso', value: 'permiso' },
            { label: 'Duplicada', value: 'duplicada' },
        ],
        tiposdecese: [
            { label: 'Renuncia', value: '1' },
            { label: 'Renuncia con incentivos', value: '2' },
            { label: 'Despido o destitución', value: '3' },
            { label: 'Cese colectivo', value: '4' },
            { label: 'Jubilación', value: '5' },
        ],
        librosfinancieros: [
            {value: "1", label: 'Estado de Situación Financiera'},  
            {value: "2", label: 'Estado de Resultados'},
            {value: "3", label: 'Estado de Flujo de Efectivos'},
            {value: "4", label: 'Estado de Cambios en el Patrimonio'},
        ],
        personalidadfiscal:[
            {id: 'persona' ,value: "dni",nombre: 'DNI', numero: 8},
            {id: 'empresa' ,value: "ruc",nombre: 'RUC', numero: 11},
            {id: 'personaext' ,value: "carnet",nombre: 'CE', numero: 12},
            {id: 'extranjero' ,value: "pasaporte",nombre: 'PAS', numero: 12},
        ],
        monedapais: [
            {value: "Soles",nombre: 'Soles',simbolo: "S/"},
            // {value: "USD",nombre: 'Dolares',simbolo: "$"}
        ],
        divisionesterritoriales: [
            { label: 'Departamento', value: 'departamento' },
            { label: 'Provincia', value: 'provincia' },
            { label: 'Distrito', value: 'distrito' }        
        ],
        tipodebeneficio:[
            { label: 'Gratificación', value: '1' },
            { label: 'CTS', value: '2' },  
            { label: 'Vacaciones', value: '2' },           
        ],
        tiposdoc:[
            { value: 'factura', nombre: 'Factura' },
            { value: 'boleta', nombre: 'Boleta' },
            { value: 'ncredito', nombre: 'Nota de crédito' },
            { value: 'ndebito', nombre: 'Nota de débito' },
            { value: 'recibohonorarios', nombre: 'Recibo por honorarios' },
            { value: 'ticket', nombre: 'Ticket' },
        ],
        formaspago: [
            { value: 'efectivo', nombre: 'Efectivo' },
            { value: 'transferencia', nombre: 'Transferencia' },
            { value: 'pos', nombre: 'POS' },
            { value: 'niubiz', nombre: 'Niubiz' },
            { value: 'yape', nombre: 'Yape' },
            { value: 'plin', nombre: 'Plin' },
        ],
        tipoIngresos: [
            { value: '1', nombre: 'Sueldo test ' },
            { value: '2', nombre: 'Asignaciones' },
            { value: '3', nombre: 'Propinas' },
            { value: '4', nombre: 'Horas extra' },
            { value: '5', nombre: 'Bono' },
            { value: '6', nombre: 'Comisiones' },
            { value: '7', nombre: 'Otros ingresos' },
            { value: '8', nombre: 'Metas' },
            { value: '9', nombre: 'Recargo al consumo' },
        ],
        tipoDescuentos: [
            { value: '1', nombre: 'Adelanto de sueldo' },
            { value: '2', nombre: 'Adelanto de gratificación' },
            { value: '3', nombre: 'Préstamo personal' },
        ],
        claseAportes: [
            { value: '1', nombre: 'Essalud' },
            { value: '2', nombre: 'SCTR' },
            { value: '3', nombre: 'Seguro ley de vida' },
        ],
        claseRetencion: [
            { value: '1', nombre: 'AFP' },
            { value: '2', nombre: 'ONP' },
            { value: '3', nombre: 'Renta de 5ta categoría' },
        ],
    },
    {
        nombre: "Chile",
        imagen: "assets/images/header/chile.svg",
        codigo: "CL",
        simboloMoneda: "$",
        tipoImpuesto: "IVA",
        moneda: "CLP",
    },
    {
        nombre: "Colombia",
        imagen: "assets/images/header/colombia.svg",
        codigo: "CO",
        simboloMoneda: "$",
        valortributario: "UVT",
        tipoImpuesto: "IVA",
        personalidadfiscal:[
            {id:'persona', value: "cc",nombre: 'CC', numero: 10},
            {id:'extranjero', value: "ce",nombre: 'CE', numero: 8},
            {id:'empresa',value: "nit",nombre: 'NIT', numero: 11},
        ],
        regimenesLaborales: [
            { value: '1', label: 'Régimen simple' },
            { value: '2', label: 'Régimen ordinario' },
            { value: '3', label: 'Régimen especial' },
        ],
        tiposTributoSunat: [
            { value: 'retencion_fuente', label: 'Retención de la fuente' },
            { value: 'isr', label: 'IVA' },
            { value: 'pila', label: 'PILA' },
            { value: 'ica', label: 'ICA' }
        ],
        archivoregulatorio: [
            { value: "1", label: 'Nómina Electrónica' },
            { value: "2", label: 'Planilla PILA' },
            { value: "3", label: 'Formulario 220' },
            { value: "4", label: 'Reporte de Cesantías' },
        ],
        regimenesdesalud:[
            { value: 'eps', label: 'EPS' },
        ],
        jornadasLaborales: [
            { value: 'trabajo_maximo', label: 'Trabajo máximo' },
            { value: 'atipica_acumulativa', label: 'Atípica o acumulativa' },
            { value: 'horario_nocturno', label: 'Horario nocturno' },
        ],
        tiposjustificacion: [
            { label: 'Vacaciones', value: 'vacaciones' },
            { label: 'Licencia de Luto', value: 'LUTO' },
            { label: 'Licencia de Maternidad', value: 'MATERNIDAD' },
            { label: 'Licencia de Paternidad', value: 'PATERNIDAD' },
            { label: 'Licencia de Matrimonio', value: 'MATRIMONIO' },
            { label: 'Cita Médica', value: 'CITA_MEDICA' },
            { label: 'Grave Calamidad Doméstica', value: 'GRAVE_CALAMIDAD_DOMESTICA' }
        ],
        libroscontables: [
            { value: 'librodiario', label: 'Libro Diario' },
            { value: 'libromayor', label: 'Libro Mayor' },
            { value: 'libroinventarios', label: 'Libro de Inventarios' }
        ],
        tiposIncidencia: [
            { label: 'Injustificada', value: 'Injustificada' },
            { label: 'Justificada', value: 'Justificada' },
            { label: 'Incapacidad Médica', value: 'Incapacidad Médica' },
        ],
        
        librosfinancieros: [
            {value: "1", label: 'Estado de Situación Financiera'},  
            {value: "2", label: 'Estado de Resultados'},
            {value: "3", label: 'Estado de Flujo de Efectivos'},
            {value: "4", label: 'Estado de Cambios en el Patrimonio'},
        ],
        tiposdoc:[
            {value: "facturaelectronica",nombre: 'Factura electrónica de venta'},
            {value: "facturaelectronica",nombre: 'Documento equivalente POS'},
            {value: "docsoporte",nombre: 'Documento soporte en adquisiciones a no obligados a facturar'},
            {value: "docnomina",nombre: 'Documento soporte de nómina electrónica'},
            {value: "docelectronico",nombre: 'Documento equivalente electrónico (otros)'},
            {value: "comprobanteegreso",nombre: 'Comprobante de egreso'},
            {value: "recibocaja",nombre: 'Recibo de caja'},
            {value: "ordendecompra",nombre: 'Orden de compra'},
            {value: "remisionguia",nombre: 'Remisión / Guía de despacho'},
        ],
        divisionesterritoriales: [
            { label: 'Departamento', value: 'departamento' },
            { label: 'Municipio', value: 'municipio' }        
        ],
        formaspago: [
            {value: "efectivo",nombre: 'Efectivo'},
            {value: "tarjetadebito",nombre: 'Tarjeta Débito'},
            {value: "tarjetacredito",nombre: 'Tarjeta Crédito'},
            {value: "transferencia",nombre: 'Transferencia Bancaria'},
            {value: "pse",nombre: 'PSE'},
            {value: "credito",nombre: 'Crédito'},
            {value: "billeteradigital",nombre: 'Billetera Digital'},
            {value: "pagoqr",nombre: 'Pago QR Interoperable'},
            {value: "cheque",nombre: 'Cheque'},
            {value: "créditocomercial",nombre: 'Crédito Comercial'},
        ],
        beneficiosasociados:[
            {value: "1",nombre: 'Cesantías'},
            {value: "2",nombre: 'Prima de servicios'},
            {value: "3",nombre: 'Vacaciones'},
        ],
        retencionesaltrabajador:[
            {value: 1 ,nombre: 'Salud'},
            {value: 2 ,nombre: 'Pensión'},
            {value: 3 ,nombre: 'Retención en la fuente'},
        ],
        aportesdelempleador:[
            {value: '1' ,nombre: 'Salud'},
            {value: '2' ,nombre: 'Pensión'},
            {value: '3' ,nombre: 'ARL'},
            {value: '4' ,nombre: 'Parafiscales'},
        ],
        monedapais: [
            {value: "COP",nombre: 'Pesos colombianos',simbolo: "$"},
            {value: "USD",nombre: 'Dolares',simbolo: "$"}
        ],
        entidad: "DIAN",
    },
    {
        nombre: "Costa Rica",
        imagen: "assets/images/header/costarica.svg",
        codigo: "CR",
        simboloMoneda: "$",
        moneda: "USD",
        tipoImpuesto: "IVA",
    },
    {
        nombre: "Ecuador",
        imagen: "assets/images/header/ecuador.svg",
        codigo: "EC",
        simboloMoneda: "$",
        tipoImpuesto: "IVA",
        regimendesalud: 'IESS',
        jornadasLaborales: [
            { value: 'trabajo_maximo', label: 'Trabajo máximo' },
            { value: 'atipica_acumulativa', label: 'Atípica o acumulativa' },
            { value: 'horario_nocturno', label: 'Horario nocturno' },
            { value: 'jornada_parcial', label: 'Jornada Parcial' },
        ],
        tipoprovision: [
            { value: "1", label: 'Décima tercero' },
            { value: "2", label: 'Décima cuarto' },
            { value: "3", label: 'Fondo de reserva' },
        ],
        regimenesLaborales: [
            { value: '1', label: 'RIMPE Negocios Populares' },
            { value: '2', label: 'RIMPE Emprendedores' },
            { value: '3', label: 'Régimen General' },
            { value: '4', label: 'Sociedades' },
            { value: '5', label: 'Contribuyente Especial' },
        ],

        archivoregulatorio: [
            {value: "1", label: 'Planillas de Aportes IESS'},
            {value: "2", label: 'Avisos de entrada y salida'},
            {value: "3", label: 'Acta de finiquito'},
            {value: "4", label: 'Formulario 107'},
            {value: "5", label: 'Declaración de décimos'},
            {value: "6", label: 'RDEP'},
            // {value: "4", label: 'Bono 14'},
            // {value: "5", label: 'Aguinaldo'},
        ],
        tiposTributoSunat: [
            { value: 'iva', label: 'IVA' },
            { value: 'impuesto_renta', label: 'Impuesto a la renta' },
            { value: 'isr', label: 'ISR' },
            { value: 'iess', label: 'IESS' },
            { value: 'contribucion_societaria', label: 'Contribución societaria' }
        ],
        tipoISelect: [
            { id: 'iva', nombre: 'IVA' },
            { id: 'isr', nombre: 'ISR' },
            { id: 'retenciones', nombre: 'Retenciones' }
        ],
        tiposCuenta: [
            { value: 1, label: 'Cuenta corriente' },
            { value: 2, label: 'Cuenta de ahorro' },
        ],
        regimenesdesalud:[
            { value: 'iess', label: 'IESS' },
            { value: 'seguroprivado', label: 'Seguro privado' },
        ],
        personalidadfiscal:[
            {id: 'persona',value: "ci",nombre: 'CI', numero: 10},
            {id: 'empresa',value: "ruc",nombre: 'RUC', numero: 13},
            {id: 'extranjero',value: "PAS",nombre: 'PAS', numero: 10},
        ],
        provincias: [
            {value: "1", nombre: 'Pichincha'},
        ],
        tiposIncidencia: [
            { label: 'Injustificada', value: 'Injustificada' },
            { label: 'Justificada', value: 'Justificada' },
            { label: 'Descanso médico', value: 'Descanso méd.' },
        ],
        beneficiosasociados:[
            {value: "1",nombre: 'Décimo tercero'},
            {value: "2",nombre: 'Décimo cuarto'},
            {value: "3",nombre: 'Vacaciones'},
            {value: "4",nombre: 'Fondo de reserva'},
        ],
        retencionesaltrabajador:[
            {value: 1 ,nombre: 'Aporte personal IESS'},
            {value: 2 ,nombre: 'Extención conyugal IESS'},
            {value: 3 ,nombre: 'Impuesto a la Renta'},
        ],
        aportesdelempleador:[
            {value: 1 ,nombre: 'Aporte patronal IESS'},
            {value: 2 ,nombre: 'Otros aportes'},
        ],
        canton:[
            {value : '1' , nombre: 'Quito'},
        ],
        librosfinancieros: [
            {value: "1", label: 'Estado de Situación Financiera'},  
            {value: "2", label: 'Estado de Resultados'},
            {value: "3", label: 'Estado de Flujo de Efectivo'},
            {value: "4", label: 'Estado de Cambios en el Patrimonio'},
        ],
        divisionesterritoriales: [
            { label: 'Provincia', value: 'provincia' },
            { label: 'Cantón', value: 'canton' },
            { label: 'Parroquia', value: 'parroquia' }        
        ],
        libroscontables: [
                { value: 'LIBRO_VENTAS', label: 'Libro de Ventas' },
                { value: 'LIBRO_COMPRAS', label: 'Libro de Compras' },
                { value: 'LIBRO_RETENCIONES', label: 'Libro de Retenciones' },
                { value: 'ATS', label: 'ATS – Anexo Transaccional Simplificado' },
                { value: 'RESULTADOS_EJERCICIO', label: 'Resultados del ejercicio' },
                { value: 'LIBRO_DIARIO', label: 'Libro Diario' },
                { value: 'LIBRO_MAYOR', label: 'Libro Mayor' },
                { value: 'LIBRO_INVENTARIOS_BALANCES', label: 'Libro de Inventarios y Balances' }
        ],
        tiposjustificacion: [
        { label: 'Vacaciones', value: 'VACACIONES' },
        { label: 'Calamidad Doméstica', value: 'CALAMIDAD_DOMESTICA' },
        { label: 'Cita Médica IESS', value: 'CITA_MEDICA_IESS' },
        { label: 'Licencia por Paternidad/Maternidad', value: 'PATERNIDAD_MATERNIDAD' },
        { label: 'Cuidado de Cargas Familiares', value: 'CUIDADO_CARGAS_FAMILIARES' },
        { label: 'Otros', value: 'OTROS' },
        ],
        monedapais: [
            {value: "USD",nombre: 'Dolares',simbolo: "$"}
        ],
        tiposdoc:[
            {value: "facturaelectronica",nombre: 'Factura'},
            {value: "notadeventa",nombre: 'Nota de venta'},
            // {value: "liquidacioncompras",nombre: 'Liquidación de Compras de Bienes y Prestación de Servicios'},
            // {value: "retencion",nombre: 'Comprobante de Retención'},
        ],
        formaspago: [
            {value: "efectivo",nombre: 'Efectivo'},
            {value: "tarjetacredito",nombre: 'Tarjeta Crédito'},
            {value: "credito",nombre: 'Crédito'},
            {value: "tarjetadebito",nombre: 'Tarjeta Débito'},
            {value: "transferencia",nombre: 'Transferencia'},
            {value: "credito",nombre: 'Crédito'},
            {value: "billeteradigital",nombre: 'Billetera Digital'},
            {value: "cheque",nombre: 'Cheque'},
        ],
        entidad: "SRI",
    },
    {
        nombre: "El Salvador",
        imagen: "assets/images/header/elsalvador.svg",
        codigo: "SV",
        simboloMoneda: "$",
        moneda: "USD",
        tipoImpuesto: "IVA",
    },
    {
        nombre: "Guatemala",
        imagen: "assets/images/header/guatemala.svg",
        codigo: "GT",
        simboloMoneda: "Q",
        tipoImpuesto: "IVA",
        entidad: 'SAT',
        jornadasLaborales: [
            { value: 'trabajo_maximo', label: 'Trabajo máximo' },
            { value: 'atipica_acumulativa', label: 'Atípica o acumulativa' },
            { value: 'horario_nocturno', label: 'Horario nocturno' },
        ],
        tiposTributoSunat: [
            { value: 'isr', label: 'ISR' },
            { value: 'isr', label: 'IVA' },
            { value: 'igss', label: 'IGSS' },
            { value: 'iso', label: 'ISO' }
        ],
        monedapais: [
            {value: "GTQ",nombre: 'Quetzales',simbolo: "Q"}
        ],
        regimenesLaborales:[
            { value: '1', label: 'Régimen general' },
            { value: '2', label: 'Pequeño contribuyente' }
        ],
        divisionesterritoriales: [
            { label: 'Departamento', value: 'departamento' },
            { label: 'Municipio', value: 'municipio' }        
        ],
        tiposIncidencia: [
            { label: 'Injustificada', value: 'Injustificada' },
            { label: 'Justificada', value: 'Justificada' },
            { label: 'Suspensiones del IGSS', value: 'Suspensiones del IGSS' },
        ],

        tiposjustificacion:[
            { label: 'Vacaciones', value: 'VACACIONES' },
            { label: 'Licencia por Fallecimiento', value: 'FALLECIMIENTO' },
            { label: 'Licencia por Matrimonio', value: 'MATRIMONIO' },
            { label: 'Licencia por Nacimiento de Hijo', value: 'NACIMIENTO_HIJO' },
            { label: 'Citación Judicial o Administrativa', value: 'CITACION_JUDICIAL_ADMIN' },
            { label: 'Cita Médica IGSS', value: 'CITA_MEDICA_IGSS' },
            { label: 'Academia', value: 'academia' },
            { label: 'Licencia por Maternidad', value: 'MATERNIDAD' },
            { label: 'Licencia por Paternidad', value: 'PATERNIDAD' }
        ],
        regimendesalud: 'IGSS',
        tiposdecese:[
            {label: "Renuncia", value: "2"},
            {label: "Renuncia con insentivos", value: "1"},
            {label: "Despido", value: "3"},
        ],
        tiposCuenta: [
            { value: 1, label: 'Ahorro' },
            { value: 2, label: 'Monetaria' },
        ],
        impuestosContribuciones: [
            { value: 'quintaCategoria', label: 'Impuesto sobre la Renta' },
            { value: 'salud', label: 'Salud' },
        ],
        tipoprovision:[
            {value: "1",label: 'Bono 14'},
            {value: "2",label: 'Aguinaldo'},
            {value: "3",label: 'Vacaciones'},
            {value: "4",label: 'Indemnización'},
        ],
        beneficiosasociados:[
            {value: "1",nombre: 'Bono 14'},
            {value: "2",nombre: 'Aguinaldo'},
            {value: "3",nombre: 'Vacaciones'},
        ],
        librosfinancieros: [
            {value: "1", label: 'Estado de Situación Financiera'},  
            {value: "2", label: 'Estado de Resultados'},
            {value: "3", label: 'Estado de flujos de Efectivo'},
            {value: "4", label: 'Estado de Cambios en el Patrimonio'},
        ],
        archivoregulatorio: [
            {value: "1", label: 'IGSS'},
            {value: "2", label: 'Retención de ISR'},
            {value: "3", label: 'Libro de salarios'},
            // {value: "4", label: 'Bono 14'},
            // {value: "5", label: 'Aguinaldo'},
        ],
        libroscontables: [
            { value: 'LIBRO_INVENTARIOS', label: 'Libro de Inventarios' },
            { value: 'LIBRO_DIARIO', label: 'Libro Diario' },
            { value: 'LIBRO_MAYOR', label: 'Libro Mayor' },
            { value: 'LIBRO_ESTADOS_FINANCIEROS', label: 'Libro de Estados Financieros' },
            { value: 'LIBRO_COMPRAS_IVA', label: 'Libro de Compras (IVA)' },
            { value: 'LIBRO_VENTAS_IVA', label: 'Libro de Ventas (IVA)' }
        ],
        personalidadfiscal:[
            {id:'persona',value: "dpi",nombre: 'DPI', numero: 13},
            {id:'empresa',value: "nit",nombre: 'NIT', numero: 10},
        ],
        tiposdoc:[
            {value: "factura",nombre: 'Factura'},
            {value: "recibos",nombre: 'Recibos'},
            {value: "especiales",nombre: 'Facturas especiales'},
        ],
        retencionesaltrabajador:[
            {value: 1 ,nombre: 'ISR Asalariados'},
            {value: 2 ,nombre: 'IGSS Cuota laboral'},
        ],
        aportesdelempleador:[
            // {value: '1' ,nombre: 'IGSS asalariados'},
            // {value: '2' ,nombre: 'IGSS 12.67%'}
            {value: 1 ,nombre: 'IGSS Cuota patronal'},
            // {value: '2' ,nombre: 'Sin aporte patronal'},
        ],
        formaspago: [
            {value: "efectivo",nombre: 'Efectivo'},
            {value: "tarjetadebito",nombre: 'Tarjeta Débito'},
            {value: "tarjetacredito",nombre: 'Tarjeta Crédito'},
            {value: "transferencia",nombre: 'Transferencia Bancaria'},
            {value: "depositobancario",nombre: 'Deposito Bancario'},
            {value: "billeteradigital",nombre: 'Billetera Digital'},
            {value: "pagoqr",nombre: 'Pago QR Interoperable'},
            {value: "cheque",nombre: 'Cheque'},
            {value: "créditocomercial",nombre: 'Crédito Comercial'},
            {value: "opcional",nombre: 'Vale/Bono/Cortesía'},
            {value: "pagomixto",nombre: 'Pago Mixto'},
            {value: "pagomonedaextranjera",nombre: 'Pago en moneda extranjera (USD)'},
            {value: "descuento",nombre: 'Descuento por planilla'},

        ],
        tipoIngresos: [
            { value: '1', nombre: 'Sueldo base' },
            { value: '2', nombre: 'Sueldo ordinario' },
            { value: '3', nombre: 'Bonificación Decreto "37-2001"' },
            { value: '4', nombre: 'Bonificación Decreto "78-89"' },
            { value: '5', nombre: '(KPIs)' },
            { value: '6', nombre: 'Bono 14' },
            { value: '7', nombre: 'Aginaldo' },
            { value: '8', nombre: 'Horas extra' },
            { value: '9', nombre: 'Comisiones' },
            { value: '10', nombre: 'Propinas' },
            { value: '11', nombre: 'Recargo al consumo' },
            { value: '12', nombre: 'Vacaciones' },
        ],
        tipoDescuentos: [
            { value: '1', nombre: 'Adelanto de sueldo' },
            { value: '2', nombre: 'Adelanto de aguinaldo' },
            { value: '3', nombre: 'Préstamo personal' },
        ],
        claseAportes: [
            { value: '1', nombre: 'IGSS Patronal 10.67%' },
            { value: '2', nombre: 'Indemnización 8.33%' },
        ],
        claseRetencion: [
            { value: '1', nombre: 'IGSS Patronal 4.83%' },
            { value: '2', nombre: 'ISR Asalariados 5%' },
        ],
        tipodebeneficio:[
            {value: "1", label: 'Bono 14'},
            {value: "2", label: 'Aguinaldo'},
        ],
    },
    {
        nombre: "Mexico",
        imagen: "assets/images/header/mexico.svg",
        codigo: "MX",
        simboloMoneda: "$",
        tipoImpuesto: "IVA",
        moneda: "USD",
    },
    {
        nombre: "Nicaragua",
        imagen: "assets/images/header/nicaragua.svg",
        codigo: "NI",
        tipoImpuesto: "IVA",
        simboloMoneda: "$",
        moneda: "USD",
    },
    {
        nombre: "Republica Dominicana",
        imagen: "assets/images/header/republicadominicana.svg",
        codigo: "DO",
        tipoImpuesto: "ITBIS",
        simboloMoneda: "$",
        moneda: "DOP",
    },
    {
        nombre: "Venezuela",
        imagen: "assets/images/header/venezuela.svg",
        codigo: "VZ",
        tipoImpuesto: "IVA",
        simboloMoneda: "$",
        moneda: "USD",
    },
    {
        nombre: "Honduras",
        imagen: "assets/images/header/honduras.svg",
        codigo: "HD",
        tipoImpuesto: "IVA",
        simboloMoneda: "$",
        moneda: "USD",
    }
];
