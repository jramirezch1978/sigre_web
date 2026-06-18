/**
 * Entidad de dominio: Proveedor.
 * Convención: proveedor_campo / cuenta_bancaria_campo
 */
export interface CuentaBancariaEntity {
  cuenta_bancaria_banco:          string;
  cuenta_bancaria_numero_cuenta:  string;
  cuenta_bancaria_cci:            string;
  cuenta_bancaria_tipo:           string;
  cuenta_bancaria_moneda:         string;
  cuenta_bancaria_estado:         string;
}

export interface ProveedorEntity {
  id?:                                  number;
  proveedor_codigo:                    string;
  proveedor_razon_social:              string;
  proveedor_identificacion_fiscal:     string;
  proveedor_tipo_doc_identidad_id?:    number;
  proveedor_estado:                    string;
  proveedor_condicion_pago:            string;
  proveedor_nombre_comercial?:         string;
  proveedor_direccion_fiscal?:         string;
  proveedor_email?:                    string;
  proveedor_telefono?:                 string;
  proveedor_tipo?:                     string;
  proveedor_nombre_contacto?:          string;
  proveedor_cargo_contacto?:           string;
  proveedor_telefono_contacto?:        string;
  proveedor_email_contacto?:           string;
  proveedor_condicion_pago_comercial?: string;
  proveedor_plazo_credito?:            string;
  proveedor_cuentas_bancarias?:        CuentaBancariaEntity[];
}
