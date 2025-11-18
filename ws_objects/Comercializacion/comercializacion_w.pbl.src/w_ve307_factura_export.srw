$PBExportHeader$w_ve307_factura_export.srw
forward
global type w_ve307_factura_export from w_abc_master
end type
type st_ori from statictext within w_ve307_factura_export
end type
type sle_ori from singlelineedit within w_ve307_factura_export
end type
type st_nro from statictext within w_ve307_factura_export
end type
type sle_nro from singlelineedit within w_ve307_factura_export
end type
type cb_buscar from commandbutton within w_ve307_factura_export
end type
end forward

global type w_ve307_factura_export from w_abc_master
integer width = 2478
integer height = 1948
string title = "FACTURA DE EXPORTACION (VE307)"
string menuname = "m_mtto_impresion"
st_ori st_ori
sle_ori sle_ori
st_nro st_nro
sle_nro sle_nro
cb_buscar cb_buscar
end type
global w_ve307_factura_export w_ve307_factura_export

forward prototypes
public subroutine of_retrieve (string as_tipo_doc, string as_nro_doc)
public subroutine of_retrieve (string as_tipo_doc)
end prototypes

public subroutine of_retrieve (string as_tipo_doc, string as_nro_doc);dw_master.retrieve( as_tipo_doc, as_nro_doc )
if dw_master.RowCount() = 0 then
	dw_master.event ue_insert()
	dw_master.object.tipo_doc [dw_master.GetRow()] = as_tipo_doc
	dw_master.object.nro_doc [dw_master.GetRow()]  = as_nro_doc
	
	dw_master.ii_protect = 1
	dw_master.of_protect( )
	dw_master.ii_update = 1
else	
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	dw_master.ii_update = 0
end if



end subroutine

public subroutine of_retrieve (string as_tipo_doc);
end subroutine

on w_ve307_factura_export.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_impresion" then this.MenuID = create m_mtto_impresion
this.st_ori=create st_ori
this.sle_ori=create sle_ori
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_buscar=create cb_buscar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_ori
this.Control[iCurrent+2]=this.sle_ori
this.Control[iCurrent+3]=this.st_nro
this.Control[iCurrent+4]=this.sle_nro
this.Control[iCurrent+5]=this.cb_buscar
end on

on w_ve307_factura_export.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_ori)
destroy(this.sle_ori)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_buscar)
end on

event ue_list_open;call super::ue_list_open;//override
// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_fact_exp_tbl'
sl_param.titulo = 'Factura de Exportacion'
sl_param.field_ret_i[1] = 1  //TIPO_DOC
sl_param.field_ret_i[2] = 2  //NRO_DOC

OpenWithParm(w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
   of_retrieve(sl_param.field_ret[1],sl_param.field_ret[2])
END IF
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'form') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
end event

event ue_print;// Override
String ls_tipo_doc, ls_nro_doc

if dw_master.GetRow() = 0 then return

ls_tipo_doc = dw_master.object.tipo_doc[dw_master.getrow()]
ls_nro_doc  = dw_master.object.nro_doc [dw_master.getrow()]

str_parametros lstr_rep	

lstr_rep.string1 = ls_tipo_doc
lstr_rep.string2 = ls_nro_doc
OpenSheetWithParm(w_ve307_factura_export_frm, lstr_rep, This, 2, layered!)

end event

