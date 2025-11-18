$PBExportHeader$w_ve708_estructura_costo_ov.srw
forward
global type w_ve708_estructura_costo_ov from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_ve708_estructura_costo_ov
end type
type cb_seleccion from commandbutton within w_ve708_estructura_costo_ov
end type
type cb_aceptar from commandbutton within w_ve708_estructura_costo_ov
end type
type dw_articulos from datawindow within w_ve708_estructura_costo_ov
end type
type rb_fecha from radiobutton within w_ve708_estructura_costo_ov
end type
type rb_cliente from radiobutton within w_ve708_estructura_costo_ov
end type
type dw_grafico from datawindow within w_ve708_estructura_costo_ov
end type
type cb_barra from commandbutton within w_ve708_estructura_costo_ov
end type
type st_nom_articulo from statictext within w_ve708_estructura_costo_ov
end type
type cbx_todo from checkbox within w_ve708_estructura_costo_ov
end type
type cbx_actv from checkbox within w_ve708_estructura_costo_ov
end type
type cbx_anul from checkbox within w_ve708_estructura_costo_ov
end type
type cbx_desp from checkbox within w_ve708_estructura_costo_ov
end type
type st_etiqueta from statictext within w_ve708_estructura_costo_ov
end type
type dw_clientes from datawindow within w_ve708_estructura_costo_ov
end type
type rb_resumen from radiobutton within w_ve708_estructura_costo_ov
end type
type rb_detalle from radiobutton within w_ve708_estructura_costo_ov
end type
type gb_1 from groupbox within w_ve708_estructura_costo_ov
end type
type gb_2 from groupbox within w_ve708_estructura_costo_ov
end type
type gb_3 from groupbox within w_ve708_estructura_costo_ov
end type
type gb_4 from groupbox within w_ve708_estructura_costo_ov
end type
type gb_5 from groupbox within w_ve708_estructura_costo_ov
end type
type st_espere from statictext within w_ve708_estructura_costo_ov
end type
type cbx_canal from checkbox within w_ve708_estructura_costo_ov
end type
type cbx_sub_canal from checkbox within w_ve708_estructura_costo_ov
end type
type dw_canal from datawindow within w_ve708_estructura_costo_ov
end type
type dw_sub_canal from datawindow within w_ve708_estructura_costo_ov
end type
type cb_down_c from commandbutton within w_ve708_estructura_costo_ov
end type
type cb_canal from commandbutton within w_ve708_estructura_costo_ov
end type
type cb_down_sc from commandbutton within w_ve708_estructura_costo_ov
end type
type cb_sub_canal from commandbutton within w_ve708_estructura_costo_ov
end type
type gb_6 from groupbox within w_ve708_estructura_costo_ov
end type
end forward

global type w_ve708_estructura_costo_ov from w_report_smpl
integer width = 3621
integer height = 1744
string title = "[VE708] Reporte de Estructura de Costos"
string menuname = "m_reporte"
long backcolor = 67108864
uo_1 uo_1
cb_seleccion cb_seleccion
cb_aceptar cb_aceptar
dw_articulos dw_articulos
rb_fecha rb_fecha
rb_cliente rb_cliente
dw_grafico dw_grafico
cb_barra cb_barra
st_nom_articulo st_nom_articulo
cbx_todo cbx_todo
cbx_actv cbx_actv
cbx_anul cbx_anul
cbx_desp cbx_desp
st_etiqueta st_etiqueta
dw_clientes dw_clientes
rb_resumen rb_resumen
rb_detalle rb_detalle
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
st_espere st_espere
cbx_canal cbx_canal
cbx_sub_canal cbx_sub_canal
dw_canal dw_canal
dw_sub_canal dw_sub_canal
cb_down_c cb_down_c
cb_canal cb_canal
cb_down_sc cb_down_sc
cb_sub_canal cb_sub_canal
gb_6 gb_6
end type
global w_ve708_estructura_costo_ov w_ve708_estructura_costo_ov

type variables
string is_flag, is_estados[3], is_articulo, is_cliente = '%', is_flag_canal = '0', is_categ, is_serie
end variables

