$PBExportHeader$w_rh607_rpt_asiento_remuneraciones.srw
forward
global type w_rh607_rpt_asiento_remuneraciones from w_rpt
end type
type cbx_1 from checkbox within w_rh607_rpt_asiento_remuneraciones
end type
type uo_1 from u_ingreso_rango_fechas within w_rh607_rpt_asiento_remuneraciones
end type
type cbx_origen from checkbox within w_rh607_rpt_asiento_remuneraciones
end type
type cbx_ttrab from checkbox within w_rh607_rpt_asiento_remuneraciones
end type
type cb_3 from commandbutton within w_rh607_rpt_asiento_remuneraciones
end type
type sle_origen from singlelineedit within w_rh607_rpt_asiento_remuneraciones
end type
type st_3 from statictext within w_rh607_rpt_asiento_remuneraciones
end type
type sle_ttrabajador from singlelineedit within w_rh607_rpt_asiento_remuneraciones
end type
type st_2 from statictext within w_rh607_rpt_asiento_remuneraciones
end type
type cb_2 from commandbutton within w_rh607_rpt_asiento_remuneraciones
end type
type cb_1 from commandbutton within w_rh607_rpt_asiento_remuneraciones
end type
type dw_report from u_dw_rpt within w_rh607_rpt_asiento_remuneraciones
end type
type gb_1 from groupbox within w_rh607_rpt_asiento_remuneraciones
end type
end forward

global type w_rh607_rpt_asiento_remuneraciones from w_rpt
integer width = 3392
integer height = 2176
string title = "Resumen de Asiento de Remuneraciones (RRHH607)"
string menuname = "m_impresion"
long backcolor = 12632256
cbx_1 cbx_1
uo_1 uo_1
cbx_origen cbx_origen
cbx_ttrab cbx_ttrab
cb_3 cb_3
sle_origen sle_origen
st_3 st_3
sle_ttrabajador sle_ttrabajador
st_2 st_2
cb_2 cb_2
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_rh607_rpt_asiento_remuneraciones w_rh607_rpt_asiento_remuneraciones

on w_rh607_rpt_asiento_remuneraciones.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cbx_1=create cbx_1
this.uo_1=create uo_1
this.cbx_origen=create cbx_origen
this.cbx_ttrab=create cbx_ttrab
this.cb_3=create cb_3
this.sle_origen=create sle_origen
this.st_3=create st_3
this.sle_ttrabajador=create sle_ttrabajador
this.st_2=create st_2
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.cbx_origen
this.Control[iCurrent+4]=this.cbx_ttrab
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.sle_origen
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.sle_ttrabajador
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.dw_report
this.Control[iCurrent+13]=this.gb_1
end on

on w_rh607_rpt_asiento_remuneraciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.uo_1)
destroy(this.cbx_origen)
destroy(this.cbx_ttrab)
destroy(this.cb_3)
destroy(this.sle_origen)
destroy(this.st_3)
destroy(this.sle_ttrabajador)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = FALSE
THIS.Event ue_preview()

end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type cbx_1 from checkbox within w_rh607_rpt_asiento_remuneraciones
integer x = 1472
integer y = 40
integer width = 832
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Libro Contable de C.T.S"
end type

type uo_1 from u_ingreso_rango_fechas within w_rh607_rpt_asiento_remuneraciones
integer x = 64
integer y = 128
integer taborder = 30
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(date('01/01/1900'), date('31/12/9999')) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cbx_origen from checkbox within w_rh607_rpt_asiento_remuneraciones
integer x = 978
integer y = 380
integer width = 343
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Todos"
end type

type cbx_ttrab from checkbox within w_rh607_rpt_asiento_remuneraciones
integer x = 978
integer y = 280
integer width = 343
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Todos"
end type

type cb_3 from commandbutton within w_rh607_rpt_asiento_remuneraciones
integer x = 814
integer y = 384
integer width = 110
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO      , '&
								       +'ORIGEN.NOMBRE     AS DESCRIPCION   '&
				   				 	 +'FROM ORIGEN '&

														 
														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_origen.text = lstr_seleccionar.param1[1]
END IF														 

end event

