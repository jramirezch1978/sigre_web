/**
 * Entidad de Aseguradora.
 * Nomenclatura: tabla_campo (convención del diagrama de base de datos).
 * Refleja la estructura del JSON en assets/data/activo-fijo/tabla/aseguradoras.json
 * y los campos guardados en localStorage.
 */
export interface AseguradoraEntity {
  // Identificador opcional (para localStorage)
  id?: string;
  // Campos de ASEGURADORA
  aseguradora_codigo:                string;
  aseguradora_razon_social:          string;
  aseguradora_doc_fiscal:            string;
  aseguradora_tipo_documento?:       string;
  aseguradora_direccion_fiscal?:     string;
  aseguradora_telefono?:             string;
  aseguradora_correo?:               string;
  aseguradora_contacto?:             string;
  aseguradora_pagina_web?:           string;
  aseguradora_condiciones_comerciales?: string;
  aseguradora_observaciones?:        string;
  aseguradora_estado:                string;
  // Metadatos
  aseguradora_fecha_creacion?:       string;
  aseguradora_fecha_modificacion?:   string;
}
