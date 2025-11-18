$PBExportHeader$w_rh300_reportes_param.srw
forward
global type w_rh300_reportes_param from w_cns
end type
type tab_reporte from tab within w_rh300_reportes_param
end type
type tp_1 from userobject within tab_reporte
end type
type dw_master from u_dw_cns within tp_1
end type
type tp_1 from userobject within tab_reporte
dw_master dw_master
end type
type tp_2 from userobject within tab_reporte
end type
type sle_paginador from singlelineedit within tp_2
end type
type p_17 from picture within tp_2
end type
type sle_titulo from singlelineedit within tp_2
end type
type rb_print_no from radiobutton within tp_2
end type
type rb_print_si from radiobutton within tp_2
end type
type p_16 from picture within tp_2
end type
type p_15 from picture within tp_2
end type
type rb_historico_no from radiobutton within tp_2
end type
type rb_historico_si from radiobutton within tp_2
end type
type p_14 from picture within tp_2
end type
type ddlb_secciones from u_ddlb_lista within tp_2
end type
type p_9 from picture within tp_2
end type
type ddlb_afp from u_ddlb_lista within tp_2
end type
type cbx_afp from checkbox within tp_2
end type
type p_13 from picture within tp_2
end type
type cbx_trabajador from checkbox within tp_2
end type
type ddlb_areas from u_ddlb_lista within tp_2
end type
type cbx_secciones from checkbox within tp_2
end type
type ddlb_centros_costo from u_ddlb_lista within tp_2
end type
type ddlb_cencos_niv1 from u_ddlb_lista within tp_2
end type
type cbx_centros_costo from checkbox within tp_2
end type
type p_10 from picture within tp_2
end type
type p_3 from picture within tp_2
end type
type rb_afp_todos from radiobutton within tp_2
end type
type rb_afp_no from radiobutton within tp_2
end type
type rb_afp_si from radiobutton within tp_2
end type
type p_11 from picture within tp_2
end type
type rb_tarjeta_no from radiobutton within tp_2
end type
type rb_tarjeta_si from radiobutton within tp_2
end type
type rb_tarjeta_todos from radiobutton within tp_2
end type
type p_7 from picture within tp_2
end type
type dw_trabajador from datawindow within tp_2
end type
type ddlb_concepto from listbox within tp_2
end type
type p_12 from picture within tp_2
end type
type cbx_concepto from checkbox within tp_2
end type
type gb_concepto from groupbox within tp_2
end type
type gb_6 from groupbox within tp_2
end type
type gb_4 from groupbox within tp_2
end type
type gb_9 from groupbox within tp_2
end type
type gb_7 from groupbox within tp_2
end type
type gb_5 from groupbox within tp_2
end type
type gb_11 from groupbox within tp_2
end type
type gb_10 from groupbox within tp_2
end type
type gb_13 from groupbox within tp_2
end type
type gb_14 from groupbox within tp_2
end type
type gb_12 from groupbox within tp_2
end type
type tp_2 from userobject within tab_reporte
sle_paginador sle_paginador
p_17 p_17
sle_titulo sle_titulo
rb_print_no rb_print_no
rb_print_si rb_print_si
p_16 p_16
p_15 p_15
rb_historico_no rb_historico_no
rb_historico_si rb_historico_si
p_14 p_14
ddlb_secciones ddlb_secciones
p_9 p_9
ddlb_afp ddlb_afp
cbx_afp cbx_afp
p_13 p_13
cbx_trabajador cbx_trabajador
ddlb_areas ddlb_areas
cbx_secciones cbx_secciones
ddlb_centros_costo ddlb_centros_costo
ddlb_cencos_niv1 ddlb_cencos_niv1
cbx_centros_costo cbx_centros_costo
p_10 p_10
p_3 p_3
rb_afp_todos rb_afp_todos
rb_afp_no rb_afp_no
rb_afp_si rb_afp_si
p_11 p_11
rb_tarjeta_no rb_tarjeta_no
rb_tarjeta_si rb_tarjeta_si
rb_tarjeta_todos rb_tarjeta_todos
p_7 p_7
dw_trabajador dw_trabajador
ddlb_concepto ddlb_concepto
p_12 p_12
cbx_concepto cbx_concepto
gb_concepto gb_concepto
gb_6 gb_6
gb_4 gb_4
gb_9 gb_9
gb_7 gb_7
gb_5 gb_5
gb_11 gb_11
gb_10 gb_10
gb_13 gb_13
gb_14 gb_14
gb_12 gb_12
end type
type tab_reporte from tab within w_rh300_reportes_param
tp_1 tp_1
tp_2 tp_2
end type
type cb_1 from commandbutton within w_rh300_reportes_param
end type
type uo_fecha from u_fecha within w_rh300_reportes_param
end type
type rb_fecha from radiobutton within w_rh300_reportes_param
end type
type ddlb_tipo_trabajador from u_ddlb_lista within w_rh300_reportes_param
end type
type em_ano_m from editmask within w_rh300_reportes_param
end type
type st_ano_m from statictext within w_rh300_reportes_param
end type
type ddlb_mes_m from dropdownlistbox within w_rh300_reportes_param
end type
type st_mes_m from statictext within w_rh300_reportes_param
end type
type rb_mes from radiobutton within w_rh300_reportes_param
end type
type p_8 from picture within w_rh300_reportes_param
end type
type p_6 from picture within w_rh300_reportes_param
end type
type p_5 from picture within w_rh300_reportes_param
end type
type p_4 from picture within w_rh300_reportes_param
end type
type st_etiqueta from statictext within w_rh300_reportes_param
end type
type cbx_periodo from checkbox within w_rh300_reportes_param
end type
type cbx_tipo_trabajador from checkbox within w_rh300_reportes_param
end type
type p_2 from picture within w_rh300_reportes_param
end type
type p_1 from picture within w_rh300_reportes_param
end type
type uo_rango from u_rango_fechas within w_rh300_reportes_param
end type
type rb_semana from radiobutton within w_rh300_reportes_param
end type
type rb_semana_fecha from radiobutton within w_rh300_reportes_param
end type
type rb_rango_fecha from radiobutton within w_rh300_reportes_param
end type
type cbx_origen from checkbox within w_rh300_reportes_param
end type
type rb_grafico from radiobutton within w_rh300_reportes_param
end type
type rb_texto from radiobutton within w_rh300_reportes_param
end type
type gb_1 from groupbox within w_rh300_reportes_param
end type
type gb_2 from groupbox within w_rh300_reportes_param
end type
type ddlb_origen from u_ddlb_lista within w_rh300_reportes_param
end type
type st_sem from statictext within w_rh300_reportes_param
end type
type em_sem from editmask within w_rh300_reportes_param
end type
type st_ano from statictext within w_rh300_reportes_param
end type
type em_ano from editmask within w_rh300_reportes_param
end type
type uo_semana from u_semana_fecha within w_rh300_reportes_param
end type
type gb_3 from groupbox within w_rh300_reportes_param
end type
type gb_8 from groupbox within w_rh300_reportes_param
end type
type p_procesando from picture within w_rh300_reportes_param
end type
type st_procesando_title from statictext within w_rh300_reportes_param
end type
type st_procesando_status from statictext within w_rh300_reportes_param
end type
type st_procesando from statictext within w_rh300_reportes_param
end type
type mle_1 from multilineedit within w_rh300_reportes_param
end type
end forward

global type w_rh300_reportes_param from w_cns
integer width = 3598
integer height = 2040
boolean titlebar = false
string title = ""
string menuname = "m_impresion"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean border = false
boolean center = true
event ue_query_retrieve ( )
event ue_zoom ( integer ai_zoom )
event ue_preview ( )
event ue_cambio_graph ( integer ai_graph_order )
event ue_saveas ( )
event ue_hide_detail ( )
tab_reporte tab_reporte
cb_1 cb_1
uo_fecha uo_fecha
rb_fecha rb_fecha
ddlb_tipo_trabajador ddlb_tipo_trabajador
em_ano_m em_ano_m
st_ano_m st_ano_m
ddlb_mes_m ddlb_mes_m
st_mes_m st_mes_m
rb_mes rb_mes
p_8 p_8
p_6 p_6
p_5 p_5
p_4 p_4
st_etiqueta st_etiqueta
cbx_periodo cbx_periodo
cbx_tipo_trabajador cbx_tipo_trabajador
p_2 p_2
p_1 p_1
uo_rango uo_rango
rb_semana rb_semana
rb_semana_fecha rb_semana_fecha
rb_rango_fecha rb_rango_fecha
cbx_origen cbx_origen
rb_grafico rb_grafico
rb_texto rb_texto
gb_1 gb_1
gb_2 gb_2
ddlb_origen ddlb_origen
st_sem st_sem
em_sem em_sem
st_ano st_ano
em_ano em_ano
uo_semana uo_semana
gb_3 gb_3
gb_8 gb_8
p_procesando p_procesando
st_procesando_title st_procesando_title
st_procesando_status st_procesando_status
st_procesando st_procesando
mle_1 mle_1
end type
global w_rh300_reportes_param w_rh300_reportes_param

type variables
integer ii_zi, ii_zoom, ii_zoom_actual, ii_carga_sem, ii_charged_dw, ii_dw_ypos, ii_select_cantidad, ii_select_cantidad_grf
string is_origen, is_tipo_trabajador, is_old_sql, is_old_from, is_old_where, is_old_order, is_old_sql_graph, is_old_from_graph, is_old_where_graph, is_old_order_graph, is_datawindow_tabla, is_datawindow_graph, is_title, is_rango_fecha, is_graph_title, is_graph
Boolean	ib_preview = false
long il_detail_height
str_reporte_param istr_reporte_param
end variables

forward prototypes
public subroutine of_cambio_grf (integer ai_direccion)
public subroutine of_recibe_param ()
public subroutine of_carga_dw_tabular ()
public subroutine of_carga_dw_grafico ()
end prototypes

