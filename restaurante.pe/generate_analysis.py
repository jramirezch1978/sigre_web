# -*- coding: utf-8 -*-
"""
Script para leer todos los documentos de HUs descargados,
analizar su contenido y generar un archivo markdown con
síntesis y análisis completo del proyecto Restaurant.pe
"""

import os
import re
import json
import sys

sys.stdout.reconfigure(encoding='utf-8')

BASE_DIR = r'e:\Work\sigre_web\restaurante.pe'
HUS_DIR = os.path.join(BASE_DIR, 'HUs por modulo')
EXTRACTED_FILE = os.path.join(BASE_DIR, 'extracted_data.json')
OUTPUT_MD = os.path.join(BASE_DIR, 'ANALISIS_COMPLETO_RESTAURANT_PE.md')

# Cargar datos del inventario para contexto adicional
with open(EXTRACTED_FILE, 'r', encoding='utf-8') as f:
    inventory_data = json.load(f)

# Obtener info consolidada
consolidado = inventory_data.get('Consolidado', {})
consolidado_rows = consolidado.get('rows', [])
consolidado_hlinks = consolidado.get('hyperlinks', {})

# Construir mapa de estados por funcionalidad
row_modules = {}
current_module = ""
stats_by_module = {}
stats_by_state = {}

for i, row in enumerate(consolidado_rows):
    if i == 0:
        continue  # header
    if row[0]:
        current_module = row[0]
    
    estado = row[3] if len(row) > 3 and row[3] else "Sin estado"
    funcionalidad = row[4] if len(row) > 4 and row[4] else ""
    
    if not funcionalidad:
        continue
    
    if current_module not in stats_by_module:
        stats_by_module[current_module] = {'total': 0, 'estados': {}}
    stats_by_module[current_module]['total'] += 1
    
    if estado not in stats_by_module[current_module]['estados']:
        stats_by_module[current_module]['estados'][estado] = 0
    stats_by_module[current_module]['estados'][estado] += 1
    
    if estado not in stats_by_state:
        stats_by_state[estado] = 0
    stats_by_state[estado] += 1


# Definir orden de módulos
MODULE_ORDER = [
    ('01_Almacen', 'Almacén', 'Gestión integral de inventarios, stock, movimientos y valorización de productos'),
    ('02_Compras', 'Compras', 'Gestión de proveedores, órdenes de compra/servicio, aprovisionamiento y reportes'),
    ('03_Ventas', 'Ventas', 'Facturación, pedidos, caja, clientes y reportes de ventas'),
    ('04_Finanzas', 'Finanzas', 'Tesorería, cuentas por pagar/cobrar, conciliaciones, adelantos y flujo de caja'),
    ('05_Contabilidad', 'Contabilidad', 'Plan contable, asientos, libros electrónicos, reportes financieros y cierres'),
    ('06_Activos_Fijos', 'Activos Fijos', 'Registro, depreciación, traslados, seguros y revaluación de activos'),
    ('07_RRHH', 'Recursos Humanos', 'Gestión de personal, nómina, asistencia, reclutamiento y talento'),
    ('08_Produccion', 'Producción', 'Órdenes de producción, recetas, costos, trazabilidad y calidad'),
    ('09_Configuraciones', 'Configuraciones', 'Parámetros del sistema, multicompañía, localización e integraciones'),
]


