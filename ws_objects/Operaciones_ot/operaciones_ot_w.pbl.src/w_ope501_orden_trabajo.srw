$PBExportHeader$w_ope501_orden_trabajo.srw
forward
global type w_ope501_orden_trabajo from w_abc
end type
type st_1 from statictext within w_ope501_orden_trabajo
end type
type tab_1 from tab within w_ope501_orden_trabajo
end type
type tabpage_1 from userobject within tab_1
end type
type dw_master from u_dw_abc within tabpage_1
end type
type dw_1 from u_dw_cns within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_master dw_master
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_det_art from u_dw_abc within tabpage_2
end type
type dw_det_op from u_dw_abc within tabpage_2
end type
type dw_lista_op from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_det_art dw_det_art
dw_det_op dw_det_op
dw_lista_op dw_lista_op
end type
type tabpage_3 from userobject within tab_1
end type
type dw_compras from u_dw_cns within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_compras dw_compras
end type
type tabpage_4 from userobject within tab_1
end type
type dw_servicios from u_dw_cns within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_servicios dw_servicios
end type
type tabpage_5 from userobject within tab_1
end type
type dw_art_pendientes from u_dw_cns within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_art_pendientes dw_art_pendientes
end type
type tabpage_9 from userobject within tab_1
end type
type dw_pend_compra from u_dw_cns within tabpage_9
end type
type tabpage_9 from userobject within tab_1
dw_pend_compra dw_pend_compra
end type
type tabpage_6 from userobject within tab_1
end type
type dw_consumo_int from u_dw_cns within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_consumo_int dw_consumo_int
end type
type tabpage_7 from userobject within tab_1
end type
type dw_gd from u_dw_cns within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_gd dw_gd
end type
type tabpage_8 from userobject within tab_1
end type
type dw_ingresos from u_dw_cns within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_ingresos dw_ingresos
end type
type tabpage_10 from userobject within tab_1
end type
type dw_destajero from u_dw_cns within tabpage_10
end type
type tabpage_10 from userobject within tab_1
dw_destajero dw_destajero
end type
type tabpage_11 from userobject within tab_1
end type
type dw_jornaleros from u_dw_cns within tabpage_11
end type
type tabpage_11 from userobject within tab_1
dw_jornaleros dw_jornaleros
end type
type tab_1 from tab within w_ope501_orden_trabajo
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_9 tabpage_9
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
tabpage_10 tabpage_10
tabpage_11 tabpage_11
end type
type cb_1 from commandbutton within w_ope501_orden_trabajo
end type
type sle_nro_ot from u_sle_codigo within w_ope501_orden_trabajo
end type
end forward

global type w_ope501_orden_trabajo from w_abc
integer width = 3813
integer height = 2400
string title = "[OPE501] Consulta por Orden de Trabajo"
string menuname = "m_cns"
st_1 st_1
tab_1 tab_1
cb_1 cb_1
sle_nro_ot sle_nro_ot
end type
global w_ope501_orden_trabajo w_ope501_orden_trabajo

type variables
String 	is_plantilla, is_col, is_data_type, is_doc_ot, &
			is_accion, is_ot_adm, is_cod_plant, is_flag_cnta_prsp, &
			is_dolares,	is_seccion_def,is_tip_seccion, is_articulo
			
DatawindowChild idw_child

u_dw_abc idw_det_op, idw_det_art, idw_lista_op




end variables

forward prototypes
public subroutine of_asignar_dws ()
public subroutine of_retrieve (string as_orden)
end prototypes

public subroutine of_asignar_dws ();// Asigno los Datawindows con sus respectivas variables globales

idw_lista_op 				= tab_1.tabpage_2.dw_lista_op
idw_det_op					= tab_1.tabpage_2.dw_det_op  
idw_det_art					= tab_1.tabpage_2.dw_det_art

end subroutine

public subroutine of_retrieve (string as_orden);Long ll_count

Select count(nro_orden) into :ll_count from orden_trabajo where 
    nro_orden = :as_orden;
if ll_count = 0 then
	Messagebox( "Error", "Orden de Trabajo no existe")		
	Return
end if

is_articulo = as_orden

tab_1.SelectTab(1)

tab_1.tabpage_1.dw_master.Retrieve(as_orden)
tab_1.tabpage_1.dw_1.Retrieve(as_orden)
tab_1.tabpage_3.dw_compras.Retrieve(as_orden)
tab_1.tabpage_4.dw_servicios.Retrieve(as_orden)
tab_1.tabpage_5.dw_art_pendientes.Retrieve(as_orden)
tab_1.tabpage_6.dw_consumo_int.Retrieve(as_orden)
tab_1.tabpage_7.dw_gd.Retrieve(as_orden)
tab_1.tabpage_8.dw_ingresos.Retrieve(as_orden)
tab_1.tabpage_9.dw_pend_compra.Retrieve(as_orden)
tab_1.tabpage_10.dw_destajero.Retrieve(as_orden)
tab_1.tabpage_11.dw_jornaleros.Retrieve(as_orden)

tab_1.tabpage_2.dw_lista_op.Retrieve(as_orden)
tab_1.tabpage_2.dw_det_op.Retrieve(as_orden)
tab_1.tabpage_2.dw_det_art.Retrieve(as_orden)

end subroutine

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

im_1 = CREATE m_rButton      				// crear menu de boton derecho del mouse

tab_1.tabpage_1.dw_master.SetTransObject(sqlca)
tab_1.tabpage_1.dw_1.SetTransObject(sqlca)
tab_1.tabpage_3.dw_compras.SetTransObject(sqlca)
tab_1.tabpage_4.dw_servicios.SetTransObject(sqlca)
tab_1.tabpage_5.dw_art_pendientes.SetTransObject(sqlca)
tab_1.tabpage_6.dw_consumo_int.SetTransObject(sqlca)
tab_1.tabpage_7.dw_gd.SetTransObject(sqlca)
tab_1.tabpage_8.dw_ingresos.SetTransObject(sqlca)
tab_1.tabpage_9.dw_pend_compra.SetTransObject(sqlca)
tab_1.tabpage_10.dw_destajero.SetTransObject(sqlca)
tab_1.tabpage_11.dw_jornaleros.SetTransObject(sqlca)

tab_1.tabpage_2.dw_lista_op.SetTransObject(sqlca)
tab_1.tabpage_2.dw_det_op.SetTransObject(sqlca)
tab_1.tabpage_2.dw_det_art.SetTransObject(sqlca)


idw_query = tab_1.tabpage_1.dw_1

//wf_reset_dw()
of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event resize;call super::resize;tab_1.width = newwidth - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_1.dw_master.width  = tab_1.tabpage_1.width  - tab_1.tabpage_1.dw_master.x - 10
tab_1.tabpage_1.dw_1.width  		= tab_1.tabpage_1.width  - tab_1.tabpage_1.dw_1.x - 10
tab_1.tabpage_1.dw_1.height 		= tab_1.tabpage_1.height - tab_1.tabpage_1.dw_1.y - 10


tab_1.tabpage_2.dw_lista_op.height 	= tab_1.tabpage_2.height - tab_1.tabpage_2.dw_lista_op.y - 10
tab_1.tabpage_2.dw_det_op.width		= tab_1.tabpage_2.width  - tab_1.tabpage_2.dw_det_op.x - 10
tab_1.tabpage_2.dw_det_art.width  	= tab_1.tabpage_2.width  - tab_1.tabpage_2.dw_det_art.x - 10
tab_1.tabpage_2.dw_det_art.height 	= tab_1.tabpage_2.height - tab_1.tabpage_2.dw_det_art.y - 10


