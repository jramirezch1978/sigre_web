$PBExportHeader$w_pt307_proyecto_pd.srw
forward
global type w_pt307_proyecto_pd from w_abc_master
end type
end forward

global type w_pt307_proyecto_pd from w_abc_master
integer width = 2752
integer height = 1368
string title = "Parte Diario de proyectos"
string menuname = "m_mantenimiento_cl"
event ue_cancelar ( )
end type
global w_pt307_proyecto_pd w_pt307_proyecto_pd

type variables

end variables

forward prototypes
public subroutine of_retrieve (long an_ano, string as_cod_Art)
end prototypes

event ue_cancelar();// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()

dw_master.ii_update = 0



end event

public subroutine of_retrieve (long an_ano, string as_cod_Art);Long ll_row

ll_row = dw_master.retrieve(an_ano, as_cod_art)

return 
end subroutine

on w_pt307_proyecto_pd.create
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
end on

on w_pt307_proyecto_pd.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;f_centrar(this)
ii_pregunta_delete = 1

end event

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.ano.Protect)

IF li_protect = 0 THEN
   dw_master.Object.ano.Protect = 1
	dw_master.Object.cod_art.Protect = 1
	dw_master.Object.cod_plantilla.Protect = 1
END IF
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then
	return
end if
ib_update_check = True

dw_master.of_set_flag_replicacion()

end event

event ue_list_open();// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_sel_proyectos"
sl_param.titulo = "Proyectos"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2


OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(LONG( sl_param.field_ret[1]), sl_param.field_ret[2])
END IF
end event

type dw_master from w_abc_master`dw_master within w_pt307_proyecto_pd
integer x = 14
integer y = 12
integer width = 2670
integer height = 1136
string dataobject = "d_abc_proyecto_pd"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
end event

event dw_master::itemchanged;call super::itemchanged;Long ll_count, ll_proy, ll_oper,  ll_null

SetNull( ll_null)
// Verifica si existe
this.AcceptText()
IF dwo.name = "nro_sec_proy" then
	ll_proy = LONG( data)
	Select count( nro_sec_proy) into :ll_count 
	   from proyecto where nro_sec_proy = :ll_proy;	
	if ll_count = 0 then
		Messagebox( "Error", "Numero de proyecto no existe", Exclamation!)		
		this.object.nro_sec_proy[row] = ll_null
		Return 1
	end if	
end if

IF dwo.name = "nro_operacion" then
	ll_proy = this.object.nro_sec_proy[row]
	ll_oper = LONG( data)
	Select count( nro_sec_proy) into :ll_count 
	   from proyecto_det_operacion where nro_sec_proy = :ll_proy and
		  nro_operacion = :ll_oper;	
	if ll_count = 0 then
		Messagebox( "Error", "Numero de operacion no existe", Exclamation!)		
		this.object.nro_operacion[row] = ll_null
		Return 1
	end if	
end if
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;is_action = 'new'
end event

event dw_master::doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
str_parametros sl_param

if dwo.name = 'nro_sec_proy' and this.Describe( "nro_sec_proy.Protect") <> '1' then
	// Asigna valores a structura 		
	sl_param.dw1 = "d_sel_proyectos"   
	sl_param.titulo = "Proyectos"
	sl_param.field_ret_i[1] = 1		
	sl_param.retrieve = 'S'

	OpenWithParm( w_lista, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then		
		this.object.nro_sec_proy[this.getrow()] = LONG(sl_param.field_ret[1])
		ii_update = 1
	END IF		
end if
if dwo.name = 'nro_operacion' and this.Describe( "nro_operacion.Protect") <> '1' then
	// Asigna valores a structura 		
	sl_param.dw1 = "d_sel_proyecto_operacion"   
	sl_param.titulo = "Operaciones"
	sl_param.tipo = '1L'
	sl_param.long1 = LONG(this.object.nro_sec_proy[ this.getrow()])
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2
	sl_param.retrieve = 'S'

	OpenWithParm( w_lista, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then		
		this.object.nro_operacion[this.getrow()] = LONG(sl_param.field_ret[1])
		this.object.desc_operacion[this.getrow()] = sl_param.field_ret[2]
		ii_update = 1
	END IF		
end if
end event

