$PBExportHeader$w_ma505_recor_mant.srw
forward
global type w_ma505_recor_mant from w_cns
end type
type st_desfil from statictext within w_ma505_recor_mant
end type
type dw_tip_manten from datawindow within w_ma505_recor_mant
end type
type dw_filtro from datawindow within w_ma505_recor_mant
end type
type dw_consulta_res from u_dw_cns within w_ma505_recor_mant
end type
type dw_consulta_det from u_dw_cns within w_ma505_recor_mant
end type
type uo_fechas from u_ingreso_rango_fechas within w_ma505_recor_mant
end type
type cb_1 from commandbutton within w_ma505_recor_mant
end type
type gb_1 from groupbox within w_ma505_recor_mant
end type
type gb_2 from groupbox within w_ma505_recor_mant
end type
end forward

global type w_ma505_recor_mant from w_cns
integer width = 3639
integer height = 2024
string title = "Record de Mantenimiento (MA505)"
string menuname = "m_cns_smpl_print"
st_desfil st_desfil
dw_tip_manten dw_tip_manten
dw_filtro dw_filtro
dw_consulta_res dw_consulta_res
dw_consulta_det dw_consulta_det
uo_fechas uo_fechas
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_ma505_recor_mant w_ma505_recor_mant

type variables
String is_filtro_maq,is_filtro_cc
end variables

on w_ma505_recor_mant.create
int iCurrent
call super::create
if this.MenuName = "m_cns_smpl_print" then this.MenuID = create m_cns_smpl_print
this.st_desfil=create st_desfil
this.dw_tip_manten=create dw_tip_manten
this.dw_filtro=create dw_filtro
this.dw_consulta_res=create dw_consulta_res
this.dw_consulta_det=create dw_consulta_det
this.uo_fechas=create uo_fechas
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_desfil
this.Control[iCurrent+2]=this.dw_tip_manten
this.Control[iCurrent+3]=this.dw_filtro
this.Control[iCurrent+4]=this.dw_consulta_res
this.Control[iCurrent+5]=this.dw_consulta_det
this.Control[iCurrent+6]=this.uo_fechas
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_ma505_recor_mant.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_desfil)
destroy(this.dw_tip_manten)
destroy(this.dw_filtro)
destroy(this.dw_consulta_res)
destroy(this.dw_consulta_det)
destroy(this.uo_fechas)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)  
//Help
ii_help = 505

dw_consulta_det.SettransObject(SQLCA)
dw_consulta_res.SettransObject(SQLCA)
dw_consulta_res.Modify("DataWindow.Print.Preview=Yes")


uo_fechas.of_set_label("Desde","Hasta")
uo_fechas.of_set_fecha(TODAY(),TODAY())
uo_fechas.of_set_rango_inicio(DATE('01/01/1900'))
uo_fechas.of_set_rango_fin(DATE('31/12/9999'))
end event

event resize;call super::resize;dw_consulta_res.width  = newwidth  - dw_consulta_res.x - 10
dw_consulta_res.height = newheight - dw_consulta_res.y - 10
end event

event ue_print();call super::ue_print;dw_consulta_res.TriggerEvent('ue_print')
end event

type st_desfil from statictext within w_ma505_recor_mant
integer x = 18
integer y = 220
integer width = 1449
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type dw_tip_manten from datawindow within w_ma505_recor_mant
integer x = 1536
integer y = 92
integer width = 1993
integer height = 172
integer taborder = 50
string title = "none"
string dataobject = "d_cons_t_mant_ext"
boolean border = false
boolean livescroll = true
end type

event constructor;SettransObject(sqlca)
InsertRow(0)
end event

type dw_filtro from datawindow within w_ma505_recor_mant
integer x = 46
integer y = 92
integer width = 1394
integer height = 84
integer taborder = 40
string title = "none"
string dataobject = "d_cons_record_mant_ext"
boolean border = false
boolean livescroll = true
end type

event constructor;SettransObject(sqlca)
InsertRow(0)
end event

