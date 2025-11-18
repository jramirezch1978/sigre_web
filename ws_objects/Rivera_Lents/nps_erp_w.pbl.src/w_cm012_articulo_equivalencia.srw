$PBExportHeader$w_cm012_articulo_equivalencia.srw
forward
global type w_cm012_articulo_equivalencia from w_abc
end type
type dw_detail from u_dw_abc within w_cm012_articulo_equivalencia
end type
type dw_master from u_dw_abc within w_cm012_articulo_equivalencia
end type
end forward

global type w_cm012_articulo_equivalencia from w_abc
integer width = 3264
integer height = 2596
string title = "Equivalencias (CM012)"
string menuname = "m_mtto_smpl"
dw_detail dw_detail
dw_master dw_master
end type
global w_cm012_articulo_equivalencia w_cm012_articulo_equivalencia

event ue_open_pre();call super::ue_open_pre;//f_centrar( this )

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)
dw_master.retrieve()

ii_pregunta_delete = 1 
idw_1 = dw_detail
dw_master.of_protect()         		// bloquear modificaciones 
dw_detail.of_protect()
end event

on w_cm012_articulo_equivalencia.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_master
end on

on w_cm012_articulo_equivalencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = dw_detail.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_detail.AcceptText() 

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_detail.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_detail.Object.cod_equiva.Protect)

IF li_protect = 0 THEN
   dw_detail.Object.cod_equiva.Protect = 1
END IF
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type ole_skin from w_abc`ole_skin within w_cm012_articulo_equivalencia
end type

type dw_detail from u_dw_abc within w_cm012_articulo_equivalencia
integer y = 1092
integer width = 2263
integer height = 488
integer taborder = 20
string dataobject = "d_abc_articulo_equivalencias_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
ii_rk[1] = 1 

ii_ss = 0 
is_dwform = 'tabular'
end event

event doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
String ls_name, ls_prot, ls_soles
Double ln_cambio, ln_precio
str_parametros sl_param

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

// Ayuda de busqueda para articulos
if ls_name = 'cod_equiva' and ls_prot = '0' then
	OpenWithParm (w_pop_articulos, parent)
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' then
		this.object.cod_equiva[this.getrow()] = sl_param.field_ret[1]
		this.object.desc_art[this.getrow()] = sl_param.field_ret[2]
		this.object.und[this.getrow()] = sl_param.field_ret[3]	
 	END IF
END IF
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_art[al_row] = dw_master.object.cod_art[dw_master.getrow()]
end event

event ue_delete_pre;call super::ue_delete_pre;if dw_detail.getrow() = 0 then return 0
end event

type dw_master from u_dw_abc within w_cm012_articulo_equivalencia
integer width = 2263
integer height = 1080
string dataobject = "d_dddw_articulo"
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1	
ii_dk[1] = 1 

is_dwform = 'tabular'
idw_det  = dw_detail
end event

event ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)

end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

