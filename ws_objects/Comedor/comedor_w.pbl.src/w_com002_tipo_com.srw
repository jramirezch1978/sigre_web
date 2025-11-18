$PBExportHeader$w_com002_tipo_com.srw
forward
global type w_com002_tipo_com from w_abc_master_smpl
end type
end forward

global type w_com002_tipo_com from w_abc_master_smpl
integer width = 2208
integer height = 1076
string title = "Tipo de Comedores (COM002)"
string menuname = "m_mantto_smpl"
end type
global w_com002_tipo_com w_com002_tipo_com

type variables


end variables

forward prototypes
public function boolean of_num_zona_proceso (string as_origen, ref string as_ult_nro)
end prototypes

public function boolean of_num_zona_proceso (string as_origen, ref string as_ult_nro);String	ls_mensaje

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

on w_com002_tipo_com.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_com002_tipo_com.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = TRUE

if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
end if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_com002_tipo_com
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
string dataobject = "d_tipo_comedor_tbl"
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
		
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado	[al_row] = '1'
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

event dw_master::itemchanged;call super::itemchanged;string ls_codigo, ls_data
this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	case "COD_INCIDENCIA"
		
		ls_codigo = this.object.cod_labor[row]

		SetNull(ls_data)
		select desc_labor
			into :ls_data
		from labor
		where cod_labor = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "CODIGO DE LABOR NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_labor	[row] = ls_codigo
			this.object.desc_labor	[row] = ls_codigo
			return 1
		end if

		this.object.desc_labos[row] = ls_data
		
end choose


end event

