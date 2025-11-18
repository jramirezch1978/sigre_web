$PBExportHeader$w_fl906_presupuesto_varia.srw
forward
global type w_fl906_presupuesto_varia from w_abc_master_smpl
end type
type st_1 from statictext within w_fl906_presupuesto_varia
end type
type em_year from editmask within w_fl906_presupuesto_varia
end type
type cbx_todos from checkbox within w_fl906_presupuesto_varia
end type
type ddlb_naves from u_ddlb within w_fl906_presupuesto_varia
end type
type dw_1 from u_dw_grf within w_fl906_presupuesto_varia
end type
type ddlb_desde from dropdownlistbox within w_fl906_presupuesto_varia
end type
type st_2 from statictext within w_fl906_presupuesto_varia
end type
type ddlb_hasta from dropdownlistbox within w_fl906_presupuesto_varia
end type
type st_3 from statictext within w_fl906_presupuesto_varia
end type
type pb_accept from picturebutton within w_fl906_presupuesto_varia
end type
end forward

global type w_fl906_presupuesto_varia from w_abc_master_smpl
integer width = 3470
integer height = 1936
string title = "Variaciones Presupuestales (FL906)"
string menuname = "m_rep_grf"
boolean resizable = false
boolean center = true
event ue_preview ( )
event ue_procesar ( )
st_1 st_1
em_year em_year
cbx_todos cbx_todos
ddlb_naves ddlb_naves
dw_1 dw_1
ddlb_desde ddlb_desde
st_2 st_2
ddlb_hasta ddlb_hasta
st_3 st_3
pb_accept pb_accept
end type
global w_fl906_presupuesto_varia w_fl906_presupuesto_varia

type variables
boolean ib_preview
end variables

event ue_preview();IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_procesar();string 	ls_mes_ini, ls_mes_fin, ls_ano, ls_mensaje, ls_nave, ls_periodo
integer 	li_desde, li_hasta, li_tipo, li_ok
long 		ll_ano, ll_cuenta

ls_ano 		= right(trim(idw_1.object.t_titulo.text),4)
ll_ano 		= long(ls_ano)
li_desde 	= idw_1.object.mes[1]
li_hasta 	= idw_1.object.mes[idw_1.rowcount()]
ls_mes_ini 	= trim(idw_1.object.mes_nomb[1])
ls_mes_fin 	= trim(idw_1.object.mes_nomb[idw_1.rowcount()])
ls_mensaje 	= 'Se va a recalcular el presupuesto para '
li_tipo = 2

if li_desde = li_hasta then
	ls_periodo = 'el mes ' + ls_mes_fin + ', año '+ ls_ano
else
	ls_periodo = 'el periodo ' + ls_mes_ini + ' - ' + ls_mes_fin+', año '+ ls_ano
end if

ls_mensaje 	= ls_mensaje + ls_periodo &
				+ '~r ¿Esta conforme con los datos mostrados?'

