$PBExportHeader$w_pt909_ajuste_pto_fabrica.srw
forward
global type w_pt909_ajuste_pto_fabrica from w_abc
end type
type em_fecha from editmask within w_pt909_ajuste_pto_fabrica
end type
type st_6 from statictext within w_pt909_ajuste_pto_fabrica
end type
type st_1 from statictext within w_pt909_ajuste_pto_fabrica
end type
type pb_2 from picturebutton within w_pt909_ajuste_pto_fabrica
end type
type pb_1 from picturebutton within w_pt909_ajuste_pto_fabrica
end type
end forward

global type w_pt909_ajuste_pto_fabrica from w_abc
integer width = 1266
integer height = 816
string title = "Ajuste"
string menuname = "m_master"
boolean toolbarvisible = false
em_fecha em_fecha
st_6 st_6
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_pt909_ajuste_pto_fabrica w_pt909_ajuste_pto_fabrica

on w_pt909_ajuste_pto_fabrica.create
int iCurrent
call super::create
if this.MenuName = "m_master" then this.MenuID = create m_master
this.em_fecha=create em_fecha
this.st_6=create st_6
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_fecha
this.Control[iCurrent+2]=this.st_6
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_1
end on

on w_pt909_ajuste_pto_fabrica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_fecha)
destroy(this.st_6)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre();call super::ue_open_pre;f_centrar( this)

ii_pregunta_delete = 1
em_fecha.text = String(today(), 'dd/mm/yyyy')
end event

type em_fecha from editmask within w_pt909_ajuste_pto_fabrica
integer x = 402
integer y = 204
integer width = 366
integer height = 96
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_6 from statictext within w_pt909_ajuste_pto_fabrica
integer x = 192
integer y = 216
integer width = 174
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Al:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pt909_ajuste_pto_fabrica
integer x = 87
integer y = 16
integer width = 1065
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Ajuste de presupuesto fabrica"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pt909_ajuste_pto_fabrica
integer x = 640
integer y = 412
integer width = 315
integer height = 180
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(parent)
end event

type pb_1 from picturebutton within w_pt909_ajuste_pto_fabrica
integer x = 265
integer y = 412
integer width = 315
integer height = 180
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Long ll_ano
String ls_flag
Date ld_fecha1, ld_fecha2

if TRIM(em_fecha.text) = '' THEN  // ISNULL( em_fecha.text) OR 
	Messagebox( "Error", "Ingrese año", exclamation!)
	em_fecha.SetFocus()
	return
end if

// Valida que se ejecute a partir del dia 16
if LONG( mid( em_fecha.text,1,2) ) < 16 THEN
	Messagebox( "Error", "Fecha no permitida", exclamation!)	
	return
end if

ld_fecha1 = DATE( '01/' + RIGHT( em_fecha.text,7) )
ld_fecha2 = DATE( em_fecha.text)

SetPointer(Hourglass!)
DECLARE proc1 PROCEDURE FOR USP_PTO_AJUSTE_FABRICA(:ld_fecha1, :ld_fecha2, :gs_user);
EXECUTE Proc1;
if sqlca.sqlcode = -1 then   // Fallo
		Messagebox( "Error", sqlca.sqlerrtext, stopsign!)
		MessageBox( 'Error', "Procedimiento <<USP_PTO_AJUSTE_FABRICA>> no concluyo correctamente", StopSign! )
		rollback ;
		return 0
	else
		MessageBox( 'Mensaje', "Proceso terminado" )
		commit ;
	End If

close(parent)
end event

