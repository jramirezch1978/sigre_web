$PBExportHeader$w_rh022_parametros_fechas.srw
forward
global type w_rh022_parametros_fechas from w_abc_master_smpl
end type
end forward

global type w_rh022_parametros_fechas from w_abc_master_smpl
integer width = 3534
integer height = 1136
string title = "(RH022) Parámetros de Fechas de Procesos"
string menuname = "m_master_simple"
end type
global w_rh022_parametros_fechas w_rh022_parametros_fechas

type variables

end variables

on w_rh022_parametros_fechas.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh022_parametros_fechas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("origen.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('origen')
END IF
end event

event ue_update_pre;call super::ue_update_pre;string  ls_origen
integer li_row, li_verifica

li_row = dw_master.GetRow()

if li_row > 0 then 
	ls_origen = trim(dw_master.GetItemString(li_row,"origen"))
	if len(ls_origen) = 0 or isnull(ls_origen) then
		dw_master.ii_update = 0
		MessageBox("Sistema de Validación","Ingrese código de origen")
		dw_master.SetColumn("origen")
		dw_master.SetFocus()
	else
		select count(*)
		  into :li_verifica
		  from origen
		  where cod_origen = :ls_origen ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			MessageBox("Sistema de Validación","Código de origen no existe")
			dw_master.SetColumn("origen")
			dw_master.SetFocus()
		end if	  
	end if	
end if	

dw_master.of_set_flag_replicacion( )
end event

event ue_open_pre;call super::ue_open_pre;try 
	if gs_empresa = 'CANTABRIA' or gnvo_app.of_get_parametro("RRHH_PROCESSING_TIPO_PLANILLA", "0") = "1" then
		
		dw_master.DataObject = 'd_parametros_fechas_cantabria_tbl'
		
	elseif gnvo_app.of_get_parametro( "GIRO NEGOCIO PESCA/SEMANAL", "1")  = '1' then
		
		dw_master.DataObject = 'd_parametros_fechas_pesca_tbl'
		
	else
		
		dw_master.DataObject = 'd_parametros_fechas_tbl'
		
	end if
	
	dw_master.SetTransobject( SQLCA )
	
catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	
end try

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh022_parametros_fechas
event ue_display ( string as_columna,  long al_row )
integer width = 3451
integer height = 908
string dataobject = "d_parametros_fechas_tbl"
boolean hscrollbar = false
boolean livescroll = false
end type

event dw_master::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_parametros sl_param

choose case lower(as_columna)
		
	case "origen"
		
		ls_sql = "SELECT cod_origen as codigo_origen, " &
				  + "nombre AS nombre_origen " &
				  + "FROM origen " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
				this.object.origen	[al_row] = ls_codigo
				this.object.nombre	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "tipo_trabajador"
		
		ls_sql = "select tt.tipo_trabajador as tipo_trabajador, " &
				 + "tt.desc_tipo_tra as descripcion_tipo_trabajador " &
				 + "from tipo_trabajador tt, " &
				 + "     tipo_trabajador_user ttu " &
				 + "where tt.tipo_trabajador = ttu.tipo_trabajador " &
				 + "  and ttu.cod_usr        = '" + gs_user + "'" &
				 + "  and tt.flag_estado 	  = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_trabajador	[al_row] = ls_codigo
			this.ii_update = 1
		end if		

	case "proveedor"
		
		ls_sql = "SELECT proveedor as cod_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor " &
				  + "FROM proveedor " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
				this.object.cod_relacion	[al_row] = ls_codigo
			this.ii_update = 1
		end if		
		
end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::itemchanged;call super::itemchanged;string ls_origen, ls_descripcion

accepttext()
choose case dwo.name 
	case 'origen'
		ls_origen = dw_master.object.origen[row]	
		select nombre
		  into :ls_descripcion
		  from origen
		  where cod_origen = :ls_origen ;
		dw_master.object.nombre[row] = ls_descripcion
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_desc

dw_master.Modify("origen.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("fec_proceso.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("fec_inicio.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("fec_final.Protect='1~tIf(IsRowNew(),0,1)'")

select nombre
	into :ls_desc
from origen
where cod_origen = :gs_origen;

this.object.origen						[al_row] = gs_origen
this.object.nombre						[al_row] = ls_desc
this.object.flag_calc_vacaciones 	[al_row] = '0'
this.object.flag_calc_CTS 				[al_row] = '0'
this.object.flag_calc_gratificacion	[al_row] = '0'
this.object.cod_relacion				[al_row] = gnvo_app.empresa.is_empresa
this.object.flag_bonificacion_pesca	[al_row] = '0'
this.object.nro_semana					[al_row] = 0
end event

event dw_master::doubleclicked;call super::doubleclicked;
string ls_columna
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

