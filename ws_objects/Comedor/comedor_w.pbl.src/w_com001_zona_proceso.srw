$PBExportHeader$w_com001_zona_proceso.srw
forward
global type w_com001_zona_proceso from w_abc_master_smpl
end type
end forward

global type w_com001_zona_proceso from w_abc_master_smpl
integer width = 2208
integer height = 1076
string title = "Zonas de Proceso (Com001)"
string menuname = "m_mantto_smpl"
end type
global w_com001_zona_proceso w_com001_zona_proceso

type variables
long	il_num_zona
end variables

forward prototypes
public function boolean of_curr_num_zona (ref long al_ult_nro)
public function boolean of_num_zona_proceso (ref string as_ult_nro)
public function string of_get_num_zona ()
end prototypes

public function boolean of_curr_num_zona (ref long al_ult_nro);String	ls_mensaje

//create or replace function USF_COM_CURR_NUM_ZONA(
//       asi_cod_origen origen.cod_origen%type
//) return number is

DECLARE USF_COM_CURR_NUM_ZONA PROCEDURE FOR
	USF_COM_CURR_NUM_ZONA( :gs_origen );

EXECUTE USF_COM_CURR_NUM_ZONA;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION USF_COM_CURR_NUM_ZONA: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetNull(al_ult_nro)
	return FALSE
END IF

FETCH USF_COM_CURR_NUM_ZONA INTO :al_ult_nro;
CLOSE USF_COM_CURR_NUM_ZONA;

return TRUE
end function

public function boolean of_num_zona_proceso (ref string as_ult_nro);String	ls_mensaje

//create or replace function USF_COM_NUM_ZONA_PROCESO
//(asi_cod_origen origen.cod_origen%type)
// return varchar2 is

DECLARE USF_COM_NUM_ZONA_PROCESO PROCEDURE FOR
	USF_COM_NUM_ZONA_PROCESO( :gs_origen );

EXECUTE USF_COM_NUM_ZONA_PROCESO;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION USF_COM_NUM_ZONA_PROCESO: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetNull(as_ult_nro)
	return FALSE
END IF

FETCH USF_COM_NUM_ZONA_PROCESO INTO :as_ult_nro;
CLOSE USF_COM_NUM_ZONA_PROCESO;

return TRUE


end function

public function string of_get_num_zona ();long 		ll_row, ll_ult_nro, ll_temp
string	ls_temp, ls_ult_nro

ll_ult_nro =0
for ll_row = 1 to idw_1.RowCount()
	ls_temp = idw_1.object.zona_proceso[ll_row]
	if left(ls_temp,2) = gs_origen then
		ll_temp = Long( mid( ls_temp, 3 ) )
		if ll_temp > ll_ult_nro then
			ll_ult_nro = ll_temp
		end if
	end if
next

ll_ult_nro ++

ls_ult_nro = gs_origen + string(ll_ult_nro, '00000000')
return ls_ult_nro
end function

on w_com001_zona_proceso.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_com001_zona_proceso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;Long 		ll_row
String 	ls_cod_zona
Boolean	lb_ret
dwItemStatus ldis_status

ib_update_check = TRUE

if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
end if

//Colocar Numeradores
FOR ll_row = 1 TO dw_master.Rowcount()
	//asignar nro de parte cuando registro sea nuevo
	ldis_status = dw_master.GetItemStatus(ll_row, 0, Primary!)
   IF ldis_status = NewModified! THEN
		ls_cod_zona = dw_master.Object.zona_proceso[ll_row]
		
		if ls_cod_zona ='' or IsNull(ls_cod_zona) then
			lb_ret = this.of_num_zona_proceso( ls_cod_zona )
			if lb_ret = TRUE then
		      dw_master.Object.zona_proceso [ll_row] = ls_cod_zona
			else
				ib_update_check = False	
				return
			end if
		end if
   END IF
NEXT

select seq_com_zona_proceso.currval
	into :il_num_zona
from dual;

if il_num_zona = 0 or IsNull(il_num_zona) then il_num_zona = 0

