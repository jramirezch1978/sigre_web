# 📋 Pasos Siguientes - SigreWebServiceWrapper

## ✅ Estado Actual

- ✅ Proyecto .NET creado
- ✅ Referencia al servicio SOAP agregada
- ✅ Clase `ConsultaRUC` implementada con soporte COM
- ✅ Clase `PadronRUC` para respuestas
- ✅ DLL compilado correctamente: `bin\Release\net48\SigreWebServiceWrapper.dll`

---

## 🎯 Siguiente Paso: Registrar el DLL para COM

### Opción 1: Script Automático (Recomendado)

1. **Clic derecho** en `Registrar-COM.ps1`
2. Seleccionar **"Ejecutar con PowerShell"**
3. Si Windows pide confirmación, hacer clic en **"Sí"**

O manualmente:

```powershell
# Ejecutar PowerShell como Administrador
# Navegar a la carpeta del proyecto
cd "C:\SIGRE\SigreWebServiceWrapper"

# Registrar (x64 - 64 bits)
.\Registrar-COM.ps1 -Platform x64

# O para x86 (32 bits)
.\Registrar-COM.ps1 -Platform x86
```

### Opción 2: Comando Manual

```powershell
# Para 64-bit
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\regasm.exe "C:\SIGRE\SigreWebServiceWrapper\bin\Release\net48\SigreWebServiceWrapper.dll" /tlb /codebase /verbose

# Para 32-bit
C:\Windows\Microsoft.NET\Framework\v4.0.30319\regasm.exe "C:\SIGRE\SigreWebServiceWrapper\bin\Release\net48\SigreWebServiceWrapper.dll" /tlb /codebase /verbose
```

---

## 🧪 Verificar el Registro

Después de registrar, verificar en PowerShell:

```powershell
# Verificar en el registro de Windows
Get-ItemProperty "HKLM:\Software\Classes\SigreWebServiceWrapper.ConsultaRUC"

# Verificar el CLSID
Get-ChildItem "HKLM:\Software\Classes\CLSID" | Where-Object { $_.GetValue("ProgID") -eq "SigreWebServiceWrapper.ConsultaRUC" }
```

Si estos comandos retornan información, el registro fue exitoso.

---

## 🔬 Probar desde PowerBuilder 2025

### Prueba Rápida

1. Abrir PowerBuilder 2025
2. Crear una ventana de prueba
3. Agregar un botón y en su evento `clicked`:

```powerscript
OLEObject lole_service
OLEObject lole_respuesta
integer li_ret

lole_service = CREATE OLEObject
li_ret = lole_service.ConnectToNewObject("SigreWebServiceWrapper.ConsultaRUC")

IF li_ret = 0 THEN
    MessageBox("Éxito", "El componente COM se creó correctamente!", Information!)
    
    // Probar el método Test
    string ls_test = lole_service.Test("20100070970")
    MessageBox("Prueba", ls_test, Information!)
    
    lole_service.Dispose()
    lole_service.DisconnectObject()
ELSE
    MessageBox("Error", "No se pudo crear el objeto COM. Código: " + String(li_ret), StopSign!)
END IF

DESTROY lole_service
```

### Prueba Completa - Consulta de RUC

```powerscript
OLEObject lole_service
OLEObject lole_respuesta
integer li_ret
string ls_mensaje

lole_service = CREATE OLEObject
li_ret = lole_service.ConnectToNewObject("SigreWebServiceWrapper.ConsultaRUC")

IF li_ret = 0 THEN
    // Consultar un RUC real
    lole_respuesta = lole_service.ConsultarRUC( &
        "20100070970",        // RUC a consultar (SUPERMERCADOS PERUANOS)
        "20123456789",        // RUC de tu empresa
        "usuario",            // Usuario del servicio
        "clave",              // Clave del servicio
        "EMPRESA01",          // Código de empresa
        "ESTACION01")         // Nombre de estación
    
    IF lole_respuesta.IsOk THEN
        ls_mensaje = "RUC: " + lole_respuesta.Ruc + "~r~n"
        ls_mensaje += "Razón Social: " + lole_respuesta.RazonSocial + "~r~n"
        ls_mensaje += "Estado: " + lole_respuesta.Estado + "~r~n"
        ls_mensaje += "Condición: " + lole_respuesta.Condicion + "~r~n"
        ls_mensaje += "Dirección: " + lole_respuesta.ObtenerDireccionCompleta() + "~r~n"
        ls_mensaje += "Ubicación: " + lole_respuesta.ObtenerUbicacionCompleta()
        
        MessageBox("Información del RUC", ls_mensaje, Information!)
    ELSE
        MessageBox("Error", lole_respuesta.Mensaje, StopSign!)
    END IF
    
    lole_service.Dispose()
    lole_service.DisconnectObject()
END IF

DESTROY lole_service
```

---

## 📁 Archivos de Ayuda

