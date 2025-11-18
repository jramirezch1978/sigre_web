$PBExportHeader$w_pt014_usr_cnta_prsp.srw
forward
global type w_pt014_usr_cnta_prsp from w_abc
end type
type st_2 from statictext within w_pt014_usr_cnta_prsp
end type
type ddlb_2 from u_ddlb within w_pt014_usr_cnta_prsp
end type
type dw_master from u_dw_abc within w_pt014_usr_cnta_prsp
end type
end forward

global type w_pt014_usr_cnta_prsp from w_abc
integer width = 2245
integer height = 1840
string title = "Cencos - Cnta_prsp x Usuario (PT014)"
string menuname = "m_mantenimiento_sl"
st_2 st_2
ddlb_2 ddlb_2
dw_master dw_master
end type
global w_pt014_usr_cnta_prsp w_pt014_usr_cnta_prsp

type variables
string is_usuario
end variables

on w_pt014_usr_cnta_prsp.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.st_2=create st_2
this.ddlb_2=create ddlb_2
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.ddlb_2
this.Control[iCurrent+3]=this.dw_master
end on

on w_pt014_usr_cnta_prsp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.ddlb_2)
destroy(this.dw_master)
end on

event ue_insert;call super::ue_insert;Long  ll_row

if is_usuario = '' or IsNull(is_usuario) then
	MessageBox('Aviso', 'No ha selesccionado ningun usuario')
	return
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
dw_master.of_protect()         		// bloquear modificaciones 


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
	dw_master.ii_protect = 0
	dw_master.of_protect()
END IF
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_master.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
	END IF
END IF

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = FALSE
if f_row_Processing( dw_master, "form") <> true then	
	return
end if

ib_update_check = TRUE
end event

type st_2 from statictext within w_pt014_usr_cnta_prsp
integer x = 32
integer y = 44
integer width = 224
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Usuario:"
boolean focusrectangle = false
end type

type ddlb_2 from u_ddlb within w_pt014_usr_cnta_prsp
integer x = 283
integer y = 32
integer width = 1833
integer height = 780
boolean bringtotop = true
integer textsize = -8
boolean hscrollbar = true
end type

event modified;call super::modified;//String ls_usr
//
//ls_usr = this.text
//
//dw_1.Retrieve(ls_usr)
//dw_2.Retrieve(ls_usr)
end event

event ue_open_pre();call super::ue_open_pre;is_dataobject = 'd_usuario_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 12                     // Longitud del campo 1
ii_lc2 = 30							// Longitud del campo 2

end event

event ue_output;call super::ue_output;is_usuario = aa_key
dw_master.Retrieve(is_usuario)
dw_master.ii_update = 0
end event

type dw_master from u_dw_abc within w_pt014_usr_cnta_prsp
integer y = 148
integer width = 2103
integer height = 1456
integer taborder = 20
string dataobject = "d_abc_usr_cnta_prsp"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr[al_row] = is_usuario
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;return 1
end event

event doubleclicked;call super::doubleclicked;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 		= "d_list_cencos_cnta_prsp_tbl"
sl_param.titulo 	= "Cencos - Cnta Prsp"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.field_ret_i[3] = 3
sl_param.field_ret_i[4] = 4

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then	
	// Se ubica la cabecera
	this.object.cencos 			[row] = sl_param.field_ret[1]
	this.object.desc_cencos 	[row] = sl_param.field_ret[2]
	this.object.cnta_prsp 		[row] = sl_param.field_ret[3]
	this.object.desc_cnta_prsp [row] = sl_param.field_ret[4]
END IF
end event