event ue_query_retrieve();st_procesando.visible = true
st_procesando_title.visible = true
st_procesando_status.visible = true
p_procesando.visible = true

if not isnull(istr_reporte_param.procedure_name) then 
	execute immediate :istr_reporte_param.procedure_name;
end if

if rb_texto.checked then
	of_carga_dw_tabular()
else
	of_carga_dw_grafico()
end if

ib_preview = false
this.event ue_preview()

if tab_reporte.tp_2.rb_print_si.checked = true then tab_reporte.tp_1.dw_master.print(true)

p_procesando.visible = false
st_procesando_title.visible = false
st_procesando_status.visible = false
st_procesando.visible = false
tab_reporte.selectedtab = 1

string ls_titulo
ls_titulo = string(tab_reporte.tp_2.sle_titulo.text)
tab_reporte.tp_1.dw_master.object.st_titulo.text = ls_titulo


//paginador
if Len(tab_reporte.tp_2.sle_paginador.text) > 0 then
	tab_reporte.tp_1.dw_master.object.nro_planilla_t.text = tab_reporte.tp_2.sle_paginador.text
end if	

end event

event ue_zoom(integer ai_zoom);if ib_preview = false then return
tab_reporte.tp_1.dw_master.EVENT ue_zoom(ai_zoom)
end event

event ue_preview();IF ib_preview THEN
	tab_reporte.tp_1.dw_master.Modify("DataWindow.Print.Preview=No")
	tab_reporte.tp_1.dw_master.Modify("datawindow.print.preview.zoom = " + String(ii_zoom_actual))
	tab_reporte.tp_1.dw_master.title = "Reporte " + " (Zoom: " + String(ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	tab_reporte.tp_1.dw_master.Modify("DataWindow.Print.Preview=Yes")
	tab_reporte.tp_1.dw_master.Modify("datawindow.print.preview.zoom = " + String(ii_zoom_actual))
	tab_reporte.tp_1.dw_master.title = "Reporte " + " (Zoom: " + String(ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF

end event

event ue_cambio_graph(integer ai_graph_order);if rb_texto.checked = true then return
of_cambio_grf(ai_graph_order)
end event

event ue_saveas();idw_1.saveas()
end event

event ue_hide_detail();if rb_grafico.checked = true then return
if idw_1.rowcount() <= 0 then return

if long(idw_1.Object.DataWindow.Detail.Height) = 0 then
	idw_1.Object.DataWindow.Detail.Height = il_detail_height
else
	idw_1.Object.DataWindow.Detail.Height = 0
end if
end event

public subroutine of_cambio_grf (integer ai_direccion);Integer	li_tipo_grf

li_tipo_grf = Integer(idw_1.Object.gr_1.GraphType)


IF ai_direccion = -1 THEN
	li_tipo_grf --
	IF li_tipo_grf <1 THEN li_tipo_grf = 17
ELSE
	li_tipo_grf ++
	IF li_tipo_grf > 17 THEN li_tipo_grf = 1
END IF

idw_1.Object.gr_1.GraphType = li_tipo_grf
end subroutine

public subroutine of_recibe_param ();string ls_campo_tarjeta, ls_campo_origen, ls_campo_tipo_trabajador, ls_campo_seccion, ls_campo_empleado, ls_campo_fecha, ls_titulo
boolean lb_usa_grafico
//str_reporte_param lstr_reporte_param

istr_reporte_param = message.powerobjectparm

ls_titulo = trim(istr_reporte_param.datawindows_title)
this.title = "(RH300) - " + ls_titulo 

is_datawindow_tabla = trim(istr_reporte_param.datawindows_name) + '_tbl'
is_datawindow_graph = trim(istr_reporte_param.datawindows_name) + '_grf'

lb_usa_grafico = istr_reporte_param.usa_grafico

ii_select_cantidad = 1
ii_select_cantidad_grf = 1

ls_campo_tarjeta = istr_reporte_param.campo_tarjeta[1]
ls_campo_origen = istr_reporte_param.campo_origen[1]
ls_campo_tipo_trabajador = istr_reporte_param.campo_tipo_trabajador[1]
ls_campo_seccion = istr_reporte_param.campo_seccion[1]
ls_campo_empleado = istr_reporte_param.campo_trabajador[1]
ls_campo_fecha = istr_reporte_param.campo_fecha[1]

is_title = istr_reporte_param.windows_title
tab_reporte.tp_2.sle_titulo.text = is_title

if isnull(lb_usa_grafico) or lb_usa_grafico = false then
	rb_grafico.enabled = false
else
	rb_grafico.enabled = true
end if

if isnull(ls_campo_tarjeta) or trim(ls_campo_tarjeta) = '' then
	tab_reporte.tp_2.rb_tarjeta_todos.enabled = false
	tab_reporte.tp_2.rb_tarjeta_si.enabled = false
	tab_reporte.tp_2.rb_tarjeta_no.enabled = false
else
	tab_reporte.tp_2.rb_tarjeta_todos.enabled = true
	tab_reporte.tp_2.rb_tarjeta_si.enabled = true
	tab_reporte.tp_2.rb_tarjeta_no.enabled = true
end if

if isnull(ls_campo_origen) or trim(ls_campo_origen) = '' then
	cbx_origen.enabled = false
else
	cbx_origen.enabled = true
end if

if isnull(ls_campo_tipo_trabajador) or trim(ls_campo_tipo_trabajador) = '' then
	cbx_tipo_trabajador.enabled = false
else
	cbx_tipo_trabajador.enabled = true
end if

if isnull(ls_campo_seccion) or trim(ls_campo_seccion) = '' then
	tab_reporte.tp_2.cbx_secciones.enabled = false
else
	tab_reporte.tp_2.cbx_secciones.enabled = true
end if

if isnull(ls_campo_empleado) or trim(ls_campo_empleado) = '' then
	tab_reporte.tp_2.cbx_trabajador.enabled = false
else
	tab_reporte.tp_2.cbx_trabajador.enabled = true
end if

if isnull(ls_campo_fecha) or trim(ls_campo_fecha) = '' then
	cbx_periodo.enabled = false
	rb_mes.enabled = false
	rb_rango_fecha.enabled = false
	rb_semana.enabled = false
	rb_semana_fecha.enabled = false
	rb_fecha.enabled = false
	ddlb_mes_m.enabled = false
	em_ano_m.enabled = false
else
	cbx_periodo.enabled = true
	rb_mes.enabled = true
	rb_rango_fecha.enabled = true
	rb_semana.enabled = true
	rb_semana_fecha.enabled = true
	rb_fecha.enabled = true
	ddlb_mes_m.enabled = true
	em_ano_m.enabled = true
end if

if istr_reporte_param.select_historico = true and istr_reporte_param.select_historico_grf = true then
	tab_reporte.tp_2.rb_historico_si.enabled = true
	tab_reporte.tp_2.rb_historico_no.enabled = true
else
	tab_reporte.tp_2.rb_historico_si.enabled = false
	tab_reporte.tp_2.rb_historico_no.enabled = false
end if

end subroutine

public subroutine of_carga_dw_tabular ();string 	ls_new_sql, ls_select_campos, ls_select_from, ls_select_where, &
			ls_campo_origen, ls_campo_tarjeta, ls_campo_tipo_trabajador, &
			ls_campo_area, ls_campo_seccion, ls_campo_fecha, ls_campo_trabajador, &
			ls_ini, ls_fin, ls_rango_texto, ls_fecha_reporte, ls_campo_cencos, &
			ls_campo_cod_afp, ls_campo_concep, ls_procedure, ls_concep
integer 	li_cuenta, li_ano, li_mes, li_sem
long 		ll_concep
boolean 	lb_selected_concep


ls_new_sql = ""
st_procesando_status.text = 'ARMANDO CONSULTA DE DATOS'

for li_cuenta = 1 to ii_select_cantidad 
	if li_cuenta >= 2 then ls_new_sql = ls_new_sql + " union all "
	//estructura del query
	ls_select_campos = trim(istr_reporte_param.select_campos[li_cuenta])
	ls_select_from = trim(istr_reporte_param.select_from[li_cuenta])
	ls_select_where = trim(istr_reporte_param.select_where[li_cuenta])
	//nombres de los campos
	ls_campo_origen = istr_reporte_param.campo_origen[li_cuenta]
	ls_campo_tipo_trabajador = istr_reporte_param.campo_tipo_trabajador[li_cuenta]
	ls_campo_area = istr_reporte_param.campo_area[li_cuenta]
	ls_campo_seccion = istr_reporte_param.campo_seccion[li_cuenta]
	ls_campo_trabajador = istr_reporte_param.campo_trabajador[li_cuenta]
	ls_campo_fecha = istr_reporte_param.campo_fecha[li_cuenta]
	ls_campo_tarjeta = istr_reporte_param.campo_tarjeta[li_cuenta]
	ls_campo_cencos = istr_reporte_param.campo_cencos[li_cuenta]
	ls_campo_cod_afp = istr_reporte_param.campo_cod_afp[li_cuenta]
	ls_campo_concep =  istr_reporte_param.campo_concep[li_cuenta]
	//where de la afiliación a AFPs
	if tab_reporte.tp_2.rb_afp_todos.checked = false and (not isnull(ls_campo_cod_afp)) and trim(ls_campo_cod_afp) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		if tab_reporte.tp_2.rb_afp_si.checked = true then
			ls_select_where = ls_select_where + trim(ls_campo_cod_afp) + " is not null "
		else
			ls_select_where = ls_select_where + trim(ls_campo_cod_afp) + " is null "
		end if
	end if
	//where de la forma de pago
	if tab_reporte.tp_2.rb_tarjeta_todos.checked = false and (not isnull(ls_campo_tarjeta)) and trim(ls_campo_tarjeta) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		if tab_reporte.tp_2.rb_tarjeta_si.checked = true then
			ls_select_where = ls_select_where + trim(ls_campo_tarjeta) + " is not null "
		else
			ls_select_where = ls_select_where + trim(ls_campo_tarjeta) + " is null "
		end if
	end if
	//where de origenes
	if cbx_origen.checked = false and (not isnull(ls_campo_origen)) and trim(ls_campo_origen) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_origen) + ") = '" + trim(right(ddlb_origen.text,2)) + "'"
	end if
	//where de tipo de trabajador
	if cbx_tipo_trabajador.checked = false and (not isnull(ls_campo_tipo_trabajador)) and trim(ls_campo_tipo_trabajador) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_tipo_trabajador) + ") = '" + trim(right(ddlb_tipo_trabajador.text,3)) + "'"
	end if
	//where de secciones
	if tab_reporte.tp_2.cbx_secciones.checked = false and (not isnull(ls_campo_seccion)) and trim(ls_campo_seccion) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_area) + ") = '" + trim(right(tab_reporte.tp_2.ddlb_areas.text,1)) + "' and trim(" + trim(ls_campo_seccion) + ") = '" + trim(right(tab_reporte.tp_2.ddlb_secciones.text,3)) + "'"
	end if
	//where del codigo del trabajador
	if tab_reporte.tp_2.cbx_trabajador.checked = false and (not isnull(ls_campo_trabajador)) and trim(ls_campo_trabajador) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_trabajador) + ") = '" + trim(tab_reporte.tp_2.dw_trabajador.object.cod_trabajador[tab_reporte.tp_2.dw_trabajador.getrow()]) + "'"
	end if
	//where de centoros de costo
	if tab_reporte.tp_2.cbx_centros_costo.checked = false and (not isnull(ls_campo_cencos)) and trim(ls_campo_cencos) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_cencos) + ") = '" + trim(right(tab_reporte.tp_2.ddlb_centros_costo.text,10)) + "'"
	end if
	//where de la AFP
	if tab_reporte.tp_2.cbx_afp.checked = false and (not isnull(ls_campo_cod_afp)) and trim(ls_campo_cod_afp) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_cod_afp) + ") = '" + trim(right(tab_reporte.tp_2.ddlb_afp.text,2)) + "'"
	end if
	//where del concepto
	ls_concep = ''
	lb_selected_concep = false
	if tab_reporte.tp_2.cbx_concepto.checked = false and (not isnull(ls_campo_concep)) and trim(ls_campo_concep) <> '' and tab_reporte.tp_2.ddlb_concepto.selecteditem() <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		for ll_concep = 0 to tab_reporte.tp_2.ddlb_concepto.totalitems()
			if tab_reporte.tp_2.ddlb_concepto.state(ll_concep) = 1 then
				if lb_selected_concep then
					ls_concep = ls_concep + ","
				else
					ls_concep = "("
				end if
				ls_concep = ls_concep + " '" + left(tab_reporte.tp_2.ddlb_concepto.text(ll_concep),4) + "' "
				lb_selected_concep = true
			end if
		next
		if not isnull(ls_concep) and trim(ls_concep) <> '' then 
			ls_concep = ls_concep + ')'
			ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_concep) + ") in " + ls_concep
		end if				
	end if
	//where de la fecha
	if cbx_periodo.checked = true and (not isnull(ls_campo_fecha)) and trim(ls_campo_fecha) <> ''  then
		if rb_fecha.checked = true then
			ls_ini = string(uo_fecha.of_get_fecha())
			ls_fin = string(uo_fecha.of_get_fecha())
		else
			if rb_rango_fecha.checked = true then
				ls_ini = string(uo_rango.of_get_fecha1())
				ls_fin = string(uo_rango.of_get_fecha2())
			else
				if rb_mes.checked = true then
					ls_ini = '01/' + (left(right(trim(ddlb_mes_m.text),3),2)) + '/' + em_ano_m.text
					li_mes = integer(left(right(trim(ddlb_mes_m.text),3),2))
					li_ano =  integer(em_ano_m.text)
					if li_mes = 12 then
						li_mes = 1
						li_ano = li_ano + 1
					else
						li_mes = li_mes + 1
					end if
					ls_fin = string(relativedate(date(string(li_ano) + '-' + right('0' + string(li_mes),2) + '-01'), -1))
				else
					if rb_semana_fecha.checked = true then
						li_ano = integer(uo_semana.st_ano.text)
						li_sem = integer(uo_semana.st_sem.text)
					else
						li_ano = integer(em_ano.text)
						li_sem = integer(em_sem.text)
					end if
			   	declare busca_fechas procedure for 
						usp_busca_fechas(:li_sem, :li_ano);
					execute busca_fechas;
					fetch busca_fechas into :ls_ini, :ls_fin;
					close busca_fechas;
					if isnull(ls_ini) or isnull(ls_fin) then 
						messagebox('Error', 'No se pueden cargar las fechas ~r referentes a la semana y al ~r año deseados')
						return
					end if
				end if
			end if		
		end if
		
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		
		ls_select_where = trim(ls_select_where) + " trunc(" + trim(ls_campo_fecha) + ") between to_date('" + trim(ls_ini) + "', 'dd/mm/yyyy') and to_date('" + trim(ls_fin) + "', 'dd/mm/yyyy')" 
		
	end if
	
	ls_new_sql = trim(ls_new_sql) + " " + ls_select_campos + " " + ls_select_from + " " + ls_select_where
