$PBExportHeader$w_cn968_asiento_costo_vinc.srw
forward
global type w_cn968_asiento_costo_vinc from w_prc
end type
type st_progreso from statictext within w_cn968_asiento_costo_vinc
end type
type hpb_1 from hprogressbar within w_cn968_asiento_costo_vinc
end type
type cb_reporte from commandbutton within w_cn968_asiento_costo_vinc
end type
type sle_mes from singlelineedit within w_cn968_asiento_costo_vinc
end type
type st_3 from statictext within w_cn968_asiento_costo_vinc
end type
type sle_ano from singlelineedit within w_cn968_asiento_costo_vinc
end type
type st_2 from statictext within w_cn968_asiento_costo_vinc
end type
type dw_reporte from u_dw_rpt within w_cn968_asiento_costo_vinc
end type
type sle_libro from singlelineedit within w_cn968_asiento_costo_vinc
end type
type cb_cancelar from commandbutton within w_cn968_asiento_costo_vinc
end type
type cb_generar from commandbutton within w_cn968_asiento_costo_vinc
end type
type st_4 from statictext within w_cn968_asiento_costo_vinc
end type
type st_1 from statictext within w_cn968_asiento_costo_vinc
end type
type gb_1 from groupbox within w_cn968_asiento_costo_vinc
end type
end forward

global type w_cn968_asiento_costo_vinc from w_prc
integer width = 3278
integer height = 2484
string title = "[CN968] Asientos de costos vinculados a compras"
string menuname = "m_prc"
boolean maxbox = false
boolean resizable = false
boolean center = true
event ue_retrieve ( )
event ue_generar ( )
st_progreso st_progreso
hpb_1 hpb_1
cb_reporte cb_reporte
sle_mes sle_mes
st_3 st_3
sle_ano sle_ano
st_2 st_2
dw_reporte dw_reporte
sle_libro sle_libro
cb_cancelar cb_cancelar
cb_generar cb_generar
st_4 st_4
st_1 st_1
gb_1 gb_1
end type
global w_cn968_asiento_costo_vinc w_cn968_asiento_costo_vinc

event ue_retrieve();String 	ls_msj
Integer	li_year, li_mes

try 
	
	li_year 	= Integer(sle_ano.text)
	li_mes 	= Integer(sle_mes.text)
		
	dw_reporte.Retrieve(li_year, li_mes)
	
	if dw_reporte.RowCount() > 0 then
		cb_generar.enabled = true
	end if

	
	

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, '')
	
finally
	

	
end try
end event

event ue_generar();Long		ll_year, ll_mes, ll_nro_libro, ll_count, ll_row, ll_procesados
string  	ls_mensaje, ls_nro_oc, ls_cnta_cntbl

//Cuanto cuantos registros han seleccionado
ll_count = 0
for ll_row = 1 to dw_reporte.RowCount()
	
	if dw_reporte.object.tipo_docref1 [ll_row] = gnvo_app.is_doc_oc and &
		 dw_reporte.object.checked 	[ll_Row] = '1' then
		 
		ll_count ++
		
	end if
next

if ll_count = 0 then
	MessageBox('Error', 'No ha seleccionado ninguna orden de compra para procesar, por favor verifique!', StopSign!)
	return
end if


ll_year 			= Long(sle_ano.text)
ll_mes			= Long(sle_mes.text)
ll_nro_libro 	= Long(sle_libro.text)

ll_procesados = 0
for ll_row = 1 to dw_reporte.RowCount()
	if dw_reporte.object.tipo_docref1 [ll_row] = gnvo_app.is_doc_oc and &
		 dw_reporte.object.checked 	[ll_Row] = '1' then
		 
		 ls_nro_oc 		= dw_reporte.object.nro_docref1 	[ll_row]
		 ls_cnta_Cntbl	= dw_reporte.object.cnta_ctbl 	[ll_row]
		 
		//create or replace procedure usp_cntbl_asiento_oc_os(
		//       asi_nro_oc           in orden_compra.nro_oc%TYPE,
		//       asi_cnta_cntbl       in cntbl_cnta.cnta_ctbl%TYPE,
		//       asi_origen           in origen.cod_origen%TYPE,
		//       ani_year             in number,
		//       ani_mes              in number,
		//       ani_nro_libro        in cntbl_libro.nro_libro%TYPE,
		//       asi_usuario          in usuario.cod_usr%TYPE
		//) is
		
		DECLARE usp_cntbl_asiento_oc_os PROCEDURE FOR 
			usp_cntbl_asiento_oc_os ( :ls_nro_oc,
											  :ls_cnta_Cntbl,
											  :gs_origen,
										 	  :ll_year, 
										 	  :ll_mes, 
										 	  :ll_nro_libro, 
										 	  :gs_user ) ;
		
		EXECUTE usp_cntbl_asiento_oc_os  ;
		
		IF sqlca.sqlcode = -1 THEN
			ls_mensaje = sqlca.sqlerrtext
			ROLLBACK ;
			MessageBox( 'Error', 'Se produjo un error al ejecutar el procedure usp_cntbl_asiento_oc_os. Mensaje: ' + ls_mensaje, StopSign! )
			return
		END IF
		
		Close usp_cntbl_asiento_oc_os;

		ll_procesados ++
		 
		hpb_1.Position = Integer(ll_procesados / ll_count * 100)
		st_progreso.Text = 'Procesando ' + string(ll_procesados) + ' de ' + string(ll_count) &
		 					  + ' Porc: ' + string(ll_procesados / ll_count, '###,##0.000') + "%"
	end if
