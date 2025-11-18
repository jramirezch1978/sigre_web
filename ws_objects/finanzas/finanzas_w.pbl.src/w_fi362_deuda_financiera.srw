$PBExportHeader$w_fi362_deuda_financiera.srw
forward
global type w_fi362_deuda_financiera from w_abc
end type
type pb_3 from picturebutton within w_fi362_deuda_financiera
end type
type sle_cnta_prsp from singlelineedit within w_fi362_deuda_financiera
end type
type sle_cencos from singlelineedit within w_fi362_deuda_financiera
end type
type st_7 from statictext within w_fi362_deuda_financiera
end type
type st_6 from statictext within w_fi362_deuda_financiera
end type
type st_5 from statictext within w_fi362_deuda_financiera
end type
type dw_1 from datawindow within w_fi362_deuda_financiera
end type
type pb_2 from picturebutton within w_fi362_deuda_financiera
end type
type pb_1 from picturebutton within w_fi362_deuda_financiera
end type
type sle_plazo from singlelineedit within w_fi362_deuda_financiera
end type
type st_4 from statictext within w_fi362_deuda_financiera
end type
type st_3 from statictext within w_fi362_deuda_financiera
end type
type st_2 from statictext within w_fi362_deuda_financiera
end type
type st_1 from statictext within w_fi362_deuda_financiera
end type
type em_f_cuota from editmask within w_fi362_deuda_financiera
end type
type sle_cuotas from singlelineedit within w_fi362_deuda_financiera
end type
type em_deuda from editmask within w_fi362_deuda_financiera
end type
type dw_detail from u_dw_abc within w_fi362_deuda_financiera
end type
type dw_master from u_dw_abc within w_fi362_deuda_financiera
end type
type gb_2 from groupbox within w_fi362_deuda_financiera
end type
type gb_1 from groupbox within w_fi362_deuda_financiera
end type
end forward

global type w_fi362_deuda_financiera from w_abc
integer width = 3849
integer height = 2392
string title = "Deuda Financiera (FI362)"
string menuname = "m_mantenimiento_cl_anular"
pb_3 pb_3
sle_cnta_prsp sle_cnta_prsp
sle_cencos sle_cencos
st_7 st_7
st_6 st_6
st_5 st_5
dw_1 dw_1
pb_2 pb_2
pb_1 pb_1
sle_plazo sle_plazo
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
em_f_cuota em_f_cuota
sle_cuotas sle_cuotas
em_deuda em_deuda
dw_detail dw_detail
dw_master dw_master
gb_2 gb_2
gb_1 gb_1
end type
global w_fi362_deuda_financiera w_fi362_deuda_financiera

type variables
String is_accion,is_cnta_prsp

end variables

forward prototypes
public subroutine of_totales_deuda ()
public subroutine of_totales_deuda_cero ()
end prototypes

public subroutine of_totales_deuda ();Decimal {2} ldc_capital_proy,ldc_interes_proy,ldc_portes_proy,ldc_igv_proy

ldc_capital_proy = dw_detail.object.capital_proy [1]
ldc_interes_proy = dw_detail.object.interes_proy [1]	
ldc_portes_proy  = dw_detail.object.portes_proy  [1]	
ldc_igv_proy 	  = dw_detail.object.igv_proy 	 [1]	
				

String ls_flag_capital

//verificar datos de cabecera
ls_flag_capital = dw_master.object.flag_capital [1]

if ls_flag_capital = '0' then				
	//actualiza cabecera
	dw_master.object.tot_capital [1] = ldc_capital_proy
end if	

dw_master.object.tot_interes [1] = ldc_interes_proy
dw_master.object.tot_portes  [1] = ldc_portes_proy
dw_master.object.tot_igv 	  [1] = ldc_igv_proy
dw_master.ii_update 					= 1

end subroutine

public subroutine of_totales_deuda_cero ();String ls_flag_capital

//verificar datos de cabecera
ls_flag_capital = dw_master.object.flag_capital [1]

if ls_flag_capital = '0' then
	//actualiza cabecera
	dw_master.object.tot_capital [1] = 0.00
	dw_master.object.tot_interes [1] = 0.00
	dw_master.object.tot_portes  [1] = 0.00
	dw_master.object.tot_igv 	  [1] = 0.00
	dw_master.ii_update 					= 1
end if	

end subroutine

