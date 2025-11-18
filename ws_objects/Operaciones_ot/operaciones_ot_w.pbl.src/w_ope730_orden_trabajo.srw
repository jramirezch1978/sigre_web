$PBExportHeader$w_ope730_orden_trabajo.srw
forward
global type w_ope730_orden_trabajo from w_report_smpl
end type
type st_1 from statictext within w_ope730_orden_trabajo
end type
type cb_lectura from commandbutton within w_ope730_orden_trabajo
end type
type sle_ot from u_sle_codigo within w_ope730_orden_trabajo
end type
end forward

global type w_ope730_orden_trabajo from w_report_smpl
integer width = 1440
integer height = 1312
string title = "Orden de Trabajo (OPE730)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
st_1 st_1
cb_lectura cb_lectura
sle_ot sle_ot
end type
global w_ope730_orden_trabajo w_ope730_orden_trabajo

forward prototypes
public function integer of_get_parametros (ref string as_clase)
end prototypes

public function integer of_get_parametros (ref string as_clase);Long		ll_rc = 0
String	ls_clase


SELECT CLASE_PROD_TERM
  INTO :as_clase
  FROM SIG_AGRICOLA
 WHERE RECKEY = '1' ;
	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer SIG_AZUCAR')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_ope730_orden_trabajo.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.st_1=create st_1
this.cb_lectura=create cb_lectura
this.sle_ot=create sle_ot
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_lectura
this.Control[iCurrent+3]=this.sle_ot
end on

on w_ope730_orden_trabajo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_lectura)
destroy(this.sle_ot)
end on

event ue_retrieve;call super::ue_retrieve;String	ls_clase
Long		ll_rc


IF ll_rc = 0 THEN
	idw_1.Retrieve(sle_ot.Text)
	idw_1.object.p_logo.filename = gs_logo
	idw_1.object.t_empresa.text = gs_empresa
	idw_1.object.t_user.text = gs_user
END IF


end event

type dw_report from w_report_smpl`dw_report within w_ope730_orden_trabajo
integer x = 18
integer y = 116
string dataobject = "d_ot_oper_amp_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "sldo_total" 
		lstr_1.DataObject = 'd_articulo_saldos_almacen_tbl'
		lstr_1.Width = 2500
		lstr_1.Height= 1300
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Saldos por Almacen'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)
	CASE "sldo_pendiente" 
		lstr_1.DataObject = 'd_articulo_mov_proy_ov_pendiente'
		lstr_1.Width = 3220
		lstr_1.Height= 1300
		lstr_1.Arg[1] = GetItemString(row,'cod_art')
		lstr_1.Title = 'Solicitudes Pendientes'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)	
END CHOOSE

end event

type st_1 from statictext within w_ope730_orden_trabajo
integer x = 23
integer y = 20
integer width = 485
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Trabajo:"
boolean focusrectangle = false
end type

type cb_lectura from commandbutton within w_ope730_orden_trabajo
integer x = 1015
integer y = 24
integer width = 306
integer height = 64
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.Event ue_retrieve()
end event

type sle_ot from u_sle_codigo within w_ope730_orden_trabajo
integer x = 539
integer y = 16
integer width = 402
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