next

this.event ue_Retrieve()


MessageBox( 'Mensaje', "Proceso terminado", Information! )
		

end event

on w_cn968_asiento_costo_vinc.create
int iCurrent
call super::create
if this.MenuName = "m_prc" then this.MenuID = create m_prc
this.st_progreso=create st_progreso
this.hpb_1=create hpb_1
this.cb_reporte=create cb_reporte
this.sle_mes=create sle_mes
this.st_3=create st_3
this.sle_ano=create sle_ano
this.st_2=create st_2
this.dw_reporte=create dw_reporte
this.sle_libro=create sle_libro
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_4=create st_4
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_progreso
this.Control[iCurrent+2]=this.hpb_1
this.Control[iCurrent+3]=this.cb_reporte
this.Control[iCurrent+4]=this.sle_mes
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_ano
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.dw_reporte
this.Control[iCurrent+9]=this.sle_libro
this.Control[iCurrent+10]=this.cb_cancelar
this.Control[iCurrent+11]=this.cb_generar
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.gb_1
end on

on w_cn968_asiento_costo_vinc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_progreso)
destroy(this.hpb_1)
destroy(this.cb_reporte)
destroy(this.sle_mes)
destroy(this.st_3)
destroy(this.sle_ano)
destroy(this.st_2)
destroy(this.dw_reporte)
destroy(this.sle_libro)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;String 	ls_ano, ls_mes, ls_nro_libro
Integer	li_nro_libro, li_count



try 
	// Proceso CANI
	ls_ano = string(gnvo_app.of_fecha_Actual(), 'yyyy')
	ls_mes = string(gnvo_app.of_fecha_Actual(), 'mm')
	
	sle_ano.text = ls_ano
	sle_mes.text = ls_mes
	
	li_nro_libro = Integer(gnvo_app.of_get_parametro( 'LIBRO_GASTOS_VINCULADOS', '37'))
	
	select count(*)
		into :li_count
	from cntbl_libro
	where nro_libro = :li_nro_libro;
	
	if li_count = 0 then
		MessageBox('Error', 'No existe el nro de libro ' + string(li_nro_libro) + ' por favor corregir', StopSign!)
		this.post event close()
		return
	end if
	
	sle_libro.text = string(li_nro_libro)
	
	dw_reporte.setTransObject(SQLCA)
	
catch ( Exception ex )
	MessageBox('Exception en event open()', ex.getMessage())
	
finally
	/*statementBlock*/
end try



end event

event resize;call super::resize;dw_reporte.width  = newwidth  - dw_reporte.x - 10
dw_reporte.height = newheight - dw_reporte.y - 10

st_1.width = dw_reporte.width
end event

type st_progreso from statictext within w_cn968_asiento_costo_vinc
integer x = 2437
integer y = 232
integer width = 754
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_cn968_asiento_costo_vinc
integer x = 2149
integer y = 160
integer width = 1042
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 10
end type

type cb_reporte from commandbutton within w_cn968_asiento_costo_vinc
integer x = 1184
integer y = 176
integer width = 320
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_Retrieve()
setPointer(Arrow!)
end event

type sle_mes from singlelineedit within w_cn968_asiento_costo_vinc
integer x = 562
integer y = 176
integer width = 187
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_cn968_asiento_costo_vinc
integer x = 421
integer y = 184
integer width = 187
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_cn968_asiento_costo_vinc
integer x = 229
integer y = 176
integer width = 187
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

type st_2 from statictext within w_cn968_asiento_costo_vinc
integer x = 69
integer y = 184
integer width = 169
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type dw_reporte from u_dw_rpt within w_cn968_asiento_costo_vinc
integer y = 328
integer width = 3337
integer height = 1460
integer taborder = 20
string dataobject = "d_lista_oc_os_serv_vinculados_tbl"
end type

