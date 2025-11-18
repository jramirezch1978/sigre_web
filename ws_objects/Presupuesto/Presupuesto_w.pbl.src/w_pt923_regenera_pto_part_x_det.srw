$PBExportHeader$w_pt923_regenera_pto_part_x_det.srw
$PBExportComments$Adiciona articulos proyectados al presupuesto de materiales
forward
global type w_pt923_regenera_pto_part_x_det from w_abc
end type
type st_4 from statictext within w_pt923_regenera_pto_part_x_det
end type
type em_ano from editmask within w_pt923_regenera_pto_part_x_det
end type
type st_6 from statictext within w_pt923_regenera_pto_part_x_det
end type
type st_3 from statictext within w_pt923_regenera_pto_part_x_det
end type
type st_2 from statictext within w_pt923_regenera_pto_part_x_det
end type
type st_1 from statictext within w_pt923_regenera_pto_part_x_det
end type
type pb_2 from picturebutton within w_pt923_regenera_pto_part_x_det
end type
type pb_1 from picturebutton within w_pt923_regenera_pto_part_x_det
end type
end forward

global type w_pt923_regenera_pto_part_x_det from w_abc
integer width = 1673
integer height = 1216
string title = "(PT923) Regenera presupuesto partida en función de presupuesto detalle"
string menuname = "m_only_exit"
boolean toolbarvisible = false
st_4 st_4
em_ano em_ano
st_6 st_6
st_3 st_3
st_2 st_2
st_1 st_1
pb_2 pb_2
pb_1 pb_1
end type
global w_pt923_regenera_pto_part_x_det w_pt923_regenera_pto_part_x_det

on w_pt923_regenera_pto_part_x_det.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.st_4=create st_4
this.em_ano=create em_ano
this.st_6=create st_6
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.pb_2=create pb_2
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.st_6
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.pb_2
this.Control[iCurrent+8]=this.pb_1
end on

on w_pt923_regenera_pto_part_x_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_4)
destroy(this.em_ano)
destroy(this.st_6)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.pb_2)
destroy(this.pb_1)
end on

event ue_open_pre();call super::ue_open_pre;of_center_window()


end event

type st_4 from statictext within w_pt923_regenera_pto_part_x_det
integer x = 41
integer y = 312
integer width = 1513
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "las partidas presupuestales que no tienen detalle."
boolean focusrectangle = false
end type

type em_ano from editmask within w_pt923_regenera_pto_part_x_det
integer x = 754
integer y = 576
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

type st_6 from statictext within w_pt923_regenera_pto_part_x_det
integer x = 549
integer y = 596
integer width = 402
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

type st_3 from statictext within w_pt923_regenera_pto_part_x_det
integer x = 46
integer y = 236
integer width = 1545
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "partida, en función del presupuesto detalle. No actualizará"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt923_regenera_pto_part_x_det
integer x = 46
integer y = 168
integer width = 1573
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proceso que tiene como finalidad regenerar el presupuesto"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pt923_regenera_pto_part_x_det
integer x = 178
integer y = 20
integer width = 1243
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
string text = "Regenera presupuesto partida"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pt923_regenera_pto_part_x_det
integer x = 873
integer y = 736
integer width = 315
integer height = 180
integer taborder = 30
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

type pb_1 from picturebutton within w_pt923_regenera_pto_part_x_det
integer x = 498
integer y = 736
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
String ls_modo, ls_mensaje

if ISNULL( em_ano.text) OR TRIM(em_ano.text) = '' THEN
	Messagebox( "Error", "Ingrese año", exclamation!)
	em_ano.SetFocus()
	return
end if

ll_ano = Long(em_ano.text)

DECLARE USP_PPTO_PART_X_PPTO_DET PROCEDURE FOR 
	USP_PPTO_PART_X_PPTO_DET(:ll_ano, :gs_user);
	

EXECUTE USP_PPTO_PART_X_PPTO_DET;

if sqlca.sqlcode = -1 then   // Fallo
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error USP_PPTO_PART_X_PPTO_DET", ls_mensaje, stopsign!)
	return 0
end if

CLOSE USP_PPTO_PART_X_PPTO_DET;

MessageBox( 'Mensaje', "Proceso terminado" )

end event

