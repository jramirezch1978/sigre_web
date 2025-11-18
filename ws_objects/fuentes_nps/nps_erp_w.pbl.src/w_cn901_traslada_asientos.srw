$PBExportHeader$w_cn901_traslada_asientos.srw
forward
global type w_cn901_traslada_asientos from w_prc
end type
type st_7 from statictext within w_cn901_traslada_asientos
end type
type sle_origen from singlelineedit within w_cn901_traslada_asientos
end type
type st_4 from statictext within w_cn901_traslada_asientos
end type
type sle_libro from singlelineedit within w_cn901_traslada_asientos
end type
type st_5 from statictext within w_cn901_traslada_asientos
end type
type sle_mes from singlelineedit within w_cn901_traslada_asientos
end type
type sle_ano from singlelineedit within w_cn901_traslada_asientos
end type
type cb_cancelar from commandbutton within w_cn901_traslada_asientos
end type
type cb_generar from commandbutton within w_cn901_traslada_asientos
end type
type st_3 from statictext within w_cn901_traslada_asientos
end type
type st_2 from statictext within w_cn901_traslada_asientos
end type
type st_1 from statictext within w_cn901_traslada_asientos
end type
type gb_1 from groupbox within w_cn901_traslada_asientos
end type
end forward

global type w_cn901_traslada_asientos from w_prc
integer width = 1856
integer height = 1528
string title = "[CN901] Importacion de pre asientos como asientos contables"
string menuname = "m_proceso"
st_7 st_7
sle_origen sle_origen
st_4 st_4
sle_libro sle_libro
st_5 st_5
sle_mes sle_mes
sle_ano sle_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_3 st_3
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_cn901_traslada_asientos w_cn901_traslada_asientos

on w_cn901_traslada_asientos.create
int iCurrent
call super::create
if this.MenuName = "m_proceso" then this.MenuID = create m_proceso
this.st_7=create st_7
this.sle_origen=create sle_origen
this.st_4=create st_4
this.sle_libro=create sle_libro
this.st_5=create st_5
this.sle_mes=create sle_mes
this.sle_ano=create sle_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_7
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.sle_libro
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.sle_mes
this.Control[iCurrent+7]=this.sle_ano
this.Control[iCurrent+8]=this.cb_cancelar
this.Control[iCurrent+9]=this.cb_generar
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.gb_1
end on

on w_cn901_traslada_asientos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_7)
destroy(this.sle_origen)
destroy(this.st_4)
destroy(this.sle_libro)
destroy(this.st_5)
destroy(this.sle_mes)
destroy(this.sle_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

String ls_ano, ls_mes
ls_ano = string( year( today() ) )
ls_mes = string( month( today() ) -1 )
					
sle_ano.text = ls_ano
sle_mes.text = ls_mes
sle_origen.text = gnvo_app.is_origen
end event

type ole_skin from w_prc`ole_skin within w_cn901_traslada_asientos
end type

type st_7 from statictext within w_cn901_traslada_asientos
integer x = 677
integer y = 848
integer width = 187
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Origen"
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_cn901_traslada_asientos
integer x = 928
integer y = 848
integer width = 187
integer height = 64
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_cn901_traslada_asientos
integer x = 677
integer y = 756
integer width = 187
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Libro"
boolean focusrectangle = false
end type

type sle_libro from singlelineedit within w_cn901_traslada_asientos
integer x = 928
integer y = 756
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

type st_5 from statictext within w_cn901_traslada_asientos
integer x = 293
integer y = 236
integer width = 1211
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 12632256
string text = "COMO ASIENTOS CONTABLES"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cn901_traslada_asientos
integer x = 928
integer y = 664
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

type sle_ano from singlelineedit within w_cn901_traslada_asientos
integer x = 928
integer y = 572
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

type cb_cancelar from commandbutton within w_cn901_traslada_asientos
integer x = 960
integer y = 1112
integer width = 320
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;CLOSE (PARENT)
end event

type cb_generar from commandbutton within w_cn901_traslada_asientos
integer x = 535
integer y = 1108
integer width = 320
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;String ls_ano, ls_mes, ls_libro, ls_origen, ls_usuario, ls_mensaje
Long ll_count

cb_generar.enabled  = false
cb_cancelar.enabled = false
sle_ano.enabled     = false
sle_mes.enabled     = false
sle_libro.enabled	  = false

ls_ano = sle_ano.text
ls_mes = sle_mes.text
ls_libro = sle_libro.text
ls_origen = sle_origen.text
ls_usuario = gnvo_app.is_user

// Verifica si existe libro contable
SELECT count(*) INTO :ll_count
FROM cntbl_libro
WHERE nro_libro = to_number(:ls_libro,'99') ;

IF ll_count > 0 THEN

	DECLARE PB_USP_CNTBL_TRASLADO_ASIENTOS PROCEDURE FOR USP_CNTBL_TRASLADO_ASIENTOS
        ( :ls_ano, :ls_mes, :ls_libro, :ls_origen, :ls_usuario ) ;
	EXECUTE PB_USP_CNTBL_TRASLADO_ASIENTOS ;

	if SQLCA.SQLCode = -1 then
	  ls_mensaje = sqlca.sqlerrtext
	  rollback ;
	  MessageBox("SQL error", ls_mensaje, StopSign!)
	  MessageBox('Atención','No se realizó traslado de los Pre - Asientos', Exclamation! )
	else
	  commit ;
	  MessageBox ('Atención', "Proceso Ha Concluído Satisfactoriamente")
	end if
	
	CLOSE PB_USP_CNTBL_TRASLADO_ASIENTOS ;
ELSE
	MessageBox('Aviso', "Libro contable no existe")
END IF

cb_generar.enabled  = true
cb_cancelar.enabled = true
sle_ano.enabled     = true
sle_mes.enabled     = true
sle_libro.enabled	  = true
end event

type st_3 from statictext within w_cn901_traslada_asientos
integer x = 677
integer y = 664
integer width = 187
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn901_traslada_asientos
integer x = 677
integer y = 572
integer width = 187
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn901_traslada_asientos
integer x = 105
integer y = 92
integer width = 1586
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "IMPORTACION DE PRE ASIENTOS CONTABLES"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn901_traslada_asientos
integer x = 544
integer y = 444
integer width = 745
integer height = 552
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Periodo Contable "
borderstyle borderstyle = styleraised!
end type

