# SigreWebServiceWrapper

## Descripción
Assembly .NET Framework 4.8 que actúa como wrapper para consumir servicios SOAP desde PowerBuilder 2025.

## Servicios Integrados

1. **Servicio de Licencias SIGRE**
   - URL: http://sigre.serveftp.com:9090/WSLicensingSIGRE/ImplSigre?wsdl
   - Métodos: ValidarAcceso, ValidarUsrHousing, ValidarModulosPorEmpresa, etc.

2. **Servicio de Consulta RUC (SUNAT)**
   - URL: http://pegazus.serveftp.com:9080/SunatWebServices/ImplConsultaRUC?wsdl
   - Método: ConsultarRUC

## Requisitos

- Visual Studio 2022
- .NET Framework 4.8 SDK
- PowerBuilder 2025

## Estructura del Proyecto

```
SigreWebServiceWrapper/
│
├── Properties/
│   └── AssemblyInfo.cs          # Información del assembly y configuración COM
│
├── LicensingService.cs          # Wrapper para servicio de licencias
├── ConsultaRUCService.cs        # Wrapper para consulta RUC
├── SigreWebServiceWrapper.csproj # Configuración del proyecto
└── README_PROYECTO.md           # Este archivo
```

## Pasos de Configuración

### 1. Agregar Referencias Web

Debes agregar las referencias a los servicios SOAP manualmente:

#### En Visual Studio 2022:

1. Abrir el proyecto en Visual Studio 2022
2. Clic derecho en el proyecto → **Add** → **Service Reference**
3. Clic en **"Advanced"** (abajo a la izquierda)
4. Clic en **"Add Web Reference"** (abajo a la izquierda)

**Primera referencia:**
- URL: `http://sigre.serveftp.com:9090/WSLicensingSIGRE/ImplSigre?wsdl`
- Web reference name: `SigreService`
- Clic en "Add Reference"

**Segunda referencia:**
- URL: `http://pegazus.serveftp.com:9080/SunatWebServices/ImplConsultaRUC?wsdl`
- Web reference name: `ConsultaRUCService`
- Clic en "Add Reference"

### 2. Compilar el Proyecto

#### Opción A: En Visual Studio
- Menú: **Build** → **Build Solution** (Ctrl+Shift+B)
- O clic derecho en el proyecto → **Build**

#### Opción B: Desde línea de comandos
```powershell
dotnet build -c Release
```

### 3. Registrar el DLL para COM Interop

**IMPORTANTE: Ejecutar PowerShell como Administrador**

```powershell
# Navegar a la carpeta de salida
cd "C:\SIGRE\SigreWebServiceWrapper\bin\Release\net48"

# Registrar el DLL (x64)
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\regasm.exe SigreWebServiceWrapper.dll /tlb /codebase

# O para x86 (32-bit)
C:\Windows\Microsoft.NET\Framework\v4.0.30319\regasm.exe SigreWebServiceWrapper.dll /tlb /codebase
```

### 4. Verificar el Registro

```powershell
# Verificar que el DLL está registrado
Get-ItemProperty "HKLM:\Software\Classes\SigreWebServiceWrapper.*"
```

## Uso desde PowerBuilder

### Ejemplo básico:

```powerscript
OLEObject lole_service
integer li_ret

// Crear el objeto COM
lole_service = CREATE OLEObject
li_ret = lole_service.ConnectToNewObject("SigreWebServiceWrapper.LicensingService")

IF li_ret = 0 THEN
    // Llamar al servicio
    lole_respuesta = lole_service.ValidarAcceso(...)
    
    // Usar la respuesta
    IF lole_respuesta.IsOk THEN
        // Éxito
    END IF
END IF

// Limpiar
lole_service.DisconnectObject()
DESTROY lole_service
```

## Troubleshooting

### Error: "No se pudo crear el objeto COM"
- Verificar que el DLL está registrado con regasm
- Ejecutar regasm como Administrador
- Verificar que la ruta /codebase es correcta

### Error: "Type library not registered"
- Asegurarse de usar el flag `/tlb` en regasm
- Verificar permisos de escritura en el registro de Windows

### Error al compilar: "No se encuentra el SDK"
- Instalar .NET Framework 4.8 SDK desde Visual Studio Installer
- Tools → Get Tools and Features → .NET desktop development

## Próximos Pasos

1. ✅ Proyecto creado
2. ⏳ Agregar referencias web a los servicios SOAP
3. ⏳ Implementar las clases de servicio
4. ⏳ Compilar y registrar
5. ⏳ Probar desde PowerBuilder

## Soporte

Para dudas o problemas, consultar la documentación completa en:
`documentacion/readme.md`

