$PBExportHeader$w_fi713_flujo_caja_ejt.srw
forward
global type w_fi713_flujo_caja_ejt from w_rpt
end type
type sle_moneda from n_cst_textbox within w_fi713_flujo_caja_ejt
end type
type sle_origen from singlelineedit within w_fi713_flujo_caja_ejt
end type
type st_1 from statictext within w_fi713_flujo_caja_ejt
end type
type uo_fechas from u_ingreso_rango_fechas within w_fi713_flujo_caja_ejt
end type
type tab_1 from tab within w_fi713_flujo_caja_ejt
end type
type tabpage_1 from userobject within tab_1
end type
type dw_diario from u_dw_rpt within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_diario dw_diario
end type
type tabpage_2 from userobject within tab_1
end type
type dw_semanal from u_dw_rpt within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_semanal dw_semanal
end type
type tabpage_3 from userobject within tab_1
end type
type dw_mensual from u_dw_rpt within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_mensual dw_mensual
end type
type tabpage_4 from userobject within tab_1
end type
type dw_detalle from u_dw_rpt within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_detalle dw_detalle
end type
type tab_1 from tab within w_fi713_flujo_caja_ejt
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type cb_3 from commandbutton within w_fi713_flujo_caja_ejt
end type
type cb_2 from commandbutton within w_fi713_flujo_caja_ejt
end type
type cb_1 from commandbutton within w_fi713_flujo_caja_ejt
end type
type gb_1 from groupbox within w_fi713_flujo_caja_ejt
end type
type cbx_1 from checkbox within w_fi713_flujo_caja_ejt
end type
type cb_4 from commandbutton within w_fi713_flujo_caja_ejt
end type
type sle_desc from singlelineedit within w_fi713_flujo_caja_ejt
end type
end forward

global type w_fi713_flujo_caja_ejt from w_rpt
integer width = 4690
integer height = 2952
string title = "[FI713] Reporte de Flujo de Caja Ejecutado"
string menuname = "m_reporte"
sle_moneda sle_moneda
sle_origen sle_origen
st_1 st_1
uo_fechas uo_fechas
tab_1 tab_1
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
gb_1 gb_1
cbx_1 cbx_1
cb_4 cb_4
sle_desc sle_desc
end type
global w_fi713_flujo_caja_ejt w_fi713_flujo_caja_ejt

type variables
u_dw_rpt idw_semanal, idw_mensual, idw_diario, idw_detalle


end variables

forward prototypes
public subroutine of_asigna_dws ()
end prototypes

public subroutine of_asigna_dws ();idw_diario 	= tab_1.tabpage_1.dw_diario
idw_semanal	= tab_1.tabpage_2.dw_semanal
idw_mensual	= tab_1.tabpage_3.dw_mensual
idw_detalle	= tab_1.tabpage_4.dw_detalle

end subroutine

on w_fi713_flujo_caja_ejt.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_moneda=create sle_moneda
this.sle_origen=create sle_origen
this.st_1=create st_1
this.uo_fechas=create uo_fechas
this.tab_1=create tab_1
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.gb_1=create gb_1
this.cbx_1=create cbx_1
this.cb_4=create cb_4
this.sle_desc=create sle_desc
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_moneda
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.uo_fechas
this.Control[iCurrent+5]=this.tab_1
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.cbx_1
this.Control[iCurrent+11]=this.cb_4
this.Control[iCurrent+12]=this.sle_desc
end on

on w_fi713_flujo_caja_ejt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_moneda)
destroy(this.sle_origen)
destroy(this.st_1)
destroy(this.uo_fechas)
destroy(this.tab_1)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.cbx_1)
destroy(this.cb_4)
destroy(this.sle_desc)
end on

event ue_open_pre;call super::ue_open_pre;Integer	li_year, li_semana
date		ld_Fecha1, ld_fecha2, ld_hoy