type sle_origen from singlelineedit within w_rh607_rpt_asiento_remuneraciones
integer x = 594
integer y = 380
integer width = 183
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_rh607_rpt_asiento_remuneraciones
integer x = 78
integer y = 392
integer width = 507
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_ttrabajador from singlelineedit within w_rh607_rpt_asiento_remuneraciones
integer x = 594
integer y = 280
integer width = 183
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_rh607_rpt_asiento_remuneraciones
integer x = 73
integer y = 296
integer width = 507
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Tipo de Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rh607_rpt_asiento_remuneraciones
integer x = 809
integer y = 280
integer width = 110
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT TIPO_TRABAJADOR.TIPO_TRABAJADOR AS TTRABAJADOR , '&
								       +'TIPO_TRABAJADOR.DESC_TIPO_TRA   AS DESCRIPCION , '&
										 +'TIPO_TRABAJADOR.LIBRO_PLANILLA  AS NRO_LIBRO   , '&
										 +'TIPO_TRABAJADOR.LIBRO_PROV_CTS	  AS LIBRO_CTS	    '&
				   				 	 +'FROM TIPO_TRABAJADOR '

														 
														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_ttrabajador.text = lstr_seleccionar.param1[1]
END IF														 

end event

type cb_1 from commandbutton within w_rh607_rpt_asiento_remuneraciones
integer x = 2985
integer y = 28
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;str_seleccionar_rh lstr_struct
Integer li_arr
Long	  ll_libro,ll_libro_cts
String  ls_origen,ls_tipo,ls_fecha_inicial,ls_fecha_final

//inicializa arreglo
li_arr = 1
	
if cbx_origen.checked then
	//llena arreglo para origenes


	//CURSOR DE ESTRUCTURA DE USUARIO
	DECLARE origen_usr CURSOR FOR
	 select oao.cod_origen from ot_adm_origen oao ,ot_adm_usuario oau
     where (oao.ot_adm  = oau.ot_adm ) and (oau.cod_usr = :gs_user   ) ;

	/*Abrir Cursor*/		  	
	OPEN origen_usr ;
	
	DO 				/*Recorro Cursor*/	
	 FETCH origen_usr INTO :ls_origen ;
	 
		IF sqlca.sqlcode = 100 THEN EXIT

	   /**Inserción de Arreglo**/ 
	 	lstr_struct.param1 [li_arr] = ls_origen
	 	li_arr = li_arr + 1
	 
	LOOP WHILE TRUE
	
	CLOSE origen_usr ; /*Cierra Cursor*/
	
else
	
	lstr_struct.param1 [li_arr] = sle_origen.text
	
end if

//inicializa arreglo
li_arr = 1


//tipo de trabajadores
if cbx_ttrab.checked then
		//llena arreglo para origenes
	li_arr = li_arr + 1

	//CURSOR DE ESTRUCTURA DE USUARIO
	DECLARE tip_trab CURSOR FOR
	 select libro_planilla,libro_prov_cts  from tipo_trabajador ;

	/*Abrir Cursor*/		  	
	OPEN tip_trab ;
	
	DO 				/*Recorro Cursor*/	
	 FETCH tip_trab INTO :ll_libro,:ll_libro_cts ;
	 
		IF sqlca.sqlcode = 100 THEN EXIT

	   /**Inserción de Arreglo**/ 
		if cbx_1.checked then
			ll_libro = ll_libro_cts	
		end if
		
		
	 	lstr_struct.paraml1 [li_arr] = ll_libro
	 	li_arr = li_arr + 1
	 
	LOOP WHILE TRUE
	
	CLOSE tip_trab ; /*Cierra Cursor*/
else
	//busco nro de libro
	SELECT libro_planilla,libro_prov_cts 
	  INTO :ll_libro, :ll_libro_cts 
	  FROM tipo_trabajador 
	 WHERE tipo_trabajador = :sle_ttrabajador.text ;
	
	if cbx_1.checked then
		ll_libro = ll_libro_cts	
	end if
	
	lstr_struct.paraml1 [li_arr] = ll_libro
	
end if

/**/
ls_fecha_inicial = String(uo_1.of_get_fecha1(),'yyyymmdd')
ls_fecha_final   = String(uo_1.of_get_fecha2(),'yyyymmdd')







dw_report.Retrieve(lstr_struct.paraml1,lstr_struct.param1,ls_fecha_inicial,ls_fecha_final)




end event

type dw_report from u_dw_rpt within w_rh607_rpt_asiento_remuneraciones
integer x = 23
integer y = 536
integer width = 3305
integer height = 1360
string dataobject = "d_asiento_resumen_remun_tbl_bk"
end type

type gb_1 from groupbox within w_rh607_rpt_asiento_remuneraciones
integer x = 37
integer y = 20
integer width = 1362
integer height = 480
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "&Procesar"
end type

