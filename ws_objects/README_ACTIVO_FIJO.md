# MÓDULO ACTIVO FIJO - ESTRUCTURA DE MENÚS

## Sistema ERP PowerBuilder 2017

| Opción Menú Principal | Opción Menú Desplegable | Opción Submenú 1 | Opción Submenú 2 | Opción Submenú 3 | Descripción del Proceso |
|----------------------|------------------------|-------------------|-------------------|-------------------|------------------------|
| **TABLAS** | **Configuración** | Operaciones de los Activos | | | Definición y mantenimiento de los tipos de operaciones que se pueden realizar sobre los activos fijos |
| TABLAS | Configuración | Incidencias de Activos | | | Catalogación de tipos de incidencias que pueden afectar a los activos fijos |
| TABLAS | Configuración | Indices de Precios | | | Mantenimiento de índices de precios para procesos de revaluación |
| TABLAS | Configuración | Tipos de Seguros | | | Definición de los diferentes tipos de seguros aplicables |
| TABLAS | Configuración | Aseguradoras | | | Registro y mantenimiento del maestro de compañías aseguradoras |
| TABLAS | **Maestros** | Clases de Activos | | | Definición jerárquica de clases y subclases de activos fijos |
| TABLAS | Maestros | Software | | | Registro específico para activos de tipo software y licencias |
| TABLAS | Maestros | Matriz Contable | | | Configuración de cuentas contables asociadas a cada tipo de activo |
| TABLAS | Maestros | Ubicacion de activos | | | Definición de ubicaciones físicas donde se encuentran los activos |
| TABLAS | Maestros | Marcas | | | Maestro de marcas de activos fijos para identificación |
| TABLAS | **Parametros** | De Control | | | Configuración de parámetros generales de control del módulo |
| TABLAS | Parametros | De Operaciones | | | Parámetros específicos para cálculos de depreciación y revaluación |
| TABLAS | **Numeradores** | De Activos | | | Configuración de secuencias numéricas para códigos de activos |
| TABLAS | Numeradores | De Traslados | | | Numeración automática para documentos de traslado |
| **OPERACIONES** | | Maestro de Activo Fijo | | | Registro principal de activos fijos con datos generales y contables |
| OPERACIONES | **Traslado de Activo Fijo** | Ingreso de datos | | | Captura de solicitudes de traslado de activos |
| OPERACIONES | Traslado de Activo Fijo | Aprobación | | | Proceso de autorización y confirmación de traslados |
| OPERACIONES | | Operacione de Activos | | | Registro de operaciones especiales: repotenciación, revaluación e indexación |
| OPERACIONES | | Polizas de Seguro | | | Gestión de pólizas de seguro asociadas a activos fijos |
| OPERACIONES | | Venta de Activos | | | Proceso de baja de activos por venta con generación de movimientos |
| OPERACIONES | | Revaluaciones | | | Registro de revaluaciones técnicas y comerciales de activos fijos |
| **REPORTES** | | Resumen de Activos Fijo | | | Listado general de activos fijos con valores y depreciación |
| REPORTES | | Depreciacion Anual x Activo | | | Reporte detallado de depreciación anual por cada activo |
| REPORTES | | Resumen de Activos Fijos por Rango | | | Reporte consolidado filtrado por rangos de fecha o código |
| **PROCESOS** | **Cálculo de Depreciación** | Cálculo Depreciación | | | Proceso masivo de cálculo de depreciación mensual/anual |

## Notas Importantes:

- El módulo maneja el control integral de activos fijos
- Incluye funcionalidades para depreciación, revaluación e indexación
- Diseñado para cumplimiento con normativas contables

## Flujo Principal del Proceso:

1. **Configuración Inicial**: Configurar tablas maestras y parámetros
2. **Registro de Activos**: Capturar activos en el maestro principal
3. **Operaciones**: Realizar traslados, revaluaciones y otras operaciones
4. **Procesos Periódicos**: Ejecutar cálculos de depreciación
5. **Reportería**: Generar informes de control y cumplimiento

## Alimentación a Contabilidad:

**Mecanismo de Integración Contable:**
El módulo de activo fijo integra con contabilidad mediante matrices contables específicas por tipo de activo y operación, aunque los asientos automáticos están actualmente deshabilitados.

**Proceso de Integración:**
1. **Configuración de Matrices**: Cada clase de activo tiene configurada su matriz contable que define las cuentas de activo, depreciación acumulada y gasto
2. **Cálculo de Depreciación**: Proceso mensual que calcula la depreciación de todos los activos y distribuye por centro de costos
3. **Operaciones de Activos**: Registro de altas, bajas, mejoras, revaluaciones y traslados con impacto contable
4. **Estado Actual**: Los cálculos están activos pero la generación automática de asientos está deshabilitada, requiriendo transferencia manual

**Información Contabilizada:**
- **Registro de Activos**: Costo histórico y clasificación contable
- **Depreciación Periódica**: Cálculo automático de depreciación por método configurado
- **Revaluaciones**: Ajustes por valuación técnica o comercial
- **Operaciones Especiales**: Mejoras que incrementan el valor del activo
- **Bajas y Ventas**: Retiro de activos con reconocimiento de resultados