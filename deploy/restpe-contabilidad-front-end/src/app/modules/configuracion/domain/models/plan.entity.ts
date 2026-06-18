export interface PlanEntity {
  plan_nombre: string;
  plan_precio: string;
  plan_usuarios: number;
  plan_cajas: number;
  plan_facturacion_max: string;
  plan_modulos: string[];
  plan_dispositivo_adicional: string;
  plan_is_actual: boolean;
}