on w_ve708_estructura_costo_ov.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cb_seleccion=create cb_seleccion
this.cb_aceptar=create cb_aceptar
this.dw_articulos=create dw_articulos
this.rb_fecha=create rb_fecha
this.rb_cliente=create rb_cliente
this.dw_grafico=create dw_grafico
this.cb_barra=create cb_barra
this.st_nom_articulo=create st_nom_articulo
this.cbx_todo=create cbx_todo
this.cbx_actv=create cbx_actv
this.cbx_anul=create cbx_anul
this.cbx_desp=create cbx_desp
this.st_etiqueta=create st_etiqueta
this.dw_clientes=create dw_clientes
this.rb_resumen=create rb_resumen
this.rb_detalle=create rb_detalle
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.st_espere=create st_espere
this.cbx_canal=create cbx_canal
this.cbx_sub_canal=create cbx_sub_canal
this.dw_canal=create dw_canal
this.dw_sub_canal=create dw_sub_canal
this.cb_down_c=create cb_down_c
this.cb_canal=create cb_canal
this.cb_down_sc=create cb_down_sc
this.cb_sub_canal=create cb_sub_canal
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_seleccion
this.Control[iCurrent+3]=this.cb_aceptar
this.Control[iCurrent+4]=this.dw_articulos
this.Control[iCurrent+5]=this.rb_fecha
this.Control[iCurrent+6]=this.rb_cliente
this.Control[iCurrent+7]=this.dw_grafico
this.Control[iCurrent+8]=this.cb_barra
this.Control[iCurrent+9]=this.st_nom_articulo
this.Control[iCurrent+10]=this.cbx_todo
this.Control[iCurrent+11]=this.cbx_actv
this.Control[iCurrent+12]=this.cbx_anul
this.Control[iCurrent+13]=this.cbx_desp
this.Control[iCurrent+14]=this.st_etiqueta
this.Control[iCurrent+15]=this.dw_clientes
this.Control[iCurrent+16]=this.rb_resumen
this.Control[iCurrent+17]=this.rb_detalle
this.Control[iCurrent+18]=this.gb_1
this.Control[iCurrent+19]=this.gb_2
this.Control[iCurrent+20]=this.gb_3
this.Control[iCurrent+21]=this.gb_4
this.Control[iCurrent+22]=this.gb_5
this.Control[iCurrent+23]=this.st_espere
this.Control[iCurrent+24]=this.cbx_canal
this.Control[iCurrent+25]=this.cbx_sub_canal
this.Control[iCurrent+26]=this.dw_canal
this.Control[iCurrent+27]=this.dw_sub_canal
this.Control[iCurrent+28]=this.cb_down_c
this.Control[iCurrent+29]=this.cb_canal
this.Control[iCurrent+30]=this.cb_down_sc
this.Control[iCurrent+31]=this.cb_sub_canal
this.Control[iCurrent+32]=this.gb_6
end on

on w_ve708_estructura_costo_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_seleccion)
destroy(this.cb_aceptar)
destroy(this.dw_articulos)
destroy(this.rb_fecha)
destroy(this.rb_cliente)
destroy(this.dw_grafico)
destroy(this.cb_barra)
destroy(this.st_nom_articulo)
destroy(this.cbx_todo)
destroy(this.cbx_actv)
destroy(this.cbx_anul)
destroy(this.cbx_desp)
destroy(this.st_etiqueta)
destroy(this.dw_clientes)
destroy(this.rb_resumen)
destroy(this.rb_detalle)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.st_espere)
destroy(this.cbx_canal)
destroy(this.cbx_sub_canal)
destroy(this.dw_canal)
destroy(this.dw_sub_canal)
destroy(this.cb_down_c)
destroy(this.cb_canal)
destroy(this.cb_down_sc)
destroy(this.cb_sub_canal)
destroy(this.gb_6)
end on

event ue_retrieve;//Override
ib_preview = false

st_espere.bringtotop = true
st_espere.visible = true
setpointer(HourGlass!)

date ld_fec_ini, ld_fec_fin
long ll_count
string ls_null, ls_canal, ls_sub_canal
integer i
decimal{2} ldc_mayor, ldc_menor

ld_fec_ini = date(uo_1.of_get_fecha1())
ld_fec_fin = date(uo_1.of_get_fecha2())

setnull(ls_null)

//Reinicializando el array de flags de estados
for i = 1 to upperbound(is_estados[]) 
	is_estados[i] = ls_null
next

if cbx_todo.checked = true then
	is_estados[1] = '0'
	is_estados[2] = '1'
	is_estados[3] = '2'
end if

i = 1

if ( cbx_todo.checked = false and cbx_anul.checked = true ) then
	is_estados[i] = '0'
	i++
end if

if ( cbx_todo.checked = false and cbx_actv.checked = true ) then
	is_estados[i] = '1'
	i++
end if

if ( cbx_todo.checked = false and cbx_desp.checked = true ) then
	is_estados[i] = '2'
end if

delete from tt_canal_distribucion;
delete from tt_canal_distribucion_det;

//llenando tablas de canal y sub - canal
if cbx_canal.checked = true then
	
	if dw_canal.rowcount( ) = 0 then
		messagebox('Aviso','No ha seleccionado ningun Canal de Distribucion, Verifique!')
		st_espere.bringtotop = false
		st_espere.visible = false
		setpointer(Arrow!)
		return
	end if
	
	for i = 1 to dw_canal.rowcount( )
		
		ls_canal = dw_canal.object.canal[i]
		
		insert into tt_canal_distribucion (canal) 
		     values ( :ls_canal );
		
	next
	
	//insercion de sub canales
	if cbx_sub_canal.checked = true then
		
		if dw_sub_canal.rowcount( ) = 0 then
			messagebox('Aviso','No ha seleccionado ningun Sub - Canal de Distribucion, Verifique!')
			st_espere.bringtotop = false
			st_espere.visible = false
			setpointer(Arrow!)
		end if
		
		for i = 1 to dw_sub_canal.rowcount( )
			
			ls_sub_canal = dw_sub_canal.object.sub_canal[i]
			
			insert into tt_canal_distribucion_det (sub_canal) 
		     values ( :ls_sub_canal );
			
		next
		
	else //sino esta marcado el sub canal, insertar los sub canales dependiendo de los canales escogidos
		
		//Todos los sub - canales dependiendo de los canales escogidos
		insert into tt_canal_distribucion_det ( sub_canal )
			  select d.sub_canal
				 from canal_distribucion_det d, tt_canal_distribucion m
				where m.canal = d.canal
				group by d.sub_canal;
	
	end if
	