type dw_master from w_abc_master`dw_master within w_ve307_factura_export
event ue_display ( string as_columna,  long al_row )
integer x = 5
integer y = 144
integer width = 2400
integer height = 1596
string dataobject = "d_ve_factura_exportacion_ff"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_ruc


CHOOSE CASE upper(as_columna)
	
	CASE "INCOTERM"
		ls_sql = "SELECT INCOTERM AS CODIGO, " &
			    + "DESCRIPCION AS DESCRIPCION " &
				 + "FROM INCOTERM " 					&
				 + "WHERE FLAG_ESTADO = '1' " 	

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.incoterm		 [al_row] = ls_codigo
			This.object.desc_incoterm[al_row] = ls_data
		END IF
		This.ii_update = 1
		
	CASE "PUERTO_VENTA"
		ls_sql = "SELECT PUERTO AS CODIGO, " 		&
			    + "DESCR_PUERTO AS DESCRIPCION " 	&
				 + "FROM FL_PUERTOS " 					&
				 + "WHERE FLAG_ESTADO = '1' " 			

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.puerto_venta		[al_row] = ls_codigo
			This.object.descr_puerto_venta[al_row] = ls_data
		END IF
		This.ii_update = 1

	CASE "FORMA_EMPAQUE"
		ls_sql = "SELECT FORMA_EMPAQUE AS CODIGO, " 	&
			    + "DESCRIPCION AS DESCRIPCION " 		&
				 + "FROM FORMA_EMPAQUE " 					&
				 + "WHERE FLAG_ESTADO = '1' " 		

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.forma_empaque 		[al_row] = ls_codigo
			This.object.desc_forma_empaque[al_row] = ls_data
		END IF
		This.ii_update = 1

	CASE "BANCO_COBRANZA"
		ls_sql = "SELECT COD_BANCO AS CODIGO, " &
			    + "NOM_BANCO AS DESCRIPCION " 	 &
				 + "FROM BANCO " 						 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.banco_cobranza		[al_row] = ls_codigo
			This.object.nom_banco_cobranza[al_row] = ls_data
		END IF
		This.ii_update = 1

	CASE "DOC_COBRANZA"
		ls_sql = "SELECT TIPO_DOC AS CODIGO, " 	&
			    + "DESC_TIPO_DOC AS DESCRIPCION " 	&
				 + "FROM DOC_TIPO " 						
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.doc_cobranza	[al_row] = ls_codigo
			This.object.desc_tipo_doc	[al_row] = ls_data
		END IF
		This.ii_update = 1

	CASE "ASEGURADOR"
		ls_sql = "SELECT proveedor AS codigo, " 		 &
			 		+ "nom_proveedor AS nom_proveedor, " &
				  	+ "RUC as RUC_proveedor " 				 &
			  		+ "FROM proveedor " 						 &
			  		+ "where flag_estado = '1'"
			 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')
	
		IF ls_codigo <> '' THEN
			This.object.asegurador		[al_row] = ls_codigo
			This.object.nom_asegurador [al_row] = ls_data						
		END IF
		This.ii_update = 1

	CASE "BANCO_ASEGURADOR"
		ls_sql = "SELECT COD_BANCO AS CODIGO, " &
			    + "NOM_BANCO AS DESCRIPCION " 	 &
				 + "FROM BANCO " 						 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.banco_asegurador		[al_row] = ls_codigo
			This.object.nom_banco_asegurador	[al_row] = ls_data
		END IF
		This.ii_update = 1
	
	CASE "PUERTO_ORIGEN"
		ls_sql = "SELECT PUERTO AS CODIGO, " 		&
			    + "DESCR_PUERTO AS DESCRIPCION " 	&
				 + "FROM FL_PUERTOS " 					&
				 + "WHERE FLAG_ESTADO = '1' " 			

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.puerto_origen			[al_row] = ls_codigo
			This.object.descr_puerto_origen	[al_row] = ls_data
		END IF
		This.ii_update = 1

	CASE "PUERTO_DESTINO"
		ls_sql = "SELECT PUERTO AS CODIGO, " 		&
			    + "DESCR_PUERTO AS DESCRIPCION " 	&
				 + "FROM FL_PUERTOS " 					&
				 + "WHERE FLAG_ESTADO = '1' " 			

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.puerto_destino			[al_row] = ls_codigo
			This.object.descr_puerto_destino	[al_row] = ls_data
		END IF
		This.ii_update = 1

END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF

end event

event dw_master::itemerror;call super::itemerror;RETURN 1

end event

event dw_master::itemchanged;call super::itemchanged;string ls_flag, ls_data, ls_codigo, ls_null

SetNull(ls_null)
THIS.AcceptText()

IF row = 0 then
	RETURN
END IF

CHOOSE CASE upper(dwo.name)
	
	CASE "INCOTERM"
		SELECT descripcion
			INTO :ls_data
		FROM Incoterm
		WHERE incoterm = :data
		  AND flag_estado = '1';
	
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de INCOTERM no existe", StopSign!)
			this.object.incoterm		 [row] = ls_Null
			this.object.desc_incoterm[row] = ls_Null
			RETURN 1
		END IF
		THIS.object.desc_incoterm[row] = ls_data

	CASE "PUERTO_VENTA"
		SELECT descr_puerto
			INTO :ls_data
		FROM fl_puertos
		WHERE puerto = :data
		  AND flag_estado = '1';
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Puerto no existe", StopSign!)
			this.object.puerto_venta		[row] = ls_Null
			this.object.descr_puerto_venta[row] = ls_Null
			RETURN 1
		END IF
		THIS.object.descr_puerto_venta[row] = ls_data

	
	CASE "FORMA_EMPAQUE"
		SELECT descripcion
			INTO :ls_data
		FROM forma_empaque
		WHERE forma_empaque = :data
		  AND flag_estado = '1';
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Forma de Empaque no existe", StopSign!)
			this.object.forma_empaque		[row] = ls_Null
			this.object.desc_forma_empaque[row] = ls_Null
			RETURN 1
		END IF
		THIS.object.desc_forma_empaque[row] = ls_data

	CASE "BANCO_COBRANZA"
		SELECT nom_banco
			INTO :ls_data
		FROM	Banco
		WHERE cod_banco = :data;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Banco no existe o no esta activo, Verifique", StopSign!)
			this.object.banco_cobranza		[row] = ls_Null
			this.object.nom_banco_cobranza[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.nom_banco_cobranza[row] = ls_data

	CASE "DOC_COBRANZA"
		SELECT desc_tipo_doc
			INTO :ls_data
		FROM	doc_tipo
		WHERE tipo_doc 	= :data;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Documento no existe o no esta activo, Verifique", StopSign!)
			this.object.doc_cobranza	[row] = ls_Null
			this.object.desc_tipo_doc	[row] = ls_Null
			RETURN 1
		END IF
		THIS.object.desc_tipo_doc[row] = ls_data
		
	CASE "ASEGURADOR"
		SELECT nom_proveedor
			INTO :ls_data
		FROM proveedor
		WHERE flag_estado = '1'
		  AND proveedor = :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'EL ASEGURADOR NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.asegurador		[row] = ls_null
			THIS.object.nom_asegurador	[row] = ls_null
			RETURN 1
		END IF
		THIS.object.nom_asegurador[row] = ls_data
		
	CASE "BANCO_ASEGURADOR"
		SELECT nom_banco
			INTO :ls_data
		FROM	Banco
		WHERE cod_banco = :data;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Banco no existe o no esta activo, Verifique", StopSign!)
			this.object.banco_asegurador	  [row] = ls_Null
			this.object.nom_banco_asegurador[row] = ls_Null
			RETURN 1
		END IF
		THIS.object.nom_banco_asegurador[row] = ls_data

	CASE "PUERTO_ORIGEN"
		SELECT descr_puerto
			INTO :ls_data
		FROM fl_puertos
		WHERE puerto = :data
		  AND flag_estado = '1';
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Puerto no existe", StopSign!)
			this.object.puerto_origen			[row] = ls_Null
			this.object.descr_puerto_origen	[row] = ls_Null
			RETURN 1
		END IF
		THIS.object.descr_puerto_origen[row] = ls_data

CASE "PUERTO_DESTINO"
		SELECT descr_puerto
			INTO :ls_data
		FROM fl_puertos
		WHERE puerto = :data
		  AND flag_estado = '1';
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Puerto no existe", StopSign!)
			this.object.puerto_destino			[row] = ls_Null
			this.object.descr_puerto_destino	[row] = ls_Null
			RETURN 1
		END IF
		THIS.object.descr_puerto_destino[row] = ls_data

END CHOOSE
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr[al_row] = gs_user


end event

type st_ori from statictext within w_ve307_factura_export
integer x = 64
integer y = 36
integer width = 288
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Doc:"
boolean focusrectangle = false
end type

type sle_ori from singlelineedit within w_ve307_factura_export
integer x = 352
integer y = 20
integer width = 229
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type st_nro from statictext within w_ve307_factura_export
integer x = 654
integer y = 32
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Doc:"
boolean focusrectangle = false
end type

type sle_nro from singlelineedit within w_ve307_factura_export
integer x = 969
integer y = 24
integer width = 512
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;cb_buscar.event clicked()
end event

type cb_buscar from commandbutton within w_ve307_factura_export
integer x = 1536
integer y = 20
integer width = 402
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;EVENT ue_update_request()   // Verifica actualizaciones pendientes
of_retrieve(sle_ori.text, sle_nro.text)
end event

