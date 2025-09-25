#!/usr/bin/env node

/**
 * Script para generar automáticamente el archivo version.json durante el build
 * Se ejecuta antes de la compilación para actualizar la versión y timestamp
 */

const fs = require('fs');
const path = require('path');

// Generar timestamp actual
const now = new Date();
const buildTimestamp = now.toISOString();

// Generar versión basada en año y mes de compilación
const year = now.getFullYear();
const month = String(now.getMonth() + 1).padStart(2, '0'); // getMonth() devuelve 0-11, por eso sumamos 1
const version = `${year}.${month}`;

// Crear objeto de versión
const versionInfo = {
  version: version,
  buildTimestamp: buildTimestamp,
  buildDate: now.toLocaleDateString('es-PE', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  })
};

// Ruta del archivo version.json
const versionFilePath = path.join(__dirname, '..', 'src', 'assets', 'version.json');

// Escribir el archivo
fs.writeFileSync(versionFilePath, JSON.stringify(versionInfo, null, 2));

console.log(`✅ Versión generada automáticamente:`);
console.log(`   📦 Versión: ${versionInfo.version}`);
console.log(`   🕒 Build Timestamp: ${versionInfo.buildTimestamp}`);
console.log(`   📅 Build Date: ${versionInfo.buildDate}`);
console.log(`   📄 Archivo: ${versionFilePath}`);
