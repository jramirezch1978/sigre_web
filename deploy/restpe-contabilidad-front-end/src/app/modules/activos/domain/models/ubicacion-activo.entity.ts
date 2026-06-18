export interface UbicacionActivoEntity {
  id?: string;
  ubic_codigo:          string;
  ubic_nombre:          string;
  ubic_nivel:           string;   // '01' | '02' | '03'
  ubic_descripcion:     string;
  ubic_responsable:     string;
  ubic_ubicacion_padre: string;
  ubic_estado:          string;   // Activo | Inactivo
  ubic_cod_interno?:    string;
  ubic_observaciones?:  string;
  ubic_org_hierarchy?:  string[];
}
