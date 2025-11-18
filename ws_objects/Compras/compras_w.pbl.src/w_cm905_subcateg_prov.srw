$PBExportHeader$w_cm905_subcateg_prov.srw
forward
global type w_cm905_subcateg_prov from w_abc
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm905_subcateg_prov
end type
type st_1 from statictext within w_cm905_subcateg_prov
end type
type pb_2 from picturebutton within w_cm905_subcateg_prov
end type
type pb_1 from picturebutton within w_cm905_subcateg_prov
end type
end forward

global type w_cm905_subcateg_prov from w_abc
integer width = 2007
integer height = 824
string title = "Actualiza PROVEEDOR_ARTICULO (CM905)"
string menuname = "m_salir"
boolean resizable = false
boolean center = true
event ue_aceptar ( )
event ue_salir ( )
uo_fecha uo_fecha
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_cm905_subcateg_prov w_cm905_subcateg_prov

event ue_aceptar();string	ls_mensaje
Date 		ld_desde, ld_hasta

ld_desde = uo_fecha.of_get_fecha1()
ld_hasta = uo_fecha.of_get_fecha2()

//create or replace procedure USP_CMP_SUBCATEG_PROV(
//       adi_fecha1   in date,
//       adi_fecha2   in date,
//       asi_usuario  in usuario.cod_usr%TYPE
//)is

DECLARE USP_CMP_SUBCATEG_PROV PROCEDURE FOR
	USP_CMP_SUBCATEG_PROV( :ld_desde, :ld_hasta, :gs_user );

EXECUTE USP_CMP_SUBCATEG_PROV;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_CMP_SUBCATEG_PROV: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_CMP_SUBCATEG_PROV;

MessageBox('Aviso', 'Proceso ha sido ejecutado satisfactoriamente')

end event

event ue_salir();close(this)
end event

on w_cm905_subcateg_prov.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.uo_fecha=create uo_fecha
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_1
end on

on w_cm905_subcateg_prov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar(this)
end event

type uo_fecha from u_ingreso_rango_fechas within w_cm905_subcateg_prov
integer x = 270
integer y = 300
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;string ls_desde
of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
ls_desde = '01/' + string(today(), 'mm/yyyy')
of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final
end event

type st_1 from statictext within w_cm905_subcateg_prov
integer x = 32
integer y = 4
integer width = 1920
integer height = 260
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Actualiza la Tabla PROVEEDOR_ARTICULO de acuerdo a las últimas 5 compras realizadas en el rango de fecha"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_cm905_subcateg_prov
integer x = 992
integer y = 448
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

event clicked;parent.event dynamic ue_salir()
end event

type pb_1 from picturebutton within w_cm905_subcateg_prov
integer x = 617
integer y = 448
integer width = 315
integer height = 180
integer taborder = 10
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

event clicked;parent.event dynamic ue_aceptar()
end event

