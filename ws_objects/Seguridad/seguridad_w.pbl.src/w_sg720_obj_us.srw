$PBExportHeader$w_sg720_obj_us.srw
forward
global type w_sg720_obj_us from w_report_smpl
end type
type cb_1 from commandbutton within w_sg720_obj_us
end type
type ddlb_1 from u_ddlb within w_sg720_obj_us
end type
type st_1 from statictext within w_sg720_obj_us
end type
end forward

global type w_sg720_obj_us from w_report_smpl
integer width = 2309
integer height = 1592
string title = "Accesos x Objeto (SG720)"
string menuname = "m_rpt_simple"
long backcolor = 12632256
cb_1 cb_1
ddlb_1 ddlb_1
st_1 st_1
end type
global w_sg720_obj_us w_sg720_obj_us

type variables
String  is_objeto
end variables

on w_sg720_obj_us.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_1=create cb_1
this.ddlb_1=create ddlb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.ddlb_1
this.Control[iCurrent+3]=this.st_1
end on

on w_sg720_obj_us.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.ddlb_1)
destroy(this.st_1)
end on

event ue_retrieve;call super::ue_retrieve;String	ls_descripcion, ls_sistema

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

idw_1.Retrieve(is_objeto)

// Leer Descripcion de Objeto
  SELECT "OBJETO_SIS"."DESCRIPCION",   
         "OBJETO_SIS"."SISTEMA"  
    INTO :ls_descripcion,   
         :ls_sistema  
    FROM "OBJETO_SIS"  
   WHERE "OBJETO_SIS"."OBJETO" = :is_objeto ;
	
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_cod_obj.text = 'SG720'
idw_1.object.t_objeto.text = is_objeto
idw_1.object.t_obj_descripcion.text = ls_descripcion
idw_1.object.t_sistema.text = ls_sistema

end event

type dw_report from w_report_smpl`dw_report within w_sg720_obj_us
integer x = 18
integer y = 132
string dataobject = "d_obj_usr_grp_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String		ls_tipo_doc
STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cant_pendiente" 
		lstr_1.DataObject = 'd_articulo_mov_tbl'
		lstr_1.Width = 1700
		lstr_1.Height= 1000
		lstr_1.Arg[1] = GetItemString(row,'cod_origen')
		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Title = 'Movimientos Relacionados'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
	CASE "nro_doc"
		ls_tipo_doc = TRIM(GetItemString(row,'tipo_doc'))	
		CHOOSE CASE ls_tipo_doc
			CASE 'OT'
				lstr_1.DataObject = 'd_orden_trabajo_oper_sec_ff'
				lstr_1.Width = 2000
				lstr_1.Height= 1800
				lstr_1.Arg[1] = GetItemString(row,'nro_doc')
				lstr_1.Arg[2] = GetItemString(row,'oper_sec')
				lstr_1.Title = 'Orden de Trabajo'
			CASE 'SC'
				lstr_1.DataObject = 'd_sol_compra_ff'
				lstr_1.Width = 2300
				lstr_1.Height= 1200
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Solicitud de Compra'
			CASE 'SL'
				lstr_1.DataObject = 'd_solicitud_salida_ff'
				lstr_1.Width = 2100
				lstr_1.Height= 800
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Solicitud de Salida'
			CASE 'OC'
				lstr_1.DataObject = 'd_orden_compra_ff'
				lstr_1.Width = 2400
				lstr_1.Height= 1300
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Orden de Compra'
			CASE 'OV'
				lstr_1.DataObject = 'd_orden_venta_ff'
				lstr_1.Width = 2300
				lstr_1.Height= 1500
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Orden de Venta'
		END CHOOSE
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
END CHOOSE

end event

type cb_1 from commandbutton within w_sg720_obj_us
integer x = 1797
integer y = 36
integer width = 325
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.Event ue_retrieve()
end event

type ddlb_1 from u_ddlb within w_sg720_obj_us
integer x = 283
integer y = 32
integer width = 1399
integer height = 780
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
boolean allowedit = true
end type

event modified;call super::modified;//String ls_usr
//
//ls_usr = this.text
//
//dw_1.Retrieve(ls_usr)
//dw_2.Retrieve(ls_usr)
end event

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_objetos_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 30                     // Longitud del campo 1
ii_lc2 = 30							// Longitud del campo 2

end event

event ue_output;call super::ue_output;is_objeto = aa_key

end event

type st_1 from statictext within w_sg720_obj_us
integer x = 32
integer y = 44
integer width = 224
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Objeto:"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