next

if not isnull(istr_reporte_param.select_group) and trim(istr_reporte_param.select_group) <> '' then ls_new_sql = ls_new_sql + " " + istr_reporte_param.select_group
if not isnull(istr_reporte_param.select_order) and trim(istr_reporte_param.select_order) <> '' then ls_new_sql = ls_new_sql + " " + istr_reporte_param.select_order

//título de fechas
if ls_ini = ls_fin then
	ls_rango_texto = "Fecha  " + ls_ini
else
	ls_rango_texto = "Periodo  " + ls_ini + ' - ' + ls_fin
end if	

//asigna valores del datawindows al objeto

st_procesando_status.text = 'EJECUTANDO CONSULTA DE DATOS'
idw_1.dataobject = is_datawindow_tabla
idw_1.settransobject(sqlca)

ls_procedure = istr_reporte_param.procedure_name

if not isnull(ls_procedure) and trim(ls_procedure) <> '' then
	st_procesando_status.text = 'EJECUTANDO PROCESO'
	execute immediate :ls_procedure;
end if

if gs_user = 'arojas' or gs_user = 'jarch' then
	mle_1.text = ls_new_sql
	mle_1.visible = true
	cb_1.visible = true
end if

idw_1.setsqlselect(ls_new_sql)
st_procesando_status.text = 'ARMANDO REPORTE'
ii_charged_dw = idw_1.retrieve(gs_user)
st_procesando_status.text = 'MOSTRANDO REPORTE'
//coloca objetos adicionales en el datawindows

if tab_reporte.tp_1.dw_master.rowcount() >= 1 then
	tab_reporte.tp_1.dw_master.object.p_logo.filename = gs_logo
	tab_reporte.tp_1.dw_master.object.st_empresa.text = gs_empresa
	tab_reporte.tp_1.dw_master.object.st_usuario.text = gs_user
	tab_reporte.tp_1.dw_master.object.st_rango_fecha.text = ls_rango_texto
	select to_char(sysdate, 'dd/mm/yyyy hh:mi:ss')
		into :ls_fecha_reporte
		from dual;
	tab_reporte.tp_1.dw_master.object.st_fecha.text = ls_fecha_reporte
	il_detail_height = long(idw_1.Object.DataWindow.Detail.Height)
end if
end subroutine

public subroutine of_carga_dw_grafico ();string ls_new_sql, ls_select_campos, ls_select_from, ls_select_where, ls_campo_origen, ls_campo_tarjeta, ls_campo_tipo_trabajador, ls_campo_area, ls_campo_seccion, ls_campo_fecha, ls_campo_trabajador, ls_ini, ls_fin, ls_rango_texto, ls_fecha_reporte, ls_campo_cod_afp, ls_campo_cencos, ls_campo_concep, ls_procedure, ls_concep
long ll_concep
boolean lb_selected_concep
integer li_cuenta, li_ano, li_mes, li_sem

