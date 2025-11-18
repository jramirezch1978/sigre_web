$PBExportHeader$w_rh453_p_pago_sin_cnta_ahorro.srw
forward
global type w_rh453_p_pago_sin_cnta_ahorro from w_prc
end type
type cb_1 from commandbutton within w_rh453_p_pago_sin_cnta_ahorro
end type
type em_fecha from editmask within w_rh453_p_pago_sin_cnta_ahorro
end type
type em_descripcion from editmask within w_rh453_p_pago_sin_cnta_ahorro
end type
type em_origen from editmask within w_rh453_p_pago_sin_cnta_ahorro
end type
type cb_2 from commandbutton within w_rh453_p_pago_sin_cnta_ahorro
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh453_p_pago_sin_cnta_ahorro
end type
type gb_1 from groupbox within w_rh453_p_pago_sin_cnta_ahorro
end type
type gb_2 from groupbox within w_rh453_p_pago_sin_cnta_ahorro
end type
end forward

global type w_rh453_p_pago_sin_cnta_ahorro from w_prc
integer width = 2665
integer height = 916
string title = "(RH453) C.E. del Personal Sin Cuenta de Ahorro"
cb_1 cb_1
em_fecha em_fecha
em_descripcion em_descripcion
em_origen em_origen
cb_2 cb_2
uo_1 uo_1
gb_1 gb_1
gb_2 gb_2
end type
global w_rh453_p_pago_sin_cnta_ahorro w_rh453_p_pago_sin_cnta_ahorro

on w_rh453_p_pago_sin_cnta_ahorro.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.em_fecha=create em_fecha
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_2=create cb_2
this.uo_1=create uo_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_fecha
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.uo_1
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_rh453_p_pago_sin_cnta_ahorro.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.em_fecha)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_2)
destroy(this.uo_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

type cb_1 from commandbutton within w_rh453_p_pago_sin_cnta_ahorro
integer x = 1161
integer y = 636
integer width = 293
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.SetMicroHelp('Procesando Pagos a Personal Sin Cuenta de Ahorro')

string ls_origen, ls_mensaje, ls_tipo_trabaj
date   ld_fecha

ls_origen = string(em_origen.text)
ld_fecha  = date(em_fecha.text)

ls_tipo_trabaj = uo_1.of_get_Value()

if isnull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then ls_tipo_trabaj = '%'

DECLARE pb_usp_rh_pago_sin_cnta_ahorro PROCEDURE FOR USP_RH_PAGO_SIN_CNTA_AHORRO
        ( :ls_origen, :gs_user, :ld_fecha, :ls_tipo_trabaj ) ;
EXECUTE pb_usp_rh_pago_sin_cnta_ahorro ;

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("SQL error", ls_mensaje)
  MessageBox('Atención','Proceso de generación de cheques falló', Exclamation! )
  Parent.SetMicroHelp('Proceso no se llegó a realizar')
ELSE
  commit ;
  MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
END IF

end event

type em_fecha from editmask within w_rh453_p_pago_sin_cnta_ahorro
integer x = 1157
integer y = 436
integer width = 306
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type em_descripcion from editmask within w_rh453_p_pago_sin_cnta_ahorro
integer x = 462
integer y = 160
integer width = 1061
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh453_p_pago_sin_cnta_ahorro
integer x = 155
integer y = 160
integer width = 151
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh453_p_pago_sin_cnta_ahorro
integer x = 343
integer y = 160
integer width = 87
integer height = 68
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type uo_1 from u_ddlb_tipo_trabajador within w_rh453_p_pago_sin_cnta_ahorro
integer x = 1609
integer y = 72
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type gb_1 from groupbox within w_rh453_p_pago_sin_cnta_ahorro
integer x = 1056
integer y = 368
integer width = 507
integer height = 188
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Fecha de Proceso "
borderstyle borderstyle = stylebox!
end type

type gb_2 from groupbox within w_rh453_p_pago_sin_cnta_ahorro
integer x = 96
integer y = 88
integer width = 1472
integer height = 192
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
borderstyle borderstyle = stylebox!
end type