end if

//Filtrando check de canal
if cbx_canal.checked = true then
	
	is_flag_canal = '1' //procedimiento que genera los graficos
	
	if rb_fecha.checked = true then
		//reporte
		if rb_resumen.checked = true then
			dw_report.dataobject = 'd_rpt_estruct_costos_res_tbl_ca'
		else
			dw_report.dataobject = 'd_rpt_estruct_costos_tbl_ca'
		end if
		dw_report.SetTransObject(sqlca)
		dw_report.retrieve( ld_fec_ini, ld_fec_fin, gs_empresa, gs_user, is_estados[] )
		
		//lista
		dw_articulos.dataobject = 'd_rpt_lista_articulos_estruct_costo_ca'
		dw_articulos.settransobject(sqlca)
		dw_articulos.retrieve( ld_fec_ini, ld_fec_fin, is_estados[] )
		
		//clientes
		dw_clientes.dataobject = 'd_rpt_lista_cliente_estruct_costo_ca'
		dw_clientes.settransobject(sqlca)
		dw_clientes.retrieve( ld_fec_ini, ld_fec_fin, is_estados[] )
		
		is_flag = 'F' //procedimiento para el grafico se hace por fecha
			
	else //cliente
		select count(*)
		  into :ll_count
		  from tt_proveedor;
		
		if ll_count = 0 or isnull(ll_count) then
			messagebox('Aviso','No ha seleccionado ningun Cliente, Verifique!')
			st_espere.bringtotop = false
			st_espere.visible = false
			setpointer(Arrow!)
			return
		end if
		
		//reporte
		if rb_resumen.checked = true then
			dw_report.dataobject = 'd_rpt_estruct_costos_x_client_res_tbl_ca'
		else
			dw_report.dataobject = 'd_rpt_estruct_costos_x_cliente_tbl_ca'
		end if
		dw_report.SetTransObject(sqlca)
		dw_report.retrieve(gs_empresa, gs_user, is_estados[])
		
		//lista
		dw_articulos.dataobject = 'd_rpt_lista_art_estruct_costo_x_cl_ca'
		dw_articulos.settransobject(sqlca)
		dw_articulos.retrieve(is_estados[])
		
		//clientes
		dw_clientes.dataobject = 'd_rpt_lista_cli_estruct_costo_x_cl_ca'
		dw_clientes.settransobject(sqlca)
		dw_clientes.retrieve( is_estados[] )
		
		is_flag = 'C' //procedimiento para el grafico se hace por Clientes Seleccionados
		
	end if
	
else
	
	is_flag_canal = '0'

	if rb_fecha.checked = true then
		//reporte
		if rb_resumen.checked = true then
			dw_report.dataobject = 'd_rpt_estructura_costos_res_tbl'
		else
			dw_report.dataobject = 'd_rpt_estructura_costos_tbl'
		end if
		dw_report.SetTransObject(sqlca)
		dw_report.retrieve( ld_fec_ini, ld_fec_fin, gs_empresa, gs_user, is_estados[] )
		
		//lista
		dw_articulos.dataobject = 'd_rpt_lista_articulos_estructura_costo'
		dw_articulos.settransobject(sqlca)
		dw_articulos.retrieve( ld_fec_ini, ld_fec_fin, is_estados[] )
		
		//clientes
		dw_clientes.dataobject = 'd_rpt_lista_cliente_estructura_costo'
		dw_clientes.settransobject(sqlca)
		dw_clientes.retrieve( ld_fec_ini, ld_fec_fin, is_estados[] )
		
		is_flag = 'F' //procedimiento para el grafico se hace por fecha
			
	else //cliente
		select count(*)
		  into :ll_count
		  from tt_proveedor;
		
		if ll_count = 0 or isnull(ll_count) then
			messagebox('Aviso','No ha seleccionado ningun Cliente, Verifique!')
			st_espere.bringtotop = false
			st_espere.visible = false
			setpointer(Arrow!)
			return
		end if
		
		//reporte
		if rb_resumen.checked = true then
			dw_report.dataobject = 'd_rpt_estructura_costos_x_client_res_tbl'
		else
			dw_report.dataobject = 'd_rpt_estructura_costos_x_cliente_tbl'
		end if
		dw_report.SetTransObject(sqlca)
		dw_report.retrieve(gs_empresa, gs_user, is_estados[])
		
		//lista
		dw_articulos.dataobject = 'd_rpt_lista_articulos_estruct_costo_x_cl'
		dw_articulos.settransobject(sqlca)
		dw_articulos.retrieve(is_estados[])
		
		//clientes
		dw_clientes.dataobject = 'd_rpt_lista_cliente_estruct_costo_x_cl'
		dw_clientes.settransobject(sqlca)
		dw_clientes.retrieve( is_estados[] )
		
		is_flag = 'C' //procedimiento para el grafico se hace por Clientes Seleccionados
		
	end if
	