try 
	of_asigna_dws()
	
	
	idw_diario.SetTransObject(sqlca)
	idw_semanal.SetTransObject(sqlca)
	idw_mensual.SetTransObject(sqlca)
	idw_detalle.SetTransObject(sqlca)
	
	sle_moneda.text = gnvo_app.is_soles
	
	//Obtengo la semana en curso
	ld_hoy 		= Date(gnvo_app.of_fecha_Actual())
	li_year 		= Integer(string(ld_hoy, 'yyyy'))
	li_semana 	= gnvo_app.of_get_semana( ld_hoy )
	
	gnvo_app.of_get_fechas( li_year, li_Semana, ld_fecha1, ld_fecha2)
	
	uo_Fechas.of_set_fecha( ld_fecha1, ld_fecha2)
	
	//Modo Preview
	idw_1 = idw_detalle
	ib_preview = false
	event ue_preview()
	
	idw_1 = idw_diario
	
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

tab_1.width = newwidth - tab_1.x
tab_1.height = newheight - tab_1.y

idw_diario.width = tab_1.tabpage_1.width - idw_diario.x
idw_diario.height = tab_1.tabpage_1.height - idw_diario.y

idw_semanal.width = tab_1.tabpage_2.width - idw_semanal.x
idw_semanal.height = tab_1.tabpage_2.height - idw_semanal.y

idw_mensual.width = tab_1.tabpage_3.width - idw_mensual.x
idw_mensual.height = tab_1.tabpage_3.height - idw_mensual.y

idw_detalle.width = tab_1.tabpage_4.width - idw_detalle.x
idw_detalle.height = tab_1.tabpage_4.height - idw_detalle.y


idw_1 = idw_diario

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

idw_diario.retrieve(ld_fecha_inicio, ld_Fecha_final, ls_origen, ls_moneda)
idw_diario.Object.p_logo.filename 	= gs_logo
idw_diario.Object.t_origen.text 		= ls_desc_origen
idw_diario.Object.t_empresa.text 	= gs_empresa
idw_diario.Object.t_usuario.text 	= gs_user

//Caja Semanal
idw_semanal.retrieve(ld_fecha_inicio, ld_Fecha_final, ls_origen, ls_moneda)
idw_semanal.Object.p_logo.filename 	= gs_logo
idw_semanal.Object.t_origen.text 	= ls_desc_origen
idw_semanal.Object.t_empresa.text 	= gs_empresa
idw_semanal.Object.t_usuario.text 	= gs_user

//Caja Mensual
idw_mensual.retrieve(ld_fecha_inicio, ld_Fecha_final, ls_origen, ls_moneda)
idw_mensual.Object.p_logo.filename 	= gs_logo
idw_mensual.Object.t_origen.text 	= ls_desc_origen
idw_mensual.Object.t_empresa.text 	= gs_empresa
idw_mensual.Object.t_usuario.text 	= gs_user

//Detalle del flujo de caja
idw_detalle.retrieve(ld_fecha_inicio, ld_Fecha_final, ls_origen, ls_moneda)
idw_detalle.Object.p_logo.filename 	= gs_logo
idw_detalle.Object.t_origen.text 	= ls_desc_origen
idw_detalle.Object.t_empresa.text	= gs_empresa
idw_detalle.Object.t_usuario.text 	= gs_user


end event

event ue_saveas_excel;////Overwriting
//string ls_path, ls_file
//int li_rc

//li_rc = GetFileSaveName ( "Select File", &
//   ls_path, ls_file, "XLS", &
//   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

//IF li_rc = 1 Then
//   uf_save_dw_as_excel ( idw_1, ls_file )
//End If

string ls_path, ls_file
int li_rc
DataStore lds_dw8
DataWindowChild dwc_dw8
long ll_count

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
	// Crear DataStore temporal para el report dw_8
	lds_dw8 = Create DataStore
	lds_dw8.DataObject = "d_rpt_flujo_caja_ejec_res7_tbl"
	lds_dw8.SetTransObject(sqlca)
	
	// Obtener el objeto report dw_8 del DataWindow compuesto
	IF idw_1.GetChild("dw_8", dwc_dw8) = 1 THEN
		// Copiar todos los datos del report al DataStore
		ll_count = dwc_dw8.RowCount()
		IF ll_count > 0 THEN
			dwc_dw8.RowsCopy(1, ll_count, Primary!, lds_dw8, 1, Primary!)
			// Exportar el DataStore a Excel
			uf_save_ds_as_excel(lds_dw8, ls_path)
		ELSE
			MessageBox('Aviso', 'No hay datos para exportar en dw_8', StopSign!)
		END IF
	ELSE
		MessageBox('Error', 'No se pudo acceder al objeto report dw_8', StopSign!)
	END IF
	
	// Limpiar
	IF IsValid(lds_dw8) THEN Destroy lds_dw8
