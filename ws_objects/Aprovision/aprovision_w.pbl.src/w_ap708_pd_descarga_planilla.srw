$PBExportHeader$w_ap708_pd_descarga_planilla.srw
forward
global type w_ap708_pd_descarga_planilla from w_cns_smpl
end type
type cbx_especie from checkbox within w_ap708_pd_descarga_planilla
end type
type cb_especies from commandbutton within w_ap708_pd_descarga_planilla
end type
type uo_periodo from u_ingreso_rango_fechas_v within w_ap708_pd_descarga_planilla
end type
type pb_1 from picturebutton within w_ap708_pd_descarga_planilla
end type
type gb_1 from groupbox within w_ap708_pd_descarga_planilla
end type
end forward

global type w_ap708_pd_descarga_planilla from w_cns_smpl
integer width = 3479
integer height = 2024
string title = "(AP708)  Planilla de Descarga de Materia Prima"
string menuname = "m_rpt"
windowstate windowstate = maximized!
event ue_query_retrieve ( )
cbx_especie cbx_especie
cb_especies cb_especies
uo_periodo uo_periodo
pb_1 pb_1
gb_1 gb_1
end type
global w_ap708_pd_descarga_planilla w_ap708_pd_descarga_planilla

type variables
String is_especie
end variables

event ue_query_retrieve();this.event dynamic ue_retrieve()
end event

on w_ap708_pd_descarga_planilla.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.cbx_especie=create cbx_especie
this.cb_especies=create cb_especies
this.uo_periodo=create uo_periodo
this.pb_1=create pb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_especie
this.Control[iCurrent+2]=this.cb_especies
this.Control[iCurrent+3]=this.uo_periodo
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.gb_1
end on

on w_ap708_pd_descarga_planilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_especie)
destroy(this.cb_especies)
destroy(this.uo_periodo)
destroy(this.pb_1)
destroy(this.gb_1)
end on

event ue_filter;//override

idw_1.Event ue_filter()



end event

event ue_retrieve;call super::ue_retrieve;date ld_ini, ld_fin
string ls_especie, ls_periodo, ls_fecha

dw_cns.reset( )

ld_ini = uo_periodo.of_get_fecha1()
ld_fin = uo_periodo.of_get_fecha2()

if ld_ini = ld_fin then
	ls_periodo = 'FECHA : ' + string(ld_ini, 'dd/MM/yyyy')
else
	ls_periodo = 'PERIODO : ' + string(ld_ini, 'dd/MM/yyyy') + ' - ' + string(ld_fin, 'dd/MM/yyyy')
end if

select to_char(sysdate, 'dd/mm/yyyy hh24:mi') 
   into :ls_fecha
	from dual;

if cbx_especie.checked then
   dw_cns.dataobject = 'd_ap_pd_descarga_plan_cpst'
else
	dw_cns.dataobject = 'd_ap_pd_descarga_plan_esp_cpst'
end if

dw_cns.settransobject( sqlca )

if cbx_especie.checked then
	dw_cns.retrieve(gs_origen, ld_ini, ld_fin)
else
	dw_cns.retrieve(gs_origen, is_especie, ld_ini, ld_fin)
end if

dw_cns.object.st_titulo.text = 'PLANILLA DE DESCARGAS POR DESTINO DE MATERIA PRIMA ~r' + ls_periodo
dw_cns.object.st_empresa.text = gs_empresa
dw_cns.object.st_usuario.text = 'Usuario: ' + trim(gs_user)
dw_cns.object.st_fecha.text = 'Fecha: ' + ls_fecha
dw_cns.object.p_logo.filename = gs_logo

dw_cns.visible = true
end event

type dw_cns from w_cns_smpl`dw_cns within w_ap708_pd_descarga_planilla
integer x = 0
integer y = 296
integer width = 3209
integer height = 1336
string dataobject = "d_ap_pd_descarga_plan_esp_cpst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_cns::constructor;call super::constructor;
 is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
 is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
// ii_dk[1] = 1 	      // columnas que se pasan al detall

//rte_sql.text = this.getsqlselect( )




end event

event dw_cns::ue_filter;//override

string	ls_filter
SetNull (ls_filter)

DataWindowChild l_dwc 

if THIS.getchild('dw_1',l_dwc) = 1 then
l_dwc.settransobject(sqlca) 
l_dwc.setfilter(ls_filter) 
l_dwc.filter() 
end if 

end event

type cbx_especie from checkbox within w_ap708_pd_descarga_planilla
integer x = 155
integer y = 124
integer width = 293
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
string text = "Todas"
boolean checked = true
end type

event clicked;if this.checked then
	cb_especies.enabled = False
else
	cb_especies.enabled = True
end if
end event

type cb_especies from commandbutton within w_ap708_pd_descarga_planilla
integer x = 526
integer y = 112
integer width = 585
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Una o Más especies"
end type

event clicked;
str_parametros sl_param

// Ventana para seleccionar multiples especies
sl_param.w1 		 = parent
sl_param.dw1       = 'd_data_especies_tbl'
sl_param.titulo    = 'Especies'
//sl_param.tipo		 = '3S'     // con un parametro del tipo string
sl_param.opcion 	 = 2

OpenWithParm( w_abc_seleccion, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.titulo = 's' THEN
	is_especie = sl_param.field_ret[1]
ELSE
	RETURN
END IF


Parent.Event ue_query_retrieve()
end event

type uo_periodo from u_ingreso_rango_fechas_v within w_ap708_pd_descarga_planilla
integer x = 1312
integer y = 64
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(relativedate(today(), -30), today()) //para setear la fecha inicial


of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_periodo.destroy
call u_ingreso_rango_fechas_v::destroy
end on

type pb_1 from picturebutton within w_ap708_pd_descarga_planilla
integer x = 2304
integer y = 84
integer width = 306
integer height = 148
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;parent.event ue_retrieve()
end event

type gb_1 from groupbox within w_ap708_pd_descarga_planilla
integer x = 101
integer y = 28
integer width = 1170
integer height = 248
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Especie"
end type

