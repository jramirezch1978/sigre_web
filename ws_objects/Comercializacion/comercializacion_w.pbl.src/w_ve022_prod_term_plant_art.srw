$PBExportHeader$w_ve022_prod_term_plant_art.srw
forward
global type w_ve022_prod_term_plant_art from w_abc_mastdet_smpl
end type
type uo_search from n_cst_search within w_ve022_prod_term_plant_art
end type
end forward

global type w_ve022_prod_term_plant_art from w_abc_mastdet_smpl
integer width = 3502
integer height = 2628
string title = "[VE022] Amarre Plantilla / Articulos Prod Terminado"
string menuname = "m_mantenimiento_sl"
uo_search uo_search
end type
global w_ve022_prod_term_plant_art w_ve022_prod_term_plant_art

on w_ve022_prod_term_plant_art.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
end on

on w_ve022_prod_term_plant_art.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_search)
end on

event ue_insert;// Override Ancester
Long  ll_row

dw_detail.accepttext( )

CHOOSE CASE idw_1
	CASE dw_detail
		IF dw_master.GetRow() = 0 THEN
			MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
			RETURN
		END IF
		
	CASE ELSE
	  RETURN
	  
END CHOOSE

//insertar
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
END IF
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = FALSE

IF f_row_Processing( dw_detail, "tabular") <> TRUE THEN RETURN

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = TRUE

end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE

uo_search.of_set_dw(dw_master)
end event

event ue_update;//Ancester Override

Boolean lbo_ok = TRUE
String	ls_msg

dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_detail.of_create_log()
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_detail.of_save_log()
	end if
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_detail.ii_update = 0
	dw_detail.il_totdel = 0
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()

END IF
end event

event resize;call super::resize;uo_search.width  = newwidth  - uo_search.x - 10
uo_search.event ue_resize(newheight, uo_search.width, sizetype)
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ve022_prod_term_plant_art
integer x = 0
integer y = 88
integer width = 3154
integer height = 1112
string dataobject = "d_lista_prod_terminados_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ve022_prod_term_plant_art
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 1224
integer width = 3214
integer height = 852
string dataobject = "d_abc_plant_prod_articulo_tbl"
end type

event dw_detail::ue_display(string as_columna, long al_row);Boolean 	lb_ret
String 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate
			
ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)
	
	CASE 'cod_plantilla'
		ls_sql = "select pp.cod_plantilla as codigo_plant, " &
				  +"pp.desc_plantilla as Descripcion_plant, " &
				  +"pp.ot_adm as ot_adm " &
				  +"from plant_prod pp, " &
				  +"ot_adm_usuario a " &
				  +"where pp.ot_adm = a.ot_adm " &
				  +"and pp.flag_estado = '1' " &
				  +"and a.cod_usr = '" + gs_user + "'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_plantilla [al_row] = ls_codigo
			This.object.desc_plantilla[al_row] = ls_data
			This.ii_update = 1
		END IF
		
	CASE 'incoterm'
		ls_sql = "select incoterm as codigo, " &
				  +"descripcion as Descripcion_incoterm " &
				  +"from incoterm " &
				  +"where flag_estado = '1' " 
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.incoterm 				[al_row] = ls_codigo
			This.object.incoterm_descripcion [al_row] = ls_data
			This.ii_update = 1
		END IF
			
END CHOOSE

end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 3
ii_ck[3] = 4

ii_rk[1] = 3 	      // columnas que recibimos del master

end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event dw_detail::itemerror;call super::itemerror;RETURN 1
end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_data, ls_null

SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	 CASE 'cod_plantilla'
			SELECT desc_plantilla	
			 INTO :ls_data
			FROM plant_prod	
			WHERE cod_plantilla = :data
			  AND flag_estado = '1';
			
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'LA PLANTILLA NO EXISTE O NO ESTA ACTIVA, POR FAVOR VERIFIQUE', StopSign!)
				This.object.cod_plantilla	[row] = ls_null
				This.object.desc_plantilla	[row]	= ls_null
				RETURN 1
			END IF
			
			This.object.desc_plantilla[row]	= ls_data
			
		CASE 'incoterm'
			SELECT descripcion
			  INTO :ls_data
			FROM incoterm
			WHERE incoterm = :data
			  AND flag_estado = '1' ;
		
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'EL INCOTERM NO EXISTE O NO ESTA ACTIVA, POR FAVOR VERIFIQUE', StopSign!)
				This.object.incoterm					[row] = ls_null
				This.object.incoterm_descripcion	[row]	= ls_null
				RETURN 1
			END IF
			
			This.object.incoterm_descripcion[row]	= ls_data
END CHOOSE


end event

type uo_search from n_cst_search within w_ve022_prod_term_plant_art
integer taborder = 30
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

