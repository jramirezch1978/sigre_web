$PBExportHeader$w_cn902_saldos_x_cencos.srw
forward
global type w_cn902_saldos_x_cencos from w_prc
end type
type st_5 from statictext within w_cn902_saldos_x_cencos
end type
type sle_mes from singlelineedit within w_cn902_saldos_x_cencos
end type
type sle_ano from singlelineedit within w_cn902_saldos_x_cencos
end type
type cb_cancelar from commandbutton within w_cn902_saldos_x_cencos
end type
type cb_generar from commandbutton within w_cn902_saldos_x_cencos
end type
type st_3 from statictext within w_cn902_saldos_x_cencos
end type
type st_2 from statictext within w_cn902_saldos_x_cencos
end type
type st_1 from statictext within w_cn902_saldos_x_cencos
end type
type r_1 from rectangle within w_cn902_saldos_x_cencos
end type
end forward

global type w_cn902_saldos_x_cencos from w_prc
integer width = 1477
integer height = 944
string title = "Generacion de pre asientos de talleres (CN945)"
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
global w_cn902_saldos_x_cencos w_cn902_saldos_x_cencos

on w_cn902_saldos_x_cencos.create
int iCurrent
call super::create
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

on w_cn902_saldos_x_cencos.destroy
call super::destroy
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

event open;call super::open;String ls_ano, ls_mes
Long ll_nro_libro
// Proceso SCEN (Saldo por centro de costo)
ls_ano = string( year( today() ) )
ls_mes = string( month( today() ) )
					
sle_ano.text = ls_ano
sle_mes.text = ls_mes

end event

type st_5 from statictext within w_cn902_saldos_x_cencos
integer x = 165
integer y = 180
integer width = 1134
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centros de costos"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cn902_saldos_x_cencos
integer x = 809
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

type sle_ano from singlelineedit within w_cn902_saldos_x_cencos
integer x = 809
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

type cb_cancelar from commandbutton within w_cn902_saldos_x_cencos
integer x = 873
integer y = 688
integer width = 302
integer height = 80
integer taborder = 70
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

type cb_generar from commandbutton within w_cn902_saldos_x_cencos
integer x = 347
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
string text = "Generar"
end type

event clicked;string  ls_ano, ls_mes, ls_fecha

cb_generar.enabled = false
sle_ano.enabled = false
sle_mes.enabled = false

ls_ano = sle_ano.text
ls_mes = sle_mes.text


DECLARE PB_USP_CNT_945_TALLERES PROCEDURE FOR USP_CNT_945_TALLERES ( 
   :ls_ano, :ls_mes, :gs_origen, :gs_user ) ;
execute PB_USP_CNT_945_TALLERES ;

if sqlca.sqlcode = -1 Then
	rollback ;
	MessageBox( 'Error', "Procedimiento <<USP_CNT_944_ALM_ING>> no concluyo correctamente", StopSign! )
else
	commit ;
	MessageBox( 'Mensaje', "Proceso terminado" )
End If
		
Close pb_usp_cnt_945_talleres ;
cb_generar.enabled = true
sle_ano.enabled = true
sle_mes.enabled = true
end event

type st_3 from statictext within w_cn902_saldos_x_cencos
integer x = 366
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

type st_2 from statictext within w_cn902_saldos_x_cencos
integer x = 366
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

type st_1 from statictext within w_cn902_saldos_x_cencos
integer x = 160
integer y = 68
integer width = 1134
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generacion de saldos de "
alignment alignment = center!
boolean focusrectangle = false
end type

type r_1 from rectangle within w_cn902_saldos_x_cencos
integer linethickness = 1
long fillcolor = 12632256
integer x = 274
integer y = 348
integer width = 827
integer height = 268
end type