tab_1.tabpage_3.dw_compras.width  = tab_1.tabpage_3.width  - tab_1.tabpage_3.dw_compras.x - 10
tab_1.tabpage_3.dw_compras.height = tab_1.tabpage_3.height - tab_1.tabpage_3.dw_compras.y - 10

tab_1.tabpage_4.dw_servicios.width  = tab_1.tabpage_4.width  - tab_1.tabpage_4.dw_servicios.x - 10
tab_1.tabpage_4.dw_servicios.height = tab_1.tabpage_4.height - tab_1.tabpage_4.dw_servicios.y - 10

tab_1.tabpage_5.dw_art_pendientes.width  = tab_1.tabpage_5.width  - tab_1.tabpage_5.dw_art_pendientes.x - 10
tab_1.tabpage_5.dw_art_pendientes.height = tab_1.tabpage_5.height - tab_1.tabpage_5.dw_art_pendientes.y - 10

tab_1.tabpage_6.dw_consumo_int.width  = tab_1.tabpage_6.width  - tab_1.tabpage_6.dw_consumo_int.x - 10
tab_1.tabpage_6.dw_consumo_int.height = tab_1.tabpage_6.height - tab_1.tabpage_6.dw_consumo_int.y - 10


tab_1.tabpage_7.dw_gd.width  = tab_1.tabpage_7.width  - tab_1.tabpage_7.dw_gd.x - 10
tab_1.tabpage_7.dw_gd.height = tab_1.tabpage_7.height - tab_1.tabpage_7.dw_gd.y - 10


tab_1.tabpage_8.dw_ingresos.width  = tab_1.tabpage_8.width  - tab_1.tabpage_8.dw_ingresos.x - 10
tab_1.tabpage_8.dw_ingresos.height = tab_1.tabpage_8.height - tab_1.tabpage_8.dw_ingresos.y - 10

tab_1.tabpage_9.dw_pend_compra.width  = tab_1.tabpage_9.width  - tab_1.tabpage_9.dw_pend_compra.x - 10
tab_1.tabpage_9.dw_pend_compra.height = tab_1.tabpage_9.height - tab_1.tabpage_9.dw_pend_compra.y - 10

tab_1.tabpage_10.dw_destajero.width  = tab_1.tabpage_10.width  - tab_1.tabpage_10.dw_destajero.x - 10
tab_1.tabpage_10.dw_destajero.height = tab_1.tabpage_10.height - tab_1.tabpage_10.dw_destajero.y - 10

tab_1.tabpage_11.dw_jornaleros.width  = tab_1.tabpage_11.width  - tab_1.tabpage_11.dw_jornaleros.x - 10
tab_1.tabpage_11.dw_jornaleros.height = tab_1.tabpage_11.height - tab_1.tabpage_11.dw_jornaleros.y - 10

end event

on w_ope501_orden_trabajo.create
int iCurrent
call super::create
if this.MenuName = "m_cns" then this.MenuID = create m_cns
this.st_1=create st_1
this.tab_1=create tab_1
this.cb_1=create cb_1
this.sle_nro_ot=create sle_nro_ot
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_nro_ot
end on

on w_ope501_orden_trabajo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.tab_1)
destroy(this.cb_1)
destroy(this.sle_nro_ot)
end on

event open;// Ancestor Script has been Override
of_asignar_dws()

IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF


//cargar seccion generica
select ot_seccion_def,seccion_tipo_def 
  into :is_seccion_def,:is_tip_seccion
  from prod_param 
 where (reckey = '1') ;
 
idw_query = tab_1.tabpage_3.dw_compras


//asigna seccion general
//tab_1.tabpage_6.sle_seccion.text     = is_seccion_def
//tab_1.tabpage_6.sle_tip_seccion.text = is_tip_seccion
//tab_1.tabpage_6.em_factor.text		 = '1'


//Abrir y recuperar (necesita parametros)
str_parametros sl_param
sl_param = Message.PowerObjectParm

String ls_nro_ot
Long ll_row, ll_operacion
//If sl_param.opcion = 1 then
//	ls_nro_ot = sl_param.string1
//	ll_operacion = sl_param.long1

	
	
	//wf_retrieve_dw(ls_nro_ot)
//	wf_retrieve_dw(gs_origen, ls_nro_ot)
	
	TriggerEvent ('ue_modify')
	//Dirigirse al tab de Operaciones
	tab_1.SelectedTab = 2
	

	IF ll_row = 0 Then Return
	
	idw_1.Event ue_output(ll_row)
	
	
//END IF
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		
IF ib_update_check = FALSE THEN RETURN

sl_param.dw1     = 'd_lista_ots_tbl'
sl_param.titulo  = 'Orden de Trabajo'
sl_param.tipo    = ''

sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	sle_nro_ot.text = sl_param.field_ret[1]
	of_retrieve( sl_param.field_ret[1])
	TriggerEvent ('ue_modify')
	
END IF
end event

event ue_print;call super::ue_print;Integer 	li_row
String	ls_nro_orden
str_parametros lstr_param
u_dw_abc			ldw_master

ldw_master = tab_1.tabpage_1.dw_master

if ldw_master.getRow() = 0 then return
li_row = ldw_master.getRow()

ls_nro_orden = ldw_master.object.nro_orden [li_row]

lstr_param.dw1 		= 'd_rpt_formato_ot_tbl'
lstr_param.titulo 	= 'Previo de Orden de Trabajo [' + ls_nro_orden + "]"
lstr_param.string1 	= ls_nro_orden
lstr_param.posicion_paper = 2   //Portrait
lstr_param.tipo		= '1S'


OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end event

event ue_filter_avanzado;//Override
idw_query.Event dynamic ue_filter_avanzado()
end event

event ue_saveas_excel;call super::ue_saveas_excel;string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( idw_query, ls_file )
End If
end event

event ue_saveas;call super::ue_saveas;idw_query.EVENT dynamic ue_saveas()
end event

event ue_saveas_pdf;call super::ue_saveas_pdf;string ls_path, ls_file
int li_rc
n_cst_email	lnv_email

ls_file = idw_query.Object.DataWindow.Print.DocumentName

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "PDF", &
   "Archivos PDF (*.pdf),*.pdf" , "C:\", 32770)

IF li_rc = 1 Then
	lnv_email = CREATE n_cst_email
	try
		if not lnv_email.of_create_pdf( idw_query, ls_path) then return
		
		MessageBox('Confirmacion', 'Se ha creado el archivo ' + ls_path + ' satisfactoriamente.', Exclamation!)
		
	catch (Exception ex)
		MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + ls_path + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
		
	finally
		Destroy lnv_email
		
	end try
	
End If
end event

type st_1 from statictext within w_ope501_orden_trabajo
integer x = 105
integer y = 40
integer width = 462
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Trabajo"
boolean focusrectangle = false
end type

