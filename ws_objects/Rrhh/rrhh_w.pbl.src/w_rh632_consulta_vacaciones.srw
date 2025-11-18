$PBExportHeader$w_rh632_consulta_vacaciones.srw
forward
global type w_rh632_consulta_vacaciones from w_abc
end type
type st_mensaje from statictext within w_rh632_consulta_vacaciones
end type
type pb_procesar from picturebutton within w_rh632_consulta_vacaciones
end type
type cb_3 from commandbutton within w_rh632_consulta_vacaciones
end type
type cb_invertir from commandbutton within w_rh632_consulta_vacaciones
end type
type cb_marcar from commandbutton within w_rh632_consulta_vacaciones
end type
type st_3 from statictext within w_rh632_consulta_vacaciones
end type
type st_2 from statictext within w_rh632_consulta_vacaciones
end type
type em_year from editmask within w_rh632_consulta_vacaciones
end type
type st_1 from statictext within w_rh632_consulta_vacaciones
end type
type dw_master from u_dw_cns within w_rh632_consulta_vacaciones
end type
type gb_1 from groupbox within w_rh632_consulta_vacaciones
end type
type em_tipo from editmask within w_rh632_consulta_vacaciones
end type
type cb_2 from commandbutton within w_rh632_consulta_vacaciones
end type
type em_desc_tipo from editmask within w_rh632_consulta_vacaciones
end type
type sle_codigo from singlelineedit within w_rh632_consulta_vacaciones
end type
type sle_nombre from singlelineedit within w_rh632_consulta_vacaciones
end type
type cb_4 from commandbutton within w_rh632_consulta_vacaciones
end type
end forward

global type w_rh632_consulta_vacaciones from w_abc
integer width = 3520
integer height = 1964
string title = "[RH632] Consulta masiva de vacaciones"
string menuname = "m_impresion"
event ue_retrieve ( )
event ue_procesar ( )
event ue_saveas_excel ( )
event ue_saveas ( )
event ue_saveas_pdf ( )
st_mensaje st_mensaje
pb_procesar pb_procesar
cb_3 cb_3
cb_invertir cb_invertir
cb_marcar cb_marcar
st_3 st_3
st_2 st_2
em_year em_year
st_1 st_1
dw_master dw_master
gb_1 gb_1
em_tipo em_tipo
cb_2 cb_2
em_desc_tipo em_desc_tipo
sle_codigo sle_codigo
sle_nombre sle_nombre
cb_4 cb_4
end type
global w_rh632_consulta_vacaciones w_rh632_consulta_vacaciones

event ue_retrieve();String 	ls_tipo_trabajador, ls_trabajador, ls_mensaje
Integer	li_year
dateTime	ldt_hora1, ldt_hora2
Decimal	ldc_tiempo

ldt_hora1 = gnvo_app.of_fecha_actual() 

ls_tipo_trabajador 	= trim(em_tipo.text) + '%'
ls_trabajador 		 	= trim(sle_codigo.text) + '%'

li_year 					= Integer(em_year.text)

//  procedure sp_rpt_vacaciones(
//    ani_year         number,
//    asi_tipo_trabaj  tipo_trabajador.tipo_trabajador%TYPE,
//    asi_codtra       maestro.cod_trabajador%TYPE
//  ) is
DECLARE 	usp_rpt_vacaciones PROCEDURE FOR
			  pkg_rrhh.sp_rpt_vacaciones(	:li_year,
                             				:ls_tipo_trabajador,
													:ls_trabajador);
EXECUTE 	usp_rpt_vacaciones ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_rpt_vacaciones: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE usp_rpt_vacaciones;


dw_master.Retrieve( )

ldt_hora2 = gnvo_app.of_fecha_actual()

//Determino el tiempo transcurrido
select (:ldt_hora2 - :ldt_hora1) * 24 * 60 * 60
  into :ldc_tiempo
  from dual;
  
st_mensaje.text = 'Tiempo Transcurrido: ' + string(ldc_tiempo, '###,##0.00') + " seg. Nro de registros: " + string(dw_master.RowCount(), '###,##0')

if dw_master.RowCount() > 0 then
	cb_marcar.enabled = true
	cb_invertir.enabled = true
	
else
	cb_marcar.enabled = false
	cb_invertir.enabled = false
end if
end event

event ue_procesar();//this.event ue_retrieve( )
str_parametros lstr_param
Long				ll_count, ll_i

lstr_param.dw_1 = dw_master
lstr_param.long1 = long(em_year.text)

//Antes de procesar valido que hayan al menos un registro seleccionado
ll_count = 0
for ll_i = 1 to dw_master.RowCount() 
	if dw_master.object.checked[ll_i] = '1' then
		ll_count ++
	end if
next

if ll_count = 0 then
	MessageBox('Error', 'No ha seleccionado ningun registro, por favor confirme', Information!)
	return
end if



//Envio el numero de registros seleccionados
lstr_param.long2 = ll_count

//Abro la ventana para el proceso de vacaciones
OpenWithParm(w_procesar_vacaciones, lstr_param)

lstr_param = Message.PowerObjectParm

//Si el usuario ha procesado, y no ha cancelado la operación, entonces refresco los datos
if lstr_param.b_return then
	this.event ue_retrieve()
end if




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

on w_rh632_consulta_vacaciones.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_mensaje=create st_mensaje
this.pb_procesar=create pb_procesar
this.cb_3=create cb_3
this.cb_invertir=create cb_invertir
this.cb_marcar=create cb_marcar
this.st_3=create st_3
this.st_2=create st_2
this.em_year=create em_year
this.st_1=create st_1
this.dw_master=create dw_master
this.gb_1=create gb_1
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.em_desc_tipo=create em_desc_tipo
this.sle_codigo=create sle_codigo
this.sle_nombre=create sle_nombre
this.cb_4=create cb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mensaje
this.Control[iCurrent+2]=this.pb_procesar
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cb_invertir
this.Control[iCurrent+5]=this.cb_marcar
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.em_year
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.dw_master
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.em_tipo
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.em_desc_tipo
this.Control[iCurrent+15]=this.sle_codigo
this.Control[iCurrent+16]=this.sle_nombre
this.Control[iCurrent+17]=this.cb_4
end on

