$PBExportHeader$w_cn048_cnta_cntbl_grupo.srw
forward
global type w_cn048_cnta_cntbl_grupo from w_abc_mastdet_smpl
end type
end forward

global type w_cn048_cnta_cntbl_grupo from w_abc_mastdet_smpl
integer width = 2263
integer height = 1584
string title = "(CN048) Grupo Cntas Cntbl"
string menuname = "m_abc_mastdet_smpl"
end type
global w_cn048_cnta_cntbl_grupo w_cn048_cnta_cntbl_grupo

on w_cn048_cnta_cntbl_grupo.create
call super::create
if this.MenuName = "m_abc_mastdet_smpl" then this.MenuID = create m_abc_mastdet_smpl
end on

on w_cn048_cnta_cntbl_grupo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect

ls_protect=dw_master.Describe("cntbl_cnta_grp.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cntbl_cnta_grp')
END IF
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cn048_cnta_cntbl_grupo
integer width = 2199
integer height = 508
string dataobject = "d_abc_grupo_cnta_cntbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master				// dw_master
idw_det  = dw_detail		// dw_detail
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cn048_cnta_cntbl_grupo
integer x = 5
integer y = 540
integer width = 2199
integer height = 848
string dataobject = "d_abc_grupo_cnta_cntbl_det"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_detail::doubleclicked;call super::doubleclicked;// Ventanas de ayuda
IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
	CASE 'cnta_ctbl'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
												 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
												 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
												 +'FROM CNTBL_CNTA ' 
								  
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			Setitem(row,'cnta_ctbl',lstr_seleccionar.param1[1])
			Setitem(row,'desc_cnta',lstr_seleccionar.param2[1])
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
		this.object.desc_cnta[row]=ls_desc
end choose

end event