ls_new_sql = ""
st_procesando_status.text = 'ARMANDO CONSULTA DE DATOS'
for li_cuenta = 1 to ii_select_cantidad 
	if li_cuenta >= 2 then ls_new_sql = ls_new_sql + " union all "
	//estructura del query
	ls_select_campos = trim(istr_reporte_param.select_campos_grf[li_cuenta])
	ls_select_from = trim(istr_reporte_param.select_from_grf[li_cuenta])
	ls_select_where = trim(istr_reporte_param.select_where_grf[li_cuenta])
	//nombres de los campos
	ls_campo_origen = istr_reporte_param.campo_origen_grf[li_cuenta]
	ls_campo_tipo_trabajador = istr_reporte_param.campo_tipo_trabajador_grf[li_cuenta]
	ls_campo_area = istr_reporte_param.campo_area_grf[li_cuenta]
	ls_campo_seccion = istr_reporte_param.campo_seccion_grf[li_cuenta]
	ls_campo_trabajador = istr_reporte_param.campo_trabajador_grf[li_cuenta]
	ls_campo_fecha = istr_reporte_param.campo_fecha_grf[li_cuenta]
	ls_campo_tarjeta = istr_reporte_param.campo_tarjeta_grf[li_cuenta]
	ls_campo_cod_afp = istr_reporte_param.campo_cod_afp_grf[li_cuenta]
	ls_campo_cencos = istr_reporte_param.campo_cencos_grf[li_cuenta]
	ls_campo_concep = istr_reporte_param.campo_concep_grf[li_cuenta]
	//where de la forma de pago
	if tab_reporte.tp_2.rb_tarjeta_todos.checked = false and (not isnull(ls_campo_tarjeta)) and trim(ls_campo_tarjeta) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		if tab_reporte.tp_2.rb_tarjeta_si.checked = true then
			ls_select_where = ls_select_where + trim(ls_campo_tarjeta) + " is not null "
		else
			ls_select_where = ls_select_where + trim(ls_campo_tarjeta) + " is null "
		end if
	end if
	//where de la afiliación a AFPs
	if tab_reporte.tp_2.rb_afp_todos.checked = false and (not isnull(ls_campo_cod_afp)) and trim(ls_campo_cod_afp) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		if tab_reporte.tp_2.rb_tarjeta_si.checked = true then
			ls_select_where = ls_select_where + trim(ls_campo_cod_afp) + " is not null "
		else
			ls_select_where = ls_select_where + trim(ls_campo_cod_afp) + " is null "
		end if
	end if
	//where de origenes
	if cbx_origen.checked = false and (not isnull(ls_campo_origen)) and trim(ls_campo_origen) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_origen) + ") = '" + trim(right(ddlb_origen.text,2)) + "'"
	end if
	//where de tipo de trabajador
	if cbx_tipo_trabajador.checked = false and (not isnull(ls_campo_tipo_trabajador)) and trim(ls_campo_tipo_trabajador) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_tipo_trabajador) + ") = '" + trim(right(ddlb_tipo_trabajador.text,3)) + "'"
	end if
	//where de secciones
	if tab_reporte.tp_2.cbx_secciones.checked = false and (not isnull(ls_campo_seccion)) and trim(ls_campo_seccion) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_area) + ") = '" + trim(right(tab_reporte.tp_2.ddlb_areas.text,1)) + "' and trim(" + trim(ls_campo_seccion) + ") = '" + trim(right(tab_reporte.tp_2.ddlb_secciones.text,3)) + "'"
	end if
	//where del codigo del trabajador
	if tab_reporte.tp_2.cbx_trabajador.checked = false and (not isnull(ls_campo_trabajador)) and trim(ls_campo_trabajador) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_trabajador) + ") = '" + trim(tab_reporte.tp_2.dw_trabajador.object.cod_trabajador[tab_reporte.tp_2.dw_trabajador.getrow()]) + "'"
	end if
	//where de centoros de costo
	if tab_reporte.tp_2.cbx_centros_costo.checked = false and (not isnull(ls_campo_cencos)) and trim(ls_campo_cencos) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_cencos) + ") = '" + trim(right(tab_reporte.tp_2.ddlb_centros_costo.text,10)) + "'"
	end if
	//where de la AFP
	if tab_reporte.tp_2.cbx_afp.checked = false and (not isnull(ls_campo_cod_afp)) and trim(ls_campo_cod_afp) <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_cod_afp) + ") = '" + trim(right(tab_reporte.tp_2.ddlb_afp.text,2)) + "'"
	end if
	//where del concepto
	ls_concep = ''
	lb_selected_concep = false
	if tab_reporte.tp_2.cbx_concepto.checked = false and (not isnull(ls_campo_concep)) and trim(ls_campo_concep) <> '' and tab_reporte.tp_2.ddlb_concepto.selecteditem() <> '' then 
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		for ll_concep = 0 to tab_reporte.tp_2.ddlb_concepto.totalitems()
			if tab_reporte.tp_2.ddlb_concepto.state(ll_concep) = 1 then
				if lb_selected_concep then
					ls_concep = ls_concep + ","
				else
					ls_concep = "("
				end if
				ls_concep = ls_concep + " '" + left(tab_reporte.tp_2.ddlb_concepto.text(ll_concep),4) + "' "
				lb_selected_concep = true
			end if
		next
		if not isnull(ls_concep) and trim(ls_concep) <> '' then 
			ls_concep = ls_concep + ')'
			ls_select_where = trim(ls_select_where) + " trim(" + trim(ls_campo_concep) + ") in " + ls_concep
		end if				
	end if
	//where de la fecha
	if cbx_periodo.checked = true and (not isnull(ls_campo_fecha)) and trim(ls_campo_fecha) <> ''  then
		if rb_rango_fecha.checked = true then
			ls_ini = string(uo_rango.of_get_fecha1())
			ls_fin = string(uo_rango.of_get_fecha2())
		else
			if rb_mes.checked = true then
				ls_ini = '01/' + (left(right(trim(ddlb_mes_m.text),3),2)) + '/' + em_ano_m.text
				li_mes = integer(left(right(trim(ddlb_mes_m.text),3),2))
				li_ano =  integer(em_ano_m.text)
				if li_mes = 12 then
					li_mes = 1
					li_ano = li_ano + 1
				else
					li_mes = li_mes + 1
				end if
				ls_fin = string(relativedate(date(string(li_ano) + '-' + right('0' + string(li_mes),2) + '-01'), -1))
			else
				if rb_semana_fecha.checked = true then
					li_ano = integer(uo_semana.st_ano.text)
					li_sem = integer(uo_semana.st_sem.text)
				else
					li_ano = integer(em_ano.text)
					li_sem = integer(em_sem.text)
				end if
			   declare busca_fechas procedure for 
					usp_busca_fechas(:li_sem, :li_ano);
				execute busca_fechas;
				fetch busca_fechas into :ls_ini, :ls_fin;
				close busca_fechas;
				if isnull(ls_ini) or isnull(ls_fin) then 
					messagebox('Error', 'No se pueden cargar las fechas ~r referentes a la semana y al ~r año deseados')
					return
				end if
			end if		
		end if
		if isnull(ls_select_where) or trim(ls_select_where) = '' then 
			ls_select_where = ' where '
		else
			ls_select_where = ls_select_where + ' and '
		end if
		ls_select_where = trim(ls_select_where) + " trunc(" + trim(ls_campo_fecha) + ") between to_date('" + trim(ls_ini) + "', 'dd/mm/yyyy') and to_date('" + trim(ls_fin) + "', 'dd/mm/yyyy')" 
	end if
	ls_new_sql = trim(ls_new_sql) + " " + ls_select_campos + " " + ls_select_from + " " + ls_select_where
next

if not isnull(istr_reporte_param.select_order_grf) and trim(istr_reporte_param.select_order_grf) <> '' then ls_new_sql = ls_new_sql + " " + istr_reporte_param.select_order_grf

//título de fechas
if ls_ini = ls_fin then
	ls_rango_texto = " - FECHA " + ls_ini
else
	ls_rango_texto = " - PERIODO " + ls_ini + ' - ' + ls_fin
end if	

//asigna valores del datawindows al objeto
st_procesando_status.text = 'EJECUTANDO CONSULTA DE DATOS'
idw_1.dataobject = is_datawindow_graph
idw_1.settransobject(sqlca)
ls_procedure = istr_reporte_param.procedure_name_grf
if not isnull(ls_procedure) and trim(ls_procedure) <> '' then
	st_procesando_status.text = 'EJECUTANDO PROCESO'
	execute immediate :ls_procedure;
end if

if gs_user = 'mmcsn' then
	mle_1.text = ls_new_sql
	mle_1.visible = true
	cb_1.visible = true
end if

idw_1.setsqlselect(ls_new_sql)
st_procesando_status.text = 'ARMANDO REPORTE'
ii_charged_dw = idw_1.retrieve(gs_user)
st_procesando_status.text = 'MOSTRANDO REPORTE'
//coloca objetos adicionales en el datawindows

if tab_reporte.tp_1.dw_master.rowcount() >= 1 then
	tab_reporte.tp_1.dw_master.object.gr_1.title = istr_reporte_param.datawindows_title + ls_rango_texto
	il_detail_height = long(idw_1.Object.DataWindow.Detail.Height)
end if
end subroutine

on w_rh300_reportes_param.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.tab_reporte=create tab_reporte
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.rb_fecha=create rb_fecha
this.ddlb_tipo_trabajador=create ddlb_tipo_trabajador
this.em_ano_m=create em_ano_m
this.st_ano_m=create st_ano_m
this.ddlb_mes_m=create ddlb_mes_m
this.st_mes_m=create st_mes_m
this.rb_mes=create rb_mes
this.p_8=create p_8
this.p_6=create p_6
this.p_5=create p_5
this.p_4=create p_4
this.st_etiqueta=create st_etiqueta
this.cbx_periodo=create cbx_periodo
this.cbx_tipo_trabajador=create cbx_tipo_trabajador
this.p_2=create p_2
this.p_1=create p_1
this.uo_rango=create uo_rango
this.rb_semana=create rb_semana
this.rb_semana_fecha=create rb_semana_fecha
this.rb_rango_fecha=create rb_rango_fecha
this.cbx_origen=create cbx_origen
this.rb_grafico=create rb_grafico
this.rb_texto=create rb_texto
this.gb_1=create gb_1
this.gb_2=create gb_2
this.ddlb_origen=create ddlb_origen
this.st_sem=create st_sem
this.em_sem=create em_sem
this.st_ano=create st_ano
this.em_ano=create em_ano
this.uo_semana=create uo_semana
this.gb_3=create gb_3
this.gb_8=create gb_8
this.p_procesando=create p_procesando
this.st_procesando_title=create st_procesando_title
this.st_procesando_status=create st_procesando_status
this.st_procesando=create st_procesando
this.mle_1=create mle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_reporte
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.rb_fecha
this.Control[iCurrent+5]=this.ddlb_tipo_trabajador
this.Control[iCurrent+6]=this.em_ano_m
this.Control[iCurrent+7]=this.st_ano_m
this.Control[iCurrent+8]=this.ddlb_mes_m
this.Control[iCurrent+9]=this.st_mes_m
this.Control[iCurrent+10]=this.rb_mes
this.Control[iCurrent+11]=this.p_8
this.Control[iCurrent+12]=this.p_6
this.Control[iCurrent+13]=this.p_5
this.Control[iCurrent+14]=this.p_4
this.Control[iCurrent+15]=this.st_etiqueta
this.Control[iCurrent+16]=this.cbx_periodo
this.Control[iCurrent+17]=this.cbx_tipo_trabajador
this.Control[iCurrent+18]=this.p_2
this.Control[iCurrent+19]=this.p_1
this.Control[iCurrent+20]=this.uo_rango
this.Control[iCurrent+21]=this.rb_semana
this.Control[iCurrent+22]=this.rb_semana_fecha
this.Control[iCurrent+23]=this.rb_rango_fecha
this.Control[iCurrent+24]=this.cbx_origen
this.Control[iCurrent+25]=this.rb_grafico
this.Control[iCurrent+26]=this.rb_texto
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_2
this.Control[iCurrent+29]=this.ddlb_origen
this.Control[iCurrent+30]=this.st_sem
this.Control[iCurrent+31]=this.em_sem
this.Control[iCurrent+32]=this.st_ano
this.Control[iCurrent+33]=this.em_ano
this.Control[iCurrent+34]=this.uo_semana
this.Control[iCurrent+35]=this.gb_3
this.Control[iCurrent+36]=this.gb_8
this.Control[iCurrent+37]=this.p_procesando
this.Control[iCurrent+38]=this.st_procesando_title
this.Control[iCurrent+39]=this.st_procesando_status
this.Control[iCurrent+40]=this.st_procesando
this.Control[iCurrent+41]=this.mle_1
end on

