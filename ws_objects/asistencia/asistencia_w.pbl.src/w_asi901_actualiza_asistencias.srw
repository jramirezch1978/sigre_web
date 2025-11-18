$PBExportHeader$w_asi901_actualiza_asistencias.srw
forward
global type w_asi901_actualiza_asistencias from w_prc
end type
type cb_ttrab from commandbutton within w_asi901_actualiza_asistencias
end type
type st_5 from statictext within w_asi901_actualiza_asistencias
end type
type st_7 from statictext within w_asi901_actualiza_asistencias
end type
type em_ttrab from editmask within w_asi901_actualiza_asistencias
end type
type em_origen from editmask within w_asi901_actualiza_asistencias
end type
type cb_origen from commandbutton within w_asi901_actualiza_asistencias
end type
type em_descripcion_origen from editmask within w_asi901_actualiza_asistencias
end type
type em_descripcion_ttrab from editmask within w_asi901_actualiza_asistencias
end type
type uo_1 from u_ingreso_fecha within w_asi901_actualiza_asistencias
end type
type hpb_1 from hprogressbar within w_asi901_actualiza_asistencias
end type
type cb_1 from commandbutton within w_asi901_actualiza_asistencias
end type
type gb_1 from groupbox within w_asi901_actualiza_asistencias
end type
end forward

global type w_asi901_actualiza_asistencias from w_prc
integer width = 2066
integer height = 736
string title = "Transferencia de Asistencia (ASI902)"
string menuname = "m_proceso"
cb_ttrab cb_ttrab
st_5 st_5
st_7 st_7
em_ttrab em_ttrab
em_origen em_origen
cb_origen cb_origen
em_descripcion_origen em_descripcion_origen
em_descripcion_ttrab em_descripcion_ttrab
uo_1 uo_1
hpb_1 hpb_1
cb_1 cb_1
gb_1 gb_1
end type
global w_asi901_actualiza_asistencias w_asi901_actualiza_asistencias

on w_asi901_actualiza_asistencias.create
int iCurrent
call super::create
if this.MenuName = "m_proceso" then this.MenuID = create m_proceso
this.cb_ttrab=create cb_ttrab
this.st_5=create st_5
this.st_7=create st_7
this.em_ttrab=create em_ttrab
this.em_origen=create em_origen
this.cb_origen=create cb_origen
this.em_descripcion_origen=create em_descripcion_origen
this.em_descripcion_ttrab=create em_descripcion_ttrab
this.uo_1=create uo_1
this.hpb_1=create hpb_1
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ttrab
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.st_7
this.Control[iCurrent+4]=this.em_ttrab
this.Control[iCurrent+5]=this.em_origen
this.Control[iCurrent+6]=this.cb_origen
this.Control[iCurrent+7]=this.em_descripcion_origen
this.Control[iCurrent+8]=this.em_descripcion_ttrab
this.Control[iCurrent+9]=this.uo_1
this.Control[iCurrent+10]=this.hpb_1
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.gb_1
end on

on w_asi901_actualiza_asistencias.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_ttrab)
destroy(this.st_5)
destroy(this.st_7)
destroy(this.em_ttrab)
destroy(this.em_origen)
destroy(this.cb_origen)
destroy(this.em_descripcion_origen)
destroy(this.em_descripcion_ttrab)
destroy(this.uo_1)
destroy(this.hpb_1)
destroy(this.cb_1)
destroy(this.gb_1)
end on

type cb_ttrab from commandbutton within w_asi901_actualiza_asistencias
integer x = 672
integer y = 320
integer width = 87
integer height = 76
integer taborder = 40
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

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_ttrab.text             = sl_param.field_ret[1]
	em_descripcion_ttrab.text = sl_param.field_ret[2]
END IF

end event

type st_5 from statictext within w_asi901_actualiza_asistencias
integer x = 105
integer y = 236
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_7 from statictext within w_asi901_actualiza_asistencias
integer x = 105
integer y = 328
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ttrab from editmask within w_asi901_actualiza_asistencias
integer x = 489
integer y = 320
integer width = 151
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_asi901_actualiza_asistencias
integer x = 489
integer y = 228
integer width = 151
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_origen from commandbutton within w_asi901_actualiza_asistencias
integer x = 672
integer y = 228
integer width = 87
integer height = 76
integer taborder = 30
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
	em_origen.text             = sl_param.field_ret[1]
	em_descripcion_origen.text = sl_param.field_ret[2]
END IF

end event

type em_descripcion_origen from editmask within w_asi901_actualiza_asistencias
integer x = 773
integer y = 228
integer width = 846
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_descripcion_ttrab from editmask within w_asi901_actualiza_asistencias
integer x = 773
integer y = 320
integer width = 846
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type uo_1 from u_ingreso_fecha within w_asi901_actualiza_asistencias
integer x = 229
integer y = 120
integer taborder = 30
end type

event constructor;call super::constructor;of_set_label('Fecha : ') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

type hpb_1 from hprogressbar within w_asi901_actualiza_asistencias
integer x = 50
integer y = 444
integer width = 1925
integer height = 68
end type

type cb_1 from commandbutton within w_asi901_actualiza_asistencias
integer x = 1627
integer y = 76
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String  ls_tipo_trab,ls_origen,ls_msj_err
Boolean lb_ret = true
Date	  ld_fecha

ld_fecha 	 = uo_1.of_get_fecha()  
ls_origen	 = em_origen.text
ls_tipo_trab = em_ttrab.text

DECLARE PB_USP_RRHH_REGISTRA_ASISTENCIA PROCEDURE FOR USP_RRHH_REGISTRA_ASISTENCIA 
(:ld_fecha,:ls_tipo_trab,:ls_origen,:gs_user);
EXECUTE PB_USP_RRHH_REGISTRA_ASISTENCIA ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_msj_err)
	lb_ret = FALSE
END IF


IF lb_ret then
	Commit ;
	Messagebox('Aviso','Proceso Culmino Satisfactoriamente')
END IF

CLOSE PB_USP_RRHH_REGISTRA_ASISTENCIA ;
end event

type gb_1 from groupbox within w_asi901_actualiza_asistencias
integer x = 27
integer y = 20
integer width = 1984
integer height = 520
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Fecha a Registrar"
end type