def extract_hu_info(content):
    """Extrae información estructurada de una HU."""
    info = {
        'titulo': '',
        'descripcion': '',
        'proceso': '',
        'subproceso': '',
        'modulo': '',
        'narrativa': '',
        'navegabilidad': '',
        'criterios': [],
        'campos': '',
        'integracion': '',
        'consideraciones': '',
        'comentarios': ''
    }
    
    lines = content.strip().split('\n')
    
    # Titulo (primera linea generalmente)
    if lines:
        info['titulo'] = lines[0].strip()
    
    # Buscar secciones por numero
    current_section = ''
    current_content = []
    
    section_map = {
        '1. título': 'titulo_sec',
        '2. descripción': 'descripcion',
        '3. proceso': 'proceso_sec',
        '4. narrativa': 'narrativa',
        '5. regla de navegabilidad': 'navegabilidad',
        '6. criterios de aceptación': 'criterios',
        '7. campos': 'campos',
        '8. detalle de integración': 'integracion',
        '9. consideraciones técnicas': 'consideraciones',
        '10. comentarios': 'comentarios',
    }
    
    for line in lines[1:]:
        line_lower = line.strip().lower()
        
        # Detectar inicio de seccion
        found_section = False
        for key, sec_name in section_map.items():
            if line_lower.startswith(key) or (key.split('. ')[1] in line_lower and line_lower[0].isdigit()):
                if current_section and current_content:
                    text = '\n'.join(current_content).strip()
                    if current_section == 'descripcion':
                        info['descripcion'] = text
                    elif current_section == 'narrativa':
                        info['narrativa'] = text
                    elif current_section == 'criterios':
                        info['criterios'] = [c.strip() for c in text.split('\n') if c.strip() and c.strip() != '*']
                    elif current_section == 'campos':
                        info['campos'] = text
                    elif current_section == 'integracion':
                        info['integracion'] = text
                    elif current_section == 'consideraciones':
                        info['consideraciones'] = text
                    elif current_section == 'comentarios':
                        info['comentarios'] = text
                    elif current_section == 'navegabilidad':
                        info['navegabilidad'] = text
                    elif current_section == 'proceso_sec':
                        for pline in text.split('\n'):
                            if 'proceso:' in pline.lower() and 'sub' not in pline.lower():
                                info['proceso'] = pline.split(':')[-1].strip()
                            elif 'subproceso:' in pline.lower():
                                info['subproceso'] = pline.split(':')[-1].strip()
                            elif 'módulo:' in pline.lower() or 'modulo:' in pline.lower():
                                info['modulo'] = pline.split(':')[-1].strip()
                
                current_section = sec_name
                current_content = []
                found_section = True
                break
        
        if not found_section:
            current_content.append(line)
    
    # Procesar ultima seccion
    if current_section and current_content:
        text = '\n'.join(current_content).strip()
        if current_section == 'comentarios':
            info['comentarios'] = text
        elif current_section == 'consideraciones':
            info['consideraciones'] = text
        elif current_section == 'descripcion':
            info['descripcion'] = text
    
    # Si no se encontro descripcion, usar las primeras lineas
    if not info['descripcion'] and len(lines) > 2:
        for line in lines[1:6]:
            if len(line.strip()) > 30 and 'como usuario' in line.lower():
                info['descripcion'] = line.strip()
                break
    
    return info


def count_criteria(content):
    """Cuenta criterios de aceptacion en el contenido."""
    count = 0
    for line in content.split('\n'):
        stripped = line.strip()
        if stripped.startswith('*') or stripped.startswith('-'):
            if len(stripped) > 10:
                count += 1
        elif re.match(r'^\d+\.', stripped):
            count += 1
    return count


# ============================================================
# PROCESAR TODOS LOS DOCUMENTOS
# ============================================================
print("Procesando documentos...")

all_modules_data = {}
total_files = 0
total_chars = 0

for folder_name, module_name, module_desc in MODULE_ORDER:
    folder_path = os.path.join(HUS_DIR, folder_name)
    if not os.path.exists(folder_path):
        continue
    
    module_data = {
        'name': module_name,
        'folder': folder_name,
        'description': module_desc,
        'hus': []
    }
    
    for filename in sorted(os.listdir(folder_path)):
        if not filename.endswith('.txt'):
            continue
        
        filepath = os.path.join(folder_path, filename)
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
        except:
            try:
                with open(filepath, 'r', encoding='latin-1') as f:
                    content = f.read()
            except:
                continue
        
        total_files += 1
        total_chars += len(content)
        
        hu_info = extract_hu_info(content)
        hu_info['filename'] = filename
        hu_info['char_count'] = len(content)
        hu_info['criteria_count'] = count_criteria(content)
        hu_info['raw_content'] = content
        
        module_data['hus'].append(hu_info)
    
    all_modules_data[folder_name] = module_data
    print(f"  {module_name}: {len(module_data['hus'])} HUs procesadas")

