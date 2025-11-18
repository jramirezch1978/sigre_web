$PBExportHeader$w_gen_genera_turnos.srw
forward
global type w_gen_genera_turnos from w_prc
end type
type st_1 from statictext within w_gen_genera_turnos
end type
type cb_1 from commandbutton within w_gen_genera_turnos
end type
type st_3 from statictext within w_gen_genera_turnos
end type
type st_4 from statictext within w_gen_genera_turnos
end type
type st_5 from statictext within w_gen_genera_turnos
end type
type ano from singlelineedit within w_gen_genera_turnos
end type
type sem_desde from singlelineedit within w_gen_genera_turnos
end type
type sem_hasta from singlelineedit within w_gen_genera_turnos
end type
type gb_3 from groupbox within w_gen_genera_turnos
end type
end forward

global type w_gen_genera_turnos from w_prc
integer width = 2313
integer height = 832
string title = "Solo Para Personal de Turno Rotativo"
st_1 st_1
cb_1 cb_1
st_3 st_3
st_4 st_4
st_5 st_5
ano ano
sem_desde sem_desde
sem_hasta sem_hasta
gb_3 gb_3
end type
global w_gen_genera_turnos w_gen_genera_turnos

on w_gen_genera_turnos.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.ano=create ano
this.sem_desde=create sem_desde
this.sem_hasta=create sem_hasta
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.ano
this.Control[iCurrent+7]=this.sem_desde
this.Control[iCurrent+8]=this.sem_hasta
this.Control[iCurrent+9]=this.gb_3
end on

on w_gen_genera_turnos.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.ano)
destroy(this.sem_desde)
destroy(this.sem_hasta)
destroy(this.gb_3)
end on

event open;call super::open;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - w_gen_genera_turnos.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - w_gen_genera_turnos.WorkSpaceHeight()) / 2) - 150
w_gen_genera_turnos.move(ll_x,ll_y)

end event

type st_1 from statictext within w_gen_genera_turnos
integer x = 91
integer y = 96
integer width = 2098
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "GENERACION DE TURNOS PARA PERSONAL DE GUARDIAS"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_gen_genera_turnos
integer x = 987
integer y = 540
integer width = 306
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;string ls_usuario
double ln_ano, ln_semana_d, ln_semana_h

ls_usuario  = gs_user
ln_ano      = double(ano.text)
ln_semana_d = double(sem_desde.text)
ln_semana_h = double(sem_hasta.text)

if ln_semana_d > ln_semana_h then
	MessageBox("Atención","Semana Desde no es Válido")
	return
end if
if ln_semana_h > 53 then
	MessageBox("Atención","Un Año No Tiene Mas de 53 Semanas")
	return
end if

DECLARE pb_usp_asi_genera_turnos PROCEDURE FOR USP_ASI_GENERA_TURNOS
        (:ls_usuario, :ln_ano, :ln_semana_d, :ln_semana_h) ;
EXECUTE pb_usp_asi_genera_turnos ;

IF SQLCA.SQLCode = -1 THEN 
  rollback ;
  MessageBox("SQL error", SQLCA.SQLErrText)
  MessageBox('Atención','No se pudo generar los turno del persona rotativo', Exclamation! )
ELSE
  commit ;
  MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
END IF


end event

type st_3 from statictext within w_gen_genera_turnos
integer x = 375
integer y = 316
integer width = 242
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_4 from statictext within w_gen_genera_turnos
integer x = 896
integer y = 316
integer width = 279
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desde"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_5 from statictext within w_gen_genera_turnos
integer x = 1417
integer y = 316
integer width = 279
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hasta"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type ano from singlelineedit within w_gen_genera_turnos
integer x = 667
integer y = 316
integer width = 178
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sem_desde from singlelineedit within w_gen_genera_turnos
integer x = 1216
integer y = 316
integer width = 151
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sem_hasta from singlelineedit within w_gen_genera_turnos
integer x = 1742
integer y = 316
integer width = 151
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_gen_genera_turnos
integer x = 315
integer y = 256
integer width = 1664
integer height = 204
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 79741120
string text = " Rango de Semanas "
end type

