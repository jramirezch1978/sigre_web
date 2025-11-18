$PBExportHeader$w_rh726_consist_dias_no_lab.srw
forward
global type w_rh726_consist_dias_no_lab from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_rh726_consist_dias_no_lab
end type
type cb_1 from commandbutton within w_rh726_consist_dias_no_lab
end type
type st_2 from statictext within w_rh726_consist_dias_no_lab
end type
type em_ttrab from editmask within w_rh726_consist_dias_no_lab
end type
type cb_ttrab from commandbutton within w_rh726_consist_dias_no_lab
end type
type em_descripcion_ttrab from editmask within w_rh726_consist_dias_no_lab
end type
type gb_1 from groupbox within w_rh726_consist_dias_no_lab
end type
end forward

global type w_rh726_consist_dias_no_lab from w_report_smpl
integer width = 3749
integer height = 1832
string title = "[RH725] Consistencia de Días no laborados"
string menuname = "m_reporte"
uo_1 uo_1
cb_1 cb_1
st_2 st_2
em_ttrab em_ttrab
cb_ttrab cb_ttrab
em_descripcion_ttrab em_descripcion_ttrab
gb_1 gb_1
end type
global w_rh726_consist_dias_no_lab w_rh726_consist_dias_no_lab

on w_rh726_consist_dias_no_lab.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cb_1=create cb_1
this.st_2=create st_2
this.em_ttrab=create em_ttrab
this.cb_ttrab=create cb_ttrab
this.em_descripcion_ttrab=create em_descripcion_ttrab
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.em_ttrab
this.Control[iCurrent+5]=this.cb_ttrab
this.Control[iCurrent+6]=this.em_descripcion_ttrab
this.Control[iCurrent+7]=this.gb_1
end on

on w_rh726_consist_dias_no_lab.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.em_ttrab)
destroy(this.cb_ttrab)
destroy(this.em_descripcion_ttrab)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_tipo_trabajador, ls_ruc, ls_nom_empresa, ls_empresa, ls_mensaje
Date 		ld_fecha_ini, ld_fecha_fin

ls_tipo_trabajador = em_ttrab.text

ld_fecha_ini = uo_1.of_get_fecha1()
ld_fecha_fin = uo_1.of_get_fecha2()  

select cod_empresa
  into :ls_empresa
  from genparam
 where reckey = '1';
 
Select nombre, ruc 
	into :ls_nom_empresa, :ls_ruc
from empresa
where cod_empresa = :ls_empresa;

//create or replace procedure usp_rh_dias_no_laborados(
//       asi_tipo_trabaj      in tipo_trabajador.tipo_trabajador%TYPE,
//       adi_Fecha1           in date,
//       adi_fecha2           in date
//) is

//ejecuto procesos de CIERRE DE PLANILLA
DECLARE usp_rh_dias_no_laborados PROCEDURE FOR 
	usp_rh_dias_no_laborados(:ls_tipo_trabajador ,
									 :ld_fecha_ini ,
									 :ld_fecha_fin);

EXECUTE usp_rh_dias_no_laborados ;

//busco errores
if sqlca.sqlcode = -1 then
   ls_mensaje = sqlca.sqlerrtext
   Rollback ;
   Messagebox('SQL Error usp_rh_dias_no_laborados',ls_mensaje)
   Return
end if	   	  
  
CLOSE usp_rh_dias_no_laborados ;

dw_report.Retrieve(ls_tipo_trabajador, ld_fecha_ini, ld_fecha_fin)
dw_report.object.datawindow.Print.Orientation = 2

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_texto.text = "PERIODO DEL " + &
										  STRING(ld_fecha_ini, 'dd/mm/yyyy') + " al " + &
										  STRING(ld_fecha_fin, 'dd/mm/yyyy')
dw_report.object.t_empresa.text 	= gs_empresa
dw_report.object.t_ruc.text 		= ls_ruc
dw_report.object.t_objeto.text 	= this.classname()
dw_report.object.t_user.text 		= gs_user


end event

type dw_report from w_report_smpl`dw_report within w_rh726_consist_dias_no_lab
integer x = 0
integer y = 196
integer width = 3333
integer height = 1232
string dataobject = "d_rpt_consist_dias_no_lab_tbl"
end type

type uo_1 from u_ingreso_rango_fechas within w_rh726_consist_dias_no_lab
integer x = 37
integer y = 68
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cb_1 from commandbutton within w_rh726_consist_dias_no_lab
integer x = 2871
integer y = 52
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Trigger Event ue_retrieve()
end event

type st_2 from statictext within w_rh726_consist_dias_no_lab
integer x = 1326
integer y = 68
integer width = 443
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de trabajador :"
boolean focusrectangle = false
end type

type em_ttrab from editmask within w_rh726_consist_dias_no_lab
integer x = 1765
integer y = 68
integer width = 151
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_ttrab from commandbutton within w_rh726_consist_dias_no_lab
integer x = 1947
integer y = 68
integer width = 87
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_ttrab.text             = sl_param.field_ret[1]
	em_descripcion_ttrab.text = sl_param.field_ret[2]
END IF

end event

type em_descripcion_ttrab from editmask within w_rh726_consist_dias_no_lab
integer x = 2048
integer y = 68
integer width = 741
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type gb_1 from groupbox within w_rh726_consist_dias_no_lab
integer width = 2848
integer height = 176
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Parametros de reporte"
end type