on w_rh300_reportes_param.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_reporte)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.rb_fecha)
destroy(this.ddlb_tipo_trabajador)
destroy(this.em_ano_m)
destroy(this.st_ano_m)
destroy(this.ddlb_mes_m)
destroy(this.st_mes_m)
destroy(this.rb_mes)
destroy(this.p_8)
destroy(this.p_6)
destroy(this.p_5)
destroy(this.p_4)
destroy(this.st_etiqueta)
destroy(this.cbx_periodo)
destroy(this.cbx_tipo_trabajador)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.uo_rango)
destroy(this.rb_semana)
destroy(this.rb_semana_fecha)
destroy(this.rb_rango_fecha)
destroy(this.cbx_origen)
destroy(this.rb_grafico)
destroy(this.rb_texto)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.ddlb_origen)
destroy(this.st_sem)
destroy(this.em_sem)
destroy(this.st_ano)
destroy(this.em_ano)
destroy(this.uo_semana)
destroy(this.gb_3)
destroy(this.gb_8)
destroy(this.p_procesando)
destroy(this.st_procesando_title)
destroy(this.st_procesando_status)
destroy(this.st_procesando)
destroy(this.mle_1)
end on

event resize;
tab_reporte.width = newwidth  - tab_reporte.x - 10
tab_reporte.height = newheight - tab_reporte.y - 10

tab_reporte.tp_1.dw_master.width  = newwidth  - tab_reporte.tp_1.dw_master.x - 80
tab_reporte.tp_1.dw_master.height = newheight - tab_reporte.tp_1.dw_master.y - 670

tab_reporte.tp_2.ddlb_concepto.width = newwidth - tab_reporte.tp_2.ddlb_concepto.x - 110
tab_reporte.tp_2.ddlb_concepto.height = newheight - tab_reporte.tp_2.ddlb_concepto.y - 690

tab_reporte.tp_2.gb_concepto.width = newwidth - tab_reporte.tp_2.gb_concepto.x - 90
tab_reporte.tp_2.gb_concepto.height = newheight - tab_reporte.tp_2.gb_concepto.y - 670
end event

event ue_open_pre;call super::ue_open_pre;string ls_cod_trabajador

ii_charged_dw = 0

ii_carga_sem = 0

ddlb_origen.selectitem(1)
ddlb_tipo_trabajador.selectitem(1)
tab_reporte.tp_2.ddlb_areas.selectitem(1)
tab_reporte.tp_2.ddlb_secciones.event constructor()
tab_reporte.tp_2.ddlb_secciones.selectitem(1)
tab_reporte.tp_2.ddlb_concepto.selectitem(1)
tab_reporte.tp_2.ddlb_cencos_niv1.selectitem(1)
tab_reporte.tp_2.ddlb_centros_costo.event constructor()
tab_reporte.tp_2.ddlb_centros_costo.selectitem(1)
tab_reporte.tp_2.ddlb_afp.selectitem(1)
tab_reporte.tp_2.cbx_afp.enabled = false
idw_1 = tab_reporte.tp_1.dw_master
idw_1.BorderStyle = StyleLowered!
this.title = is_title

select max(cod_trabajador) into :ls_cod_trabajador from maestro;
tab_reporte.tp_2.dw_trabajador.settransobject(sqlca)
tab_reporte.tp_2.dw_trabajador.retrieve(ls_cod_trabajador)

ii_help = 101           // help topic
of_position_window(0,0)        // Posicionar la ventana en forma fija
ii_dw_ypos = idw_1.y



end event

event ue_mail_send;String		ls_ini_file, ls_file, ls_name, ls_address, ls_subject, ls_note, ls_path, ls_mailparam
integer li_mailparam, li_p1, li_p2, li_p3
n_cst_email	lnv_mail
n_cst_api	lnv_api

lnv_mail = CREATE n_cst_email
lnv_api  = CREATE n_cst_api

if rb_texto.checked = true then
	ls_path = 'c:\report.html'
	ls_file = 'report.html'
	idw_1.SaveAs(ls_path, HTMLTable!, True)
else
	ls_path = 'c:\report.xls'
	ls_file = 'report.xls'
	idw_1.SaveAs("gr_1",ls_path, CSV!, TRUE)
end if

OpenWithParm(w_mail_param, this.title)
ls_mailparam = Message.StringParm

if trim(ls_mailparam) = 'cancel' then return

li_mailparam = len(ls_mailparam)
li_p1 = pos(ls_mailparam, '|P1|', 1)
li_p2 = pos(ls_mailparam, '|P2|', 1)
li_p3 = pos(ls_mailparam, '|P3|', 1)

ls_name = mid(ls_mailparam, 1, li_p1 - 4)
ls_address = mid(ls_mailparam, li_p1 + 4, li_p2 - li_p1 - 4)
ls_subject = mid(ls_mailparam, li_p2 + 4, li_p3 - li_p2 - 4)
ls_note = mid(ls_mailparam, li_p3 + 4, li_mailparam - li_p3)

lnv_mail.of_logon()
lnv_mail.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
lnv_mail.of_logoff()
lnv_api.of_file_delete(ls_path)

DESTROY lnv_mail
DESTROY lnv_api
end event

event open;call super::open;of_recibe_param()



end event

type tab_reporte from tab within w_rh300_reportes_param
event create ( )
event destroy ( )
integer y = 516
integer width = 3534
integer height = 1312
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tp_1 tp_1
tp_2 tp_2
end type

on tab_reporte.create
this.tp_1=create tp_1
this.tp_2=create tp_2
this.Control[]={this.tp_1,&
this.tp_2}
end on

on tab_reporte.destroy
destroy(this.tp_1)
destroy(this.tp_2)
end on

type tp_1 from userobject within tab_reporte
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3497
integer height = 1184
long backcolor = 79741120
string text = "  Visualiza Reporte  "
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "DataWindow!"
long picturemaskcolor = 536870912
dw_master dw_master
end type

on tp_1.create
this.dw_master=create dw_master
this.Control[]={this.dw_master}
end on

on tp_1.destroy
destroy(this.dw_master)
end on

type dw_master from u_dw_cns within tp_1
event ue_zoom ( integer ai_zoom )
event ue_mouse_move pbm_mousemove
integer x = 5
integer y = 24
integer width = 3474
integer height = 1152
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event ue_zoom(integer ai_zoom);Integer	li_Zoom

li_Zoom = ai_zoom * ii_zi   //  Incremento del zoom

If li_Zoom = 0 Then
	OpenWithParm(w_zoom, ii_zoom_actual)
	If Message.DoubleParm > 0 Then
		ii_zoom_actual = Message.DoubleParm
	End if
	
Else
	ii_zoom_actual = ii_zoom_actual + li_Zoom
End If

If ii_zoom_actual < 10 Then ii_zoom_actual = 10

THIS.modify('datawindow.print.preview.zoom = ' + String(ii_zoom_actual))
This.title = "Reporte " + "(Zoom: " + String(ii_zoom_actual) + "%)"

end event

event ue_mouse_move;if ii_charged_dw <= 0 then return
if rb_texto.checked = true then
	st_etiqueta.visible = false 	
	return
end if
Int  li_Rtn, li_Series, li_Category 
String  ls_serie, ls_categ, ls_cantidad, ls_mensaje 
Long ll_row 
grObjectType MouseMoveObject 
MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)
IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	ls_categ = this.CategoryName('gr_1', li_Category)   
	ls_serie = this.SeriesName('gr_1', li_Series)        
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,###,##0.00') 
	ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
	st_etiqueta.BringToTop = TRUE 
	st_etiqueta.x = xpos + dw_master.x + 50
	st_etiqueta.y = ypos + ii_dw_ypos - 50
	st_etiqueta.text = ls_mensaje 
	st_etiqueta.width = len(ls_mensaje) * 30 
	st_etiqueta.visible = true 
ELSE 
	st_etiqueta.visible = false 
END IF
end event

event constructor;call super::constructor;ii_ck[1] = 1
ii_zi = 25
end event

