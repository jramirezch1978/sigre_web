Perfecto, entiendo. Usar un **assembly .NET** es la mejor opción en tu caso. Te voy a guiar paso a paso para crear un wrapper .NET que consuma el servicio SOAP y lo uses desde PowerBuilder 2025.

## Paso 1: Crear el Proyecto .NET

### 1.1 En Visual Studio (2019 o superior)

bash

```bash
# Crear un nuevo proyecto Class Library (.NET Framework 4.8 o .NET 6/7/8)
# Nombre: SigreWebServiceWrapper
```

**Importante:** Usa **.NET Framework 4.8** para mejor compatibilidad con PowerBuilder, o **.NET 6/7/8** si usas PB 2025 con soporte .NET Core.

### 1.2 Agregar la Referencia del Servicio Web

En Visual Studio:

1. **Clic derecho en el proyecto** → **Add** → **Service Reference**
2. **Clic en "Advanced"** → **Add Web Reference**
3. **URL:** `http://sigre.serveftp.com:9090/WSLicensingSIGRE/ImplSigre?wsdl`
4. **Web reference name:** `SigreService`
5. **Clic en "Add Reference"**

## Paso 2: Crear la Clase Wrapper en C#

csharp

```csharp
usingSystem;
usingSystem.Runtime.InteropServices;
usingSigreWebServiceWrapper.SigreService;// Tu referencia web

namespaceSigreWebServiceWrapper
{
/// <summary>
/// Wrapper para consumir el servicio SOAP desde PowerBuilder
/// </summary>
[ComVisible(true)]
[ClassInterface(ClassInterfaceType.AutoDual)]
[ProgId("SigreWebServiceWrapper.LicensingService")]
publicclassLicensingService
{
privateImplSigreService _service;

publicLicensingService()
{
            _service =newImplSigreService();
}

/// <summary>
/// Valida el acceso de una empresa
/// </summary>
publicRespuestaValidacionValidarAcceso(
string empresa,
string pcName,
string ipLocal,
string ipPublica,
string userOS,
string versionOS,
string macAddress,
string serieRED,
string serieHDD)
{
try
{
var resultado = _service.validarAcceso(
                    empresa, pcName, ipLocal, ipPublica,
                    userOS, versionOS, macAddress, serieRED, serieHDD);

returnConvertirRespuesta(resultado);
}
catch(Exception ex)
{
returnnewRespuestaValidacion
{
                    IsOk =false,
                    Mensaje ="Error: "+ ex.Message
};
}
}

/// <summary>
/// Valida un usuario de Housing
/// </summary>
publicRespuestaValidacionValidarUsrHousing(string usuario)
{
try
{
var resultado = _service.validarUsrHousing(usuario);
returnConvertirRespuesta(resultado);
}
catch(Exception ex)
{
returnnewRespuestaValidacion
{
                    IsOk =false,
                    Mensaje ="Error: "+ ex.Message
};
}
}

/// <summary>
/// Valida módulos por empresa
/// </summary>
publicRespuestaValidacionValidarModulosPorEmpresa(string empresa)
{
try
{
var resultado = _service.validarModulosPorEmpresa(empresa);
returnConvertirRespuesta(resultado);
}
catch(Exception ex)
{
returnnewRespuestaValidacion
{
                    IsOk =false,
                    Mensaje ="Error: "+ ex.Message
};
}
}

/// <summary>
/// Valida módulo y empresa
/// </summary>
publicRespuestaValidacionValidarModuloEmpresa(string empresa,string modulo)
{
try
{
var resultado = _service.validarModuloEmpresa(empresa, modulo);
returnConvertirRespuesta(resultado);
}
catch(Exception ex)
{
returnnewRespuestaValidacion
{
                    IsOk =false,
                    Mensaje ="Error: "+ ex.Message
};
}
}

/// <summary>
/// Valida módulos de housing
/// </summary>
publicRespuestaValidacionValidarModulosHousing(string[] empresas)
{
try
{
var resultado = _service.validarModulosHousing(empresas);
returnConvertirRespuesta(resultado);
}
catch(Exception ex)
{
returnnewRespuestaValidacion
{
                    IsOk =false,
                    Mensaje ="Error: "+ ex.Message
};
}
}

/// <summary>
/// Convierte la respuesta del servicio a un formato simple para PowerBuilder
/// </summary>
privateRespuestaValidacionConvertirRespuesta(strRespuesta respuesta)
{
var resultado =newRespuestaValidacion
{
                IsOk = respuesta.isOk,
                Mensaje = respuesta.mensaje ??"",
                Contador = respuesta.contador,
                Count = respuesta.count,
                Id = respuesta.id
};

// Convertir lista si existe
if(respuesta.lista !=null&& respuesta.lista.Length >0)
{
                resultado.Lista = respuesta.lista;
}

// Convertir módulos si existen
if(respuesta.modulos !=null&& respuesta.modulos.Length >0)
{
                resultado.Modulos =newModuloInfo[respuesta.modulos.Length];
for(int i =0; i < respuesta.modulos.Length; i++)
{
                    resultado.Modulos[i]=newModuloInfo
{
                        ModuloId = respuesta.modulos[i].moduloId,
                        Codigo = respuesta.modulos[i].codigo ??"",
                        Descripcion = respuesta.modulos[i].descripcion ??"",
                        FlagEstado = respuesta.modulos[i].flagEstado ??"",
                        FlagAcceso = respuesta.modulos[i].flag_acceso ??"",
                        Icono = respuesta.modulos[i].icono ??""
};
}
}

return resultado;
}
}

/// <summary>
/// Clase de respuesta simplificada para PowerBuilder
/// </summary>
[ComVisible(true)]
[ClassInterface(ClassInterfaceType.AutoDual)]
publicclassRespuestaValidacion
{
publicbool IsOk {get;set;}
publicstring Mensaje {get;set;}
publicint Contador {get;set;}
publicint Count {get;set;}
publicint Id {get;set;}
publicstring[] Lista {get;set;}
publicModuloInfo[] Modulos {get;set;}

publicRespuestaValidacion()
{
            Mensaje ="";
            Lista =newstring[0];
            Modulos =newModuloInfo[0];
}
}

/// <summary>
/// Información de módulo simplificada
/// </summary>
[ComVisible(true)]
[ClassInterface(ClassInterfaceType.AutoDual)]
publicclassModuloInfo
{
publicint ModuloId {get;set;}
publicstring Codigo {get;set;}
publicstring Descripcion {get;set;}
publicstring FlagEstado {get;set;}
publicstring FlagAcceso {get;set;}
publicstring Icono {get;set;}

publicModuloInfo()
{
            Codigo ="";
            Descripcion ="";
            FlagEstado ="";
            FlagAcceso ="";
            Icono ="";
}
}
}
```

