$PBExportHeader$w_rh301_dias_falta.srw
forward
global type w_rh301_dias_falta from w_abc
end type
type cb_4 from commandbutton within w_rh301_dias_falta
end type
type st_mensaje from statictext within w_rh301_dias_falta
end type
type st_3 from statictext within w_rh301_dias_falta
end type
type em_descripcion from editmask within w_rh301_dias_falta
end type
type cb_1 from commandbutton within w_rh301_dias_falta
end type
type em_origen from editmask within w_rh301_dias_falta
end type
type cb_3 from commandbutton within w_rh301_dias_falta
end type
type st_2 from statictext within w_rh301_dias_falta
end type
type em_dias from editmask within w_rh301_dias_falta
end type
type st_1 from statictext within w_rh301_dias_falta
end type
type dw_master from u_dw_cns within w_rh301_dias_falta
end type
type gb_1 from groupbox within w_rh301_dias_falta
end type
type em_tipo from editmask within w_rh301_dias_falta
end type
type cb_2 from commandbutton within w_rh301_dias_falta
end type
type em_desc_tipo from editmask within w_rh301_dias_falta
end type
end forward

global type w_rh301_dias_falta from w_abc
integer width = 3520
integer height = 1964
string title = "[RH301] Desctivacion de Trabajador dias de falta"
string menuname = "m_master_simple"
event ue_retrieve ( )
event ue_procesar ( )
event ue_saveas_excel ( )
event ue_saveas ( )
event ue_saveas_pdf ( )
event ue_desactivar ( )
cb_4 cb_4
st_mensaje st_mensaje
st_3 st_3
em_descripcion em_descripcion
cb_1 cb_1
em_origen em_origen
cb_3 cb_3
st_2 st_2
em_dias em_dias
st_1 st_1
dw_master dw_master
gb_1 gb_1
em_tipo em_tipo
cb_2 cb_2
em_desc_tipo em_desc_tipo
end type
global w_rh301_dias_falta w_rh301_dias_falta

event ue_retrieve();String 	ls_tipo_trabajador, ls_origen
Integer	li_Dias_falta
dateTime	ldt_hora1, ldt_hora2
Decimal	ldc_tiempo

ldt_hora1 = gnvo_app.of_fecha_actual() 

ls_tipo_trabajador 	= trim(em_tipo.text) + '%'
li_dias_falta			= Integer(em_dias.text)
ls_origen				= em_origen.text

dw_master.Retrieve( ls_origen, ls_tipo_trabajador, li_dias_falta )

ldt_hora2 = gnvo_app.of_fecha_actual()

//Determino el tiempo transcurrido
select (:ldt_hora2 - :ldt_hora1) * 24 * 60 * 60
  into :ldc_tiempo
  from dual;
  
st_mensaje.text = 'Tiempo Transcurrido: ' + string(ldc_tiempo, '###,##0.00') + " seg. Nro de registros: " + string(dw_master.RowCount(), '###,##0')


end event

event ue_procesar();////this.event ue_retrieve( )
//str_parametros lstr_param
//Long				ll_count, ll_i
//
//lstr_param.dw_1 = dw_master
//lstr_param.long1 = long(em_year.text)
//
////Antes de procesar valido que hayan al menos un registro seleccionado
//ll_count = 0
//for ll_i = 1 to dw_master.RowCount() 
//	if dw_master.object.checked[ll_i] = '1' then
//		ll_count ++
//	end if
//next
//
//if ll_count = 0 then
//	MessageBox('Error', 'No ha seleccionado ningun registro, por favor confirme', Information!)
//	return
//end if
//
//
//
////Envio el numero de registros seleccionados
//lstr_param.long2 = ll_count
//
////Abro la ventana para el proceso de vacaciones
//OpenWithParm(w_procesar_vacaciones, lstr_param)
//
//lstr_param = Message.PowerObjectParm
//
////Si el usuario ha procesado, y no ha cancelado la operación, entonces refresco los datos
//if lstr_param.b_return then
//	this.event ue_retrieve()
//end if
//
//
//
//
end event

event ue_saveas_excel();string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_master, ls_file )
End If
end event

event ue_saveas();dw_master.EVENT ue_saveas()
end event

event ue_saveas_pdf();string ls_path, ls_file
int li_rc
n_cst_email	lnv_email

ls_file = dw_master.Object.DataWindow.Print.DocumentName

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "PDF", &
   "Archivos PDF (*.pdf),*.pdf" , "C:\", 32770)

IF li_rc = 1 Then
	lnv_email = CREATE n_cst_email
	try
		if not lnv_email.of_create_pdf( dw_master, ls_path) then return
		
		MessageBox('Confirmacion', 'Se ha creado el archivo ' + ls_path + ' satisfactoriamente.', Exclamation!)
		
	catch (Exception ex)
		MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + ls_path + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
		
	finally
		Destroy lnv_email
		
	end try
	
End If
end event

event ue_desactivar();Long 		ll_selecionados, ll_row
Integer	li_dias_falta
String	ls_cod_trabajador, ls_mensaje, ls_comentario

if dw_master.rowCount() = 0 then return

ll_selecionados = 0

for ll_row = 1 to dw_master.rowCount()
	if dw_master.object.checked [ll_row] = '1' then
		ll_selecionados ++
	end if
next

if ll_selecionados = 0 then return

