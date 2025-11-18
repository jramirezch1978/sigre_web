$PBExportHeader$w_cm902_monto_total_oc.srw
forward
global type w_cm902_monto_total_oc from w_abc
end type
type st_1 from statictext within w_cm902_monto_total_oc
end type
type pb_2 from picturebutton within w_cm902_monto_total_oc
end type
type pb_1 from picturebutton within w_cm902_monto_total_oc
end type
end forward

global type w_cm902_monto_total_oc from w_abc
integer width = 2007
integer height = 632
string title = "[CM902] Regenera el Monto Total de la OC"
string menuname = "m_salir"
boolean resizable = false
event ue_aceptar ( )
event ue_salir ( )
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_cm902_monto_total_oc w_cm902_monto_total_oc

event ue_aceptar();string 	ls_mensaje

//create or replace procedure USP_CMP_ACT_MONTO_OC(
//       asi_nada in varchar
//)is

DECLARE USP_CMP_ACT_MONTO_OC PROCEDURE FOR
	USP_CMP_ACT_MONTO_OC( :gs_origen );

EXECUTE USP_CMP_ACT_MONTO_OC;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_CMP_ACT_MONTO_OC: " + SQLCA.SQLErrText
	Rollback ;
	SetPointer (Arrow!)
	return 
END IF

CLOSE USP_CMP_ACT_MONTO_OC;

MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')

end event

event ue_salir();close(this)
end event

on w_cm902_monto_total_oc.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.pb_2
this.Control[iCurrent+3]=this.pb_1
end on

on w_cm902_monto_total_oc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

type st_1 from statictext within w_cm902_monto_total_oc
integer width = 1984
integer height = 172
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Regenera el Monto Total de la OC"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_cm902_monto_total_oc
integer x = 1001
integer y = 260
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
string picturename = "C:\SIGRE\resources\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_salir()
end event

type pb_1 from picturebutton within w_cm902_monto_total_oc
integer x = 626
integer y = 260
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
string picturename = "C:\SIGRE\resources\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_aceptar()
end event

