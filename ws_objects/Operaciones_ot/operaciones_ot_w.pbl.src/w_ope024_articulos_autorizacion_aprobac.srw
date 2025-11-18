$PBExportHeader$w_ope024_articulos_autorizacion_aprobac.srw
forward
global type w_ope024_articulos_autorizacion_aprobac from w_abc
end type
type cb_3 from commandbutton within w_ope024_articulos_autorizacion_aprobac
end type
type st_1 from statictext within w_ope024_articulos_autorizacion_aprobac
end type
type sle_articulo from singlelineedit within w_ope024_articulos_autorizacion_aprobac
end type
type dw_master from u_dw_abc within w_ope024_articulos_autorizacion_aprobac
end type
type gb_1 from groupbox within w_ope024_articulos_autorizacion_aprobac
end type
end forward

global type w_ope024_articulos_autorizacion_aprobac from w_abc
integer width = 3602
integer height = 1548
string title = "Nivel de autorizacion de articulos (OPE024)"
string menuname = "m_master_lista_anular"
event ue_anular ( )
cb_3 cb_3
st_1 st_1
sle_articulo sle_articulo
dw_master dw_master
gb_1 gb_1
end type
global w_ope024_articulos_autorizacion_aprobac w_ope024_articulos_autorizacion_aprobac

type variables
String is_accion


end variables

forward prototypes
public subroutine wf_retrieve_dw (string as_nro_solicitud_ot)
end prototypes

public subroutine wf_retrieve_dw (string as_nro_solicitud_ot);dw_master.Retrieve(as_nro_solicitud_ot)	

end subroutine

on w_ope024_articulos_autorizacion_aprobac.create
int iCurrent
call super::create
if this.MenuName = "m_master_lista_anular" then this.MenuID = create m_master_lista_anular
this.cb_3=create cb_3
this.st_1=create st_1
this.sle_articulo=create sle_articulo
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_articulo
this.Control[iCurrent+4]=this.dw_master
this.Control[iCurrent+5]=this.gb_1
end on

on w_ope024_articulos_autorizacion_aprobac.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.sle_articulo)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)
dw_master.SetTransObject(SQLCA)

idw_1 = dw_master              // asignar dw corriente
dw_master.of_protect()


//Help
ii_help = 301

end event

event ue_insert;call super::ue_insert;//Long  ll_row
//
//TriggerEvent('ue_update_request')
//
//IF ib_update_check = FALSE THEN RETURN
//
//dw_master.Reset()
//
//ll_row = idw_1.Event ue_insert()
//
//IF ll_row <> -1 THEN 
//	This.Event ue_insert_pos(ll_row)
//END IF	
//
end event

event ue_retrieve_list;call super::ue_retrieve_list;str_seleccionar lstr_seleccionar
String ls_flag_estado, ls_cod_art

ls_flag_estado='1'

// Mostrar ayuda
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ARTICULO.COD_ART AS CODIGO ,'&
								 +'ARTICULO.DESC_ART AS DESCRIPCION '&
								 +'FROM ARTICULO ' &
								 +'WHERE ARTICULO.FLAG_ESTADO = '+"'"+ls_flag_estado+"'"
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_cod_art = TRIM(lstr_seleccionar.param1[1])
	dw_master.retrieve(ls_cod_art)
END IF														 


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
	END IF
END IF

end event

event ue_delete;//Messagebox('Aviso','No se puede eliminar Registro Verifique!')
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
END IF

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type cb_3 from commandbutton within w_ope024_articulos_autorizacion_aprobac
integer x = 814
integer y = 64
integer width = 402
integer height = 84
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubicar"
end type

event clicked;String ls_cod_art, ls_flag_estado
str_seleccionar lstr_seleccionar
Long ll_count

ls_cod_art = Trim(sle_articulo.text)
ls_flag_estado='1'
IF Isnull(ls_cod_art) OR Trim(ls_cod_art) = '' THEN
	// Mostrar ayuda
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT ARTICULO.COD_ART AS CODIGO ,'&
									 +'ARTICULO.DESC_ART AS DESCRIPCION '&
									 +'FROM ARTICULO ' &
									 +'WHERE ARTICULO.FLAG_ESTADO = '+"'"+ls_flag_estado+"'"
	OpenWithParm(w_seleccionar,lstr_seleccionar)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_articulo.text = TRIM(lstr_seleccionar.param1[1])
		ls_cod_art = TRIM(lstr_seleccionar.param1[1])
	END IF														 
ELSE
	SELECT count(*) 
	  INTO :ll_count 
	  FROM articulo a 
	 WHERE cod_art = :ls_cod_art ;

	IF ll_count=0 THEN RETURN 

END IF
dw_master.retrieve(ls_cod_art)

end event

event getfocus;//String ls_solicitud
//Long ll_count
//
//ls_solicitud = TRIM(sle_solicitud.text)
//
//IF isnull(ls_solicitud) THEN
//	messagebox('Aviso','Digite solicitud de orden de trabajo a buscar')
//ELSE
//	
//	SELECT count(*) INTO :ll_count FROM SOLICITUD_OT 
//	WHERE NRO_SOLICITUD = :ls_solicitud ;
//	
//	IF ll_count > 0 THEN
//		dw_master.Retrieve(ls_solicitud)
//	ELSE
//		MessageBox('Aviso', 'Solicitud de Orden de trabajo no existe')
//	END IF
//END IF
//
//return 1
end event

type st_1 from statictext within w_ope024_articulos_autorizacion_aprobac
integer x = 87
integer y = 80
integer width = 270
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Artículo : "
boolean focusrectangle = false
end type

type sle_articulo from singlelineedit within w_ope024_articulos_autorizacion_aprobac
event ue_tecla pbm_keydown
integer x = 370
integer y = 64
integer width = 421
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;IF Key = KeyEnter! THEN
	cb_3.triggerevent(clicked!)
END IF
end event

type dw_master from u_dw_abc within w_ope024_articulos_autorizacion_aprobac
integer x = 27
integer y = 216
integer width = 3520
integer height = 1128
string dataobject = "d_abc_articulo_generales_ff"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master				// dw_master



end event

event itemchanged;call super::itemchanged;this.AcceptText( )
ii_update = 1

if dwo.name = 'flag_reposicion' then
	if data = '0' then
//		this.Object.sldo_minimo.Protect = 1
		this.Object.sldo_maximo.Protect = 1
//		this.Object.cnt_compra_rec.Protect = 1
//		this.Object.dias_reposicion.Protect = 1
//		this.Object.dias_rep_import.Protect = 1
		this.object.sldo_minimo.edit.required = 'Yes'
		this.object.sldo_maximo.edit.required = 'Yes'
		this.object.cnt_compra_rec.edit.required = 'Yes'
		this.object.nivel_aprob[row]=1		
		this.ii_update = 1
	else
//		this.Object.sldo_minimo.Protect = 0
		this.Object.sldo_maximo.Protect = 0
//		this.Object.cnt_compra_rec.Protect = 0
//		this.Object.dias_reposicion.Protect = 0
//		this.Object.dias_rep_import.Protect = 0
		this.object.sldo_minimo.edit.required = 'No'
		this.object.sldo_maximo.edit.required = 'No'
		this.object.cnt_compra_rec.edit.required = 'No'
		this.object.nivel_aprob[row]=0
		this.ii_update = 1
	end if	
end if
end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

type gb_1 from groupbox within w_ope024_articulos_autorizacion_aprobac
integer x = 41
integer y = 8
integer width = 1225
integer height = 168
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ubicar"
end type