on w_fi362_deuda_financiera.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular" then this.MenuID = create m_mantenimiento_cl_anular
this.pb_3=create pb_3
this.sle_cnta_prsp=create sle_cnta_prsp
this.sle_cencos=create sle_cencos
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.dw_1=create dw_1
this.pb_2=create pb_2
this.pb_1=create pb_1
this.sle_plazo=create sle_plazo
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.em_f_cuota=create em_f_cuota
this.sle_cuotas=create sle_cuotas
this.em_deuda=create em_deuda
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_3
this.Control[iCurrent+2]=this.sle_cnta_prsp
this.Control[iCurrent+3]=this.sle_cencos
this.Control[iCurrent+4]=this.st_7
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.pb_2
this.Control[iCurrent+9]=this.pb_1
this.Control[iCurrent+10]=this.sle_plazo
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.em_f_cuota
this.Control[iCurrent+16]=this.sle_cuotas
this.Control[iCurrent+17]=this.em_deuda
this.Control[iCurrent+18]=this.dw_detail
this.Control[iCurrent+19]=this.dw_master
this.Control[iCurrent+20]=this.gb_2
this.Control[iCurrent+21]=this.gb_1
end on

on w_fi362_deuda_financiera.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_3)
destroy(this.sle_cnta_prsp)
destroy(this.sle_cencos)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.dw_1)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.sle_plazo)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_f_cuota)
destroy(this.sle_cuotas)
destroy(this.em_deuda)
destroy(this.dw_detail)
destroy(this.dw_master)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)


idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query
dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado




of_position_window(0,0)       			// Posicionar la ventana en forma fija


//parametro de cuenta presupuestal
select cntas_prsp_gfinan into :is_cnta_prsp from finparam where reckey = '1' ;
end event

event resize;call super::resize;//dw_master.width  = newwidth  - dw_master.x - 10
//dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_insert;call super::ue_insert;String ls_tipo_deuda
Long   ll_row

IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF

choose case idw_1
		 case dw_master

				if ib_update_check = False Then
					Return
				end if	
				
				is_accion = 'new'				
				dw_master.reset()
				dw_detail.reset()
				
 		 case dw_detail
				if dw_master.Getrow() = 0 then return
				
				ls_tipo_deuda = dw_master.object.tipo_deuda_fin [dw_master.Getrow()]
				
				if Isnull(ls_tipo_deuda) or Trim(ls_tipo_deuda) = '' then
					Messagebox('Aviso','Debe Ingresar Tipo de Deuda en la Cabecera ,Verifique!')
					Return
				end if
					
				
end choose


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN



IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		Messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		Messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	is_accion = 'fileopen'
END IF

end event

event ue_update_pre;call super::ue_update_pre;String ls_nro_deuda,ls_cod_origen
Long   ll_row_master,ll_inicio
dwItemStatus ldis_status

nvo_numeradores lnvo_numeradores
lnvo_numeradores = CREATE nvo_numeradores

ib_update_check = True

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN 
	ib_update_check = False
	GOTO SALIDA
END IF


ls_cod_origen = dw_master.object.cod_origen   [ll_row_master]
ls_nro_deuda  = dw_master.object.nro_registro [ll_row_master]


//Verificación de Data en Detalle de Documento
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	GOTO SALIDA
ELSE
	ib_update_check = True
END IF

//Verificación de Data en Detalle de Documento
IF f_row_Processing( dw_detail, "tabular") <> true then	
	ib_update_check = False	
	GOTO SALIDA
ELSE
	ib_update_check = True
END IF


//IF dw_detail.Rowcount() = 0 THEN
//	Messagebox('Aviso','Debe Colocar Cuotas de Deuda Financiera,Verifique!')
//	GOTO SALIDA
//END IF


if is_accion = 'new' then
	SetNull(ls_nro_deuda)
		
	IF	lnvo_numeradores.uf_num_deuda(ls_cod_origen,ls_nro_deuda) = FALSE THEN
		ib_update_check = False	
		GOTO SALIDA
		Return
	END IF

	dw_master.object.nro_registro [ll_row_master] = ls_nro_deuda
	
end if	


//actualizar detalle
For ll_inicio = 1 to dw_detail.Rowcount()
	 
	 dw_detail.object.nro_registro [ll_inicio] = ls_nro_deuda
	 
	 