type tab_1 from tab within w_ope501_orden_trabajo
integer y = 148
integer width = 3707
integer height = 2004
integer taborder = 30
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
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_9 tabpage_9
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
tabpage_10 tabpage_10
tabpage_11 tabpage_11
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_9=create tabpage_9
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.tabpage_8=create tabpage_8
this.tabpage_10=create tabpage_10
this.tabpage_11=create tabpage_11
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_9,&
this.tabpage_6,&
this.tabpage_7,&
this.tabpage_8,&
this.tabpage_10,&
this.tabpage_11}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_9)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
destroy(this.tabpage_8)
destroy(this.tabpage_10)
destroy(this.tabpage_11)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3671
integer height = 1828
long backcolor = 79741120
string text = "Orden Trabajo"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_master dw_master
dw_1 dw_1
end type

on tabpage_1.create
this.dw_master=create dw_master
this.dw_1=create dw_1
this.Control[]={this.dw_master,&
this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_master)
destroy(this.dw_1)
end on

type dw_master from u_dw_abc within tabpage_1
integer width = 3173
integer height = 412
string dataobject = "d_abc_orden_trabajo_ff"
end type

event clicked;call super::clicked;This.BorderStyle = StyleRaised!
idw_1 = THIS
This.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez


ii_ck[1] = 13		// columnas de lectrua de este dw

ii_dk[1] = 15 	   // columnas que se pasan al detalle


idw_mst  = dw_master

end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String ls_adm,ls_name,ls_prot
str_seleccionar lstr_seleccionar


ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

This.Accepttext()


CHOOSE CASE dwo.name
	    CASE 'ot_tipo'

		
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT OT_TIPO.OT_TIPO AS CODIGO, '&   
												 +'OT_TIPO.DESCRIPCION  AS DESCRIPCION  '&   
												 +'FROM  OT_TIPO '&
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'ot_tipo',lstr_seleccionar.param1[1])
					Setitem(row,'desc_ot_tipo',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF												 

END CHOOSE
end event

event itemchanged;call super::itemchanged;String ls_descripcion, ls_ot_adm

Accepttext()

CHOOSE CASE dwo.name

				
		 CASE 'ot_tipo'
			   ls_ot_adm = This.object.ot_adm [row]
				
			   SELECT descripcion
				  INTO :ls_descripcion
				  FROM ot_tipo 
				 WHERE (ot_tipo = :data     ) ;

				
				IF Isnull(ls_descripcion) OR Trim(ls_descripcion) = '' THEN
					SetNull(ls_descripcion)
					Messagebox('Aviso','Tipo de OT No Existe , Verifique')
					This.object.ot_tipo      [row] = ls_descripcion
					This.object.desc_ot_tipo [row] = ls_descripcion
					Return 1
				END IF
				This.object.desc_ot_tipo [row] = ls_descripcion
				
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

type dw_1 from u_dw_cns within tabpage_1
integer y = 420
integer width = 3081
integer height = 1328
integer taborder = 40
string dataobject = "d_abc_orden_trabajo_ff_det"
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3671
integer height = 1828
long backcolor = 79741120
string text = "Operaciones"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_det_art dw_det_art
dw_det_op dw_det_op
dw_lista_op dw_lista_op
end type

on tabpage_2.create
this.dw_det_art=create dw_det_art
this.dw_det_op=create dw_det_op
this.dw_lista_op=create dw_lista_op
this.Control[]={this.dw_det_art,&
this.dw_det_op,&
this.dw_lista_op}
end on

on tabpage_2.destroy
destroy(this.dw_det_art)
destroy(this.dw_det_op)
destroy(this.dw_lista_op)
end on

type dw_det_art from u_dw_abc within tabpage_2
integer x = 1161
integer y = 844
integer width = 2313
integer height = 504
integer taborder = 20
string dataobject = "d_abc_insumo_ot_tbl"
end type

event clicked;call super::clicked;//idw_1.BorderStyle = StyleRaised!
//idw_1 = THIS
//idw_1.BorderStyle = StyleLowered!
//
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1	
ii_ck[2] = 2	
ii_rk[1] = 22

idw_mst  =  dw_det_op
idw_det  =  dw_det_art
end event

event dberror;call super::dberror;
String	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name
Integer	li_pos_ini, li_pos_fin, li_pos_nc

ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1

ls_cadena = Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc = Pos(ls_cadena,'.',1) - 1 
ls_prop   = Mid(ls_cadena,1,li_pos_nc)
ls_const  = Mid(ls_cadena,li_pos_nc + 2)

CHOOSE CASE sqldbcode
//	CASE 1                        // Llave Duplicada
//        Messagebox('Error PK: ' + this.ClassName(),'Llave Duplicada, Linea: ' + String(row))
//		  Return 1
	CASE 02292                         // Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
        INTO :ls_name
        FROM ALL_CONSTRAINTS
       WHERE ((OWNER          = :ls_prop  ) AND 
             (CONSTRAINT_NAME = :ls_const )) ;
        Messagebox('Error FK: ' + this.ClassName(),'Registro Tiene Movimientos en Tabla: '+ls_name)
        Return 1
	CASE ELSE
		ls_msg  = 'Database: ' + SQLCA.Database + ls_crlf
		ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
		ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
		ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
		ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
		ls_msg += 'SQLDBCode: ' + String(SQLDBCode) + ls_crlf
		ls_msg += 'SQLErrText: ' + SQLErrText + ls_crlf
		ls_msg += 'Linea: ' + String(row) + ls_crlf
		//ls_msg += 'SQLDBCode: ' + String(SQLCA.SQLDBCode) + ls_crlf
		//ls_msg += 'SQLErrText: ' + SQLCA.SQLErrText + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID
		messagebox('dberror: ' + this.ClassName(), ls_msg, StopSign!)
END CHOOSE





end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN Return

String ls_name,ls_prot,ls_cod_labor, ls_und, ls_cnta_prsp, ls_estado, ls_modifica
String ls_flag_modifica
Decimal{4} ld_cant_procesada

str_seleccionar lstr_seleccionar

ls_name = dwo.name
if this.Describe( lower(dwo.name) + ".Protect") = '1' then return


ls_estado = this.Object.estado[row]
ls_modifica = this.Object.modifica[row]

CHOOSE CASE dwo.name
	CASE 'cod_art'
		// No muestra ayuda, en caso no esta permitido modificar cod_art
		
		IF (isnull(ls_estado) OR isnull(ls_modifica)) THEN RETURN
	
		ls_cod_labor = dw_det_op.object.cod_labor [dw_det_op.getrow()]
		
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = "SELECT COD_ART AS CODIGO, "&   
									  + "DESC_ART AS DESCRIPCION, "&   
									  + "UND AS UNIDAD, "&   
									  + "CNTA_PRSP_INSM AS CUENTA_PRESUPUESTAL "&
									  + "FROM  VW_MTT_ART_X_LABOR "&
									  + "WHERE COD_LABOR = '" + ls_cod_labor + "'"    



		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			
			this.object.cod_art 			[row] = lstr_seleccionar.param1[1]
			this.object.nom_articulo 	[row] = lstr_seleccionar.param2[1]
			this.object.und				[row] = lstr_seleccionar.param3[1]
			this.object.cnta_prsp		[row] = lstr_seleccionar.param4[1]
			this.ii_update = 1
			//of_set_articulo(lstr_seleccionar.param1[1])
		END IF
		
 	CASE 'cnta_prsp'
		// No muestra ayuda, en caso no esta permitido modificar cnta_prsp
		IF (isnull(ls_estado) OR isnull(ls_modifica)) THEN RETURN
		
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT CNTA_PRSP AS CNTA_PRSP, '&   
									  + 'DESCRIPCION AS DESCRIPCION '&   
									  + 'FROM  PRESUPUESTO_CUENTA '

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			this.object.cnta_prsp	[row] = lstr_seleccionar.param1[1]
			this.ii_update = 1
		END IF

 	CASE 'almacen'
		// No muestra ayuda, en caso no esta permitido modificar almacen
		IF (isnull(ls_estado) OR isnull(ls_modifica)) THEN RETURN
		
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = "SELECT almacen AS codigo_almacen, "&   
										 +"desc_almacen AS DESCripcion_almacen "&   
										 +"FROM  almacen " &
										 +"where flag_estado = '1'"

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			this.object.almacen [row] = lstr_seleccionar.param1[1]
//			of_set_saldo_total(this.object.cod_art[this.GetRow()], lstr_seleccionar.param1[1])
			this.ii_update = 1
		END IF
				

END CHOOSE
end event

event itemchanged;call super::itemchanged;String ls_cod_art, ls_desc_art,ls_uni_art, ls_colname,ls_cod_labor,&
		 ls_cnta_prsp, ls_desc, ls_null

DateTime ldt_fec_inicio_ope, ldt_fec_inicio_mat

this.acceptText()

ldt_fec_inicio_ope = dw_det_op.object.fec_inicio [dw_det_op.Getrow()] //fecha der inicio de operaciones
ldt_fec_inicio_mat = this.object.fec_proyect [row] //fecha del material

IF ldt_fec_inicio_mat < ldt_fec_inicio_ope then
	messagebox('Aviso','Fecha de material no puede ser menor que fecha de operación')
   THIS.object.fec_proyect [row] = ldt_fec_inicio_ope
	return 1
END IF

ls_colname = dwo.name
SetNull(ls_null)

IF dwo.name = 'cod_art' then
	ls_cod_labor = dw_det_op.object.cod_labor [dw_det_op.getrow()]
	ls_cod_art   = data

	SELECT a.desc_art, a.und, l.cnta_prsp_insm
	  INTO :ls_desc_art, :ls_uni_art, :ls_cnta_prsp
	  FROM articulo a,
	  		 labor_insumo l
	 WHERE a.cod_art     = l.cod_art     
	   AND a.flag_estado = '1'           
		AND l.cod_labor   = :ls_cod_labor 
		AND a.cod_art	  = :ls_cod_art;
	
	IF SQLCA.SQLCode = 100 then
		Messagebox('Aviso','Verifique Codigo de Articulo')
		This.object.cod_art 		 	 [row] = ls_null
		This.object.nom_articulo 	 [row] = ls_null
		This.object.und 			 	 [row] = ls_null
		This.object.cnta_prsp	 	 [row] = ls_null
		Return 1
	end if
	
   THIS.object.nom_articulo	[row] = ls_desc_art
	THIS.object.und				[row] = ls_uni_art
	THIS.object.cnta_prsp		[row] = ls_cnta_prsp
	
//	of_set_articulo(ls_cod_art)
	
elseif dwo.name = 'cnta_prsp' then
	select descripcion
		into :ls_desc
	from presupuesto_cuenta
	where cnta_prsp = :data;
	
	IF SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Cuenta Presupuestal no existe')
		this.object.cnta_prsp [row] = ls_null
		return
	end if

elseif dwo.name = 'almacen' then
	select desc_almacen
		into :ls_desc
	from almacen
	where almacen = :data
	  and flag_estado = '1';
	
	IF SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'El codigo de almacen no existe o no esta activo')
		this.object.almacen [row] = ls_null
		return
	end if
	
