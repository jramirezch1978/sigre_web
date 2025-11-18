$PBExportHeader$w_rh515_calculo_utilidades.srw
forward
global type w_rh515_calculo_utilidades from w_prc
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh515_calculo_utilidades
end type
type em_item from editmask within w_rh515_calculo_utilidades
end type
type st_4 from statictext within w_rh515_calculo_utilidades
end type
type st_2 from statictext within w_rh515_calculo_utilidades
end type
type em_ano from editmask within w_rh515_calculo_utilidades
end type
type cb_1 from commandbutton within w_rh515_calculo_utilidades
end type
type gb_2 from groupbox within w_rh515_calculo_utilidades
end type
end forward

global type w_rh515_calculo_utilidades from w_prc
integer width = 1984
integer height = 596
string title = "(RH515) Cálculo de Utilidades"
boolean resizable = false
boolean center = true
uo_1 uo_1
em_item em_item
st_4 st_4
st_2 st_2
em_ano em_ano
cb_1 cb_1
gb_2 gb_2
end type
global w_rh515_calculo_utilidades w_rh515_calculo_utilidades

on w_rh515_calculo_utilidades.create
int iCurrent
call super::create
this.uo_1=create uo_1
this.em_item=create em_item
this.st_4=create st_4
this.st_2=create st_2
this.em_ano=create em_ano
this.cb_1=create cb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.em_item
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.em_ano
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_rh515_calculo_utilidades.destroy
call super::destroy
destroy(this.uo_1)
destroy(this.em_item)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.em_ano)
destroy(this.cb_1)
destroy(this.gb_2)
end on

type uo_1 from u_ddlb_tipo_trabajador within w_rh515_calculo_utilidades
integer x = 1029
integer y = 20
integer taborder = 40
boolean bringtotop = true
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type em_item from editmask within w_rh515_calculo_utilidades
integer x = 741
integer y = 84
integer width = 123
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "#"
end type

type st_4 from statictext within w_rh515_calculo_utilidades
integer x = 32
integer y = 120
integer width = 357
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Corresponde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh515_calculo_utilidades
integer x = 32
integer y = 64
integer width = 357
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Periodo a que"
boolean focusrectangle = false
end type

type em_ano from editmask within w_rh515_calculo_utilidades
integer x = 457
integer y = 84
integer width = 270
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_1 from commandbutton within w_rh515_calculo_utilidades
integer x = 750
integer y = 268
integer width = 434
integer height = 176
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;integer li_periodo, li_item, li_count
string  ls_tipo_trabaj, ls_mensaje, ls_flag_externo, ls_genera

Parent.SetMicroHelp('Procesando Cálculo de Participación de Utilidades')

li_periodo = integer(em_ano.text)
li_item = integer(em_item.text)

SELECT count(*) 
  INTO :li_count 
  FROM utl_distribucion 
 WHERE periodo=:li_periodo and item=:li_item and flag_estado='1' ;

IF li_count = 0 THEN
	MessageBox('Aviso', 'No existe periodo de utilidad a procesar')
	Return 1
END IF

ls_tipo_trabaj = uo_1.of_get_value()


//create or replace procedure usp_rh_utl_calculo (
//       ani_periodo          in utl_distribucion.periodo%TYPE, 
//       ani_item             in utl_distribucion.item%TYPE,
//       asi_origen           in origen.cod_origen%TYPE,
//       asi_tipo_trabaj      in tipo_trabajador.tipo_trabajador%TYPE
//) is

// Procedimiento de calculo de utilidades
DECLARE usp_rh_utl_calculo PROCEDURE FOR 
	usp_rh_utl_calculo( :li_periodo, 
							  :li_item,
							  :ls_tipo_trabaj) ;
		  
EXECUTE usp_rh_utl_calculo ;


IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("SQL error usp_rh_utl_calculo", ls_mensaje)
  Parent.SetMicroHelp('Proceso no se llegó a realizar')
  return
end if

close usp_rh_utl_calculo;
MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)

end event

type gb_2 from groupbox within w_rh515_calculo_utilidades
integer width = 987
integer height = 220
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Período"
end type