Next	


SALIDA:

destroy lnvo_numeradores
end event

event ue_delete;//override
Long  ll_row

choose case idw_1
		 case dw_master
				Return
       case	dw_detail
				//recalcular totales
				
end choose


ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF
end event

event ue_delete_pos;call super::ue_delete_pos;dw_detail.accepttext()

if idw_1 = dw_detail then
	//recalcular totales
	if dw_detail.rowcount() > 0 then
		of_totales_deuda ()
	else
		of_totales_deuda_cero ()
	end if
	
end if
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")

	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF
//
end event

event ue_retrieve_list;call super::ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row , ll_inicio ,ll_ano ,ll_count
String ls_cencos,ls_cnta_prsp ,ls_null ,ls_origen
str_parametros sl_param

Setnull(ls_null)
TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_deuda_financ_tbl'
sl_param.titulo = 'Deuda Financiera'
sl_param.field_ret_i[1] = 1	//Nro de Registro



//OpenWithParm( w_search_datos, sl_param)
OpenWithParm( w_lista, sl_param)


sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.Retrieve(sl_param.field_ret[1])
	dw_detail.Retrieve(sl_param.field_ret[1])
	
	dw_master.il_row = dw_master.Getrow()

	TriggerEvent('ue_modify')
	is_accion = 'fileopen'	
END IF
end event

type pb_3 from picturebutton within w_fi362_deuda_financiera
integer x = 3538
integer y = 1176
integer width = 192
integer height = 168
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Copy!"
end type

event clicked;String ls_cencos,ls_cnta_prsp
Long   ll_inicio

ls_cencos    = sle_cencos.text
ls_cnta_prsp = sle_cnta_prsp.text


For ll_inicio = 1 to dw_detail.rowcount()
	 dw_detail.object.cencos    [ll_inicio] = ls_cencos  
	 dw_detail.object.cnta_prsp [ll_inicio] = ls_cnta_prsp
	 dw_detail.ii_update = 1
	 
	
Next



end event

type sle_cnta_prsp from singlelineedit within w_fi362_deuda_financiera
integer x = 3095
integer y = 1372
integer width = 343
integer height = 84
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_cencos from singlelineedit within w_fi362_deuda_financiera
integer x = 3095
integer y = 1236
integer width = 343
integer height = 84
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_7 from statictext within w_fi362_deuda_financiera
integer x = 2702
integer y = 1384
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cnta Prsp :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within w_fi362_deuda_financiera
integer x = 2702
integer y = 1248
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cencos :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_fi362_deuda_financiera
integer x = 2656
integer y = 1000
integer width = 1147
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transferir Archivo XLS a Detalle de CUOTAS"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_fi362_deuda_financiera
boolean visible = false
integer x = 2839
integer y = 1032
integer width = 686
integer height = 400
integer taborder = 70
string title = "none"
string dataobject = "d_abc_prueba_excel_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event constructor;Settransobject( sqlca)
end event

type pb_2 from picturebutton within w_fi362_deuda_financiera
integer x = 3077
integer y = 808
integer width = 242
integer height = 156
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "StartPipeline!"
alignment htextalign = left!
end type

event clicked;String  ls_pathname, ls_filename ,ls_cod_capital,ls_cod_int,ls_cod_portes,ls_cod_igv,&
		  ls_tipo_deuda
Long 	  ll_rc ,ll_inicio ,ll_nro_cuota ,LI_OPCION
Date	  ld_fecha
Decimal {2} ldc_capital,ldc_interes,ldc_portes,ldc_igv
oleobject loo_excel , lo_sheet


//ESTA SEGURO DE REALIZAR OPERACION DE AUTOGENERAR DETALLE
if dw_master.Getrow() = 0 then return
				
ls_tipo_deuda = dw_master.object.tipo_deuda_fin [dw_master.Getrow()]
				
if Isnull(ls_tipo_deuda) or Trim(ls_tipo_deuda) = '' then
	Messagebox('Aviso','Debe Ingresar Tipo de Deuda en la Cabecera ,Verifique!')
	Return
end if



li_opcion = MessageBox('Aviso','Est Seguro de Realizar Operacion de Transferencia de Archivos', Question!, YesNo!, 2)

IF li_opcion = 2 THEN
	Return
END IF



