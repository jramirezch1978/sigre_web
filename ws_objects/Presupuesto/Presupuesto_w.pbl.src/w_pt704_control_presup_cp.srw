$PBExportHeader$w_pt704_control_presup_cp.srw
$PBExportComments$Control presupuestario por cuenta presupuestal
forward
global type w_pt704_control_presup_cp from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas within w_pt704_control_presup_cp
end type
type rb_1 from radiobutton within w_pt704_control_presup_cp
end type
type rb_2 from radiobutton within w_pt704_control_presup_cp
end type
type cb_3 from commandbutton within w_pt704_control_presup_cp
end type
type gb_1 from groupbox within w_pt704_control_presup_cp
end type
type gb_2 from groupbox within w_pt704_control_presup_cp
end type
end forward

global type w_pt704_control_presup_cp from w_report_smpl
integer width = 2939
integer height = 1472
string title = "Control  x Cuentas Presupuestales (PT704)"
string menuname = "m_impresion"
long backcolor = 67108864
uo_fechas uo_fechas
rb_1 rb_1
rb_2 rb_2
cb_3 cb_3
gb_1 gb_1
gb_2 gb_2
end type
global w_pt704_control_presup_cp w_pt704_control_presup_cp

type variables
Long il_ano
end variables

on w_pt704_control_presup_cp.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fechas=create uo_fechas
this.rb_1=create rb_1
this.rb_2=create rb_2
this.cb_3=create cb_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_pt704_control_presup_cp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.cb_3)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre();call super::ue_open_pre;uo_fechas.event ue_output()
end event

type dw_report from w_report_smpl`dw_report within w_pt704_control_presup_cp
integer y = 228
string dataobject = "d_rpt_control_presupuestal_cp"
end type

type uo_fechas from u_ingreso_rango_fechas within w_pt704_control_presup_cp
integer x = 41
integer y = 72
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor; string ls_inicio 

 of_set_label('Desde','Hasta') //para setear la fecha inicial

//Obtenemos el Primer dia del Mes

ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 of_set_fecha(date(ls_inicio),today())
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas
 
//Controles a Observar en el Windows

end event

event ue_output();call super::ue_output;Date ld_fec_ini
ld_fec_ini = uo_fechas.of_get_fecha1()

il_ano = YEAR( ld_fec_ini)

end event

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type rb_1 from radiobutton within w_pt704_control_presup_cp
integer x = 1449
integer y = 84
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;// Inserta todos los registros en tabla temporal

Delete from tt_pto_seleccion;

	insert into tt_pto_seleccion ( cnta_prsp ) 
 		(SELECT DISTINCT cnta_prsp
    	FROM PRESUPUESTO_PARTIDA            
   	WHERE ANO =  :il_ano) ;
//Commit;
end event

type rb_2 from radiobutton within w_pt704_control_presup_cp
integer x = 1742
integer y = 88
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;str_parametros sl_param

// Asigna valores a structura 
sl_param.dw1 = "d_sel_presupuesto_partida_cnta_pres_ano"
sl_param.titulo = "Cuentas presupuestales"
sl_param.opcion = 2
sl_param.tipo = '1L'
sl_param.long1 = il_ano

OpenWithParm( w_rpt_listas, sl_param)
end event

type cb_3 from commandbutton within w_pt704_control_presup_cp
integer x = 2240
integer y = 56
integer width = 306
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
end type

event clicked;Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_fechas.of_get_fecha1()
ld_fec_fin = uo_fechas.of_get_fecha2()

SetPointer(Hourglass!)
// genera archivo de articulos, solo los que se han movido segun compras
DECLARE PB_USP_proc1 PROCEDURE FOR USP_PTO_CONTROL_PRESUP_CP
				  (:il_ano, :ld_fec_ini, :ld_fec_fin);
EXECUTE PB_USP_PROC1;
If sqlca.sqlcode = -1 then
	messagebox("Error", sqlca.sqlerrtext)
	return 0
end if

dw_report.visible = true
dw_report.retrieve()

dw_report.object.t_titulo1.text = 'Del ' + STRING(ld_fec_ini, "DD/MM/YYYY") + &
								' Al ' + STRING(ld_fec_fin, "DD/MM/YYYY")
//dw_report.object.t_titulo2.text = "Tipo: " + ddlb_tipo.text//	
dw_report.object.t_usuario.text = gs_user
dw_report.Object.p_logo.filename = gs_logo
end event

type gb_1 from groupbox within w_pt704_control_presup_cp
integer width = 1376
integer height = 188
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
end type

type gb_2 from groupbox within w_pt704_control_presup_cp
integer x = 1376
integer width = 846
integer height = 188
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cta. Presup."
end type

