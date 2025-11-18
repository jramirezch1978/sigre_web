$PBExportHeader$u_semana_fecha.sru
forward
global type u_semana_fecha from u_fecha
end type
type st_1 from statictext within u_semana_fecha
end type
type st_2 from statictext within u_semana_fecha
end type
type st_3 from statictext within u_semana_fecha
end type
type st_ano from statictext within u_semana_fecha
end type
type st_mes from statictext within u_semana_fecha
end type
type st_sem from statictext within u_semana_fecha
end type
end forward

global type u_semana_fecha from u_fecha
integer width = 1577
integer height = 96
st_1 st_1
st_2 st_2
st_3 st_3
st_ano st_ano
st_mes st_mes
st_sem st_sem
end type
global u_semana_fecha u_semana_fecha

type variables
integer ii_error
end variables

on u_semana_fecha.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_ano=create st_ano
this.st_mes=create st_mes
this.st_sem=create st_sem
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_ano
this.Control[iCurrent+5]=this.st_mes
this.Control[iCurrent+6]=this.st_sem
end on

on u_semana_fecha.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_ano)
destroy(this.st_mes)
destroy(this.st_sem)
end on

type cb_1 from u_fecha`cb_1 within u_semana_fecha
integer x = 9
integer y = 8
integer taborder = 10
end type

type em_1 from u_fecha`em_1 within u_semana_fecha
integer x = 283
integer y = 8
integer width = 306
integer taborder = 20
end type

event em_1::modified;call super::modified;integer li_ano, li_mes, li_semana
string ls_fecha

if ii_error = 1 then return

ls_fecha = trim(this.text)

declare busca_sem_fecha procedure for
	usp_tg_busca_semana_fecha(:ls_fecha);

execute busca_sem_fecha;

fetch busca_sem_fecha into :ls_fecha, :li_ano, :li_mes, :li_semana;

close busca_sem_fecha;

if isnull(li_semana) or li_semana < 0 then messagebox('Error', 'Sólo se han ingresado fechas hasta ' + trim(ls_fecha))

st_ano.text = string(li_ano)
st_mes.text = string(li_mes)
st_sem.text = string(li_semana)

end event

event ue_validacion;Integer li_rc = 1
ii_error = 0
IF ad_enter < id_inicio THEN
	MessageBox("Error", "Fecha por debajo del limite")
	li_rc = -1
	ii_error = 1
ELSE
	IF ad_enter > id_fin THEN
		MessageBox("Error", "Fecha sobre el limite")
		li_rc = -1
		ii_error = 1
	END IF
END IF


IF li_rc = -1 THEN
	IF ai_cal = 1 THEN
		cb_1.SetFocus()
	ELSE
		em_1.SetFocus()
	END IF
ELSE
	PARENT.EVENT ue_output()
END IF


end event

type st_1 from statictext within u_semana_fecha
integer x = 622
integer y = 20
integer width = 105
integer height = 56
boolean bringtotop = true
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

type st_2 from statictext within u_semana_fecha
integer x = 951
integer y = 20
integer width = 105
integer height = 56
boolean bringtotop = true
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

type st_3 from statictext within u_semana_fecha
integer x = 1239
integer y = 20
integer width = 187
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Semana"
boolean focusrectangle = false
end type

type st_ano from statictext within u_semana_fecha
integer x = 745
integer y = 8
integer width = 169
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_mes from statictext within u_semana_fecha
integer x = 1097
integer y = 8
integer width = 101
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_sem from statictext within u_semana_fecha
integer x = 1454
integer y = 8
integer width = 114
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

