$PBExportHeader$w_cn049_plant_grp_cc_prod.srw
forward
global type w_cn049_plant_grp_cc_prod from w_abc_mastdet_smpl
end type
end forward

global type w_cn049_plant_grp_cc_prod from w_abc_mastdet_smpl
integer width = 3209
integer height = 1584
string title = "(CN049) Plantilla de grupo de centros de costos de producción"
string menuname = "m_abc_mastdet_smpl"
end type
global w_cn049_plant_grp_cc_prod w_cn049_plant_grp_cc_prod

on w_cn049_plant_grp_cc_prod.create
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
end on

on w_cn049_plant_grp_cc_prod.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect

ls_protect=dw_master.Describe("cod_plant.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_plant')
END IF


end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cn049_plant_grp_cc_prod
integer width = 2199
integer height = 508
string dataobject = "d_abc_plant_grp_cc_prod_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master				// dw_master
idw_det  = dw_detail		// dw_detail
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cn049_plant_grp_cc_prod
integer x = 5
integer y = 540
integer width = 3131
integer height = 848
string dataobject = "d_abc_plant_grp_cc_prod_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[1] = 1				// columnas de lectura de este dw
ii_rk[1] = 1 	      	// columnas que recibimos del master

end event

event dw_detail::doubleclicked;call super::doubleclicked;// Ventanas de ayuda
IF Getrow() = 0 THEN Return
String ls_name, ls_prot, ls_flag_estado
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

ls_flag_estado = '1' 

CHOOSE CASE dwo.name
	CASE 'cencos'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CODIGO, '&
												 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&
												 +'FROM CENTROS_COSTO '&
												 +'WHERE CENTROS_COSTO.FLAG_ESTADO = '+"'"+ls_flag_estado+"'"
								  
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'cencos',lstr_seleccionar.param1[1])
			Setitem(row,'centros_costo_desc_cencos',lstr_seleccionar.param2[1])
			ii_update = 1
		END IF
	
	CASE 'cnta_ctbl'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
												 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
												 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
												 +'FROM CNTBL_CNTA '&
												 +'WHERE CNTBL_CNTA.FLAG_ESTADO = '+"'"+ls_flag_estado+"'"
								  
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'cnta_ctbl',lstr_seleccionar.param1[1])
			Setitem(row,'cntbl_cnta_abrev_cnta',lstr_seleccionar.param2[1])
			ii_update = 1
		END IF
END CHOOSE

end event

event dw_detail::itemchanged;call super::itemchanged;string ls_cod, ls_desc

This.AcceptText()

if row <= 0 then return

Choose case GetColumnName()
	case "cnta_ctbl"
		ls_cod = this.object.cnta_ctbl[row]
		
		Select desc_cnta
		  into :ls_desc
		  from cntbl_cnta
		 where cnta_ctbl = : ls_cod;
		
		this.object.cntbl_cnta_abrev_cnta[row]=ls_desc
	case "cencos"
		ls_cod = this.object.cencos[row]

		Select desc_cencos
		  into :ls_desc
		  from centros_costo 
		 where cencos = : ls_cod;

		this.object.centros_costo_desc_cencos[row]=ls_desc
		
end choose

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr[al_row] = gs_user
end event

