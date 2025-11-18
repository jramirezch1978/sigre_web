$PBExportHeader$w_rh613_rpt_utilidades_distribucion.srw
forward
global type w_rh613_rpt_utilidades_distribucion from w_report_smpl
end type
type cb_1 from commandbutton within w_rh613_rpt_utilidades_distribucion
end type
type em_periodo from editmask within w_rh613_rpt_utilidades_distribucion
end type
type st_1 from statictext within w_rh613_rpt_utilidades_distribucion
end type
type em_item from editmask within w_rh613_rpt_utilidades_distribucion
end type
type ddlb_tipo_trabaj from u_ddlb within w_rh613_rpt_utilidades_distribucion
end type
type ddlb_origen from u_ddlb within w_rh613_rpt_utilidades_distribucion
end type
type st_2 from statictext within w_rh613_rpt_utilidades_distribucion
end type
type st_3 from statictext within w_rh613_rpt_utilidades_distribucion
end type
type gb_1 from groupbox within w_rh613_rpt_utilidades_distribucion
end type
end forward

global type w_rh613_rpt_utilidades_distribucion from w_report_smpl
integer width = 3552
integer height = 1876
string title = "(RH613) Detalle de Utilidades"
string menuname = "m_impresion"
cb_1 cb_1
em_periodo em_periodo
st_1 st_1
em_item em_item
ddlb_tipo_trabaj ddlb_tipo_trabaj
ddlb_origen ddlb_origen
st_2 st_2
st_3 st_3
gb_1 gb_1
end type
global w_rh613_rpt_utilidades_distribucion w_rh613_rpt_utilidades_distribucion

on w_rh613_rpt_utilidades_distribucion.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_periodo=create em_periodo
this.st_1=create st_1
this.em_item=create em_item
this.ddlb_tipo_trabaj=create ddlb_tipo_trabaj
this.ddlb_origen=create ddlb_origen
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_periodo
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_item
this.Control[iCurrent+5]=this.ddlb_tipo_trabaj
this.Control[iCurrent+6]=this.ddlb_origen
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.gb_1
end on

on w_rh613_rpt_utilidades_distribucion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_periodo)
destroy(this.st_1)
destroy(this.em_item)
destroy(this.ddlb_tipo_trabaj)
destroy(this.ddlb_origen)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string  ls_mensaje, ls_origen, ls_tipo_trabajador, ls_desc_origen, ls_desc_tipo_trabaj
integer li_periodo, li_item

li_periodo = integer(em_periodo.text)
li_item = integer(em_item.text)
ls_origen = MID(ddlb_origen.text,1,2)
ls_desc_origen = MID(ddlb_origen.text,6,15)
ls_tipo_trabajador = MID(ddlb_tipo_trabaj.text,1,3)
ls_desc_tipo_trabaj = MID(ddlb_tipo_trabaj.text,6,20)

dw_report.retrieve(li_periodo, li_item, ls_origen, ls_tipo_trabajador)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_texto.text = 'Periodo ' + String(li_periodo) + ' - ' + String(li_item) + ', ' + ls_desc_origen + ' - ' + ls_desc_tipo_trabaj
end event

