$PBExportHeader$w_ap315_liquidacion_compra_frm.srw
forward
global type w_ap315_liquidacion_compra_frm from w_rpt
end type
type rb_1 from radiobutton within w_ap315_liquidacion_compra_frm
end type
type rb_2 from radiobutton within w_ap315_liquidacion_compra_frm
end type
type dw_report from u_dw_rpt within w_ap315_liquidacion_compra_frm
end type
end forward

global type w_ap315_liquidacion_compra_frm from w_rpt
integer width = 2377
integer height = 1612
string title = "[AP315] Reporte de Liquidacion de Compra"
string menuname = "m_rpt"
rb_1 rb_1
rb_2 rb_2
dw_report dw_report
end type
global w_ap315_liquidacion_compra_frm w_ap315_liquidacion_compra_frm

forward prototypes
public subroutine of_nro_vale ()
end prototypes

public subroutine of_nro_vale ();String	  ls_separador, ls_nro_vale
Long		  ll_i

ls_separador = ', '

FOR ll_i = 1 to dw_report.Rowcount( )
	IF LEN(ls_nro_vale) > 0 THEN
		ls_nro_vale = ls_nro_vale + ls_separador + dw_report.object.nro_vale[ll_i]
	ELSE
		ls_nro_vale = ls_nro_vale + dw_report.object.nro_vale[ll_i]
	END IF
NEXT

dw_report.object.t_nota_ingreso.text = ls_nro_vale
end subroutine

on w_ap315_liquidacion_compra_frm.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.dw_report
end on

on w_ap315_liquidacion_compra_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()

rb_1.event clicked( )
//This.Event ue_retrieve()
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()

end event

event ue_retrieve;call super::ue_retrieve;String 	ls_nro_lc, ls_nom_empresa, ls_ruc, ls_cod_rel, ls_tipo_doc, &
	    	ls_num_let, ls_fecha_let, ls_desc_imp, ls_tasa_imp, ls_origen, &
			ls_cod_usr
decimal ldc_importe
date	 ld_fecha

str_parametros lstr_rep

n_cst_numlet lnv_num_let
lnv_num_let = CREATE n_cst_numlet

lstr_rep = message.powerobjectparm

ls_cod_rel  = lstr_rep.string1
ls_tipo_doc = lstr_rep.string2
ls_nro_lc   = lstr_rep.string3

Select nombre, ruc 
	into :ls_nom_empresa, :ls_ruc
from empresa
where cod_empresa = (select cod_empresa from genparam where reckey = '1');

if not ISNULL( ls_ruc ) then  ls_ruc = 'RUC:' + ls_ruc

dw_report.Retrieve(ls_cod_rel, ls_tipo_doc, ls_nro_lc)

IF idw_1.getrow() > 0 THEN
	ldc_importe 	= dw_report.object.importe_total [idw_1.getrow()]
	ld_fecha			= date(dw_report.object.fecha_emision[idw_1.getrow()])
	ls_num_let 		= lnv_num_let.of_numlet(String(ldc_importe))
	ls_fecha_let	= lnv_num_let.of_numfech(ld_fecha)
	ls_origen 		= dw_report.object.origen	[1]
	ls_cod_usr		= dw_report.object.cod_usr	[1]
END IF

// Obtengo el tipo de impuesto y la tasa
SELECT it.desc_impuesto, it.tasa_impuesto
  INTO :ls_desc_imp, :ls_tasa_imp
FROM   cp_doc_det_imp   cp,
       impuestos_tipo   it
WHERE  CP.COD_RELACION = :ls_cod_rel
  AND  CP.TIPO_DOC     = :ls_tipo_doc
  AND  CP.NRO_DOC      = :ls_nro_lc 
  AND  cp.tipo_impuesto= it.tipo_impuesto ;

IF rb_2.checked THEN
	idw_1.Object.p_logo.filename  = gs_logo
	idw_1.object.t_direccion.text = f_direccion_empresa(ls_origen)
	idw_1.object.t_telefono.text  = f_telefono_empresa(ls_origen)
	idw_1.object.t_email.text  	= gnvo_app.of_email_user(ls_cod_usr, ls_origen)
	idw_1.object.t_ruc.text 		= ls_ruc
	idw_1.object.t_empresa.text	= ls_nom_empresa
	idw_1.object.t_usuario.text	= gs_user
ELSE
	idw_1.object.t_fecha.text		= ls_fecha_let
END IF

idw_1.object.t_dir_prov.text = f_direccion_proveedor(ls_cod_rel, '0')

IF isNull(ls_desc_imp) OR LEN(ls_desc_imp) = 0 THEN
	idw_1.object.t_impuesto.text  = ''
ELSE
	idw_1.object.t_impuesto.text  = ls_desc_imp + ' ' + ls_tasa_imp + '%'
END IF

idw_1.Visible = True

IF gs_empresa = 'CEPIBO' THEN
	this.dw_report.Object.DataWindow.Print.Paper.Size = 256 
	this.dw_report.Object.DataWindow.Print.CustomPage.Width = 250
	this.dw_report.Object.DataWindow.Print.CustomPage.Length = 141
END IF
end event

type rb_1 from radiobutton within w_ap315_liquidacion_compra_frm
integer y = 16
integer width = 814
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Pre - Impreso"
boolean checked = true
end type

event clicked;if gs_empresa = 'FISHOLG' then
	dw_report.dataobject = 'd_rpt_liquidacion_compra_fisholg'
elseif gs_empresa = 'CEPIBO' then
	dw_report.dataobject = 'd_rpt_liquidacion_compra_cepibo'
else
	dw_report.dataobject = 'd_rpt_liquidacion_compra'
end if


dw_report.settransobject(sqlca)

ib_preview = false
event ue_preview()
event ue_retrieve()

of_nro_vale()


end event

type rb_2 from radiobutton within w_ap315_liquidacion_compra_frm
integer x = 841
integer y = 8
integer width = 594
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Completo"
end type

event clicked;dw_report.dataobject = 'd_rpt_liquidacion_compra_tbl'
dw_report.settransobject(sqlca)
ib_preview = false
event ue_preview()
event ue_retrieve()
of_nro_vale()

end event

type dw_report from u_dw_rpt within w_ap315_liquidacion_compra_frm
integer y = 112
integer width = 1984
integer height = 1092
string dataobject = "d_rpt_liquidacion_compra"
boolean hscrollbar = true
boolean vscrollbar = true
end type

