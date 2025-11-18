$PBExportHeader$w_rh441_p_adiciona_gratificacion.srw
forward
global type w_rh441_p_adiciona_gratificacion from w_prc
end type
type hpb_1 from hprogressbar within w_rh441_p_adiciona_gratificacion
end type
type em_year from editmask within w_rh441_p_adiciona_gratificacion
end type
type ddlb_mes from dropdownlistbox within w_rh441_p_adiciona_gratificacion
end type
type dw_1 from datawindow within w_rh441_p_adiciona_gratificacion
end type
type cb_1 from commandbutton within w_rh441_p_adiciona_gratificacion
end type
type cb_origen from commandbutton within w_rh441_p_adiciona_gratificacion
end type
type em_origen from editmask within w_rh441_p_adiciona_gratificacion
end type
type em_descripcion from editmask within w_rh441_p_adiciona_gratificacion
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh441_p_adiciona_gratificacion
end type
type gb_1 from groupbox within w_rh441_p_adiciona_gratificacion
end type
type gb_2 from groupbox within w_rh441_p_adiciona_gratificacion
end type
end forward

global type w_rh441_p_adiciona_gratificacion from w_prc
integer width = 3799
integer height = 1528
string title = "(RH441) Adiciona Gratificaciones Para Cálculo de Planilla"
hpb_1 hpb_1
em_year em_year
ddlb_mes ddlb_mes
dw_1 dw_1
cb_1 cb_1
cb_origen cb_origen
em_origen em_origen
em_descripcion em_descripcion
uo_1 uo_1
gb_1 gb_1
gb_2 gb_2
end type
global w_rh441_p_adiciona_gratificacion w_rh441_p_adiciona_gratificacion

type variables
n_cst_wait	invo_wait
end variables

on w_rh441_p_adiciona_gratificacion.create
int iCurrent
call super::create
this.hpb_1=create hpb_1
this.em_year=create em_year
this.ddlb_mes=create ddlb_mes
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_origen=create cb_origen
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.uo_1=create uo_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_1
this.Control[iCurrent+2]=this.em_year
this.Control[iCurrent+3]=this.ddlb_mes
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_origen
this.Control[iCurrent+7]=this.em_origen
this.Control[iCurrent+8]=this.em_descripcion
this.Control[iCurrent+9]=this.uo_1
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_rh441_p_adiciona_gratificacion.destroy
call super::destroy
destroy(this.hpb_1)
destroy(this.em_year)
destroy(this.ddlb_mes)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_origen)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.uo_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;call super::open;Date 	ld_hoy

dw_1.settransobject(SQLCA)

ld_hoy = Date(gnvo_app.of_fecha_actual())

em_year.text = string(ld_hoy, 'yyyy')

invo_wait = create n_cst_wait

end event

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10

hpb_1.width  = newwidth  - hpb_1.x - 10
end event

event close;call super::close;destroy invo_wait
end event

type hpb_1 from hprogressbar within w_rh441_p_adiciona_gratificacion
integer y = 220
integer width = 3525
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
end type

type em_year from editmask within w_rh441_p_adiciona_gratificacion
integer x = 3003
integer y = 64
integer width = 279
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
string mask = "###0"
boolean spin = true
double increment = 1
string minmax = "0~~9999"
end type