IF GetFileOpenName ( "Open File", ls_pathname, ls_filename, "XLS","Excel Files(*.xls),*.xls" ) < 1 THEN Return 

loo_excel = CREATE OLEObject 
loo_excel.ConnectToNewObject( "excel.application" ) 
loo_excel.visible = false 
loo_excel.workbooks.open( ls_pathname ) 
lo_sheet = loo_Excel.Application.ActiveSheet

//Desprotegemos la hoja, ya que si esta protegida daría error
lo_sheet.Unprotect()
loo_excel.ActiveCell.CurrentRegion.Select() 
loo_excel.Selection.Copy() 

//Copiamos apartir de la segunda fila, ya que el la primera están las cabeceras
ll_rc = dw_1.ImportClipBoard ( 2 ) 
ClipBoard('') 
//loo_excel.ActiveWorkbook.Save()
//loo_excel.workbooks.close() 
loo_excel.disconnectobject() 
DESTROY loo_excel 
//Destroy lun_so

//****************************************//
//  Transferencia de archivo a Importar	//
//****************************************//

dw_1.accepttext()

For ll_inicio = 1 to dw_1.Rowcount()
	 ld_fecha     = Date(dw_1.object.fecha [ll_inicio])
	 ll_nro_cuota = dw_1.object.nro_cuota [ll_inicio]
	 //montos
	 ldc_capital = dw_1.object.capital [ll_inicio]
	 ldc_interes = dw_1.object.interes [ll_inicio]
	 ldc_portes	 = dw_1.object.portes  [ll_inicio]
	 ldc_igv 	 = dw_1.object.igv	  [ll_inicio]
	 //codigos
	 ls_cod_capital = Trim(dw_1.object.cod_cap [ll_inicio])
	 ls_cod_int		 = Trim(dw_1.object.cod_int [ll_inicio])
	 ls_cod_portes	 = Trim(dw_1.object.cod_por [ll_inicio])
	 ls_cod_igv 	 = Trim(dw_1.object.cod_igv [ll_inicio])
 		
	 
	 //inserta registro en el detalle para capital
	 if Not(Isnull(ldc_capital) or ldc_capital = 0) then
		 dw_detail.Triggerevent( 'ue_insert')
		 dw_detail.object.nro_cuota			  [dw_detail.il_row] = ll_nro_cuota
		 dw_detail.object.tipo_deuda_concepto [dw_detail.il_row] = ls_cod_capital
		 dw_detail.object.fec_vcto_proy 		  [dw_detail.il_row] = ld_fecha
		 dw_detail.object.monto_proy	 		  [dw_detail.il_row] = ldc_capital
	 end if
	 
	 //inserta registro en el detalle para interes
	 if Not(Isnull(ldc_interes) or ldc_interes = 0) then
		 dw_detail.Triggerevent( 'ue_insert')
		 dw_detail.object.nro_cuota			  [dw_detail.il_row] = ll_nro_cuota
		 dw_detail.object.tipo_deuda_concepto [dw_detail.il_row] = ls_cod_int
		 dw_detail.object.fec_vcto_proy 		  [dw_detail.il_row] = ld_fecha
		 dw_detail.object.monto_proy	 		  [dw_detail.il_row] = ldc_interes
	 end if
	 
	 //inserta registro en el detalle para portes
	 if Not(Isnull(ldc_portes) or ldc_portes = 0) then
		 dw_detail.Triggerevent( 'ue_insert')
		 dw_detail.object.nro_cuota			  [dw_detail.il_row] = ll_nro_cuota
		 dw_detail.object.tipo_deuda_concepto [dw_detail.il_row] = ls_cod_portes
		 dw_detail.object.fec_vcto_proy 		  [dw_detail.il_row] = ld_fecha
		 dw_detail.object.monto_proy	 		  [dw_detail.il_row] = ldc_portes
	 end if
	 
	 //inserta registro en el detalle para igv
	 if Not(Isnull(ldc_igv) or ldc_igv = 0) then
		 dw_detail.Triggerevent( 'ue_insert')
		 dw_detail.object.nro_cuota			  [dw_detail.il_row] = ll_nro_cuota
		 dw_detail.object.tipo_deuda_concepto [dw_detail.il_row] = ls_cod_igv
		 dw_detail.object.fec_vcto_proy 		  [dw_detail.il_row] = ld_fecha
		 dw_detail.object.monto_proy	 		  [dw_detail.il_row] = ldc_igv
	 end if
	 	 
