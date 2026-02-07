# -*- coding: utf-8 -*-
"""
Script para descargar todos los documentos de Google Docs
referenciados en el archivo extracted_data.json.
Exporta cada documento como texto plano (.txt).
"""

import json
import re
import os
import time
import urllib.request
import urllib.error
import ssl

# Configuracion
INPUT_FILE = r'e:\Work\sigre_web\restaurante.pe\extracted_data.json'
OUTPUT_DIR = r'e:\Work\sigre_web\restaurante.pe\docs_descargados'

# Crear directorio de salida
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Cargar datos
with open(INPUT_FILE, 'r', encoding='utf-8') as f:
    data = json.load(f)

# Extraer URLs unicas y mapear doc_id -> info
doc_map = {}
for sheet_name, sheet_data in data.items():
    if 'hyperlinks' in sheet_data:
        for coord, url in sheet_data['hyperlinks'].items():
            if 'docs.google.com/document' in url:
                m = re.search(r'/document/d/([a-zA-Z0-9_-]+)', url)
                if m:
                    doc_id = m.group(1)
                    if doc_id not in doc_map:
                        # Buscar titulo en los datos de la hoja
                        row_num = int(re.search(r'\d+', coord).group())
                        title = ""
                        for row in sheet_data.get('rows', []):
                            # Buscar en las filas algo que coincida
                            pass
                        doc_map[doc_id] = {
                            'url': url,
                            'sheet': sheet_name,
                            'coord': coord
                        }

print(f"Total documentos a descargar: {len(doc_map)}")
print(f"Directorio de salida: {OUTPUT_DIR}")
print("=" * 80)

# Contexto SSL sin verificacion (para evitar problemas de certificados)
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

# Descargar cada documento
success_count = 0
error_count = 0
errors = []

for i, (doc_id, info) in enumerate(doc_map.items(), 1):
    # URL de exportacion como texto plano
    export_url = f"https://docs.google.com/document/d/{doc_id}/export?format=txt"
    filename = f"{doc_id}.txt"
    filepath = os.path.join(OUTPUT_DIR, filename)

    # Si ya existe, saltar
    if os.path.exists(filepath) and os.path.getsize(filepath) > 0:
        print(f"[{i}/{len(doc_map)}] YA EXISTE: {filename}")
        success_count += 1
        continue

    try:
        req = urllib.request.Request(export_url)
        req.add_header('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36')
        
        with urllib.request.urlopen(req, context=ctx, timeout=30) as response:
            content = response.read()
            
            with open(filepath, 'wb') as f:
                f.write(content)
            
            size_kb = len(content) / 1024
            print(f"[{i}/{len(doc_map)}] OK: {filename} ({size_kb:.1f} KB) - {info['sheet']}:{info['coord']}")
            success_count += 1
            
    except urllib.error.HTTPError as e:
        print(f"[{i}/{len(doc_map)}] ERROR HTTP {e.code}: {filename} - {info['sheet']}:{info['coord']}")
        errors.append({'doc_id': doc_id, 'error': f'HTTP {e.code}', 'info': info})
        error_count += 1
    except Exception as e:
        print(f"[{i}/{len(doc_map)}] ERROR: {filename} - {str(e)[:80]}")
        errors.append({'doc_id': doc_id, 'error': str(e), 'info': info})
        error_count += 1

    # Pausa para no saturar (rate limiting)
    time.sleep(0.5)

print("\n" + "=" * 80)
print(f"RESUMEN:")
print(f"  Exitosos: {success_count}")
print(f"  Errores:  {error_count}")
print(f"  Total:    {len(doc_map)}")

if errors:
    print(f"\nDocumentos con error:")
    for err in errors:
        print(f"  - {err['doc_id']}: {err['error']} ({err['info']['sheet']}:{err['info']['coord']})")

# Guardar log
log_file = os.path.join(OUTPUT_DIR, '_download_log.json')
with open(log_file, 'w', encoding='utf-8') as f:
    json.dump({
        'total': len(doc_map),
        'success': success_count,
        'errors': error_count,
        'error_details': errors,
        'doc_map': {k: v for k, v in doc_map.items()}
    }, f, ensure_ascii=False, indent=2)

print(f"\nLog guardado en: {log_file}")