event itemchanged;call super::itemchanged;u_ds_base	lds_listado
String		ls_nro_doc, ls_tipo_doc, ls_nro_os
Decimal		ldc_soles_hab, ldc_imp_soles, ldc_soles_deb
Long			ll_row, ll_find
boolean		lb_select

this.AcceptText()

try
	lds_listado = create u_ds_base
	
	if lower(dwo.name) = 'checked' then
		ls_nro_doc 	= this.object.nro_docref1 	[row]
		ls_tipo_doc	= this.object.tipo_docref1 [row]
		
	
		if ls_tipo_doc = gnvo_app.is_doc_oc then
			lds_listado.DataObject = 'd_lista_os_det_por_oc_tbl'	
			lds_listado.setTransObject(SQLCA)
			
			lds_listado.Retrieve(ls_nro_doc)
			
			if data = '1' then
				if lds_listado.RowCount() = 0 then
					MessageBox('Error', "No existe Orden de Servicio vinculante para la Orden de Compra " &
											+ trim(ls_tipo_doc) + "-" + ls_nro_doc &
											+ ", por favor verifique!", StopSign!)
					this.object.checked [row] = '0'
					return 2
				end if
			end if
			
			lb_Select = false
			
			for ll_row = 1 to lds_listado.RowCount() 
				ls_nro_os		= lds_listado.object.nro_os 			[ll_row]
				ldc_imp_soles	= Dec(lds_listado.object.imp_soles 	[ll_row])
				ldc_soles_deb	= Dec(this.object.soles_deb 	[row])
				
				ll_find = this.find("tipo_docref1='" + gnvo_app.is_doc_os + "' and nro_docref1='" + ls_nro_os + "'", 0, dw_reporte.RowCount())
				
				if ll_find > 0 then
					ldc_soles_hab = Dec(this.object.soles_hab [ll_find])
					
					
					if data = '1' then
						ldc_soles_hab += ldc_imp_soles
						ldc_soles_deb += ldc_imp_soles
						
					else
						ldc_soles_hab -= ldc_imp_soles
						ldc_soles_deb -= ldc_imp_soles
					end if
					
					if ldc_soles_deb < 0 then
						ldc_soles_deb = 0
					end if
					
					if ldc_soles_hab < 0 then
						ldc_soles_hab = 0
					end if
					
					this.object.soles_deb 		[row] 	= ldc_soles_deb
					this.object.soles_hab 		[ll_find] = ldc_soles_hab
					this.object.checked 			[ll_find] = '1'
					
					lb_select = true
					
				end if
			next
			
			if not lb_select then
				MessageBox('Error', "No existe Orden de Servicio vinculante para la Orden de Compra " &
											+ trim(ls_tipo_doc) + "-" + ls_nro_doc &
											+ ", por favor verifique!", StopSign!)
				this.object.checked [row] = '0'
				return 2
			end if
			
		end if
		
	end if
	
catch(Exception ex)

finally
	destroy lds_listado
	
end try


end event

type sle_libro from singlelineedit within w_cn968_asiento_costo_vinc
event ue_dobleclick pbm_lbuttondblclk
integer x = 914
integer y = 176
integer width = 192
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT trim(to_char(nro_libro)) AS CODIGO, " &
		 + "desc_libro AS DESCRIPCION " &
		 + "FROM cntbl_libro " &
		 + "ORDER BY nro_libro " 

//ls_sql = "SELECT d.tipo_doc AS CODIGO, " &
//		 + "d.desc_tipo_doc AS DESCRIPCION " &
//		 + "FROM doc_tipo d " 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data,'1') 

if ls_codigo <> '' then
	this.text   = ls_codigo
// sle_1.text	= ls_data
end if



end event

type cb_cancelar from commandbutton within w_cn968_asiento_costo_vinc
integer x = 1824
integer y = 176
integer width = 302
integer height = 84
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_generar from commandbutton within w_cn968_asiento_costo_vinc
integer x = 1513
integer y = 176
integer width = 302
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_generar()
setPointer(Arrow!)
end event

type st_4 from statictext within w_cn968_asiento_costo_vinc
integer x = 763
integer y = 184
integer width = 187
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Libro contable :"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn968_asiento_costo_vinc
integer width = 3145
integer height = 88
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Generación de asientos de costos vinculados a compras"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn968_asiento_costo_vinc
integer y = 96
integer width = 3205
integer height = 220
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos Generales"
end type