//	of_set_saldo_total(this.object.cod_art[this.GetRow()], data)
	  
END IF		


end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
//TriggerEvent ue_modify()
end event

type dw_det_op from u_dw_abc within tabpage_2
integer x = 1161
integer width = 2331
integer height = 832
integer taborder = 20
string dataobject = "d_abc_operacion_ot_ff"
integer ii_protect = 1
end type

event clicked;call super::clicked;//Long   ll_row, ll_inicio, ll_count, ll_opcion, ll_nro_item
//String ls_flag_estado, ls_flag_estado_ot, ls_oper_sec, ls_nro_parte, ls_ot_adm
//String ls_flag_ctrl_aprt_ot
//Decimal ld_cant_real
//
//
////idw_1.BorderStyle = StyleRaised!
////idw_1 = THIS
////idw_1.BorderStyle = StyleLowered!
//
//
//IF dwo.name = 'b_abrir' THEN
//	ll_row = idw_det_op.getrow()
//
//	IF ll_row = 0 THEN RETURN
//	
//	//estado de la ot
//	ls_flag_estado_ot = dw_master.object.flag_estado [dw_master.getrow()]
//
//	IF ls_flag_estado_ot = '0' THEN  //ANULADO
//		Messagebox('Aviso','Orden de Trabajo esta Anulada')
//		RETURN
//	ELSEIF ls_flag_estado_ot = '2' THEN// CERRADA
//		ll_opcion = Messagebox('Orden de Trabajo cerrada', &
//						'Desea continuar', &
//						exclamation!, yesno!,2)
//		
//		IF ll_opcion = 2 THEN
//			RETURN
//		END IF
//		dw_master.object.flag_estado[1]='1'
//		
//	END IF
//		
//	//estado de la operacion
//	ls_flag_estado = idw_det_op.object.flag_estado [ll_row]
//	ls_oper_sec		= idw_det_op.object.oper_sec    [ll_row]
//	
//	IF ls_flag_estado = '1' THEN
//		Messagebox('Aviso','Operacion se Encuentra Activa ')
//		RETURN
//	ELSEIF ls_flag_estado = '3' THEN
//		Messagebox('Aviso','Operacion se Encuentra Proyectada ')
//		RETURN
//	ELSEIF ls_flag_estado = '0' THEN
//		Messagebox('Aviso','Operacion Ha Sido Anulada')
//		RETURN
//	END IF
//	
//	SELECT count(*) 
//	  INTO :ll_count 
//	  FROM pd_ot_det 
//	 WHERE oper_sec = :ls_oper_sec 
//	   AND flag_terminado='1' ;
//	
//	IF ll_count > 0 THEN 
//		select min(nro_parte), nro_item 
//		  into :ls_nro_parte, :ll_nro_item
//		  from pd_ot_det 
//       where oper_sec = :ls_oper_sec AND flag_terminado='1'
//	 group by nro_parte, nro_item ;
//	
//		Messagebox('Corrija por parte diario', 'Operacion cerrada por parte diario '+ls_nro_parte + ', item ' + string(ll_nro_item))
//		Return
//	END IF
//	
//	IF idw_det_op.object.cant_real[ll_row] > 0 THEN
//		idw_det_op.object.flag_estado [ll_row] = '1' //abrir operacion
//	ELSE
//		idw_det_op.object.flag_estado [ll_row] = '3' //proyectar operacion
//	END IF
//	
//	ls_ot_adm = dw_master.object.ot_adm[dw_master.GetRow()]	//ABRIR ARTICULOS
//	
//	SELECT NVL(o.flag_ctrl_aprt_ot,1)
//	  INTO :ls_flag_ctrl_aprt_ot
//	  FROM ot_administracion o
//	 WHERE ot_adm = :ls_ot_adm ;
//	
//	//ABRIR ARTICULOS, DEPENDIENDO DEL PARAMETRO DE CONTROL DEL OT ADM
//	For ll_inicio = 1 TO idw_det_art.Rowcount()
//		 IF ls_flag_ctrl_aprt_ot = '0' THEN
//		 	idw_det_art.object.flag_estado [ll_inicio] = '1'
//		 ELSE
//			idw_det_art.object.flag_estado [ll_inicio] = '3'
//		 END IF
//	Next
//	
//	dw_master.ii_update = 1
//	idw_det_art.ii_update = 1
//	idw_det_op.ii_update = 1
//	
//ELSEIF dwo.name = 'b_cerrar' THEN
//	
//	ll_row = idw_det_op.getrow()
//
//	IF ll_row = 0 THEN RETURN
//	//estado de la ot
//	ls_flag_estado_ot = dw_master.object.flag_estado [dw_master.getrow()]
//
//	IF ls_flag_estado_ot = '0' THEN  //ANULADO
//		Messagebox('Aviso','Orden de Trabajo esta Anulada')
//		RETURN
//	ELSEIF ls_flag_estado_ot = '2' THEN// CERRADA
//		Messagebox('Aviso','Orden de Trabajo esta Cerrada')
//		RETURN
//	END IF	
//
//	//estado de la operacion
//	ld_cant_real = idw_det_op.object.cant_real [ll_row]
//	IF ld_cant_real > 0 THEN
//		MessageBox('Aviso','Operación tiene parte diario, verifique!')
//		Return
//	END IF
//	
//	ls_flag_estado = idw_det_op.object.flag_estado [ll_row]
//	IF ls_flag_estado = '2' THEN
//		Messagebox('Aviso','Operacion ya se Encuentra Cerrada ')
//		RETURN
//	ELSEIF ls_flag_estado = '0' THEN
//		Messagebox('Aviso','Operacion Ha Sido Anulada')
//		RETURN
//	END IF
//	
//	idw_det_op.object.flag_estado [ll_row] = '2' //cerrar operacion
//	
//	//CERRAR ARTICULOS
//	For ll_inicio = 1 TO idw_det_art.Rowcount()
//		 idw_det_art.object.flag_estado [ll_inicio] = '2'
//	Next	
//
//	idw_det_op.ii_update  = 1
//	idw_det_art.ii_update = 1
//END IF
end event