## Paso 3: Configurar el Proyecto para COM Interop

### 3.1 En el archivo `.csproj`, agregar:

xml

```xml
<PropertyGroup>
<RegisterForComInterop>true</RegisterForComInterop>
<ComVisible>true</ComVisible>
<TargetFramework>net48</TargetFramework>
</PropertyGroup>
```

### 3.2 Crear el archivo `AssemblyInfo.cs`:

csharp

```csharp
usingSystem.Runtime.InteropServices;

[assembly:ComVisible(true)]
[assembly:Guid("12345678-1234-1234-1234-123456789ABC")]// Genera un GUID único
```

## Paso 4: Compilar y Registrar el Assembly

bash

```bash
# 1. Compilar en Release
dotnet build -c Release

# 2. Registrar para COM (ejecutar como Administrador)
cd bin\Release\net48
regasm SigreWebServiceWrapper.dll /tlb:SigreWebServiceWrapper.tlb /codebase
```

## Paso 5: Usar en PowerBuilder 2025

### 5.1 Crear la nueva clase `n_cst_licensing_net.sru`:

powerscript

```powerscript
$PBExportHeader$n_cst_licensing_net.sru
forward
global type n_cst_licensing_net from nonvisualobject
end type
end forward

global type n_cst_licensing_net from nonvisualobject
end type
global n_cst_licensing_net n_cst_licensing_net

type variables
OLEObject iole_service
boolean ib_internet_verificado = false
end variables

forward prototypes
public function boolean of_validar (string as_empresa)
public function ws_strrespuesta of_validar_usuario (string ls_cod_usuario)
public function ws_strrespuesta of_validar_modulos_housing (str_empresas str_param)
public function ws_strrespuesta of_validar_modulo_empresa (string ls_cod_usuario, string ls_cod_modulo)
public function ws_strrespuesta of_validar_modulos_por_empresa (string as_empresa)
public function boolean of_valida_internet ()
public function string of_get_usuario ()
private function boolean of_inicializar_servicio ()
end prototypes

private function boolean of_inicializar_servicio ();
// Inicializa el servicio .NET
integer li_ret

TRY
    iole_service = CREATE OLEObject
    li_ret = iole_service.ConnectToNewObject("SigreWebServiceWrapper.LicensingService")
  
    IF li_ret <> 0 THEN
        MessageBox("Error", "No se pudo crear el objeto COM. Código: " + String(li_ret) + &
                   "~r~n~r~nAsegúrese de que el assembly esté registrado con RegAsm.", StopSign!)
        RETURN FALSE
    END IF
  
    RETURN TRUE
  
CATCH (RuntimeError er)
    MessageBox("Error", "Error al inicializar servicio: " + er.getMessage(), StopSign!)
    RETURN FALSE
END TRY

end function

public function boolean of_validar (string as_empresa);
String ls_PCName, ls_ipLocal, ls_MacAddress, ls_SerieRED, ls_SerieHDD
String ls_UserOS, ls_VersionOS
OLEObject lole_respuesta

TRY
    // Validar internet
    IF NOT of_valida_internet() THEN
        MessageBox("Error", "No hay conexión a internet", Exclamation!)
        RETURN FALSE
    END IF
  
    // Inicializar servicio si no está creado
    IF IsNull(iole_service) THEN
        IF NOT of_inicializar_servicio() THEN RETURN FALSE
    END IF
  
    // Obtener datos del sistema (usa tus funciones existentes)
    // ls_PCName = of_obtener_pc()
    // ls_UserOS = of_get_usuario()
    // ... etc
  
    // Llamar al servicio .NET
    gnvo_wait.of_mensaje("Validando licencia...")
  
    lole_respuesta = iole_service.ValidarAcceso(as_empresa, ls_PCName, ls_ipLocal, "", &
                                                  ls_UserOS, ls_VersionOS, ls_MacAddress, &
                                                  ls_SerieRED, ls_SerieHDD)
  
    IF NOT lole_respuesta.IsOk THEN
        MessageBox('Error', 'Equipo no válido. Mensaje: ' + lole_respuesta.Mensaje, Exclamation!)
        RETURN FALSE
    ELSE
        RETURN TRUE
    END IF
  
CATCH (RuntimeError er)
    MessageBox("Error", "Error en validación: " + er.getMessage(), StopSign!)
    RETURN FALSE
END TRY

end function

public function ws_strrespuesta of_validar_usuario (string ls_cod_usuario);
ws_strrespuesta rpta
OLEObject lole_respuesta
integer li_i

TRY
    IF NOT of_valida_internet() THEN
        MessageBox("Error", "No hay conexión a internet", Exclamation!)
        RETURN rpta
    END IF
  
    IF IsNull(iole_service) THEN
        IF NOT of_inicializar_servicio() THEN RETURN rpta
    END IF
  
    gnvo_wait.of_mensaje("Validando usuario " + ls_cod_usuario + "...")
    yield()
  
    lole_respuesta = iole_service.ValidarUsrHousing(ls_cod_usuario)
  
    // Convertir respuesta .NET a estructura PowerBuilder
    rpta.isOk = lole_respuesta.IsOk
    rpta.mensaje = lole_respuesta.Mensaje
    rpta.contador = lole_respuesta.Contador
    rpta.count = lole_respuesta.Count
    rpta.id = lole_respuesta.Id
  
    // Copiar array de lista si existe
    IF lole_respuesta.Lista.Length > 0 THEN
        FOR li_i = 0 TO lole_respuesta.Lista.Length - 1
            rpta.lista[li_i + 1] = lole_respuesta.Lista[li_i]
        NEXT
    END IF
  
    RETURN rpta
  
CATCH (RuntimeError er)
    MessageBox("Error", "Error validando usuario: " + er.getMessage(), StopSign!)
    RETURN rpta
END TRY

end function

public function ws_strrespuesta of_validar_modulo_empresa (string ls_cod_usuario, string ls_cod_modulo);
ws_strrespuesta rpta
OLEObject lole_respuesta

TRY
    IF NOT of_valida_internet() THEN
        MessageBox("Error", "No hay conexión a internet", Exclamation!)
        RETURN rpta
    END IF
  
    IF IsNull(iole_service) THEN
        IF NOT of_inicializar_servicio() THEN RETURN rpta
    END IF
  
    gnvo_wait.of_mensaje("Validando Módulo / Empresa...")
    yield()
  
    lole_respuesta = iole_service.ValidarModuloEmpresa(ls_cod_usuario, ls_cod_modulo)
  
    rpta.isOk = lole_respuesta.IsOk
    rpta.mensaje = lole_respuesta.Mensaje
  
    RETURN rpta
  
CATCH (RuntimeError er)
    MessageBox("Error", "Error validando módulo: " + er.getMessage(), StopSign!)
    RETURN rpta
END TRY

end function

public function ws_strrespuesta of_validar_modulos_por_empresa (string as_empresa);
ws_strrespuesta rpta
OLEObject lole_respuesta
integer li_i
ws_beanModulo lstr_modulo

TRY
    IF NOT of_valida_internet() THEN
        MessageBox("Error", "No hay conexión a internet", Exclamation!)
        RETURN rpta
    END IF
  
    IF IsNull(iole_service) THEN
        IF NOT of_inicializar_servicio() THEN RETURN rpta
    END IF
  
    lole_respuesta = iole_service.ValidarModulosPorEmpresa(as_empresa)
  
    rpta.isOk = lole_respuesta.IsOk
    rpta.mensaje = lole_respuesta.Mensaje
  
    // Convertir módulos
    IF lole_respuesta.Modulos.Length > 0 THEN
        FOR li_i = 0 TO lole_respuesta.Modulos.Length - 1
            lstr_modulo.moduloId = lole_respuesta.Modulos[li_i].ModuloId
            lstr_modulo.codigo = lole_respuesta.Modulos[li_i].Codigo
            lstr_modulo.descripcion = lole_respuesta.Modulos[li_i].Descripcion
            lstr_modulo.flagEstado = lole_respuesta.Modulos[li_i].FlagEstado
            lstr_modulo.flag_acceso = lole_respuesta.Modulos[li_i].FlagAcceso
            lstr_modulo.icono = lole_respuesta.Modulos[li_i].Icono
          
            rpta.modulos[li_i + 1] = lstr_modulo
        NEXT
    END IF
  
    RETURN rpta
  
CATCH (RuntimeError er)
    MessageBox("Error", "Error obteniendo módulos: " + er.getMessage(), StopSign!)
    RETURN rpta
END TRY

end function

public function boolean of_valida_internet ();
// Mantén tu implementación actual
RETURN TRUE
end function

public function string of_get_usuario ();
// Mantén tu implementación actual
RETURN ""
end function

on n_cst_licensing_net.create
call super::create
TriggerEvent(this, "constructor")
end on

on n_cst_licensing_net.destroy
TRY
    IF NOT IsNull(iole_service) THEN
        iole_service.DisconnectObject()
    END IF
CATCH (RuntimeError er)
    // Ignorar errores al destruir
END TRY

TriggerEvent(this, "destructor")
call super::destroy
end on
```

