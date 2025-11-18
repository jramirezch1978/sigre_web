$PBExportHeader$w_ve304_lote_emb_inspec.srw
forward
global type w_ve304_lote_emb_inspec from w_abc_master
end type
type dw_detail from u_dw_abc within w_ve304_lote_emb_inspec
end type
type sle_gs_origen from singlelineedit within w_ve304_lote_emb_inspec
end type
type st_nro from statictext within w_ve304_lote_emb_inspec
end type
type sle_nro from singlelineedit within w_ve304_lote_emb_inspec
end type
type cb_1 from commandbutton within w_ve304_lote_emb_inspec
end type
end forward

global type w_ve304_lote_emb_inspec from w_abc_master
integer width = 2798
integer height = 1916
string title = "Inspección de Embarque (VE304)"
string menuname = "m_mtto_lista"
boolean controlmenu = false
dw_detail dw_detail
sle_gs_origen sle_gs_origen
st_nro st_nro
sle_nro sle_nro
cb_1 cb_1
end type
global w_ve304_lote_emb_inspec w_ve304_lote_emb_inspec

type variables

end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_str_parametros (string as_nro_inspeccion)
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_next_nro, ls_lock_table, ls_mensaje

	IF dw_master.getrow() = 0 THEN RETURN 0
	
	IF is_action = 'new' THEN
		SELECT count(*)
			INTO :ll_count
		FROM num_lote_emb_inspec
		WHERE origen = :gs_origen;
		
		IF ll_count = 0 THEN
			ls_lock_table = 'LOCK TABLE num_lote_emb_inspec IN EXCLUSIVE MODE'
			EXECUTE IMMEDIATE :ls_lock_table ;
			
			IF SQLCA.SQLCode < 0 THEN
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Aviso', ls_mensaje)
				return 0
			END IF
			
			INSERT INTO num_lote_emb_inspec(origen, ult_nro)
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
		FROM num_lote_emb_inspec
		WHERE origen = :gs_origen FOR UPDATE;
		
		UPDATE num_lote_emb_inspec
			SET ult_nro = ult_nro + 1
		WHERE origen = :gs_origen;
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN 0
		END IF
		
		ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
		
		dw_master.object.nro_inspeccion[dw_master.getrow()] = ls_next_nro
		dw_master.ii_update = 1
	ELSE
		//ls_next_nro = dw_master.object.nro_ov[dw_master.getrow()] 
	END IF

RETURN 1
end function

public subroutine of_retrieve(string as_nro_inspeccion);dw_master.retrieve( as_nro_inspeccion )
dw_detail.retrieve( as_nro_inspeccion )

dw_master.ii_protect = 0
dw_detail.ii_protect = 0

dw_master.of_protect( )
dw_detail.of_protect( )

dw_master.ii_update = 0
dw_detail.ii_update = 0

is_Action = 'open'




end subroutine

on w_ve304_lote_emb_inspec.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_lista" then this.MenuID = create m_mtto_lista
this.dw_detail=create dw_detail
this.sle_gs_origen=create sle_gs_origen
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.sle_gs_origen
this.Control[iCurrent+3]=this.st_nro
this.Control[iCurrent+4]=this.sle_nro
this.Control[iCurrent+5]=this.cb_1
end on

on w_ve304_lote_emb_inspec.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.sle_gs_origen)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_1)
end on

event resize;//Override

dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

end event

event ue_update_request;//Override

Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si 
// se quiere actualizar

IF dw_master.ii_update = 1 &
	or dw_detail.ii_update = 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", &
	                           "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF
end event

event ue_open_pre;call super::ue_open_pre;dw_detail.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos
dw_detail.ii_protect = 0
dw_detail.of_protect()         		// bloquear modificaciones 

//Datawindow por defecto
idw_1 = dw_master

sle_gs_origen.text = gs_origen

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

if f_row_processing( dw_master, 'form') = false then return

//Para la replicacion de datos
dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()


// Genera el numero del embarque
if of_set_numera() = 0 then return


// Si todo ha salido bien cambio el indicador ib_update_check a true, 
//para indicarle al evento ue_update que todo ha salido bien

ib_update_check = true

end event

event ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Detalle')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
	IF lbo_ok THEN
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	//idw_1.retrieve()
	dw_master.ii_update 	= 0
	dw_master.il_totdel 	= 0
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
	dw_detail.ii_update 	= 0
	dw_detail.il_totdel 	= 0
	dw_detail.ii_protect = 0
	dw_detail.of_protect( )
	
	is_action = 'open'
	
END IF


end event

event ue_list_open;call super::ue_list_open;// Asigna valores a structura 

str_parametros sl_param

sl_param.dw1    = 'd_ve_lista_lote_emb_inspec_tbl'
sl_param.titulo = 'INSPECCION DE EMBARQUE'
sl_param.field_ret_i[1] = 1	//Nro Inspeccion


OpenWithParm( w_lista, sl_param )


sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF
end event

type dw_master from w_abc_master`dw_master within w_ve304_lote_emb_inspec
event ue_display ( string as_columna,  long al_row )
integer x = 23
integer y = 148
integer width = 2683
integer height = 792
string dataobject = "d_ve_lote_emb_inspec_ff"
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_ruc
long 		ll_count

// as_columna,  al_row

CHOOSE CASE upper(as_columna)
		
	CASE "PROVEEDOR"
		ls_sql = "SELECT proveedor AS codigo, " 		 &
			 		+ "nom_proveedor AS nom_proveedor, " &
				  	+ "RUC as RUC_proveedor " 				 &
			  		+ "FROM proveedor " 						 &
			  		+ "where flag_estado = '1'"
			 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')
	
		IF ls_codigo <> '' THEN
			This.object.proveedor		[al_row] = ls_codigo
			This.object.nom_proveedor [al_row] = ls_data						
		END IF
		This.ii_update = 1
		
END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_det  =  dw_detail
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;is_action = 'new'

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
	
	CASE "NRO_LOTE"
		SELECT nro_lote
			INTO :ls_data
		FROM Lote_Embarque
		WHERE nro_lote = :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'EL LOTE DE EMBARQUE NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.nro_lote[row] = ls_null
			RETURN 1
		END IF
		
	CASE "PROVEEDOR"
		SELECT nom_proveedor
			INTO :ls_data
		FROM proveedor
		WHERE flag_estado = '1'
		  AND proveedor = :data;
		  
		IF SQLCA.SQLCode = 100 THEN
			MessageBox('Aviso', 'EL PROVEEDOR NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			THIS.object.proveedor		[row] = ls_null
			THIS.object.nom_proveedor	[row] = ls_null
			RETURN 1
		END IF
		
		THIS.object.nom_proveedor[row] = ls_data

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

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_detail from u_dw_abc within w_ve304_lote_emb_inspec
integer x = 18
integer y = 968
integer width = 2683
integer height = 736
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ve_lote_emb_analisis_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = 	dw_master

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event itemerror;call super::itemerror;RETURN 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;String ls_nro_insp

ls_nro_insp = dw_master.object.nro_inspeccion[dw_master.GetRow()]

this.object.nro_inspeccion 		[al_row] = ls_nro_insp
end event

type sle_gs_origen from singlelineedit within w_ve304_lote_emb_inspec
integer x = 352
integer y = 28
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

type st_nro from statictext within w_ve304_lote_emb_inspec
integer x = 55
integer y = 40
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

type sle_nro from singlelineedit within w_ve304_lote_emb_inspec
integer x = 517
integer y = 28
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

type cb_1 from commandbutton within w_ve304_lote_emb_inspec
integer x = 1051
integer y = 24
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

