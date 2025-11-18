# MÓDULO CONTABILIDAD - ESTRUCTURA DE MENÚS

## Sistema ERP PowerBuilder 2017

| Opción Menú Principal | Opción Menú Desplegable | Opción Submenú 1 | Opción Submenú 2 | Opción Submenú 3 | Descripción del Proceso |
|----------------------|------------------------|-------------------|-------------------|-------------------|------------------------|
| **TABLAS** | **Configuración Básica** | Libros contables | | | Definición y configuración de libros contables |
| TABLAS | Configuración Básica | Monedas | | | Registro de monedas y tipos de cambio |
| TABLAS | Configuración Básica | Origen | | | Configuración de códigos de origen |
| TABLAS | Configuración Básica | Clases contables | | | Definición de clases para cuentas contables |
| TABLAS | Configuración Básica | Ventas a Título Gratuito | | | Configuración para ventas sin contraprestación |
| TABLAS | Configuración Básica | Grupo Cuentas | | | Agrupación de cuentas para reportes |
| TABLAS | **Plan de Cuentas** | Maestro Plan de Cuentas | | | Registro y mantenimiento del plan de cuentas |
| TABLAS | Plan de Cuentas | Cuentas vs SUNAT | | | Equivalencias con plan de cuentas SUNAT |
| TABLAS | Plan de Cuentas | Indice de Ajuste | | | Índices para ajustes por inflación |
| TABLAS | Plan de Cuentas | Cierre contable x mes | | | Configuración de cierres mensuales |
| TABLAS | **Centros de Costos** | Niveles 1, 2 3 | | | Estructura jerárquica de centros de costos |
| TABLAS | Centros de Costos | Maestro de Centro de Costos | | | Registro maestro de centros de costos |
| TABLAS | Centros de Costos | Centros Costo - Usuarios - Servicios | | | Asignación de usuarios y servicios por centro |
| TABLAS | Centros de Costos | Asignación de artículos por Centro de Costos | | | Asignación de artículos a centros de costos |
| TABLAS | Centros de Costos | Grupo de centros de costos | | | Agrupación de centros de costos |
| TABLAS | **Matrices** | Matrices de almacenes - sub categorias | | | Matrices contables para almacenes |
| TABLAS | Matrices | Matrices Transferencias x Cencos | | | Matrices para transferencias entre centros |
| TABLAS | Matrices | Configuración de Tabla de venta | | | Configuración para tablas de ventas |
| TABLAS | Matrices | Matrices de Venta de bien y Servicio | | | Matrices contables para ventas |
| TABLAS | Matrices | Plantillas de grupos de cencos produccion | | | Plantillas para centros de producción |
| TABLAS | Matrices | Plantillas de grupos de centros de beneficios | | | Plantillas para centros de beneficios |
| TABLAS | Matrices | Matriz Para el Cierre del Ejercicio | | | Configuración para cierre anual |
| **OPERACIONES** | | Ingreso / Modificación de asientos contables | | | Registro manual de asientos contables |
| OPERACIONES | | Credito fiscal | | | Manejo de crédito fiscal |
| OPERACIONES | | Certificados de Retenciones | | | Emisión de certificados de retenciones |
| OPERACIONES | | Anexos de Cuentas Contables | | | Gestión de anexos contables |
| OPERACIONES | | Modificacion Masiva de Asientos contables | | | Modificación masiva de asientos |
| **CONSULTAS** | | Por Codigo de Relacion, segun lista | | | Consulta por código de relación en lista |
| CONSULTAS | | Por codigo de relacion, segun rango | | | Consulta por rango de códigos de relación |
| CONSULTAS | | Por Codigo de Relacion y Cuenta | | | Consulta por relación y cuenta específica |
| CONSULTAS | | Por Documento | | | Consulta por documento específico |
| CONSULTAS | | Balance de Comprobacion | | | Balance de comprobación |
| CONSULTAS | | Centros de Costos de Trabajadores | | | Consulta de centros de costos por trabajador |
| **REPORTES** | **Estados Financieros** | Balance de Comprobacion | | | Balance de comprobación estándar |
| REPORTES | Estados Financieros | Balance General - Contable | | | Balance general contable |
| REPORTES | Estados Financieros | Ganancias y Pérdidas por Función | | | Estado de resultados por función |
| REPORTES | Estados Financieros | Ganancias y Pérdidas por Naturaleza | | | Estado de resultados por naturaleza |
| REPORTES | Estados Financieros | Balance General | | | Balance general empresarial |
| REPORTES | Estados Financieros | Balance Mensualizado | | | Balance mensualizado |
| REPORTES | **Libros Oficiales** | Libro mayor | | | Libro mayor general |
| REPORTES | Libros Oficiales | Libro Mayor General - Resumen | | | Mayor general resumido |
| REPORTES | Libros Oficiales | Resumen mensual | | | Resumen mensual del libro diario |
| REPORTES | Libros Oficiales | Detalle mensual | | | Detalle mensual del libro diario |
| REPORTES | Libros Oficiales | Resumen mensual de Caja | | | Resumen mensual de caja |
| REPORTES | Libros Oficiales | Detalle mensual de Caja | | | Detalle mensual de movimientos de caja |
| REPORTES | **Formatos SUNAT** | Formato 5.1 Libro Diario | | | Libro diario formato SUNAT |
| REPORTES | Formatos SUNAT | Formato 6.1: Libro Mayor | | | Libro mayor formato SUNAT |
| REPORTES | Formatos SUNAT | Formato 13.1: Inventario Permanente Valorizado | | | Inventario permanente valorizado |
| REPORTES | Formatos SUNAT | Export Balance a PDT | | | Exportación de balance a PDT |
| **PROCESOS** | | Cuadre de asientos | | | Proceso de cuadre de asientos |
| PROCESOS | | Corrige pre cuentas de asientos contables | | | Corrección de pre-cuentas |
| PROCESOS | | Generación de Asientos de Almacen | | | Generación automática de asientos de almacén |
| PROCESOS | | Asientos de devengados de RRHH | | | Asientos de devengados de recursos humanos |
| PROCESOS | | Proceso de Costo Contable | | | Proceso de costeo contable de producción |

## Recepción de Información de Otros Módulos:

**Mecanismo Central de Integración:**
El módulo de contabilidad recibe información automáticamente de todos los módulos operativos mediante un sistema unificado de matrices contables y pre-asientos.

**Proceso de Consolidación:**
1. Los módulos operativos generan transacciones con sus respectivos conceptos
2. Cada concepto tiene asociada una matriz contable
3. Las matrices determinan automáticamente las cuentas debe/haber
4. Se crean pre-asientos en tablas temporales
5. Los pre-asientos se transfieren al módulo de contabilidad
6. Se consolidan en el libro diario oficial