event constructor;call super::constructor;
is_mastdet = 'md'		  // 'm' = master sin detalle (default), 'd' =  detalle,
                    	  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
							   
ii_ck[1] = 21		     // columnas de lectrua de este dw
ii_dk[1] = 21          // columnas que se pasan al detalle

idw_det = dw_det_art   // dw_detail

end event

event doubleclicked;call super::doubleclicked;//IF Getrow() = 0 THEN Return
//String   ls_name, ls_prot, ls_flag_uso, ls_cod_labor, ls_ot_adm, &
//		   ls_cod_ejecutor, ls_flag_facturacion, ls_tercero, ls_flag_estado,&
//			ls_sub_cat, ls_cencos, ls_desc_cencos, ls_cencos_ant, ls_opersec_f	
//str_seleccionar lstr_seleccionar
//Long     ll_count, ln_count_f
//Integer  ll_i
//Datetime ldt_fec_inicio
//Decimal{4} ld_costo_unitario
//Datawindow ldw
//
//ls_name = dwo.name
//ls_prot = this.Describe( ls_name + ".Protect")
//
//if ls_prot = '1' then    //protegido 
//	return
//end if
//
//ls_opersec_f = trim(this.object.oper_sec [row])
//
//ls_flag_estado = '1'
//
//CHOOSE CASE dwo.name
//		 CASE 'cod_labor'
//				
//				ls_ot_adm = dw_master.object.ot_adm[dw_master.getRow()]
//				
//				IF dw_det_art.rowcount() > 0 THEN
//					Messagebox('Aviso','No puede Cambiar Codigo de Labor tiene Articulo , Verifique!')
//					RETURN 
//				END IF
//				
//				lstr_seleccionar.s_sql = "SELECT COD_LABOR AS CODIGO, "&   
//										      +"DESC_LABOR AS DESCRIPCION, "&
//												+"UND AS UNIDAD "&
//												+"FROM VW_OPE_LABOR_X_OT_ADM "&
//												+"WHERE OT_ADM = '" + ls_ot_adm + "'"				
//
//										  
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					ls_cod_labor = lstr_seleccionar.param1[1]
//					Setitem(row,'cod_labor',lstr_seleccionar.param1[1])
//					Setitem(row,'desc_operacion',lstr_seleccionar.param2[1])
//					Setitem(row,'labor_und',lstr_seleccionar.param3[1])
//					Setitem(row,'labor_und_1',lstr_seleccionar.param3[1])
//					
//					/*Recupero Ejecutor*/
//					SELECT Count(*)
//					  INTO :ll_count
//					  FROM labor_ejecutor
//					 WHERE (cod_labor = :ls_cod_labor) ;
//					
//					IF ll_count > 0 THEN
//						SELECT MIN(cod_ejecutor)
//					     INTO :ls_cod_ejecutor
//					     FROM labor_ejecutor
//					    WHERE (cod_labor = :ls_cod_labor) ;
//						 
//						This.object.cod_ejecutor [row] = ls_cod_ejecutor
//						
//					   /* Asignando costo unitario */
//					   SELECT NVL(costo_unitario,0)
//				        INTO :ld_costo_unitario
//				        FROM labor_ejecutor le
//				       WHERE ((le.cod_labor    = :ls_cod_labor ) AND
//				            (le.cod_ejecutor = :ls_cod_ejecutor  )) ;
//				      
//				      This.object.costo_unit [row] = ld_costo_unitario
//					   					   
//					 	SELECT ejecutor_3ro INTO :ls_tercero FROM prod_param WHERE reckey='1' ;
//						// Asignando flag de facturacion
//						IF is_accion = 'new' THEN
//							IF ls_cod_ejecutor <> ls_tercero THEN
//						  		Setitem(row,'flag_facturacion', 'F')
//						  	ELSE
//						  		Setitem(row,'flag_facturacion', 'N')
//						   END IF
//						END IF
//					END IF
//					ii_update = 1
//				END IF
//		CASE 'cod_ejecutor'
//			  
//			   ls_cod_labor = this.object.cod_labor [row]
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT LABOR_EJECUTOR.COD_EJECUTOR AS COD_EJECUTOR ,'&
//														 +'LABOR_EJECUTOR.COD_LABOR    AS COD_LABOR     '&
//														 +'FROM LABOR_EJECUTOR ' &
//														 +'WHERE LABOR_EJECUTOR.COD_LABOR = '+"'"+ls_cod_labor+"'"
//										  
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'cod_ejecutor',lstr_seleccionar.param1[1])
//					ls_cod_ejecutor = lstr_seleccionar.param1[1]
//
//					// Asignando costo unitario
//					SELECT NVL(costo_unitario,0)
//				     INTO :ld_costo_unitario
//				     FROM labor_ejecutor le
//				    WHERE ((le.cod_labor    = :ls_cod_labor ) AND
//				           (le.cod_ejecutor = :ls_cod_ejecutor)) ;
//				
//				   This.object.costo_unit [row] = ld_costo_unitario
//				
//					ii_update = 1
//				END IF
//		CASE 'proveedor'
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO, '&
//														 +'PROVEEDOR.NOM_PROVEEDOR AS RAZON_SOCIAL '&
//														 +'FROM PROVEEDOR ' 
//										  
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'proveedor',lstr_seleccionar.param1[1])
//					ii_update = 1
//					
//					// Colocando flag de facturable
//					ls_flag_facturacion = this.object.flag_facturacion [row]
//					IF isnull(ls_flag_facturacion) THEN
//						ls_cod_ejecutor = this.object.cod_ejecutor [row]
//						SELECT ejecutor_3ro into :ls_tercero FROM prod_param WHERE reckey='1' ;
//						IF ls_cod_ejecutor <> ls_tercero THEN
//							Setitem(row,'flag_facturacion', 'F')
//							this.ii_update = 1
//						END IF
//					END IF
//				END IF
//		CASE 'fec_inicio'
//				
//				ldw = this
//				f_call_calendar(ldw,dwo.name,dwo.coltype,row)
//				
//				//modifico si existe articulos a modificar
//				ldt_fec_inicio = This.object.fec_inicio [row]
//				//
////				wf_updt_art_finicio(ldt_fec_inicio)
//				this.ii_update = 1
//				
//				
//		CASE 'fec_fin' 
//				ldw = this
//				f_call_calendar(ldw,dwo.name,dwo.coltype,row)
//				this.ii_update = 1
//				
//		CASE 'operaciones_fec_inicio_est'
//				ldw = this
//				f_call_calendar(ldw,dwo.name,dwo.coltype,row)
//				this.ii_update = 1
//
//		CASE 'cencos'
//			
//			   if dw_det_art.GetRow() > 0 then
//		
//					Select count(p.flag_estado)
//				  	  into :ln_count_f
//				  	  from articulo_mov_proy p
//				 	 where p.flag_estado <> '3'
//				   	and p.oper_sec = :ls_opersec_f;
//				 
//				 	if ln_count_f = 0 then
//						
//    					lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&   
//										      +'CENTROS_COSTO.DESC_CENCOS AS DESC_CENCOS '&
//												+'FROM CENTROS_COSTO '&
//												+'WHERE CENTROS_COSTO.FLAG_ESTADO = '+"'"+ls_flag_estado+"'"
//										  
//						OpenWithParm(w_seleccionar,lstr_seleccionar)
//					
//						IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//						IF lstr_seleccionar.s_action = "aceptar" THEN
//							Setitem(row,'cencos',lstr_seleccionar.param1[1])
//							this.ii_update = 1
//						else 
//							Return
//						END IF
//						
//						ls_cencos = lstr_seleccionar.param1[1]
//	
//							Select c.desc_cencos
//							 into :ls_desc_cencos
//							 from centros_costo c
//							where c.cencos = :ls_cencos;
//				
//						For ll_i = 1 to dw_det_art.RowCount()
//							 ls_flag_estado = dw_det_art.object.flag_estado [ll_i]
//							 dw_det_art.object.cencos      [ll_i] = ls_cencos
//							 dw_det_art.object.desc_cencos [ll_i] = ls_desc_cencos
//						Next
//						
//					else
//						messagebox('Operaciones_OT', 'No puede cambiar el Cencos de la Operación')
//						Return 1
//					end if
//					
//				else
//					
//   				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&   
//										      +'CENTROS_COSTO.DESC_CENCOS AS DESC_CENCOS '&
//												+'FROM CENTROS_COSTO '&
//												+'WHERE CENTROS_COSTO.FLAG_ESTADO = '+"'"+ls_flag_estado+"'"
//										  
//					OpenWithParm(w_seleccionar,lstr_seleccionar)
//					
//					IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//					IF lstr_seleccionar.s_action = "aceptar" THEN
//						Setitem(row,'cencos',lstr_seleccionar.param1[1])
//						this.ii_update = 1
//					else 
//						Return
//					END IF
//				END IF
//						
//		CASE 'servicio'
//				//BUSCAR SUB CATEGORIA DE LABOR
//				ls_cod_labor = this.object.cod_labor [row]
//				
//				
//				select Nvl(sub_cat_serv_3ro,' ') into :ls_sub_cat from labor where cod_labor = :ls_cod_labor and flag_estado = '1';
//			
//			
//			   lstr_seleccionar.s_sql = 'SELECT SERVICIOS.SERVICIO AS CODIGO ,  '&
//											  +'SERVICIOS.DESCRIPCION AS DESCRIPCION , '&
//											  +'SERVICIOS.COD_SUB_CAT AS SUB_CATEGORIA '&
//											  +'FROM SERVICIOS  '&   
//											  +'WHERE SERVICIOS.FLAG_ESTADO = '+"'"+'1'+"' AND "&
//											  +'      SERVICIOS.COD_SUB_CAT = '+"'"+ls_sub_cat +"'"
//			  
//
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'servicio',lstr_seleccionar.param1[1])
//					this.ii_update = 1
//				END IF
//
//END CHOOSE
//
//
end event

