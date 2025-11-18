$PBExportHeader$w_abc_copia_control_lectura.srw
forward
global type w_abc_copia_control_lectura from w_abc
end type
type rb_no from radiobutton within w_abc_copia_control_lectura
end type
type rb_si from radiobutton within w_abc_copia_control_lectura
end type
type em_lectura_n from editmask within w_abc_copia_control_lectura
end type
type st_5 from statictext within w_abc_copia_control_lectura
end type
type em_control_hora_n from editmask within w_abc_copia_control_lectura
end type
type st_4 from statictext within w_abc_copia_control_lectura
end type
type st_1 from statictext within w_abc_copia_control_lectura
end type
type em_control_hora from editmask within w_abc_copia_control_lectura
end type
type st_3 from statictext within w_abc_copia_control_lectura
end type
type em_lectura from editmask within w_abc_copia_control_lectura
end type
type pb_exit from picturebutton within w_abc_copia_control_lectura
end type
type cb_actualizar from commandbutton within w_abc_copia_control_lectura
end type
type st_2 from statictext within w_abc_copia_control_lectura
end type
type gb_1 from groupbox within w_abc_copia_control_lectura
end type
type gb_2 from groupbox within w_abc_copia_control_lectura
end type
type gb_3 from groupbox within w_abc_copia_control_lectura
end type
type ln_1 from line within w_abc_copia_control_lectura
end type
end forward

global type w_abc_copia_control_lectura from w_abc
integer width = 1458
integer height = 1068
string title = "Copias de Datos de Control / Lectura"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
rb_no rb_no
rb_si rb_si
em_lectura_n em_lectura_n
st_5 st_5
em_control_hora_n em_control_hora_n
st_4 st_4
st_1 st_1
em_control_hora em_control_hora
st_3 st_3
em_lectura em_lectura
pb_exit pb_exit
cb_actualizar cb_actualizar
st_2 st_2
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
ln_1 ln_1
end type
global w_abc_copia_control_lectura w_abc_copia_control_lectura

type variables
str_parametros istr_rep
end variables

on w_abc_copia_control_lectura.create
int iCurrent
call super::create
this.rb_no=create rb_no
this.rb_si=create rb_si
this.em_lectura_n=create em_lectura_n
this.st_5=create st_5
this.em_control_hora_n=create em_control_hora_n
this.st_4=create st_4
this.st_1=create st_1
this.em_control_hora=create em_control_hora
this.st_3=create st_3
this.em_lectura=create em_lectura
this.pb_exit=create pb_exit
this.cb_actualizar=create cb_actualizar
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.ln_1=create ln_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_no
this.Control[iCurrent+2]=this.rb_si
this.Control[iCurrent+3]=this.em_lectura_n
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.em_control_hora_n
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.em_control_hora
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.em_lectura
this.Control[iCurrent+11]=this.pb_exit
this.Control[iCurrent+12]=this.cb_actualizar
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.gb_2
this.Control[iCurrent+16]=this.gb_3
this.Control[iCurrent+17]=this.ln_1
end on

on w_abc_copia_control_lectura.destroy
call super::destroy
destroy(this.rb_no)
destroy(this.rb_si)
destroy(this.em_lectura_n)
destroy(this.st_5)
destroy(this.em_control_hora_n)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.em_control_hora)
destroy(this.st_3)
destroy(this.em_lectura)
destroy(this.pb_exit)
destroy(this.cb_actualizar)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.ln_1)
end on

event ue_open_pre;//Override

istr_rep = message.powerobjectparm

em_control_hora.text = string(istr_rep.long2)
em_lectura.text 		= string(istr_rep.long3)
//--//
em_control_hora_n.text = string(istr_rep.long2)
em_lectura_n.text 	  = string(istr_rep.long3 + 1)


end event

event open;// Override
THIS.EVENT ue_open_pre()
end event

type rb_no from radiobutton within w_abc_copia_control_lectura
integer x = 1024
integer y = 276
integer width = 142
integer height = 116
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "No"
boolean checked = true
boolean lefttext = true
end type

type rb_si from radiobutton within w_abc_copia_control_lectura
integer x = 1024
integer y = 372
integer width = 142
integer height = 116
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Si"
boolean lefttext = true
end type

type em_lectura_n from editmask within w_abc_copia_control_lectura
integer x = 626
integer y = 784
integer width = 165
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "01"
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
double increment = 1
string minmax = "1~~"
end type

