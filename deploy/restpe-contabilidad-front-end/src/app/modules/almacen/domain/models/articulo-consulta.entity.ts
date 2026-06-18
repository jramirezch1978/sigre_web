export interface ArticuloConsultaEntity {
    almacen_codigo: string;
    nombre: string;
    codBarras: string;
    medida: string;
    categoria: string;
    stockActual: number;
    precioVenta: number;
    precioCompra: number;
    estado: string;
    usuarioResponsable: string;
    almacenPrincipal: string;
    puntoReposicion: number;
    proveedorHabitual: string;
    impuestoA: number;
    naturalezaC: string;
    cuentaCI: string;
    cuentaCV: string;
    unidad: string;
}
