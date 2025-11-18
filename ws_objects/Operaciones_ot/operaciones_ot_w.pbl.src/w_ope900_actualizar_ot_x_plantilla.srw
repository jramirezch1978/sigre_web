$PBExportHeader$w_ope900_actualizar_ot_x_plantilla.srw
forward
global type w_ope900_actualizar_ot_x_plantilla from w_prc
end type
type dw_factor from u_dw_abc within w_ope900_actualizar_ot_x_plantilla
end type
type em_factor from editmask within w_ope900_actualizar_ot_x_plantilla
end type
type st_2 from statictext within w_ope900_actualizar_ot_x_plantilla
end type
type cb_4 from commandbutton within w_ope900_actualizar_ot_x_plantilla
end type
type cb_3 from commandbutton within w_ope900_actualizar_ot_x_plantilla
end type
type cb_1 from commandbutton within w_ope900_actualizar_ot_x_plantilla
end type
type sle_nro_ot from u_sle_codigo within w_ope900_actualizar_ot_x_plantilla
end type
type st_1 from statictext within w_ope900_actualizar_ot_x_plantilla
end type
type cb_2 from commandbutton within w_ope900_actualizar_ot_x_plantilla
end type
type cb_procesar from commandbutton within w_ope900_actualizar_ot_x_plantilla
end type
end forward

global type w_ope900_actualizar_ot_x_plantilla from w_prc
integer width = 2094
integer height = 1396
string title = "[OPE900] Actualiza datos de OT, según factor de plantilla"
string menuname = "m_salir"
event ue_procesar ( )
dw_factor dw_factor
em_factor em_factor
st_2 st_2
cb_4 cb_4
cb_3 cb_3
cb_1 cb_1
sle_nro_ot sle_nro_ot
st_1 st_1
cb_2 cb_2
cb_procesar cb_procesar
end type
global w_ope900_actualizar_ot_x_plantilla w_ope900_actualizar_ot_x_plantilla

event ue_procesar();//usp_ope_act_ot_plant

//Date ld_fecha
//String ls_msj, ls_tipo_doc, ls_flag
//
//ld_fecha = uo_1.of_get_fecha()
//ls_flag	= left(ddlb_1.text,1)
//ls_tipo_doc = trim(sle_1.text)
//
//cb_procesar.enabled = false
//
////create or replace procedure USP_OPE_CIERRE_AMP(
////       asi_tipo_doc   IN doc_tipo.tipo_doc%TYPE,
////       adi_fecha      IN DATE,
////       asi_flag       IN VARCHAR2,
////       asi_user       IN usuario.cod_usr%TYPE
////) IS
//
//DECLARE USP_OPE_CIERRE_AMP PROCEDURE FOR 
//		USP_OPE_CIERRE_AMP ( :ls_tipo_doc,
//									:ld_fecha, 
//									:ls_flag,
//									:gs_user	);
//											  
//execute USP_OPE_CIERRE_AMP;
//
//IF sqlca.sqlcode = -1 Then
//	ls_msj = sqlca.sqlerrtext
//	rollback ;
//	MessageBox( 'Error USP_OPE_CIERRA_OPERACIONES', ls_msj, StopSign! )
//	return
//end if
//
//CLOSE USP_OPE_CIERRE_AMP;
//
//MessageBox( 'Mensaje', "Proceso terminado" )
//
//cb_procesar.enabled = true
//
end event

on w_ope900_actualizar_ot_x_plantilla.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.dw_factor=create dw_factor
this.em_factor=create em_factor
this.st_2=create st_2
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_1=create cb_1
this.sle_nro_ot=create sle_nro_ot
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_procesar=create cb_procesar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_factor
this.Control[iCurrent+2]=this.em_factor
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_4
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.sle_nro_ot
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.cb_procesar
end on

on w_ope900_actualizar_ot_x_plantilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_factor)
destroy(this.em_factor)
destroy(this.st_2)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_1)
destroy(this.sle_nro_ot)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_procesar)
end on

event open;call super::open;//string ls_doc_ot
//
//select doc_ot 
//	into :ls_doc_ot
//from logparam
//where reckey = '1';
//
//sle_1.text = ls_doc_ot
//
end event

event ue_open_pre;call super::ue_open_pre;dw_factor.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic

end event

type dw_factor from u_dw_abc within w_ope900_actualizar_ot_x_plantilla
integer x = 87
integer y = 232
integer width = 1906
integer height = 552
integer taborder = 40
string dataobject = "d_prod_plant_lanz_edit_factor_tbl"
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_factor

end event

