$PBExportHeader$w_fl911_generar_variaciones.srw
forward
global type w_fl911_generar_variaciones from w_abc
end type
type mle_texto from multilineedit within w_fl911_generar_variaciones
end type
type pb_1 from picturebutton within w_fl911_generar_variaciones
end type
type pb_2 from picturebutton within w_fl911_generar_variaciones
end type
type st_1 from statictext within w_fl911_generar_variaciones
end type
type st_6 from statictext within w_fl911_generar_variaciones
end type
type em_ano from editmask within w_fl911_generar_variaciones
end type
end forward

global type w_fl911_generar_variaciones from w_abc
integer width = 1710
integer height = 1236
string title = "Generacion de Variaciones (FL911)"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
mle_texto mle_texto
pb_1 pb_1
pb_2 pb_2
st_1 st_1
st_6 st_6
em_ano em_ano
end type
global w_fl911_generar_variaciones w_fl911_generar_variaciones

type variables
integer ii_ano, ii_mes_ini, ii_mes_fin

end variables

forward prototypes
public function boolean of_genera_variacion ()
end prototypes

public function boolean of_genera_variacion ();integer 	li_ok
string	ls_mensaje

//create or replace procedure usp_fl_genera_variacion(
//       aii_mes_ini          in Integer,
//       aii_mes_fin          in Integer,
//       aii_ano              in Integer,
//       asi_usuario          in usuario.cod_usr%TYPE,
//       asi_origen           in logistica_procesos.cod_proceso%TYPE,
//     	aso_mensaje 	      out varchar2,
//       aio_ok      	      out number 
//) is

DECLARE usp_fl_genera_variacion PROCEDURE FOR
	usp_fl_genera_variacion( :ii_mes_ini,
									 :ii_mes_fin,
									 :ii_ano,
									 :gs_user, 
									 :gs_origen );

EXECUTE usp_fl_genera_variacion;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_genera_variacion: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

FETCH usp_fl_genera_variacion INTO :ls_mensaje, :li_ok;
	
CLOSE usp_fl_genera_variacion;

if li_ok <> 1 then
	MessageBox('Error PROCEDURE usp_fl_genera_presupuesto', ls_mensaje, StopSign!)	
	return false
end if

MessageBox('Aviso','Se han generado las variaciones para el año ' &
	+trim(string(ii_ano)) + ' satisfactoriamente', Exclamation! )

return true

end function

on w_fl911_generar_variaciones.create
int iCurrent
call super::create
this.mle_texto=create mle_texto
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
this.st_6=create st_6
this.em_ano=create em_ano
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_texto
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.em_ano
end on

on w_fl911_generar_variaciones.destroy
call super::destroy
destroy(this.mle_texto)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
destroy(this.st_6)
destroy(this.em_ano)
end on

event ue_open_pre;call super::ue_open_pre;str_gen_prspto lstr_param

IF IsValid(message.powerobjectparm) AND &
	ClassName(message.powerobjectparm) = 'str_gen_prspto' THEN
	
	lstr_param 	= message.powerobjectparm
	ii_ano 		= lstr_param.ai_ano
	ii_mes_ini	= lstr_param.ai_mes_ini
	ii_mes_fin	= lstr_param.ai_mes_fin
	
ELSE
	messagebox('Aviso','Parámetros mal pasados')
	Close(this)
	return
END IF

em_ano.text = string(year(Today()) + 1)

mle_texto.text = 'Proceso que tiene como finalidad generar las ' &
	+ 'varciones en las partidas presupuestales de Flota, tomando como ' &
	+ 'informacion las varciones de proyeccion de pesca del año y la ' &
	+ 'plantilla presupuestal por embarcación. ' &
	+ '~r~n~r~nUna vez generada esta informacion no podra ser ' &
	+ 'alterada' &
	+ '~r~n~r~nAño: ' + string(ii_ano) + ', Mes Inicial: ' + string(ii_mes_ini) &
	+ ', Mes Final: ' + string(ii_mes_fin)
end event

event ue_set_access;// Ancestor Script has been Override
end event

type mle_texto from multilineedit within w_fl911_generar_variaciones
integer x = 50
integer y = 128
integer width = 1563
integer height = 604
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

type pb_1 from picturebutton within w_fl911_generar_variaciones
integer x = 384
integer y = 904
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
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Long ll_ano

if ISNULL( em_ano.text) OR TRIM(em_ano.text) = '' THEN
	Messagebox( "Aviso", "Ingrese año", exclamation!)
	em_ano.SetFocus()
	return
end if

if parent.of_genera_variacion() = true then
	Close(parent)
end if
end event

type pb_2 from picturebutton within w_fl911_generar_variaciones
integer x = 759
integer y = 904
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
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(parent)
end event

type st_1 from statictext within w_fl911_generar_variaciones
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
string text = "Generación de Variaciones"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_fl911_generar_variaciones
integer x = 50
integer y = 780
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

type em_ano from editmask within w_fl911_generar_variaciones
integer x = 256
integer y = 764
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