event itemchanged;call super::itemchanged;//DataWindowChild ldwc_labor
//String   ls_desc_labor, ls_und              , ls_filter, &
//		   ls_ejecutor  , ls_cod_labor        , ls_codigo, &
//			ls_tercero   , ls_flag_facturacion , ls_cliente, &
//			ls_sub_cat, ls_cencos, ls_data, ls_desc_cencos, ls_flag_estado, &
//			ls_opersec_f, ls_cencos_ante
//			
//Datetime ldt_fec_inicio
//Decimal{4}  ld_costo_unitario
//Integer  li_registros, ll_i
//Long		ll_count, ln_count_f
//
//this.accepttext()
//
//ls_opersec_f = trim(this.object.oper_sec [row])
//
//CHOOSE CASE dwo.name
//		 CASE 'fec_inicio'
//				
//				//modifico si existe articulos a modificar
//				ldt_fec_inicio = This.object.fec_inicio [row]
////				wf_updt_art_finicio(ldt_fec_inicio)
//				This.object.fec_inicio_est [row] = ldt_fec_inicio
//				
//		 CASE 'cod_ejecutor'
//			   ls_cod_labor = This.object.cod_labor [row]
//				
//				SELECT NVL(costo_unitario,0)
//				  INTO :ld_costo_unitario
//				  FROM labor_ejecutor le
//				 WHERE ((le.cod_labor    = :ls_cod_labor ) AND
//				        (le.cod_ejecutor = :data         )) ;
//								 
//				IF sqlca.SQLCode = 100 THEN
//					SetNull(ls_codigo)
//					Messagebox('AViso','Ejecutor no existe para esta Labor , Verifique')
//					This.object.cod_ejecutor [row] = ls_codigo
//					Return 1
//				END IF
//				
//				This.object.costo_unit [row] = ld_costo_unitario
//						  
//				
//				ls_cliente = This.object.proveedor[row]
//
//				IF isnull(ls_cliente) then
//					Setitem(row,'flag_facturacion', 'N')
//				ELSE
//					SELECT ejecutor_3ro 
//						INTO :ls_tercero 
//					FROM prod_param 
//					WHERE reckey='1' ;
//					// Asignando flag de facturacion
//					ls_ejecutor = This.object.cod_ejecutor[row]
//					IF is_accion = 'new' THEN
//						IF ls_ejecutor <> ls_tercero THEN
//							Setitem(row,'flag_facturacion', 'F')
//						ELSE
//							Setitem(row,'flag_facturacion', 'N')
//						END IF
//					END IF
//	   		END IF
//				
//		 CASE 'cod_labor'
//				ls_cod_labor = String(This.object.cod_labor [row])
//
//				IF dw_det_art.rowcount() > 0 THEN
//					This.object.cod_labor [row] = ls_cod_labor
//					Messagebox('Aviso','No puede Cambiar Codigo de Labor tiene Articulo , Verifique!')
//					RETURN 1	
//				END IF
//
//				SELECT desc_labor,und
//   				  INTO :ls_desc_labor,:ls_und
//				  FROM labor 
//				 WHERE (cod_labor =  :data )
//				   and flag_estado = '1';
//				 
//				IF SQLCA.SQLCode = 0 then
//					
//					This.object.desc_operacion [row] = ls_desc_labor
//					This.object.labor_und	   [row] = ls_und
//					This.object.labor_und_1 	[row] = ls_und
//					
//					/*Busco Ejecutor*/
//					// Capturando el ejecutor
//					SELECT min(cod_ejecutor)
//					  INTO :ls_ejecutor
//					  FROM labor_ejecutor
//					 WHERE (cod_labor = :data) 
//						and flag_estado = '1';	
//				 		 
//	  			   IF SQLCA.SQLCode = 0 THEN
//					
//		  			   This.object.cod_ejecutor [row] = ls_ejecutor
//						SELECT ejecutor_3ro 
//							INTO :ls_tercero 
//						FROM prod_param 
//						WHERE reckey='1' ;
//						// Asignando flag de facturacion
//						IF is_accion = 'new' THEN
//							IF ls_ejecutor <> ls_tercero THEN
//						  		Setitem(row,'flag_facturacion', 'F')
//						  	ELSE
//						  		Setitem(row,'flag_facturacion', 'N')
//						   END IF
//						END IF
//					ELSE
//						SetNull(ls_ejecutor)
//						This.object.cod_ejecutor [row] = ls_ejecutor	
//	   		   END IF
//					
//				ELSE
//					messagebox('Aviso', 'Dato ingresado no existe o no esta activo')
//					SetNull(ls_codigo)
//					this.object.cod_labor      [row] = ls_codigo
//					this.object.cod_ejecutor   [row] = ls_codigo
//					this.object.desc_operacion [row] = ls_codigo
//					This.object.labor_und	   [row] = ls_codigo
//					This.object.labor_und_1 	[row] = ls_codigo
//					
//					RETURN 1
//				END IF
//
//		CASE 'proveedor'
//				SELECT Count(*) 
//				  INTO :ll_count
//				  FROM proveedor
//				 WHERE (proveedor = :data );
//
//				IF ll_count > 0 then
//					// Asignando flag de facturacion
//					SELECT ejecutor_3ro INTO :ls_tercero FROM prod_param WHERE reckey='1' ;
//					ls_ejecutor = This.object.cod_ejecutor[row]
//					IF is_accion = 'new' THEN
//						IF ls_ejecutor <> ls_tercero THEN
//							Setitem(row,'flag_facturacion', 'F')
//						ELSE
//							Setitem(row,'flag_facturacion', 'N')
//						END IF
//					END IF
//				ELSE
//					 SetNull(ls_codigo)
//					 This.object.proveedor [row] = ls_codigo
//	   		END IF
//				
//		 CASE 'servicio'
//				ls_cod_labor = this.object.cod_labor [row]
//				
//				select sub_cat_serv_3ro
//					into :ls_sub_cat 
//				from labor 
//				where cod_labor = :ls_cod_labor 
//				  and flag_estado = '1';
//				
//				if SQLCA.SQLCode = 100 then
//					SetNull(ls_cod_labor)
//					this.object.servicio [row] = ls_cod_labor
//					Messagebox('Aviso','Este Servicio no esta activo o no existe, Verifique!')
//					return 1
//				end if
//				
//				if IsNull(ls_sub_cat) or ls_sub_cat = '' then
//					SetNull(ls_cod_labor)
//					this.object.servicio [row] = ls_cod_labor
//					Messagebox('Aviso','Este servicio no tiene enlazado una subcategoria de servicios, Verifique!')
//					return 1
//				end if
//
//				SELECT Count(*)
//				  INTO :ll_count
//				  FROM servicios
//				 WHERE (servicio    = :data      ) and
//				 		 (flag_estado = '1'        ) and
//						 (cod_sub_cat = :ls_sub_cat );
//			  
//			   
//				IF ll_count = 0 THEN
//					Messagebox('Aviso','Servicio No Existe, no esta activo o no pertenece a la subcategoria de servicios especificada en la labor ,Verifique!')
//					SetNull(ls_cod_labor)
//					this.object.servicio [row] = ls_cod_labor
//					Return 1
//				END IF
//
//			case "cencos"
//
//				ls_cencos = this.object.cencos[row]
//				   
//					Select c.desc_cencos
//					  into :ls_desc_cencos
//					  from centros_costo c
//					 where c.cencos = :ls_cencos;
//					 
//				IF sqlca.SQLCode = 100 THEN
//					SetNull(ls_codigo)
//					Messagebox('Aviso','Cencos no existe o no esta activo, Verifique')
//					This.object.cencos [row] = ''
//					Return 1
//				END IF
//				
//				 if dw_det_art.GetRow() > 0 then
//		
//					Select count(p.flag_estado)
//				  	  into :ln_count_f
//				  	  from articulo_mov_proy p
//				 	 where p.flag_estado <> '3'
//				   	and p.oper_sec = :ls_opersec_f;
//						
//				 	if ln_count_f = 0 then
//						
//	 					For ll_i = 1 to dw_det_art.RowCount()
//							 ls_flag_estado = dw_det_art.object.flag_estado [ll_i]
//							 dw_det_art.object.cencos      [ll_i] = ls_cencos
//							 dw_det_art.object.desc_cencos [ll_i] = ls_desc_cencos
//						Next
//					
//					else
//						
//						messagebox('Operaciones_OT', 'No puede cambiar el Cencos de la Operación')
//						Return 1
//					end if
//					
//				end if
//END CHOOSE		
//
end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;tab_1.tabpage_2.dw_lista_op.Setrow(currentrow)
tab_1.tabpage_2.dw_lista_op.ScrollToRow(currentrow)
end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)


