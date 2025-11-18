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
type gb_1 from groupbox within w_cn705_cntbl_rpt_pre_asiento
end type
type gb_2 from groupbox within w_cn705_cntbl_rpt_pre_asiento
end type
end forward

global type w_cn705_cntbl_rpt_pre_asiento from w_rpt_list
integer width = 3735
integer height = 2028
string title = "Emisión de Reportes de los Pre Asientos (CN705)"
string menuname = "m_impresion"
long backcolor = 67108864
sle_ano sle_ano
sle_mes sle_mes
dw_origen dw_origen
gb_1 gb_1
gb_2 gb_2
end type
global w_cn705_cntbl_rpt_pre_asiento w_cn705_cntbl_rpt_pre_asiento

on w_cn705_cntbl_rpt_pre_asiento.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.dw_origen=create dw_origen
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.dw_origen
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.gb_2
end on

on w_cn705_cntbl_rpt_pre_asiento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.dw_origen)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String ls_ano, ls_mes, ls_origen
ls_ano = String(sle_ano.text)
ls_mes = String(sle_mes.text)
ls_origen = dw_origen.object.origen[1]

DECLARE USP_CNTBL_RPT_PRE_ASIENTOS PROCEDURE FOR 
	USP_CNTBL_RPT_PRE_ASIENTOS( :ls_ano, :ls_mes, :ls_origen ) ;
Execute USP_CNTBL_RPT_PRE_ASIENTOS ;

if gnvo_app.of_existserror( SQLCA, 'Procedure USP_CNTBL_RPT_PRE_ASIENTOS') then
	rollback;
	return
end if


dw_report.retrieve()

close USP_CNTBL_RPT_PRE_ASIENTOS;

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text 	= gs_empresa
dw_report.object.t_user.text 		= gs_user

end event

event ue_open_pre;call super::ue_open_pre;dw_origen.SetTransObject(SQLCA)
dw_origen.Retrieve()

dw_origen.InsertRow(0)

event ue_preview()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type dw_report from w_rpt_list`dw_report within w_cn705_cntbl_rpt_pre_asiento
integer x = 0
integer y = 384
integer width = 3607
integer height = 1376
integer taborder = 0
string dataobject = "d_cntbl_rpt_pre_asiento_tbl"
end type

type dw_1 from w_rpt_list`dw_1 within w_cn705_cntbl_rpt_pre_asiento
integer y = 56
integer width = 1371
integer height = 304
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
integer x = 1408
integer y = 96
integer width = 128
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "»"
end type

type pb_2 from w_rpt_list`pb_2 within w_cn705_cntbl_rpt_pre_asiento
integer x = 1408
integer y = 204
integer width = 128
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "«"
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_cn705_cntbl_rpt_pre_asiento
integer x = 1554
integer y = 56
integer width = 1371
integer height = 304
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
integer x = 3314
integer y = 236
integer width = 238
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
string text = "Aceptar"
end type

event cb_report::clicked;call super::clicked;integer ln_nro_libro, i
string  ls_descripcion

delete from tt_cntbl_asientos ;
	
for i = 1 to dw_2.rowcount()
  	 ln_nro_libro   = dw_2.object.nro_libro[i]
 	 ls_descripcion = dw_2.object.desc_libro[i]
	 
	 insert into tt_cntbl_asientos (nro_libro, descripcion)
	 values (:ln_nro_libro, :ls_descripcion) ;
	 
	 if sqlca.sqlcode = -1 then
		 messagebox("Error al insertar registro",sqlca.sqlerrtext)
	end if
next

dw_report.SetTransObject(sqlca)
dw_report.visible=true

parent.event ue_retrieve()

end event

type sle_ano from singlelineedit within w_cn705_cntbl_rpt_pre_asiento
integer x = 3063
integer y = 96
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
integer x = 3282
integer y = 96
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
integer x = 2971
integer y = 240
integer width = 256
integer height = 76
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_origen_ff"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_cn705_cntbl_rpt_pre_asiento
integer x = 3013
integer y = 24
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
integer height = 372
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Seleccione Número de Libro "
end type