type ddlb_mes from dropdownlistbox within w_rh441_p_adiciona_gratificacion
integer x = 2427
integer y = 64
integer width = 567
integer height = 352
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string item[] = {"07. Julio","12. Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type dw_1 from datawindow within w_rh441_p_adiciona_gratificacion
integer y = 304
integer width = 3104
integer height = 964
string dataobject = "d_lista_calculo_planilla_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_rh441_p_adiciona_gratificacion
integer x = 3314
integer y = 28
integer width = 293
integer height = 152
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;String  ls_origen, ls_codtra, ls_mensaje, ls_tipo_trabaj,ls_flag_mensual, ls_year, ls_nom_trabajador
Date    ld_fec_proceso
Long    ll_i, ll_rows

try 
	invo_wait.of_mensaje('Adiciona Gratificación Para Cálculo de Planilla')
	if trim(em_origen.text) = '' then
		MessageBox('Error', 'Debe indicar el origen para el proceso', StopSign!)
		cb_origen.setFocus()
		return
	end if
	
	ls_origen = string(em_origen.text)
	
	if trim(em_year.text) = '' then
		MessageBox('Error', 'Debe indicar el año de la gratificacion para el proceso', StopSign!)
		em_year.setFocus()
		return
	end if
	
	if trim(ddlb_mes.Text) = '' then
		MessageBox('Error', 'Debe indicar el periodo de la gratificacion para el proceso', StopSign!)
		ddlb_mes.setFocus()
		return
	end if

	ls_year = em_year.text
	
	if left(ddlb_mes.text, 2) = '07' then
		ld_fec_proceso = date('15/07/' + ls_year)
	elseif left(ddlb_mes.text, 2) = '12' then
		ld_fec_proceso = date('15/12/' + ls_year)
	else
		MessageBox('Error', 'Mes indicado no existe para procesar, ' + ddlb_mes.text, StopSign!)
		ddlb_mes.setFocus()
		return
	end if
	
	//Selecciono el tipo de trabajador
	ls_tipo_trabaj = uo_1.of_get_value()
	
	if uo_1.cbx_todos.checked = false then
		dw_1.dataobject = 'd_lista_adiciona_gratificacion_tbl'
		dw_1.settransobject(sqlca)
		ll_rows = dw_1.Retrieve(ls_origen, ls_tipo_trabaj, ld_fec_proceso) 
	else
		dw_1.dataobject = 'd_lista_adiciona_gratificacion_todo_tbl'
		dw_1.settransobject(sqlca)
		ll_rows = dw_1.Retrieve(ls_origen, gs_user, ld_fec_proceso) 
	end if
	
	if dw_1.RowCount() = 0 then
		MessageBox('Error', 'No existe Gratificacion calculada para los datos ingresados, por favor Verifique!', StopSign!)
		ddlb_mes.setFocus()
		return
	end if
		
	
	//Verifico si lo han subido a las ganancias variables
	
	//INDICADOR DE GRATIFICACION MENSUAL
	ls_flag_mensual = '0'
	
	
	DECLARE USP_RH_ADICIONA_GRATIFICACION PROCEDURE FOR 
		USP_RH_ADICIONA_GRATIFICACION( :ls_codtra, 
												 :ld_fec_proceso,
												 :ls_flag_mensual ) ;
	
	FOR ll_i = 1 TO ll_rows
		yield()
		
		dw_1.ScrollToRow (ll_i)
		dw_1.SelectRow (0, false)
		dw_1.SelectRow (ll_i, true)
		
		ls_codtra 				= dw_1.object.cod_trabajador 	[ll_i]
		ls_nom_trabajador	= dw_1.object.nom_trabajador 		[ll_i]
		
		EXECUTE USP_RH_ADICIONA_GRATIFICACION ;
		
		if SQLCA.SQLCode = -1 then
			ls_mensaje = sqlca.sqlerrtext
			rollback ;
			MessageBox("SQL error", 'Error al procesar registro: ' + string(ll_i) &
											+ '~r~nTrabajador: ' + ls_codtra + '-' + ls_nom_trabajador + '.' &
											+ '~r~nError: ' + ls_mensaje, StopSign!)
			return
		end if
		
		hpb_1.Position = ll_i / ll_rows * 100
		
		yield()
	NEXT
	
	commit ;
	CLOSE USP_RH_ADICIONA_GRATIFICACION;
	
catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, '')
finally
	invo_wait.of_close()
end try

end event

type cb_origen from commandbutton within w_rh441_p_adiciona_gratificacion
integer x = 219
integer y = 64
integer width = 87
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_origen from editmask within w_rh441_p_adiciona_gratificacion
integer x = 69
integer y = 64
integer width = 151
integer height = 92
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_descripcion from editmask within w_rh441_p_adiciona_gratificacion
integer x = 302
integer y = 64
integer width = 1056
integer height = 92
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type uo_1 from u_ddlb_tipo_trabajador within w_rh441_p_adiciona_gratificacion
event destroy ( )
integer x = 1477
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type gb_1 from groupbox within w_rh441_p_adiciona_gratificacion
integer x = 2391
integer width = 910
integer height = 204
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Periodo"
end type

type gb_2 from groupbox within w_rh441_p_adiciona_gratificacion
integer width = 1467
integer height = 204
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