- **`Ejemplos-PowerBuilder.txt`** - Ejemplos completos de código PowerBuilder
- **`Registrar-COM.ps1`** - Script para registrar el DLL
- **`Desregistrar-COM.ps1`** - Script para desregistrar el DLL
- **`Compilar-y-Registrar.ps1`** - Script que compila y registra en un paso
- **`README_PROYECTO.md`** - Documentación técnica del proyecto

---

## 🔄 Workflow de Desarrollo

### Cuando hagas cambios al código C#:

1. **Compilar**:
   ```powershell
   dotnet build -c Release
   ```

2. **Desregistrar versión anterior** (opcional):
   ```powershell
   .\Desregistrar-COM.ps1
   ```

3. **Registrar nueva versión**:
   ```powershell
   .\Registrar-COM.ps1
   ```

O todo en un comando:
```powershell
.\Compilar-y-Registrar.ps1
```

### Cuando pruebes desde PowerBuilder:

1. Cerrar PowerBuilder si está abierto
2. Compilar y registrar el DLL
3. Abrir PowerBuilder
4. Ejecutar tu aplicación de prueba

**IMPORTANTE:** Si tienes PowerBuilder abierto y cambias el DLL, debes cerrar y volver a abrir PowerBuilder para que reconozca la nueva versión.

---

## 🚀 Integración en tu Aplicación

### Crear Objeto de Servicio Reutilizable

Te recomiendo crear un objeto no visual en tu aplicación PowerBuilder:

**`n_cst_consulta_ruc_sunat.sru`**

Este objeto:
- Encapsula la lógica de COM
- Maneja errores automáticamente
- Proporciona funciones simples de usar
- Se puede reutilizar en toda la aplicación

Ver **`Ejemplos-PowerBuilder.txt`** para el código completo.

### Usar en tu Aplicación Existente

Si ya tienes un objeto `n_cst_compras` o similar que consulta RUC, simplemente:

1. Reemplaza el código de `SoapConnection` antiguo
2. Usa el nuevo objeto COM
3. Mantén la misma interface para no romper código existente

---

## 📊 Datos que Retorna el Servicio

El servicio retorna toda la información del Padrón RUC de SUNAT:

- **Datos básicos**: RUC, Razón Social, Estado, Condición
- **Dirección completa**: Tipo de vía, nombre, número, interior, etc.
- **Ubicación**: Departamento, Provincia, Distrito, Ubigeo
- **Métodos de ayuda**: `ObtenerDireccionCompleta()`, `ObtenerUbicacionCompleta()`

Ver la sección "PROPIEDADES DISPONIBLES" en **`Ejemplos-PowerBuilder.txt`**

---

## ❓ Troubleshooting

### Error: "Clase no registrada" (-4)
- Ejecutar `Registrar-COM.ps1` como Administrador
- Verificar que el DLL existe en `bin\Release\net48\`

### Error: "No se puede encontrar el punto de conexión"
- Verificar conectividad a internet
- Probar en navegador: http://pegazus.serveftp.com:9080/SunatWebServices/ImplConsultaRUC?wsdl

### DLL Compilado pero no se registra
- Verificar que .NET Framework 4.8 esté instalado
- Verificar que RegAsm.exe existe en:
  - `C:\Windows\Microsoft.NET\Framework64\v4.0.30319\regasm.exe` (x64)
  - `C:\Windows\Microsoft.NET\Framework\v4.0.30319\regasm.exe` (x86)

### PowerBuilder no reconoce cambios en el DLL
- Cerrar completamente PowerBuilder
- Desregistrar y volver a registrar el DLL
- Abrir PowerBuilder nuevamente

---

## 📞 Próximos Pasos Opcionales

### Si necesitas agregar el servicio de Licencias SIGRE:

1. Agregar la segunda referencia web en Visual Studio:
   - URL: `http://sigre.serveftp.com:9090/WSLicensingSIGRE/ImplSigre?wsdl`
   - Nombre: `SigreService`

2. Crear `LicensingService.cs` (similar a `ConsultaRUCService.cs`)

3. Recompilar y registrar

### Si necesitas distribuir a otros PCs:

1. Copiar `SigreWebServiceWrapper.dll` al PC destino
2. Ejecutar `Registrar-COM.ps1` en ese PC como Administrador
3. Asegurarse que .NET Framework 4.8 esté instalado en el PC

---

## ✅ Checklist Final

- [ ] DLL compilado correctamente
- [ ] DLL registrado con RegAsm
- [ ] Prueba básica desde PowerBuilder funciona
- [ ] Consulta de RUC funciona correctamente
- [ ] Creado objeto reutilizable en PowerBuilder
- [ ] Integrado en la aplicación existente
- [ ] Probado en ambiente de desarrollo
- [ ] Documentado para el equipo

---

¿Todo listo? ¡Excelente trabajo! 🎉

Si tienes algún problema, revisa la documentación o los ejemplos proporcionados.

