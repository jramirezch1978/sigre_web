$PBExportHeader$w_cn953_cuadre_asiento.srw
forward
global type w_cn953_cuadre_asiento from w_prc
end type
type st_5 from statictext within w_cn953_cuadre_asiento
end type
type sle_origen from singlelineedit within w_cn953_cuadre_asiento
end type
type sle_mes from singlelineedit within w_cn953_cuadre_asiento
end type
type sle_ano from singlelineedit within w_cn953_cuadre_asiento
end type
type cb_cancelar from commandbutton within w_cn953_cuadre_asiento
end type
type cb_generar from commandbutton within w_cn953_cuadre_asiento
end type
type st_4 from statictext within w_cn953_cuadre_asiento
end type
type st_3 from statictext within w_cn953_cuadre_asiento
end type
type st_2 from statictext within w_cn953_cuadre_asiento
end type
type st_1 from statictext within w_cn953_cuadre_asiento
end type
type r_1 from rectangle within w_cn953_cuadre_asiento
end type
end forward

global type w_cn953_cuadre_asiento from w_prc
integer width = 1477
integer height = 1116
string title = "Regeneracion asientos contables (CN953)"
st_5 st_5
sle_origen sle_origen
sle_mes sle_mes
sle_ano sle_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
r_1 r_1
end type
global w_cn953_cuadre_asiento w_cn953_cuadre_asiento

on w_cn953_cuadre_asiento.create
int iCurrent
call super::create
this.st_5=create st_5
this.sle_origen=create sle_origen
this.sle_mes=create sle_mes
this.sle_ano=create sle_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.cb_cancelar
this.Control[iCurrent+6]=this.cb_generar
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.r_1
end on

on w_cn953_cuadre_asiento.destroy
call super::destroy
destroy(this.st_5)
destroy(this.sle_origen)
destroy(this.sle_mes)
destroy(this.sle_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.r_1)
end on

event open;call super::open;String ls_ano, ls_mes, ls_nro_libro, ls_origen

ls_ano = string( year( today() ) )
ls_mes = string( month( today() ) )
ls_origen = gs_origen
					
sle_ano.text = ls_ano
sle_mes.text = ls_mes
sle_origen.text = ls_origen

end event

type st_5 from statictext within w_cn953_cuadre_asiento
integer x = 155
integer y = 160
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
string text = "por origen, año y mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_cn953_cuadre_asiento
integer x = 809
integer y = 584
integer width = 187
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn953_cuadre_asiento
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

type sle_ano from singlelineedit within w_cn953_cuadre_asiento
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

type cb_cancelar from commandbutton within w_cn953_cuadre_asiento
integer x = 759
integer y = 844
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

type cb_generar from commandbutton within w_cn953_cuadre_asiento
integer x = 375
integer y = 844
integer width = 302
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;String  ls_ano, ls_mes, ls_origen
Long ll_ano, ll_mes


cb_generar.enabled = false
sle_ano.enabled = false
sle_mes.enabled = false
sle_origen.enabled = false

ll_ano = Long(sle_ano.text)
ll_mes = Long(sle_mes.text)
ls_origen = sle_origen.text

DECLARE PB_USP_CNT_CUADRE_ASIENTO PROCEDURE FOR USP_CNT_CUADRE_ASIENTO ( 
   :ll_ano, :ll_mes, :ls_origen ) ;
	
execute PB_USP_CNT_CUADRE_ASIENTO  ;

if sqlca.sqlcode = -1 Then
	rollback ;
	MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	MessageBox( 'Error', "Procedimiento <<USP_CNT_CUADRE_ASIENTO>> no concluyo correctamente", StopSign! )
else
	commit ;
	MessageBox( 'Mensaje', "Proceso terminado" )
End If
		
Close PB_USP_CNT_CUADRE_ASIENTO ;


cb_generar.enabled = true
sle_ano.enabled = true
sle_mes.enabled = true



end event

type st_4 from statictext within w_cn953_cuadre_asiento
integer x = 366
integer y = 580
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
string text = "Origen :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn953_cuadre_asiento
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

type st_2 from statictext within w_cn953_cuadre_asiento
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

type st_1 from statictext within w_cn953_cuadre_asiento
integer x = 155
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
string text = "Regenera cuadre de asientos"
alignment alignment = center!
boolean focusrectangle = false
end type

type r_1 from rectangle within w_cn953_cuadre_asiento
integer linethickness = 1
long fillcolor = 12632256
integer x = 274
integer y = 348
integer width = 827
integer height = 356
end type