print(f"\nTotal: {total_files} documentos, {total_chars/1024/1024:.1f} MB de texto")


# ============================================================
# GENERAR MARKDOWN
# ============================================================
print("\nGenerando archivo markdown...")

md = []

# PORTADA
md.append("# Análisis Completo del Proyecto Restaurant.pe - Sistema ERP")
md.append("")
md.append("> **Documento generado automáticamente** a partir del análisis de 204 Historias de Usuario (HUs)")
md.append(f"> **Total de documentación analizada:** {total_files} documentos ({total_chars/1024:.0f} KB de texto)")
md.append(f"> **Módulos identificados:** {len(all_modules_data)}")
md.append("")
md.append("---")
md.append("")

# RESUMEN EJECUTIVO
md.append("## 1. Resumen Ejecutivo")
md.append("")
md.append("**Restaurant.pe** es un sistema ERP (Enterprise Resource Planning) integral diseñado específicamente para la industria gastronómica y de restaurantes, con capacidad de operación **multipaís** (Perú, Colombia, Chile, República Dominicana, entre otros), **multiempresa** (varias razones sociales) y **multisucursal**.")
md.append("")
md.append("El sistema busca centralizar y automatizar todos los procesos operativos, financieros, contables y de gestión humana de cadenas de restaurantes y franquicias, reemplazando sistemas fragmentados por una plataforma unificada.")
md.append("")
md.append("### Características Transversales Identificadas")
md.append("")
md.append("A lo largo de todas las HUs se identifican las siguientes características que son **transversales** a todo el sistema:")
md.append("")
md.append("| Característica | Descripción |")
md.append("|---|---|")
md.append("| **Multipaís** | Soporte para diferentes normativas fiscales, tributarias y laborales por país |")
md.append("| **Multiempresa** | Múltiples razones sociales operando en el mismo sistema |")
md.append("| **Multisucursal** | Gestión por locales/sucursales con consolidación corporativa |")
md.append("| **Multimoneda** | Operaciones en diferentes monedas con tipo de cambio |")
md.append("| **Auditoría completa** | Log de auditoría contable en todas las operaciones (usuario, fecha, hora, IP, acción) |")
md.append("| **Integración contable** | Todos los módulos generan pre-asientos o asientos contables |")
md.append("| **Control de permisos** | Roles y perfiles de usuario granulares |")
md.append("| **Exportación** | Exportación a Excel/PDF en todos los reportes y listados |")
md.append("| **Carga masiva** | Importación de datos vía Excel con validaciones |")
md.append("")

# ESTADÍSTICAS GENERALES
md.append("### Estado General del Proyecto")
md.append("")
total_funcs = sum(s['total'] for s in stats_by_module.values())
md.append(f"Se identificaron **{total_funcs} funcionalidades** distribuidas en los siguientes estados:")
md.append("")
md.append("| Estado | Cantidad | Porcentaje |")
md.append("|---|---|---|")
for estado, count in sorted(stats_by_state.items(), key=lambda x: -x[1]):
    pct = count / total_funcs * 100
    md.append(f"| {estado} | {count} | {pct:.1f}% |")
md.append(f"| **Total** | **{total_funcs}** | **100%** |")
md.append("")

