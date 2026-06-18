export interface DevolucionConsultaEntity {
    almacen_codigo: string;
    producto: string;
    proveedor: string;
    almacen: string;
    medida: string;
    tipoDoc: string;
    devolucion: number;
    saldo: number;
    fechaDevolucion: string;
    estado: string;
    unidadMedida?: string;
    guia?: string;
    monto?: number;
    ordenCompra?: string;
    precioUnitario?: number;
    cantidadDevolver?: number;
    fechaRegistro?: string;
    ordenAsociada?: string;
}