end event

type dw_lista_op from u_dw_abc within tabpage_2
integer width = 1143
integer height = 1204
integer taborder = 20
string dataobject = "d_abc_operaciones_ot_tbl"
end type

event clicked;call super::clicked;//idw_1.BorderStyle = StyleRaised!
//idw_1 = THIS
//idw_1.BorderStyle = StyleLowered!
//
This.SelectRow(0, False)
This.SelectRow(row, True)
This.SetRow(row)

IF row = 0 Then Return


This.Event ue_output(row)



end event

event constructor;call super::constructor;idw_det = dw_det_op

ii_ck[1] = 1		// columnas de lectrua de este dw
ii_dk[1] = 21     // columnas que se pasan al detalle

ii_ss = 1

end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col
String  ls_column , ls_report, ls_color,ls_data_type,ls_col_tipo
Long ll_row


li_col = tab_1.tabpage_2.dw_lista_op.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	ls_col_tipo = is_col+'.coltype' 
	ls_data_type = this.Describe(ls_col_tipo)
	is_data_type = Mid(ls_data_type,1,pos(ls_data_type,'(') - 1)

	//st_campo.text = "Buscar por :" + Trim(is_col)
//	dw_find.reset()
//	dw_find.InsertRow(0)
//	dw_find.SetFocus()
	This.SelectRow(0, False)
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)