on w_rh632_consulta_vacaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_mensaje)
destroy(this.pb_procesar)
destroy(this.cb_3)
destroy(this.cb_invertir)
destroy(this.cb_marcar)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_year)
destroy(this.st_1)
destroy(this.dw_master)
destroy(this.gb_1)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.em_desc_tipo)
destroy(this.sle_codigo)
destroy(this.sle_nombre)
destroy(this.cb_4)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

end event

event ue_open_pre;call super::ue_open_pre;integer	li_year

li_year = year(date(gnvo_app.of_fecha_actual( )))

em_year.text = string(li_year)

dw_master.setTransobject( SQLCA )


end event

event ue_print;call super::ue_print;dw_master.event ue_print()
end event

event ue_filter;//Override
dw_master.Event ue_filter()
end event

event ue_filter_avanzado;//Override
dw_master.Event ue_filter_avanzado()
end event

type st_mensaje from statictext within w_rh632_consulta_vacaciones
integer x = 1810
integer y = 288
integer width = 1371
integer height = 68
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type pb_procesar from picturebutton within w_rh632_consulta_vacaciones
integer x = 2670
integer y = 52
integer width = 379
integer height = 236
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\procesos.bmp"
string disabledname = "C:\SIGRE\resources\BMP\procesos.bmp"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Procesar Vacaciones"
end type

event clicked;setPointer(HourGlass!)
parent.dynamic event ue_procesar()
setPointer(Arrow!)
end event

type cb_3 from commandbutton within w_rh632_consulta_vacaciones
integer x = 2272
integer y = 52
integer width = 379
integer height = 236
integer taborder = 20
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

type cb_invertir from commandbutton within w_rh632_consulta_vacaciones
integer x = 1810
integer y = 176
integer width = 425
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Invertir seleccion"
end type

event clicked;Long ll_i

dw_master.Accepttext( )

for ll_i = 1 to dw_master.RowCount( )
	if dw_master.object.checked [ll_i] = '1' then
		dw_master.object.checked [ll_i] = '0'
	else
		dw_master.object.checked [ll_i] = '1'
	end if
next
end event

type cb_marcar from commandbutton within w_rh632_consulta_vacaciones
integer x = 1810
integer y = 52
integer width = 425
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Marcar todos"
end type

event clicked;Long		ll_i
String	ls_checked

dw_master.Accepttext( )

if trim(this.text) = 'Marcar todos' then

	this.text = 'Desmarcar todos'
	
	ls_checked = '1'
	
else
	
	this.text = 'Marcar todos'
	
	ls_checked = '0'
	
end if

for ll_i = 1 to dw_master.RowCount( )
	dw_master.object.checked [ll_i] = ls_checked
next
end event

type st_3 from statictext within w_rh632_consulta_vacaciones
integer x = 55
integer y = 276
integer width = 379
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh632_consulta_vacaciones
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

type em_year from editmask within w_rh632_consulta_vacaciones
integer x = 471
integer y = 60
integer width = 320
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
string mask = "###0"
boolean spin = true
double increment = 1
end type

type st_1 from statictext within w_rh632_consulta_vacaciones
integer x = 91
integer y = 76
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Periodo: "
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_master from u_dw_cns within w_rh632_consulta_vacaciones
integer y = 380
integer width = 3424
integer height = 1288
integer taborder = 40
string dataobject = "d_rpt_vacaciones_masivas_crt"
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

if this.object.checked [row] = '1' then
	this.object.checked[row] = '0'
else
	this.object.checked[row] = '1'
end if
end event

event ue_filter_avanzado;//Override
this.Modify('datawindow.crosstab.staticmode=yes')
this.iu_powerfilter.checked =  not iu_powerfilter.checked
this.iu_powerfilter.event ue_clicked()
ib_filter = not ib_filter
this.Modify('datawindow.crosstab.staticmode=no')
end event

type gb_1 from groupbox within w_rh632_consulta_vacaciones
integer y = 4
integer width = 3191
integer height = 364
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

type em_tipo from editmask within w_rh632_consulta_vacaciones
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

type cb_2 from commandbutton within w_rh632_consulta_vacaciones
integer x = 763
integer y = 164
integer width = 87
integer height = 84
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

type em_desc_tipo from editmask within w_rh632_consulta_vacaciones
integer x = 869
integer y = 156
integer width = 873
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Todos"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type sle_codigo from singlelineedit within w_rh632_consulta_vacaciones
integer x = 471
integer y = 260
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
borderstyle borderstyle = stylelowered!
end type

type sle_nombre from singlelineedit within w_rh632_consulta_vacaciones
integer x = 869
integer y = 260
integer width = 873
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217738
string text = "Todos"
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_rh632_consulta_vacaciones
integer x = 763
integer y = 260
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
String ls_sql, ls_codigo, ls_Data, ls_tipo_trabajador

ls_tipo_trabajador = trim(em_tipo.text) + '%'

ls_sql = "select m.cod_trabajador as codigo_trabajador, " &
		 + "m.nom_trabajador as nombre_trabajador " &
		 + "from vw_pr_trabajador m " &
		 + "where tipo_trabajador like '" + ls_tipo_trabajador + "'"

f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_codigo.text  = ls_codigo
	sle_nombre.text  = ls_data
END IF	


end event

