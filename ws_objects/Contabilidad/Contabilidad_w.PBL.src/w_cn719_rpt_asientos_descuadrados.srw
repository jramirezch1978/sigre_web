$PBExportHeader$w_cn719_rpt_asientos_descuadrados.srw
forward
global type w_cn719_rpt_asientos_descuadrados from w_report_smpl
end type
type st_2 from statictext within w_cn719_rpt_asientos_descuadrados
end type
type sle_ano from singlelineedit within w_cn719_rpt_asientos_descuadrados
end type
type st_3 from statictext within w_cn719_rpt_asientos_descuadrados
end type
type sle_mes from singlelineedit within w_cn719_rpt_asientos_descuadrados
end type
type cb_1 from commandbutton within w_cn719_rpt_asientos_descuadrados
end type
type cb_procesar from commandbutton within w_cn719_rpt_asientos_descuadrados
end type
type cb_mt from commandbutton within w_cn719_rpt_asientos_descuadrados
end type
type cb_dt from commandbutton within w_cn719_rpt_asientos_descuadrados
end type
type cb_is from commandbutton within w_cn719_rpt_asientos_descuadrados
end type
type gb_1 from groupbox within w_cn719_rpt_asientos_descuadrados
end type
end forward

global type w_cn719_rpt_asientos_descuadrados from w_report_smpl
integer width = 3410
integer height = 1760
string title = "Asientos descuadrados (CN719)"
string menuname = "m_abc_report_smpl"
st_2 st_2
sle_ano sle_ano
st_3 st_3
sle_mes sle_mes
cb_1 cb_1
cb_procesar cb_procesar
cb_mt cb_mt
cb_dt cb_dt
cb_is cb_is
gb_1 gb_1
end type
global w_cn719_rpt_asientos_descuadrados w_cn719_rpt_asientos_descuadrados

type variables
//String is_cencos_redondeo
end variables

forward prototypes
public subroutine of_update_asientos ()
end prototypes

public subroutine of_update_asientos ();n_cst_contabilidad 	lnvo_contabilidad

try 
	lnvo_contabilidad = create n_cst_contabilidad
	
	lnvo_contabilidad.of_update_asientos( )
	
	MessageBox('Aviso', 'Actualizacion de asientos contables realizado satisfactoriamente', Information!)
	
catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Error al actualizar las cabeceras de asientos')
	
finally
	destroy lnvo_contabilidad

end try
                           
end subroutine

on w_cn719_rpt_asientos_descuadrados.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.st_2=create st_2
this.sle_ano=create sle_ano
this.st_3=create st_3
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.cb_procesar=create cb_procesar
this.cb_mt=create cb_mt
this.cb_dt=create cb_dt
this.cb_is=create cb_is
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_mes
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_procesar
this.Control[iCurrent+7]=this.cb_mt
this.Control[iCurrent+8]=this.cb_dt
this.Control[iCurrent+9]=this.cb_is
this.Control[iCurrent+10]=this.gb_1
end on

on w_cn719_rpt_asientos_descuadrados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_ano)
destroy(this.st_3)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.cb_procesar)
destroy(this.cb_mt)
destroy(this.cb_dt)
destroy(this.cb_is)
destroy(this.gb_1)
end on

event ue_open_pre;//Override

String ls_origen, ls_ano, ls_mes

sle_ano.text = string( today(), 'yyyy')
sle_mes.text = string( today(), 'mm')


of_update_asientos( )

idw_1 = dw_report
idw_1.SetTransObject(sqlca)

//Cuenta contable de ajuste por redondeo
try
	
	//is_cnta_cntbl_redondeo = gnvo_app.of_get_parametro( 'CNTA_CNTBL AJSUTE REDONDEO', '97601101')
	
catch(Exception ex)
	MessageBox("Error", "Ha ocurrido una exception: " + ex.getMessage())
	
end try
end event

event ue_retrieve;call super::ue_retrieve;Integer li_year, li_mes

li_year = integer(sle_ano.text)
li_mes = integer(sle_mes.text)

dw_report.SetTransObject(sqlca)
dw_report.retrieve(li_year, li_mes)
cb_procesar.enabled = false

if dw_report.RowCount() > 0 then
	cb_mt.enabled = true
	cb_dt.enabled 	= true
	cb_is.enabled	= true
else
	cb_mt.enabled = false
	cb_dt.enabled 	= false
	cb_is.enabled	= false
end if





end event

