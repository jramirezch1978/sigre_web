$PBExportHeader$w_af901_calculo_revaluacion.srw
forward
global type w_af901_calculo_revaluacion from w_prc
end type
type st_2 from statictext within w_af901_calculo_revaluacion
end type
type st_1 from statictext within w_af901_calculo_revaluacion
end type
type em_mes from editmask within w_af901_calculo_revaluacion
end type
type em_ano from editmask within w_af901_calculo_revaluacion
end type
type cb_1 from commandbutton within w_af901_calculo_revaluacion
end type
type gb_1 from groupbox within w_af901_calculo_revaluacion
end type
end forward

global type w_af901_calculo_revaluacion from w_prc
integer width = 1650
integer height = 732
string title = "(AF401) Cálculo de Revaluaciones"
st_2 st_2
st_1 st_1
em_mes em_mes
em_ano em_ano
cb_1 cb_1
gb_1 gb_1
end type
global w_af901_calculo_revaluacion w_af901_calculo_revaluacion

on w_af901_calculo_revaluacion.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
this.em_mes=create em_mes
this.em_ano=create em_ano
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_mes
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.gb_1
end on

on w_af901_calculo_revaluacion.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_mes)
destroy(this.em_ano)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event open;call super::open;
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

type st_2 from statictext within w_af901_calculo_revaluacion
integer x = 859
integer y = 212
integer width = 151
integer height = 56
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
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_af901_calculo_revaluacion
integer x = 352
integer y = 212
integer width = 151
integer height = 56
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
alignment alignment = center!
boolean focusrectangle = false
end type

type em_mes from editmask within w_af901_calculo_revaluacion
integer x = 1033
integer y = 204
integer width = 187
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_ano from editmask within w_af901_calculo_revaluacion
integer x = 535
integer y = 204
integer width = 283
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_1 from commandbutton within w_af901_calculo_revaluacion
integer x = 654
integer y = 416
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

event clicked;string  ls_mensaje
integer li_ano, li_mes

Parent.SetMicroHelp('Procesando Cálculo de Revaluaciones de Activos')

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

DECLARE pb_usp_afi_calculo_revaluacion PROCEDURE FOR USP_AFI_CALCULO_REVALUACION
        ( :li_ano, :li_mes, :gs_user ) ;
EXECUTE pb_usp_afi_calculo_revaluacion ;

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("SQL error", ls_mensaje)
  MessageBox('Atención','Cálculo de revaluación de activos falló', Exclamation! )
  Parent.SetMicroHelp('Proceso no se llegó a realizar')
ELSE
  commit ;
  MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
END IF

end event

type gb_1 from groupbox within w_af901_calculo_revaluacion
integer x = 306
integer y = 124
integer width = 987
integer height = 220
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Fecha de Inicio de Depreciación"
end type

