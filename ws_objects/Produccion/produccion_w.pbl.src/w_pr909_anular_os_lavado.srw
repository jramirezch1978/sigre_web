$PBExportHeader$w_pr909_anular_os_lavado.srw
forward
global type w_pr909_anular_os_lavado from w_abc
end type
type sle_nro_os from singlelineedit within w_pr909_anular_os_lavado
end type
type cb_aceptar from picturebutton within w_pr909_anular_os_lavado
end type
type st_2 from statictext within w_pr909_anular_os_lavado
end type
type st_1 from statictext within w_pr909_anular_os_lavado
end type
end forward

global type w_pr909_anular_os_lavado from w_abc
integer width = 1193
integer height = 884
string title = "Anular Orden de Servicio(COM904)"
string menuname = "m_salir"
event ue_aceptar ( )
sle_nro_os sle_nro_os
cb_aceptar cb_aceptar
st_2 st_2
st_1 st_1
end type
global w_pr909_anular_os_lavado w_pr909_anular_os_lavado

event ue_aceptar();// Para Anular la Orden de Servicio

if MessageBox('Producción','Esta seguro de realizar esta operación',Question!,yesno!) = 2 then
					return
End if

string 	ls_nro_os, ls_mensaje


ls_nro_os 	= sle_nro_os.text


if IsNull(ls_nro_os) or ls_nro_os = '' then
	MessageBox('PRODUCCIÓN', 'NO HA INGRESO UN Nro. DE ORDEN DE SERVICIO VALIDO',StopSign!)
	return
end if

DECLARE 	USP_PROD_ANULA_OS_LAVADO PROCEDURE FOR
			USP_PROD_ANULA_OS_LAVADO( :ls_nro_os) ;
EXECUTE 	USP_PROD_ANULA_OS_LAVADO ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_ANULA_OS_LAVADO: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_PROD_ANULA_OS_LAVADO;

MessageBox('PRODUCCIÓN', 'LA ORDEN DE SERVICIO A SIDO ANULDA DE MANERA SATISFACTORIA', Information!)
return
end event

on w_pr909_anular_os_lavado.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.sle_nro_os=create sle_nro_os
this.cb_aceptar=create cb_aceptar
this.st_2=create st_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro_os
this.Control[iCurrent+2]=this.cb_aceptar
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
end on

on w_pr909_anular_os_lavado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nro_os)
destroy(this.cb_aceptar)
destroy(this.st_2)
destroy(this.st_1)
end on

type sle_nro_os from singlelineedit within w_pr909_anular_os_lavado
event dobleclick pbm_lbuttondblclk
integer x = 297
integer y = 324
integer width = 507
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT O.NRO_OS AS NRO_OS, " & 
		  +"O.DESCRIPCION AS DESCRIPCION " &
		  + "FROM ORDEN_SERVICIO O " &
		  + "WHERE O.flag_estado = '1' " &
		  + "AND O.COD_USR = '" + gs_user + "'" &
		  + "AND O.COD_ORIGEN = '" + gs_origen + "'"
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
end if


end event

type cb_aceptar from picturebutton within w_pr909_anular_os_lavado
integer x = 334
integer y = 504
integer width = 430
integer height = 120
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
string picturename = "H:\source\BMP\ACEPTARE.BMP"
alignment htextalign = right!
end type

event clicked;parent.event ue_aceptar()
end event

type st_2 from statictext within w_pr909_anular_os_lavado
integer x = 297
integer y = 192
integer width = 507
integer height = 124
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
string text = "Seleccione Nro. de OS:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pr909_anular_os_lavado
integer y = 28
integer width = 1120
integer height = 148
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Anular de Orden de Servicio de Lavado"
alignment alignment = center!
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