type dw_report from w_report_smpl`dw_report within w_cn719_rpt_asientos_descuadrados
integer x = 0
integer y = 264
integer width = 3333
integer height = 1236
integer taborder = 50
string dataobject = "d_rpt_asientos_descuadrados_tbl"
end type

event dw_report::itemchanged;call super::itemchanged;Integer li_i, li_select

this.Accepttext( )


li_select = 0
for li_i = 1 to this.RowCount()
	if li_i = row then
		if data = '1' then
			li_select ++
		end if
	else
		if this.object.checked[li_i] = '1' then
			li_select ++
		end if
	end if
		
next

if li_select > 0 then
	cb_procesar.enabled = true
else
	cb_procesar.enabled = false
end if
end event

type st_2 from statictext within w_cn719_rpt_asientos_descuadrados
integer x = 32
integer y = 68
integer width = 155
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_cn719_rpt_asientos_descuadrados
integer x = 169
integer y = 68
integer width = 215
integer height = 72
integer taborder = 20
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

type st_3 from statictext within w_cn719_rpt_asientos_descuadrados
integer x = 398
integer y = 68
integer width = 155
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cn719_rpt_asientos_descuadrados
integer x = 571
integer y = 68
integer width = 123
integer height = 72
integer taborder = 30
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

type cb_1 from commandbutton within w_cn719_rpt_asientos_descuadrados
integer x = 1019
integer y = 52
integer width = 402
integer height = 176
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

event clicked;parent.event ue_retrieve( )
end event

type cb_procesar from commandbutton within w_cn719_rpt_asientos_descuadrados
integer x = 1426
integer y = 52
integer width = 402
integer height = 176
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Procesar"
end type

event clicked;Integer 		li_i, li_year, li_mes, li_nro_libro
Long			ll_nro_asiento, ll_item
String 		ls_origen, ls_flag_deb_hab, ls_cnta_cntbl_redondeo, ls_cencos_redondeo
Decimal		ldc_dif_sol, ldc_dif_dol
Date			ld_fec_cntbl

try 
	ls_cencos_redondeo = gnvo_app.of_get_parametro( 'CENCOS_AJUSTE_REDONDEO', '60100301')
	
	for li_i = 1 to idw_1.RowCount()
		if idw_1.object.checked [li_i] = '1' then
			//Inserto la linea que falta para ajustar el asiento
			
			//Obtengo el numero de voucher
			ls_origen 		= idw_1.object.origen 					[li_i]
			li_year			= Integer(idw_1.object.ano 			[li_i])
			li_mes			= Integer(idw_1.object.mes 			[li_i])
			li_nro_libro 	= Integer(idw_1.object.nro_libro 	[li_i])
			ll_nro_asiento	= Long(idw_1.object.nro_asiento 		[li_i])
			ld_fec_cntbl 	= Date(idw_1.object.FECHA_CNTBL		[li_i])
			
			//Obtengo la diferencia en soles y dolares
			ldc_dif_sol		= Dec(idw_1.object.dif_sol 			[li_i])
			ldc_dif_dol		= Dec(idw_1.object.dif_dol 			[li_i])
			
			if (ldc_dif_sol > 0 or ldc_dif_dol > 0) then
				ls_flag_deb_hab = 'H'
				ls_cnta_cntbl_redondeo = gnvo_app.of_get_parametro( 'CNTA_CNTBL AJSUTE REDONDEO HABER', '77731002')
			else
				ls_flag_deb_hab = 'D'
				ls_cnta_cntbl_redondeo = gnvo_app.of_get_parametro( 'CNTA_CNTBL AJSUTE REDONDEO DEBE', '96677132')
			end if
			
			
			
			//Obtengo el siguiente nro item
			select nvl(max(item), 0)
				into :ll_item
			from cntbl_asiento_det
			where origen 		= :ls_origen
			  and ano			= :li_year
			  and mes			= :li_mes
			  and nro_libro	= :li_nro_libro
			  and nro_asiento	= :ll_nro_asiento;
			
			//Incremento el nro de item
			ll_item ++
			
			//Inserto el detalle adicional al asiento
			insert into cntbl_asiento_det(
				origen, ano, mes, nro_libro, nro_asiento, item, 
				cnta_ctbl, fec_cntbl, det_glosa, flag_gen_aut, flag_debhab, 
				cencos, imp_movsol, imp_movdol)
			values(
				:ls_origen, :li_year, :li_mes, :li_nro_libro, :ll_nro_asiento, :ll_item,
				:ls_cnta_cntbl_redondeo, :ld_fec_cntbl, 'AJUSTE POR REDONDEO', '0', :ls_flag_deb_hab,
				:ls_cencos_redondeo, abs(:ldc_dif_sol), abs(:ldc_dif_dol));
			
			if gnvo_app.of_existserror( SQLCA, "No se pudo insertar datos en cntbl_asiento_det") then
				rollback;
				return;
			end if
			
				
			
		end if
	next
	
	commit;
	of_update_asientos( )
	
	parent.event ue_retrieve()
	
	MessageBox("Aviso", "Proceso terminado satisfactoriamente ", Information!)

catch ( Exception ex )
	gnvo_app.of_Catch_exception(ex, 'Error en proceso de asientos descuadrados')
	
end try

end event

type cb_mt from commandbutton within w_cn719_rpt_asientos_descuadrados
integer x = 27
integer y = 152
integer width = 320
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "M. Todos"
end type

event clicked;Long ll_row

for ll_row = 1 to dw_report.RowCount()
	dw_report.object.checked [ll_row] = '1'
next

if dw_report.RowCount() > 0 then
	cb_procesar.enabled = true
end if
end event

type cb_dt from commandbutton within w_cn719_rpt_asientos_descuadrados
integer x = 343
integer y = 152
integer width = 320
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "D. Todos"
end type

event clicked;Long ll_row

for ll_row = 1 to dw_report.RowCount()
	dw_report.object.checked [ll_row] = '0'
next

if dw_report.RowCount() > 0 then
	cb_procesar.enabled = false
end if
end event

type cb_is from commandbutton within w_cn719_rpt_asientos_descuadrados
integer x = 663
integer y = 152
integer width = 320
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "I. Selec"
end type

event clicked;Long ll_row, ll_i

ll_i = 0
for ll_row = 1 to dw_report.RowCount()
	if dw_report.object.checked [ll_row] = '1' then
		dw_report.object.checked [ll_row] = '0'
	else
		dw_report.object.checked [ll_row] = '1'
		ll_i ++
	end if
next

if ll_i > 0 then
	cb_procesar.enabled = true
end if
end event

type gb_1 from groupbox within w_cn719_rpt_asientos_descuadrados
integer width = 2519
integer height = 252
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

