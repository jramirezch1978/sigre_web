$PBExportHeader$w_sig715_fce_fabrica.srw
forward
global type w_sig715_fce_fabrica from w_report_smpl
end type
type cb_lectura from commandbutton within w_sig715_fce_fabrica
end type
type cb_param from commandbutton within w_sig715_fce_fabrica
end type
type uo_1 from u_ingreso_fecha within w_sig715_fce_fabrica
end type
type uo_2 from u_ingreso_rango_fechas within w_sig715_fce_fabrica
end type
type uo_3 from u_ingreso_rango_fechas within w_sig715_fce_fabrica
end type
type em_almacen from editmask within w_sig715_fce_fabrica
end type
type pb_1 from picturebutton within w_sig715_fce_fabrica
end type
type uo_4 from u_ingreso_rango_fechas within w_sig715_fce_fabrica
end type
type gb_2 from groupbox within w_sig715_fce_fabrica
end type
type gb_3 from groupbox within w_sig715_fce_fabrica
end type
type gb_4 from groupbox within w_sig715_fce_fabrica
end type
type gb_1 from groupbox within w_sig715_fce_fabrica
end type
type gb_5 from groupbox within w_sig715_fce_fabrica
end type
end forward

global type w_sig715_fce_fabrica from w_report_smpl
integer width = 3630
integer height = 1828
string title = "Indicadores de gestión de Fábrica (SIG715)"
string menuname = "m_rpt_simple"
long backcolor = 134217752
cb_lectura cb_lectura
cb_param cb_param
uo_1 uo_1
uo_2 uo_2
uo_3 uo_3
em_almacen em_almacen
pb_1 pb_1
uo_4 uo_4
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_1 gb_1
gb_5 gb_5
end type
global w_sig715_fce_fabrica w_sig715_fce_fabrica

type variables

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

on w_sig715_fce_fabrica.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_lectura=create cb_lectura
this.cb_param=create cb_param
this.uo_1=create uo_1
this.uo_2=create uo_2
this.uo_3=create uo_3
this.em_almacen=create em_almacen
this.pb_1=create pb_1
this.uo_4=create uo_4
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_1=create gb_1
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.cb_param
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.uo_2
this.Control[iCurrent+5]=this.uo_3
this.Control[iCurrent+6]=this.em_almacen
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.uo_4
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_3
this.Control[iCurrent+11]=this.gb_4
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_5
end on

on w_sig715_fce_fabrica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lectura)
destroy(this.cb_param)
destroy(this.uo_1)
destroy(this.uo_2)
destroy(this.uo_3)
destroy(this.em_almacen)
destroy(this.pb_1)
destroy(this.uo_4)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_1)
destroy(this.gb_5)
end on

event ue_open_pre;call super::ue_open_pre;String ls_almacen 

select almacen_pptt
  into :ls_almacen
  from labparam where reckey='1' ;
  
em_almacen.text = ls_almacen

end event

