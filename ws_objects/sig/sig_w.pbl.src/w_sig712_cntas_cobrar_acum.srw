$PBExportHeader$w_sig712_cntas_cobrar_acum.srw
forward
global type w_sig712_cntas_cobrar_acum from w_report_smpl
end type
type cb_lectura from commandbutton within w_sig712_cntas_cobrar_acum
end type
type uo_1 from u_ingreso_rango_fechas within w_sig712_cntas_cobrar_acum
end type
type cbx_nc from checkbox within w_sig712_cntas_cobrar_acum
end type
type gb_1 from groupbox within w_sig712_cntas_cobrar_acum
end type
end forward

global type w_sig712_cntas_cobrar_acum from w_report_smpl
integer width = 3223
integer height = 2148
string title = "Cuentas por Cobrar Acumulado (SIG712)"
string menuname = "m_rpt_simple"
long backcolor = 134217752
cb_lectura cb_lectura
uo_1 uo_1
cbx_nc cbx_nc
gb_1 gb_1
end type
global w_sig712_cntas_cobrar_acum w_sig712_cntas_cobrar_acum

type variables
String	is_oper, is_clase
end variables

forward prototypes
public function integer of_get_parametros (ref string as_clase, ref string as_oper_ing_prod)
end prototypes

public function integer of_get_parametros (ref string as_clase, ref string as_oper_ing_prod);Long		ll_rc = 0
String	ls_clase


SELECT CLASE_PROD_TERM
  INTO :as_clase
  FROM SIGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer SIGPARAM')
	lL_rc = -1
END IF

SELECT OPER_ING_PROD
  INTO :as_oper_ing_prod
  FROM LOGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -2
END IF

RETURN ll_rc

end function

on w_sig712_cntas_cobrar_acum.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_lectura=create cb_lectura
this.uo_1=create uo_1
this.cbx_nc=create cbx_nc
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.cbx_nc
this.Control[iCurrent+4]=this.gb_1
end on

on w_sig712_cntas_cobrar_acum.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.uo_1)
destroy(this.cbx_nc)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;//idw_1.of_set_split(idw_1.of_get_column_end('articulo_nom_articulo'))
end event

type dw_report from w_report_smpl`dw_report within w_sig712_cntas_cobrar_acum
integer y = 220
integer width = 3081
integer height = 1368
string dataobject = "d_rpt_sig_cntas_cobrar_acum"
boolean hsplitscroll = true
end type

event dw_report::doubleclicked;call super::doubleclicked;LONG ll_col, ll_static, li_pos
STRING ls_col, ls_objects, ls_value, ls_col1, &
		 ls_numero, ls_moneda, ls_data, &
 		 ls_relacion, ls_cod_art, ls_tipo, ls_embar, &
		 ls_doc_otr, ls_doc_ov
Date ld_fec_ini, ld_fec_fin
sg_parametros lstr_rep


CHOOSE CASE dwo.Name
	CASE "valor_acum"
		ld_fec_ini = uo_1.of_get_fecha1()
		ld_fec_fin = uo_1.of_get_fecha2()
		ls_relacion = this.object.cod_relacion [row]
		ls_cod_art = this.object.cod_art [row]
		lstr_rep.string1 = ls_relacion
		lstr_rep.string2 = ls_cod_art
		lstr_rep.date1 = ld_fec_ini
		lstr_rep.date2 = ld_fec_fin
	
		if cbx_nc.checked =true then
			lstr_rep.tipo = 'NCC'
		else
			lstr_rep.tipo = 'TODOS'
			ls_embar  = this.object.forma_embarque [row]
   		ls_moneda = this.object.cod_moneda [row]
			lstr_rep.string3 = ls_embar
			lstr_rep.string4 = ls_moneda
		end if
		OpenSheetWithParm(w_sig712_cntas_cobrar_acum_detalle, lstr_rep, w_main, 2, layered!)
END CHOOSE





end event

type cb_lectura from commandbutton within w_sig712_cntas_cobrar_acum
integer x = 1518
integer y = 64
integer width = 343
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;date ld_fec_ini, ld_fec_fin
datetime ldt_fec_ini, ldt_fec_fin
String ls_msj_err

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()  

SetPointer(hourglass!)

idw_1.ii_zoom_actual = 110
ib_preview = false

event ue_preview()
idw_1.retrieve(ld_fec_ini,ld_fec_fin)

SetPointer(Arrow!)

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = 'Indicadores de gestión'
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
dw_report.Object.t_windows.text = this.classname()
SetPointer(Arrow!)

idw_1.visible=true

parent.event ue_preview()
end event

type uo_1 from u_ingreso_rango_fechas within w_sig712_cntas_cobrar_acum
integer x = 64
integer y = 72
integer taborder = 40
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cbx_nc from checkbox within w_sig712_cntas_cobrar_acum
integer x = 2011
integer y = 60
integer width = 603
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217752
string text = "Nota de Credito"
boolean lefttext = true
end type

event clicked;date ld_fec_ini, ld_fec_fin
ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()  

IF THIS.checked = true THEN 

   dw_report.dataobject = 'd_rpt_sig_cntas_cobrar_acum_ncc'
	dw_report.SetTransObject(sqlca)
	dw_report.Retrieve(ld_fec_ini,ld_fec_fin)
	
	dw_report.Object.p_logo.filename = gs_logo
	dw_report.Object.t_texto.text = 'NOTA DE CREDITO'
	dw_report.Object.t_empresa.text = gs_empresa
	dw_report.Object.t_user.text = gs_user
	dw_report.Object.t_windows.text = this.classname()
	SetPointer(Arrow!)

	dw_report.visible=true

ELSE
	dw_report.dataobject = 'd_rpt_sig_cntas_cobrar_acum'
	dw_report.SetTransObject(sqlca)
	dw_report.Retrieve(ld_fec_ini,ld_fec_fin)
	
	dw_report.Object.p_logo.filename = gs_logo
	dw_report.Object.t_texto.text = 'Indicadores de gestión'
	dw_report.Object.t_empresa.text = gs_empresa
	dw_report.Object.t_user.text = gs_user
	dw_report.Object.t_windows.text = this.classname()
	SetPointer(Arrow!)
	dw_report.visible=true
END IF

parent.event ue_preview()
end event

type gb_1 from groupbox within w_sig712_cntas_cobrar_acum
integer x = 9
integer width = 1413
integer height = 196
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 134217752
string text = "Parámetros de Lectura"
end type