Next	


of_totales_deuda ()

end event

type pb_1 from picturebutton within w_fi362_deuda_financiera
integer x = 3127
integer y = 552
integer width = 101
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "CreateRuntime5!"
alignment htextalign = left!
end type

event clicked;String ls_tipo_deuda 
Long   ll_inicio,ll_nro_cuotas,ll_dia_plazo
Date   ld_fecha_cuota	
Decimal {2} ldc_monto_deuda,ldc_monto_cuota


ll_nro_cuotas   = Long(sle_cuotas.text)
ll_dia_plazo    = Long(sle_plazo.text)
ld_fecha_cuota  = Date(em_f_cuota.text)
ldc_monto_deuda = Dec(em_deuda.text)

ls_tipo_deuda = dw_master.object.tipo_deuda_fin [dw_master.Getrow()]
				
if Isnull(ls_tipo_deuda) or Trim(ls_tipo_deuda) = '' then
	Messagebox('Aviso','Debe Ingresar Tipo de Deuda en la Cabecera ,Verifique!')
	Return
end if


if ll_nro_cuotas = 0 or Isnull(ll_nro_cuotas) then
	sle_cuotas.Setfocus()
	Messagebox('Aviso','Debe Ingresar Tipo de Deuda en la Cabecera ,Verifique!')
	Return
end if	

if ldc_monto_deuda = 0 or Isnull(ldc_monto_deuda) then
	em_deuda.Setfocus()
	Messagebox('Aviso','Debe Ingresar Monto de Deuda par Generar Cuotas ,Verifique!')
	Return
end if	


//monto por cuota
ldc_monto_cuota = Round(ldc_monto_deuda / ll_nro_cuotas,2)


For ll_inicio = 1 to ll_nro_cuotas
	 dw_detail.TriggerEvent('ue_insert')	
	 dw_detail.object.nro_cuota 			  [dw_detail.il_row] = ll_inicio
	 dw_detail.object.tipo_deuda_concepto [dw_detail.il_row] = '01'     //capital
	 dw_detail.object.monto_proy			  [dw_detail.il_row] = ldc_monto_cuota
 	 dw_detail.object.fec_vcto_proy		  [dw_detail.il_row] = ld_fecha_cuota

	 ld_fecha_cuota = RelativeDate ( ld_fecha_cuota, ll_dia_plazo )
	 
Next	
end event

type sle_plazo from singlelineedit within w_fi362_deuda_financiera
integer x = 3296
integer y = 420
integer width = 174
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_fi362_deuda_financiera
integer x = 2702
integer y = 432
integer width = 631
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Plazo de Entre Cuotas :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_fi362_deuda_financiera
integer x = 2702
integer y = 332
integer width = 375
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "F.Inicio Deuda :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi362_deuda_financiera
integer x = 2702
integer y = 236
integer width = 375
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Cuotas :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi362_deuda_financiera
integer x = 2702
integer y = 140
integer width = 375
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Monto :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_f_cuota from editmask within w_fi362_deuda_financiera
integer x = 3095
integer y = 320
integer width = 343
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
end type

type sle_cuotas from singlelineedit within w_fi362_deuda_financiera
integer x = 3095
integer y = 224
integer width = 174
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type em_deuda from editmask within w_fi362_deuda_financiera
integer x = 3095
integer y = 128
integer width = 507
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###,###.00"
end type

type dw_detail from u_dw_abc within w_fi362_deuda_financiera
integer x = 32
integer y = 1516
integer width = 3762
integer height = 688
integer taborder = 20
string dataobject = "d_abc_deuda_financiera_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_rk[1] = 1 	      // columnas que recibimos del master



idw_mst = dw_master
idw_det = dw_detail

end event

event ue_insert_pre;call super::ue_insert_pre;String ls_tipo_doc,ls_flag_estado

ls_tipo_doc 	= dw_master.object.doc_deuda_det_fin [1]
ls_flag_estado = dw_master.object.flag_estado		 [1]

this.object.cnta_prsp    [al_row] = is_cnta_prsp
this.object.flag_estado  [al_row] = ls_flag_estado
this.object.cnta_prsp    [al_row] = is_cnta_prsp
this.object.tipo_doc_ref [al_row] = ls_tipo_doc
end event

