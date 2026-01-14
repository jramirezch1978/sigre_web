$PBExportHeader$n_cst_database.sru
forward
global type n_cst_database from nonvisualobject
end type
end forward

global type n_cst_database from nonvisualobject
end type
global n_cst_database n_cst_database

type variables
n_cst_wait invo_wait
end variables

forward prototypes
public function boolean of_valida_database ()
public function boolean of_add_column (string as_tabla, string as_columna, string as_type_data)
public function boolean of_add_column (string as_tabla, string as_columna, string as_type_data, string as_default_value, boolean ab_not_null)
public function boolean of_add_column (string as_tabla, string as_columna, string as_type_data, boolean ab_not_null)
end prototypes

public function boolean of_valida_database ();Long		ll_count
String	ls_cmd, ls_mensaje, ls_columna 

try 
	
	//CNTAS_COBRAR
	invo_wait.of_mensaje("Verificando estructura de TABLA CNTAS_COBRAR")
	if not this.of_add_column('CNTAS_COBRAR', 'SALDO_PAGAR', 'NUMBER(13,2)') then return false
	if not this.of_add_column('CNTAS_COBRAR', 'INTERES', 'NUMBER(13,2)') then return false
	if not this.of_add_column('CNTAS_COBRAR', 'AMORTIZACION', 'NUMBER(13,2)') then return false
	if not this.of_add_column('CNTAS_COBRAR', 'NRO_LETRA', 'char(4)') then return false
	
	//Adiciono las columnas a la tabla articulo
	invo_wait.of_mensaje("Verificando estructura de ARTICULO")
	if not this.of_add_column('ARTICULO', 'MNZ', 'VARCHAR2(10)', '', false) then return false
	if not this.of_add_column('ARTICULO', 'LOTE', 'VARCHAR2(10)', '', false) then return false
	
	//num_doc_tipo
	invo_wait.of_mensaje("Verificando estructura de NUM_DOC_TIPO")
	if not this.of_add_column('NUM_DOC_TIPO', 'FLAG_TIPO_IMPRESION', 'CHAR(1)', '0', true) then return false
	if not this.of_add_column('NUM_DOC_TIPO', 'FLAG_TIPO_EMAIL', 'CHAR(1)', '0', true) then return false
	if not this.of_add_column('NUM_DOC_TIPO', 'COMENTARIOS', 'VARCHAR2(2000)', FALSE) then return false
	
	//GAN_DESCT_FIJO
	invo_wait.of_mensaje("Verificando estructura de GAN_DESCT_FIJO")
	if not this.of_add_column('GAN_DESCT_FIJO', 'IMP_MAX_GAN_DESC', 'NUMBER(15,4)', '0', true) then return false
	
	//CNTAS_COBRAR
	invo_wait.of_mensaje("Verificando estructura de CNTAS_COBRAR")
	if not this.of_add_column('CNTAS_COBRAR', 'UND_PESO', 'CHAR(3)') then return false
	
	//ARTICULO_MOV_PROY
	invo_wait.of_mensaje("Verificando estructura de ARTICULO_MOV_PROY")
	if not this.of_add_column('ARTICULO_MOV_PROY', 'DESCRIPCION', 'VARCHAR2(2000)') then return false
	if not this.of_add_column('ARTICULO_MOV_PROY', 'UND', 'CHAR(3)') then return false
	if not this.of_add_column('ARTICULO_MOV_PROY', 'OBSERVACION', 'VARCHAR2(2000)') then return false
	if not this.of_add_column('ARTICULO_MOV_PROY', 'COD_SERVICIO', 'CHAR(3)') then return false
	if not this.of_add_column('ARTICULO_MOV_PROY', 'CANT_DESPACHO', 'NUMBER(12,4)', '0.00', false) then return false
	if not this.of_add_column('ARTICULO_MOV_PROY', 'FACTOR_CONV', 'NUMBER(18,12)', '0.00', false) then return false
	    
	    
	
	//PLANT_PROD
	invo_wait.of_mensaje("Verificando estructura de PLANT_PROD")
	if not this.of_add_column('PLANT_PROD', 'ESPECIE', 'CHAR(8)') then return false
	
	//MAESTRO
	invo_wait.of_mensaje("Verificando estructura de MAESTRO")
	if not this.of_add_column('MAESTRO', 'COMENTARIO', 'VARCHAR2(2000)') then return false

	
	//PROFORMA
	invo_wait.of_mensaje("Verificando estructura de PROFORMA")
	if not this.of_add_column('PROFORMA', 'ITEM_DIRECCION', 'number(4)') then return false	
	if not this.of_add_column('PROFORMA', 'OBSERVACION', 'VARCHAR2(2000)') then return false	
	if not this.of_add_column('PROFORMA', 'COD_USR', 'CHAR(6)') then return false	
	if not this.of_add_column('PROFORMA', 'COD_MONEDA', 'CHAR(3)') then return false	
	if not this.of_add_column('PROFORMA', 'TASA_CAMBIO', 'NUMBER(7,4)') then return false	
	
	
	//PROFORMA_DET
	invo_wait.of_mensaje("Verificando estructura de PROFORMA_DET")
	if not this.of_add_column('PROFORMA_DET', 'COD_SERVICIO', 'char(8)') then return false	
	if not this.of_add_column('PROFORMA_DET', 'DESC_SERVICIO', 'VARCHAR2(2000)') then return false
	if not this.of_add_column('PROFORMA_DET', 'LARGO', 'NUMBER(15,4)','1', true) then return false
	if not this.of_add_column('PROFORMA_DET', 'ANCHO', 'NUMBER(15,4)', '1', true) then return false
	
	
	//CARGO
	invo_wait.of_mensaje("Verificando estructura de CARGO")
	if not this.of_add_column('CARGO', 'MANUAL_MOF', 'blob') then return false	
	
	
	//ORDEN_TRABAJO
	invo_wait.of_mensaje("Verificando estructura de ORDEN_TRABAJO")
	if not this.of_add_column('ORDEN_TRABAJO', 'NRO_OV', 'char(10)') then return false	
	
	//ORDEN_VENTA
	invo_wait.of_mensaje("Verificando estructura de ORDEN_VENTA")
	if not this.of_add_column('ORDEN_VENTA', 'PAYMENTS', 'VARCHAR2(100)') then return false	
	if not this.of_add_column('ORDEN_VENTA', 'BANCO', 'VARCHAR2(400)') then return false	
	
	//TG_PD_DESTAJO
	invo_wait.of_mensaje("Verificando estructura de TG_PD_DESTAJO")
	if not this.of_add_column('TG_PD_DESTAJO', 'OT_ADM', 'VARCHAR2(10)') then return false	
	
	//TG_CUADRILLAS
	invo_wait.of_mensaje("Verificando estructura de TG_CUADRILLAS")
	if not this.of_add_column('TG_CUADRILLAS', 'OT_ADM', 'VARCHAR2(10)') then return false	
	
	//VALE_MOV
	invo_wait.of_mensaje("Verificando estructura de VALE_MOV")
	if not this.of_add_column('VALE_MOV', 'FEC_PRODUCCION', 'DATE','sysdate', true) then return false
	
	return true