if messagebox('ADVERTENCIA', ls_mensaje ,Exclamation!,YesNo!,1) = 1 then
	idw_1.reset()
	dw_1.reset()

	if cbx_todos.checked then
		
	//create or replace procedure usp_fl_presup_compara(
	//       aii_tip_oper         in Integer, -- 1 consulta / 2 prceso
	//       aii_mes_ini          in Integer,
	//       aii_mes_fin          in Integer,
	//       aii_ano              in Integer, 
	//       asi_cod_usr          in String,
	//       aio_cuenta           out Integer,  -- -1 no hay registros / 1 visualizacion de registros
	//     	aso_mensaje 	      out varchar2,
	//       aio_ok      	      out number ) is
	
	
		declare usp_fl_presup_compara procedure for
			usp_fl_presup_compara( 	:li_tipo , 
											:li_desde, 
											:li_hasta, 
											:ll_ano  , 
											:gs_user );
	
		execute usp_fl_presup_compara;
	
		IF SQLCA.sqlcode = -1 THEN
			ls_mensaje = "PROCEDURE usp_fl_presup_compara: " + SQLCA.SQLErrText
			Rollback ;
			MessageBox('SQL error', ls_mensaje, StopSign!)	
			return
		END IF
	
		fetch usp_fl_presup_compara into :ll_cuenta, 
					:ls_mensaje, :li_ok;
		close usp_fl_presup_compara;
	
		if li_ok <> 1 then
			MessageBox('Error PROCEDURE usp_fl_presup_compara', ls_mensaje, StopSign!)	
			return
		end if
	
	else
		
		ls_nave = trim(right(ddlb_naves.text,10))
		
		//create or replace procedure usp_fl_presup_compara_nave(
		//       aii_tip_oper         in Integer, -- 1 consulta / 2 prceso
		//       aii_mes_ini          in Integer,
		//       aii_mes_fin          in Integer,
		//       aii_ano              in Integer,
		//       asi_nave             in String, 
		//       asi_cod_usr          in String,
		//   	   aso_mensaje 	      out varchar2,
		//       aio_ok      	      out number ) is
		
		declare usp_fl_presup_compara_nave procedure for
			usp_fl_presup_compara_nave(	:li_tipo , 
													:li_desde, 
													:li_hasta, 
													:ll_ano  , 
													:ls_nave , 
													:gs_user );
													
		execute usp_fl_presup_compara_nave;
	
		IF SQLCA.sqlcode = -1 THEN
			ls_mensaje = "PROCEDURE usp_fl_presup_compara_nave: " + SQLCA.SQLErrText
			Rollback ;
			MessageBox('SQL error', ls_mensaje, StopSign!)	
			return
		END IF
	
		fetch usp_fl_presup_compara_nave into :ls_mensaje, :li_ok;
					
		close usp_fl_presup_compara_nave;
	
		if li_ok <> 1 then
			MessageBox('Error PROCEDURE usp_fl_presup_compara_nave', ls_mensaje, StopSign!)	
			return
		end if
		
	end if

end if

messagebox('Flota','Proceso de recálculo presupuestal para ' + ls_periodo ,Exclamation!,Ok!)



end event

on w_fl906_presupuesto_varia.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.st_1=create st_1
this.em_year=create em_year
this.cbx_todos=create cbx_todos
this.ddlb_naves=create ddlb_naves
this.dw_1=create dw_1
this.ddlb_desde=create ddlb_desde
this.st_2=create st_2
this.ddlb_hasta=create ddlb_hasta
this.st_3=create st_3
this.pb_accept=create pb_accept
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_year
this.Control[iCurrent+3]=this.cbx_todos
this.Control[iCurrent+4]=this.ddlb_naves
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.ddlb_desde
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.ddlb_hasta
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.pb_accept
end on

on w_fl906_presupuesto_varia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.cbx_todos)
destroy(this.ddlb_naves)
destroy(this.dw_1)
destroy(this.ddlb_desde)
destroy(this.st_2)
destroy(this.ddlb_hasta)
destroy(this.st_3)
destroy(this.pb_accept)
end on

event ue_open_pre;call super::ue_open_pre;dw_1.settransobject(sqlca)
ii_lec_mst = 0
ii_help = 101            // help topic
ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
ib_log = TRUE
//is_tabla = 'Master'
//idw_query = dw_master

this.event dynamic ue_preview()

end event

event resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10

end event

event ue_query_retrieve;integer 	li_desde, li_hasta, li_tipo, li_ok
string 	ls_nave, ls_mensaje
datetime ldt_fecha
long 		ll_cuenta, ll_ano

select sysdate 
	into :ldt_fecha 
from dual;

ll_ano 	= long(em_year.text)
li_desde = integer(left(right(trim(ddlb_desde.text),3),2))
li_hasta = integer(left(right(trim(ddlb_hasta.text),3),2))
li_tipo 	= 1

commit;

idw_1.visible = true
dw_1.visible  = true
	
if cbx_todos.checked then
	
//create or replace procedure usp_fl_presup_compara(
//       aii_tip_oper         in Integer, -- 1 consulta / 2 prceso
//       aii_mes_ini          in Integer,
//       aii_mes_fin          in Integer,
//       aii_ano              in Integer, 
//       asi_cod_usr          in String,
//       aio_cuenta           out Integer,  -- -1 no hay registros / 1 visualizacion de registros
//     	aso_mensaje 	      out varchar2,
//       aio_ok      	      out number ) is


	declare usp_fl_presup_compara procedure for
		usp_fl_presup_compara( 	:li_tipo , 
										:li_desde, 
										:li_hasta, 
										:ll_ano  , 
										:gs_user );

	execute usp_fl_presup_compara;

	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE usp_fl_presup_compara: " + SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error', ls_mensaje, StopSign!)	
		return
	END IF

	fetch usp_fl_presup_compara into :ll_cuenta, 
				:ls_mensaje, :li_ok;
	close usp_fl_presup_compara;

	if li_ok <> 1 then
		MessageBox('Error PROCEDURE usp_fl_presup_compara', ls_mensaje, StopSign!)	
		return
	end if