event itemchanged;call super::itemchanged;Decimal {2} ldc_capital_proy,ldc_interes_proy,ldc_portes_proy,ldc_igv_proy

Accepttext()


choose case dwo.name
		 case	'tipo_deuda_concepto'
				of_totales_deuda ()
				
		 case 'monto_proy'
				of_totales_deuda ()

				
				
				
				
end choose

end event

event itemerror;call super::itemerror;Return 1
end event

type dw_master from u_dw_abc within w_fi362_deuda_financiera
integer x = 37
integer y = 16
integer width = 2601
integer height = 1472
string dataobject = "d_abc_deuda_financiera_cab_tbl"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;String ls_null,ls_data1,ls_data2,ls_data3,ls_data4,ls_data5,ls_data6
Long   ll_count

Setnull(ls_null)
Accepttext()


CHOOSE CASE dwo.name
		 CASE 'cod_moneda'

            select Count(*) into :ll_count
				  from moneda
				 where (cod_moneda = :data) ;
			   										
				
				if ll_count = 0 then
					this.object.cod_moneda [row] = ls_null
					Messagebox('Aviso','Codigo de Moneda No Existe, Verifique!')
					Return 1
			   END IF	
				
				
		 CASE 'tipo_deuda_fin'
            select deuda_financ_tipo.descripcion,
						 deuda_financ_tipo.tipo_doc , 
						 deuda_financ_tipo.flag_cxc_cxp ,
						 deuda_financ_tipo.flag_cxc_cxp_det,
						 deuda_financ_tipo.flag_capital ,
						 deuda_financ_tipo.doc_deuda_det_fin 
			     into :ls_data1,:ls_data2,:ls_data3,:ls_data4,:ls_data5,:ls_data6
				  from deuda_financ_tipo 
		   	 where (deuda_financ_tipo.flag_estado    = '1'   ) and
				 		 (deuda_financ_tipo.tipo_deuda_fin = :data ) ;
						  

				 if sqlca.sqlcode = 100 then
				    Messagebox('Aviso','Tipo de Deuda Financiera No Existe o Esta Inactivo,Verifique!')	
				    This.object.tipo_deuda_fin                [row] = ls_null
					 This.object.deuda_financ_tipo_descripcion [row] = ls_null
				    This.object.tipo_doc							 [row] = ls_null
				    This.object.flag_cxc_cxp		 				 [row] = ls_null
					 This.object.flag_cxc_cxp_det  				 [row] = ls_null
					 This.object.flag_capital 		 				 [row] = ls_null
					 This.object.doc_deuda_det_fin 				 [row] = ls_null
				  	 Return 1
			    else
					 This.object.deuda_financ_tipo_descripcion [row] = ls_data1
				    This.object.tipo_doc							 [row] = ls_data2
				    This.object.flag_cxc_cxp		 				 [row] = ls_data3
					 This.object.flag_cxc_cxp_det  				 [row] = ls_data4
					 This.object.flag_capital 		 				 [row] = ls_data5
					 This.object.doc_deuda_det_fin 				 [row] = ls_data6

			    end if										 
			
														 
	  	 CASE 'tipo_doc'
				select desc_tipo_doc into :ls_data1
				  from doc_tipo
				 where (tipo_doc = :data) ;
				
				
				 if sqlca.sqlcode = 100 then
				    Messagebox('Aviso','Tipo de Documento No Existe o Esta Inactivo,Verifique!')	
				    This.object.tipo_doc [row] = ls_null
				  	 Return 1
			    end if										 

		 CASE 'tipo_doc_ref'
			   select desc_tipo_doc into :ls_data1
				  from doc_tipo
				 where (tipo_doc = :data) ;
				
				
				 if sqlca.sqlcode = 100 then
				    Messagebox('Aviso','Tipo de Documento No Existe o Esta Inactivo,Verifique!')	
				    This.object.tipo_doc_ref [row] = ls_null
				  	 Return 1
			    end if									
				 
		 CASE 'cod_relacion'
			
				select p.nom_proveedor into :ls_data1
				  from proveedor p
				 where (p.proveedor   = :data) and
				 		 (p.flag_estado = '1'  ) ;

				if sqlca.sqlcode = 100 then
					This.object.cod_relacion  [row] = ls_null
					This.object.nom_proveedor [row] = ls_null
				else
					This.object.nom_proveedor [row] = ls_data1
				end if
				 
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez



ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = dw_master
idw_det = dw_detail

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen   [al_row] = gs_origen
this.object.fec_registro [al_row] = today()
this.object.usr_reg      [al_row] = gs_user
this.object.flag_estado  [al_row] = '3'
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return