## Paso 6: Reemplazar en tu Código

En `integrador.sra` y otros lugares donde uses `n_cst_licensing`, simplemente cambia:

powerscript

```powerscript
// ANTES:
n_cst_licensing invo_licensing

// AHORA:
n_cst_licensing_net invo_licensing
```

## Ventajas de este Enfoque

1. ✅ **No cambias el API SOAP** - sigue funcionando igual
2. ✅ **Compatibilidad total** con PowerBuilder 2025
3. ✅ **Fácil mantenimiento** - cambios en .NET no afectan PB
4. ✅ **Mejor manejo de errores** - control completo en C#
5. ✅ **Reutilizable** - puedes usar el mismo assembly en otros proyectos

## Notas Importantes

* **Ejecuta Visual Studio como Administrador** para registrar el COM
* **Distribuye el DLL** junto con tu aplicación PowerBuilder
* **Si usas .NET 6+** , necesitas el runtime de .NET instalado en el cliente
* **Para .NET Framework 4.8** , está incluido en Windows 10/11

¿Necesitas ayuda con algún paso específico o tienes dudas sobre la implementación?


Perfecto, veo que tienes **otro servicio SOAP** (`ImplConsultaRUCService`) que consulta información de RUC desde SUNAT. Analicemos cómo migrarlo a PowerBuilder 2025.

