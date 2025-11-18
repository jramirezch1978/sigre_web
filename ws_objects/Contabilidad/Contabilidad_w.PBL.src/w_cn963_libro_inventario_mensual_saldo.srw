$PBExportHeader$w_cn963_libro_inventario_mensual_saldo.srw
forward
global type w_cn963_libro_inventario_mensual_saldo from w_prc
end type
type st_5 from statictext within w_cn963_libro_inventario_mensual_saldo
end type
type sle_mes from singlelineedit within w_cn963_libro_inventario_mensual_saldo
end type
type sle_ano from singlelineedit within w_cn963_libro_inventario_mensual_saldo
end type
type cb_cancelar from commandbutton within w_cn963_libro_inventario_mensual_saldo
end type
type cb_generar from commandbutton within w_cn963_libro_inventario_mensual_saldo
end type
type st_3 from statictext within w_cn963_libro_inventario_mensual_saldo
end type
type st_2 from statictext within w_cn963_libro_inventario_mensual_saldo
end type
type st_1 from statictext within w_cn963_libro_inventario_mensual_saldo
end type
type r_1 from rectangle within w_cn963_libro_inventario_mensual_saldo
end type
end forward

global type w_cn963_libro_inventario_mensual_saldo from w_prc
integer width = 1664
integer height = 996
string title = "(CN963) Saldo Valorizado  Mensual  de Almacen de Materiales "
string menuname = "m_prc"
st_5 st_5
sle_mes sle_mes
sle_ano sle_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_3 st_3
st_2 st_2
st_1 st_1
r_1 r_1
end type
global w_cn963_libro_inventario_mensual_saldo w_cn963_libro_inventario_mensual_saldo

type variables

end variables

on w_cn963_libro_inventario_mensual_saldo.create
int iCurrent
call super::create
if this.MenuName = "m_prc" then this.MenuID = create m_prc
this.st_5=create st_5
this.sle_mes=create sle_mes
this.sle_ano=create sle_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.sle_ano
this.Control[iCurrent+4]=this.cb_cancelar
this.Control[iCurrent+5]=this.cb_generar
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.r_1
end on

on w_cn963_libro_inventario_mensual_saldo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_5)
destroy(this.sle_mes)
destroy(this.sle_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.r_1)
end on

event open;call super::open;String ls_ano, ls_mes, ls_nro_libro

ls_ano = string( year( today() ) )
ls_mes = string( month( today() ) )
					
sle_ano.text = ls_ano
sle_mes.text = ls_mes
end event

type st_5 from statictext within w_cn963_libro_inventario_mensual_saldo
integer x = 73
integer y = 160
integer width = 1477
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "articulos de almacen de materiales"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cn963_libro_inventario_mensual_saldo
integer x = 914
integer y = 496
integer width = 187
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_ano from singlelineedit within w_cn963_libro_inventario_mensual_saldo
integer x = 914
integer y = 404
integer width = 187
integer height = 64
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_cn963_libro_inventario_mensual_saldo
integer x = 823
integer y = 688
integer width = 302
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;close(parent)
end event

type cb_generar from commandbutton within w_cn963_libro_inventario_mensual_saldo
integer x = 494
integer y = 688
integer width = 302
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

event clicked;string  ls_ano, ls_mes, ls_msj
integer ll_ano, ll_mes

cb_generar.enabled = false
cb_cancelar.enabled = false
sle_ano.enabled = false
sle_mes.enabled = false

ls_ano = sle_ano.text
ls_mes = sle_mes.text
//ll_ano = LONG(ls_ano)
//ll_mes = LONG(ls_mes)
ll_ano = integer(ls_ano)
ll_mes = integer(ls_mes)

	DECLARE PB_usp_cnt_arti_precio_promedio PROCEDURE FOR usp_cnt_arti_precio_promedio ( 
   	:ll_ano, :ll_mes ) ;
	
	execute PB_usp_cnt_arti_precio_promedio ;

	if sqlca.sqlcode = -1 Then
		ls_msj = sqlca.sqlerrtext
	rollback ;
		MessageBox( 'Error', ls_msj, StopSign! )
		MessageBox( 'Error', "Procedimiento <<USP_CNT_ARTI_PRECIO_PROMEDIO1>> no concluyo correctamente", StopSign! )
	else
		commit ;
		MessageBox( 'Mensaje', "Proceso terminado" )
	End If
		
	Close PB_usp_cnt_arti_precio_promedio ;

	cb_generar.enabled = true
	cb_cancelar.enabled = true
	sle_ano.enabled = true
	sle_mes.enabled = true

end event

type st_3 from statictext within w_cn963_libro_inventario_mensual_saldo
integer x = 471
integer y = 492
integer width = 357
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn963_libro_inventario_mensual_saldo
integer x = 471
integer y = 404
integer width = 357
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn963_libro_inventario_mensual_saldo
integer x = 87
integer y = 68
integer width = 1486
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proceso que genera Saldo Valorizado de"
alignment alignment = center!
boolean focusrectangle = false
end type

type r_1 from rectangle within w_cn963_libro_inventario_mensual_saldo
integer linethickness = 1
long fillcolor = 12632256
integer x = 379
integer y = 348
integer width = 827
integer height = 280
end type

