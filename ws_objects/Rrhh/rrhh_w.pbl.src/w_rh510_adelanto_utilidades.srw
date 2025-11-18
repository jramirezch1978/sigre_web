$PBExportHeader$w_rh510_adelanto_utilidades.srw
forward
global type w_rh510_adelanto_utilidades from w_prc
end type
type cbx_1 from checkbox within w_rh510_adelanto_utilidades
end type
type st_7 from statictext within w_rh510_adelanto_utilidades
end type
type st_6 from statictext within w_rh510_adelanto_utilidades
end type
type st_5 from statictext within w_rh510_adelanto_utilidades
end type
type em_monto from editmask within w_rh510_adelanto_utilidades
end type
type rb_fijo from radiobutton within w_rh510_adelanto_utilidades
end type
type rb_porcent from radiobutton within w_rh510_adelanto_utilidades
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh510_adelanto_utilidades
end type
type st_4 from statictext within w_rh510_adelanto_utilidades
end type
type st_2 from statictext within w_rh510_adelanto_utilidades
end type
type st_1 from statictext within w_rh510_adelanto_utilidades
end type
type em_ano from editmask within w_rh510_adelanto_utilidades
end type
type cb_1 from commandbutton within w_rh510_adelanto_utilidades
end type
type em_descripcion from editmask within w_rh510_adelanto_utilidades
end type
type em_origen from editmask within w_rh510_adelanto_utilidades
end type
type em_fecha from editmask within w_rh510_adelanto_utilidades
end type
type st_3 from statictext within w_rh510_adelanto_utilidades
end type
type cb_2 from commandbutton within w_rh510_adelanto_utilidades
end type
type gb_1 from groupbox within w_rh510_adelanto_utilidades
end type
end forward

global type w_rh510_adelanto_utilidades from w_prc
integer width = 2853
integer height = 1112
string title = "(RH510) Genera adelantos de Utilidades"
cbx_1 cbx_1
st_7 st_7
st_6 st_6
st_5 st_5
em_monto em_monto
rb_fijo rb_fijo
rb_porcent rb_porcent
uo_1 uo_1
st_4 st_4
st_2 st_2
st_1 st_1
em_ano em_ano
cb_1 cb_1
em_descripcion em_descripcion
em_origen em_origen
em_fecha em_fecha
st_3 st_3
cb_2 cb_2
gb_1 gb_1
end type
global w_rh510_adelanto_utilidades w_rh510_adelanto_utilidades

on w_rh510_adelanto_utilidades.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.em_monto=create em_monto
this.rb_fijo=create rb_fijo
this.rb_porcent=create rb_porcent
this.uo_1=create uo_1
this.st_4=create st_4
this.st_2=create st_2
this.st_1=create st_1
this.em_ano=create em_ano
this.cb_1=create cb_1
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.em_fecha=create em_fecha
this.st_3=create st_3
this.cb_2=create cb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.st_7
this.Control[iCurrent+3]=this.st_6
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.em_monto
this.Control[iCurrent+6]=this.rb_fijo
this.Control[iCurrent+7]=this.rb_porcent
this.Control[iCurrent+8]=this.uo_1
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.em_ano
this.Control[iCurrent+13]=this.cb_1
this.Control[iCurrent+14]=this.em_descripcion
this.Control[iCurrent+15]=this.em_origen
this.Control[iCurrent+16]=this.em_fecha
this.Control[iCurrent+17]=this.st_3
this.Control[iCurrent+18]=this.cb_2
this.Control[iCurrent+19]=this.gb_1
end on

on w_rh510_adelanto_utilidades.destroy
call super::destroy
destroy(this.cbx_1)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.em_monto)
destroy(this.rb_fijo)
destroy(this.rb_porcent)
destroy(this.uo_1)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.cb_1)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_fecha)
destroy(this.st_3)
destroy(this.cb_2)
destroy(this.gb_1)
end on

type cbx_1 from checkbox within w_rh510_adelanto_utilidades
integer x = 1755
integer y = 372
integer width = 928
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Elimina adelantos perosnal exterior"
end type

type st_7 from statictext within w_rh510_adelanto_utilidades
integer x = 1769
integer y = 220
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "judiciales."
boolean focusrectangle = false
end type

