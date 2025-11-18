$PBExportHeader$w_cn705_cntbl_rpt_pre_asiento.srw
forward
global type w_cn705_cntbl_rpt_pre_asiento from w_rpt_list
end type
type sle_ano from singlelineedit within w_cn705_cntbl_rpt_pre_asiento
end type
type sle_mes from singlelineedit within w_cn705_cntbl_rpt_pre_asiento
end type
type dw_origen from datawindow within w_cn705_cntbl_rpt_pre_asiento
end type
type cbx_1 from checkbox within w_cn705_cntbl_rpt_pre_asiento
end type
type gb_1 from groupbox within w_cn705_cntbl_rpt_pre_asiento
end type
type gb_2 from groupbox within w_cn705_cntbl_rpt_pre_asiento
end type
end forward

global type w_cn705_cntbl_rpt_pre_asiento from w_rpt_list
integer width = 3735
integer height = 2028
string title = "Emisión de Reportes de los Pre Asientos (CN705)"
string menuname = "m_abc_report_smpl"
long backcolor = 67108864
sle_ano sle_ano
sle_mes sle_mes
dw_origen dw_origen
cbx_1 cbx_1
gb_1 gb_1
gb_2 gb_2
end type
global w_cn705_cntbl_rpt_pre_asiento w_cn705_cntbl_rpt_pre_asiento

on w_cn705_cntbl_rpt_pre_asiento.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.dw_origen=create dw_origen
this.cbx_1=create cbx_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.dw_origen
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_cn705_cntbl_rpt_pre_asiento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.dw_origen)
destroy(this.cbx_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_origen
integer 	ln_nro_libro, li_i, li_year, li_mes
string  	ls_descripcion, ls_mensaje

if dw_2.RowCount( ) = 0 then
	MessageBox('Error', 'No ha seleccionado ningun libro contable, verifique por favor!', StopSign!)
	return
end if

delete from tt_cntbl_asientos ;
	
for li_i = 1 to dw_2.rowcount()
	ln_nro_libro   = dw_2.object.nro_libro	[li_i]
 	ls_descripcion = dw_2.object.desc_libro[li_i]
	 
	insert into tt_cntbl_asientos (nro_libro, descripcion)
	values (:ln_nro_libro, :ls_descripcion) ;
	 
	if sqlca.sqlcode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		messagebox("Error ", "Error al insertar registro en tt_cntbl_asientos: " + ls_mensaje )
		return
	end if
	
	commit;
next

li_year 		= Integer(sle_ano.text)
li_mes 		= Integer(sle_mes.text)
ls_origen 	= dw_origen.object.origen[1]

dw_report.visible=true

dw_report.retrieve(ls_origen, li_year, li_mes)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text 	= gs_empresa
dw_report.object.t_user.text 		= gs_user

end event

event ue_open_pre;call super::ue_open_pre;dw_origen.SetTransObject(SQLCA)
dw_origen.Retrieve()

dw_origen.InsertRow(0)

ib_preview = false
event ue_preview()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type dw_report from w_rpt_list`dw_report within w_cn705_cntbl_rpt_pre_asiento
integer x = 0
integer y = 436
integer width = 3607
integer height = 1376
integer taborder = 0
string dataobject = "d_cntbl_rpt_pre_asiento_tbl"
end type

type dw_1 from w_rpt_list`dw_1 within w_cn705_cntbl_rpt_pre_asiento
integer x = 23
integer y = 56
integer width = 1326
integer height = 348
integer taborder = 0
string dataobject = "d_cntbl_nro_libro_tbl"
end type

event dw_1::constructor;call super::constructor;idw_1 = dw_report
idw_1.Visible = False

dw_1.SetTransObject(sqlca)
dw_1.retrieve()
dw_2.SetTransObject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

type pb_1 from w_rpt_list`pb_1 within w_cn705_cntbl_rpt_pre_asiento
integer x = 1413
integer y = 120
integer width = 128
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "»"
end type

type pb_2 from w_rpt_list`pb_2 within w_cn705_cntbl_rpt_pre_asiento
integer x = 1413
integer y = 228
integer width = 128
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "«"
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_cn705_cntbl_rpt_pre_asiento
integer x = 1568
integer y = 56
integer width = 1326
integer height = 348
integer taborder = 0
string dataobject = "d_cntbl_nro_libro_tbl"
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

type cb_report from w_rpt_list`cb_report within w_cn705_cntbl_rpt_pre_asiento
integer x = 3305
integer y = 304
integer width = 238
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
string text = "Aceptar"
end type

event cb_report::clicked;call super::clicked;SetPointer(HourGlass!)

parent.event ue_retrieve()

SetPointer(Arrow!)
end event

type sle_ano from singlelineedit within w_cn705_cntbl_rpt_pre_asiento
integer x = 3054
integer y = 172
integer width = 192
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn705_cntbl_rpt_pre_asiento
integer x = 3273
integer y = 172
integer width = 105
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type dw_origen from datawindow within w_cn705_cntbl_rpt_pre_asiento
integer x = 2962
integer y = 308
integer width = 256
integer height = 76
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_origen_ff"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_cn705_cntbl_rpt_pre_asiento
integer x = 2981
integer y = 16
integer width = 462
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar Fecha"
boolean checked = true
end type

event clicked;if cbx_1.checked then
	dw_report.object.t_fecha.visible = '1'
else
	dw_report.object.t_fecha.visible = '0'
end if
end event

type gb_1 from groupbox within w_cn705_cntbl_rpt_pre_asiento
integer x = 3003
integer y = 100
integer width = 421
integer height = 188
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Año y Mes "
end type

type gb_2 from groupbox within w_cn705_cntbl_rpt_pre_asiento
integer width = 2953
integer height = 424
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Seleccione Número de Libro "
end type