md.append("### Distribución por Módulo")
md.append("")
md.append("| Módulo | Funcionalidades | HUs Documentadas | Completo | Parcial | Por Construir |")
md.append("|---|---|---|---|---|---|")
for folder_name, module_name, module_desc in MODULE_ORDER:
    mod_key = None
    for mk in stats_by_module:
        if module_name.lower()[:4] in mk.lower()[:6]:
            mod_key = mk
            break
    if not mod_key:
        for mk in stats_by_module:
            if folder_name.split('_')[1].lower()[:4] in mk.lower()[:6]:
                mod_key = mk
                break
    
    if mod_key and mod_key in stats_by_module:
        s = stats_by_module[mod_key]
        hus_count = len(all_modules_data.get(folder_name, {}).get('hus', []))
        completo = s['estados'].get('Completo', 0)
        parcial = s['estados'].get('Parcialmente', 0)
        por_construir = s['estados'].get('Por construir', 0)
        md.append(f"| {module_name} | {s['total']} | {hus_count} | {completo} | {parcial} | {por_construir} |")
    else:
        hus_count = len(all_modules_data.get(folder_name, {}).get('hus', []))
        if hus_count > 0:
            md.append(f"| {module_name} | - | {hus_count} | - | - | - |")

md.append("")
md.append("---")
md.append("")

# DETALLE POR MÓDULO
md.append("## 2. Análisis Detallado por Módulo")
md.append("")

for folder_name, module_name, module_desc in MODULE_ORDER:
    if folder_name not in all_modules_data:
        continue
    
    mod = all_modules_data[folder_name]
    hus = mod['hus']
    
    if not hus:
        continue
    
    md.append(f"### 2.{MODULE_ORDER.index((folder_name, module_name, module_desc))+1}. Módulo de {module_name}")
    md.append("")
    md.append(f"> **{module_desc}**")
    md.append(f"> ")
    md.append(f"> HUs documentadas: **{len(hus)}** | Carpeta: `{folder_name}/`")
    md.append("")
    
    # Agrupar HUs por proceso/subproceso
    processes = {}
    for hu in hus:
        proc = hu.get('proceso', '') or 'General'
        if proc not in processes:
            processes[proc] = []
        processes[proc].append(hu)
    
    # Tabla resumen del modulo
    md.append("#### Listado de Historias de Usuario")
    md.append("")
    md.append("| # | Archivo | Título | Descripción resumida |")
    md.append("|---|---|---|---|")
    
    for i, hu in enumerate(hus, 1):
        titulo = hu['titulo'][:80] if hu['titulo'] else hu['filename']
        desc = hu['descripcion'][:120] + '...' if len(hu['descripcion']) > 120 else hu['descripcion']
        desc = desc.replace('\n', ' ').replace('|', '-')
        titulo = titulo.replace('|', '-')
        md.append(f"| {i} | `{hu['filename']}` | {titulo} | {desc} |")
    
    md.append("")
    
    # Detalle de cada HU
    md.append("#### Detalle de cada HU")
    md.append("")
    
    for hu in hus:
        titulo = hu['titulo'] if hu['titulo'] else hu['filename']
        md.append(f"##### {titulo}")
        md.append("")
        
        if hu['descripcion']:
            # Limpiar descripcion
            desc = hu['descripcion'].replace('\n', ' ').strip()
            if len(desc) > 500:
                desc = desc[:500] + '...'
            md.append(f"**Descripción:** {desc}")
            md.append("")
        
        if hu['navegabilidad']:
            nav = hu['navegabilidad'].replace('\n', ' ').strip()
            md.append(f"**Navegación:** {nav}")
            md.append("")
        
        # Extraer criterios clave del contenido raw
        raw = hu['raw_content']
        
        # Buscar criterios de aceptacion
        criterios_section = ""
        in_criterios = False
        for line in raw.split('\n'):
            if 'criterios de aceptación' in line.lower() or '6. criterios' in line.lower():
                in_criterios = True
                continue
            if in_criterios:
                if re.match(r'^[7-9]\.\s', line.strip()) or 'campos del' in line.lower():
                    break
                criterios_section += line + '\n'
        
        if criterios_section.strip():
            md.append("**Criterios de Aceptación clave:**")
            md.append("")
            criteria_lines = [l.strip() for l in criterios_section.split('\n') if l.strip() and len(l.strip()) > 5]
            for cl in criteria_lines[:10]:
                cl = cl.lstrip('*- ')
                cl = re.sub(r'^\d+\.\s*', '', cl)
                if cl and len(cl) > 5:
                    md.append(f"- {cl}")
            md.append("")
        
        # Integraciones
        if hu['integracion']:
            integ = hu['integracion'].replace('\n', ' ').strip()
            if len(integ) > 300:
                integ = integ[:300] + '...'
            md.append(f"**Integraciones:** {integ}")
            md.append("")
        
        md.append("---")
        md.append("")
    
    md.append("")

