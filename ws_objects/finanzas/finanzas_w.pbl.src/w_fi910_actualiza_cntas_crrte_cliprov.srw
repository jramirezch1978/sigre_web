$PBExportHeader$w_fi910_actualiza_cntas_crrte_cliprov.srw
forward
global type w_fi910_actualiza_cntas_crrte_cliprov from w_prc
end type
type sle_year from singlelineedit within w_fi910_actualiza_cntas_crrte_cliprov
end type
type st_1 from statictext within w_fi910_actualiza_cntas_crrte_cliprov
end type
type rb_proveedores from radiobutton within w_fi910_actualiza_cntas_crrte_cliprov
end type
type rb_clientes from radiobutton within w_fi910_actualiza_cntas_crrte_cliprov
end type
type pb_1 from picturebutton within w_fi910_actualiza_cntas_crrte_cliprov
end type
type gb_2 from groupbox within w_fi910_actualiza_cntas_crrte_cliprov
end type
end forward

global type w_fi910_actualiza_cntas_crrte_cliprov from w_prc
integer width = 1550
integer height = 648
string title = "[FI910] Actualizacion Cuenta Corriente"
string menuname = "m_proceso_salida"
boolean maxbox = false
boolean resizable = false
boolean center = true
sle_year sle_year
st_1 st_1
rb_proveedores rb_proveedores
rb_clientes rb_clientes
pb_1 pb_1
gb_2 gb_2
end type
global w_fi910_actualiza_cntas_crrte_cliprov w_fi910_actualiza_cntas_crrte_cliprov

on w_fi910_actualiza_cntas_crrte_cliprov.create
int iCurrent
call super::create
if this.MenuName = "m_proceso_salida" then this.MenuID = create m_proceso_salida
this.sle_year=create sle_year
this.st_1=create st_1
this.rb_proveedores=create rb_proveedores
this.rb_clientes=create rb_clientes
this.pb_1=create pb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_year
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.rb_proveedores
this.Control[iCurrent+4]=this.rb_clientes
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_fi910_actualiza_cntas_crrte_cliprov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_year)
destroy(this.st_1)
destroy(this.rb_proveedores)
destroy(this.rb_clientes)
destroy(this.pb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;sle_year.text = String(gnvo_app.of_fecha_actual( ), 'yyyy')
end event

type sle_year from singlelineedit within w_fi910_actualiza_cntas_crrte_cliprov
integer x = 247
integer y = 96
integer width = 325
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_fi910_actualiza_cntas_crrte_cliprov
integer x = 73
integer y = 112
integer width = 160
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Año :"
boolean focusrectangle = false
end type

type rb_proveedores from radiobutton within w_fi910_actualiza_cntas_crrte_cliprov
integer x = 41
integer y = 324
integer width = 443
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Proveedores"
boolean checked = true
end type

type rb_clientes from radiobutton within w_fi910_actualiza_cntas_crrte_cliprov
integer x = 37
integer y = 228
integer width = 443
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Clientes "
end type

type pb_1 from picturebutton within w_fi910_actualiza_cntas_crrte_cliprov
integer x = 1106
integer y = 60
integer width = 361
integer height = 208
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "C:\SIGRE\resources\Gif\icono_siga1.gif"
alignment htextalign = left!
boolean map3dcolors = true
end type

event clicked;Long   ll_ano


//Actualiza Cuenta Corriente de Clientes
ll_ano = Long(sle_year.text)

if Isnull(ll_ano) or ll_ano = 0 then
	Messagebox('Aviso','Debe Ingresar el Año para Empezar Verificación de Asientos')
	Return
end if


if rb_clientes.checked then
	if gnvo_app.finparam.of_actualiza_saldo_cc() then
		MessageBox('Aviso', 'Proceso de actualización de cuenta corriente de clientes realizado correctamente', Information!)
	end if
	
elseif rb_proveedores.checked	then
	if gnvo_app.finparam.of_actualiza_saldo_cp() then
		MessageBox('Aviso', 'Proceso de actualización de cuenta corriente de Proveedores realizado correctamente', Information!)
	end if
end if	



///



end event

type gb_2 from groupbox within w_fi910_actualiza_cntas_crrte_cliprov
integer width = 1527
integer height = 468
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Actualiza Cuenta Corriente"
end type

