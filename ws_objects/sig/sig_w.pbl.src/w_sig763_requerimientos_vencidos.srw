$PBExportHeader$w_sig763_requerimientos_vencidos.srw
forward
global type w_sig763_requerimientos_vencidos from w_report_smpl
end type
type uo_fecha from u_ingreso_fecha within w_sig763_requerimientos_vencidos
end type
type cb_1 from commandbutton within w_sig763_requerimientos_vencidos
end type
type rb_ot from radiobutton within w_sig763_requerimientos_vencidos
end type
type rb_sc from radiobutton within w_sig763_requerimientos_vencidos
end type
type rb_sl from radiobutton within w_sig763_requerimientos_vencidos
end type
type rb_ov from radiobutton within w_sig763_requerimientos_vencidos
end type
type rb_otr from radiobutton within w_sig763_requerimientos_vencidos
end type
type rb_oc from radiobutton within w_sig763_requerimientos_vencidos
end type
type gb_1 from groupbox within w_sig763_requerimientos_vencidos
end type
end forward

global type w_sig763_requerimientos_vencidos from w_report_smpl
integer width = 3086
integer height = 1716
string title = "Requerimientos Vencidos (SIG763)"
string menuname = "m_rpt_simple"
long backcolor = 12632256
uo_fecha uo_fecha
cb_1 cb_1
rb_ot rb_ot
rb_sc rb_sc
rb_sl rb_sl
rb_ov rb_ov
rb_otr rb_otr
rb_oc rb_oc
gb_1 gb_1
end type
global w_sig763_requerimientos_vencidos w_sig763_requerimientos_vencidos

type variables
String	is_dw = 'D', is_doc
String	is_doc_ot, is_doc_sc, is_doc_ss, is_doc_oc, is_doc_ov, is_doc_otr

end variables

forward prototypes
public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_sc, ref string as_doc_ss, ref string as_doc_oc, ref string as_doc_ov, ref string as_doc_otr)
end prototypes

public function integer of_get_parametros (ref string as_doc_ot, ref string as_doc_sc, ref string as_doc_ss, ref string as_doc_oc, ref string as_doc_ov, ref string as_doc_otr);Long		ll_rc = 0
String	ls_clase


SELECT DOC_OT, DOC_SC, DOC_SS, DOC_OC, DOC_OV, DOC_OTR
  INTO :as_doc_ot, :as_doc_sc, :as_doc_ss, :as_doc_oc, :as_doc_ov, :as_doc_otr
  FROM LOGPARAM
 WHERE RECKEY = '1' ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer Tipo de Documento OT')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_sig763_requerimientos_vencidos.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.rb_ot=create rb_ot
this.rb_sc=create rb_sc
this.rb_sl=create rb_sl
this.rb_ov=create rb_ov
this.rb_otr=create rb_otr
this.rb_oc=create rb_oc
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.rb_ot
this.Control[iCurrent+4]=this.rb_sc
this.Control[iCurrent+5]=this.rb_sl
this.Control[iCurrent+6]=this.rb_ov
this.Control[iCurrent+7]=this.rb_otr
this.Control[iCurrent+8]=this.rb_oc
this.Control[iCurrent+9]=this.gb_1
end on

on w_sig763_requerimientos_vencidos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.rb_ot)
destroy(this.rb_sc)
destroy(this.rb_sl)
destroy(this.rb_ov)
destroy(this.rb_otr)
destroy(this.rb_oc)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Date	ld_fecha

ld_fecha = uo_fecha.of_get_fecha()

//IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

idw_1.Retrieve(is_doc, ld_fecha)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_objeto.text = 'SIG763'
idw_1.object.t_user.text = gs_user
idw_1.object.t_fecha.text = String(ld_fecha, 'dd/mm/yyyy')
end event

event ue_open_pre;call super::ue_open_pre;long	ll_rc


ll_rc = of_get_parametros(is_doc_ot, is_doc_sc, is_doc_ss, is_doc_oc, is_doc_ov, is_doc_otr)

is_dw = 'D'
//idw_1.Dataobject = 'd_operaciones_desprogramadas'
idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")
is_doc = is_doc_ot
end event

type dw_report from w_report_smpl`dw_report within w_sig763_requerimientos_vencidos
integer x = 14
integer y = 160
integer width = 2272
integer height = 720
string dataobject = "d_art_mov_prov_ot_vencidos_usr"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cod_labor" 
		lstr_1.DataObject = 'd_labor_ff'
		lstr_1.Width = 2500
		lstr_1.Height= 650
		lstr_1.Arg[1] = GetItemString(row,'cod_labor')
		lstr_1.Title = 'Labor'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
END CHOOSE
end event

type uo_fecha from u_ingreso_fecha within w_sig763_requerimientos_vencidos
integer x = 9
integer y = 36
integer taborder = 20
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor; of_set_label('Hasta:') 
 of_set_fecha(RelativeDate(Today(),-1))
 of_set_rango_inicio(date('01/01/2000')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

type cb_1 from commandbutton within w_sig763_requerimientos_vencidos
integer x = 2112
integer y = 56
integer width = 402
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.Event ue_retrieve()

end event

type rb_ot from radiobutton within w_sig763_requerimientos_vencidos
integer x = 727
integer y = 72
integer width = 187
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT"
boolean checked = true
end type

event clicked;idw_1.Dataobject = 'd_art_mov_prov_ot_vencidos_usr'
idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
is_doc = is_doc_ot
end event

type rb_sc from radiobutton within w_sig763_requerimientos_vencidos
integer x = 951
integer y = 72
integer width = 165
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SC"
end type

event clicked;idw_1.Dataobject = 'd_art_mov_prov_sc_vencidos_usr'
idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
is_doc = is_doc_sc
end event

type rb_sl from radiobutton within w_sig763_requerimientos_vencidos
integer x = 1152
integer y = 72
integer width = 187
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SS"
end type

event clicked;idw_1.Dataobject = 'd_art_mov_prov_ss_vencidos_usr'
idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
is_doc = is_doc_ss
end event

type rb_ov from radiobutton within w_sig763_requerimientos_vencidos
integer x = 1362
integer y = 72
integer width = 165
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OV"
end type

event clicked;idw_1.Dataobject = 'd_art_mov_prov_ov_vencidos_usr'
idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
is_doc = is_doc_ov
end event

type rb_otr from radiobutton within w_sig763_requerimientos_vencidos
integer x = 1554
integer y = 72
integer width = 192
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OTR"
end type

event clicked;idw_1.Dataobject = 'd_art_mov_prov_otr_vencidos_usr'
idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
is_doc = is_doc_otr
end event

type rb_oc from radiobutton within w_sig763_requerimientos_vencidos
integer x = 1769
integer y = 72
integer width = 165
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OC"
end type

event clicked;idw_1.Dataobject = 'd_art_mov_prov_oc_vencidos_usr'
idw_1.SetTransObject(SQLCA)
idw_1.Modify("DataWindow.Print.Preview=Yes")
idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
is_doc = is_doc_oc
end event

type gb_1 from groupbox within w_sig763_requerimientos_vencidos
integer x = 654
integer y = 12
integer width = 1326
integer height = 132
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipos de Ordenes"
end type

