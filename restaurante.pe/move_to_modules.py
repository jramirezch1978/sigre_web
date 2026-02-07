# -*- coding: utf-8 -*-
"""
Script para mover los documentos descargados a subcarpetas por módulo
dentro de docs_descargados/
"""

import json
import os
import re
import shutil
import sys

sys.stdout.reconfigure(encoding='utf-8')

BASE_DIR = r'e:\Work\sigre_web\restaurante.pe'
DOCS_DIR = os.path.join(BASE_DIR, 'docs_descargados')
EXTRACTED_FILE = os.path.join(BASE_DIR, 'extracted_data.json')

# Cargar datos del inventario
with open(EXTRACTED_FILE, 'r', encoding='utf-8') as f:
    data = json.load(f)

# Construir mapa: doc_id -> modulo
consolidado = data.get('Consolidado', {})
hlinks = consolidado.get('hyperlinks', {})
rows = consolidado.get('rows', [])

# Primero, construir lista de modulos por fila (propagando hacia abajo)
row_modules = {}
current_module = ""
for i, row in enumerate(rows):
    if row[0]:
        current_module = row[0]
    row_modules[i] = current_module

# Mapear doc_id -> (modulo, titulo_hu, funcionalidad)
doc_to_module = {}
for coord, url in hlinks.items():
    m = re.search(r'/document/d/([a-zA-Z0-9_-]+)', url)
    if not m:
        continue
    doc_id = m.group(1)
    row_num = int(re.search(r'\d+', coord).group())
    row_idx = row_num - 1

    if row_idx in row_modules:
        modulo = row_modules[row_idx]
        titulo_hu = rows[row_idx][6] if row_idx < len(rows) and len(rows[row_idx]) > 6 else ""
        funcionalidad = rows[row_idx][4] if row_idx < len(rows) and len(rows[row_idx]) > 4 else ""
        doc_to_module[doc_id] = {
            'modulo': modulo,
            'titulo_hu': titulo_hu or "",
            'funcionalidad': funcionalidad or ""
        }

# También revisar otras hojas por si tienen doc_ids adicionales
for sheet_name, sheet_data in data.items():
    if sheet_name == 'Consolidado':
        continue
    sheet_hlinks = sheet_data.get('hyperlinks', {})
    for coord, url in sheet_hlinks.items():
        m_doc = re.search(r'/document/d/([a-zA-Z0-9_-]+)', url)
        if m_doc:
            did = m_doc.group(1)
            if did not in doc_to_module:
                # Inferir modulo del nombre de la hoja
                mod = sheet_name
                if 'Almac' in mod: mod = 'Almacén'
                elif 'Compra' in mod: mod = 'Compras'
                elif 'Venta' in mod: mod = 'Ventas'
                elif 'Finanza' in mod: mod = 'Finanzas'
                elif 'RRHH' in mod: mod = 'RR.HH'
                elif 'Activo' in mod: mod = 'Activos fijos'
                elif 'Contab' in mod: mod = 'Contabilidad'
                doc_to_module[did] = {'modulo': mod, 'titulo_hu': '', 'funcionalidad': ''}


def get_folder_name(modulo):
    """Devuelve nombre de carpeta normalizado."""
    m = modulo.lower().strip()
    if 'almac' in m: return '01_Almacen'
    if 'compra' in m: return '02_Compras'
    if 'venta' in m: return '03_Ventas'
    if 'finanz' in m: return '04_Finanzas'
    if 'contab' in m: return '05_Contabilidad'
    if 'activo' in m: return '06_Activos_Fijos'
    if 'rr' in m or 'rrhh' in m or 'recurso' in m: return '07_RRHH'
    if 'producc' in m: return '08_Produccion'
    if 'config' in m: return '09_Configuraciones'
    return '00_Sin_Modulo'


def sanitize(name, max_len=80):
    """Limpia nombre de archivo."""
    name = re.sub(r'[<>:"/\\|?*\n\r]', '', name)
    name = re.sub(r'\s+', ' ', name).strip()
    name = name.replace('\u2013', '-').replace('\u2014', '-')
    name = name.replace('\u00e9', 'e').replace('\u00f3', 'o').replace('\u00ed', 'i')
    name = name.replace('\u00e1', 'a').replace('\u00fa', 'u').replace('\u00f1', 'n')
    return name[:max_len]


# Mover archivos
moved = 0
not_mapped = 0
already_moved = 0

for filename in os.listdir(DOCS_DIR):
    filepath = os.path.join(DOCS_DIR, filename)
    
    # Saltar directorios, log y archivos no-txt
    if os.path.isdir(filepath):
        continue
    if filename.startswith('_') or not filename.endswith('.txt'):
        continue
    
    doc_id = filename.replace('.txt', '')
    
    if doc_id in doc_to_module:
        info = doc_to_module[doc_id]
        folder = get_folder_name(info['modulo'])
        
        # Crear carpeta del modulo
        module_dir = os.path.join(DOCS_DIR, folder)
        os.makedirs(module_dir, exist_ok=True)
        
        # Generar nombre descriptivo
        titulo = info['titulo_hu'] or info['funcionalidad'] or doc_id
        hu_code = re.search(r'(HU-[A-Z]+-[A-Z0-9-]+)', titulo)
        if hu_code:
            clean_name = sanitize(hu_code.group(1))
        else:
            clean_name = sanitize(titulo[:70])
        
        dest_file = os.path.join(module_dir, f"{clean_name}.txt")
        
        # Evitar duplicados
        counter = 1
        while os.path.exists(dest_file):
            dest_file = os.path.join(module_dir, f"{clean_name}_{counter}.txt")
            counter += 1
        
        shutil.move(filepath, dest_file)
        moved += 1
    else:
        # Mover a carpeta sin modulo
        other_dir = os.path.join(DOCS_DIR, '00_Sin_Modulo')
        os.makedirs(other_dir, exist_ok=True)
        shutil.move(filepath, os.path.join(other_dir, filename))
        not_mapped += 1

# Resumen
print("=" * 80)
print("RESULTADO DE ORGANIZACION")
print("=" * 80)
print(f"  Archivos movidos: {moved}")
print(f"  Sin modulo asignado: {not_mapped}")
print(f"\nEstructura final en {DOCS_DIR}:")

for d in sorted(os.listdir(DOCS_DIR)):
    full = os.path.join(DOCS_DIR, d)
    if os.path.isdir(full):
        files = [f for f in os.listdir(full) if f.endswith('.txt')]
        print(f"  {d}/ ({len(files)} archivos)")
        for f in sorted(files)[:5]:
            print(f"    - {f}")
        if len(files) > 5:
            print(f"    ... y {len(files) - 5} mas")