idw_det_op.Setrow(currentrow)
idw_det_op.ScrollToRow(currentrow)
end event

event ue_output;call super::ue_output;string 	ls_nro_orden
Integer 	li_operacion

if al_row > 0 then
	THIS.EVENT ue_retrieve_det(al_row)
	
	idw_det.ScrollToRow(al_row)
	
	li_operacion = idw_lista_op.GetItemNumber( al_row, "nro_operacion" )
	ls_nro_orden = idw_lista_op.GetItemString( al_row, "nro_orden" )
	
	// Recuperando datos para los secuenciales
	//idw_oper_dep.Retrieve(ls_nro_orden, li_operacion)

	
	//Recuperando datos para los lanzamientos
//	idw_lanza_plant.Retrieve(ls_nro_orden)

end if


end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;String ls_oper_sec

ls_oper_sec = this.GetItemString(this.GetRow(),'oper_sec')

IF Isnull(ls_oper_sec) THEN
	idw_det_art.reset()
ELSE

	idw_det_art.retrieve(ls_oper_sec)
	idw_det_art.ii_protect = 0
	idw_det_art.of_protect()
END IF 

end event

type tabpage_3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 160
integer width = 3671
integer height = 1828
long backcolor = 79741120
string text = "Orden de Compras"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_compras dw_compras
end type

on tabpage_3.create
this.dw_compras=create dw_compras
this.Control[]={this.dw_compras}
end on

on tabpage_3.destroy
destroy(this.dw_compras)
end on

type dw_compras from u_dw_cns within tabpage_3
integer width = 3113
integer height = 1288
integer taborder = 20
string dataobject = "d_cns_ot_oc"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
// ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event doubleclicked;call super::doubleclicked;if row= 0 then return
str_parametros lstr_rep
w_rpt_preview lw_1

if lower(dwo.name) = 'nro_doc' then
	lstr_rep.dw1 = 'd_rpt_orden_compra_cab'
	lstr_rep.titulo = 'Previo de Orden de compra'
	lstr_rep.string1 = this.object.cod_origen[row]
	lstr_rep.string2 = this.object.nro_doc	  [row]
	
	OpenSheetWithParm(lw_1, lstr_rep, w_main, 0, Layered!)			
end if
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3671
integer height = 1828
long backcolor = 79741120
string text = "Orden de Servicios"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_servicios dw_servicios
end type

on tabpage_4.create
this.dw_servicios=create dw_servicios
this.Control[]={this.dw_servicios}
end on

on tabpage_4.destroy
destroy(this.dw_servicios)
end on

type dw_servicios from u_dw_cns within tabpage_4
integer width = 3141
integer height = 1408
integer taborder = 20
string dataobject = "d_cns_orden_tra_ordserv"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event doubleclicked;call super::doubleclicked;if row= 0 then return
str_parametros lstr_rep
w_rpt_preview lw_1

if lower(dwo.name) = 'nro_os' then
	lstr_rep.dw1 = 'd_rpt_orden_servicio'
	
	lstr_rep.titulo = 'Previo de Orden de Servicio'
	lstr_rep.string1 = this.object.cod_origen[row]
	lstr_rep.string2 = this.object.nro_os	  [row]
	
	OpenSheetWithParm(lw_1, lstr_rep, w_main, 0, Layered!)			
end if
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3671
integer height = 1828
long backcolor = 79741120
string text = "Pendientes por Retirar"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_art_pendientes dw_art_pendientes
end type

on tabpage_5.create
this.dw_art_pendientes=create dw_art_pendientes
this.Control[]={this.dw_art_pendientes}
end on

on tabpage_5.destroy
destroy(this.dw_art_pendientes)
end on

type dw_art_pendientes from u_dw_cns within tabpage_5
integer width = 3127
integer height = 1248
integer taborder = 20
string dataobject = "d_cns_pend_articulo_ot"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type tabpage_9 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3671
integer height = 1828
long backcolor = 79741120
string text = "Pendientes de Compra"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_pend_compra dw_pend_compra
end type

on tabpage_9.create
this.dw_pend_compra=create dw_pend_compra
this.Control[]={this.dw_pend_compra}
end on

on tabpage_9.destroy
destroy(this.dw_pend_compra)
end on

type dw_pend_compra from u_dw_cns within tabpage_9
integer width = 3127
integer height = 1248
string dataobject = "d_cns_pend_compra_ot"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3671
integer height = 1828
long backcolor = 79741120
string text = "Consumos de Almacen"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_consumo_int dw_consumo_int
end type

on tabpage_6.create
this.dw_consumo_int=create dw_consumo_int
this.Control[]={this.dw_consumo_int}
end on

on tabpage_6.destroy
destroy(this.dw_consumo_int)
end on

type dw_consumo_int from u_dw_cns within tabpage_6
integer width = 3127
integer height = 1248
string dataobject = "d_cns_consumo_almacen_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3671
integer height = 1828
long backcolor = 79741120
string text = "Gatos Directos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_gd dw_gd
end type

on tabpage_7.create
this.dw_gd=create dw_gd
this.Control[]={this.dw_gd}
end on

on tabpage_7.destroy
destroy(this.dw_gd)
end on

type dw_gd from u_dw_cns within tabpage_7
integer width = 3127
integer height = 1248
string dataobject = "d_cns_gastos_directos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3671
integer height = 1828
long backcolor = 79741120
string text = "Ingresos~r~npor Produccion"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_ingresos dw_ingresos
end type

on tabpage_8.create
this.dw_ingresos=create dw_ingresos
this.Control[]={this.dw_ingresos}
end on

on tabpage_8.destroy
destroy(this.dw_ingresos)
end on

type dw_ingresos from u_dw_cns within tabpage_8
integer width = 3127
integer height = 1248
string dataobject = "d_cns_ingresos_almacen_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type tabpage_10 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 160
integer width = 3671
integer height = 1828
long backcolor = 79741120
string text = "Detalle de~r~nPersonal Destajero"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_destajero dw_destajero
end type

on tabpage_10.create
this.dw_destajero=create dw_destajero
this.Control[]={this.dw_destajero}
end on

on tabpage_10.destroy
destroy(this.dw_destajero)
end on

type dw_destajero from u_dw_cns within tabpage_10
integer width = 3127
integer height = 1248
string dataobject = "d_cns_personal_destajero_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type tabpage_11 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3671
integer height = 1828
long backcolor = 79741120
string text = "Detalle de~r~nPersonal Jornalero"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_jornaleros dw_jornaleros
end type

on tabpage_11.create
this.dw_jornaleros=create dw_jornaleros
this.Control[]={this.dw_jornaleros}
end on

on tabpage_11.destroy
destroy(this.dw_jornaleros)
end on

type dw_jornaleros from u_dw_cns within tabpage_11
integer width = 3127
integer height = 1248
string dataobject = "d_cns_personal_jornalero_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type cb_1 from commandbutton within w_ope501_orden_trabajo
integer x = 1097
integer y = 32
integer width = 283
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String ls_cod

ls_cod = sle_nro_ot.text

of_retrieve( ls_cod )
end event

type sle_nro_ot from u_sle_codigo within w_ope501_orden_trabajo
integer x = 571
integer y = 28
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 700
long backcolor = 16777215
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

