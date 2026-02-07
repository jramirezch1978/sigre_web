# -*- coding: utf-8 -*-
"""
Script para organizar los documentos descargados:
- Renombrar con nombres descriptivos basados en el titulo de la HU
- Organizar en carpetas por modulo
- Crear un indice maestro
"""

import json
import os
import re
import shutil
import sys

sys.stdout.reconfigure(encoding='utf-8')

# Rutas
BASE_DIR = r'e:\Work\sigre_web\restaurante.pe'
DOCS_DIR = os.path.join(BASE_DIR, 'docs_descargados')
ORGANIZED_DIR = os.path.join(BASE_DIR, 'HUs_por_modulo')
EXTRACTED_FILE = os.path.join(BASE_DIR, 'extracted_data.json')

# Cargar datos del inventario
with open(EXTRACTED_FILE, 'r', encoding='utf-8') as f:
    data = json.load(f)

# Construir mapa: doc_id -> info del registro (modulo, titulo HU, descripcion)
doc_info_map = {}
consolidado = data.get('Consolidado', {})
hlinks = consolidado.get('hyperlinks', {})
rows = consolidado.get('rows', [])

# Headers del consolidado
headers = rows[0] if rows else []

for coord, url in hlinks.items():
    m = re.search(r'/document/d/([a-zA-Z0-9_-]+)', url)
    if not m:
        continue
    doc_id = m.group(1)
    
    # Extraer numero de fila de la coordenada (ej: G2 -> 2)
    row_num = int(re.search(r'\d+', coord).group())
    col_letter = re.search(r'[A-Z]+', coord).group()
    
    # Buscar la fila correspondiente (row_num - 1 porque el indice empieza en 0)
    row_idx = row_num - 1
    if row_idx < len(rows):
        row = rows[row_idx]
        modulo = row[0] if len(row) > 0 and row[0] else ""
        proceso = row[1] if len(row) > 1 and row[1] else ""
        subproceso = row[2] if len(row) > 2 and row[2] else ""
        estado = row[3] if len(row) > 3 and row[3] else ""
        funcionalidad = row[4] if len(row) > 4 and row[4] else ""
        descripcion = row[5] if len(row) > 5 and row[5] else ""
        titulo_hu = row[6] if len(row) > 6 and row[6] else ""
        
        # Propagar modulo si esta vacio (las filas heredan del bloque anterior)
        if not modulo:
            for prev_idx in range(row_idx - 1, -1, -1):
                prev_row = rows[prev_idx]
                if prev_row[0]:
                    modulo = prev_row[0]
                    break
        
        doc_info_map[doc_id] = {
            'modulo': modulo,
            'proceso': proceso,
            'subproceso': subproceso,
            'estado': estado,
            'funcionalidad': funcionalidad,
            'descripcion': descripcion,
            'titulo_hu': titulo_hu,
            'url': url,
            'coord': coord
        }


def sanitize_filename(name, max_len=80):
    """Limpia un nombre para usarlo como nombre de archivo."""
    # Remover caracteres invalidos
    name = re.sub(r'[<>:"/\\|?*]', '', name)
    name = re.sub(r'\s+', ' ', name).strip()
    name = name[:max_len]
    return name


def get_module_folder(modulo):
    """Normaliza nombre de modulo para carpeta."""
    modulo_map = {
        'Almacén': '01_Almacen',
        'Almacen': '01_Almacen',
        'Compras': '02_Compras',
        'Ventas': '03_Ventas',
        'Finanzas': '04_Finanzas',
        'Contabilidad': '05_Contabilidad',
        'Activos fijos': '06_Activos_Fijos',
        'RR.HH': '07_RRHH',
        'Produccion': '08_Produccion',
        'Producción': '08_Produccion',
        'Configuraciones': '09_Configuraciones',
    }
    for key, val in modulo_map.items():
        if key.lower() in modulo.lower():
            return val
    return '00_Otros'


# Crear estructura de carpetas y copiar archivos
os.makedirs(ORGANIZED_DIR, exist_ok=True)
indice = []
copied = 0
not_found = 0

for doc_id, info in doc_info_map.items():
    src_file = os.path.join(DOCS_DIR, f"{doc_id}.txt")
    if not os.path.exists(src_file):
        not_found += 1
        continue
    
    # Determinar carpeta del modulo
    folder_name = get_module_folder(info['modulo'])
    module_dir = os.path.join(ORGANIZED_DIR, folder_name)
    os.makedirs(module_dir, exist_ok=True)
    
    # Generar nombre descriptivo
    titulo = info['titulo_hu'] or info['funcionalidad'] or doc_id
    # Extraer codigo HU si existe
    hu_code = re.search(r'(HU-[A-Z]+-[A-Z0-9-]+)', titulo)
    if hu_code:
        clean_name = sanitize_filename(hu_code.group(1))
    else:
        clean_name = sanitize_filename(titulo[:60])
    
    dest_file = os.path.join(module_dir, f"{clean_name}.txt")
    
    # Evitar duplicados
    counter = 1
    while os.path.exists(dest_file):
        dest_file = os.path.join(module_dir, f"{clean_name}_{counter}.txt")
        counter += 1
    
    shutil.copy2(src_file, dest_file)
    copied += 1
    
    indice.append({
        'modulo': info['modulo'],
        'carpeta': folder_name,
        'archivo': os.path.basename(dest_file),
        'titulo_hu': info['titulo_hu'],
        'funcionalidad': info['funcionalidad'],
        'estado': info['estado'],
        'descripcion': info['descripcion'],
        'url_original': info['url']
    })

# Crear indice maestro
indice_file = os.path.join(ORGANIZED_DIR, '_INDICE_MAESTRO.json')
with open(indice_file, 'w', encoding='utf-8') as f:
    json.dump(indice, f, ensure_ascii=False, indent=2)

# Crear indice en texto
indice_txt = os.path.join(ORGANIZED_DIR, '_INDICE_MAESTRO.txt')
with open(indice_txt, 'w', encoding='utf-8') as f:
    f.write("INDICE MAESTRO DE HISTORIAS DE USUARIO\n")
    f.write("=" * 80 + "\n\n")
    
    current_module = ""
    for item in sorted(indice, key=lambda x: (x['carpeta'], x['archivo'])):
        if item['carpeta'] != current_module:
            current_module = item['carpeta']
            f.write(f"\n{'=' * 80}\n")
            f.write(f"MODULO: {item['modulo']} ({current_module})\n")
            f.write(f"{'=' * 80}\n\n")
        
        f.write(f"  Archivo: {item['archivo']}\n")
        f.write(f"  Titulo: {item['titulo_hu']}\n")
        f.write(f"  Funcionalidad: {item['funcionalidad']}\n")
        f.write(f"  Estado: {item['estado']}\n")
        f.write(f"  URL: {item['url_original']}\n")
        f.write(f"  ---\n")

print(f"\nRESUMEN DE ORGANIZACION:")
print(f"  Documentos copiados: {copied}")
print(f"  No encontrados: {not_found}")
print(f"  Directorio: {ORGANIZED_DIR}")
print(f"\nEstructura creada:")
for d in sorted(os.listdir(ORGANIZED_DIR)):
    full = os.path.join(ORGANIZED_DIR, d)
    if os.path.isdir(full):
        count = len([f for f in os.listdir(full) if f.endswith('.txt')])
        print(f"  {d}/ ({count} archivos)")
    else:
        print(f"  {d}")