type st_5 from statictext within w_abc_copia_control_lectura
integer x = 247
integer y = 796
integer width = 343
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro. Lectura"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_control_hora_n from editmask within w_abc_copia_control_lectura
integer x = 626
integer y = 688
integer width = 165
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "01"
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
double increment = 1
string minmax = "1~~"
end type

type st_4 from statictext within w_abc_copia_control_lectura
integer x = 110
integer y = 692
integer width = 480
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro. Control / Hora:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_abc_copia_control_lectura
integer x = 110
integer y = 308
integer width = 480
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro. Control / Hora:"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_control_hora from editmask within w_abc_copia_control_lectura
integer x = 626
integer y = 304
integer width = 165
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "01"
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
double increment = 1
string minmax = "1~~"
end type

type st_3 from statictext within w_abc_copia_control_lectura
integer x = 242
integer y = 412
integer width = 343
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro. Lectura"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_lectura from editmask within w_abc_copia_control_lectura
integer x = 626
integer y = 400
integer width = 165
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "01"
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
double increment = 1
string minmax = "1~~"
end type

type pb_exit from picturebutton within w_abc_copia_control_lectura
integer x = 1097
integer y = 836
integer width = 137
integer height = 104
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Exit!"
alignment htextalign = left!
string powertiptext = "Salir"
end type

event clicked;Close(Parent)
end event

type cb_actualizar from commandbutton within w_abc_copia_control_lectura
integer x = 960
integer y = 700
integer width = 402
integer height = 104
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copiar"
end type

event clicked;String ls_flag_borrar, ls_msg

Integer   ll_nro_control,   ll_nro_lectura, &
		    ll_nro_control_n, ll_nro_lectura_n, ll_msg
		 
		 
//if MessageBox('Modulo de Producción','Esta seguro de realizar esta operacion',Question!,yesno!) = 2 then
//					return
//End if

if rb_no.checked  = true then 
	ls_flag_borrar = '0'
else
	ls_flag_borrar = '1'
end if

ll_nro_control   = Integer(em_control_hora.text)
ll_nro_lectura   = Integer(em_lectura.text)

ll_nro_control_n = Integer(em_control_hora_n.text)
ll_nro_lectura_n = Integer(em_lectura_n.text)

DECLARE USP_PROD_COPIA_CON_LEC PROCEDURE FOR 
		  USP_PROD_COPIA_CON_LEC(:istr_rep.string1,
		  								 :istr_rep.string2,
										 :istr_rep.long1,
										 :ll_nro_control,
										 :ll_nro_lectura,
										 :ll_nro_control_n,
										 :ll_nro_lectura_n,
										 :istr_rep.datetime1,
										 :ls_flag_borrar);
EXECUTE USP_PROD_COPIA_CON_LEC;
fetch USP_PROD_COPIA_CON_LEC into :ll_msg, :ls_msg;
CLOSE USP_PROD_COPIA_CON_LEC;

if ll_msg = 1 then
	messagebox('Modulo de Producción', ls_msg)
	return
end if

istr_rep.w1.dynamic function of_retrieve_det(istr_rep.string1, ll_nro_control_n, ll_nro_lectura_n)

//IF sqlca.sqlcode = -1 THEN
//		messagebox( "Modulo de Producción", sqlca.sqlerrtext)
//	else
//		messagebox( "Modulo de Producción", 'El proceso se ha realizado de manera satisfactoria')
//END IF






end event

type st_2 from statictext within w_abc_copia_control_lectura
integer x = 59
integer y = 52
integer width = 1326
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "COPIAR DATOS DE CONTROL / LECTURA"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_abc_copia_control_lectura
integer x = 59
integer y = 224
integer width = 859
integer height = 292
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Datos Base"
end type

type gb_2 from groupbox within w_abc_copia_control_lectura
integer x = 59
integer y = 608
integer width = 859
integer height = 292
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Datos Nuevos"
end type

type gb_3 from groupbox within w_abc_copia_control_lectura
integer x = 969
integer y = 224
integer width = 402
integer height = 292
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Borrar Datos"
end type

type ln_1 from line within w_abc_copia_control_lectura
integer linethickness = 16
integer beginx = 891
integer beginy = 572
integer endx = 78
integer endy = 572
end type

