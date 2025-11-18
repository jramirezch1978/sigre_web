$PBExportHeader$w_rh358_rpt_adelanto_gratificacion_st.srw
forward
global type w_rh358_rpt_adelanto_gratificacion_st from w_report_smpl
end type
type cb_3 from commandbutton within w_rh358_rpt_adelanto_gratificacion_st
end type
type em_descripcion from editmask within w_rh358_rpt_adelanto_gratificacion_st
end type
type em_origen from editmask within w_rh358_rpt_adelanto_gratificacion_st
end type
type em_desc_tipo from editmask within w_rh358_rpt_adelanto_gratificacion_st
end type
type em_tipo from editmask within w_rh358_rpt_adelanto_gratificacion_st
end type
type cb_2 from commandbutton within w_rh358_rpt_adelanto_gratificacion_st
end type
type cb_1 from commandbutton within w_rh358_rpt_adelanto_gratificacion_st
end type
type uo_1 from u_ingreso_fecha within w_rh358_rpt_adelanto_gratificacion_st
end type
type st_1 from statictext within w_rh358_rpt_adelanto_gratificacion_st
end type
type st_2 from statictext within w_rh358_rpt_adelanto_gratificacion_st
end type
type gb_2 from groupbox within w_rh358_rpt_adelanto_gratificacion_st
end type
end forward

global type w_rh358_rpt_adelanto_gratificacion_st from w_report_smpl
integer width = 3387
integer height = 1500
string title = "(RH358) Adelanto de Gratificaciones del Personal sin Tarjeta de Ahorro"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
uo_1 uo_1
st_1 st_1
st_2 st_2
gb_2 gb_2
end type
global w_rh358_rpt_adelanto_gratificacion_st w_rh358_rpt_adelanto_gratificacion_st

on w_rh358_rpt_adelanto_gratificacion_st.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.em_desc_tipo=create em_desc_tipo
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.cb_1=create cb_1
this.uo_1=create uo_1
this.st_1=create st_1
this.st_2=create st_2
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_desc_tipo
this.Control[iCurrent+5]=this.em_tipo
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.uo_1
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.gb_2
end on

on w_rh358_rpt_adelanto_gratificacion_st.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String ls_origen, ls_tiptra, ls_descripcion
Date	 ld_fecha	

ls_origen 		= String(em_origen.text)
ls_tiptra 		= String(em_tipo.text)
ls_descripcion = String(em_desc_tipo.text)
ld_fecha			= uo_1.of_get_fecha()

dw_report.retrieve (ls_tiptra,ls_origen,ld_fecha)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.st_sit.text = ls_descripcion

end event

type dw_report from w_report_smpl`dw_report within w_rh358_rpt_adelanto_gratificacion_st
integer x = 0
integer y = 412
integer width = 3328
integer height = 844
integer taborder = 60
string dataobject = "d_rpt_adel_gratif_sin_tarjeta_tbl"
end type

type cb_3 from commandbutton within w_rh358_rpt_adelanto_gratificacion_st
integer x = 608
integer y = 200
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

type em_descripcion from editmask within w_rh358_rpt_adelanto_gratificacion_st
integer x = 709
integer y = 208
integer width = 759
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh358_rpt_adelanto_gratificacion_st
integer x = 439
integer y = 208
integer width = 151
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_desc_tipo from editmask within w_rh358_rpt_adelanto_gratificacion_st
integer x = 713
integer y = 300
integer width = 759
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh358_rpt_adelanto_gratificacion_st
integer x = 443
integer y = 300
integer width = 151
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh358_rpt_adelanto_gratificacion_st
integer x = 613
integer y = 292
integer width = 87
integer height = 68
integer taborder = 20
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

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_tiptra, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_tipo.text      = sl_param.field_ret[1]
	em_desc_tipo.text = sl_param.field_ret[2]
END IF

end event

type cb_1 from commandbutton within w_rh358_rpt_adelanto_gratificacion_st
integer x = 2825
integer y = 112
integer width = 293
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type uo_1 from u_ingreso_fecha within w_rh358_rpt_adelanto_gratificacion_st
integer x = 55
integer y = 92
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

type st_1 from statictext within w_rh358_rpt_adelanto_gratificacion_st
integer x = 55
integer y = 208
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh358_rpt_adelanto_gratificacion_st
integer x = 37
integer y = 304
integer width = 375
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_rh358_rpt_adelanto_gratificacion_st
integer width = 1650
integer height = 400
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Datos"
end type

