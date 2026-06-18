export interface AgrupacionSedeEntity {
  agrupacion_sede_codigo: string;
  agrupacion_sede_fecha_creacion: string;
  agrupacion_sede_nombre: string;
  agrupacion_sede_criterio_principal: string;
  agrupacion_sede_num_trabajadores: number;
  agrupacion_sede_estado: string;
  agrupacion_sede_sede?: string;
  agrupacion_sede_centro_costo?: string;
  agrupacion_sede_canal?: string;
  agrupacion_sede_cargo?: string;
  agrupacion_sede_salario?: string;
  agrupacion_sede_descripcion?: string;
  trabajadores?: any[];
}