type tp_2 from userobject within tab_reporte
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3497
integer height = 1184
long backcolor = 67108864
string text = "  Opciones Adicionales de Configuración  "
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "ArrangeIcons!"
long picturemaskcolor = 536870912
sle_paginador sle_paginador
p_17 p_17
sle_titulo sle_titulo
rb_print_no rb_print_no
rb_print_si rb_print_si
p_16 p_16
p_15 p_15
rb_historico_no rb_historico_no
rb_historico_si rb_historico_si
p_14 p_14
ddlb_secciones ddlb_secciones
p_9 p_9
ddlb_afp ddlb_afp
cbx_afp cbx_afp
p_13 p_13
cbx_trabajador cbx_trabajador
ddlb_areas ddlb_areas
cbx_secciones cbx_secciones
ddlb_centros_costo ddlb_centros_costo
ddlb_cencos_niv1 ddlb_cencos_niv1
cbx_centros_costo cbx_centros_costo
p_10 p_10
p_3 p_3
rb_afp_todos rb_afp_todos
rb_afp_no rb_afp_no
rb_afp_si rb_afp_si
p_11 p_11
rb_tarjeta_no rb_tarjeta_no
rb_tarjeta_si rb_tarjeta_si
rb_tarjeta_todos rb_tarjeta_todos
p_7 p_7
dw_trabajador dw_trabajador
ddlb_concepto ddlb_concepto
p_12 p_12
cbx_concepto cbx_concepto
gb_concepto gb_concepto
gb_6 gb_6
gb_4 gb_4
gb_9 gb_9
gb_7 gb_7
gb_5 gb_5
gb_11 gb_11
gb_10 gb_10
gb_13 gb_13
gb_14 gb_14
gb_12 gb_12
end type

on tp_2.create
this.sle_paginador=create sle_paginador
this.p_17=create p_17
this.sle_titulo=create sle_titulo
this.rb_print_no=create rb_print_no
this.rb_print_si=create rb_print_si
this.p_16=create p_16
this.p_15=create p_15
this.rb_historico_no=create rb_historico_no
this.rb_historico_si=create rb_historico_si
this.p_14=create p_14
this.ddlb_secciones=create ddlb_secciones
this.p_9=create p_9
this.ddlb_afp=create ddlb_afp
this.cbx_afp=create cbx_afp
this.p_13=create p_13
this.cbx_trabajador=create cbx_trabajador
this.ddlb_areas=create ddlb_areas
this.cbx_secciones=create cbx_secciones
this.ddlb_centros_costo=create ddlb_centros_costo
this.ddlb_cencos_niv1=create ddlb_cencos_niv1
this.cbx_centros_costo=create cbx_centros_costo
this.p_10=create p_10
this.p_3=create p_3
this.rb_afp_todos=create rb_afp_todos
this.rb_afp_no=create rb_afp_no
this.rb_afp_si=create rb_afp_si
this.p_11=create p_11
this.rb_tarjeta_no=create rb_tarjeta_no
this.rb_tarjeta_si=create rb_tarjeta_si
this.rb_tarjeta_todos=create rb_tarjeta_todos
this.p_7=create p_7
this.dw_trabajador=create dw_trabajador
this.ddlb_concepto=create ddlb_concepto
this.p_12=create p_12
this.cbx_concepto=create cbx_concepto
this.gb_concepto=create gb_concepto
this.gb_6=create gb_6
this.gb_4=create gb_4
this.gb_9=create gb_9
this.gb_7=create gb_7
this.gb_5=create gb_5
this.gb_11=create gb_11
this.gb_10=create gb_10
this.gb_13=create gb_13
this.gb_14=create gb_14
this.gb_12=create gb_12
this.Control[]={this.sle_paginador,&
this.p_17,&
this.sle_titulo,&
this.rb_print_no,&
this.rb_print_si,&
this.p_16,&
this.p_15,&
this.rb_historico_no,&
this.rb_historico_si,&
this.p_14,&
this.ddlb_secciones,&
this.p_9,&
this.ddlb_afp,&
this.cbx_afp,&
this.p_13,&
this.cbx_trabajador,&
this.ddlb_areas,&
this.cbx_secciones,&
this.ddlb_centros_costo,&
this.ddlb_cencos_niv1,&
this.cbx_centros_costo,&
this.p_10,&
this.p_3,&
this.rb_afp_todos,&
this.rb_afp_no,&
this.rb_afp_si,&
this.p_11,&
this.rb_tarjeta_no,&
this.rb_tarjeta_si,&
this.rb_tarjeta_todos,&
this.p_7,&
this.dw_trabajador,&
this.ddlb_concepto,&
this.p_12,&
this.cbx_concepto,&
this.gb_concepto,&
this.gb_6,&
this.gb_4,&
this.gb_9,&
this.gb_7,&
this.gb_5,&
this.gb_11,&
this.gb_10,&
this.gb_13,&
this.gb_14,&
this.gb_12}
end on

on tp_2.destroy
destroy(this.sle_paginador)
destroy(this.p_17)
destroy(this.sle_titulo)
destroy(this.rb_print_no)
destroy(this.rb_print_si)
destroy(this.p_16)
destroy(this.p_15)
destroy(this.rb_historico_no)
destroy(this.rb_historico_si)
destroy(this.p_14)
destroy(this.ddlb_secciones)
destroy(this.p_9)
destroy(this.ddlb_afp)
destroy(this.cbx_afp)
destroy(this.p_13)
destroy(this.cbx_trabajador)
destroy(this.ddlb_areas)
destroy(this.cbx_secciones)
destroy(this.ddlb_centros_costo)
destroy(this.ddlb_cencos_niv1)
destroy(this.cbx_centros_costo)
destroy(this.p_10)
destroy(this.p_3)
destroy(this.rb_afp_todos)
destroy(this.rb_afp_no)
destroy(this.rb_afp_si)
destroy(this.p_11)
destroy(this.rb_tarjeta_no)
destroy(this.rb_tarjeta_si)
destroy(this.rb_tarjeta_todos)
destroy(this.p_7)
destroy(this.dw_trabajador)
destroy(this.ddlb_concepto)
destroy(this.p_12)
destroy(this.cbx_concepto)
destroy(this.gb_concepto)
destroy(this.gb_6)
destroy(this.gb_4)
destroy(this.gb_9)
destroy(this.gb_7)
destroy(this.gb_5)
destroy(this.gb_11)
destroy(this.gb_10)
destroy(this.gb_13)
destroy(this.gb_14)
destroy(this.gb_12)
end on

type sle_paginador from singlelineedit within tp_2
integer x = 64
integer y = 1076
integer width = 1723
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type p_17 from picture within tp_2
integer x = 87
integer y = 828
integer width = 59
integer height = 60
string picturename = "Properties!"
boolean focusrectangle = false
end type

type sle_titulo from singlelineedit within tp_2
integer x = 78
integer y = 904
integer width = 1723
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type rb_print_no from radiobutton within tp_2
integer x = 2130
integer y = 912
integer width = 155
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No"
boolean checked = true
end type

type rb_print_si from radiobutton within tp_2
integer x = 1952
integer y = 912
integer width = 155
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Si"
end type

type p_16 from picture within tp_2
integer x = 1934
integer y = 832
integer width = 59
integer height = 60
string picturename = "Print!"
boolean focusrectangle = false
end type

type p_15 from picture within tp_2
integer x = 1934
integer y = 612
integer width = 59
integer height = 60
string picturename = "InsertReturn!"
boolean focusrectangle = false
end type

type rb_historico_no from radiobutton within tp_2
integer x = 2130
integer y = 700
integer width = 169
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No"
boolean checked = true
end type

event clicked;if this.checked then 
	ii_select_cantidad = 1
	ii_select_cantidad_grf = 1
end if
end event

type rb_historico_si from radiobutton within tp_2
integer x = 1952
integer y = 700
integer width = 160
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Si"
end type

event clicked;if this.checked then 
	ii_select_cantidad = istr_reporte_param.select_cantidad
	ii_select_cantidad_grf = istr_reporte_param.select_cantidad_grf
end if
end event

type p_14 from picture within tp_2
integer x = 882
integer y = 76
integer width = 59
integer height = 60
string picturename = "Custom004!"
boolean focusrectangle = false
end type

type ddlb_secciones from u_ddlb_lista within tp_2
integer x = 1600
integer y = 168
integer width = 709
integer height = 692
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
boolean autohscroll = true
boolean sorted = true
boolean hscrollbar = true
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_dddw_seccion_reporte_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 3							// Longitud del campo 2
end event

event ue_item_add;//overwrite
Integer	li_index, li_x
Long     ll_rows, ll_total, ll_count
Any  		la_id
String	ls_item, ls_area

ll_total = this.totalitems()

if ll_total >= 1 then
	for ll_count = ll_total to 1 step -1
		this.deleteitem(ll_count)
	next
end if

ls_area = right(trim(ddlb_areas.text),1)

ll_rows = ids_Data.Retrieve(ls_area)

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

this.height = ddlb_areas.height
end event

type p_9 from picture within tp_2
integer x = -1413
integer y = 292
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "SetDefaultClass!"
boolean focusrectangle = false
end type

type ddlb_afp from u_ddlb_lista within tp_2
integer x = 78
integer y = 696
integer width = 658
integer height = 1128
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_dddw_admin_afp_reporte_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 2							// Longitud del campo 2

end event

type cbx_afp from checkbox within tp_2
integer x = 553
integer y = 620
integer width = 73
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
boolean checked = true
end type

event clicked;if this.checked = true then
	ddlb_afp.enabled = false
else
	ddlb_afp.enabled = true
end if
end event

type p_13 from picture within tp_2
integer x = 87
integer y = 624
integer width = 59
integer height = 60
string picturename = "StyleLibraryList5!"
boolean focusrectangle = false
end type

type cbx_trabajador from checkbox within tp_2
integer x = 1522
integer y = 620
integer width = 78
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	dw_trabajador.enabled = false
		
	cbx_origen.enabled = true
	cbx_tipo_trabajador.enabled = true
	cbx_secciones.enabled = true
	cbx_centros_costo.enabled = true
	cbx_concepto.enabled = true
	cbx_afp.enabled = false
	
	rb_tarjeta_todos.enabled = true
	rb_tarjeta_si.enabled = true
	rb_tarjeta_no.enabled = true
	
	rb_afp_todos.enabled = true
	rb_afp_si.enabled = true
	rb_afp_no.enabled = true

else
	dw_trabajador.enabled = true
	
	cbx_origen.enabled = false
	cbx_tipo_trabajador.enabled = false
	cbx_secciones.enabled = false
	cbx_centros_costo.enabled = false
	cbx_concepto.enabled = false
	cbx_afp.enabled = false
	
	rb_tarjeta_todos.enabled = false
	rb_tarjeta_si.enabled = false
	rb_tarjeta_no.enabled = false
	
	rb_afp_todos.enabled = false
	rb_afp_si.enabled = false
	rb_afp_no.enabled = false
	
