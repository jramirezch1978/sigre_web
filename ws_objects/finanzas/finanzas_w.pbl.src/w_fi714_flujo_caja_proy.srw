$PBExportHeader$w_fi714_flujo_caja_proy.srw
forward
global type w_fi714_flujo_caja_proy from w_rpt
end type
type sle_moneda from n_cst_textbox within w_fi714_flujo_caja_proy
end type
type st_1 from statictext within w_fi714_flujo_caja_proy
end type
type dw_reporte from u_dw_rpt within w_fi714_flujo_caja_proy
end type
type uo_fechas from u_ingreso_rango_fechas within w_fi714_flujo_caja_proy
end type
type cb_1 from commandbutton within w_fi714_flujo_caja_proy
end type
type gb_1 from groupbox within w_fi714_flujo_caja_proy
end type
type cbx_1 from checkbox within w_fi714_flujo_caja_proy
end type
type sle_origen from singlelineedit within w_fi714_flujo_caja_proy
end type
type cb_4 from commandbutton within w_fi714_flujo_caja_proy
end type
type sle_desc from singlelineedit within w_fi714_flujo_caja_proy
end type
end forward

global type w_fi714_flujo_caja_proy from w_rpt
integer width = 3589
integer height = 1628
string title = "[FI714] Reporte de Flujo Mensual de Caja Proyectado"
string menuname = "m_reporte"
sle_moneda sle_moneda
st_1 st_1
dw_reporte dw_reporte
uo_fechas uo_fechas
cb_1 cb_1
gb_1 gb_1
cbx_1 cbx_1
sle_origen sle_origen
cb_4 cb_4
sle_desc sle_desc
end type
global w_fi714_flujo_caja_proy w_fi714_flujo_caja_proy

type variables



end variables

forward prototypes
public subroutine of_asigna_dws ()
end prototypes

public subroutine of_asigna_dws ();
end subroutine

on w_fi714_flujo_caja_proy.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_moneda=create sle_moneda
this.st_1=create st_1
this.dw_reporte=create dw_reporte
this.uo_fechas=create uo_fechas
this.cb_1=create cb_1
this.gb_1=create gb_1
this.cbx_1=create cbx_1
this.sle_origen=create sle_origen
this.cb_4=create cb_4
this.sle_desc=create sle_desc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_moneda
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_reporte
this.Control[iCurrent+4]=this.uo_fechas
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.sle_origen
this.Control[iCurrent+9]=this.cb_4
this.Control[iCurrent+10]=this.sle_desc
end on

on w_fi714_flujo_caja_proy.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_moneda)
destroy(this.st_1)
destroy(this.dw_reporte)
destroy(this.uo_fechas)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.cbx_1)
destroy(this.sle_origen)
destroy(this.cb_4)
destroy(this.sle_desc)
end on

event ue_open_pre;call super::ue_open_pre;try 
	of_asigna_dws()
	
	Integer	li_year, li_semana
	date		ld_Fecha1, ld_fecha2, ld_hoy
	
	dw_reporte.SetTransObject(sqlca)
	
	//Obtengo la semana en curso
	ld_hoy = Date(gnvo_app.of_fecha_Actual())
	li_year = Integer(string(ld_hoy, 'yyyy'))
	li_semana = gnvo_app.of_get_semana( ld_hoy )
	
	gnvo_app.of_get_fechas( li_year, li_Semana, ld_fecha1, ld_fecha2)
	
	uo_Fechas.of_set_fecha( ld_fecha1, ld_fecha2)
	
	//Modo Preview
	ib_preview = true
	event ue_preview()
	
	idw_1 = dw_reporte
	
catch ( Exception ex )
	
	MessageBox('Error', 'Ha ocurrido una excepcion: ' + ex.getMessage())
end try



end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;of_asigna_dws()

dw_reporte.width = newwidth - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y

idw_1 = dw_reporte

end event

event ue_filter;call super::ue_filter;idw_1.groupcalc( )
end event

event ue_retrieve;call super::ue_retrieve;Date   ld_fecha_inicio,ld_fecha_final
String ls_origen, ls_desc_origen, ls_moneda

ld_fecha_inicio = uo_fechas.of_get_fecha1()
ld_fecha_final	 = uo_fechas.of_get_fecha2()

IF String(ld_fecha_inicio,'yyyy') <> String(ld_fecha_final,'yyyy') THEN
	Messagebox('Aviso','Las fechas no debe ser de Diferentes Años', stopSign!)
	Return
END IF

// Evalua el tipo de origen selecionado
if cbx_1.checked  then
	ls_origen = '%%'
	ls_desc_origen  = 'Todos los Origenes'
else
	if trim(sle_origen.text) = '' then
		Messagebox('Aviso','Debe especificar un origen, por favor corrija!', stopSign!)
		sle_origen.setFocus()
		return
	end if
		
	ls_origen =  trim(sle_origen.text) + '%'
	ls_desc_origen  = 'ORIGEN: '+trim(sle_origen.text)+' - ' + sle_desc.text
	
end if

if trim(sle_moneda.text) = '' then
	Messagebox('Aviso','Debe especificar una moneda, por favor corrija!', stopSign!)
	sle_moneda.setFocus()
	return
end if

ls_moneda = trim(sle_moneda.text)

ls_desc_origen  += ' MONEDA ('+ trim(ls_moneda) + ')'


//Detalle del flujo de caja
dw_reporte.retrieve(ld_fecha_inicio, ld_Fecha_final, ls_origen, ls_moneda)
dw_reporte.Object.p_logo.filename 	= gs_logo
dw_reporte.Object.t_origen.text 		= ls_desc_origen
dw_reporte.Object.t_empresa.text		= gs_empresa
dw_reporte.Object.t_usuario.text 	= gs_user


