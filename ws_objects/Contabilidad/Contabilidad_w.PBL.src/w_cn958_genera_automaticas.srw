$PBExportHeader$w_cn958_genera_automaticas.srw
forward
global type w_cn958_genera_automaticas from w_prc
end type
type cbx_1 from checkbox within w_cn958_genera_automaticas
end type
type st_5 from statictext within w_cn958_genera_automaticas
end type
type sle_mes from singlelineedit within w_cn958_genera_automaticas
end type
type sle_ano from singlelineedit within w_cn958_genera_automaticas
end type
type cb_cancelar from commandbutton within w_cn958_genera_automaticas
end type
type cb_generar from commandbutton within w_cn958_genera_automaticas
end type
type st_2 from statictext within w_cn958_genera_automaticas
end type
type st_1 from statictext within w_cn958_genera_automaticas
end type
type gb_1 from groupbox within w_cn958_genera_automaticas
end type
end forward

global type w_cn958_genera_automaticas from w_prc
integer width = 1957
integer height = 1008
string title = "[CN958] Genera Asientos de Cuentas Contables Automaticas"
string menuname = "m_prc"
boolean resizable = false
boolean center = true
cbx_1 cbx_1
st_5 st_5
sle_mes sle_mes
sle_ano sle_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_cn958_genera_automaticas w_cn958_genera_automaticas

on w_cn958_genera_automaticas.create
int iCurrent
call super::create
if this.MenuName = "m_prc" then this.MenuID = create m_prc
this.cbx_1=create cbx_1
this.st_5=create st_5
this.sle_mes=create sle_mes
this.sle_ano=create sle_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.cb_cancelar
this.Control[iCurrent+6]=this.cb_generar
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_cn958_genera_automaticas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.st_5)
destroy(this.sle_mes)
destroy(this.sle_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;

String ls_ano, ls_mes
ls_ano = string( gnvo_app.of_fecha_Actual(), 'yyyy' )
ls_mes = string( gnvo_app.of_fecha_Actual(), 'mm')
					
sle_ano.text = ls_ano
sle_mes.text = ls_mes

end event

type cbx_1 from checkbox within w_cn958_genera_automaticas
integer x = 398
integer y = 544
integer width = 471
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Indicar el Mes :"
end type

event clicked;if this.checked then
	sle_mes.enabled = true
else
	sle_mes.enabled = false
end if
end event

type st_5 from statictext within w_cn958_genera_automaticas
integer x = 306
integer y = 220
integer width = 1312
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 12632256
string text = "CONTABLES AUTOMATICAS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cn958_genera_automaticas
integer x = 901
integer y = 544
integer width = 283
integer height = 84
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_ano from singlelineedit within w_cn958_genera_automaticas
integer x = 901
integer y = 448
integer width = 283
integer height = 84
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_cn958_genera_automaticas
integer x = 1065
integer y = 700
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

type cb_generar from commandbutton within w_cn958_genera_automaticas
integer x = 544
integer y = 696
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

event clicked;String 	ls_usuario, ls_msj
Long 		ll_year, ll_mes
dateTime	ldt_inicio, ldt_fin
Decimal	ldc_dias


cb_generar.enabled  	= false
cb_cancelar.enabled 	= false
sle_ano.enabled     	= false
sle_mes.enabled     	= false
cbx_1.enabled 			= false

ll_year = Long(sle_ano.text)

if cbx_1.checked then
	ll_mes = Long(sle_mes.text)
else
	ll_mes = -1
end if

//FEcha y hora de inicio
ldt_inicio = gnvo_app.of_fecha_actual( )

DECLARE USP_CNT_GENERA_AUTOMATICAS PROCEDURE FOR 
	USP_CNT_GENERA_AUTOMATICAS( :ll_year, 
										 :ll_mes ) ;
EXECUTE USP_CNT_GENERA_AUTOMATICAS ;

IF sqlca.sqlcode = -1 THEN
	ls_msj = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox ('Error',"Store Procedure USP_CNT_GENERA_AUTOMATICAS Falló, Error: " + ls_msj, StopSign!)
	return 
end if

COMMIT ;

CLOSE USP_CNT_GENERA_AUTOMATICAS ;

//Fecha y hora de Fin
ldt_fin = gnvo_app.of_fecha_actual()

select :ldt_fin - :ldt_inicio
	into :ldc_dias
from dual;

MessageBox ('Atención', "Proceso ha sido ejecutado satisfactoriamente en " + string(round(ldc_dias * 24 * 60,2)) + " minutos")


cb_generar.enabled  = true
cb_cancelar.enabled = true
sle_ano.enabled     = true
cbx_1.enabled		  = true

if cbx_1.checked then
	sle_mes.enabled = true
else
	sle_mes.enabled = false
end if
end event

type st_2 from statictext within w_cn958_genera_automaticas
integer x = 398
integer y = 448
integer width = 471
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn958_genera_automaticas
integer x = 306
integer y = 80
integer width = 1317
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "GENERACION DE CUENTAS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn958_genera_automaticas
integer x = 315
integer y = 364
integer width = 1312
integer height = 308
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
borderstyle borderstyle = styleraised!
end type

