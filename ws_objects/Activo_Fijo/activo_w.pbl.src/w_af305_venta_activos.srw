$PBExportHeader$w_af305_venta_activos.srw
forward
global type w_af305_venta_activos from w_abc_mastdet_smpl
end type
end forward

global type w_af305_venta_activos from w_abc_mastdet_smpl
integer width = 3081
integer height = 1868
string title = "(AF305) Venta de Activos"
string menuname = "m_master_simple"
end type
global w_af305_venta_activos w_af305_venta_activos

forward prototypes
public subroutine of_retrieve (string as_tipo_doc, string as_nro_doc, long al_row)
end prototypes

public subroutine of_retrieve (string as_tipo_doc, string as_nro_doc, long al_row);// Funcion para recuperar los datos del documento por pagar
String	ls_moneda, ls_observacion, ls_cod_usr
Date		ld_fecha
decimal	ldec_importe

SELECT FECHA_DOCUMENTO, COD_MONEDA, IMPORTE_DOC, OBSERVACION, COD_USR
  INTO :ld_fecha		, :ls_moneda,  :ldec_importe, :ls_observacion, :ls_cod_usr
FROM   CNTAS_COBRAR 
WHERE  TIPO_DOC = :as_tipo_doc
  AND  NRO_DOC  = :as_nro_doc;


dw_detail.object.fecha_documento [al_row] = ld_fecha
dw_detail.object.cod_moneda		[al_row] = ls_moneda
dw_detail.object.importe_doc		[al_row] = ldec_importe
dw_detail.object.observacion		[al_row] = ls_observacion
dw_detail.object.cod_usr			[al_row] = ls_cod_usr
end subroutine

on w_af305_venta_activos.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_af305_venta_activos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;// OVerride
dw_master.width  = newwidth  - dw_master.x - 300
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
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

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

ib_log = TRUE
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

event ue_update;// Ancester Override
Boolean lbo_ok = TRUE
String	ls_msg

dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_Detail.of_create_log()
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

type dw_master from w_abc_mastdet_smpl`dw_master within w_af305_venta_activos
integer x = 201
integer y = 16
integer width = 2565
integer height = 612
string dataobject = "dw_lista_maestro_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al master
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_af305_venta_activos
event ue_display ( string as_columna,  long al_row )
integer x = 14
integer y = 704
integer width = 3003
integer height = 936
string dataobject = "dw_ventas_activos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate, &
			ls_tipo_doc, ls_nro_doc
			
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
	CASE "tipo_doc"
		ls_nro_doc = This.object.nro_doc [al_row]
		ls_sql = "SELECT DISTINCT CC.TIPO_DOC AS CODIGO, " &
				  +"DT.DESC_TIPO_DOC AS DESCRIPCION "&
				  +"FROM CNTAS_COBRAR CC, " &
				  +"DOC_TIPO DT " &
				  +"WHERE CC.TIPO_DOC = DT.TIPO_DOC " &
				  +"AND CC.FLAG_ESTADO <> '0' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.tipo_doc 	 [al_row] = ls_codigo
			This.ii_update = 1
		END IF
	
		of_retrieve(ls_codigo, ls_nro_doc, al_row)
			
	CASE 'nro_doc'
		ls_tipo_doc = This.object.tipo_doc [al_row]
		
		ls_sql = "SELECT TIPO_DOC AS TIPO_DOC, " &
				  +"NRO_DOC AS NUMERO_DOC " &
				  +"FROM   CNTAS_COBRAR " &
				  +"WHERE  TIPO_DOC = '" + ls_tipo_doc + "'" &
				  +"AND  FLAG_ESTADO <> '0' " &
				  +"AND  ORIGEN = '" + gs_origen + "'"
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.nro_doc 	 [al_row] = ls_data
			This.ii_update = 1
		END IF
		
		of_retrieve(ls_tipo_doc, ls_data, al_row)
	
END CHOOSE
end event

event dw_detail::itemerror;call super::itemerror;RETURN 1

end event

event dw_detail::constructor;call super::constructor;
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("tipo_doc.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("nro_doc.Protect='1~tIf(IsRowNew(),0,1)'")

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

event dw_detail::itemchanged;call super::itemchanged;String ls_data, ls_null, ls_tipo_doc, ls_nro_doc


SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	CASE 'tipo_doc'
		ls_nro_doc = This.object.nro_doc [row]
		SELECT DISTINCT
			 CC.TIPO_DOC	
		 INTO :ls_data
		FROM   CNTAS_COBRAR   CC,
				 	 DOC_TIPO       DT
		WHERE  CC.TIPO_DOC = DT.TIPO_DOC
		  AND  CC.TIPO_DOC = :data
		  AND  CC.FLAG_ESTADO <> '0';
			
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL TIPO_DOC NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.tipo_doc	[row] = ls_null
			this.object.nro_doc	[row]	= ls_null
			return 1
		END IF
		
		of_retrieve(data, ls_nro_doc, row)
		
	CASE 'nro_doc'
		ls_tipo_doc = This.object.tipo_doc [row]
		SELECT NRO_DOC
		  INTO :ls_data
		FROM   CNTAS_COBRAR
		WHERE  TIPO_DOC = :ls_tipo_doc
  			AND  FLAG_ESTADO <> '0'
  			AND  ORIGEN = :gs_origen
			AND  NRO_DOC = :data;
		
			
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL NUMERO DOC NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.nro_doc	[row]	= ls_null
			return 1
		END IF
		
		of_retrieve(ls_tipo_doc, data, row)
		
END CHOOSE
end event

