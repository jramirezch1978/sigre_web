export interface CargoFuncion {
  numero: number;
  descripcion: string;
}

export interface DefinicionCargosEntity {
  cargo_codigo: string;
  cargo_nombre: string;
  cargo_funciones: CargoFuncion[];
  cargo_area: string;
  cargo_centro_costos: string;
  cargo_categoria: string;
  cargo_nivel: string;
  cargo_salario_minimo: number;
  cargo_salario_promedio: number;
  cargo_salario_maximo: number;
  cargo_vigencia: string;
  cargo_estado: string;
}