type st_6 from statictext within w_rh510_adelanto_utilidades
integer x = 1769
integer y = 148
integer width = 1015
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "utilidades. Considerará los porcentajes"
boolean focusrectangle = false
end type

type st_5 from statictext within w_rh510_adelanto_utilidades
integer x = 1769
integer y = 76
integer width = 987
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Este proceso generará adelantos de "
boolean focusrectangle = false
end type

type em_monto from editmask within w_rh510_adelanto_utilidades
integer x = 969
integer y = 336
integer width = 347
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type rb_fijo from radiobutton within w_rh510_adelanto_utilidades
integer x = 101
integer y = 380
integer width = 686
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Monto fijo:"
end type

type rb_porcent from radiobutton within w_rh510_adelanto_utilidades
integer x = 101
integer y = 292
integer width = 686
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Porcentaje remuneración:"
boolean checked = true
end type

type uo_1 from u_ddlb_tipo_trabajador within w_rh510_adelanto_utilidades
integer x = 1605
integer y = 540
boolean bringtotop = true
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type st_4 from statictext within w_rh510_adelanto_utilidades
integer x = 101
integer y = 152
integer width = 357
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Corresponde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh510_adelanto_utilidades
integer x = 101
integer y = 96
integer width = 357
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Periodo a que"
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh510_adelanto_utilidades
integer x = 869
integer y = 152
integer width = 466
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Tope Para Adelanto"
boolean focusrectangle = false
end type

type em_ano from editmask within w_rh510_adelanto_utilidades
integer x = 517
integer y = 116
integer width = 270
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_1 from commandbutton within w_rh510_adelanto_utilidades
integer x = 1152
integer y = 868
integer width = 293
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;integer li_periodo
string  ls_origen, ls_tipo_trabaj, ls_mensaje, ls_tipo_dcto
date    ld_fecha_tope
decimal{2} ld_monto

Parent.SetMicroHelp('Procesando Adelantos a Cuenta de Utilidades')

li_periodo    = integer(em_ano.text)
ld_fecha_tope = date(em_fecha.text)
ls_origen     = string(em_origen.text)

ls_tipo_trabaj = uo_1.of_get_value()

IF rb_porcent.checked = false or rb_fijo.checked = false then
	MessageBox('Aviso','Defina tipo de cantidad a adelantar')
	Return 1
ELSEIF rb_porcent.checked = true THEN
	ls_tipo_dcto='P'
ELSE
	ls_tipo_dcto='F'
END IF 

IF Dec(em_monto.text)<=0 THEN
	MessageBox('Aviso','Cantidad a descontar errada')
	Return 1
ELSE
	ld_monto = Dec(em_monto.text) 
END IF 

if isnull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then ls_tipo_trabaj = '%'

DECLARE pb_usp_rh_utl_adelantos PROCEDURE FOR USP_RH_UTL_ADELANTOS
        ( :li_periodo, :ld_fecha_tope, :ls_origen, :ls_tipo_trabaj, 
		  	:ls_tipo_dcto, :ld_monto) ;
EXECUTE pb_usp_rh_utl_adelantos ;

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("SQL error", ls_mensaje)
  MessageBox('Atención','Proceso de generación de Adelantos falló', Exclamation! )
  Parent.SetMicroHelp('Proceso no se llegó a realizar')
ELSE
  commit ;
  MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
END IF

end event

type em_descripcion from editmask within w_rh510_adelanto_utilidades
integer x = 475
integer y = 620
integer width = 1006
integer height = 76
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

type em_origen from editmask within w_rh510_adelanto_utilidades
integer x = 165
integer y = 620
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

type em_fecha from editmask within w_rh510_adelanto_utilidades
integer x = 1371
integer y = 116
integer width = 347
integer height = 84
integer taborder = 20
boolean bringtotop = true
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

type st_3 from statictext within w_rh510_adelanto_utilidades
integer x = 869
integer y = 96
integer width = 466
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Fecha de Ingreso"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rh510_adelanto_utilidades
integer x = 352
integer y = 620
integer width = 87
integer height = 76
integer taborder = 30
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

type gb_1 from groupbox within w_rh510_adelanto_utilidades
integer x = 96
integer y = 548
integer width = 1440
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

