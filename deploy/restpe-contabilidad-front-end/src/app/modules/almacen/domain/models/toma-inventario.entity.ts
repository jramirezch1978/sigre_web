export interface TomaInventarioEntity {
    toma_inventario_codigo: string;
    toma_inventario_producto: string;
    toma_inventario_observacion: string;
    toma_inventario_categoria: string;
    toma_inventario_medida: string;
    toma_inventario_stock_fisico: number;
    toma_inventario_stock_sistema: number;
    toma_inventario_diferencia: number;
    toma_inventario_diferencia_valor: number;
    toma_inventario_tipo_diferencia: string;
    toma_inventario_almacen: string;
    toma_inventario_persona_responsable: string;
    toma_inventario_ultimo_cambio: string;
    toma_inventario_condicion: string;
}
