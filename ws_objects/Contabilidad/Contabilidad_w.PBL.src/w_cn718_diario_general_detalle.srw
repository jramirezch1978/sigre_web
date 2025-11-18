$PBExportHeader$w_cn718_diario_general_detalle.srw
forward
global type w_cn718_diario_general_detalle from w_rpt_list
end type
type sle_ano from singlelineedit within w_cn718_diario_general_detalle
end type
type sle_mes from singlelineedit within w_cn718_diario_general_detalle
end type
type st_1 from statictext within w_cn718_diario_general_detalle
end type
type st_2 from statictext within w_cn718_diario_general_detalle
end type
type st_3 from statictext within w_cn718_diario_general_detalle
end type
type st_4 from statictext within w_cn718_diario_general_detalle
end type
type rb_detalle from radiobutton within w_cn718_diario_general_detalle
end type
type rb_resumen from radiobutton within w_cn718_diario_general_detalle
end type
type cb_libro from commandbutton within w_cn718_diario_general_detalle
end type
type cbx_1 from checkbox within w_cn718_diario_general_detalle
end type
type gb_1 from groupbox within w_cn718_diario_general_detalle
end type
type gb_2 from groupbox within w_cn718_diario_general_detalle
end type
end forward

global type w_cn718_diario_general_detalle from w_rpt_list
integer width = 3442
integer height = 1976
string title = "Diario General (CN718)"
string menuname = "m_abc_report_smpl"
boolean resizable = false
long backcolor = 67108864
sle_ano sle_ano
sle_mes sle_mes
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
rb_detalle rb_detalle
rb_resumen rb_resumen
cb_libro cb_libro
cbx_1 cbx_1
gb_1 gb_1
gb_2 gb_2
end type
global w_cn718_diario_general_detalle w_cn718_diario_general_detalle

type variables
String is_opcion 
end variables

event resize;call super::resize;// Prueba
dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


end event