type dw_report from w_report_smpl`dw_report within w_rh613_rpt_utilidades_distribucion
integer x = 0
integer y = 212
integer width = 3456
integer height = 1360
integer taborder = 60
string dataobject = "d_rpt_utilidad_distribuc_tbl"
end type

type cb_1 from commandbutton within w_rh613_rpt_utilidades_distribucion
integer x = 3150
integer y = 72
integer width = 293
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_periodo from editmask within w_rh613_rpt_utilidades_distribucion
integer x = 261
integer y = 88
integer width = 187
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_1 from statictext within w_rh613_rpt_utilidades_distribucion
integer x = 27
integer y = 88
integer width = 224
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Período:"
boolean focusrectangle = false
end type

type em_item from editmask within w_rh613_rpt_utilidades_distribucion
integer x = 475
integer y = 88
integer width = 105
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
string mask = "#"
end type

type ddlb_tipo_trabaj from u_ddlb within w_rh613_rpt_utilidades_distribucion
integer x = 2245
integer y = 80
integer width = 763
integer height = 480
integer taborder = 40
boolean bringtotop = true
integer limit = 4
string is_dataobject = "d_lista_tipo_trabaj_todos_tbl"
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_lista_tipo_trabaj_todos_tbl'

ii_cn1 = 1                    // Nro del campo 1
ii_cn2 = 2                    // Nro del campo 2
ii_ck  = 1                    // Nro del campo key
ii_lc1 = 5							// Longitud del campo 1
ii_lc2 = 30							// Longitud del campo 2

end event

type ddlb_origen from u_ddlb within w_rh613_rpt_utilidades_distribucion
integer x = 878
integer y = 88
integer width = 905
integer height = 492
integer taborder = 30
boolean bringtotop = true
integer limit = 4
string is_dataobject = "d_lista_origen_todos_tbl"
end type

event ue_open_pre;call super::ue_open_pre;Long ll_count_origen, ll_count_origen_otadm

// Conteo de origenes activos
SELECT count(*) 
  INTO :ll_count_origen 
  FROM origen o 
 WHERE flag_estado='1' ;

// Conteo de origenes de OT_ADM
  SELECT count(distinct ot_adm_origen.cod_origen)   
    INTO :ll_count_origen_otadm 
    FROM "ORIGEN",   
         "OT_ADM_ORIGEN",   
         "OT_ADM_USUARIO"  
   WHERE ( origen.cod_origen (+) = ot_adm_origen.cod_origen) and  
         ( "OT_ADM_ORIGEN"."OT_ADM" = "OT_ADM_USUARIO"."OT_ADM" ) and  
         ( ( trim("OT_ADM_USUARIO"."COD_USR") = trim(:gs_user) ) )   ;

IF ll_count_origen > ll_count_origen_otadm THEN
	is_dataobject = 'd_dddw_origen_usuario_tbl'
ELSE
	is_dataobject = 'd_lista_origen_todos_tbl'
END IF

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 5                     // Longitud del campo 1
ii_lc2 = 20							// Longitud del campo 2

end event

event ue_item_add;// Override
Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item

Long ll_count_origen, ll_count_origen_otadm

// Conteo de origenes activos
SELECT count(*) 
  INTO :ll_count_origen 
  FROM origen o 
 WHERE flag_estado='1' ;

// Conteo de origenes de OT_ADM
  SELECT count(distinct ot_adm_origen.cod_origen)   
    INTO :ll_count_origen_otadm 
    FROM "ORIGEN",   
         "OT_ADM_ORIGEN",   
         "OT_ADM_USUARIO"  
   WHERE ( origen.cod_origen (+) = ot_adm_origen.cod_origen) and  
         ( "OT_ADM_ORIGEN"."OT_ADM" = "OT_ADM_USUARIO"."OT_ADM" ) and  
         ( ( trim("OT_ADM_USUARIO"."COD_USR") = trim(:gs_user) ) )   ;

IF ll_count_origen > ll_count_origen_otadm THEN
	ll_rows = ids_Data.Retrieve(gs_user)
ELSE
	ll_rows = ids_Data.Retrieve()
END IF

//ll_rows = ids_Data.Retrieve()

IF ll_rows < 1 THEN	MessageBox('Error', 'Este DDLB no tiene Registros')

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, '.')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

end event

type st_2 from statictext within w_rh613_rpt_utilidades_distribucion
integer x = 681
integer y = 96
integer width = 178
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh613_rpt_utilidades_distribucion
integer x = 1847
integer y = 96
integer width = 379
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Tipo Trabajador:"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh613_rpt_utilidades_distribucion
integer width = 3040
integer height = 200
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parámetros"
end type