end if // FIN DEL IF DE CHECK CANAL Y SUB CANAL

dw_clientes.insertrow( 1 )
dw_clientes.object.comprador_final[1] = 'TODOS'
dw_clientes.Scrolltorow( 1 )
dw_clientes.selectrow( 1, true)
dw_clientes.selectrow( 2, false)

if dw_articulos.rowcount( ) > 0 then
	is_articulo = dw_articulos.object.cod_art[1]
	
	//llena la tabla temporal para el grafico
	declare usp_proc procedure for USP_VE_RPT_ESTRUCT_COSTO(:ld_fec_ini, :ld_fec_fin, :is_articulo, :is_flag, :is_cliente, :is_flag_canal);
	execute usp_proc;
	
	if sqlca.sqlcode = -1 then
		Messagebox('Aviso',string(sqlca.sqlcode)+ ' ' + string(sqlca.sqlerrtext) )
		rollback;
		st_espere.bringtotop = false
		st_espere.visible = false
		setpointer(Arrow!)
		return
	end if
	
end if

dw_grafico.retrieve(is_estados[])
dw_grafico.event ue_graphcreate()

dw_report.object.p_logo.filename = gs_logo

//MOdificando escala del grafico
select max(valor)
  into :ldc_mayor
  from tt_ve_graf_asignacion_costo;

select min(valor)
  into :ldc_menor
  from tt_ve_graf_asignacion_costo;
  
dw_grafico.object.gr_1.Values.autoscale = 0

dw_grafico.object.gr_1.Values.MaximumValue = integer(ldc_mayor + 1)

if integer(ldc_menor - 1) < 0 then
	dw_grafico.object.gr_1.Values.MinimumValue = 0
else
	dw_grafico.object.gr_1.Values.MinimumValue = integer(ldc_menor - 1)
end if

this.event ue_preview()

st_espere.bringtotop = false
st_espere.visible = false
setpointer(Arrow!)
end event

event resize;call super::resize;//boton
cb_barra.height = newheight - cb_barra.y - 32

//listas (articulos - cliente)

dw_articulos.height = ( dw_report.height / 2 )

dw_clientes.y = ( dw_articulos.height + dw_articulos.y ) + 25
dw_clientes.height = ( dw_report.height / 2 ) - 60

//grafico
dw_grafico.width = newwidth - dw_grafico.x - 32
dw_grafico.height = newheight - dw_grafico.y - 32

//Ubicacion de etiqueta espero por favor


st_espere.x = ( (newwidth / 2) - (st_espere.width / 2) )

st_espere.y = ( (newheight / 2 )  -  (st_espere.height / 2 ) )
end event

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = true
end event

event mousemove;call super::mousemove;st_nom_articulo.visible = false
end event