type dw_report from w_report_smpl`dw_report within w_sig715_fce_fabrica
integer x = 41
integer y = 484
integer width = 3177
integer height = 1072
string dataobject = "d_rpt_fce_semaforo_comerc_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;String ls_reporte, ls_grupo, ls_texto
Date ld_fec_dia, ld_fec_ini_mes, ld_fec_fin_mes, ld_fec_ini_trim, ld_fec_fin_trim
Date ld_fec_ini_ano, ld_fec_fin_ano

sg_paramet lstr_rep

IF row = 0 then return

IF this.Rowcount( ) = 0 then return

ls_grupo = this.object.sig_fce[row]

ld_fec_dia = uo_1.of_get_fecha()

ld_fec_ini_mes = uo_2.of_get_fecha1()
ld_fec_fin_mes = uo_2.of_get_fecha2()

ld_fec_ini_trim = uo_3.of_get_fecha1()
ld_fec_fin_trim = uo_3.of_get_fecha2()

ld_fec_ini_ano = uo_4.of_get_fecha1()
ld_fec_fin_ano = uo_4.of_get_fecha2()

IF ls_grupo='PRD_AZUM' then
	  lstr_rep.string1 = 'M'  //Mes
	  lstr_rep.string2 = 'Del ' + string(ld_fec_ini_mes,'dd/mm/yyyy') + ' al ' + string(ld_fec_fin_mes,'dd/mm/yyyy')
	  
ELSEIF ls_grupo='PRD_AZUA' then
	  lstr_rep.string1 = 'A'  //Año
	  lstr_rep.string2 = 'Del ' + string(ld_fec_ini_ano,'dd/mm/yyyy') + ' al ' + string(ld_fec_fin_ano,'dd/mm/yyyy')	  

ELSEIF ls_grupo='PRD_AZUT' then
	  lstr_rep.string1 = 'T'  //Trimestral
	  lstr_rep.string2 = 'Del ' + string(ld_fec_ini_trim,'dd/mm/yyyy') + ' al ' + string(ld_fec_fin_trim,'dd/mm/yyyy')

ELSE	// Diario
	  lstr_rep.string1 = 'D'
	  lstr_rep.string2 = 'Del ' + string(ld_fec_dia,'dd/mm/yyyy') 	  

END IF 
OpenSheetWithParm(w_sig715_res_prod_acum, lstr_rep, w_main, 2, layered!)
end event

type cb_lectura from commandbutton within w_sig715_fce_fabrica
integer x = 2263
integer y = 272
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

event clicked;STRING ls_reporte, ls_almacen, ls_tipo_mov, ls_texto, ls_msj_err
DATE ld_fec_dia, ld_fec_ini_mes, ld_fec_fin_mes, ld_fec_ini_trim, ld_fec_fin_trim
DATE ld_fec_ini_ano, ld_fec_fin_ano

cb_lectura.enabled = false

select ingreso_pptt 
  into :ls_tipo_mov
  from labparam where reckey='1' ;

ls_reporte = 'FABRIC'

SetPointer(hourglass!)

ls_almacen = trim(em_almacen.text)
ld_fec_dia = uo_1.of_get_fecha()

ld_fec_ini_mes = uo_2.of_get_fecha1()
ld_fec_fin_mes = uo_2.of_get_fecha2()

ld_fec_ini_trim = uo_3.of_get_fecha1()
ld_fec_fin_trim = uo_3.of_get_fecha2()

ld_fec_ini_ano = uo_4.of_get_fecha1()
ld_fec_fin_ano = uo_4.of_get_fecha2()

DECLARE PB_USP_SIGA_IND_PRODUC PROCEDURE FOR USP_SIGA_IND_PRODUC
(:ls_reporte, :ls_almacen, :ls_tipo_mov, :ld_fec_dia, :ld_fec_ini_mes, :ld_fec_fin_mes, 
 :ld_fec_ini_trim, :ld_fec_fin_trim, :ld_fec_ini_ano, :ld_fec_fin_ano );
EXECUTE PB_USP_SIGA_IND_PRODUC ;

cb_lectura.enabled = true

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
END IF

CLOSE PB_USP_SIGA_IND_PRODUC ;

idw_1.ii_zoom_actual = 110
ib_preview = false

event ue_preview()

//idw_1.DataObject='d_rpt_parte_diario_gen_tbl'
//idw_1.SetTransObject(sqlca)

idw_1.retrieve(ls_reporte)

SetPointer(Arrow!)

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = 'Indicadores de gestión'
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
SetPointer(Arrow!)

cb_param.enabled = true

idw_1.visible=true

//parent.event ue_preview()
end event

type cb_param from commandbutton within w_sig715_fce_fabrica
integer x = 2258
integer y = 368
integer width = 343
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Níveles"
end type

event clicked;sg_parametros lstr_rep

IF dw_report.Rowcount( ) = 0 then return

lstr_rep.string1 = 'COMER'
OpenSheetWithParm(w_sig714_fce_comerc_niveles, lstr_rep, w_main, 2, layered!)


end event

type uo_1 from u_ingreso_fecha within w_sig715_fce_fabrica
integer x = 73
integer y = 68
integer taborder = 80
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Día:') 
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

type uo_2 from u_ingreso_rango_fechas within w_sig715_fce_fabrica
integer x = 869
integer y = 100
integer taborder = 90
boolean bringtotop = true
end type

event constructor;call super::constructor;Date ld_fecha, ld_fecha_ini

ld_fecha = uo_1.of_get_fecha()

Select trunc(:ld_fecha,'month') into :ld_fecha_ini from dual ;

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_ini, ld_fecha) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_2.destroy
call u_ingreso_rango_fechas::destroy
end on

type uo_3 from u_ingreso_rango_fechas within w_sig715_fce_fabrica
integer x = 2240
integer y = 96
integer height = 96
integer taborder = 80
boolean bringtotop = true
end type

event constructor;call super::constructor;Date ld_fec_ini_trim, ld_fec_fin_trim, ld_fecha
DateTime ldt_fec_ini_trim, ldt_fec_fin_trim
String ls_ano, ls_mes

ld_fecha = uo_1.of_get_fecha()

select usf_sig_fecha_periodo(:ld_fecha, 'T', 'I') into :ld_fec_ini_trim from dual ;

select usf_sig_fecha_periodo(:ld_fecha, 'T', 'F') into :ld_fec_fin_trim from dual ;


of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha( ld_fec_ini_trim, ld_fec_fin_trim) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_3.destroy
call u_ingreso_rango_fechas::destroy
end on

type em_almacen from editmask within w_sig715_fce_fabrica
integer x = 96
integer y = 280
integer width = 384
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!!!!!!"
end type

type pb_1 from picturebutton within w_sig715_fce_fabrica
integer x = 530
integer y = 260
integer width = 128
integer height = 104
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

type uo_4 from u_ingreso_rango_fechas within w_sig715_fce_fabrica
integer x = 869
integer y = 320
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;Date ld_fec_ini, ld_fec_fin
String ls_ano, ls_mes

ld_fec_fin = uo_1.of_get_fecha()

select usf_sig_fecha_periodo(:ld_fec_fin, 'A', 'I') into :ld_fec_ini from dual ;

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha( ld_fec_ini, ld_fec_fin) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_4.destroy
call u_ingreso_rango_fechas::destroy
end on

type gb_2 from groupbox within w_sig715_fce_fabrica
integer x = 41
integer y = 12
integer width = 658
integer height = 172
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 134217752
string text = "Fecha día"
end type

type gb_3 from groupbox within w_sig715_fce_fabrica
integer x = 846
integer y = 28
integer width = 1353
integer height = 204
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217752
string text = "Rango fecha mensual"
end type

type gb_4 from groupbox within w_sig715_fce_fabrica
integer x = 2217
integer y = 24
integer width = 1358
integer height = 204
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217752
string text = "Rango fecha trimestral"
end type

type gb_1 from groupbox within w_sig715_fce_fabrica
integer x = 50
integer y = 200
integer width = 635
integer height = 204
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217752
string text = "Alm. pp.tt."
end type

type gb_5 from groupbox within w_sig715_fce_fabrica
integer x = 841
integer y = 244
integer width = 1358
integer height = 204
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
string text = "Rango fecha anual"
end type

