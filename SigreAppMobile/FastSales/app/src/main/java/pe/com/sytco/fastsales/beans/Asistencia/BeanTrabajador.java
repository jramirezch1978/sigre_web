package pe.com.sytco.fastsales.beans.Asistencia;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.util.Hashtable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanTrabajador extends BeanAncestor implements Serializable, KvmSerializable {
    
    private String codTrabajador;
    private String apelPaterno;
    private String apelMaterno;
    private String nombre1;
    private String nombre2;
    private String dni;
    private String tipoDocIdentRtps;
    private String nroDocIdentRtps;
    private byte[] fotoBlob;
    private String flagEstado;
    private String codOrigen;
    private String nomTrabajador;  // Nombre completo desde el backend
    private String fechaCese;      // Fecha de cese del trabajador (formato: dd/MM/yyyy)
    private String fechaNacimiento; // Fecha de nacimiento (formato: dd/MM/yyyy)
    private String fechaIngreso;   // Fecha de ingreso (formato: dd/MM/yyyy)
    private String cargo;          // Cargo del trabajador
    private String area;           // Área del trabajador
    
    public BeanTrabajador() {
        this.codTrabajador = "";
        this.apelPaterno = "";
        this.apelMaterno = "";
        this.nombre1 = "";
        this.nombre2 = "";
        this.dni = "";
        this.tipoDocIdentRtps = "";
        this.nroDocIdentRtps = "";
        this.flagEstado = "";
        this.codOrigen = "";
        this.nomTrabajador = "";
        this.fechaCese = "";
        this.fechaNacimiento = "";
        this.fechaIngreso = "";
        this.cargo = "";
        this.area = "";
    }

    @Override
    public Object getProperty(int i) {
        switch(i) {
            case 0: return codTrabajador;
            case 1: return apelPaterno;
            case 2: return apelMaterno;
            case 3: return nombre1;
            case 4: return nombre2;
            case 5: return dni;
            case 6: return tipoDocIdentRtps;
            case 7: return nroDocIdentRtps;
            case 8: return fotoBlob;
            case 9: return flagEstado;
            case 10: return codOrigen;
            case 11: return fechaCese;
            case 12: return fechaNacimiento;
            case 13: return fechaIngreso;
            case 14: return cargo;
            case 15: return area;
        }
        return null;
    }

    @Override
    public int getPropertyCount() {
        return 16;
    }

    @Override
    public void setProperty(int i, Object value) {
        switch(i) {
            case 0:
                codTrabajador = value.toString();
                break;
            case 1:
                apelPaterno = value.toString();
                break;
            case 2:
                apelMaterno = value.toString();
                break;
            case 3:
                nombre1 = value.toString();
                break;
            case 4:
                nombre2 = value.toString();
                break;
            case 5:
                dni = value.toString();
                break;
            case 6:
                tipoDocIdentRtps = value.toString();
                break;
            case 7:
                nroDocIdentRtps = value.toString();
                break;
            case 8:
                fotoBlob = (byte[]) value;
                break;
            case 9:
                flagEstado = value.toString();
                break;
            case 10:
                codOrigen = value.toString();
                break;
            case 11:
                fechaCese = value.toString();
                break;
            case 12:
                fechaNacimiento = value.toString();
                break;
            case 13:
                fechaIngreso = value.toString();
                break;
            case 14:
                cargo = value.toString();
                break;
            case 15:
                area = value.toString();
                break;
        }
    }

    @Override
    public void getPropertyInfo(int __index, Hashtable __table, PropertyInfo __info) {
        switch(__index) {
            case 0:
                __info.name = "codTrabajador";
                __info.type = String.class;
                break;
            case 1:
                __info.name = "apelPaterno";
                __info.type = String.class;
                break;
            case 2:
                __info.name = "apelMaterno";
                __info.type = String.class;
                break;
            case 3:
                __info.name = "nombre1";
                __info.type = String.class;
                break;
            case 4:
                __info.name = "nombre2";
                __info.type = String.class;
                break;
            case 5:
                __info.name = "dni";
                __info.type = String.class;
                break;
            case 6:
                __info.name = "tipoDocIdentRtps";
                __info.type = String.class;
                break;
            case 7:
                __info.name = "nroDocIdentRtps";
                __info.type = String.class;
                break;
            case 8:
                __info.name = "fotoBlob";
                __info.type = byte[].class;
                break;
            case 9:
                __info.name = "flagEstado";
                __info.type = String.class;
                break;
            case 10:
                __info.name = "codOrigen";
                __info.type = String.class;
                break;
            case 11:
                __info.name = "fechaCese";
                __info.type = String.class;
                break;
            case 12:
                __info.name = "fechaNacimiento";
                __info.type = String.class;
                break;
            case 13:
                __info.name = "fechaIngreso";
                __info.type = String.class;
                break;
            case 14:
                __info.name = "cargo";
                __info.type = String.class;
                break;
            case 15:
                __info.name = "area";
                __info.type = String.class;
                break;
        }
    }

    @Override
    public String getInnerText() {
        return null;
    }

    @Override
    public void setInnerText(String s) {
    }

    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        if(soapObject.getProperty("codTrabajador") != null)
            this.codTrabajador = soapObject.getProperty("codTrabajador").toString();
        else
            this.codTrabajador = "";

        if(soapObject.getProperty("apelPaterno") != null) {
            String apelPaternoStr = soapObject.getProperty("apelPaterno").toString();
            this.apelPaterno = (apelPaternoStr != null && !apelPaternoStr.equals("anyType{}")) ? apelPaternoStr : "";
        } else {
            this.apelPaterno = "";
        }

        if(soapObject.getProperty("apelMaterno") != null) {
            String apelMaternoStr = soapObject.getProperty("apelMaterno").toString();
            this.apelMaterno = (apelMaternoStr != null && !apelMaternoStr.equals("anyType{}")) ? apelMaternoStr : "";
        } else {
            this.apelMaterno = "";
        }

        if(soapObject.getProperty("nombre1") != null) {
            String nombre1Str = soapObject.getProperty("nombre1").toString();
            this.nombre1 = (nombre1Str != null && !nombre1Str.equals("anyType{}")) ? nombre1Str : "";
        } else {
            this.nombre1 = "";
        }

        if(soapObject.getProperty("nombre2") != null) {
            String nombre2Str = soapObject.getProperty("nombre2").toString();
            this.nombre2 = (nombre2Str != null && !nombre2Str.equals("anyType{}")) ? nombre2Str : "";
        } else {
            this.nombre2 = "";
        }

        if(soapObject.getProperty("dni") != null)
            this.dni = soapObject.getProperty("dni").toString();
        else
            this.dni = "";

        if(soapObject.getProperty("tipoDocIdentRtps") != null)
            this.tipoDocIdentRtps = soapObject.getProperty("tipoDocIdentRtps").toString();
        else
            this.tipoDocIdentRtps = "";

        if(soapObject.getProperty("nroDocIdentRtps") != null)
            this.nroDocIdentRtps = soapObject.getProperty("nroDocIdentRtps").toString();
        else
            this.nroDocIdentRtps = "";

        // Extraer fotoBlob (viene como Base64 desde el SOAP)
        android.util.Log.i("BeanTrabajador", "=== INICIO extraccion fotoBlob ===");
        android.util.Log.i("BeanTrabajador", "Trabajador: " + this.codTrabajador);
        
        // Log de TODAS las propiedades del SOAP para debug
        android.util.Log.i("BeanTrabajador", "Propiedades del SOAP:");
        for (int i = 0; i < soapObject.getPropertyCount(); i++) {
            org.ksoap2.serialization.PropertyInfo propInfo = new org.ksoap2.serialization.PropertyInfo();
            soapObject.getPropertyInfo(i, propInfo);
            String propName = propInfo.name;
            Object propValue = soapObject.getProperty(i);
            String propType = propValue != null ? propValue.getClass().getName() : "null";
            android.util.Log.i("BeanTrabajador", "  [" + i + "] " + propName + " = " + propType);
        }
        
        if(soapObject.getProperty("fotoBlob") != null) {
            try {
                Object fotoBlobObj = soapObject.getProperty("fotoBlob");
                android.util.Log.i("BeanTrabajador", "fotoBlob property existe. Tipo: " + fotoBlobObj.getClass().getName());
                
                if (fotoBlobObj instanceof byte[]) {
                    // Si ya viene como byte[]
                    this.fotoBlob = (byte[]) fotoBlobObj;
                    android.util.Log.i("BeanTrabajador", "fotoBlob extraído como byte[]. Tamaño: " + this.fotoBlob.length + " bytes");
                } else {
                    // Para cualquier otro tipo (String, SoapPrimitive, etc.), convertir a String y decodificar
                    String base64String = fotoBlobObj.toString();
                    android.util.Log.i("BeanTrabajador", "fotoBlob como String/SoapPrimitive. Longitud Base64: " + base64String.length());
                    
                    // Log de los primeros caracteres para verificar
                    if (base64String.length() > 50) {
                        android.util.Log.i("BeanTrabajador", "Primeros 50 chars: " + base64String.substring(0, 50));
                    }
                    
                    // Decodificar Base64
                    this.fotoBlob = android.util.Base64.decode(base64String, android.util.Base64.DEFAULT);
                    android.util.Log.i("BeanTrabajador", "fotoBlob decodificado exitosamente. Tamaño: " + this.fotoBlob.length + " bytes");
                }
            } catch (Exception e) {
                android.util.Log.e("BeanTrabajador", "Error al extraer fotoBlob: " + e.getMessage());
                e.printStackTrace();
                this.fotoBlob = null;
            }
        } else {
            android.util.Log.w("BeanTrabajador", "fotoBlob property es NULL en el SOAP");
            this.fotoBlob = null;
        }

        if(soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado = "";

        if(soapObject.getProperty("codOrigen") != null)
            this.codOrigen = soapObject.getProperty("codOrigen").toString();
        else
            this.codOrigen = "";

        if(soapObject.getProperty("nomTrabajador") != null)
            this.nomTrabajador = soapObject.getProperty("nomTrabajador").toString();
        else
            this.nomTrabajador = "";

        if(soapObject.getProperty("fechaCese") != null) {
            String fechaCeseStr = soapObject.getProperty("fechaCese").toString();
            this.fechaCese = (fechaCeseStr != null && !fechaCeseStr.equals("anyType{}")) ? fechaCeseStr : "";
        } else {
            this.fechaCese = "";
        }

        if(soapObject.getProperty("fechaNacimiento") != null) {
            String fechaNacimientoStr = soapObject.getProperty("fechaNacimiento").toString();
            this.fechaNacimiento = (fechaNacimientoStr != null && !fechaNacimientoStr.equals("anyType{}")) ? fechaNacimientoStr : "";
        } else {
            this.fechaNacimiento = "";
        }

        if(soapObject.getProperty("fechaIngreso") != null) {
            String fechaIngresoStr = soapObject.getProperty("fechaIngreso").toString();
            this.fechaIngreso = (fechaIngresoStr != null && !fechaIngresoStr.equals("anyType{}")) ? fechaIngresoStr : "";
        } else {
            this.fechaIngreso = "";
        }

        if(soapObject.getProperty("cargo") != null) {
            String cargoStr = soapObject.getProperty("cargo").toString();
            this.cargo = (cargoStr != null && !cargoStr.equals("anyType{}")) ? cargoStr : "";
            android.util.Log.i("BeanTrabajador", "Cargo extraído: " + this.cargo);
        } else {
            android.util.Log.w("BeanTrabajador", "cargo property es NULL");
            this.cargo = "";
        }

        if(soapObject.getProperty("area") != null) {
            String areaStr = soapObject.getProperty("area").toString();
            this.area = (areaStr != null && !areaStr.equals("anyType{}")) ? areaStr : "";
            android.util.Log.i("BeanTrabajador", "Área extraída: " + this.area);
        } else {
            android.util.Log.w("BeanTrabajador", "area property es NULL");
            this.area = "";
        }

        if(soapObject.getProperty("fechaIngreso") != null) {
            String fechaIngresoStr2 = soapObject.getProperty("fechaIngreso").toString();
            android.util.Log.i("BeanTrabajador", "FechaIngreso extraída desde populate: " + fechaIngresoStr2);
        } else {
            android.util.Log.w("BeanTrabajador", "fechaIngreso desde populate es NULL");
        }
    }

    // Getters y Setters
    public String getCodTrabajador() {
        return codTrabajador;
    }

    public void setCodTrabajador(String codTrabajador) {
        this.codTrabajador = codTrabajador;
    }

    public String getApelPaterno() {
        return apelPaterno;
    }

    public void setApelPaterno(String apelPaterno) {
        this.apelPaterno = apelPaterno;
    }

    public String getApelMaterno() {
        return apelMaterno;
    }

    public void setApelMaterno(String apelMaterno) {
        this.apelMaterno = apelMaterno;
    }

    public String getNombre1() {
        return nombre1;
    }

    public void setNombre1(String nombre1) {
        this.nombre1 = nombre1;
    }

    public String getNombre2() {
        return nombre2;
    }

    public void setNombre2(String nombre2) {
        this.nombre2 = nombre2;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getTipoDocIdentRtps() {
        return tipoDocIdentRtps;
    }

    public void setTipoDocIdentRtps(String tipoDocIdentRtps) {
        this.tipoDocIdentRtps = tipoDocIdentRtps;
    }

    public String getNroDocIdentRtps() {
        return nroDocIdentRtps;
    }

    public void setNroDocIdentRtps(String nroDocIdentRtps) {
        this.nroDocIdentRtps = nroDocIdentRtps;
    }

    public byte[] getFotoBlob() {
        return fotoBlob;
    }

    public void setFotoBlob(byte[] fotoBlob) {
        this.fotoBlob = fotoBlob;
    }

    public String getFlagEstado() {
        return flagEstado;
    }

    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }

    public String getCodOrigen() {
        return codOrigen;
    }

    public void setCodOrigen(String codOrigen) {
        this.codOrigen = codOrigen;
    }

    public String getNomTrabajador() {
        return nomTrabajador;
    }

    public void setNomTrabajador(String nomTrabajador) {
        this.nomTrabajador = nomTrabajador;
    }

    // Método para obtener el nombre completo desde la vista
    public String getNombreCompleto() {
        // Si existe nomTrabajador de la vista, usarlo
        if (nomTrabajador != null && !nomTrabajador.isEmpty()) {
            return nomTrabajador.trim();
        }
        
        // Fallback: construir desde campos individuales
        StringBuilder nombreCompleto = new StringBuilder();
        if (apelPaterno != null && !apelPaterno.isEmpty()) {
            nombreCompleto.append(apelPaterno.trim());
        }
        if (apelMaterno != null && !apelMaterno.isEmpty()) {
            if (nombreCompleto.length() > 0) nombreCompleto.append(" ");
            nombreCompleto.append(apelMaterno.trim());
        }
        if (nombre1 != null && !nombre1.isEmpty()) {
            if (nombreCompleto.length() > 0) nombreCompleto.append(" ");
            nombreCompleto.append(nombre1.trim());
        }
        if (nombre2 != null && !nombre2.isEmpty()) {
            if (nombreCompleto.length() > 0) nombreCompleto.append(" ");
            nombreCompleto.append(nombre2.trim());
        }
        return nombreCompleto.toString();
    }

    // Método para obtener solo los apellidos
    public String getApellidos() {
        StringBuilder apellidos = new StringBuilder();
        if (apelPaterno != null && !apelPaterno.isEmpty()) {
            apellidos.append(apelPaterno.trim());
        }
        if (apelMaterno != null && !apelMaterno.isEmpty()) {
            if (apellidos.length() > 0) apellidos.append(" ");
            apellidos.append(apelMaterno.trim());
        }
        return apellidos.toString();
    }
    
    // Método para obtener solo los nombres
    public String getNombres() {
        StringBuilder nombres = new StringBuilder();
        if (nombre1 != null && !nombre1.isEmpty()) {
            nombres.append(nombre1.trim());
        }
        if (nombre2 != null && !nombre2.isEmpty()) {
            if (nombres.length() > 0) nombres.append(" ");
            nombres.append(nombre2.trim());
        }
        return nombres.toString();
    }

    // Método para obtener el documento de identidad
    public String getDocumentoIdentidad() {
        if (nroDocIdentRtps != null && !nroDocIdentRtps.isEmpty()) {
            return nroDocIdentRtps;
        }
        return dni != null ? dni : "";
    }

    // Método para verificar si tiene foto
    public boolean tieneFoto() {
        return (fotoBlob != null && fotoBlob.length > 0);
    }

    public String getFechaCese() {
        return fechaCese;
    }

    public void setFechaCese(String fechaCese) {
        this.fechaCese = fechaCese;
    }

    public String getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(String fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    // Método para verificar si el trabajador está cesado
    public boolean estaCesado() {
        return (fechaCese != null && !fechaCese.isEmpty() && !fechaCese.equals("anyType{}"));
    }

    // Método para verificar si el trabajador está inactivo
    public boolean estaInactivo() {
        return (flagEstado != null && flagEstado.equals("0"));
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getFechaIngreso() {
        return fechaIngreso;
    }

    public void setFechaIngreso(String fechaIngreso) {
        this.fechaIngreso = fechaIngreso;
    }
}