## Análisis del Método Actual

El método `of_leer_ruc_externo()` hace lo siguiente:

1. Crea un `SoapConnection`
2. Conecta al servicio WSDL: `http://pegazus.serveftp.com:9080/SunatWebServices/ImplConsultaRUC?wsdl`
3. Llama al método `consultarPB()` del servicio
4. Retorna un objeto `BeanPadronRUC` con datos del RUC

## Solución: Actualizar el Assembly .NET

Ya que vas a crear un assembly .NET para el servicio de licencias, **agreguemos este servicio también** al mismo proyecto.

---

## Paso 1: Agregar Nueva Referencia Web en Visual Studio

En el mismo proyecto  **SigreWebServiceWrapper** :

1. **Clic derecho en el proyecto** → **Add** → **Service Reference**
2. **Clic en "Advanced"** → **Add Web Reference**
3. **URL:** `http://pegazus.serveftp.com:9080/SunatWebServices/ImplConsultaRUC?wsdl`
4. **Web reference name:** `ConsultaRUCService`
5. **Clic en "Add Reference"**

---

## Paso 2: Agregar Clase al Wrapper .NET

En el archivo  **LicensingService.cs** , agrega las siguientes clases:

csharp

```csharp
usingSigreWebServiceWrapper.ConsultaRUCService;// Tu nueva referencia

namespaceSigreWebServiceWrapper
{
/// <summary>
/// Servicio para consultar RUC desde SUNAT
/// </summary>
[ComVisible(true)]
[ClassInterface(ClassInterfaceType.AutoDual)]
[ProgId("SigreWebServiceWrapper.ConsultaRUCService")]
publicclassConsultaRUCService
{
privateImplConsultaRUCService _service;

publicConsultaRUCService()
{
            _service =newImplConsultaRUCService();
}

/// <summary>
/// Consulta información del RUC desde el servicio remoto
/// </summary>
publicPadronRUCResponseConsultarRUC(
string rucConsulta,
string rucOrigen,
string usuario,
string clave,
string empresa,
string computerName)
{
try
{
var resultado = _service.consultarPB(
                    rucConsulta, 
                    rucOrigen, 
                    usuario, 
                    clave, 
                    empresa, 
                    computerName);

returnConvertirRespuesta(resultado);
}
catch(Exception ex)
{
returnnewPadronRUCResponse
{
                    IsOk =false,
                    Mensaje ="Error al consultar RUC: "+ ex.Message
};
}
}

/// <summary>
/// Convierte la respuesta del servicio SOAP a un formato simple
/// </summary>
privatePadronRUCResponseConvertirRespuesta(beanPadronRuc bean)
{
if(bean ==null)
{
returnnewPadronRUCResponse
{
                    IsOk =false,
                    Mensaje ="No se recibió respuesta del servicio"
};
}

returnnewPadronRUCResponse
{
                IsOk = bean.isOk,
                Mensaje = bean.mensaje ??"",
                Ruc = bean.ruc ??"",
                RazonSocial = bean.razonSocial ??"",
                Estado = bean.estado ??"",
                Condicion = bean.condicion ??"",
                Ubigeo = bean.ubigeo ??"",
                TipoVia = bean.tipoVia ??"",
                NombreVia = bean.nombreVia ??"",
                CodigoZona = bean.codigoZona ??"",
                TipoZona = bean.tipoZona ??"",
                Numero = bean.numero ??"",
                Interior = bean.interior ??"",
                Lote = bean.lote ??"",
                Departamento = bean.departamento ??"",
                Manzana = bean.manzana ??"",
                Kilometro = bean.kilometro ??"",
                CodProvincia = bean.codProvincia ??"",
                DescProvincia = bean.descProvincia ??"",
                CodDepartamento = bean.codDepartamento ??"",
                DescDepartamento = bean.descDepartamento ??"",
                DescDistrito = bean.descDistrito ??""
};
}
}

/// <summary>
/// Respuesta simplificada para PowerBuilder
/// </summary>
[ComVisible(true)]
[ClassInterface(ClassInterfaceType.AutoDual)]
publicclassPadronRUCResponse
{
publicbool IsOk {get;set;}
publicstring Mensaje {get;set;}
publicstring Ruc {get;set;}
publicstring RazonSocial {get;set;}
publicstring Estado {get;set;}
publicstring Condicion {get;set;}
publicstring Ubigeo {get;set;}
publicstring TipoVia {get;set;}
publicstring NombreVia {get;set;}
publicstring CodigoZona {get;set;}
publicstring TipoZona {get;set;}
publicstring Numero {get;set;}
publicstring Interior {get;set;}
publicstring Lote {get;set;}
publicstring Departamento {get;set;}
publicstring Manzana {get;set;}
publicstring Kilometro {get;set;}
publicstring CodProvincia {get;set;}
publicstring DescProvincia {get;set;}
publicstring CodDepartamento {get;set;}
publicstring DescDepartamento {get;set;}
publicstring DescDistrito {get;set;}

publicPadronRUCResponse()
{
            Mensaje ="";
            Ruc ="";
            RazonSocial ="";
            Estado ="";
            Condicion ="";
            Ubigeo ="";
            TipoVia ="";
            NombreVia ="";
            CodigoZona ="";
            TipoZona ="";
            Numero ="";
            Interior ="";
            Lote ="";
            Departamento ="";
            Manzana ="";
            Kilometro ="";
            CodProvincia ="";
            DescProvincia ="";
            CodDepartamento ="";
            DescDepartamento ="";
            DescDistrito ="";
}
}
}
```

