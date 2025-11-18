$PBExportHeader$w_pt308_produccion_real.srw
forward
global type w_pt308_produccion_real from w_abc_master
end type
end forward

global type w_pt308_produccion_real from w_abc_master
integer width = 2377
integer height = 1140
string title = "Produccion Real"
string menuname = "m_mantenimiento_cl"
event ue_cancelar ( )
end type
global w_pt308_produccion_real w_pt308_produccion_real

type variables
end variables

forward prototypes
public subroutine of_retrieve (string as_codart, date ad_fecha)
end prototypes

event ue_cancelar();// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()

dw_master.ii_update = 0


end event

public subroutine of_retrieve (string as_codart, date ad_fecha);Long ll_row


ll_row = dw_master.retrieve(as_codart, ad_fecha)

return 
end subroutine

on w_pt308_produccion_real.create
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
end on

on w_pt308_produccion_real.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;f_centrar(this)


end event

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.cod_art.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_art.Protect = 1
	dw_master.Object.fecha.Protect = 1
END IF

is_action = 'edit'
end event

event ue_update_pre();call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then
	return
end if
ib_update_check = True
end event

event ue_list_open();// Abre ventana pop
str_parametros sl_param
Date ld_fecha

sl_param.dw1 = "d_sel_produccion_real"
sl_param.titulo = "Produccion Real"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 3

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then	
	ld_fecha = DATE(TRIM(sl_param.field_ret[2]))	
	of_retrieve(sl_param.field_ret[1], ld_fecha)
END IF
end event

event ue_insert();// Override
Long  ll_row

idw_1.reset()
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

type dw_master from w_abc_master`dw_master within w_pt308_produccion_real
integer y = 12
integer width = 2304
integer height = 904
string dataobject = "d_abc_produccion_real"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
end event

event dw_master::itemchanged;call super::itemchanged;Long ll_count
String ls_desc,ls_und
date ld_fecha

// Verifica si existe
this.AcceptText()
IF dwo.name = "cod_art" then		
	Select count( cod_art) into :ll_count from presup_plant where cod_art = :data
	  and forma_embarque is null and flag_mercado is null;	
	if ll_count = 0 then
		Messagebox( "Error", "Articulo no tiene plantilla", Exclamation!)		
		this.object.cod_Art[row] = ""
		Return 1
	end if
	Select desc_art, und into :ls_desc, :ls_und
	   from articulo where cod_art = :data;		
	this.object.nom_articulo[row] = ls_desc
end if	
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::buttonclicked;call super::buttonclicked;// Abre ventana de ayuda 
str_parametros sl_param


// Asigna valores a structura 	
if dwo.name = 'b_cod_art' and this.Describe( "cod_art.Protect") <> '1' then
		sl_param.dw1 = "d_dddw_articulos_x_plantilla"   
		sl_param.titulo = "Articulos"
		sl_param.field_ret_i[1] = 1
		sl_param.field_ret_i[2] = 2

		OpenWithParm( w_lista, sl_param)		
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then		
			this.object.cod_art[this.getrow()] = sl_param.field_ret[1]			
			this.object.nom_articulo[this.getrow()] = sl_param.field_ret[2]
			ii_update = 1
		END IF		
	end if
end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;this.object.fecha[al_row] = today()
end event

