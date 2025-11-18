$PBExportHeader$w_cm501_cuadro_comparativo.srw
forward
global type w_cm501_cuadro_comparativo from w_report_smpl
end type
type st_1 from statictext within w_cm501_cuadro_comparativo
end type
type pb_1 from picturebutton within w_cm501_cuadro_comparativo
end type
type sle_nro from u_sle_codigo within w_cm501_cuadro_comparativo
end type
end forward

global type w_cm501_cuadro_comparativo from w_report_smpl
integer width = 2258
integer height = 1832
string title = "Cuadro Comparativo (CM501)"
string menuname = "m_impresion"
long backcolor = 67108864
st_1 st_1
pb_1 pb_1
sle_nro sle_nro
end type
global w_cm501_cuadro_comparativo w_cm501_cuadro_comparativo

on w_cm501_cuadro_comparativo.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.pb_1=create pb_1
this.sle_nro=create sle_nro
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.sle_nro
end on

on w_cm501_cuadro_comparativo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.pb_1)
destroy(this.sle_nro)
end on

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve(sle_nro.text)

end event

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = TRUE
end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc


li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If


end event

type dw_report from w_report_smpl`dw_report within w_cm501_cuadro_comparativo
integer x = 0
integer y = 132
integer width = 2167
integer height = 1472
string dataobject = "d_cns_cuadro_comparativo_cmp"
end type

type st_1 from statictext within w_cm501_cuadro_comparativo
integer x = 69
integer y = 36
integer width = 393
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Cotizacion Nº:"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_cm501_cuadro_comparativo
integer x = 969
integer y = 20
integer width = 128
integer height = 104
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\source\bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_dddw_cotizaciones_tbl"
sl_param.titulo = "Cotizaciones de Bienes"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.tipo = '1S'
sl_param.string1 = 'B'

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	sle_nro.text = sl_param.field_ret[2]
	parent.event ue_retrieve( )
END IF
end event

type sle_nro from u_sle_codigo within w_cm501_cuadro_comparativo
integer x = 466
integer y = 28
integer width = 471
integer height = 92
integer taborder = 10
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

event modified;call super::modified;parent.event ue_retrieve( )
end event