---

## Paso 3: Compilar y Registrar

bash

```bash
# 1. Compilar
dotnet build -c Release

# 2. Registrar (como Administrador)
cd bin\Release\net48
regasm SigreWebServiceWrapper.dll /tlb /codebase
```

---

## Paso 4: Crear Wrapper en PowerBuilder

Crea `n_cst_consulta_ruc.sru`:

powerscript

```powerscript
$PBExportHeader$n_cst_consulta_ruc.sru
forward
global type n_cst_consulta_ruc from nonvisualobject
end type
end forward

global type n_cst_consulta_ruc from nonvisualobject
end type

type variables
OLEObject iole_service
end variables

forward prototypes
public function beanpadronruc of_leer_ruc_externo (string as_ruc)
private function boolean of_inicializar_servicio ()
end prototypes

private function boolean of_inicializar_servicio ();
integer li_ret

TRY
    iole_service = CREATE OLEObject
    li_ret = iole_service.ConnectToNewObject("SigreWebServiceWrapper.ConsultaRUCService")
  
    IF li_ret <> 0 THEN
        MessageBox("Error", "No se pudo crear el objeto COM de Consulta RUC. Código: " + String(li_ret), StopSign!)
        RETURN FALSE
    END IF
  
    RETURN TRUE
  
CATCH (RuntimeError er)
    MessageBox("Error", "Error al inicializar servicio RUC: " + er.getMessage(), StopSign!)
    RETURN FALSE
END TRY

end function

public function beanpadronruc of_leer_ruc_externo (string as_ruc);
String ls_usuario, ls_clave, ls_url
BeanPadronRUC lbean_resultado
OLEObject lole_respuesta

TRY
    // Crear bean de respuesta
    lbean_resultado = CREATE BeanPadronRUC
  
    // Obtener parámetros
    ls_usuario = gnvo_app.of_get_parametro('USUARIO_REMOTO', 'sigre')
    ls_clave = gnvo_app.of_get_parametro('CLAVE_REMOTO', 'sigre1234')
  
    // Inicializar servicio si no existe
    IF IsNull(iole_service) THEN
        IF NOT of_inicializar_servicio() THEN
            lbean_resultado.isOk = FALSE
            lbean_resultado.mensaje = "No se pudo inicializar el servicio"
            RETURN lbean_resultado
        END IF
    END IF
  
    // Llamar al servicio .NET
    gnvo_wait.of_mensaje("Consultando RUC " + as_ruc + " en SUNAT...")
  
    lole_respuesta = iole_service.ConsultarRUC(
        as_ruc,
        gnvo_app.empresa.is_ruc,
        ls_usuario,
        ls_clave,
        gs_empresa,
        gs_estacion)
  
    // Mapear respuesta a bean de PowerBuilder
    lbean_resultado.isOk = lole_respuesta.IsOk
    lbean_resultado.mensaje = lole_respuesta.Mensaje
    lbean_resultado.ruc = lole_respuesta.Ruc
    lbean_resultado.razonSocial = lole_respuesta.RazonSocial
    lbean_resultado.estado = lole_respuesta.Estado
    lbean_resultado.condicion = lole_respuesta.Condicion
    lbean_resultado.ubigeo = lole_respuesta.Ubigeo
    lbean_resultado.tipoVia = lole_respuesta.TipoVia
    lbean_resultado.nombreVia = lole_respuesta.NombreVia
    lbean_resultado.codigoZona = lole_respuesta.CodigoZona
    lbean_resultado.tipoZona = lole_respuesta.TipoZona
    lbean_resultado.numero = lole_respuesta.Numero
    lbean_resultado.interior = lole_respuesta.Interior
    lbean_resultado.lote = lole_respuesta.Lote
    lbean_resultado.departamento = lole_respuesta.Departamento
    lbean_resultado.manzana = lole_respuesta.Manzana
    lbean_resultado.kilometro = lole_respuesta.Kilometro
    lbean_resultado.codProvincia = lole_respuesta.CodProvincia
    lbean_resultado.descProvincia = lole_respuesta.DescProvincia
    lbean_resultado.codDepartamento = lole_respuesta.CodDepartamento
    lbean_resultado.descDepartamento = lole_respuesta.DescDepartamento
    lbean_resultado.descDistrito = lole_respuesta.DescDistrito
  
    RETURN lbean_resultado
  
CATCH (RuntimeError er)
    lbean_resultado.isOk = FALSE
    lbean_resultado.mensaje = "Exception: " + er.getMessage()
    RETURN lbean_resultado
  
FINALLY
    gnvo_wait.of_close()
END TRY

end function

on n_cst_consulta_ruc.create
call super::create
TriggerEvent(this, "constructor")
end on

on n_cst_consulta_ruc.destroy
TRY
    IF NOT IsNull(iole_service) THEN
        iole_service.DisconnectObject()
    END IF
CATCH (RuntimeError er)
    // Ignorar errores al destruir
END TRY

TriggerEvent(this, "destructor")
call super::destroy
end on
```