end event

type sle_moneda from n_cst_textbox within w_fi714_flujo_caja_proy
integer x = 1774
integer y = 64
integer width = 229
integer height = 84
integer taborder = 50
integer textsize = -8
end type

event modified;call super::modified;String 	ls_desc, ls_codigo

ls_codigo = this.text

if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un Código de moneda', StopSign!)
	return
end if

SELECT descripcion 
	INTO :ls_desc
FROM moneda 
where cod_moneda = :ls_codigo ;


IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Moneda no existe, por favor verifique! ', StopSign!)
	return
end if


end event

event ue_dobleclick;call super::ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_moneda AS codigo_moneda, " &
	  	 + "descripcion AS DESCRIPCION_moneda " &
	    + "FROM moneda " &
		 + "where flag_estado <> 'O'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
end if

end event

type st_1 from statictext within w_fi714_flujo_caja_proy
integer x = 1339
integer y = 80
integer width = 402
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_reporte from u_dw_rpt within w_fi714_flujo_caja_proy
integer y = 292
integer width = 3511
integer height = 844
string dataobject = "d_rpt_flujo_caja_proy_mensual_tbl"
end type

event doubleclicked;call super::doubleclicked;String ls_mes,ls_sgrp_fcaja,ls_cod_fcaja,ls_flag_ing_egr
str_seleccionar lstr_param

IF row = 0 THEN RETURN

CHOOSE CASE dwo.name
		 CASE 'monto_enero','monto_febrero','monto_marzo' ,'monto_abril'    ,'monto_mayo'   ,&
			   'monto_junio','monto_julio'  ,'monto_agosto','monto_setiembre','monto_octubre',&
				'monto_noviembre','monto_diciembre'
				
				if     dwo.name = 'monto_enero'     THEN 
					ls_mes = '01'
				elseif dwo.name = 'monto_febrero'   THEN 
					ls_mes = '02'
				elseif dwo.name = 'monto_marzo'     THEN 
					ls_mes = '03'
				elseif dwo.name = 'monto_abril'     THEN 
					ls_mes = '04'
				elseif dwo.name = 'monto_mayo'      THEN 
					ls_mes = '05'
				elseif dwo.name = 'monto_junio'     THEN 
					ls_mes = '06'
				elseif dwo.name = 'monto_julio'     THEN 
					ls_mes = '07'
				elseif dwo.name = 'monto_agosto'    THEN 
					ls_mes = '08'
				elseif dwo.name = 'monto_setiembre' THEN 
					ls_mes = '09'
				elseif dwo.name = 'monto_octubre'   THEN 
					ls_mes = '10'
				elseif dwo.name = 'monto_noviembre' THEN 
					ls_mes = '11'
				elseif dwo.name = 'monto_diciembre' THEN 	
					ls_mes = '12'
				end if	
				
				ls_sgrp_fcaja   = this.object.sub_grp_fcaja  [row]
				ls_cod_fcaja    = this.object.cod_flujo_caja [row]
				ls_flag_ing_egr = this.object.flag_ing_egr   [row]
				
				lstr_param.param1[1] = ls_mes
				lstr_param.param1[2] = ls_sgrp_fcaja
				lstr_param.param1[3] = ls_cod_fcaja
				lstr_param.param1[4] = ls_flag_ing_egr
				

				
				//OpenSheetWithParm(w_cns_flujo_caja_eje_det_tbl,lstr_param,parent, 0, Original!)
				
END CHOOSE
end event

type uo_fechas from u_ingreso_rango_fechas within w_fi714_flujo_caja_proy
event destroy ( )
integer x = 41
integer y = 72
integer taborder = 30
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date	ld_fecha_actual

ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha_actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type cb_1 from commandbutton within w_fi714_flujo_caja_proy
integer x = 2057
integer y = 64
integer width = 480
integer height = 160
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Reporte"
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_retrieve( )
SetPointer(Arrow!)
end event

type gb_1 from groupbox within w_fi714_flujo_caja_proy
integer width = 2647
integer height = 280
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Fechas y Selecciona Origen"
end type

type cbx_1 from checkbox within w_fi714_flujo_caja_proy
integer x = 23
integer y = 168
integer width = 667
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
string text = "Todos Los Origenes "
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_origen.enabled = false
	sle_origen.text = ""
	sle_desc.text = "TODAS"
else
	sle_origen.enabled = true
	sle_desc.text = ""
end if
end event

type sle_origen from singlelineedit within w_fi714_flujo_caja_proy
integer x = 727
integer y = 160
integer width = 233
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_origen,ls_desc
Long   ll_count


ls_origen = this.text


select count(*) into :ll_count 
  from origen 
 where cod_origen = :ls_origen ;
 
IF ll_count > 0 THEN
	select nombre into :ls_desc from origen 
	 where cod_origen = :ls_origen ;
	 
	sle_desc.text = ls_desc
ELSE
	Setnull(ls_desc)
	sle_desc.text = ls_desc
END IF
 

end event

type cb_4 from commandbutton within w_fi714_flujo_caja_proy
integer x = 969
integer y = 160
integer width = 96
integer height = 88
integer taborder = 40
boolean bringtotop = true
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
lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO ,'&
				      				 +'ORIGEN.NOMBRE AS DESCRIPCION '&
				   					 +'FROM ORIGEN '

														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
   sle_origen.text =  lstr_seleccionar.param1[1]
   sle_desc.text   =  lstr_seleccionar.param2[1]
END IF

end event

type sle_desc from singlelineedit within w_fi714_flujo_caja_proy
integer x = 1088
integer y = 160
integer width = 846
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

