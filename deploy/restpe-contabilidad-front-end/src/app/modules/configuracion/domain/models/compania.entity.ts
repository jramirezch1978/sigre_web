/**
 * @summary Entidad de dominio para Compañía
 * @description Representa una compañía en el sistema de configuración
 */
export interface CompaniaEntity {
  compania_codigo: string;
  compania_razon_social: string;
  compania_direccion_fiscal: string;
  compania_correo_electronico: string;
  compania_contable_desde: string;
  compania_estado: string;
  compania_ruc?: string;
  compania_zona_horaria?: string;
  compania_nombre_comercial?: string;
  compania_idioma?: string;
}