---

## Paso 5: Usar en tu Código Existente

En `n_cst_compras.sru`, modifica la función:

powerscript

```powerscript
public function beanpadronruc of_leer_ruc_externo (string as_ruc);
// NUEVA IMPLEMENTACIÓN usando el wrapper .NET
n_cst_consulta_ruc lnvo_consulta
BeanPadronRUC lbean_resultado

TRY
    lnvo_consulta = CREATE n_cst_consulta_ruc
    lbean_resultado = lnvo_consulta.of_leer_ruc_externo(as_ruc)
  
    RETURN lbean_resultado
  
CATCH (Exception ex)
    lbean_resultado = CREATE BeanPadronRUC
    lbean_resultado.isOk = FALSE
    lbean_resultado.mensaje = "Exception: " + ex.getMessage()
    RETURN lbean_resultado
  
FINALLY
    DESTROY lnvo_consulta
END TRY

end function
```

---

## Ventajas de Este Enfoque

✅ **No cambias el API SOAP** - sigue funcionando igual

✅ **Un solo DLL para todo** - Licencias + Consulta RUC

✅ **Fácil mantenimiento** - cambios en C# no afectan PB

✅ **Mejor manejo de errores** - control completo en .NET

✅ **Compatible con PB 2025** - sin problemas de migración