end if

rb_tarjeta_todos.checked = true
rb_afp_todos.checked = true

cbx_origen.checked = true
cbx_tipo_trabajador.checked = true
cbx_secciones.checked = true
cbx_centros_costo.checked = true
cbx_concepto.checked = true
cbx_afp.checked = true

ddlb_origen.enabled = false
ddlb_tipo_trabajador.enabled = false
ddlb_areas.enabled = false
ddlb_secciones.enabled = false
ddlb_concepto.enabled = false
ddlb_cencos_niv1.enabled = false
ddlb_centros_costo.enabled = false
ddlb_afp.enabled = false
end event

type ddlb_areas from u_ddlb_lista within tp_2
integer x = 882
integer y = 168
integer width = 709
integer height = 692
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
boolean autohscroll = true
boolean sorted = true
boolean hscrollbar = true
end type

event selectionchanged;call super::selectionchanged;ddlb_secciones.event constructor()
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_dddw_area_reporte_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 1							// Longitud del campo 2
end event

type cbx_secciones from checkbox within tp_2
integer x = 1646
integer y = 76
integer width = 78
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	ddlb_areas.enabled = false
	ddlb_secciones.enabled = false
else
	ddlb_areas.enabled = true
	ddlb_secciones.enabled = true
end if
end event

type ddlb_centros_costo from u_ddlb_lista within tp_2
integer x = 1600
integer y = 436
integer width = 709
integer height = 620
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
boolean autohscroll = true
boolean sorted = true
boolean hscrollbar = true
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_dddw_centros_costo_reprote_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 10							// Longitud del campo 2
end event

event ue_item_add;//overwrite
Integer	li_index, li_x
Long     ll_rows, ll_total, ll_count
Any  		la_id
String	ls_item, ls_cencos_niv1

ll_total = this.totalitems()

if ll_total >= 1 then
	for ll_count = ll_total to 1 step -1
		this.deleteitem(ll_count)
	next
end if

ls_cencos_niv1 = right(trim(ddlb_cencos_niv1.text),2)

ll_rows = ids_Data.Retrieve(ls_cencos_niv1)

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

this.height = ddlb_areas.height
end event

type ddlb_cencos_niv1 from u_ddlb_lista within tp_2
integer x = 882
integer y = 436
integer width = 709
integer height = 620
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
boolean autohscroll = true
boolean sorted = true
boolean hscrollbar = true
end type

event selectionchanged;call super::selectionchanged;ddlb_centros_costo.event constructor()
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_dddw_cencos_niv1_reporte_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 2							// Longitud del campo 2
end event

type cbx_centros_costo from checkbox within tp_2
integer x = 1632
integer y = 348
integer width = 73
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	ddlb_cencos_niv1.enabled = false
	ddlb_centros_costo.enabled = false
else
	ddlb_cencos_niv1.enabled = true
	ddlb_centros_costo.enabled = true
end if
end event

type p_10 from picture within tp_2
integer x = 882
integer y = 352
integer width = 59
integer height = 60
string picturename = "SetVariable!"
boolean focusrectangle = false
end type

type p_3 from picture within tp_2
integer x = 82
integer y = 72
integer width = 59
integer height = 60
string picturename = "Sort!"
boolean focusrectangle = false
end type

type rb_afp_todos from radiobutton within tp_2
integer x = 96
integer y = 448
integer width = 229
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "To&dos"
boolean checked = true
end type

event clicked;cbx_afp.enabled = false
cbx_afp.checked = true
ddlb_afp.enabled = false
end event

type rb_afp_no from radiobutton within tp_2
integer x = 553
integer y = 448
integer width = 160
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&No"
end type

event clicked;cbx_afp.enabled = false
cbx_afp.checked = true
ddlb_afp.enabled = false
end event

type rb_afp_si from radiobutton within tp_2
integer x = 361
integer y = 448
integer width = 165
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Si"
end type

event clicked;cbx_afp.enabled = true
cbx_afp.checked = true
ddlb_afp.enabled = false
end event

type p_11 from picture within tp_2
integer x = 91
integer y = 352
integer width = 59
integer height = 60
string picturename = "StyleLibraryList5!"
boolean focusrectangle = false
end type

type rb_tarjeta_no from radiobutton within tp_2
integer x = 553
integer y = 172
integer width = 160
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&No"
end type

type rb_tarjeta_si from radiobutton within tp_2
integer x = 361
integer y = 172
integer width = 165
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Si"
end type

type rb_tarjeta_todos from radiobutton within tp_2
integer x = 96
integer y = 172
integer width = 229
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "To&dos"
boolean checked = true
end type

type p_7 from picture within tp_2
integer x = 887
integer y = 620
integer width = 59
integer height = 60
string picturename = "Custom076!"
boolean focusrectangle = false
end type

type dw_trabajador from datawindow within tp_2
integer x = 846
integer y = 668
integer width = 965
integer height = 136
integer taborder = 70
boolean enabled = false
string title = "none"
string dataobject = "d_busca_trabajador"
boolean border = false
boolean livescroll = true
end type

event doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2
ls_col = string(lower(dwo.name))
choose case ls_col
	case 'cod_trabajador'
		//ls_sql = "Select cod_relacion as Codigo, nombre as Nombre_Trabajador from codigo_relacion where flag_tabla = 'M'"	
		ls_sql = "select cod_relacion as Codigo, nombre as Trabajador from codigo_relacion cr where flag_tabla = 'M'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		dw_trabajador.retrieve(ls_return1)
end choose
end event

event itemchanged;string ls_col, ls_cod_trabajador, ls_nombre, ls_flag_estado

ls_col = string(lower(dwo.name))

choose case ls_col
	case 'cod_trabajador'
		this.accepttext()
		Select cod_trabajador
			into :ls_cod_trabajador
			from maestro 
			where cod_trabajador = :data;
		if sqlca.sqlcode = 100 then
			messagebox(is_title, 'No existe trabajador con código ' + trim(data))
			this.object.cod_trabajador[row] = ''
			this.object.nombre[row] = ''
			this.object.flag_estado[row] = ''
			return 2
		end if
		this.retrieve(ls_cod_trabajador)
end choose
end event

type ddlb_concepto from listbox within tp_2
integer x = 2427
integer y = 96
integer width = 946
integer height = 1040
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
boolean hscrollbar = true
boolean vscrollbar = true
boolean multiselect = true
borderstyle borderstyle = stylelowered!
end type

event constructor;string ls_concepto
declare lc_concep cursor  for
select rpad(cpt.concep,4,' ') || ' - ' || initcap(trim(cpt.desc_breve)) as concepto
from concepto cpt;
open lc_concep;
fetch lc_concep into :ls_concepto;
do while SQLCA.sqlcode = 0
	fetch lc_concep into :ls_concepto;
	this.additem(ls_concepto)
loop
close lc_concep;
end event

type p_12 from picture within tp_2
integer x = 2455
integer y = 24
integer width = 59
integer height = 60
string picturename = "Custom023!"
boolean focusrectangle = false
end type

type cbx_concepto from checkbox within tp_2
integer x = 3040
integer y = 16
integer width = 69
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	ddlb_concepto.enabled = false
else
	ddlb_concepto.enabled = true
end if
end event

type gb_concepto from groupbox within tp_2
integer x = 2391
integer y = 20
integer width = 1015
integer height = 1140
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "        Todos los Conceptos        "
end type

type gb_6 from groupbox within tp_2
integer x = 832
integer y = 616
integer width = 1015
integer height = 208
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "       Todos los Trabajadores        "
end type

type gb_4 from groupbox within tp_2
integer x = 27
integer y = 80
integer width = 754
integer height = 232
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "       Pagos con Tarjetas "
end type

type gb_9 from groupbox within tp_2
integer x = 27
integer y = 352
integer width = 754
integer height = 232
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "        Afiliados a A.F.P. "
end type

event constructor;cbx_afp.enabled = true
end event

type gb_7 from groupbox within tp_2
integer x = 832
integer y = 352
integer width = 1522
integer height = 232
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "      Todos los Centros de Costos        "
end type

type gb_5 from groupbox within tp_2
integer x = 827
integer y = 80
integer width = 1522
integer height = 232
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "       Todas las Areas y Secciones       "
end type

type gb_11 from groupbox within tp_2
integer x = 27
integer y = 624
integer width = 754
integer height = 204
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "       Todas las A.F.P.        "
end type

type gb_10 from groupbox within tp_2
integer x = 1883
integer y = 608
integer width = 471
integer height = 204
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "       Históricos ? "
end type

type gb_13 from groupbox within tp_2
integer x = 27
integer y = 832
integer width = 1824
integer height = 192
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "        Título del Reporte "
end type

type gb_14 from groupbox within tp_2
integer x = 32
integer y = 1024
integer width = 1815
integer height = 160
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Paginador"
end type

type gb_12 from groupbox within tp_2
integer x = 1883
integer y = 832
integer width = 471
integer height = 192
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "      Imprimir al Fin"
end type

type cb_1 from commandbutton within w_rh300_reportes_param
boolean visible = false
integer x = 78
integer y = 1660
integer width = 357
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ocultar Query"
end type

event clicked;mle_1.visible = false
cb_1.visible = false
end event

type uo_fecha from u_fecha within w_rh300_reportes_param
boolean visible = false
integer x = 2085
integer y = 344
integer taborder = 100
end type

on uo_fecha.destroy
call u_fecha::destroy
end on

type rb_fecha from radiobutton within w_rh300_reportes_param
integer x = 448
integer y = 324
integer width = 274
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Fecha"
end type

event clicked;uo_rango.visible = false

uo_fecha.visible = true

uo_semana.visible = false

