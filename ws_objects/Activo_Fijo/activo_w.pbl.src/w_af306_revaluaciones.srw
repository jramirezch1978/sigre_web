$PBExportHeader$w_af306_revaluaciones.srw
forward
global type w_af306_revaluaciones from w_abc_mastdet_smpl
end type
end forward

global type w_af306_revaluaciones from w_abc_mastdet_smpl
integer width = 2715
integer height = 1640
string title = "(AF306) Revaluaciones de Activos"
string menuname = "m_master_simple"
long backcolor = 67108864
end type
global w_af306_revaluaciones w_af306_revaluaciones

type variables
Integer ii_dw_upd
string ls_dato
end variables

on w_af306_revaluaciones.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_af306_revaluaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

Ib_log = True

end event

event ue_print;call super::ue_print;idw_1.print()
end event

event ue_modify;call super::ue_modify;
integer li_protect 

li_protect = integer(dw_detail.Object.cod_sub_clase.Protect)
if li_protect = 0 then
	dw_detail.Object.cod_sub_clase.Protect = 1
end if 
li_protect = integer(dw_detail.Object.fecha_adq_inicial.Protect)
if li_protect = 0 then
	dw_detail.Object.fecha_adq_inicial.Protect = 1
end if 


	

end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = FALSE

IF f_row_Processing( dw_detail, "tabular") <> TRUE THEN RETURN

//Para la replicacion de datos
dw_detail.of_set_flag_replicacion()

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = TRUE
end event

event ue_insert;// Override Ancester
Long   ll_row_master, ll_row, ll_verifica
String ls_clase


dw_detail.accepttext() //accepttext de los dw

CHOOSE CASE idw_1
	CASE dw_detail
	   TriggerEvent ('ue_update_request') //verificar ii_update de los dw
	   IF ib_update_check = FALSE THEN RETURN
	  
   CASE ELSE
	  RETURN
	  
END CHOOSE

//insertar
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
END IF
end event

event ue_update;// Override Ancester
Boolean lbo_ok = TRUE
String	ls_msg

dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_detail.of_create_log()
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_detail.ii_update = 0
	dw_detail.il_totdel = 0
	dw_detail.of_protect( )
	dw_detail.ResetUpdate( )
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	
END IF

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_af306_revaluaciones
integer x = 55
integer y = 48
integer width = 2555
integer height = 560
string dataobject = "dw_cuenta_clase_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				 // columnas de lectrua de este dw
ii_dk[1] = 1             // colunmna de pase de parametros


end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_af306_revaluaciones
event ue_display ( string as_columna,  long al_row )
integer x = 55
integer y = 660
integer width = 2555
integer height = 732
string dataobject = "dw_revaluaciones_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate, ls_clase
			
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
	CASE "cod_sub_clase"
		ls_clase = This.object.cnta_ctbl [al_row]

		ls_sql = "SELECT COD_SUB_CLASE AS COD_SUB_CLASE, " &
				  +"DESC_CLASE AS DESCRIPCION "&
				  +"FROM AF_SUB_CLASE " &
				  +"WHERE CNTA_CTBL = '" + ls_clase + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_sub_clase 	[al_row] = ls_codigo
			This.object.desc_clase		[al_row] = ls_data
			This.ii_update = 1
		END IF
		
END CHOOSE

end event

event dw_detail::constructor;call super::constructor;//Forma parte del pK
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
//Variable de pase de Parametros
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;
This.object.flag_estado [al_row] = '1'

// Validacion al ingresar un registro
dw_detail.Modify("cod_sub_clase.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("fecha_adq_inicial.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("fecha_adq_final.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("tasa.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("flag_estado.Protect='1~tIf(IsRowNew(),0,1)'")



end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF


end event

event dw_detail::itemchanged;call super::itemchanged;String ls_data, ls_null, ls_clase
date	 ld_fecha1, ld_fecha2, ld_null


SetNull(ls_null)
SetNull(ld_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	 CASE 'cod_sub_clase'
			ls_clase = This.object.cnta_ctbl [row]
			
			SELECT desc_clase	
			 INTO :ls_data
			FROM af_sub_clase
			WHERE cnta_ctbl = :ls_clase
			  and cod_sub_clase = :data;
			
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'EL CONFIN NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				this.object.cod_sub_clase		[row] = ls_null
				this.object.desc_clase	[row]	= ls_null
				return 1
			END IF
			
			this.object.desc_clase[row]	= ls_data

	CASE 'fecha_adq_inicial'
		ld_fecha1 = date(This.object.fecha_adq_inicial[row])
		ld_fecha2 = date(This.object.fecha_adq_final  [row])
		
		IF ld_fecha1 > ld_fecha2 THEN
			messagebox('Error', 'Error en Rango de Fechas')
			This.object.fecha_adq_inicial[row] = ld_null
			RETURN 1
		END IF
		
	CASE 'fecha_adq_final'
		ld_fecha1 = date(This.object.fecha_adq_inicial[row])
		ld_fecha2 = date(This.object.fecha_adq_final  [row])
		
		IF ld_fecha1 > ld_fecha2 THEN
			messagebox('Error', 'Error en Rango de Fechas')
			This.object.fecha_adq_final[row] = ld_null
			RETURN 1
		END IF
		
END CHOOSE

end event

event dw_detail::itemerror;call super::itemerror;RETURN 1
end event