---

## Notas Importantes

1. **El servicio SOAP debe estar disponible** : Asegúrate que `http://pegazus.serveftp.com:9090/SunatWebServices/` esté accesible desde tu red
2. **Logging** : El código .NET no necesita crear archivos de log manualmente, usa el logging nativo de .NET
3. **Timeout** : Puedes agregar timeout al servicio en C#:

csharp

```csharp
publicConsultaRUCService()
{
    _service =newImplConsultaRUCService();
    _service.Timeout =30000;// 30 segundos
}
```

4. **Caché de resultados** : Si consultas el mismo RUC múltiples veces, considera implementar caché en memoria

¿Quieres que te ayude a implementar alguna optimización adicional o tienes dudas sobre algún paso?

Reintentar

JR

no hay problema si uso visual studio 2022?

**¡No hay ningún problema!** Visual Studio 2022 es perfectamente compatible y es la versión recomendada. De hecho, tiene varias ventajas:

## ✅ Ventajas de Visual Studio 2022

1. **Soporte completo para .NET Framework 4.8**
2. **Soporte para .NET 6, 7 y 8** (más modernos)
3. **Mejor rendimiento** que versiones anteriores
4. **Actualizaciones de seguridad** más recientes
5. **IntelliSense mejorado** para desarrollo más rápido

## Consideraciones Importantes

### Opción 1: .NET Framework 4.8 (Recomendado para tu caso)

**Ventajas:**

* ✅ Ya está instalado en Windows 10/11
* ✅ 100% compatible con PowerBuilder 2025
* ✅ No requiere runtime adicional en clientes
* ✅ Funciona con COM Interop sin problemas

**Crear proyecto en VS 2022:**

xml

```xml
<!-- En el .csproj -->
<ProjectSdk="Microsoft.NET.Sdk">
<PropertyGroup>
<TargetFramework>net48</TargetFramework>
<RegisterForComInterop>true</RegisterForComInterop>
<ComVisible>true</ComVisible>
<Platforms>x86;x64</Platforms>
</PropertyGroup>
</Project>
```

### Opción 2: .NET 6/7/8 (Más moderno, pero requiere runtime)

**Ventajas:**

* ✅ Mejor rendimiento
* ✅ Más características modernas
* ✅ Soporte multiplataforma (si lo necesitas a futuro)

**Desventajas:**

* ❌ Requiere instalar .NET Runtime en cada cliente
* ❌ Configuración COM Interop más compleja

## Pasos para Crear el Proyecto en Visual Studio 2022

### 1. Abrir Visual Studio 2022

### 2. Crear Nuevo Proyecto

**File** → **New** → **Project**

### 3. Seleccionar Template

Busca: **"Class Library (.NET Framework)"**

⚠️ **IMPORTANTE:** Asegúrate que diga  **".NET Framework"** , NO ".NET" o ".NET Core"

Mostrar imagen

### 4. Configurar Proyecto

```
Project name: SigreWebServiceWrapper
Location: C:\SIGRE\WebServiceWrapper\
Framework: .NET Framework 4.8
```

### 5. Configurar COM Interop

**Clic derecho en el proyecto** → **Properties** → **Build**

Marca:

* ☑️ **Register for COM interop**

**Application** tab:

* ☑️ **Target platform: x86** (si PowerBuilder es 32-bit)
* ☑️ **Target platform: x64** (si PowerBuilder es 64-bit)

### 6. Configurar AssemblyInfo.cs

csharp

```csharp
usingSystem.Runtime.InteropServices;

// Hacer el assembly visible para COM
[assembly:ComVisible(true)]

// GUID único para el assembly (genera uno nuevo)
[assembly:Guid("ABCD1234-5678-90AB-CDEF-1234567890AB")]
```

### 7. Agregar Referencias Web

**Clic derecho en el proyecto** → **Add** → **Service Reference**

Si NO ves "Add Web Reference":

* Clic en **"Advanced"** (abajo a la izquierda)
* Clic en **"Add Web Reference"** (abajo a la izquierda)

**Agregar las 2 referencias:**

**Primera:**

```
URL: http://sigre.serveftp.com:9090/WSLicensingSIGRE/ImplSigre?wsdl
Web reference name: SigreService
```

**Segunda:**

```
URL: http://pegazus.serveftp.com:9080/SunatWebServices/ImplConsultaRUC?wsdl
Web reference name: ConsultaRUCService
```

### 8. Compilar

**Build** → **Build Solution** (Ctrl+Shift+B)

O desde PowerShell:

powershell

```powershell
# En la carpeta del proyecto
dotnet build -c Release
```

### 9. Registrar para COM

**Como Administrador** en PowerShell:

powershell

```powershell
cd "C:\SIGRE\WebServiceWrapper\bin\Release"

# Registrar el DLL
regasm SigreWebServiceWrapper.dll /tlb /codebase

# Verificar que se registró
Get-ItemProperty HKLM:\Software\Classes\SigreWebServiceWrapper.*
```

## Troubleshooting Visual Studio 2022

### Problema 1: No aparece ".NET Framework" en templates

**Solución:**

1. **Tools** → **Get Tools and Features**
2. Instalar: **".NET desktop development"**
3. En "Individual components", verificar que esté marcado:
   * ☑️ .NET Framework 4.8 SDK
   * ☑️ .NET Framework 4.8 targeting pack

### Problema 2: "Add Web Reference" no aparece

**Solución:**

Crear manualmente el archivo `.csproj` con esto:

xml

```xml
<ItemGroup>
<WebReferencesInclude="Web References\"/>
<WebReferenceUrlInclude="http://sigre.serveftp.com:9090/WSLicensingSIGRE/ImplSigre?wsdl">
<UrlBehavior>Dynamic</UrlBehavior>
<RelPath>Web References\SigreService\</RelPath>
</WebReferenceUrl>
</ItemGroup>
```

### Problema 3: Error al registrar con RegAsm

**Solución:**

powershell

```powershell
# Asegurarse de usar el RegAsm correcto
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\regasm.exe SigreWebServiceWrapper.dll /tlb /codebase

# Para 32-bit
C:\Windows\Microsoft.NET\Framework\v4.0.30319\regasm.exe SigreWebServiceWrapper.dll /tlb /codebase
```

## Versión Completa del .csproj

xml

```xml
<ProjectSdk="Microsoft.NET.Sdk">
<PropertyGroup>
<TargetFramework>net48</TargetFramework>
<OutputType>Library</OutputType>
<RegisterForComInterop>true</RegisterForComInterop>
<ComVisible>true</ComVisible>
<GenerateAssemblyInfo>true</GenerateAssemblyInfo>
<Deterministic>false</Deterministic>
<Platforms>x64</Platforms>
<LangVersion>latest</LangVersion>
</PropertyGroup>

<ItemGroup>
<ReferenceInclude="System"/>
<ReferenceInclude="System.Core"/>
<ReferenceInclude="System.Web.Services"/>
<ReferenceInclude="System.Xml"/>
</ItemGroup>
</Project>
```

## Verificar Instalación Correcta

powershell

```powershell
# Verificar que el DLL está registrado
Get-ChildItem"HKLM:\Software\Classes\SigreWebServiceWrapper*"

# Verificar ProgID
Get-ItemProperty"HKLM:\Software\Classes\CLSID\{GUID-DEL-ASSEMBLY}\ProgID"
```

## Conclusión

✅ **Visual Studio 2022 es 100% compatible**

✅ **Usa .NET Framework 4.8** para máxima compatibilidad

✅ **Sigue todos los pasos anteriores** que te di, funcionarán igual

✅ **No necesitas cambiar nada del código C#** que te proporcioné

¿Tienes VS 2022 instalado o necesitas ayuda para instalarlo?
