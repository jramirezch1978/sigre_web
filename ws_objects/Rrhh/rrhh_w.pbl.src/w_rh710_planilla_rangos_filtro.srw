$PBExportHeader$w_rh710_planilla_rangos_filtro.srw
forward
global type w_rh710_planilla_rangos_filtro from w_report_smpl
end type
type cb_3 from commandbutton within w_rh710_planilla_rangos_filtro
end type
type em_descripcion from editmask within w_rh710_planilla_rangos_filtro
end type
type em_origen from editmask within w_rh710_planilla_rangos_filtro
end type
type cb_procesar from commandbutton within w_rh710_planilla_rangos_filtro
end type
type uo_2 from u_ingreso_rango_fechas within w_rh710_planilla_rangos_filtro
end type
type gb_2 from groupbox within w_rh710_planilla_rangos_filtro
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh710_planilla_rangos_filtro
end type
type cbx_grupos from checkbox within w_rh710_planilla_rangos_filtro
end type
type cb_grupos from commandbutton within w_rh710_planilla_rangos_filtro
end type
type cbx_tipos from checkbox within w_rh710_planilla_rangos_filtro
end type
type cb_tipos from commandbutton within w_rh710_planilla_rangos_filtro
end type
type cbx_sindicato from checkbox within w_rh710_planilla_rangos_filtro
end type
type cb_sindicato from commandbutton within w_rh710_planilla_rangos_filtro
end type
end forward

global type w_rh710_planilla_rangos_filtro from w_report_smpl
integer width = 4832
integer height = 2048
string title = "[RH710] Planilla Horizontal x Rangos con Filtros"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
cb_procesar cb_procesar
uo_2 uo_2
gb_2 gb_2
uo_1 uo_1
cbx_grupos cbx_grupos
cb_grupos cb_grupos
cbx_tipos cbx_tipos
cb_tipos cb_tipos
cbx_sindicato cbx_sindicato
cb_sindicato cb_sindicato
end type
global w_rh710_planilla_rangos_filtro w_rh710_planilla_rangos_filtro

on w_rh710_planilla_rangos_filtro.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_procesar=create cb_procesar
this.uo_2=create uo_2
this.gb_2=create gb_2
this.uo_1=create uo_1
this.cbx_grupos=create cbx_grupos
this.cb_grupos=create cb_grupos
this.cbx_tipos=create cbx_tipos
this.cb_tipos=create cb_tipos
this.cbx_sindicato=create cbx_sindicato
this.cb_sindicato=create cb_sindicato
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cb_procesar
this.Control[iCurrent+5]=this.uo_2
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.uo_1
this.Control[iCurrent+8]=this.cbx_grupos
this.Control[iCurrent+9]=this.cb_grupos
this.Control[iCurrent+10]=this.cbx_tipos
this.Control[iCurrent+11]=this.cb_tipos
this.Control[iCurrent+12]=this.cbx_sindicato
this.Control[iCurrent+13]=this.cb_sindicato
end on

on w_rh710_planilla_rangos_filtro.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_procesar)
destroy(this.uo_2)
destroy(this.gb_2)
destroy(this.uo_1)
destroy(this.cbx_grupos)
destroy(this.cb_grupos)
destroy(this.cbx_tipos)
destroy(this.cb_tipos)
destroy(this.cbx_sindicato)
destroy(this.cb_sindicato)
end on

event ue_retrieve;string 	ls_origen, ls_tipo_trabaj
date 		ld_fecha_ini, ld_fecha_fin 
Long		ll_count

ls_origen 		= string(em_origen.text)

if isnull(ls_origen) or trim(ls_origen) = '' then 
	MessageBox('Error', 'Debe seleccionar el origen para continuar, por favor verifique!', StopSign!)
	return
end if

ld_fecha_ini 	= uo_2.of_get_fecha1()
ld_fecha_fin 	= uo_2.of_get_fecha2()

ls_tipo_trabaj = uo_1.of_get_value()

if isnull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then ls_tipo_trabaj = '%'

//GRupos de Trabajadores
if cbx_grupos.checked then
	delete TT_RRHH_GRUPO_TRABAJADOR;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_RRHH_GRUPO_TRABAJADOR' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_RRHH_GRUPO_TRABAJADOR(grupo_trabaj)
	select distinct t.grupo_trabaj
  	  from rrhh_grupo_trabajador t,
       	 maestro               m
    where m.grupo_trabaj = t.grupo_trabaj;
		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_RRHH_GRUPO_TRABAJADOR' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_RRHH_GRUPO_TRABAJADOR;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar un grupo de trabajadores, por favor verifique!', StopSign!)
		return
	end if
end if

//Tipos de contrato
if cbx_tipos.checked then
	delete TT_SITUACION_TRABAJADOR;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_SITUACION_TRABAJADOR' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_SITUACION_TRABAJADOR(situa_trabaj)
	select distinct st.situa_trabaj
	  from situacion_trabajador st,
     		 maestro              m
	 where m.situa_trabaj = st.situa_trabaj;
		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_SITUACION_TRABAJADOR' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_SITUACION_TRABAJADOR;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar un Tipo de Contrato, por favor verifique!', StopSign!)
		return
	end if
