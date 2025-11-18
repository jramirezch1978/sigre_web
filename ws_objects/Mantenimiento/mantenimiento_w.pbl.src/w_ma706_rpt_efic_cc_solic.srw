$PBExportHeader$w_ma706_rpt_efic_cc_solic.srw
forward
global type w_ma706_rpt_efic_cc_solic from w_report_smpl
end type
type cb_generar from commandbutton within w_ma706_rpt_efic_cc_solic
end type
type dw_2 from datawindow within w_ma706_rpt_efic_cc_solic
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_ma706_rpt_efic_cc_solic
end type
end forward

global type w_ma706_rpt_efic_cc_solic from w_report_smpl
integer width = 3447
integer height = 2400
string title = "Eficiencia x centro de costo solicitante (MA706)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
cb_generar cb_generar
dw_2 dw_2
uo_fecha uo_fecha
end type
global w_ma706_rpt_efic_cc_solic w_ma706_rpt_efic_cc_solic

type variables
String is_tipo = 'L'
end variables

on w_ma706_rpt_efic_cc_solic.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_generar=create cb_generar
this.dw_2=create dw_2
this.uo_fecha=create uo_fecha
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_generar
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.uo_fecha
end on

on w_ma706_rpt_efic_cc_solic.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_generar)
destroy(this.dw_2)
destroy(this.uo_fecha)
end on

event ue_open_pre();call super::ue_open_pre;idw_1.Visible = True

ib_preview = false
this.event ue_preview()

idw_1.Object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_ma706_rpt_efic_cc_solic
integer x = 0
integer y = 292
integer width = 3378
integer height = 1900
integer taborder = 50
string dataobject = "d_rpt_efic_cc_resp_tbl_bak"
end type

event dw_report::doubleclicked;call super::doubleclicked;Long ll_reg
str_cns_pop lstr_cns_pop

ll_reg = dw_report.rowcount()

IF ll_reg=0 THEN RETURN

lstr_cns_pop.arg[1] = this.object.flag_grupo[row]  
lstr_cns_pop.arg[2] = this.object.flag_control[row]
OpenSheetWithParm ( w_ma713_rpt_efic_cc_det, lstr_cns_pop, parent,0,layered!)

end event

type cb_generar from commandbutton within w_ma706_rpt_efic_cc_solic
integer x = 2949
integer y = 52
integer width = 402
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;String ls_cencos, ls_ejecutor, ls_texto
Long   ll_count, ll_row
Date   ld_fini, ld_ffin

cb_generar.enabled = false

//dw_1.Accepttext()
dw_2.Accepttext()

ld_fini     = uo_fecha.of_get_fecha1()
ld_ffin     = uo_fecha.of_get_fecha2()

ls_texto = 'Del ' + string(ld_fini,'dd/mm/yyyy') + ' al ' + string(ld_ffin,'dd/mm/yyyy')

ls_ejecutor = dw_2.object.cod_ejecutor [1]

IF Isnull(ls_ejecutor) OR Trim(ls_ejecutor) = '' THEN
	Messagebox('Aviso','Debe Seleccionar ejecutor')
	Return
END IF


/*Eliminacion de Infomación Temporal*/
delete from tt_man_efic_cc_res ;
/**/

DECLARE PB_USP_MTT_EFIC_CC_SOLIC PROCEDURE FOR USP_MTT_EFIC_CC_SOLIC ( :ls_ejecutor, :ld_fini, :ld_ffin ) ;
execute PB_USP_MTT_EFIC_CC_SOLIC ;

IF sqlca.sqlcode = -1 THEN
	MessageBox( 'Error', "Procedimiento <<USP_MTT_EFIC_CC_SOLIC>> no concluyo correctamente", StopSign! )
	Return
END IF

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_texto.text   = ls_texto
//dw_report.object.t_user.text     = gs_user

ib_preview = false
parent.event ue_preview()

cb_generar.enabled = true

end event

type dw_2 from datawindow within w_ma706_rpt_efic_cc_solic
integer x = 87
integer y = 40
integer width = 1495
integer height = 88
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_ext_ejecutor_tbl"
boolean border = false
boolean livescroll = true
end type

event constructor;SetTransObject(sqlca)
InsertRow(0)
end event

event doubleclicked;IF Getrow() = 0 THEN Return
String ls_name ,ls_prot ,ls_nombre
str_seleccionar lstr_seleccionar
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
  return
end if

IF dwo.name = 'cod_ejecutor' THEN 
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT EJECUTOR.COD_EJECUTOR AS COD_EJECUTOR ,'&
														 +'EJECUTOR.DESCRIPCION AS DESCRIPCION '&
									   				 +'FROM EJECUTOR '

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_ejecutor',lstr_seleccionar.param1[1])
					Setitem(row,'descripcion',lstr_seleccionar.param2[1])
				END IF
END IF
end event

event itemchanged;IF Getrow() = 0 THEN Return
String ls_name , ls_descripcion
ls_name = dwo.name

IF dwo.name = 'cod_ejecutor' THEN 
	select descripcion
	into :ls_descripcion
	from ejecutor
	where cod_ejecutor = :data ;
	
	Setitem(row, 'descripcion', ls_descripcion)
END IF
end event

event itemerror;String ls_descripcion
return 1
end event

type uo_fecha from u_ingreso_rango_fechas_v within w_ma706_rpt_efic_cc_solic
integer x = 2162
integer y = 28
integer taborder = 30
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;of_set_label("Desde :","Hasta :")
of_set_fecha(TODAY(),TODAY())
of_set_rango_inicio(DATE('01/01/1900'))
of_set_rango_fin(DATE('31/12/9999'))
end event

