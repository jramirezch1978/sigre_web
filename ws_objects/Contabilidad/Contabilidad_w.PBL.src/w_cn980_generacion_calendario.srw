$PBExportHeader$w_cn980_generacion_calendario.srw
forward
global type w_cn980_generacion_calendario from w_abc_master_smpl
end type
type st_1 from statictext within w_cn980_generacion_calendario
end type
type st_2 from statictext within w_cn980_generacion_calendario
end type
type cb_1 from commandbutton within w_cn980_generacion_calendario
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_cn980_generacion_calendario
end type
type st_avance from statictext within w_cn980_generacion_calendario
end type
type st_3 from statictext within w_cn980_generacion_calendario
end type
end forward

global type w_cn980_generacion_calendario from w_abc_master_smpl
integer width = 1975
integer height = 1440
string title = "Generacion Calendario (CN980)"
string menuname = "m_abc_master_smpl"
st_1 st_1
st_2 st_2
cb_1 cb_1
uo_fechas uo_fechas
st_avance st_avance
st_3 st_3
end type
global w_cn980_generacion_calendario w_cn980_generacion_calendario

on w_cn980_generacion_calendario.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_1=create st_1
this.st_2=create st_2
this.cb_1=create cb_1
this.uo_fechas=create uo_fechas
this.st_avance=create st_avance
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.uo_fechas
this.Control[iCurrent+5]=this.st_avance
this.Control[iCurrent+6]=this.st_3
end on

on w_cn980_generacion_calendario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.uo_fechas)
destroy(this.st_avance)
destroy(this.st_3)
end on

event resize;//  Override
end event

event ue_update_pre;call super::ue_update_pre;

dw_master.of_set_flag_replicacion( )

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn980_generacion_calendario
integer y = 252
integer width = 809
integer height = 952
string dataobject = "d_calendario_feriado_tbl"
end type

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;//AcceptText()
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
ii_ck[2] = 2	

end event

type st_1 from statictext within w_cn980_generacion_calendario
integer y = 192
integer width = 814
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "FERIADOS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn980_generacion_calendario
integer x = 215
integer y = 32
integer width = 1504
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "GENERACION DEL CALENDARIO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cn980_generacion_calendario
integer x = 1166
integer y = 800
integer width = 343
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "PROCESAR"
end type

event clicked;Date	ld_inicio, ld_fin, ld_work				
String	ls_flag_laborable, ls_find, ls_flag
Integer	li_mes, li_dia
Long		ll_rc

PARENT.EVENT ue_update()

ld_inicio = uo_fechas.of_get_fecha1()
ld_fin = uo_fechas.of_get_fecha2()  

ld_work = ld_inicio

Do while (ld_work <= ld_fin)

// Determinar Dia Laborable
li_mes = Month(ld_work)
li_dia = Day(ld_work)
ls_find = "mes = " + String(li_mes) + " AND dia = " + String(li_dia)
ll_rc = dw_master.Find(ls_find, 1,999)
IF ll_rc > 0 THEN
	ls_flag = dw_master.GetItemString(ll_rc, 'flag_medio_dia_lab')
	IF ls_flag = '1' THEN
		ls_flag_laborable = 'M'
	ELSE
		ls_flag_laborable = 'N'
	END IF
ELSE
	IF DayNumber(ld_work) = 1 THEN // CUANDO ES DOMINGO
		ls_flag_laborable = 'N'
	ELSE
		ls_flag_laborable = 'L'
	END IF
END IF
// Insertar Registro
INSERT INTO "CALENDARIO"  
         ( "FECHA", "FLAG_LABORABLE", "VNT_DOL_LIBRE", "CMP_DOL_LIBRE",   
           "VTA_DOL_BNC","CMP_DOL_BNC", "VNT_DOL_INTERB", "CMP_DOL_INTERB",   
           "VNT_DOL_EMP", "CMP_DOL_EMP", "VTA_DOL_PROM", "CMP_DOL_PROM",   
           "VTA_EUR_BNC", "CMP_EUR_BNC", "PROM_SBS", "VAC",   
           "FLAG_OPERACIONES", "FLAG_PROCESOS", "FLAG_RPT_MAIL", "MINIMO_VITAL",   
           "ANO_CALC", "MES_CALC", "SEMANA_CALC", "FLAG_REPLICACION" )  
  VALUES ( :ld_work, :ls_flag_laborable, 0, 0,   
           0, 0, 0, 0,   
           0, 0, 0, 0,   
           0, 0, 0, 0,   
           '0', '0', '0', 0,   
           0, 0, 0, '1' )  ;
// Siguiente Registro
st_avance.Text = String(ld_work, 'dd/mm/yyyy')
ld_work = RelativeDate(ld_work, 1)

Loop
COMMIT;

MessageBox("Fin de Proceso","El Proceso ha Terminado")






end event

type uo_fechas from u_ingreso_rango_fechas_v within w_cn980_generacion_calendario
integer x = 1029
integer y = 460
integer taborder = 20
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/2003')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


of_set_fecha(Today(), RelativeDate(Today(),365)) //para setear la fecha inicial

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type st_avance from statictext within w_cn980_generacion_calendario
integer x = 1545
integer y = 1116
integer width = 357
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn980_generacion_calendario
integer x = 1216
integer y = 1120
integer width = 283
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Avance:"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