End If
end event

type sle_moneda from n_cst_textbox within w_fi713_flujo_caja_ejt
integer x = 1856
integer y = 64
integer width = 229
integer height = 84
integer taborder = 40
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

type sle_origen from singlelineedit within w_fi713_flujo_caja_ejt
integer x = 727
integer y = 160
integer width = 233
integer height = 88
integer taborder = 40
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

type st_1 from statictext within w_fi713_flujo_caja_ejt
integer x = 1422
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

type uo_fechas from u_ingreso_rango_fechas within w_fi713_flujo_caja_ejt
event destroy ( )
integer x = 41
integer y = 60
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

type tab_1 from tab within w_fi713_flujo_caja_ejt
event create ( )
event destroy ( )
integer y = 292
integer width = 4521
integer height = 2284
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanged;if newindex = 1 then
	idw_1 = idw_diario
elseif newindex = 2 then
	idw_1 = idw_semanal
elseif newindex = 3 then
	idw_1 = idw_mensual
else
	idw_1 = idw_detalle
end if
end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 4485
integer height = 2168
long backcolor = 67108864
string text = "Diario"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_diario dw_diario
end type

on tabpage_1.create
this.dw_diario=create dw_diario
this.Control[]={this.dw_diario}
end on

on tabpage_1.destroy
destroy(this.dw_diario)
end on

type dw_diario from u_dw_rpt within tabpage_1
integer width = 4466
integer height = 2028
integer taborder = 50
string dataobject = "d_rpt_flujo_caja_diario_cmp"
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

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 4485
integer height = 2168
long backcolor = 67108864
string text = "Semanal"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_semanal dw_semanal
end type

on tabpage_2.create
this.dw_semanal=create dw_semanal
this.Control[]={this.dw_semanal}
end on

on tabpage_2.destroy
destroy(this.dw_semanal)
end on

type dw_semanal from u_dw_rpt within tabpage_2
integer x = 9
integer width = 3511
integer height = 844
string dataobject = "d_rpt_flujo_caja_semanal_cmp"
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

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 4485
integer height = 2168
long backcolor = 67108864
string text = "Mensual"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_mensual dw_mensual
end type

on tabpage_3.create
this.dw_mensual=create dw_mensual
this.Control[]={this.dw_mensual}
end on

on tabpage_3.destroy
destroy(this.dw_mensual)
end on

type dw_mensual from u_dw_rpt within tabpage_3
integer width = 3154
integer height = 812
integer taborder = 20
string dataobject = "d_rpt_flujo_caja_mensual_tbl"
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 4485
integer height = 2168
long backcolor = 67108864
string text = "Detalle"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_detalle dw_detalle
end type

on tabpage_4.create
this.dw_detalle=create dw_detalle
this.Control[]={this.dw_detalle}
end on

on tabpage_4.destroy
destroy(this.dw_detalle)
end on

type dw_detalle from u_dw_rpt within tabpage_4
integer width = 3511
integer height = 844
string dataobject = "d_rpt_detalle_flujo_caja_tbl"
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

type cb_3 from commandbutton within w_fi713_flujo_caja_ejt
boolean visible = false
integer x = 2766
integer y = 192
integer width = 471
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string text = "Grafico Egresos"
end type

event clicked;

Open(w_abc_graph_egres_flj_eje)

end event

type cb_2 from commandbutton within w_fi713_flujo_caja_ejt
boolean visible = false
integer x = 2775
integer y = 88
integer width = 471
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string text = "Grafico Ingresos"
end type

event clicked;
Open(w_abc_graph_ing_flj_eje )

end event

type cb_1 from commandbutton within w_fi713_flujo_caja_ejt
integer x = 2144
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

type gb_1 from groupbox within w_fi713_flujo_caja_ejt
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

type cbx_1 from checkbox within w_fi713_flujo_caja_ejt
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

type cb_4 from commandbutton within w_fi713_flujo_caja_ejt
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

type sle_desc from singlelineedit within w_fi713_flujo_caja_ejt
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