else
	
	ls_nave = trim(right(ddlb_naves.text,10))
	
//	create or replace procedure usp_fl_presup_compara_nave(
//       aii_tip_oper         in Integer, -- 1 consulta / 2 prceso
//       aii_mes_ini          in Integer,
//       aii_mes_fin          in Integer,
//       aii_ano              in Integer,
//       asi_nave             in String, 
//       asi_cod_usr          in String,
//       aio_cuenta           out Integer,  -- -1 no hay registros / 1 visualizacion de registros
//   	   aso_mensaje 	      out varchar2,
//       aio_ok      	      out number ) is
//
	declare usp_fl_presup_compara_nave procedure for
		usp_fl_presup_compara_nave(	:li_tipo , 
												:li_desde, 
												:li_hasta, 
												:ll_ano  , 
												:ls_nave , 
												:gs_user );
												
	execute usp_fl_presup_compara_nave;

	IF SQLCA.sqlcode = -1 THEN
		ls_mensaje = "PROCEDURE usp_fl_presup_compara_nave: " + SQLCA.SQLErrText
		Rollback ;
		MessageBox('SQL error', ls_mensaje, StopSign!)	
		return
	END IF

	fetch usp_fl_presup_compara_nave into :ll_cuenta, 
				:ls_mensaje, :li_ok;
				
	close usp_fl_presup_compara_nave;

	if li_ok <> 1 then
		MessageBox('Error PROCEDURE usp_fl_presup_compara_nave', ls_mensaje, StopSign!)	
		return
	end if
	
end if


idw_1.Retrieve()
dw_1.retrieve()

idw_1.object.t_titulo.text = 'Y CENTRO DE COSTOS PARA EL AÑO ' + TRIM(STRING(ll_ano))
idw_1.Object.t_user.text   = 'Usuario: ' + trim(gs_user)
idw_1.Object.t_fecha.text  = 'Fecha: '+trim(string(ldt_fecha))

pb_accept.enabled = true
//this.windowstate = maximized!

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl906_presupuesto_varia
boolean visible = false
integer x = 5
integer y = 124
integer width = 3397
integer height = 968
string dataobject = "d_presup_compara_tbl"
borderstyle borderstyle = styleraised!
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type st_1 from statictext within w_fl906_presupuesto_varia
integer y = 24
integer width = 151
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
string text = "Año"
boolean focusrectangle = false
end type

type em_year from editmask within w_fl906_presupuesto_varia
integer x = 110
integer y = 16
integer width = 270
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "~~9999"
end type

event constructor;long ll_year_now
datetime ldt_date

select sysdate into :ldt_date from dual;
ll_year_now = year(date(ldt_date))
this.text = string(ll_year_now)

end event

event modified;long ll_year_now, ll_year_input
datetime ldt_date

select sysdate into :ldt_date from dual;

ll_year_now = year(date(ldt_date))
ll_year_input = long(this.text)
if ll_year_now > ll_year_input then
	messagebox('Flota','No se pueden alterar años anteriores',StopSign!)
	this.text = string(ll_year_now)
	return
end if
if cbx_todos.checked = false then
	ddlb_naves.event constructor()
end if
end event

type cbx_todos from checkbox within w_fl906_presupuesto_varia
integer x = 1641
integer y = 24
integer width = 453
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
string text = "Todas las naves"
boolean checked = true
end type

event clicked;if this.checked then
	ddlb_naves.enabled = false
else
	ddlb_naves.enabled = true
	ddlb_naves.event constructor()
end if
end event

type ddlb_naves from u_ddlb within w_fl906_presupuesto_varia
integer x = 2098
integer y = 16
integer width = 791
integer height = 1624
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
boolean enabled = false
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_nave_proyeccion_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 50                     // Longitud del campo 1
ii_lc2 = 10							// Longitud del campo 2

end event

event ue_item_add;Integer	li_index, li_x
Long     ll_rows
Any  		la_id
String	ls_item

