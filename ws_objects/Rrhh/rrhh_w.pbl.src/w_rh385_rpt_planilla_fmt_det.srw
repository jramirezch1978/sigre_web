$PBExportHeader$w_rh385_rpt_planilla_fmt_det.srw
forward
global type w_rh385_rpt_planilla_fmt_det from w_abc_master_smpl
end type
type ddlb_tip_trab from u_ddlb_lista within w_rh385_rpt_planilla_fmt_det
end type
type st_1 from statictext within w_rh385_rpt_planilla_fmt_det
end type
type ddlb_origen from u_ddlb_lista within w_rh385_rpt_planilla_fmt_det
end type
type st_2 from statictext within w_rh385_rpt_planilla_fmt_det
end type
type uo_proceso from u_fecha within w_rh385_rpt_planilla_fmt_det
end type
type cbx_1 from checkbox within w_rh385_rpt_planilla_fmt_det
end type
type rb_r from radiobutton within w_rh385_rpt_planilla_fmt_det
end type
type rb_m from radiobutton within w_rh385_rpt_planilla_fmt_det
end type
type gb_1 from groupbox within w_rh385_rpt_planilla_fmt_det
end type
end forward

global type w_rh385_rpt_planilla_fmt_det from w_abc_master_smpl
integer width = 2903
integer height = 1756
string title = "(RH385) Detalle de Formato de Planilla"
string menuname = "m_impresion"
ddlb_tip_trab ddlb_tip_trab
st_1 st_1
ddlb_origen ddlb_origen
st_2 st_2
uo_proceso uo_proceso
cbx_1 cbx_1
rb_r rb_r
rb_m rb_m
gb_1 gb_1
end type
global w_rh385_rpt_planilla_fmt_det w_rh385_rpt_planilla_fmt_det

on w_rh385_rpt_planilla_fmt_det.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.ddlb_tip_trab=create ddlb_tip_trab
this.st_1=create st_1
this.ddlb_origen=create ddlb_origen
this.st_2=create st_2
this.uo_proceso=create uo_proceso
this.cbx_1=create cbx_1
this.rb_r=create rb_r
this.rb_m=create rb_m
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_tip_trab
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.ddlb_origen
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.uo_proceso
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.rb_r
this.Control[iCurrent+8]=this.rb_m
this.Control[iCurrent+9]=this.gb_1
end on

on w_rh385_rpt_planilla_fmt_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_tip_trab)
destroy(this.st_1)
destroy(this.ddlb_origen)
destroy(this.st_2)
destroy(this.uo_proceso)
destroy(this.cbx_1)
destroy(this.rb_r)
destroy(this.rb_m)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
end event

event ue_query_retrieve;Integer li_print, li_msg, li_mes
String  ls_cod_origen, ls_tip_trab, ls_msg, ls_estilo_f, ls_nombre_mes
Date    ld_proceso, ld_fecha_i, ld_fecha_f
//override

dw_master.reset( )

ls_tip_trab = trim(right(ddlb_tip_trab.text, 3))
ls_cod_origen = trim(right(ddlb_origen.text, 2))

li_print = 0
ld_proceso = uo_proceso.of_get_fecha( )

IF rb_r.checked = TRUE THEN
	
	SELECT F.FEC_INICIO, F.FEC_FINAL
	  INTO :ld_fecha_i, :ld_fecha_f
	  FROM RRHH_PARAM_ORG F
	 WHERE F.FEC_PROCESO = :ld_proceso;
	       dw_master.object.t_fecha.text = 'DEL  ' + STRING(ld_fecha_i, 'dd/mm/yyyy') + '  AL  ' + STRING(ld_fecha_f, 'dd/mm/yyyy') 
	  ELSE
		
		li_mes = month(ld_proceso)
		
	CHOOSE CASE li_mes
			
	  	CASE 1
			  ls_nombre_mes = 'ENERO'
		CASE 2
			  ls_nombre_mes = 'FEBRERO'
	   CASE 3
			  ls_nombre_mes = 'MARZO'
      CASE 4
			  ls_nombre_mes = 'ABRIL'
		CASE 5
			  ls_nombre_mes = 'MAYO'
	   CASE 6
			  ls_nombre_mes = 'JUNIO'
		CASE 7
			  ls_nombre_mes = 'JULIO'
		CASE 8
			  ls_nombre_mes = 'AGOSTO'
	   CASE 9
			  ls_nombre_mes = 'SEPTIEMBRE'
	   CASE 10
			  ls_nombre_mes = 'OCTUBRE'
		CASE 11
			  ls_nombre_mes = 'NOVIEMBRE'
	   CASE 12
			  ls_nombre_mes = 'DICIEMBRE'
	END CHOOSE
	    
		 dw_master.object.t_fecha.text =  ls_nombre_mes + ' DEL ' + STRING(YEAR(ld_proceso))

