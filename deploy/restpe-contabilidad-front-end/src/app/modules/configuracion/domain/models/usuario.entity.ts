export interface UsuarioEntity {
  usuario_usuario: string;
  usuario_nombre: string;
  usuario_apellido: string;
  usuario_cargo: string;
  usuario_estado: 'Activo' | 'Inactivo';
  usuario_email: string;
  usuario_dni: string;
  usuario_telefono: string;
  usuario_clave: string;
  usuario_direccion: string;
}
