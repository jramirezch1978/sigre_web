$PBExportHeader$w_pr911_actualiza_cebe_vales.srw
forward
global type w_pr911_actualiza_cebe_vales from w_abc
end type
type cb_aceptar from picturebutton within w_pr911_actualiza_cebe_vales
end type
type st_1 from statictext within w_pr911_actualiza_cebe_vales
end type
end forward

global type w_pr911_actualiza_cebe_vales from w_abc
integer width = 1737
integer height = 956
string title = "Actualiza CeBe del Movimiento del Almacén, según Referencia(PR911)"
string menuname = "m_impresion_1"
event ue_generar_os ( )
cb_aceptar cb_aceptar
st_1 st_1
end type
global w_pr911_actualiza_cebe_vales w_pr911_actualiza_cebe_vales

type variables

end variables

event ue_generar_os();
SetPointer (HourGlass!)
string ls_mensaje, ls_null

if MessageBox('Producción','Esta seguro de realizar esta operacion',Question!,yesno!) = 2 then
					return
End if

SetNull(ls_null)

DECLARE USP_PROD_ACTUALIZA_CEBE_VALE PROCEDURE FOR
	USP_PROD_ACTUALIZA_CEBE_VALE( :ls_null );

EXECUTE USP_PROD_ACTUALIZA_CEBE_VALE;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_ACTUALIZA_CEBE_VALE: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetPointer (Arrow!)
	return 
END IF

CLOSE USP_PROD_ACTUALIZA_CEBE_VALE;

MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')

SetPointer (Arrow!)
end event

on w_pr911_actualiza_cebe_vales.create
int iCurrent
call super::create
if this.MenuName = "m_impresion_1" then this.MenuID = create m_impresion_1
this.cb_aceptar=create cb_aceptar
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_aceptar
this.Control[iCurrent+2]=this.st_1
end on

on w_pr911_actualiza_cebe_vales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_aceptar)
destroy(this.st_1)
end on

event open;call super::open;//// Override
//THIS.EVENT ue_open_pre()
end event

type cb_aceptar from picturebutton within w_pr911_actualiza_cebe_vales
integer x = 567
integer y = 496
integer width = 530
integer height = 132
integer taborder = 60
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

event clicked;parent.event ue_generar_os()
end event

type st_1 from statictext within w_pr911_actualiza_cebe_vales
integer x = 155
integer y = 152
integer width = 1394
integer height = 292
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Actualiza Centro Beneficio de Movimientos de Almacén Según Referecia del Vale Mov"
alignment alignment = center!
boolean focusrectangle = false
end type