END IF

if cbx_1.checked then
	declare usp_rh_planilla_det_his procedure for
			  usp_rh_planilla_det_his(:ls_cod_origen, :ls_tip_trab, :ld_proceso);
	execute usp_rh_planilla_det_his;
	fetch usp_rh_planilla_det_his into :li_msg, :ls_msg;
	close usp_rh_planilla_det_his;
else	
	declare usp_rh_planilla_det procedure for
			  usp_rh_planilla_det(:ls_cod_origen, :ls_tip_trab, :ld_proceso);
	execute usp_rh_planilla_det;
	fetch usp_rh_planilla_det into :li_msg, :ls_msg;
	close usp_rh_planilla_det;
end if	

if sqlca.sqlcode <> 0 then 
	messagebox(this.title, 'Error al ejecutar usp_rh_planilla_det')
	return
end if

if li_msg = 1 then
	messagebox(this.title, ls_msg)
	return
end if

if dw_master.retrieve( ) < 1 then
	messagebox(this.title, 'No se pudo cargar el reporte')
	return
end if


OpenWithParm(w_print_opt, dw_master)
li_print = Message.DoubleParm
If li_print = -1 Then Return
dw_master.print(true)
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh385_rpt_planilla_fmt_det
integer y = 284
integer width = 2811
integer height = 1312
string dataobject = "d_rh_planilla_fmt_det_cpst"
end type

event dw_master::constructor;call super::constructor;is_dwform =  'form' 
ii_ck[1] = 1
end event

type ddlb_tip_trab from u_ddlb_lista within w_rh385_rpt_planilla_fmt_det
integer x = 439
integer y = 56
integer height = 776
boolean bringtotop = true
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_dddw_tipo_trabajador_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 3							// Longitud del campo 2

end event

type st_1 from statictext within w_rh385_rpt_planilla_fmt_det
integer x = 5
integer y = 56
integer width = 434
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Trabajador:"
boolean focusrectangle = false
end type

type ddlb_origen from u_ddlb_lista within w_rh385_rpt_planilla_fmt_det
integer x = 1536
integer y = 44
integer width = 567
integer height = 776
integer taborder = 30
boolean bringtotop = true
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_dddw_origen_usuario_tbl'

ii_cn1 = 2                     // Nro del campo 1
ii_cn2 = 1                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 2							// Longitud del campo 2

end event

event ue_item_add;//override
Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item

ll_rows = ids_Data.Retrieve(gs_user)

FOR li_x = 1 TO ll_rows
	la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
	ls_item = of_cut_string(la_id, ii_lc1, ' ')
	la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
	ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
	li_index = THIS.AddItem(ls_item)
	ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
NEXT

if ll_rows >= 1 then this.selectitem(1)
end event

type st_2 from statictext within w_rh385_rpt_planilla_fmt_det
integer x = 1298
integer y = 56
integer width = 174
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type uo_proceso from u_fecha within w_rh385_rpt_planilla_fmt_det
integer x = 183
integer y = 168
integer taborder = 20
boolean bringtotop = true
end type

event constructor;//override
of_set_label('Proceso') // para seatear el titulo del boton
of_set_fecha(today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

//of_get_fecha1()  //para leer las fechas
end event

on uo_proceso.destroy
call u_fecha::destroy
end on

type cbx_1 from checkbox within w_rh385_rpt_planilla_fmt_det
integer x = 2345
integer y = 60
integer width = 466
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Calculo Historico"
end type

type rb_r from radiobutton within w_rh385_rpt_planilla_fmt_det
integer x = 1326
integer y = 192
integer width = 343
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango"
boolean checked = true
end type

type rb_m from radiobutton within w_rh385_rpt_planilla_fmt_det
integer x = 1705
integer y = 192
integer width = 329
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
end type

type gb_1 from groupbox within w_rh385_rpt_planilla_fmt_det
integer x = 1289
integer y = 140
integer width = 814
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
string text = "Estilo de Fecha"
end type