type dw_report from w_report_smpl`dw_report within w_ve708_estructura_costo_ov
integer x = 183
integer y = 512
integer width = 3328
integer height = 964
integer ii_zoom_actual = 100
end type

type uo_1 from u_ingreso_rango_fechas within w_ve708_estructura_costo_ov
event destroy ( )
integer x = 73
integer y = 116
integer height = 80
integer taborder = 60
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Del:','Al:') 								//	para setear la fecha inicial
of_set_fecha(date(relativedate(today(),-1)), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cb_seleccion from commandbutton within w_ve708_estructura_costo_ov
integer x = 1518
integer y = 116
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Seleccion..."
end type

event clicked;opensheet(w_seleccion_clientes_x_canal, parent, 1, Original!)
end event

type cb_aceptar from commandbutton within w_ve708_estructura_costo_ov
integer x = 3182
integer y = 160
integer width = 334
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event ue_retrieve()
end event

type dw_articulos from datawindow within w_ve708_estructura_costo_ov
event ue_mousemove pbm_dwnmousemove
boolean visible = false
integer x = 183
integer y = 512
integer width = 773
integer height = 448
integer taborder = 30
boolean bringtotop = true
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;if row = 0 then return

string ls_col

if dwo.name = 'nom_articulo' then
	
	st_nom_articulo.BringToTop = TRUE 
		
	st_nom_articulo.visible = true
		
	st_nom_articulo.text = trim(this.object.nom_articulo[row])
		
	st_nom_articulo.width = len(st_nom_articulo.text) * 30
		
	st_nom_articulo.move( PixelsToUnits ( xpos, XPixelsToUnits! ) + this.x + 60, PixelsToUnits ( ypos, YPixelsToUnits! ) + this.y + 80 )

else

	st_nom_articulo.visible = false
	
end if
end event

event constructor;settransobject(Sqlca)
end event

event rowfocuschanged;f_select_current_row(this)
end event

event clicked;if row = 0 then return

st_espere.bringtotop = true
st_espere.visible = true
setpointer(HourGlass!)

date ld_fec_ini, ld_fec_fin
decimal{2} ldc_mayor, ldc_menor

ld_fec_ini = date(uo_1.of_get_fecha1())
ld_fec_fin = date(uo_1.of_get_fecha2())

is_articulo = this.object.cod_art[row]

//llena la tabla temporal para el grafico
declare usp_proc procedure for USP_VE_RPT_ESTRUCT_COSTO(:ld_fec_ini, :ld_fec_fin, :is_articulo, :is_flag, :is_cliente, :is_flag_canal);
execute usp_proc;

if sqlca.sqlcode = -1 then
	Messagebox('Aviso',string(sqlca.sqlcode)+ ' ' + string(sqlca.sqlerrtext) )
	rollback;
	st_espere.bringtotop = false
	st_espere.visible = false
	setpointer(Arrow!)
	return
end if

dw_grafico.retrieve( is_estados[] )
dw_grafico.event ue_graphcreate()

//MOdificando escala del grafico
select max(valor)
  into :ldc_mayor
  from tt_ve_graf_asignacion_costo;

select min(valor)
  into :ldc_menor
  from tt_ve_graf_asignacion_costo;
  
dw_grafico.object.gr_1.Values.autoscale = 0

dw_grafico.object.gr_1.Values.MaximumValue = integer(ldc_mayor + 1)

if integer(ldc_menor - 1) < 0 then
	dw_grafico.object.gr_1.Values.MinimumValue = 0
else
	dw_grafico.object.gr_1.Values.MinimumValue = integer(ldc_menor - 1)
end if

st_espere.bringtotop = false
st_espere.visible = false
setpointer(Arrow!)
end event

type rb_fecha from radiobutton within w_ve708_estructura_costo_ov
integer x = 270
integer y = 28
integer width = 64
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked = true then
	rb_cliente.checked = false
end if
end event

type rb_cliente from radiobutton within w_ve708_estructura_costo_ov
integer x = 1687
integer y = 36
integer width = 59
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

event clicked;if this.checked = true then
	cb_seleccion.enabled = true
	rb_fecha.checked = false
else
	cb_seleccion.enabled = false
end if
end event

type dw_grafico from datawindow within w_ve708_estructura_costo_ov
event ue_graphcreate pbm_dwngraphcreate
event ue_mousemove pbm_mousemove
boolean visible = false
integer x = 992
integer y = 512
integer width = 2523
integer height = 964
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_rpt_asigna_estructura_costo_graf"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_graphcreate;this.SetSeriesStyle("gr_1",'PRECIO CALCULADO',LineColor!, 255)
this.SetSeriesStyle("gr_1",'PRECIO CALCULADO',ForeGround!, 255)
this.SetSeriesStyle("gr_1",'PRECIO CALCULADO',Continuous!, 1)
this.SetSeriesStyle("gr_1",'PRECIO CALCULADO',Symbolx!)

this.SetSeriesStyle("gr_1",'PRECIO VENTA',LineColor!, 16711680)
this.SetSeriesStyle("gr_1",'PRECIO VENTA',ForeGround!, 16711680)
this.SetSeriesStyle("gr_1",'PRECIO VENTA',Continuous!, 1)
this.SetSeriesStyle("gr_1",'PRECIO VENTA',Symbolx!)
end event

event ue_mousemove;//codigo
Int  li_Rtn, li_Series, li_Category 
String  ls_serie, ls_categ, ls_mensaje, ls_prov, ls_nom_prov
Long ll_row 
decimal{2} ldc_precio, ldc_cant
decimal{8} ldc_costo = 0
datetime ldt_fecha

st_nom_articulo.visible = false

grObjectType MouseMoveObject 

MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)

IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	
	ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías  (OV)
	ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo (PRECIO CALCULADO O PRECIO VENTA)
	
	if trim(ls_serie) = 'PRECIO VENTA' then //Precio NOrmal
	
		Select ov.fec_registro, ov.comprador_final, p.Nom_Proveedor, round(amp.precio_unit,2), round(amp.cant_proyect,2)
		  into :ldt_fecha, :ls_prov, :ls_nom_prov, :Ldc_precio, :ldc_cant
		  From ov_costo_teorico oct, orden_venta ov,
				 articulo_mov_proy amp, proveedor p
		 Where oct.Org_Amp = ov.cod_origen
			And oct.nro_ov  = ov.nro_ov
			And ov.cod_origen = amp.cod_origen
			And ov.nro_ov     = amp.nro_doc
			And amp.tipo_doc  = ( Select doc_ov From logparam Where reckey = '1' )
			And ov.comprador_final = p.proveedor
			And trim(oct.nro_ov)   = trim(:ls_categ)
			And trim(amp.cod_art)  = trim(:is_articulo) // obtenido en el clic de la lista o en el retrieve general
		 Group By ov.fec_registro, ov.comprador_final, p.Nom_Proveedor, amp.precio_unit, amp.cant_proyect;
				 
	else //Precio calculado
		
		Select ov.fec_registro, ov.comprador_final, p.Nom_Proveedor, amp.precio_unit, round(Sum(oct.costo_unitario),8), amp.cant_proyect
		  into :ldt_fecha, :ls_prov, :ls_nom_prov, :Ldc_precio, :ldc_costo, :ldc_cant
		  From ov_costo_teorico oct, orden_venta ov,
				 articulo_mov_proy amp, proveedor p
		 Where oct.Org_Amp = ov.cod_origen
			And oct.nro_ov  = ov.nro_ov
			And ov.cod_origen = amp.cod_origen
			And ov.nro_ov     = amp.nro_doc
			And amp.tipo_doc  = ( Select doc_ov From logparam Where reckey = '1' )
			And ov.comprador_final = p.proveedor
			And trim(oct.nro_ov)   = trim(:ls_categ)
			And trim(amp.cod_art)  = trim(:is_articulo) // obtenido en el clic de la lista o en el retrieve general
		 Group By ov.fec_registro, ov.comprador_final, p.Nom_Proveedor, amp.precio_unit, amp.cant_proyect;
		
	end if
	
	ls_mensaje = ' Cliente :'+ls_prov + '~n            '+trim(ls_nom_prov)+'~n'
	ls_mensaje = ls_mensaje + '       Fecha: '+string(ldt_fecha,'dd/mm/yyyy hh:mm:ss')+'~n'
	ls_mensaje = ls_mensaje + ' Precio Unit: '+string(round(ldc_precio + ldc_costo,2))+'~n'
	ls_mensaje = ls_mensaje + '    Cantidad: '+string(ldc_cant)+'~n'
	ls_mensaje = ls_mensaje + '   Sub Total: '+string(round((ldc_precio + ldc_costo) * ldc_cant,2))
	st_etiqueta.BringToTop = TRUE 
	st_etiqueta.text = ls_mensaje 
	
	st_etiqueta.width = (len(trim(ls_nom_prov)) + 12) * 30
	st_etiqueta.height = 6 * 60
	
	if ls_categ <> is_categ or ls_serie <> is_serie then
	
		is_categ = ls_categ
		is_serie = ls_serie
		
		if ( st_etiqueta.width + st_etiqueta.x ) < parent.width then
			
			st_etiqueta.move( ( xpos + this.x + 60), ( ypos + this.y + 80) )
			
		end if

		if ( ( st_etiqueta.width + st_etiqueta.x ) > parent.width ) then
			
			st_etiqueta.move( ( ( xpos + this.x ) - st_etiqueta.width ) , ( ypos + this.y + 80) )
			
		end if
	
	end if
	
	st_etiqueta.visible = true 
	
ELSE 
	
 	st_etiqueta.visible = false 
	 
END IF
end event

event constructor;settransobject(sqlca)
end event

type cb_barra from commandbutton within w_ve708_estructura_costo_ov
integer x = 37
integer y = 512
integer width = 114
integer height = 964
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

event clicked;if this.text = '>>' then
	
	dw_articulos.visible = true
	dw_grafico.visible   = true
	dw_clientes.visible  = true
	
	dw_report.visible = false
	
	this.text = '<<'
	
else
	
	dw_articulos.visible = false
	dw_grafico.visible   = false
	dw_clientes.visible  = false
	
	dw_report.visible = true
	
	this.text = '>>'
	
end if
end event

type st_nom_articulo from statictext within w_ve708_estructura_costo_ov
boolean visible = false
integer x = 3182
integer y = 96
integer width = 334
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean border = true
boolean focusrectangle = false
end type

type cbx_todo from checkbox within w_ve708_estructura_costo_ov
integer x = 2007
integer y = 96
integer width = 288
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if this.checked = true then
	cbx_actv.checked = false
	cbx_anul.checked = false
	cbx_desp.checked = false
end if
end event

type cbx_actv from checkbox within w_ve708_estructura_costo_ov
integer x = 2007
integer y = 172
integer width = 288
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Activas"
end type

event clicked;if this.checked = true then
	cbx_todo.checked = false
end if
end event

type cbx_anul from checkbox within w_ve708_estructura_costo_ov
integer x = 2304
integer y = 96
integer width = 407
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Anuladas"
end type

event clicked;if this.checked = true then
	cbx_todo.checked = false
end if
end event

type cbx_desp from checkbox within w_ve708_estructura_costo_ov
integer x = 2304
integer y = 172
integer width = 407
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Despachadas"
end type

event clicked;if this.checked = true then
	cbx_todo.checked = false
end if
end event

type st_etiqueta from statictext within w_ve708_estructura_costo_ov
boolean visible = false
integer x = 3182
integer y = 32
integer width = 334
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean border = true
boolean focusrectangle = false
end type

type dw_clientes from datawindow within w_ve708_estructura_costo_ov
event ue_mousemove pbm_dwnmousemove
boolean visible = false
integer x = 183
integer y = 1032
integer width = 773
integer height = 448
integer taborder = 40
boolean bringtotop = true
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;if row = 0 then return

string ls_col

if dwo.name = 'nom_proveedor' then
	
	st_nom_articulo.BringToTop = TRUE 
		
	st_nom_articulo.visible = true
		
	st_nom_articulo.text = trim(this.object.nom_proveedor[row])
		
	st_nom_articulo.width = len(st_nom_articulo.text) * 30
		
	st_nom_articulo.move( PixelsToUnits ( xpos, XPixelsToUnits! ) + this.x + 60, PixelsToUnits ( ypos, YPixelsToUnits! ) + this.y + 80)

else

	st_nom_articulo.visible = false
	
end if
end event

event clicked;if row = 0 then return

st_espere.bringtotop = true
st_espere.visible = true
setpointer(HourGlass!)

date ld_fec_ini, ld_fec_fin
decimal{2} ldc_mayor, ldc_menor

ld_fec_ini = date(uo_1.of_get_fecha1())
ld_fec_fin = date(uo_1.of_get_fecha2())

is_cliente = this.object.comprador_final[row]

if trim(is_cliente) = 'TODOS' then 
	is_cliente = '%'
end if

//llena la tabla temporal para el grafico
declare usp_proc procedure for USP_VE_RPT_ESTRUCT_COSTO(:ld_fec_ini, :ld_fec_fin, :is_articulo, :is_flag, :is_cliente, :is_flag_canal);
execute usp_proc;

if sqlca.sqlcode = -1 then
	Messagebox('Aviso',string(sqlca.sqlcode)+ ' ' + string(sqlca.sqlerrtext) )
	rollback;
	st_espere.bringtotop = false
	st_espere.visible = false
	setpointer(Arrow!)
	return
end if

dw_grafico.retrieve( is_estados[] )
dw_grafico.event ue_graphcreate()

//MOdificando escala del grafico
select max(valor)
  into :ldc_mayor
  from tt_ve_graf_asignacion_costo;

select min(valor)
  into :ldc_menor
  from tt_ve_graf_asignacion_costo;
  
dw_grafico.object.gr_1.Values.autoscale = 0

dw_grafico.object.gr_1.Values.MaximumValue = integer(ldc_mayor + 1)

if integer(ldc_menor - 1) < 0 then
	dw_grafico.object.gr_1.Values.MinimumValue = 0
else
	dw_grafico.object.gr_1.Values.MinimumValue = integer(ldc_menor - 1)
end if

st_espere.bringtotop = false
st_espere.visible = false
setpointer(Arrow!)
end event

event constructor;settransobject(Sqlca)
end event

event rowfocuschanged;f_select_current_row(this)
end event

type rb_resumen from radiobutton within w_ve708_estructura_costo_ov
integer x = 2779
integer y = 100
integer width = 325
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
string text = "&Resumen"
boolean checked = true
end type

type rb_detalle from radiobutton within w_ve708_estructura_costo_ov
integer x = 2779
integer y = 172
integer width = 325
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
string text = "&Detalle"
end type

type gb_1 from groupbox within w_ve708_estructura_costo_ov
integer x = 37
integer y = 32
integer width = 1358
integer height = 228
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

type gb_2 from groupbox within w_ve708_estructura_costo_ov
integer x = 1426
integer y = 32
integer width = 517
integer height = 228
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Clientes"
end type

type gb_3 from groupbox within w_ve708_estructura_costo_ov
integer x = 1975
integer y = 32
integer width = 745
integer height = 228
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Estados OV"
end type

type gb_4 from groupbox within w_ve708_estructura_costo_ov
integer x = 2743
integer y = 32
integer width = 407
integer height = 228
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

type gb_5 from groupbox within w_ve708_estructura_costo_ov
integer x = 37
integer y = 288
integer width = 1541
integer height = 196
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Canal [Opcional]"
end type

type st_espere from statictext within w_ve708_estructura_costo_ov
boolean visible = false
integer x = 1038
integer y = 788
integer width = 1742
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 255
string text = "Procesando, Espere Por Favor ..."
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cbx_canal from checkbox within w_ve708_estructura_costo_ov
integer x = 494
integer y = 292
integer width = 59
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

event clicked;if this.checked = true then
	
	cbx_sub_canal.enabled = true
	
	dw_canal.enabled = true
	cb_down_c.enabled = true
	cb_canal.enabled = true
		
else
	
	dw_canal.reset( )
	delete from tt_canal_distribucion;
	
	dw_canal.enabled = false
	cb_down_c.enabled = false
	cb_canal.enabled = false
	
	cbx_sub_canal.enabled = false
	cbx_sub_canal.checked = false
	
	dw_sub_canal.enabled = false
	cb_down_sc.enabled = false
	cb_sub_canal.enabled = false
	
	dw_sub_canal.reset( )
	delete from tt_canal_distribucion_det;
	
end if
end event

type cbx_sub_canal from checkbox within w_ve708_estructura_costo_ov
integer x = 2208
integer y = 292
integer width = 59
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
end type

event clicked;if this.checked = true then
	
	dw_sub_canal.enabled = true
	cb_down_sc.enabled = true
	cb_sub_canal.enabled = true
		
else
	
	dw_sub_canal.reset( )
	delete from tt_canal_distribucion_det;
	
	dw_sub_canal.enabled = false
	cb_down_sc.enabled = false
	cb_sub_canal.enabled = false
	
end if
end event

type dw_canal from datawindow within w_ve708_estructura_costo_ov
integer x = 69
integer y = 360
integer width = 1029
integer height = 88
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_ext_canal"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_sub_canal from datawindow within w_ve708_estructura_costo_ov
integer x = 1641
integer y = 360
integer width = 1029
integer height = 88
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_ext_sub_canal"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_down_c from commandbutton within w_ve708_estructura_costo_ov
integer x = 1111
integer y = 356
integer width = 119
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "\/"
end type

event clicked;if this.text = '\/' then
	
	dw_canal.bringtotop = true
	
	dw_canal.height = (88 * 5)
	
	this.text = '/\'
	
else
	
	dw_canal.height = 88
	
	this.text = '\/'
	
end if
end event

type cb_canal from commandbutton within w_ve708_estructura_costo_ov
integer x = 1243
integer y = 356
integer width = 302
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Seleccion..."
end type

event clicked;open(w_seleccion_canal)

long ll_count, ll_row
string ls_cod, ls_desc

select count(*) 
  into :ll_count
  from tt_canal_distribucion;

dw_canal.reset( )

if ll_count = 0 then
	
	MessageBox('Aviso','No ha Seleccionado Ningun Canal de distribucion')
	dw_canal.reset( )
	delete from tt_canal_distribucion;
	dw_sub_canal.reset( )
	delete from tt_canal_distribucion_det;
	return
	
else
	
	declare c_canal cursor for
	select canal, descripcion
	  from tt_canal_distribucion;
	
	open c_canal;
	
	fetch c_canal into :ls_cod, :ls_desc;
	DO WHILE sqlca.sqlCode = 0
		
		ll_row = dw_canal.insertrow(0)
		
		dw_canal.object.canal[ll_row] = ls_cod
		dw_canal.object.descripcion[ll_row] = ls_desc
		
		FETCH c_canal INTO :ls_cod, :ls_desc;
	LOOP
	close c_canal;

end if
	
end event

type cb_down_sc from commandbutton within w_ve708_estructura_costo_ov
integer x = 2688
integer y = 360
integer width = 119
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "\/"
end type

event clicked;if this.text = '\/' then
	
	dw_sub_canal.bringtotop = true
	
	dw_sub_canal.height = (88 * 5)
	
	this.text = '/\'
	
else
	
	dw_sub_canal.height = 88
	
	this.text = '\/'
	
end if
end event

type cb_sub_canal from commandbutton within w_ve708_estructura_costo_ov
integer x = 2821
integer y = 360
integer width = 302
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Seleccion..."
end type

event clicked;long ll_count, ll_row
string ls_cod, ls_desc, ls_canal, ls_canal_array[]
integer i
str_parametros lstr_parametros

if dw_canal.rowcount( ) = 0 then
	messagebox('Aviso','No ha Seleccionado Ningun Canal de Distribucion como para determinar los Sub - Canales a escoger')
	dw_sub_canal.reset( )
	delete from tt_canal_distribucion_det;
	return
end if

for i = 1 to dw_canal.rowcount( )
	
	ls_canal_array[i] = dw_canal.object.canal[i]
	
next

lstr_parametros.str_array[] = ls_canal_array[]

openwithparm(w_seleccion_sub_canal,lstr_parametros)


select count(*) 
  into :ll_count
  from tt_canal_distribucion_det;

dw_sub_canal.reset( )

if ll_count = 0 then
	
	MessageBox('Aviso','No ha Seleccionado Ningun Sub - Canal de distribucion')
	return
	
else
	
	declare c_sub_canal cursor for
	select canal, sub_canal, descripcion
	  from tt_canal_distribucion_det;
	
	open c_sub_canal;
	
	fetch c_sub_canal into :ls_canal, :ls_cod, :ls_desc;
	DO WHILE sqlca.sqlCode = 0
		
		ll_row = dw_sub_canal.insertrow(0)
		
		dw_sub_canal.object.canal[ll_row]       = ls_canal
		dw_sub_canal.object.sub_canal[ll_row]   = ls_cod
		dw_sub_canal.object.descripcion[ll_row] = ls_desc
		
		FETCH c_sub_canal INTO :ls_canal, :ls_cod, :ls_desc;
	LOOP
	close c_sub_canal;

end if
	
end event

type gb_6 from groupbox within w_ve708_estructura_costo_ov
integer x = 1609
integer y = 288
integer width = 1541
integer height = 196
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sub - Canal [Opcional]"
end type

