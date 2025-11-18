$PBExportHeader$w_cn974_elimina_asiento_diario.srw
forward
global type w_cn974_elimina_asiento_diario from w_prc
end type
type st_2 from statictext within w_cn974_elimina_asiento_diario
end type
type st_1 from statictext within w_cn974_elimina_asiento_diario
end type
type em_desc_diario from editmask within w_cn974_elimina_asiento_diario
end type
type em_diario from editmask within w_cn974_elimina_asiento_diario
end type
type cb_2 from commandbutton within w_cn974_elimina_asiento_diario
end type
type em_mes from editmask within w_cn974_elimina_asiento_diario
end type
type em_ano from editmask within w_cn974_elimina_asiento_diario
end type
type cb_cancelar from commandbutton within w_cn974_elimina_asiento_diario
end type
type cb_generar from commandbutton within w_cn974_elimina_asiento_diario
end type
type gb_1 from groupbox within w_cn974_elimina_asiento_diario
end type
type gb_2 from groupbox within w_cn974_elimina_asiento_diario
end type
end forward

global type w_cn974_elimina_asiento_diario from w_prc
integer width = 2144
integer height = 980
string title = "(CN974) Elimina Diario Totalmente Fisicamente"
st_2 st_2
st_1 st_1
em_desc_diario em_desc_diario
em_diario em_diario
cb_2 cb_2
em_mes em_mes
em_ano em_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
gb_1 gb_1
gb_2 gb_2
end type
global w_cn974_elimina_asiento_diario w_cn974_elimina_asiento_diario

on w_cn974_elimina_asiento_diario.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
this.em_desc_diario=create em_desc_diario
this.em_diario=create em_diario
this.cb_2=create cb_2
this.em_mes=create em_mes
this.em_ano=create em_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_desc_diario
this.Control[iCurrent+4]=this.em_diario
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.em_mes
this.Control[iCurrent+7]=this.em_ano
this.Control[iCurrent+8]=this.cb_cancelar
this.Control[iCurrent+9]=this.cb_generar
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_cn974_elimina_asiento_diario.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_desc_diario)
destroy(this.em_diario)
destroy(this.cb_2)
destroy(this.em_mes)
destroy(this.em_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

type st_2 from statictext within w_cn974_elimina_asiento_diario
integer x = 1093
integer y = 416
integer width = 110
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn974_elimina_asiento_diario
integer x = 649
integer y = 416
integer width = 110
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type em_desc_diario from editmask within w_cn974_elimina_asiento_diario
integer x = 507
integer y = 152
integer width = 1390
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "."
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
end type

type em_diario from editmask within w_cn974_elimina_asiento_diario
integer x = 178
integer y = 152
integer width = 165
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "z"
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type cb_2 from commandbutton within w_cn974_elimina_asiento_diario
integer x = 379
integer y = 152
integer width = 87
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_diario_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_diario.text = sl_param.field_ret[1]
	em_desc_diario.text = sl_param.field_ret[2]
END IF

end event

type em_mes from editmask within w_cn974_elimina_asiento_diario
integer x = 1230
integer y = 412
integer width = 178
integer height = 72
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "z"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_ano from editmask within w_cn974_elimina_asiento_diario
integer x = 800
integer y = 412
integer width = 247
integer height = 72
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "z"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_cancelar from commandbutton within w_cn974_elimina_asiento_diario
integer x = 1120
integer y = 648
integer width = 320
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;CLOSE (PARENT)
end event

type cb_generar from commandbutton within w_cn974_elimina_asiento_diario
integer x = 640
integer y = 644
integer width = 320
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;cb_generar.enabled  = false
cb_cancelar.enabled = false

integer li_diario, li_ano, li_mes
string ls_mensaje

li_diario = integer(em_diario.text)
li_ano    = integer(em_ano.text)
li_mes    = integer(em_mes.text)

delete from cntbl_asiento_det_aux
  where ano = :li_ano 
    and mes = :li_mes 
	 and nro_libro = :li_diario ;

IF sqlca.sqlcode < 0 THEN
   ls_mensaje = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error', "Error al eliminar tabla cntbl_asiento_det_aux. Mensaje: " + ls_mensaje, StopSign! )
	return
end if

delete from cntbl_asiento_det
  where ano = :li_ano 
    and mes = :li_mes 
	 and nro_libro = :li_diario ;

IF sqlca.sqlcode < 0 THEN
   ls_mensaje = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error', "Error al eliminar tabla cntbl_asiento_det. Mensaje: " + ls_mensaje, StopSign! )
	return
end if

delete from cntbl_asiento
  where ano = :li_ano 
    and mes = :li_mes 
	 and nro_libro = :li_diario ;
  
IF sqlca.sqlcode < 0 THEN
   ls_mensaje = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error', "Error al eliminar tabla cntbl_Asiento. Mensaje: " + ls_mensaje, StopSign! )
	return
end if

COMMIT ;
MessageBox ('Atención', "Proceso Ha Concluído Satisfactoriamente")

cb_generar.enabled  = true
cb_cancelar.enabled = true

end event

type gb_1 from groupbox within w_cn974_elimina_asiento_diario
integer x = 123
integer y = 72
integer width = 1833
integer height = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Seleccione Diario "
end type

type gb_2 from groupbox within w_cn974_elimina_asiento_diario
integer x = 594
integer y = 332
integer width = 887
integer height = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Fecha de Proceso "
end type

