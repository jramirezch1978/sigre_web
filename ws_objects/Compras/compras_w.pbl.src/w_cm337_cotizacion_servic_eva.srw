$PBExportHeader$w_cm337_cotizacion_servic_eva.srw
forward
global type w_cm337_cotizacion_servic_eva from w_abc
end type
type dw_master from u_dw_abc within w_cm337_cotizacion_servic_eva
end type
type dw_evalua_art from u_dw_abc within w_cm337_cotizacion_servic_eva
end type
type dw_evalua_prov from u_dw_abc within w_cm337_cotizacion_servic_eva
end type
end forward

global type w_cm337_cotizacion_servic_eva from w_abc
integer width = 3493
integer height = 1816
string title = "Evaluacion de cotizaciones [CM310]"
string menuname = "m_mtto_imp_mail"
dw_master dw_master
dw_evalua_art dw_evalua_art
dw_evalua_prov dw_evalua_prov
end type
global w_cm337_cotizacion_servic_eva w_cm337_cotizacion_servic_eva

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
//	dw_1.retrieve( ls_origen, ls_nro)	
end if
return
end subroutine

on w_cm337_cotizacion_servic_eva.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_imp_mail" then this.MenuID = create m_mtto_imp_mail
this.dw_master=create dw_master
this.dw_evalua_art=create dw_evalua_art
this.dw_evalua_prov=create dw_evalua_prov
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.dw_evalua_art
this.Control[iCurrent+3]=this.dw_evalua_prov
end on

on w_cm337_cotizacion_servic_eva.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
destroy(this.dw_evalua_art)
destroy(this.dw_evalua_prov)
end on

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
dw_evalua_art.SetTransObject(sqlca)
dw_evalua_prov.SetTransObject(sqlca)

idw_1 = dw_master              		// asignar dw corriente
dw_master.of_protect()         		// bloquear modificaciones 
//dw_1.BorderStyle = StyleRaised!
//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

of_retrieve()


end event

event ue_update();call super::ue_update;Boolean lbo_ok = TRUE

dw_evalua_prov.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_evalua_prov.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_evalua_prov.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF
IF lbo_ok THEN
	COMMIT using SQLCA;	
	dw_evalua_prov.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF
end event

event ue_list_open();call super::ue_list_open;// Abre ventana pop
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
//	dw_master.event ue_refresh_det()	
END IF
end event

type dw_master from u_dw_abc within w_cm337_cotizacion_servic_eva
integer x = 23
integer width = 3351
integer height = 372
string dataobject = "d_abc_cotizacion_servic_207_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;idw_1 = THIS

end event

event constructor;call super::constructor;is_mastdet = 'md'		
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_mst  = dw_master
idw_det  = dw_evalua_art
end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2])
dw_evalua_prov.retrieve(aa_id[1],aa_id[2])
end event

event rowfocuschanged;call super::rowfocuschanged;IF currentrow = 0 THEN RETURN
THIS.SetRow(currentrow)
THIS.Event ue_output(currentrow)
end event

type dw_evalua_art from u_dw_abc within w_cm337_cotizacion_servic_eva
integer y = 364
integer width = 2752
integer height = 604
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_cotizacion_servic_eva_209_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'form'	
ii_dk[1] = 1 	
ii_dk[2] = 2
ii_dk[3] = 3

idw_det  = dw_evalua_prov
end event

type dw_evalua_prov from u_dw_abc within w_cm337_cotizacion_servic_eva
integer x = 14
integer y = 1004
integer width = 3355
integer height = 568
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_cotizacion_servic_eva_209_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'	
ii_rk[1] = 1 
ii_rk[2] = 2 
ii_rk[3] = 3 
end event

event itemchanged;call super::itemchanged;// solo acepta aquellos que han sido cotizados
if dwo.name = "flag_ganador" then
	if this.object.cotizo[row] = "0" then		
		Messagebox( "Atencion", "Este proveedor no ha cotizado", Exclamation!)
		return 1		
	end if
end if
end event

event itemerror;call super::itemerror;Return 1		// Fuerza a no mostrar mensaje de error
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)		// Para hacer scroll con teclado
end event