end if

//Estados de sindicato
if cbx_sindicato.checked then
	delete TT_SINDICATO;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_SINDICATO' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_SINDICATO(flag_sindicato)
	select distinct flag_sindicato
	from maestro  ;
		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_SINDICATO' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_SINDICATO;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar un Estado de Sindicato, por favor verifique!', StopSign!)
		return
	end if
end if



dw_report.SetTransObject(SQLCA)
dw_report.retrieve(ls_origen, ls_tipo_trabaj, ld_fecha_ini, ld_fecha_fin)


dw_report.Object.t_titulo1.text = 'Del ' + string(ld_fecha_ini, 'dd/mm/yyyy') &
											 + 'Al ' + string(ld_fecha_fin, 'dd/mm/yyyy')


end event

event ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)


end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type dw_report from w_report_smpl`dw_report within w_rh710_planilla_rangos_filtro
integer y = 312
integer width = 4343
integer height = 1236
integer taborder = 50
string dataobject = "d_rpt_plla_horizontal_filtros_crt"
end type

event dw_report::clicked;call super::clicked;f_select_current_row(this)
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type cb_3 from commandbutton within w_rh710_planilla_rangos_filtro
integer x = 197
integer y = 72
integer width = 87
integer height = 80
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

type em_descripcion from editmask within w_rh710_planilla_rangos_filtro
integer x = 293
integer y = 76
integer width = 759
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh710_planilla_rangos_filtro
integer x = 50
integer y = 76
integer width = 133
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type cb_procesar from commandbutton within w_rh710_planilla_rangos_filtro
integer x = 3826
integer width = 352
integer height = 224
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type uo_2 from u_ingreso_rango_fechas within w_rh710_planilla_rangos_filtro
integer x = 1120
integer y = 212
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_2.destroy
call u_ingreso_rango_fechas::destroy
end on

type gb_2 from groupbox within w_rh710_planilla_rangos_filtro
integer width = 1097
integer height = 292
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type uo_1 from u_ddlb_tipo_trabajador within w_rh710_planilla_rangos_filtro
integer x = 1125
integer height = 204
integer taborder = 20
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type cbx_grupos from checkbox within w_rh710_planilla_rangos_filtro
integer x = 2048
integer width = 640
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Grupos de Trabajadores"
boolean checked = true
end type

event clicked;if this.checked then
	cb_grupos.enabled = false
else
	cb_grupos.enabled = true
end if
end event

type cb_grupos from commandbutton within w_rh710_planilla_rangos_filtro
integer x = 2048
integer y = 76
integer width = 640
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Grupos de Trabajadores"
end type

event clicked;Long ll_count
str_parametros lstr_param 


delete TT_RRHH_GRUPO_TRABAJADOR ;
commit;

lstr_param.dw1			= 'd_lista_grupo_trabaj_tbl'
lstr_param.titulo		= 'Listado de Grupos de Trabajadores'
lstr_param.opcion   	= 2
lstr_param.tipo		= ''


OpenWithParm( w_abc_seleccion, lstr_param)
end event

type cbx_tipos from checkbox within w_rh710_planilla_rangos_filtro
integer x = 2697
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Tipo de contrato"
boolean checked = true
end type

event clicked;if this.checked then
	cb_tipos.enabled = false
else
	cb_tipos.enabled = true
end if
end event

type cb_tipos from commandbutton within w_rh710_planilla_rangos_filtro
integer x = 2697
integer y = 76
integer width = 539
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
string text = "Tipo de Contrato"
end type

event clicked;Long ll_count
str_parametros lstr_param 


delete TT_SITUACION_TRABAJADOR ;
commit;

lstr_param.dw1			= 'd_lista_situacion_trabaj_tbl'
lstr_param.titulo		= 'Listado de Tipos de Contrato'
lstr_param.opcion   	= 3
lstr_param.tipo		= ''


OpenWithParm( w_abc_seleccion, lstr_param)
end event

type cbx_sindicato from checkbox within w_rh710_planilla_rangos_filtro
integer x = 3250
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Sindicato"
boolean checked = true
end type

event clicked;if this.checked then
	cb_sindicato.enabled = false
else
	cb_sindicato.enabled = true
end if
end event

type cb_sindicato from commandbutton within w_rh710_planilla_rangos_filtro
integer x = 3250
integer y = 76
integer width = 539
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
string text = "Sindicato"
end type

event clicked;Long ll_count
str_parametros lstr_param 


delete TT_SINDICATO ;
commit;

lstr_param.dw1			= 'd_lista_sindicatos_tbl'
lstr_param.titulo		= 'Listado de estados de Sindicato'
lstr_param.opcion   	= 4
lstr_param.tipo		= ''


OpenWithParm( w_abc_seleccion, lstr_param)
end event