type em_factor from editmask within w_ope900_actualizar_ot_x_plantilla
integer x = 1499
integer y = 88
integer width = 398
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = decimalmask!
string mask = "####,###.000"
end type

type st_2 from statictext within w_ope900_actualizar_ot_x_plantilla
integer x = 1157
integer y = 100
integer width = 329
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Factor nuevo:"
boolean focusrectangle = false
end type

type cb_4 from commandbutton within w_ope900_actualizar_ot_x_plantilla
integer x = 69
integer y = 1072
integer width = 951
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Genera variación presupuestal"
end type

event clicked;parent.event ue_procesar()
end event

type cb_3 from commandbutton within w_ope900_actualizar_ot_x_plantilla
integer x = 69
integer y = 960
integer width = 951
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Actualiza cantidades en función a factor"
end type

event clicked;Integer li, li_nro_oper, li_nro_plant, li_tot_plant
String ls_cod_plantilla, ls_nro_orden

IF dw_factor.GetRow()=0 THEN return

ls_nro_orden = TRIM(sle_nro_ot.text)

// Calculando el numero de operaciones de la OT
SELECT count(*) 
  INTO :li_nro_oper 
  FROM operaciones
 WHERE nro_orden = :ls_nro_orden;

// Calculando el numero de registros de la(s) plantilla(s)
SELECT count(*) 
  INTO :li_nro_plant
  FROM prod_plant_lanz ppl, plant_prod_oper ppo
 WHERE ppl.cod_plantilla = ppo.cod_plantilla
   AND ppl.nro_orden = :ls_nro_orden ;

IF li_nro_plant <> li_nro_oper then
	messagebox('No procede actualización', &
				  'Nro de registros de plantilla no coincide con Orden de Trabajo')
	Return -1
END IF 

// Procediendo a actualizar datos de ordne de trabajo
// en función a la(s) platilla(s)
FOR li=1 to dw_factor.GetRow()
	ls_cod_plantilla = dw_factor.object.cod_plantilla[li]
	ls_nro_orden	  = dw_factor.object.nro_orden[li]	

//	usp_ope_act_ot_plant(
//		as_cod_plantilla in plant_prod.cod_plantilla%type    ,
//		as_nro_orden     in operaciones.nro_orden%type       ,
//		an_factor        in number                           ,
	
NEXT

//parent.event ue_procesar()
//// Usar plantilla usp_ope_act_ot_plant
end event

type cb_1 from commandbutton within w_ope900_actualizar_ot_x_plantilla
integer x = 827
integer y = 88
integer width = 247
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;String ls_nro_ot
Decimal{3} ld_factor
Long ll_count

ls_nro_ot=TRIM(sle_nro_ot.text)

SELECT count(distinct(p.factor))
  INTO :ll_count 
  FROM prod_plant_lanz p
 WHERE p.nro_orden=:ls_nro_ot ;

IF ll_count=0 THEN
	MessageBox('Aviso','Orden de trabajo no tiene plantilla')
	sle_nro_ot.text = ''
	Return -1
END IF 
IF ll_count>1 THEN
	MessageBox('Orden de trabajo no tiene factores estandares','Regularizarize factores previamente')
	sle_nro_ot.text = ''	
	Return -1
END IF

// Capturando factor 
SELECT distinct(p.factor)
  INTO :ld_factor 
  FROM prod_plant_lanz p
 WHERE p.nro_orden=:ls_nro_ot ;

em_factor.text = String(ld_factor,'######.000')

dw_factor.Retrieve(ls_nro_ot)

Return 1

end event

type sle_nro_ot from u_sle_codigo within w_ope900_actualizar_ot_x_plantilla
integer x = 462
integer y = 88
integer width = 329
integer height = 84
integer taborder = 10
integer textsize = -8
textcase textcase = upper!
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type st_1 from statictext within w_ope900_actualizar_ot_x_plantilla
integer x = 82
integer y = 100
integer width = 389
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Orden Trabajo :"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_ope900_actualizar_ot_x_plantilla
integer x = 1618
integer y = 924
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Salir"
end type

event clicked;Close(Parent)
end event

type cb_procesar from commandbutton within w_ope900_actualizar_ot_x_plantilla
integer x = 69
integer y = 844
integer width = 951
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Actualiza solo factor"
end type

event clicked;Integer li, li_fin, li_nro_lanzamiento
String ls_cod_plantilla, ls_nro_orden
Decimal{3} ld_factor 

ld_factor = DEC(em_factor.text)

IF dw_factor.RowCount()=0 THEN return

dw_factor.AcceptText()

FOR li=1 to dw_factor.RowCount()
	dw_factor.object.factor[li] = ld_factor 
NEXT

dw_factor.update()

commit;
end event

