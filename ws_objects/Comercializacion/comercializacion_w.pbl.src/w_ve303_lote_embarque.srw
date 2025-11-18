$PBExportHeader$w_ve303_lote_embarque.srw
forward
global type w_ve303_lote_embarque from w_abc_master
end type
type sle_gs_origen from singlelineedit within w_ve303_lote_embarque
end type
type st_nro from statictext within w_ve303_lote_embarque
end type
type sle_nro from singlelineedit within w_ve303_lote_embarque
end type
type cb_1 from commandbutton within w_ve303_lote_embarque
end type
end forward

global type w_ve303_lote_embarque from w_abc_master
integer width = 2834
integer height = 2076
string title = "LOTE DE EMBARQUE (VE303)"
string menuname = "m_mtto_lista"
boolean controlmenu = false
sle_gs_origen sle_gs_origen
st_nro st_nro
sle_nro sle_nro
cb_1 cb_1
end type
global w_ve303_lote_embarque w_ve303_lote_embarque

type variables

end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro_lote)
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_next_nro, ls_lock_table, ls_mensaje

	IF dw_master.getrow() = 0 THEN RETURN 0
	
	IF is_action = 'new' THEN
		SELECT count(*)
			INTO :ll_count
		FROM num_lote_embarque
		WHERE origen = :gs_origen;
		
		IF ll_count = 0 THEN
			ls_lock_table = 'LOCK TABLE num_lote_embarque IN EXCLUSIVE MODE'
			EXECUTE IMMEDIATE :ls_lock_table ;
			
			IF SQLCA.SQLCode < 0 THEN
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', ls_mensaje)
				return 0
			END IF
			
			INSERT INTO num_lote_embarque(origen, ult_nro)
			VALUES( :gs_origen, 1);
			
			IF SQLCA.SQLCode < 0 THEN
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', ls_mensaje)
				return 0
			END IF
		END IF
		
		SELECT ult_nro
		  INTO :ll_ult_nro
		FROM num_lote_embarque
		WHERE origen = :gs_origen FOR UPDATE;
		
		UPDATE num_lote_embarque
			SET ult_nro = ult_nro + 1
		WHERE origen = :gs_origen;
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN 0
		END IF
		
		ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
		
		dw_master.object.nro_lote[dw_master.getrow()] = ls_next_nro
		dw_master.ii_update = 1
	ELSE
		//ls_next_nro = dw_master.object.nro_ov[dw_master.getrow()] 
	END IF

RETURN 1
end function

public subroutine of_retrieve (string as_nro_lote);dw_master.retrieve( as_nro_lote )

//dw_master.ii_protect = 0
//dw_master.of_protect( )
//dw_master.ii_update = 0

is_Action = 'open'

end subroutine

on w_ve303_lote_embarque.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_lista" then this.MenuID = create m_mtto_lista
this.sle_gs_origen=create sle_gs_origen
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_gs_origen
this.Control[iCurrent+2]=this.st_nro
this.Control[iCurrent+3]=this.sle_nro
this.Control[iCurrent+4]=this.cb_1
end on

on w_ve303_lote_embarque.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_gs_origen)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_1)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

if f_row_processing( dw_master, 'form') = false then return

//Para la replicacion de datos
dw_master.of_set_flag_replicacion()


// Genera el numero del embarque
if of_set_numera() = 0 then return


// Si todo ha salido bien cambio el indicador ib_update_check a true, 
//para indicarle al evento ue_update que todo ha salido bien

ib_update_check = true
end event

event ue_update;// Ancestor Script has been Override

Boolean lbo_ok = TRUE
string	ls_nro_lote

dw_master.AcceptText()

if dw_master.GetRow() = 0 then return

ib_update_check = TRUE
THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master", &
		           "Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	ls_nro_lote = dw_master.object.nro_lote[dw_master.GetRow()]
	of_retrieve(ls_nro_lote)
	
	dw_master.ii_update  = 0
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
	is_action = 'open'
	
END IF


end event

event ue_list_open;call super::ue_list_open;// Asigna valores a structura 