il_num_zona ++

dw_master.of_set_flag_replicacion()





end event

event ue_open_pre;call super::ue_open_pre;select seq_com_zona_proceso.currval
	into :il_num_zona
from dual;

//if sqlca.SQlCode <> 0 then
//	MessageBox('Error', SQLCA.SQLErrText, StopSign!)
//end if

//this.of_curr_num_zona( il_num_zona )

if il_num_zona = 0 or IsNull(il_num_zona) then il_num_zona = 1



end event

event ue_query_retrieve;//Ancestor Script Override
idw_1.AcceptText()
idw_1.Object.datawindow.querymode = 'no'
idw_1.Retrieve()

idw_1.ii_protect = 1
idw_1.of_protect()
end event

event ue_modify;call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.zona_proceso.Protect)

IF li_protect = 0 THEN
   dw_master.Object.zona_proceso.Protect = 1
END IF
end event

type dw_master from w_abc_master_smpl`dw_master within w_com001_zona_proceso
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
string dataobject = "d_zona_proceso_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

choose case lower(as_columna)
		
	case "cod_labor"
		
		ls_sql = "SELECT COD_LABOR AS CODIGO_LABOR ," &
				 + "DESC_LABOR AS NOMBRES, " &
				 + "FLAG_MAQ_MO AS FLAG_MAQUINARIA_MO " &
				 + "FROM LABOR " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_labor	[al_row] = ls_codigo
			this.object.desc_labor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cencos"

		ls_sql = "SELECT CENCOS AS CODIGO_CENCOS ," &
				 + "DESC_CENCOS AS DESCRIPCION_CENCOS " &
				 + "FROM CENTROS_COSTO " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		
			case "origen"

		ls_sql = "SELECT cod_origen AS CODIGO ," &
				 + "nombre AS DESCRIPCION_ORIGEN " &
				 + "FROM ORIGEN " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.origen		[al_row] = ls_codigo
			this.object.nombre	   [al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string	ls_num_zona, ls_nombre_o

ls_num_zona = of_get_num_zona( )

select nombre
  into :ls_nombre_o
  from origen
 where cod_origen = :gs_origen;

this.object.zona_proceso[al_row] = ls_num_zona
this.object.origen		[al_row] = gs_origen
this.object.nombre		[al_row] = ls_nombre_o
this.object.nivel			[al_row] = 'D'
this.object.flag_estado	[al_row] = '1'
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_cencos, ls_null, &
			ls_desc_cencos

this.AcceptText()

if row <= 0 then
	return
end if

SetNull(ls_null)

choose case lower(dwo.name)
		
		case "origen"
		
		ls_codigo = this.object.origen[row]

		SetNull(ls_data)
		select nombre
		  into :ls_data
		  from origen
		 where cod_origen  = :ls_codigo
		   and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "CODIGO DE ORIGEN NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.origen		[row] = ls_null
			this.object.nombre	   [row] = ls_null
			return 1
		end if

		this.object.nombre[row] = ls_data
		
		
	case "labor"
		
		ls_codigo = this.object.cod_labor[row]

		SetNull(ls_data)
		select desc_labor
			into :ls_data
		from labor
		where cod_labor = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "CODIGO DE LABOR NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cod_labor	[row] = ls_null
			this.object.desc_labor	[row] = ls_null
			return 1
		end if

		this.object.desc_labor[row] = ls_data
		
	case "cencos"
		
		ls_cencos = this.object.cencos[row]
		
		SetNull(ls_desc_cencos)
		select desc_cencos
			into :ls_desc_cencos
		from centros_costo
		where cencos = :ls_cencos
		  and flag_estado = '1';
		  
		if ls_desc_cencos = '' or IsNull(ls_desc_cencos) then
			Messagebox('Aviso', "CODIGO DE CENTRO DE COSTO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cencos	[row] = ls_null
			this.object.desc_cencos	[row] = ls_null
			return 1
		end if
		
		this.object.desc_cencos[row] = ls_desc_cencos
end choose


end event

