$PBExportHeader$w_cm335_oc_pend_mod_fecha.srw
forward
global type w_cm335_oc_pend_mod_fecha from w_abc_master_smpl
end type
type uo_fecha from u_ingreso_fecha within w_cm335_oc_pend_mod_fecha
end type
type cb_1 from commandbutton within w_cm335_oc_pend_mod_fecha
end type
type sle_dias from singlelineedit within w_cm335_oc_pend_mod_fecha
end type
type st_1 from statictext within w_cm335_oc_pend_mod_fecha
end type
type st_2 from statictext within w_cm335_oc_pend_mod_fecha
end type
type uo_fecha_obj from u_ingreso_fecha within w_cm335_oc_pend_mod_fecha
end type
type cb_reprogramar from commandbutton within w_cm335_oc_pend_mod_fecha
end type
type gb_1 from groupbox within w_cm335_oc_pend_mod_fecha
end type
type gb_2 from groupbox within w_cm335_oc_pend_mod_fecha
end type
end forward

global type w_cm335_oc_pend_mod_fecha from w_abc_master_smpl
integer width = 3506
integer height = 2220
string menuname = "m_mant_reprog"
event ue_retrieve ( )
uo_fecha uo_fecha
cb_1 cb_1
sle_dias sle_dias
st_1 st_1
st_2 st_2
uo_fecha_obj uo_fecha_obj
cb_reprogramar cb_reprogramar
gb_1 gb_1
gb_2 gb_2
end type
global w_cm335_oc_pend_mod_fecha w_cm335_oc_pend_mod_fecha

forward prototypes
public function integer of_get_parametros (ref string as_doc_oc)
end prototypes

event w_cm335_oc_pend_mod_fecha::ue_retrieve();Long	ls_rc
String	ls_doc_oc

ls_rc = of_get_parametros(ls_doc_oc)

idw_1.Retrieve(ls_doc_oc, uo_fecha.of_get_fecha())
end event

public function integer of_get_parametros (ref string as_doc_oc);Long		ll_rc = 0



  SELECT "LOGPARAM"."DOC_OC"
    INTO :as_doc_oc
    FROM "LOGPARAM"  
   WHERE "LOGPARAM"."RECKEY" = '1' ;

	
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox(SQLCA.SQLErrText, 'No se pudo leer LOGPARAM')
	lL_rc = -1
END IF


RETURN ll_rc

end function

on w_cm335_oc_pend_mod_fecha.create
int iCurrent
call super::create
if this.MenuName = "m_mant_reprog" then this.MenuID = create m_mant_reprog
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.sle_dias=create sle_dias
this.st_1=create st_1
this.st_2=create st_2
this.uo_fecha_obj=create uo_fecha_obj
this.cb_reprogramar=create cb_reprogramar
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_dias
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.uo_fecha_obj
this.Control[iCurrent+7]=this.cb_reprogramar
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_cm335_oc_pend_mod_fecha.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.sle_dias)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.uo_fecha_obj)
destroy(this.cb_reprogramar)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
end event

event ue_set_access;// Override
end event

event ue_update;call super::ue_update;THIS.Event ue_retrieve()
end event

type dw_master from w_abc_master_smpl`dw_master within w_cm335_oc_pend_mod_fecha
integer x = 14
integer y = 220
integer width = 3433
integer height = 916
string dataobject = "d_oc_pend_mod_fecha_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ss = 0

ii_ck[1] = 6
ii_ck[2] = 7



end event

event dw_master::ue_selected_row_pro;call super::ue_selected_row_pro;

THIS.object.data.primary.current[al_row, 3] = uo_fecha_obj.of_get_fecha()
end event

type uo_fecha from u_ingreso_fecha within w_cm335_oc_pend_mod_fecha
event destroy ( )
integer x = 46
integer y = 84
integer taborder = 30
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

type cb_1 from commandbutton within w_cm335_oc_pend_mod_fecha
integer x = 1230
integer y = 88
integer width = 315
integer height = 76
integer taborder = 40
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

type sle_dias from singlelineedit within w_cm335_oc_pend_mod_fecha
integer x = 1038
integer y = 84
integer width = 151
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;uo_fecha.em_1.text = String(RelativeDate(Today(), -Integer(THIS.TExt)))
end event

type st_1 from statictext within w_cm335_oc_pend_mod_fecha
integer x = 718
integer y = 96
integer width = 315
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dias Atrazo:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm335_oc_pend_mod_fecha
integer x = 2025
integer y = 88
integer width = 311
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cambiar A:"
boolean focusrectangle = false
end type

type uo_fecha_obj from u_ingreso_fecha within w_cm335_oc_pend_mod_fecha
integer x = 2327
integer y = 76
integer taborder = 40
boolean bringtotop = true
end type

on uo_fecha_obj.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor; of_set_label('Hasta:') 
 of_set_fecha(Today())
 of_set_rango_inicio(RelativeDate(Today(),-45)) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cb_reprogramar from commandbutton within w_cm335_oc_pend_mod_fecha
integer x = 3031
integer y = 80
integer width = 379
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reprogramar"
end type

event clicked;idw_1.EVENT ue_selected_row()
idw_1.ii_update = 1
end event

type gb_1 from groupbox within w_cm335_oc_pend_mod_fecha
integer x = 23
integer width = 1563
integer height = 204
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Lectura"
end type

type gb_2 from groupbox within w_cm335_oc_pend_mod_fecha
integer x = 1984
integer width = 1472
integer height = 204
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reprogramacion"
end type