# SECCIÓN 3: INTEGRACIONES ENTRE MÓDULOS
md.append("## 3. Mapa de Integraciones entre Módulos")
md.append("")
md.append("El sistema Restaurant.pe opera como un ERP integrado donde los módulos se comunican entre sí:")
md.append("")
md.append("```")
md.append("                    ┌─────────────────┐")
md.append("                    │  CONFIGURACIONES │")
md.append("                    │  (Multicompañía, │")
md.append("                    │   Localización)  │")
md.append("                    └────────┬─────────┘")
md.append("                             │")
md.append("    ┌────────────┬───────────┼───────────┬────────────┐")
md.append("    │            │           │           │            │")
md.append("┌───▼───┐   ┌───▼───┐  ┌────▼───┐  ┌───▼───┐  ┌────▼────┐")
md.append("│COMPRAS│──▶│ALMACÉN│◀─│ VENTAS │  │ RRHH  │  │PRODUCCIÓN│")
md.append("└───┬───┘   └───┬───┘  └────┬───┘  └───┬───┘  └────┬────┘")
md.append("    │           │           │           │            │")
md.append("    └─────┬─────┴─────┬─────┘           │            │")
md.append("          │           │                 │            │")
md.append("     ┌────▼────┐ ┌───▼────┐            │            │")
md.append("     │FINANZAS │ │ACTIVOS │            │            │")
md.append("     │CxP/CxC  │ │ FIJOS  │            │            │")
md.append("     └────┬────┘ └───┬────┘            │            │")
md.append("          │          │                  │            │")
md.append("          └────┬─────┴──────────────────┘────────────┘")
md.append("               │")
md.append("        ┌──────▼──────┐")
md.append("        │CONTABILIDAD │")
md.append("        │(Asientos,   │")
md.append("        │ Libros, EEFF)│")
md.append("        └─────────────┘")
md.append("```")
md.append("")
md.append("### Flujos principales de integración:")
md.append("")
md.append("1. **Compras → Almacén:** Las órdenes de compra generan recepciones de mercadería en almacén")
md.append("2. **Compras → Finanzas (CxP):** Las facturas de proveedores generan documentos por pagar")
md.append("3. **Ventas → Almacén:** Las ventas descuentan stock automáticamente")
md.append("4. **Ventas → Finanzas (CxC):** Las facturas de venta generan documentos por cobrar")
md.append("5. **Finanzas → Contabilidad:** Los pagos, cobros y movimientos generan asientos contables")
md.append("6. **Almacén → Contabilidad:** Los movimientos de inventario generan asientos de kardex")
md.append("7. **RRHH → Contabilidad:** La nómina genera asientos de provisiones y gastos")
md.append("8. **Activos Fijos → Contabilidad:** La depreciación genera asientos automáticos")
md.append("9. **Producción → Almacén:** Consume materias primas y genera productos terminados")
md.append("10. **Producción → Contabilidad:** Los costos de producción generan asientos")
md.append("")
md.append("---")
md.append("")