st_sem.visible = false
em_sem.visible = false
st_ano.visible = false
em_ano.visible = false

st_mes_m.visible = false
ddlb_mes_m.visible = false
st_ano_m.visible = false
em_ano_m.visible = false
end event

type ddlb_tipo_trabajador from u_ddlb_lista within w_rh300_reportes_param
integer x = 2368
integer y = 100
integer width = 905
integer height = 1128
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_dddw_tipo_trabajador_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 3							// Longitud del campo 2

end event

type em_ano_m from editmask within w_rh300_reportes_param
integer x = 2729
integer y = 344
integer width = 242
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "0000"
boolean spin = true
end type

event constructor;this.text = string(year(today()))
end event

type st_ano_m from statictext within w_rh300_reportes_param
integer x = 2610
integer y = 360
integer width = 105
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type ddlb_mes_m from dropdownlistbox within w_rh300_reportes_param
integer x = 1938
integer y = 344
integer width = 635
integer height = 988
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Enero (01)"
boolean sorted = false
string item[] = {"Enero (01)","Febrero (02)","Marzo (03)","Abril (04)","Mayo (05)","Junio (06)","Julio (07)","Agosto (08)","Setiembre (09)","Octubre (10)","Noviembre (11)","Diciembre (12)"}
borderstyle borderstyle = stylelowered!
end type

event constructor;this.selectitem(month(today()))
end event

type st_mes_m from statictext within w_rh300_reportes_param
integer x = 1810
integer y = 360
integer width = 105
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type rb_mes from radiobutton within w_rh300_reportes_param
integer x = 731
integer y = 324
integer width = 187
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Mes"
boolean checked = true
end type

event clicked;if this.checked = false then return

uo_rango.visible = false

uo_fecha.visible = false

uo_semana.visible = false

st_sem.visible = false
em_sem.visible = false
st_ano.visible = false
em_ano.visible = false

st_mes_m.visible = true
ddlb_mes_m.visible = true
st_ano_m.visible = true
em_ano_m.visible = true

em_ano_m.text = string(year(today()))
end event

type p_8 from picture within w_rh300_reportes_param
integer x = 466
integer y = 256
integer width = 59
integer height = 60
string picturename = "Custom023!"
boolean focusrectangle = false
end type

type p_6 from picture within w_rh300_reportes_param
integer x = 306
integer y = 32
integer width = 59
integer height = 60
string picturename = "Custom004!"
boolean focusrectangle = false
end type

type p_5 from picture within w_rh300_reportes_param
integer x = 1166
integer y = 32
integer width = 78
integer height = 60
string picturename = "Custom042!"
boolean focusrectangle = false
end type

type p_4 from picture within w_rh300_reportes_param
integer x = 2345
integer y = 32
integer width = 64
integer height = 60
string picturename = "Move!"
boolean focusrectangle = false
end type

type st_etiqueta from statictext within w_rh300_reportes_param
boolean visible = false
integer x = 50
integer y = 1052
integer width = 402
integer height = 64
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217752
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_periodo from checkbox within w_rh300_reportes_param
integer x = 1303
integer y = 252
integer width = 73
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked then
	rb_mes.enabled = true
	rb_rango_fecha.enabled = true
	rb_semana_fecha.enabled = true
	rb_semana.enabled = true
	rb_fecha.enabled = true
	uo_rango.enabled = true
	uo_semana.enabled = true
	em_ano.enabled = true
	em_sem.enabled = true
	uo_fecha.enabled = true
	ddlb_mes_m.enabled = true
	em_ano_m.enabled = true
else
	rb_mes.enabled = false
	rb_rango_fecha.enabled = false
	rb_semana_fecha.enabled = false
	rb_semana.enabled = false
	rb_fecha.enabled = false
	uo_rango.enabled = false
	uo_semana.enabled = false
	em_ano.enabled = false
	em_sem.enabled = false
	uo_fecha.enabled = false
	ddlb_mes_m.enabled = false
	em_ano_m.enabled = false
end if
end event

type cbx_tipo_trabajador from checkbox within w_rh300_reportes_param
integer x = 2985
integer y = 28
integer width = 69
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	ddlb_tipo_trabajador.enabled = false
else
	ddlb_tipo_trabajador.enabled = true
end if
end event

type p_2 from picture within w_rh300_reportes_param
integer x = 667
integer y = 116
integer width = 59
integer height = 64
string picturename = "Custom067!"
boolean focusrectangle = false
end type

event clicked;rb_grafico.checked = true
end event

type p_1 from picture within w_rh300_reportes_param
integer x = 297
integer y = 116
integer width = 59
integer height = 64
string picturename = "Cursor!"
boolean focusrectangle = false
end type

event clicked;rb_texto.checked = true
end event

type uo_rango from u_rango_fechas within w_rh300_reportes_param
event destroy ( )
boolean visible = false
integer x = 1797
integer y = 344
end type

on uo_rango.destroy
call u_rango_fechas::destroy
end on

type rb_semana from radiobutton within w_rh300_reportes_param
integer x = 448
integer y = 396
integer width = 279
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Semana"
end type

event clicked;integer li_ano, li_semana

if this.checked = false then return

uo_rango.visible = false

uo_fecha.visible = false

uo_semana.visible = false

st_sem.visible = true
em_sem.visible = true
st_ano.visible = true
em_ano.visible = true

st_mes_m.visible = false
ddlb_mes_m.visible = false
st_ano_m.visible = false
em_ano_m.visible = false

if ii_carga_sem = 1 then return

select c.ano_calc, max(c.semana_calc) 
	into :li_ano, :li_semana
	from calendario c 
	where c.ano_calc = (select max(c.ano_calc) from calendario c) 
	group by c.ano_calc;

em_sem.text = trim(string(li_semana))
em_ano.text = trim(string(li_ano))

ii_carga_sem = 1
end event

type rb_semana_fecha from radiobutton within w_rh300_reportes_param
integer x = 731
integer y = 396
integer width = 681
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Semana &Basada en Fecha"
end type

event clicked;if this.checked = false then return

uo_rango.visible = false

uo_fecha.visible = false

uo_semana.visible = true

st_sem.visible = false
em_sem.visible = false
st_ano.visible = false
em_ano.visible = false

st_mes_m.visible = false
ddlb_mes_m.visible = false
st_ano_m.visible = false
em_ano_m.visible = false
end event

type rb_rango_fecha from radiobutton within w_rh300_reportes_param
integer x = 965
integer y = 324
integer width = 512
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de &Fechas"
end type

event clicked;if this.checked = false then return

uo_rango.visible = true

uo_fecha.visible = false

uo_semana.visible = false

st_sem.visible = false
em_sem.visible = false
st_ano.visible = false
em_ano.visible = false

st_mes_m.visible = false
ddlb_mes_m.visible = false
st_ano_m.visible = false
em_ano_m.visible = false
end event

type cbx_origen from checkbox within w_rh300_reportes_param
integer x = 1719
integer y = 28
integer width = 73
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	ddlb_origen.enabled = false
else
	ddlb_origen.enabled = true
end if
end event

type rb_grafico from radiobutton within w_rh300_reportes_param
integer x = 736
integer y = 108
integer width = 270
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Gráfico"
end type

type rb_texto from radiobutton within w_rh300_reportes_param
integer x = 366
integer y = 108
integer width = 274
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Reporte"
boolean checked = true
end type

type gb_1 from groupbox within w_rh300_reportes_param
integer x = 251
integer y = 32
integer width = 795
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "       Seleccione Presentación"
end type

type gb_2 from groupbox within w_rh300_reportes_param
integer x = 1115
integer y = 32
integer width = 1097
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "       Todos los Origenes         "
end type

type ddlb_origen from u_ddlb_lista within w_rh300_reportes_param
integer x = 1179
integer y = 100
integer width = 978
integer height = 1128
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_dddw_origen_usuario_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 2							// Longitud del campo 2

end event

event ue_item_add;//overwrite
Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item

ll_rows = ids_Data.Retrieve(gs_user)

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

end event

type st_sem from statictext within w_rh300_reportes_param
boolean visible = false
integer x = 1989
integer y = 360
integer width = 187
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Semana"
boolean focusrectangle = false
end type

type em_sem from editmask within w_rh300_reportes_param
boolean visible = false
integer x = 2199
integer y = 344
integer width = 178
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
end type

type st_ano from statictext within w_rh300_reportes_param
boolean visible = false
integer x = 2455
integer y = 360
integer width = 110
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type em_ano from editmask within w_rh300_reportes_param
boolean visible = false
integer x = 2569
integer y = 344
integer width = 238
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "0000"
boolean spin = true
end type

type uo_semana from u_semana_fecha within w_rh300_reportes_param
boolean visible = false
integer x = 1550
integer y = 344
integer taborder = 80
boolean bringtotop = true
end type

on uo_semana.destroy
call u_semana_fecha::destroy
end on

type gb_3 from groupbox within w_rh300_reportes_param
integer x = 402
integer y = 256
integer width = 2798
integer height = 232
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "        Seleccione Filtro de los Periodos          "
end type

type gb_8 from groupbox within w_rh300_reportes_param
integer x = 2295
integer y = 32
integer width = 1042
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "       Todos los Trabajadores         "
end type

type p_procesando from picture within w_rh300_reportes_param
boolean visible = false
integer x = 1737
integer y = 88
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "Custom063!"
boolean focusrectangle = false
end type

type st_procesando_title from statictext within w_rh300_reportes_param
boolean visible = false
integer y = 164
integer width = 3552
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "PROCESANDO... ESPERE UNOS SEGUNDOS POR FAVOR"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_procesando_status from statictext within w_rh300_reportes_param
boolean visible = false
integer y = 252
integer width = 3552
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type st_procesando from statictext within w_rh300_reportes_param
boolean visible = false
integer width = 3557
integer height = 516
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type mle_1 from multilineedit within w_rh300_reportes_param
boolean visible = false
integer y = 1048
integer width = 718
integer height = 352
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

