$PBExportHeader$w_cm310_cotizacion_servic_act.srw
forward
global type w_cm310_cotizacion_servic_act from w_abc_mid
end type
type dw_1 from u_dw_abc within w_cm310_cotizacion_servic_act
end type
end forward

global type w_cm310_cotizacion_servic_act from w_abc_mid
integer width = 3214
integer height = 1704
string title = "Actualizacion de cotizaciones [cm310]"
string menuname = "m_mtto_imp_mail"
windowstate windowstate = maximized!
dw_1 dw_1
end type
global w_cm310_cotizacion_servic_act w_cm310_cotizacion_servic_act

forward prototypes
public subroutine of_retrieve ()
end prototypes

public subroutine of_retrieve ();Long ll_row
String ls_origen, ls_nro

Select cod_origen, nro_cotiza into :ls_origen, :ls_nro
   From cotizacion where nro_cotiza = (select max( to_number( nro_cotiza)) from cotizacion)
	 AND tipo = 'S';

ll_row = dw_master.retrieve(ls_origen, ls_nro)
if ll_row > 0 then
	dw_master.il_row = dw_master.getrow()
	dw_master.setrow( ll_row )
	idw_1 = dw_master
	
	// Muestra datos segun primera cotizacion
	dw_1.retrieve( ls_origen, ls_nro)	
end if
return
end subroutine

on w_cm310_cotizacion_servic_act.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_imp_mail" then this.MenuID = create m_mtto_imp_mail
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_cm310_cotizacion_servic_act.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)
dw_detmast.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

idw_1 = dw_master              			// asignar dw corriente
dw_detail.BorderStyle = StyleRaised! 	// indicar dw_detail como no activado
dw_master.of_protect()         			// bloquear modificaciones 
dw_detmast.of_protect()
dw_detail.of_protect()

//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

of_retrieve()

end event

event ue_list_open();// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_dddw_cotizaciones_tbl"
sl_param.titulo = "Cotizaciones de Servicios"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.tipo = '1S'
sl_param.string1 = 'S'

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	dw_master.retrieve(sl_param.field_ret[1], sl_param.field_ret[2])	
	dw_master.event ue_refresh_det()	
END IF
end event

type dw_master from w_abc_mid`dw_master within w_cm310_cotizacion_servic_act
event ue_refresh_det ( )
integer x = 9
integer y = 44
integer width = 2738
integer height = 368
string dataobject = "d_abc_cotizacion_servic_207_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_master::ue_refresh_det();/*
   Evento creado para reemplazar al evento output sin argumento,
	esto para ser usado en la ventana w_pop             */

Long ll_row
ll_row = dw_master.getrow()

THIS.EVENT ue_retrieve_det(ll_row)
idw_det.ScrollToRow(ll_row)

//of_set_status_doc( dw_master )
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;//idw_det.retrieve(aa_id[1],aa_id[2])
dw_1.retrieve( aa_id[1],aa_id[2])
end event

type dw_detail from w_abc_mid`dw_detail within w_cm310_cotizacion_servic_act
integer x = 297
integer y = 964
integer width = 2318
integer height = 700
string dataobject = "d_abc_cotizacion_servic_act_tbl"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2

is_dwform = 'form' 
end event

type dw_detmast from w_abc_mid`dw_detmast within w_cm310_cotizacion_servic_act
integer x = 1440
integer y = 476
integer width = 2153
integer height = 436
string dataobject = "d_abc_cotizacion_update_204_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_detmast::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
is_dwform = 'form'
end event

event dw_detmast::doubleclicked;call super::doubleclicked;String ls_name, ls_prot
Datawindow ldw

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_name = 'fec_vigencia' and ls_prot = '0' then
	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	ii_update = 1
//	this.AcceptText()
//   of_get_fecha2(DATE( this.object.fec_requerida[this.getrow()]))
end if
end event

type dw_1 from u_dw_abc within w_cm310_cotizacion_servic_act
integer x = 9
integer y = 484
integer width = 1445
integer height = 436
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sel_cotizacion_proveedor_205"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1		

is_dwform = 'tabular'
end event

event clicked;call super::clicked;Long ll_row
String ls_origen, ls_proveedor, ls_nro_cotiza

ll_row = this.getrow()
if ll_row > 0 then
	ls_nro_cotiza = this.object.nro_cotiza[ll_row]
	ls_origen = this.object.cod_origen[ll_row]
	ls_proveedor = this.object.proveedor[ll_row]

	dw_detmast.retrieve( ls_origen, ls_nro_cotiza, ls_proveedor)  // Muestra proveedor
	dw_detail.retrieve( ls_origen, ls_nro_cotiza, ls_proveedor)  // muestra detalle proveedor
end if
end event