event doubleclicked;String ls_data
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
CHOOSE CASE dwo.name
		 CASE 'ind_param'
				ls_data = This.Object.ind_param[row]
				CHOOSE CASE ls_data
						 CASE 'M'
								lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO,'&
		      														 +'MAQUINA.DESC_MAQ AS DESCRIPCION, '&     	
																		 +'MAQUINA.TIPO_MAQUINA AS TIPO_MAQUINA '&
													 		   		 +'FROM MAQUINA '

								OpenWithParm(w_seleccionar,lstr_seleccionar)
 								IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
								IF lstr_seleccionar.s_action = "aceptar" THEN
									is_filtro_maq 	= lstr_seleccionar.param1[1]
									is_filtro_cc   = '%'
									st_desfil.text = lstr_seleccionar.param2[1]
								END IF

						 CASE 'C'
								lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CODIGO,'&
																		 +'CENTROS_COSTO.COD_ORIGEN AS ORIGEN,'&
		      														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&     	
													 		   		 +'FROM CENTROS_COSTO '

								OpenWithParm(w_seleccionar,lstr_seleccionar)
 								IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
								IF lstr_seleccionar.s_action = "aceptar" THEN
									is_filtro_cc 	= lstr_seleccionar.param1[1]
									is_filtro_maq	= '%'
									st_desfil.text = lstr_seleccionar.param3[1]
								END IF							

				END CHOOSE

		
END CHOOSE




									  
									  

end event

event itemchanged;Accepttext()
is_filtro_cc  = ''
is_filtro_maq = ''
st_desfil.text = ''
end event

type dw_consulta_res from u_dw_cns within w_ma505_recor_mant
integer x = 18
integer y = 876
integer width = 3534
integer height = 932
integer taborder = 20
string dataobject = "d_cons_record_mant_det_tbl"
end type

event constructor;call super::constructor; ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

type dw_consulta_det from u_dw_cns within w_ma505_recor_mant
integer x = 18
integer y = 404
integer width = 2030
integer height = 464
boolean bringtotop = true
string dataobject = "d_cons_record_mant_res_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
end event

event itemerror;call super::itemerror;return 1
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event clicked;call super::clicked;String ls_condicion,ls_flag

CHOOSE CASE dwo.name
		 CASE 'flag_manten'
				ls_flag = dw_consulta_det.Object.flag_manten[row]
				ls_condicion = 'flag_manten = '+"'"+ls_flag+"'"
				dw_consulta_res.SetFilter(ls_condicion)
				dw_consulta_res.Filter()
END CHOOSE


end event

type uo_fechas from u_ingreso_rango_fechas within w_ma505_recor_mant
integer x = 27
integer y = 308
integer taborder = 30
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_ma505_recor_mant
integer x = 3214
integer y = 324
integer width = 357
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_filtro,ls_tip_manten,ls_condicion 
Date	 ld_fec_ini,ld_fec_fin

ls_filtro     = dw_filtro.Object.ind_param[1]
ls_tip_manten = dw_tip_manten.Object.ind_param2[1]


IF Isnull(ls_filtro) OR trim(ls_filtro) = '' THEN
	Messagebox('Aviso','Debe Ingresar Un Tipo de Filtro')
	Return
ELSE
	IF ls_filtro = 'T' THEN
		is_filtro_cc  = '%'
		is_filtro_maq = '%'
	ELSEIF ls_filtro = 'M' THEN
		IF Isnull(is_filtro_maq) OR trim(is_filtro_maq) = '' THEN
			Messagebox('Aviso','Debe Ingresar Un Tipo de Maquina')
			Return
		END IF
	ELSEIF ls_filtro = 'C' THEN
		IF Isnull(is_filtro_cc) OR trim(is_filtro_cc) = '' THEN
			Messagebox('Aviso','Debe Ingresar Un Centro de Costo')
			Return
		END IF
	END IF

END IF

IF Isnull(ls_tip_manten) OR trim(ls_tip_manten) = '' THEN
	Messagebox('Aviso','Debe Ingresar Un tipo de Mantenimiento')	
	Return
END IF


ld_fec_ini   = uo_fechas.of_get_fecha1()
ld_fec_fin   = uo_fechas.of_get_fecha2()
ls_condicion = 'flag_manten = '+"'"+' '+"'"



DECLARE pb_usp_add_record_mantenimiento PROCEDURE FOR USP_MTT_ADD_RECORD_MTTO(  
        :ld_fec_ini, :ld_fec_fin);
EXECUTE pb_usp_add_record_mantenimiento ;	

dw_consulta_det.Retrieve(is_filtro_maq,is_filtro_cc,ls_tip_manten)
dw_consulta_res.Retrieve(is_filtro_maq,is_filtro_cc,ls_tip_manten,gs_empresa,gs_user)
dw_consulta_res.Object.p_logo.filename = gs_logo
dw_consulta_res.SetFilter(ls_condicion)
dw_consulta_res.Filter()
ROLLBACK;
end event

type gb_1 from groupbox within w_ma505_recor_mant
integer x = 9
integer y = 20
integer width = 1467
integer height = 180
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrado Por"
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_ma505_recor_mant
integer x = 1522
integer y = 20
integer width = 2053
integer height = 284
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipos de Mantenimiento"
borderstyle borderstyle = stylelowered!
end type

