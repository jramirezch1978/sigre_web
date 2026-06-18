export interface CategoriaArticuloEntity {
  categoria_articulo_org_hierarchy: string[];
  categoria_articulo_descripcion: string;
  categoria_articulo_sucursales: string[];
  categoria_articulo_padre: string | null;
  categoria_articulo_observacion: string;
  categoria_articulo_nivel: string;
  categoria_articulo_fecha_creacion: string;
  categoria_articulo_estado: string;
  categoria_articulo_is_categoria?: boolean;
}