# SECCIÓN 4: ANÁLISIS CRÍTICO
md.append("## 4. Análisis Crítico y Observaciones")
md.append("")
md.append("### 4.1. Fortalezas del diseño")
md.append("")
md.append("1. **Documentación estructurada:** Todas las HUs siguen un formato estándar con título, descripción, criterios de aceptación, campos, integraciones y consideraciones técnicas")
md.append("2. **Visión integral:** El sistema cubre todos los procesos de un restaurante/cadena: desde la compra de insumos hasta los estados financieros")
md.append("3. **Multipaís desde el diseño:** Se contempla desde el inicio la operación en múltiples países con normativas diferentes")
md.append("4. **Trazabilidad completa:** Log de auditoría contable en todas las operaciones")
md.append("5. **Integración contable nativa:** Todos los módulos generan asientos contables, asegurando consistencia financiera")
md.append("")
md.append("### 4.2. Áreas de atención")
md.append("")
md.append("1. **Módulo de Ventas poco documentado:** Solo 2 HUs con URL (Facturación de Regalías y Reporte Tributario), mientras que las demás funcionalidades de ventas no tienen HU asociada, probablemente porque ya están implementadas en el POS actual")
md.append("2. **Módulo de Producción sin HUs formales:** 42 funcionalidades identificadas pero solo 1 con HU documentada (Gastos Indirectos de Fabricación), indicando que es un módulo en etapa temprana de definición")
md.append("3. **Dependencia secuencial:** Módulos como Contabilidad y Activos Fijos dependen de que Finanzas y Almacén estén completos")
md.append("4. **Complejidad de localización:** El soporte multipaís implica configurar impuestos, retenciones, detracciones, formatos SUNAT/DIAN y libros electrónicos por cada país")
md.append("5. **6 HUs inaccesibles:** Documentos con permisos restringidos que no pudieron ser descargados")
md.append("")
md.append("### 4.3. Patrones recurrentes en las HUs")
md.append("")
md.append("Todas las HUs comparten un patrón de diseño consistente:")
md.append("")
md.append("- **CRUD completo:** Crear, leer, actualizar y desactivar (nunca eliminar datos con movimientos)")
md.append("- **Campos informativos:** Razón Social y País siempre de solo lectura, heredados del contexto del usuario")
md.append("- **Auditoría obligatoria:** Usuario, fecha, hora, IP y acción en cada operación")
md.append("- **Exportación estándar:** Excel y PDF en todos los listados y reportes")
md.append("- **Validaciones de integridad:** No permitir eliminar registros con movimientos asociados")
md.append("- **Perfiles de acceso:** Control granular de permisos por rol de usuario")
md.append("")
md.append("---")
md.append("")

# SECCIÓN 5: CONCLUSIÓN
md.append("## 5. Conclusión")
md.append("")
md.append("Restaurant.pe es un **ERP completo para la industria gastronómica** que abarca 9 módulos funcionales con más de 270 funcionalidades identificadas. El sistema está diseñado para operar en un entorno **multipaís, multiempresa y multisucursal**, lo que lo hace adecuado para cadenas de restaurantes y franquicias internacionales.")
md.append("")
md.append("El proyecto se encuentra en un estado mixto de desarrollo:")
md.append("")
completo_total = stats_by_state.get('Completo', 0)
parcial_total = stats_by_state.get('Parcialmente', 0)
por_construir_total = stats_by_state.get('Por construir', 0)
md.append(f"- **{completo_total} funcionalidades completas** ({completo_total/total_funcs*100:.0f}%): Base operativa funcional")
md.append(f"- **{parcial_total} funcionalidades parciales** ({parcial_total/total_funcs*100:.0f}%): Requieren mejoras o complementos")
md.append(f"- **{por_construir_total} funcionalidades por construir** ({por_construir_total/total_funcs*100:.0f}%): Desarrollo pendiente")
md.append("")
md.append("Los módulos con mayor madurez son **Almacén**, **Compras** y **Ventas**, mientras que **Contabilidad**, **Activos Fijos** y **RRHH** están mayormente por construir, representando la mayor carga de desarrollo futuro.")
md.append("")
md.append("La documentación de HUs es sólida y bien estructurada, proporcionando una base clara para el desarrollo, con criterios de aceptación específicos, campos definidos e integraciones documentadas.")
md.append("")

# Escribir archivo
with open(OUTPUT_MD, 'w', encoding='utf-8') as f:
    f.write('\n'.join(md))

print(f"\nArchivo generado: {OUTPUT_MD}")
print(f"Tamano: {len('\\n'.join(md))/1024:.1f} KB")
print(f"Lineas: {len(md)}")