for ll_row = 1 to dw_master.rowCount()
	if dw_master.object.checked [ll_row] = '1' then
		ls_cod_trabajador = dw_master.object.cod_trabajador 		[ll_row]
		li_dias_falta		= Integer(dw_master.object.dias_falta 	[ll_row])
		
		ls_comentario = 'TRABAJADOR DESACTIVADO POR TENER ' + string(li_dias_falta) + ' DE FALTA, POR EL USUARIO: ' + gs_user
		
		update maestro m
		   set m.flag_estado 		= '0',
				 m.FLAG_CAL_PLNLLA 	= '0',
				 m.comentario		 	= :ls_comentario
		 where m.cod_trabajador = :ls_cod_trabajador;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al actualizar la tabla maestro. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if;
		
		commit;
		
	end if
next

event ue_retrieve()
end event

on w_rh301_dias_falta.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.cb_4=create cb_4
this.st_mensaje=create st_mensaje
this.st_3=create st_3
this.em_descripcion=create em_descripcion
this.cb_1=create cb_1
this.em_origen=create em_origen
this.cb_3=create cb_3
this.st_2=create st_2
this.em_dias=create em_dias
this.st_1=create st_1
this.dw_master=create dw_master
this.gb_1=create gb_1
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.em_desc_tipo=create em_desc_tipo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_4
this.Control[iCurrent+2]=this.st_mensaje
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.em_descripcion
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.em_origen
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.em_dias
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.dw_master
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.em_tipo
this.Control[iCurrent+14]=this.cb_2
this.Control[iCurrent+15]=this.em_desc_tipo
end on

on w_rh301_dias_falta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_4)
destroy(this.st_mensaje)
destroy(this.st_3)
destroy(this.em_descripcion)
destroy(this.cb_1)
destroy(this.em_origen)
destroy(this.cb_3)
destroy(this.st_2)
destroy(this.em_dias)
destroy(this.st_1)
destroy(this.dw_master)
destroy(this.gb_1)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.em_desc_tipo)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

end event

event ue_open_pre;call super::ue_open_pre;string ls_desc_origen

select nombre
	into :ls_desc_origen
from origen
where cod_origen = :gs_origen;

em_origen.text 		= gs_origen
em_descripcion.text 	= ls_desc_origen

dw_master.setTransObject(SQLCA)

end event

event ue_print;call super::ue_print;dw_master.event ue_print()
end event

event ue_filter;//Override
dw_master.Event ue_filter()
end event

event ue_filter_avanzado;//Override
dw_master.Event ue_filter_avanzado()
end event

type cb_4 from commandbutton within w_rh301_dias_falta
integer x = 2318
integer y = 52
integer width = 379
integer height = 148
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)
end event

type st_mensaje from statictext within w_rh301_dias_falta
integer x = 1774
integer y = 220
integer width = 1394
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh301_dias_falta
integer x = 55
integer y = 84
integer width = 379
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_descripcion from editmask within w_rh301_dias_falta
integer x = 869
integer y = 68
integer width = 873
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 255
long backcolor = 134217752
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type cb_1 from commandbutton within w_rh301_dias_falta
integer x = 763
integer y = 68
integer width = 87
integer height = 88
integer taborder = 60
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

type em_origen from editmask within w_rh301_dias_falta
integer x = 471
integer y = 68
integer width = 279
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_3 from commandbutton within w_rh301_dias_falta
integer x = 2706
integer y = 52
integer width = 379
integer height = 148
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Desactivar"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_desactivar()
SetPointer(Arrow!)
end event

type st_2 from statictext within w_rh301_dias_falta
integer x = 55
integer y = 176
integer width = 379
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Tipo Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_dias from editmask within w_rh301_dias_falta
integer x = 2043
integer y = 68
integer width = 247
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "15"
borderstyle borderstyle = stylelowered!
string mask = "###0"
boolean spin = true
double increment = 1
end type

type st_1 from statictext within w_rh301_dias_falta
integer x = 1728
integer y = 84
integer width = 302
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Dias Falta :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_master from u_dw_cns within w_rh301_dias_falta
integer y = 304
integer width = 3424
integer height = 1288
integer taborder = 40
string dataobject = "d_abc_maestro_dias_falta_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                      //   'md' = master con detalle, 'dd' = detalle con detalle a la vez
							 
 is_dwform = 'tabular'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event clicked;call super::clicked;if row = 0 then return

this.AcceptText()

if lower(dwo.name) = 'checked' then
	if this.object.checked [row] = '1' then
		this.object.checked[row] = '0'
	else
		this.object.checked[row] = '1'
	end if
end if

setRow(row)

gnvo_app.of_select_current_row(this)
end event

event ue_filter_avanzado;//Override
this.Modify('datawindow.crosstab.staticmode=yes')
this.iu_powerfilter.checked =  not iu_powerfilter.checked
this.iu_powerfilter.event ue_clicked()
ib_filter = not ib_filter
this.Modify('datawindow.crosstab.staticmode=no')
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row(this)
end event

type gb_1 from groupbox within w_rh301_dias_falta
integer y = 4
integer width = 3191
integer height = 292
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtros de Busqueda"
end type

type em_tipo from editmask within w_rh301_dias_falta
integer x = 471
integer y = 160
integer width = 279
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "%"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh301_dias_falta
integer x = 763
integer y = 160
integer width = 87
integer height = 88
integer taborder = 30
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
String ls_sql, ls_codigo, ls_Data

ls_sql = "SELECT distinct tt.TIPO_TRABAJADOR AS CODIGO_origen, " &
		  + "tt.DESC_TIPO_TRA AS descripcion_tipo " &
		  + "FROM tipo_trabajador tt " &
		  + "WHERE tt.FLAG_ESTADO = '1'"

f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_tipo.text      = ls_codigo
	em_desc_tipo.text = ls_data
END IF	
end event

type em_desc_tipo from editmask within w_rh301_dias_falta
integer x = 869
integer y = 160
integer width = 873
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 134217752
string text = "Todos"
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

