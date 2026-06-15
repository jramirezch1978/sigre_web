export interface RazonSocialEntity {
  id: number;
  imgUrl: string;
  nombre: string;
  docFiscal: string;
  direccion: string;
  sucursales: string[];
  estado: 'Activo' | 'Inactivo';
}