String ls_name,ls_prot
Str_seleccionar lstr_seleccionar


ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'cod_moneda'
			   lstr_seleccionar.s_seleccion = 'S'
            lstr_seleccionar.s_sql = 'SELECT MONEDA.COD_MONEDA AS CODIGO,'&
			  											+'MONEDA.DESCRIPCION AS DESCRIPCION '&
			   										+'FROM MONEDA '  
														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
			 	   Setitem(row,'cod_moneda',lstr_seleccionar.param1[1])
					ii_update = 1
			   END IF	
				
		 CASE 'tipo_deuda_fin'
			   lstr_seleccionar.s_seleccion = 'S'
            lstr_seleccionar.s_sql = 'SELECT DEUDA_FINANC_TIPO.TIPO_DEUDA_FIN AS CODIGO,'&
													 	 +'DEUDA_FINANC_TIPO.DESCRIPCION AS DESCRIPCION,'&
														 +'DEUDA_FINANC_TIPO.TIPO_DOC AS TIPO_DOC, '&
														 +'DEUDA_FINANC_TIPO.FLAG_CXC_CXP AS FLAG_DOC_CAB,'&
														 +'DEUDA_FINANC_TIPO.FLAG_CXC_CXP_DET AS FLAG_DOC_DET,'&
														 +'DEUDA_FINANC_TIPO.FLAG_CAPITAL AS FLAG_CAPITAL,'&
														 +'DEUDA_FINANC_TIPO.DOC_DEUDA_DET_FIN AS TIPO_DOC_DET '&														 
														 +'FROM DEUDA_FINANC_TIPO '&
														 +'WHERE DEUDA_FINANC_TIPO.FLAG_ESTADO = '+"'"+'1'+"'"
														 
				OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
			 	   Setitem(row,'tipo_deuda_fin'					 ,lstr_seleccionar.param1[1])
					Setitem(row,'deuda_financ_tipo_descripcion',lstr_seleccionar.param2[1])
				   Setitem(row,'tipo_doc'							 ,lstr_seleccionar.param3[1])
					Setitem(row,'flag_cxc_cxp'						 ,lstr_seleccionar.param4[1])
					Setitem(row,'flag_cxc_cxp_det'				 ,lstr_seleccionar.param5[1])
					Setitem(row,'flag_capital'						 ,lstr_seleccionar.param6[1])
					Setitem(row,'doc_deuda_det_fin'				 ,lstr_seleccionar.param7[1])
					ii_update = 1
			   END IF	
														 
	  	 CASE 'tipo_doc'
			   lstr_seleccionar.s_seleccion = 'S'
            lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC AS CODIGO_DOC,'&
			  											+'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION '&
			   										+'FROM DOC_TIPO '  
														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
			 	   Setitem(row,'tipo_doc',lstr_seleccionar.param1[1])
					
					ii_update = 1
					
			   END IF	


		CASE 'tipo_doc_ref'
			   lstr_seleccionar.s_seleccion = 'S'
            lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC AS CODIGO_DOC,'&
			  											+'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION '&
			   										+'FROM DOC_TIPO '  
														
			   OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			   IF lstr_seleccionar.s_action = "aceptar" THEN
			 	   Setitem(row,'tipo_doc_ref',lstr_seleccionar.param1[1])
					ii_update = 1
			   END IF	
				
		 CASE 'cod_relacion'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO , '&
								   					 +'PROVEEDOR.NOM_PROVEEDOR AS DESCRIPCION,'&
                                           +'RUC AS NRO_RUC '				   &
									   				 +'FROM PROVEEDOR '&
														 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
					Setitem(row,'nom_proveedor',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
				
			
							
END CHOOSE


end event

type gb_2 from groupbox within w_fi362_deuda_financiera
integer x = 2670
integer y = 44
integer width = 1125
integer height = 700
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Generar Cuotas x Monto de Capital"
end type

type gb_1 from groupbox within w_fi362_deuda_financiera
integer x = 2665
integer y = 1104
integer width = 1102
integer height = 380
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Partida Presupuestal"
end type