if cbx_todos.checked = false then
	this.reset()
	ll_rows = ids_Data.Retrieve(real(trim(em_year.text)))
	for li_x = 1 to ll_rows
		la_id = ids_data.object.data.primary.current[li_x, ii_cn1]
		ls_item = of_cut_string(la_id, ii_lc1, '.')
		la_id = ids_data.object.data.primary.current[li_x, ii_cn2]
		ls_item = ls_item + of_cut_string(la_id, ii_lc2,'.')
		li_index = this.AddItem(ls_item)
		ia_key[li_index] = ids_data.object.data.primary.current[li_x, ii_ck]
	next
end if

end event

type dw_1 from u_dw_grf within w_fl906_presupuesto_varia
boolean visible = false
integer x = 14
integer y = 1096
integer width = 3387
integer height = 592
integer taborder = 20
string dataobject = "d_presup_compara_grf"
borderstyle borderstyle = stylebox!
end type

event doubleclicked;call super::doubleclicked;grObjectType lgr_click_obj
string   ls_planta, ls_grgraphname="gr_1", ls_find, ls_nave, ls_mes, ls_parametro, ls_cod_nave
int    li_series, li_category
Long    ll_rc, ll_row, ll_plantas
Decimal   ldc_total
 

lgr_click_obj = this.ObjectAtPointer (ls_grgraphname, li_series, li_category)

ls_nave = this.seriesname(ls_grgraphname,li_series)
if len(trim(ls_nave)) > 0 then
	if cbx_todos.checked then
		OpenWithParm(w_fl907_grafica_ppto_var, ls_nave)
	else
		ls_mes = trim(string(li_category,'00'))
		select nave into :ls_cod_nave from tg_naves where trim(nomb_nave) = :ls_nave;
		ls_parametro = ls_mes+ls_cod_nave
		OpenWithParm(w_fl908_grafica_ppto_compos, ls_parametro)
	end if
end if

end event

type ddlb_desde from dropdownlistbox within w_fl906_presupuesto_varia
integer x = 553
integer y = 16
integer width = 466
integer height = 1544
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"ENERO (01)","FEBREO (02)","MARZO (03)","ABRIL (04)","MAYO (05)","JUNIO (06)","JULIO (07)","AGOSTO (08)","SETIEMBRE (09)","OCTUBRE (10)","NOVIEMBRE (11)","DICIEMBRE (12)"}
borderstyle borderstyle = stylelowered!
end type

event constructor;THIS.SELECTITEM(1)
end event

event selectionchanged;integer li_desde, li_hasta
li_desde = integer(left(right(trim(ddlb_desde.text),3),2))
li_hasta = integer(left(right(trim(ddlb_hasta.text),3),2))
if li_desde > li_hasta then
	messagebox('Flota', 'Rango de fechas no válido...',StopSign!)
	ddlb_desde.selectitem(li_hasta)
end if
end event

type st_2 from statictext within w_fl906_presupuesto_varia
integer x = 375
integer y = 24
integer width = 178
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desde:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_hasta from dropdownlistbox within w_fl906_presupuesto_varia
integer x = 1175
integer y = 16
integer width = 466
integer height = 1544
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"ENERO (01)","FEBREO (02)","MARZO (03)","ABRIL (04)","MAYO (05)","JUNIO (06)","JULIO (07)","AGOSTO (08)","SETIEMBRE (09)","OCTUBRE (10)","NOVIEMBRE (11)","DICIEMBRE (12)"}
borderstyle borderstyle = stylelowered!
end type

event constructor;THIS.SELECTITEM(12)
end event

event selectionchanged;integer li_desde, li_hasta
li_desde = integer(left(right(trim(ddlb_desde.text),3),2))
li_hasta = integer(left(right(trim(ddlb_hasta.text),3),2))
if li_desde > li_hasta then
	messagebox('Flota', 'Rango de fechas no válido...',StopSign!)
	ddlb_hasta.selectitem(li_desde)
end if
end event

type st_3 from statictext within w_fl906_presupuesto_varia
integer x = 1019
integer y = 24
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hasta:"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_accept from picturebutton within w_fl906_presupuesto_varia
integer x = 2967
integer width = 347
integer height = 124
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string picturename = "h:\Source\BMP\procesar_enb.bmp"
string disabledname = "h:\Source\BMP\procesar_dsb.bmp"
alignment htextalign = left!
boolean map3dcolors = true
end type

event clicked;parent.event dynamic ue_procesar()
end event

