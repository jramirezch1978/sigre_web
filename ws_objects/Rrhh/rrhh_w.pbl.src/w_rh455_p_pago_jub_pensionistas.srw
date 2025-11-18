$PBExportHeader$w_rh455_p_pago_jub_pensionistas.srw
forward
global type w_rh455_p_pago_jub_pensionistas from w_prc
end type
type cb_1 from commandbutton within w_rh455_p_pago_jub_pensionistas
end type
type em_fecha from editmask within w_rh455_p_pago_jub_pensionistas
end type
type em_descripcion from editmask within w_rh455_p_pago_jub_pensionistas
end type
type em_origen from editmask within w_rh455_p_pago_jub_pensionistas
end type
type cb_2 from commandbutton within w_rh455_p_pago_jub_pensionistas
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh455_p_pago_jub_pensionistas
end type
type gb_1 from groupbox within w_rh455_p_pago_jub_pensionistas
end type
type gb_2 from groupbox within w_rh455_p_pago_jub_pensionistas
end type
end forward

global type w_rh455_p_pago_jub_pensionistas from w_prc
integer width = 2661
integer height = 928
string title = "(RH455) C.E. del Personal Jubilado Pensionista"
cb_1 cb_1
em_fecha em_fecha
em_descripcion em_descripcion
em_origen em_origen
cb_2 cb_2
uo_1 uo_1
gb_1 gb_1
gb_2 gb_2
end type
global w_rh455_p_pago_jub_pensionistas w_rh455_p_pago_jub_pensionistas

on w_rh455_p_pago_jub_pensionistas.create
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

on w_rh455_p_pago_jub_pensionistas.destroy
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

type cb_1 from commandbutton within w_rh455_p_pago_jub_pensionistas
integer x = 1161
integer y = 640
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

event clicked;Parent.SetMicroHelp('Procesando Pagos a Personal Jubilado Pensionista')

string ls_origen, ls_mensaje, ls_tipo_trabaj
date ld_fecha

ls_origen = string(em_origen.text)
ld_fecha  = date(em_fecha.text)

ls_tipo_trabaj = uo_1.of_get_value()

if isnull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then ls_tipo_trabaj = '%'

DECLARE pb_usp_rh_pago_jub_pensionistas PROCEDURE FOR USP_RH_PAGO_JUB_PENSIONISTAS
        ( :ls_origen, :gs_user, :ld_fecha, :ls_tipo_trabaj ) ;
EXECUTE pb_usp_rh_pago_jub_pensionistas ;

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

type em_fecha from editmask within w_rh455_p_pago_jub_pensionistas
integer x = 1138
integer y = 452
integer width = 338
integer height = 72
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

type em_descripcion from editmask within w_rh455_p_pago_jub_pensionistas
integer x = 430
integer y = 172
integer width = 1097
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh455_p_pago_jub_pensionistas
integer x = 133
integer y = 172
integer width = 151
integer height = 72
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

type cb_2 from commandbutton within w_rh455_p_pago_jub_pensionistas
integer x = 315
integer y = 172
integer width = 87
integer height = 72
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

type uo_1 from u_ddlb_tipo_trabajador within w_rh455_p_pago_jub_pensionistas
event destroy ( )
integer x = 1632
integer y = 88
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type gb_1 from groupbox within w_rh455_p_pago_jub_pensionistas
integer x = 1051
integer y = 384
integer width = 517
integer height = 184
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

type gb_2 from groupbox within w_rh455_p_pago_jub_pensionistas
integer x = 73
integer y = 96
integer width = 1518
integer height = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

