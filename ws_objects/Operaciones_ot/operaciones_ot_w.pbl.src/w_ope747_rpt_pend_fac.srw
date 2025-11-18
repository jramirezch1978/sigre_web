$PBExportHeader$w_ope747_rpt_pend_fac.srw
forward
global type w_ope747_rpt_pend_fac from w_report_smpl
end type
type cb_1 from commandbutton within w_ope747_rpt_pend_fac
end type
type uo_1 from u_ingreso_rango_fechas within w_ope747_rpt_pend_fac
end type
type sle_ot from singlelineedit within w_ope747_rpt_pend_fac
end type
type st_desc_alm from statictext within w_ope747_rpt_pend_fac
end type
type pb_1 from picturebutton within w_ope747_rpt_pend_fac
end type
type st_1 from statictext within w_ope747_rpt_pend_fac
end type
type gb_1 from groupbox within w_ope747_rpt_pend_fac
end type
end forward

global type w_ope747_rpt_pend_fac from w_report_smpl
integer width = 2286
integer height = 1664
string title = "(OPE747)  Operaciones Pendientes por Facturar"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
cb_1 cb_1
uo_1 uo_1
sle_ot sle_ot
st_desc_alm st_desc_alm
pb_1 pb_1
st_1 st_1
gb_1 gb_1
end type
global w_ope747_rpt_pend_fac w_ope747_rpt_pend_fac

on w_ope747_rpt_pend_fac.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_1=create cb_1
this.uo_1=create uo_1
this.sle_ot=create sle_ot
this.st_desc_alm=create st_desc_alm
this.pb_1=create pb_1
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.sle_ot
this.Control[iCurrent+4]=this.st_desc_alm
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.gb_1
end on

on w_ope747_rpt_pend_fac.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.sle_ot)
destroy(this.st_desc_alm)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;date ad_inicio, ad_fin

ad_inicio = uo_1.of_get_fecha1()
ad_fin = uo_1.of_get_fecha2()

dw_report.settransobject(sqlca)
dw_report.retrieve(sle_ot.text , ad_inicio, ad_fin)

dw_report.Object.user_t.text = gs_user
dw_report.Object.empresa_t.text = gs_empresa
dw_report.object.p_logo.filename = gs_logo
dw_report.object.windows_t.text = THIS.classname()

end event

type dw_report from w_report_smpl`dw_report within w_ope747_rpt_pend_fac
integer x = 32
integer y = 356
integer width = 2162
integer height = 1084
integer taborder = 60
string dataobject = "d_rpt_pend_fac"
end type

type cb_1 from commandbutton within w_ope747_rpt_pend_fac
integer x = 1490
integer y = 216
integer width = 311
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
boolean default = true
end type

event clicked;parent.event ue_retrieve()
end event

type uo_1 from u_ingreso_rango_fechas within w_ope747_rpt_pend_fac
integer x = 110
integer y = 220
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor; string ls_inicio 

 of_set_label('Desde','Hasta') //para setear la fecha inicial

//Obtenemos el Primer dia del Mes

ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 of_set_fecha(date(ls_inicio),today())
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type sle_ot from singlelineedit within w_ope747_rpt_pend_fac
integer x = 379
integer y = 108
integer width = 325
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event losefocus;// Verifica que el almacen exista
String ls_ot
Long ll_count

ls_ot = sle_ot.text

if TRIM( ls_ot ) <> '' then
	Select count(*) into :ll_count from OT_ADMINISTRACION where OT_ADM = :ls_ot;
	if ll_count = 0 then
		Messagebox( "Error", "Codigo de Ot_ADM no existe")
		sle_ot.text = ''
		sle_ot.SetFocus()
		return 
	end if
end if
end event

event modified;String 	LS_OT_ADM, ls_desc

LS_OT_ADM = sle_ot.text

if LS_OT_ADM = '' or IsNull(LS_OT_ADM) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de OT_ADM')
	return
end if

SELECT DESCRIPCION 
	INTO :ls_desc
FROM OT_ADMINISTRACION 
where OT_ADM = :LS_OT_ADM  ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de OT_ADM no existe')
	return
end if

st_desc_alm.text = ls_desc
end event

type st_desc_alm from statictext within w_ope747_rpt_pend_fac
integer x = 850
integer y = 104
integer width = 1257
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_ope747_rpt_pend_fac
integer x = 718
integer y = 104
integer width = 123
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;string ls_sql, LS_OT_ADM, ls_data
boolean lb_ret

ls_sql = "SELECT OT_ADM AS CODIGO_OT_ADM, " &
		  + "DESCRIPCION AS DESCRIPCION_OT_ADM " &
		  + "FROM OT_ADMINISTRACION " 
			 
lb_ret = f_lista(ls_sql, LS_OT_ADM, &
			ls_data, '1')
	
if LS_OT_ADM <> '' then
	sle_ot.text		= LS_OT_ADM
	st_desc_alm.text 	= ls_data
end if

end event

type st_1 from statictext within w_ope747_rpt_pend_fac
integer x = 110
integer y = 128
integer width = 247
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "OT_ADM :"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_ope747_rpt_pend_fac
integer x = 37
integer y = 28
integer width = 2149
integer height = 308
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "PARAMETROS"
end type

