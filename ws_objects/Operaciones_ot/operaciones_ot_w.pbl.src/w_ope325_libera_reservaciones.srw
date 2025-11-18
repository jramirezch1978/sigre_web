$PBExportHeader$w_ope325_libera_reservaciones.srw
forward
global type w_ope325_libera_reservaciones from w_abc_master_smpl
end type
type sle_nro_ot from u_sle_codigo within w_ope325_libera_reservaciones
end type
type st_1 from statictext within w_ope325_libera_reservaciones
end type
type cb_1 from commandbutton within w_ope325_libera_reservaciones
end type
type gb_1 from groupbox within w_ope325_libera_reservaciones
end type
end forward

global type w_ope325_libera_reservaciones from w_abc_master_smpl
integer width = 2487
integer height = 1488
string title = "[AL326] Liberación de reservaciones"
string menuname = "m_list_modify_save_exit"
sle_nro_ot sle_nro_ot
st_1 st_1
cb_1 cb_1
gb_1 gb_1
end type
global w_ope325_libera_reservaciones w_ope325_libera_reservaciones

on w_ope325_libera_reservaciones.create
int iCurrent
call super::create
if this.MenuName = "m_list_modify_save_exit" then this.MenuID = create m_list_modify_save_exit
this.sle_nro_ot=create sle_nro_ot
this.st_1=create st_1
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro_ot
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_ope325_libera_reservaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nro_ot)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

ib_update_check = true
end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0 
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		
IF ib_update_check = FALSE THEN RETURN

sl_param.dw1     = 'd_lista_ot_reservacion_x_usr_tbl'
sl_param.titulo  = 'Orden de Trabajo'
sl_param.tipo    = '1S'
sl_param.string1 = gs_user


sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	sle_nro_ot.text = sl_param.field_ret[1]
	dw_master.Retrieve(sl_param.field_ret[1])
	TriggerEvent ('ue_modify')
	
END IF


end event

type dw_master from w_abc_master_smpl`dw_master within w_ope325_libera_reservaciones
integer x = 0
integer y = 200
integer width = 2423
integer height = 1068
string dataobject = "d_proc_liberacion_amp"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

//ii_rk[1] = 1 	      // columnas que recibimos del master

end event

type sle_nro_ot from u_sle_codigo within w_ope325_libera_reservaciones
integer x = 517
integer y = 64
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
long backcolor = 16777215
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type st_1 from statictext within w_ope325_libera_reservaciones
integer x = 50
integer y = 76
integer width = 462
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Trabajo"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ope325_libera_reservaciones
integer x = 1056
integer y = 60
integer width = 507
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_nro_ot

// ls_fecha_inicio,ls_fecha_final,
ls_nro_ot = trim(sle_nro_ot.text)

IF Isnull(ls_nro_ot) or trim(ls_nro_ot) = '' THEN 
	MessageBox('Error', 'Debe ingresar un número de OT válido')
	sle_nro_ot.setFocus()
	return
end if

//Ahora valido si tiene acceso a ver esa Orden de trabajo

dw_master.Retrieve(ls_nro_ot)


end event

type gb_1 from groupbox within w_ope325_libera_reservaciones
integer width = 1627
integer height = 188
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Busqueda"
end type