catch ( Exception ex)
	gnvo_app.of_catch_Exception(ex, 'Error al momento de validar la base de datos')
	
finally
	invo_wait.of_close()
end try


end function

public function boolean of_add_column (string as_tabla, string as_columna, string as_type_data);Long		ll_count
String	ls_cmd, ls_mensaje

ll_count = 0

select count(*)
	into :ll_count
from user_tab_cols t
where t.TABLE_NAME 	= upper(:as_tabla)
  and t.COLUMN_NAME 	= upper(:as_columna);

// Verificar que el SELECT fue exitoso
if SQLCA.SQLCode <> 0 then
	MessageBox('Aviso', 'Error al verificar columna ' + as_columna + ' en tabla ' + as_tabla &
							+ '. Error: ' + SQLCA.SQLErrText, StopSign!)
	return false
end if

if ll_count = 0 then
	ls_cmd = "alter table " + upper(as_tabla) + " add " + upper(as_columna) &
			 + " " + upper(as_type_data) 
	
	EXECUTE IMMEDIATE :ls_cmd;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', 'Error al adicionar la columna ' + as_columna + ' en la tabla ' + as_tabla &
								+ '. Mensaje: ' + ls_mensaje &
								+ '~r~nComando: ' + ls_cmd, StopSign!)
		return false
	end if
end if
end function

public function boolean of_add_column (string as_tabla, string as_columna, string as_type_data, string as_default_value, boolean ab_not_null);Long		ll_count
String	ls_cmd, ls_mensaje

ll_count = 0

select count(*)
	into :ll_count
from user_tab_cols t
where t.TABLE_NAME 	= upper(:as_tabla)
  and t.COLUMN_NAME 	= upper(:as_columna);

// Verificar que el SELECT fue exitoso
if SQLCA.SQLCode <> 0 then
	MessageBox('Aviso', 'Error al verificar columna ' + as_columna + ' en tabla ' + as_tabla &
							+ '. Error: ' + SQLCA.SQLErrText, StopSign!)
	return false
end if

if ll_count = 0 then
	ls_cmd = "alter table " + upper(as_tabla) + " add " + upper(as_columna) &
			 + " " + upper(as_type_data) 
	
	if not IsNull(as_default_value) and trim(as_default_value) <> '' then
		ls_cmd = trim(ls_cmd) + " default " + as_default_value 
	end if
	
	if ab_not_null then
		ls_cmd = trim(ls_cmd) + " not null"
	end if
	
	EXECUTE IMMEDIATE :ls_cmd;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', 'Error al adicionar la columna ' + as_columna + ' en la tabla ' + as_tabla &
								+ '. Mensaje: ' + ls_mensaje &
								+ '~r~nComando: ' + ls_cmd, StopSign!)
		return false
	end if
end if
end function

public function boolean of_add_column (string as_tabla, string as_columna, string as_type_data, boolean ab_not_null);return this.of_add_column(as_tabla, as_columna, as_type_data, '', ab_not_null)
end function

on n_cst_database.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_database.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_wait = create n_cst_wait
end event

event destructor;destroy n_cst_wait
end event

