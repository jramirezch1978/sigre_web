$PBExportHeader$w_cn803_rpt_libro_certificado_retencion.srw
forward
global type w_cn803_rpt_libro_certificado_retencion from w_report_smpl
end type
type sle_year from singlelineedit within w_cn803_rpt_libro_certificado_retencion
end type
type sle_mes from singlelineedit within w_cn803_rpt_libro_certificado_retencion
end type
type cb_1 from commandbutton within w_cn803_rpt_libro_certificado_retencion
end type
type st_3 from statictext within w_cn803_rpt_libro_certificado_retencion
end type
type st_4 from statictext within w_cn803_rpt_libro_certificado_retencion
end type
type cbx_fecha from checkbox within w_cn803_rpt_libro_certificado_retencion
end type
type gb_1 from groupbox within w_cn803_rpt_libro_certificado_retencion
end type
end forward

global type w_cn803_rpt_libro_certificado_retencion from w_report_smpl
integer width = 3369
integer height = 1604
string title = "[CN803] Libro de Certificados de Retenciones"
string menuname = "m_abc_report_smpl"
sle_year sle_year
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
cbx_fecha cbx_fecha
gb_1 gb_1
end type
global w_cn803_rpt_libro_certificado_retencion w_cn803_rpt_libro_certificado_retencion

on w_cn803_rpt_libro_certificado_retencion.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_year=create sle_year
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.cbx_fecha=create cbx_fecha
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_year
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.cbx_fecha
this.Control[iCurrent+7]=this.gb_1
end on

on w_cn803_rpt_libro_certificado_retencion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cbx_fecha)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_mensaje, ls_nombre_mes
Long 		ll_ano, ll_mes

ll_ano = long(sle_year.text)
ll_mes = long(sle_mes.text)

//create or replace procedure usp_fin_rpt_libro_retenciones(
//       ani_mes   IN NUMBER,
//       ani_year  IN NUMBER
//) IS

DECLARE usp_fin_rpt_libro_retenciones PROCEDURE FOR 
	usp_fin_rpt_libro_retenciones( :ll_ano, 
											 :ll_mes);
											
Execute usp_fin_rpt_libro_retenciones ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fin_rpt_libro_retenciones: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

close usp_fin_rpt_libro_retenciones;

dw_report.retrieve()
//--
CHOOSE CASE ll_mes
			
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
dw_report.object.p_logo.filename 		= gs_logo
dw_report.object.t_user.text     		= gs_user
dw_report.object.t_year.text     		= string(ll_ano)
dw_report.object.t_ruc.text      		= gnvo_app.empresa.is_ruc
dw_report.object.t_mes.text      		= ls_nombre_mes
dw_report.object.t_razon_social.text	= gnvo_app.empresa.is_nom_empresa

if cbx_fecha.checked then
	dw_report.object.t_fecha.Visible      = '1'
else
	dw_report.object.t_fecha.Visible      = '0'
end if

end event

event ue_open_pre;call super::ue_open_pre;sle_year.text = string(gnvo_app.of_fecha_actual( ), 'yyyy')
sle_mes.text  = string(gnvo_app.of_fecha_actual( ), 'mm')
end event

type dw_report from w_report_smpl`dw_report within w_cn803_rpt_libro_certificado_retencion
integer x = 0
integer y = 204
integer width = 3291
integer height = 1116
integer taborder = 40
string dataobject = "d_rpt_libro_certificado_retencion_tbl"
end type

type sle_year from singlelineedit within w_cn803_rpt_libro_certificado_retencion
integer x = 201
integer y = 76
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

type sle_mes from singlelineedit within w_cn803_rpt_libro_certificado_retencion
integer x = 576
integer y = 76
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

type cb_1 from commandbutton within w_cn803_rpt_libro_certificado_retencion
integer x = 782
integer y = 36
integer width = 297
integer height = 136
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type st_3 from statictext within w_cn803_rpt_libro_certificado_retencion
integer x = 411
integer y = 84
integer width = 160
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn803_rpt_libro_certificado_retencion
integer x = 37
integer y = 84
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_fecha from checkbox within w_cn803_rpt_libro_certificado_retencion
integer x = 1129
integer y = 32
integer width = 942
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mostrar fecha de impresion"
boolean checked = true
end type

type gb_1 from groupbox within w_cn803_rpt_libro_certificado_retencion
integer width = 745
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
end type

