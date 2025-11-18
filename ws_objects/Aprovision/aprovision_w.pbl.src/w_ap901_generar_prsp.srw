$PBExportHeader$w_ap901_generar_prsp.srw
forward
global type w_ap901_generar_prsp from w_abc
end type
type cbx_1 from checkbox within w_ap901_generar_prsp
end type
type sle_origen from singlelineedit within w_ap901_generar_prsp
end type
type st_2 from statictext within w_ap901_generar_prsp
end type
type st_1 from statictext within w_ap901_generar_prsp
end type
type cb_1 from commandbutton within w_ap901_generar_prsp
end type
type em_ano from editmask within w_ap901_generar_prsp
end type
end forward

global type w_ap901_generar_prsp from w_abc
integer width = 1554
integer height = 460
string title = "Generar Presupuesto (AP901)"
string menuname = "m_salir"
boolean resizable = false
boolean center = true
cbx_1 cbx_1
sle_origen sle_origen
st_2 st_2
st_1 st_1
cb_1 cb_1
em_ano em_ano
end type
global w_ap901_generar_prsp w_ap901_generar_prsp

forward prototypes
public subroutine of_revierte_presupuesto ()
public subroutine of_genera_presupuesto ()
end prototypes

public subroutine of_revierte_presupuesto ();integer 	li_ano
string 	ls_origen, ls_mensaje

li_ano = integer(em_ano.text)
ls_origen = sle_origen.text

if ls_origen = '' then
	MessageBox('APROVISIONAMIENTO', 'ORIGEN INGRESADO INVALIDO, POR FAVOR VERIFIQUE', stopSign!)
	return
end if

if li_ano <= 0 then
	MessageBox('APROVISIONAMIENTO', 'AÑO INGRESADO INVALIDO, POR FAVOR VERIFIQUE', stopSign!)
	return
end if

//create or replace procedure usp_ap_revierte_presupuesto (
//       asi_origen   in origen.cod_origen%TYPE,
//       ani_year     in INTEGER
//) is

DECLARE usp_ap_revierte_presupuesto PROCEDURE FOR
	usp_ap_revierte_presupuesto( 	:ls_origen, 
						  					:li_ano);

EXECUTE usp_ap_revierte_presupuesto;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_ap_revierte_presupuesto: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE usp_ap_revierte_presupuesto;

MessageBox('APROVISIONAMIENTO', 'PROCESO REALIZADO DE MANERA SATISFACTORIA', Exclamation!)

end subroutine

public subroutine of_genera_presupuesto ();integer 	li_ano
string 	ls_origen, ls_mensaje

li_ano = integer(em_ano.text)
ls_origen = sle_origen.text

if ls_origen = '' then
	MessageBox('APROVISIONAMIENTO', 'ORIGEN INGRESADO INVALIDO, POR FAVOR VERIFIQUE', stopSign!)
	return
end if

if li_ano <= 0 then
	MessageBox('APROVISIONAMIENTO', 'AÑO INGRESADO INVALIDO, POR FAVOR VERIFIQUE', stopSign!)
	return
end if

//create or replace procedure usp_ap_genera_presupuesto(
//       asi_origen   in origen.cod_origen%TYPE,
//       ani_year     in integer,
//       asi_user     in usuario.cod_usr%TYPE
//) is

DECLARE usp_ap_genera_presupuesto PROCEDURE FOR
	usp_ap_genera_presupuesto( :ls_origen, 
						  				:li_ano,
										:gs_user);

EXECUTE usp_ap_genera_presupuesto;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_ap_genera_presupuesto: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE usp_ap_genera_presupuesto;

MessageBox('APROVISIONAMIENTO', 'PROCESO REALIZADO DE MANERA SATISFACTORIA', Exclamation!)

end subroutine

on w_ap901_generar_prsp.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.cbx_1=create cbx_1
this.sle_origen=create sle_origen
this.st_2=create st_2
this.st_1=create st_1
this.cb_1=create cb_1
this.em_ano=create em_ano
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.em_ano
end on

on w_ap901_generar_prsp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.sle_origen)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.em_ano)
end on

event ue_open_pre;call super::ue_open_pre;em_ano.text = string(Today(), 'yyyy')
sle_origen.text = gs_origen
end event

type cbx_1 from checkbox within w_ap901_generar_prsp
integer x = 727
integer y = 28
integer width = 622
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Revertir presupuesto"
end type

type sle_origen from singlelineedit within w_ap901_generar_prsp
integer x = 238
integer y = 152
integer width = 283
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_ap901_generar_prsp
integer x = 9
integer y = 152
integer width = 201
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_ap901_generar_prsp
integer y = 44
integer width = 201
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ap901_generar_prsp
integer x = 786
integer y = 148
integer width = 594
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar Presupuesto"
end type

event clicked;if cbx_1.checked then
	parent.of_revierte_presupuesto( )
else
	parent.of_genera_presupuesto( )
end if
end event

type em_ano from editmask within w_ap901_generar_prsp
integer x = 238
integer y = 32
integer width = 283
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
end type

