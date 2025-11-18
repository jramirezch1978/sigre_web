$PBExportHeader$w_af025_ubicacion.srw
forward
global type w_af025_ubicacion from w_abc_mastdet_smpl
end type
end forward

global type w_af025_ubicacion from w_abc_mastdet_smpl
integer width = 2167
integer height = 1760
string title = "(AF024) Ubicación de Activos"
string menuname = "m_master_simple"
end type
global w_af025_ubicacion w_af025_ubicacion

event ue_insert;// Ancester Override
Long   ll_row_master, ll_row, ll_verifica
String ls_ubica


dw_master.accepttext( ) //accepttext de los dw
dw_detail.accepttext( )

ll_row_master = dw_master.getrow( )

CHOOSE CASE idw_1
	CASE dw_master
	   // Adicionando en dw_master
	   TriggerEvent ('ue_update_request') //verificar ii_update de los dw
	   IF ib_update_check = FALSE THEN RETURN
	  
	CASE dw_detail
		IF dw_master.GetRow() = 0 THEN
			MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
			RETURN
		END IF
		
		ls_ubica = dw_master.Object.ubicacion[ll_row_master]
	
		IF IsNull(ls_ubica) OR ls_ubica = '' THEN
			MessageBox('Aviso', 'INGRESE UBICACION EN CABECERA, POR FAVOR VERIFIQUE', StopSign!)
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

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE

long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)


end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = FALSE

dw_master.Accepttext( )
dw_detail.Accepttext( )

IF f_row_Processing( dw_master, "tabular") <> TRUE THEN RETURN

IF f_row_Processing( dw_detail, "tabular") <> TRUE THEN RETURN

//Para la replicacion de datos
dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = TRUE

end event

on w_af025_ubicacion.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_af025_ubicacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_mastdet_smpl`dw_master within w_af025_ubicacion
integer width = 2094
integer height = 704
string dataobject = "dw_ubicacion_activo_tbl"
end type

event dw_master::constructor;call super::constructor;
ii_ss = 1 					// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle


end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 				= THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;//this.event ue_output(currentrow)
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_af025_ubicacion
integer x = 5
integer y = 752
integer width = 2094
integer height = 780
string dataobject = "dw_ubicacion_det_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ss = 1 					// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_rk[1] = 1	      	// columnas que recibimos del master

end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::itemerror;call super::itemerror;RETURN 1
end event