on w_cn718_diario_general_detalle.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.rb_detalle=create rb_detalle
this.rb_resumen=create rb_resumen
this.cb_libro=create cb_libro
this.cbx_1=create cbx_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.rb_detalle
this.Control[iCurrent+8]=this.rb_resumen
this.Control[iCurrent+9]=this.cb_libro
this.Control[iCurrent+10]=this.cbx_1
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_cn718_diario_general_detalle.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_detalle)
destroy(this.rb_resumen)
destroy(this.cb_libro)
destroy(this.cbx_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;//of_position_window(0,0) 		// Posicionar window
// ii_help = 101           // help topic

idw_1 = dw_report
idw_1.Visible = False
this.sle_ano.text=string(year(today()))
this.sle_mes.text=string(month(today()))
is_opcion='D'
end event

type dw_report from w_rpt_list`dw_report within w_cn718_diario_general_detalle
integer x = 0
integer y = 336
integer width = 3392
integer height = 1472
string dataobject = "d_rpt_diario"
end type

event dw_report::resize;long ll_x, ll_y
ll_x = (this.width - 1257)/2
ll_y = (this.height - 157)/2

this.Modify('no_rows_found.X=" ' + String(ll_x) &
 + ' " no_rows_found.Y=" ' + String(ll_y) + ' " ')
end event

type dw_1 from w_rpt_list`dw_1 within w_cn718_diario_general_detalle
integer x = 549
integer y = 436
integer width = 1019
integer height = 892
string dataobject = "nro_libro_dddw"
end type

event dw_1::constructor;call super::constructor;this.SetTransObject(sqlca)
this.retrieve()

ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

type pb_1 from w_rpt_list`pb_1 within w_cn718_diario_general_detalle
integer x = 1637
integer y = 644
end type

type pb_2 from w_rpt_list`pb_2 within w_cn718_diario_general_detalle
integer x = 1637
integer y = 964
end type

type dw_2 from w_rpt_list`dw_2 within w_cn718_diario_general_detalle
integer x = 1856
integer y = 436
integer width = 1019
integer height = 896
string dataobject = "nro_libro_dddw"
end type

event dw_2::constructor;call super::constructor;this.SetTransObject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

type cb_report from w_rpt_list`cb_report within w_cn718_diario_general_detalle
integer x = 2542
integer y = 224
integer width = 599
integer height = 80
integer textsize = -8
integer weight = 700
string text = "Generar "
end type

event cb_report::clicked;call super::clicked;integer 	li_year, li_mes, li_nro_libro, i
String 	ls_desc_libro, ls_nombre_mes, ls_nom_empresa, ls_mensaje

li_year = integer(sle_ano.text)
li_mes = integer(sle_mes.text)

dw_1.visible = false
dw_2.visible = false
pb_1.visible = false
pb_2.visible = false
st_4.visible = false

cb_libro.enabled=true

Select nombre
	into :ls_nom_empresa
from empresa
where trim(sigla) = trim(:gs_empresa);
dw_report.object.t_empresa2.text  = ls_nom_empresa

delete from tt_libro;
FOR i = 1 to dw_2.rowcount()
    li_nro_libro = dw_2.object.nro_libro[i]
	 ls_desc_libro = dw_2.object.desc_libro[i]
	 
	 Insert into tt_libro(nro_libro, desc_libro) 
	 values ( :li_nro_libro, :ls_desc_libro);		
	 
	 If sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		messagebox("Error", "Error al insertar en tabla t_libro. Mensaje: " + ls_mensaje, StopSign!)
		return
	 END IF
NEXT	

//--
CHOOSE CASE li_mes
			
	  	CASE 0
			  ls_nombre_mes = 'MES CERO'
		CASE 1
			  ls_nombre_mes = '01 ENERO'
		CASE 2
			  ls_nombre_mes = '02 FEBRERO'
	   CASE 3
			  ls_nombre_mes = '03 MARZO'
      CASE 4
			  ls_nombre_mes = '04 ABRIL'
		CASE 5
			  ls_nombre_mes = '05 MAYO'
	   CASE 6
			  ls_nombre_mes = '06 JUNIO'
		CASE 7
			  ls_nombre_mes = '07 JULIO'
		CASE 8
			  ls_nombre_mes = '08 AGOSTO'
	   CASE 9
			  ls_nombre_mes = '09 SEPTIEMBRE'
	   CASE 10
			  ls_nombre_mes = '10 OCTUBRE'
		CASE 11
			  ls_nombre_mes = '11 NOVIEMBRE'
	   CASE 12
			  ls_nombre_mes = '12 DICIEMBRE'
	END CHOOSE
//--

IF is_opcion='D' then // Detalle

	dw_report.DataObject='d_rpt_diario'
	dw_report.SetTransObject(sqlca)
	dw_report.retrieve(li_year, li_mes)
	dw_report.visible = true
   parent.event ue_preview()

	dw_report.object.p_logo.filename = gs_logo
	dw_report.object.t_empresa2.text  = ls_nom_empresa
	dw_report.object.t_user.text     = gs_user
	dw_report.object.t_mes.text		= ls_nombre_mes
	dw_report.object.t_ruc.text      = gs_ruc

elseif is_opcion='R' then  //Resumen

	dw_report.DataObject='d_rpt_diario_general_resumen_sel_tbl'
	dw_report.SetTransObject(sqlca)
	dw_report.retrieve(li_year, li_mes)
	dw_report.visible = true
   parent.event ue_preview()

	dw_report.object.p_logo.filename = gs_logo
	dw_report.object.t_empresa2.text  = ls_nom_empresa
	dw_report.object.t_usuario.text  = gs_user
	dw_report.object.t_ruc.text      = gs_ruc
	dw_report.object.t_texto.text = 'Año: ' + string(li_year, '0000') + '  Mes: ' + ls_nombre_mes
	IF gs_empresa = 'FISHOLG' then
		dw_report.object.t_1.text = 'LIBRO DIARIO'
	end if

else
	messagebox('Seleccione opcion','Detalle o Resumido')
end if

end event

type sle_ano from singlelineedit within w_cn718_diario_general_detalle
integer x = 1225
integer y = 176
integer width = 160
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn718_diario_general_detalle
integer x = 1678
integer y = 176
integer width = 142
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cn718_diario_general_detalle
integer x = 1083
integer y = 176
integer width = 123
integer height = 76
boolean bringtotop = true
integer textsize = -8
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

type st_2 from statictext within w_cn718_diario_general_detalle
integer x = 1536
integer y = 176
integer width = 123
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn718_diario_general_detalle
integer x = 1033
integer y = 36
integer width = 846
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "LIBRO DIARIO GENERAL "
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn718_diario_general_detalle
integer x = 558
integer y = 360
integer width = 526
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Libros contables:"
boolean focusrectangle = false
end type

type rb_detalle from radiobutton within w_cn718_diario_general_detalle
integer x = 142
integer y = 116
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
boolean checked = true
end type

event clicked;is_opcion='D'
//parent.event ue_preview()
end event

type rb_resumen from radiobutton within w_cn718_diario_general_detalle
integer x = 142
integer y = 208
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
end type

event clicked;is_opcion='R'
//parent.event ue_preview()
end event

type cb_libro from commandbutton within w_cn718_diario_general_detalle
integer x = 2542
integer y = 132
integer width = 599
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Selecciona Libro"
end type

event clicked;parent.event ue_preview()
dw_report.visible = false
dw_1.visible = true
dw_2.visible = true
pb_1.visible = true
pb_2.visible = true
st_4.visible = true
cb_libro.enabled=false



end event

type cbx_1 from checkbox within w_cn718_diario_general_detalle
integer x = 1943
integer y = 136
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

type gb_1 from groupbox within w_cn718_diario_general_detalle
integer x = 91
integer y = 48
integer width = 480
integer height = 264
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opción"
end type

type gb_2 from groupbox within w_cn718_diario_general_detalle
integer x = 1024
integer y = 108
integer width = 869
integer height = 180
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

