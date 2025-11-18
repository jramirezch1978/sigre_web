$PBExportHeader$w_fl909_generar_presupuesto.srw
forward
global type w_fl909_generar_presupuesto from w_abc
end type
type mle_texto from multilineedit within w_fl909_generar_presupuesto
end type
type pb_1 from picturebutton within w_fl909_generar_presupuesto
end type
type pb_2 from picturebutton within w_fl909_generar_presupuesto
end type
type st_1 from statictext within w_fl909_generar_presupuesto
end type
type st_6 from statictext within w_fl909_generar_presupuesto
end type
type em_ano from editmask within w_fl909_generar_presupuesto
end type
type cbx_rev from checkbox within w_fl909_generar_presupuesto
end type
end forward

global type w_fl909_generar_presupuesto from w_abc
integer width = 1737
integer height = 1272
string title = "Generación de Presupuesto de Flota (FL909)"
string menuname = "m_only_exit"
boolean maxbox = false
boolean resizable = false
mle_texto mle_texto
pb_1 pb_1
pb_2 pb_2
st_1 st_1
st_6 st_6
em_ano em_ano
cbx_rev cbx_rev
end type
global w_fl909_generar_presupuesto w_fl909_generar_presupuesto

forward prototypes
public function boolean of_revierte_presupuesto ()
public function boolean of_genera_presupuesto ()
end prototypes

public function boolean of_revierte_presupuesto ();integer 	li_ano, li_ok
string	ls_mensaje, ls_proceso

li_ano = integer(trim(em_ano.text))

if li_ano = 0 then
	MessageBox('Aviso', 'Año ingreso esta incorrecto, por favor verifique', StopSign!)
	return false
end if

ls_proceso = gs_origen + '010'  //Proceso de generacion de presupuesto

//create or replace procedure usp_fl_revierte_presupuesto (
//       aii_ano      in  number,
//       asi_proceso  in  logistica_procesos.cod_proceso%TYPE
//) is

DECLARE usp_fl_revierte_presupuesto PROCEDURE FOR
	usp_fl_revierte_presupuesto( :li_ano, 
										  :ls_proceso );

EXECUTE usp_fl_revierte_presupuesto;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_revierte_presupuesto: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

CLOSE usp_fl_revierte_presupuesto;

MessageBox('Aviso','Se ha revertido el presupuesto de FLOTA para el año ' &
	+trim(string(li_ano)) + ' satisfactoriamente', Exclamation! )

return true

end function

public function boolean of_genera_presupuesto ();integer 	li_ano, li_ok
string	ls_mensaje, ls_proceso

li_ano = integer(trim(em_ano.text))

if li_ano = 0 then
	MessageBox('Aviso', 'Año ingreso esta incorrecto, por favor verifique', StopSign!)
	return false
end if

ls_proceso = gs_origen + '010'  //Proceso de generacion de presupuesto

//create or replace procedure usp_fl_genera_presupuesto (
//       aii_ano      in  number,
//       asi_cod_usr  in  usuario.cod_usr%TYPE,
//       asi_proceso  in  logistica_procesos.cod_proceso%TYPE,
//       asi_origen   IN  origen.cod_origen%TYPE
//) is

DECLARE usp_fl_genera_presupuesto PROCEDURE FOR
	usp_fl_genera_presupuesto( :li_ano, 
										:gs_user, 
										:ls_proceso,
										:gs_origen);

EXECUTE usp_fl_genera_presupuesto;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_genera_presupuesto: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

CLOSE usp_fl_genera_presupuesto;

MessageBox('Aviso','Se ha generado el presupuesto de Flota para el año ' &
	+trim(string(li_ano)) + ' satisfactoriamente', Exclamation! )

return true

end function

on w_fl909_generar_presupuesto.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.mle_texto=create mle_texto
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
this.st_6=create st_6
this.em_ano=create em_ano
this.cbx_rev=create cbx_rev
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_texto
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.em_ano
this.Control[iCurrent+7]=this.cbx_rev
end on

on w_fl909_generar_presupuesto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mle_texto)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
destroy(this.st_6)
destroy(this.em_ano)
destroy(this.cbx_rev)
end on

event ue_open_pre;call super::ue_open_pre;em_ano.text = string(year(Today()))

mle_texto.text = 'Proceso que tiene como finalidad generar las ' &
	+ 'partidas para el presupuesto de Flota, tomando como ' &
	+ 'informacion la proyeccion de pesca del año y la ' &
	+ 'plantilla presupuestal por embarcación. ' &
	+ '~r~n~r~nUna vez generada esta informacion no podra ser ' &
	+ 'alterada'
end event

type mle_texto from multilineedit within w_fl909_generar_presupuesto
integer x = 50
integer y = 128
integer width = 1563
integer height = 504
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
boolean border = false
end type

type pb_1 from picturebutton within w_fl909_generar_presupuesto
integer x = 384
integer y = 852
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Long ll_ano

if ISNULL( em_ano.text) OR TRIM(em_ano.text) = '' THEN
	Messagebox( "Aviso", "Ingrese año", exclamation!)
	em_ano.SetFocus()
	return
end if

if cbx_rev.checked = true then
	parent.of_revierte_presupuesto()
else
	parent.of_genera_presupuesto()
end if
end event

type pb_2 from picturebutton within w_fl909_generar_presupuesto
integer x = 759
integer y = 852
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(parent)
end event

type st_1 from statictext within w_fl909_generar_presupuesto
integer x = 69
integer y = 16
integer width = 1390
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
string text = "Generación de Presupuesto"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_fl909_generar_presupuesto
integer x = 50
integer y = 680
integer width = 183
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type em_ano from editmask within w_fl909_generar_presupuesto
integer x = 256
integer y = 660
integer width = 315
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
string mask = "####"
end type

type cbx_rev from checkbox within w_fl909_generar_presupuesto
integer x = 1079
integer y = 668
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Revertir "
end type