str_parametros sl_param

sl_param.dw1    = 'd_ve_lista_lote_embarque_tbl'
sl_param.titulo = 'LOTES DE EMBARQUES'
sl_param.field_ret_i[1] = 1	//Nro lote de Embarque

OpenWithParm( w_lista, sl_param )


sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_cancelar;call super::ue_cancelar;EVENT ue_update_request()   // Verifica actualizaciones pendientes

dw_master.Reset()
dw_master.ii_update = 0

is_Action = 'open'




end event

event ue_anular;call super::ue_anular;Long ll_row
if dw_master.GetRow() = 0 then return 

if dw_master.object.flag_estado[dw_master.GetRow()] = '0' then
	MessageBox('Aviso', 'Este Lote de Embarque ya esta anulado, no puedes anularlo')
	return
end if

dw_master.object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1

//is_action = 'anular'
end event

type dw_master from w_abc_master`dw_master within w_ve303_lote_embarque
event ue_display ( string as_columna,  long al_row )
integer x = 18
integer y = 144
integer width = 2757
integer height = 1724
string dataobject = "d_ve_lote_embarque_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_ruc, ls_nro_embarque
//long 		ll_count


CHOOSE CASE upper(as_columna)
	
	CASE "NRO_EMBARQUE"
		ls_sql = "SELECT NRO_EMBARQUE AS NUMERO_EMBARQUE, " 		 &
			 		+ "NRO_OV AS NUMERO_OV " &
			  		+ "FROM EMBARQUE " 						 &
			  		+ "where flag_estado = '1'"
			 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
		IF ls_codigo <> '' THEN
			This.object.NRO_EMBARQUE		[al_row] = ls_codigo
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

	CASE "CONSIGNATARIO"
		ls_sql = "SELECT proveedor AS codigo, " 		 &
			 		+ "nom_proveedor AS nom_proveedor, " &
				  	+ "RUC as RUC_proveedor " 				 &
			  		+ "FROM proveedor " 						 &
			  		+ "where flag_estado = '1'"
			 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')
	
		IF ls_codigo <> '' THEN
			This.object.consignatario		[al_row] = ls_codigo
			This.object.nom_consignatario [al_row] = ls_data						
		END IF
		This.ii_update = 1
		
	CASE "COD_ART"
		ls_nro_embarque = this.object.nro_embarque[al_row]
		
		ls_sql = "SELECT DISTINCT A.COD_ART AS CODIGO, " &
			    + "A.NOM_ARTICULO AS DESCRIPCION " 		 &
				 + "FROM ARTICULO A, " 							 &
				 + "ORDEN_VENTA OV, " 						 &
				 + "ARTICULO_MOV_PROY AMP, " &
				 + "EMBARQUE E " 						 &
				 + "WHERE OV.NRO_OV = E.NRO_OV " &
				 + "AND AMP.COD_ART = A.COD_ART " &
				 + "AND AMP.TIPO_DOC = 'OV' " &
				 + "AND A.FLAG_ESTADO = '1' " &
				 + "AND E.NRO_EMBARQUE = '" + ls_nro_embarque + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_art		[al_row] = ls_codigo
			This.object.nom_articulo[al_row] = ls_data
		END IF
		This.ii_update = 1

	CASE "DOC_COBR_BANCO"
		ls_sql = "SELECT COD_BANCO AS CODIGO, " &
			    + "NOM_BANCO AS DESCRIPCION " 	 &
				 + "FROM BANCO " 						 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.doc_cobr_banco	[al_row] = ls_codigo
			This.object.nom_banco		[al_row] = ls_data
		END IF
		This.ii_update = 1

	CASE "DOC_COBR_TIPO"
		ls_sql = "SELECT TIPO_DOC AS CODIGO, " 	&
			    + "DESC_TIPO_DOC AS DESCRIPCION " 	&
				 + "FROM DOC_TIPO " 						
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.doc_cobr_tipo[al_row] = ls_codigo
			This.object.desc_tipo_doc[al_row] = ls_data
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

event dw_master::itemchanged;call super::itemchanged;string ls_flag, ls_data, ls_codigo, ls_prov, ls_null

SetNull(ls_null)
THIS.AcceptText()

IF row = 0 then
	RETURN
END IF

CHOOSE CASE upper(dwo.name)
		
	CASE "NRO_EMBARQUE"
		SELECT nro_embarque
			INTO :ls_data
		FROM Embarque
		WHERE nro_embarque = :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'EL EMBARQUE NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.nro_embarque[row] = ls_null
			RETURN 1
		END IF
		
	CASE "ASEGURADOR"
		SELECT nom_proveedor
			INTO :ls_data
		FROM proveedor
		WHERE flag_estado = '1'
		  AND proveedor 	= :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'El Asegurador no existe o no esta activo, Verifique', StopSign!)
			THIS.object.asegurador		[row] = ls_null
			THIS.object.nom_asegurador	[row] = ls_null
			RETURN 1
		END IF
		
		THIS.object.nom_asegurador[row] = ls_data

	CASE "CONSIGNATARIO"
		SELECT nom_proveedor
			INTO :ls_data
		FROM proveedor
		WHERE flag_estado = '1'
		  AND proveedor 	= :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'El Consignatario no existe o no esta activo, Verifique', StopSign!)
			THIS.object.consignatario		[row] = ls_null
			THIS.object.nom_consignatario	[row] = ls_null
			RETURN 1
		END IF
		
		THIS.object.nom_consignatario[row] = ls_data

	CASE "COD_ART"
		SELECT a.nom_articulo
			INTO :ls_data
		FROM articulo 			a,
		     articulo_venta  av
		WHERE a.cod_art = :data
		  AND a.cod_art = av.cod_art
		  AND  flag_estado = '1';
		  
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Articulo no existe o no esta activo, Verifique", StopSign!)
			this.object.cod_art		[row] = ls_Null
			this.object.nom_articulo[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.nom_articulo[row] = ls_data
	
	CASE "DOC_COBR_BANCO"
		SELECT nom_banco
			INTO :ls_data
		FROM	Banco
		WHERE cod_banco = :data;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Banco no existe o no esta activo, Verifique", StopSign!)
			this.object.doc_cobr_banco	[row] = ls_Null
			this.object.nom_banco		[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.nom_banco[row] = ls_data
		
	CASE "DOC_COBR_TIPO"
		SELECT desc_tipo_doc
			INTO :ls_data
		FROM	doc_tipo
		WHERE tipo_doc 	= :data;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Tipo de Documento no existe o no esta activo, Verifique", StopSign!)
			this.object.doc_cobr_tipo[row] = ls_Null
			this.object.desc_tipo_doc[row] = ls_Null
			RETURN 1
		END IF
		
		THIS.object.desc_tipo_doc[row] = ls_data
		
END CHOOSE
end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;is_action = 'new'

This.object.lote_embarque_cod_usr[al_row] = gs_user
end event

type sle_gs_origen from singlelineedit within w_ve303_lote_embarque
integer x = 407
integer y = 24
integer width = 114
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
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;cb_1.event clicked()
end event

type st_nro from statictext within w_ve303_lote_embarque
integer x = 110
integer y = 36
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
string text = "Numero:"
boolean focusrectangle = false
end type

type sle_nro from singlelineedit within w_ve303_lote_embarque
integer x = 571
integer y = 24
integer width = 512
integer height = 92
integer taborder = 20
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

event modified;cb_1.event clicked()
end event

type cb_1 from commandbutton within w_ve303_lote_embarque
integer x = 1106
integer y = 20
integer width = 402
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;string ls_cod_origen, ls_nro

EVENT ue_update_request()   // Verifica actualizaciones pendientes

ls_nro = Trim(sle_nro.text)

// Para comprobar que solo ingresa un numero sin codigo de origen

IF Len(ls_nro) <= 8 THEN
	ls_nro = trim(gs_origen) + string(integer(ls_nro), '00000000')
END IF

sle_nro.text = ls_nro
of_retrieve(ls_nro)

end event

