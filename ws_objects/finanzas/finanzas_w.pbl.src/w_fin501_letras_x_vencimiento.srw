$PBExportHeader$w_fin501_letras_x_vencimiento.srw
forward
global type w_fin501_letras_x_vencimiento from w_cns
end type
type cb_2 from commandbutton within w_fin501_letras_x_vencimiento
end type
type cb_1 from commandbutton within w_fin501_letras_x_vencimiento
end type
type dw_2 from datawindow within w_fin501_letras_x_vencimiento
end type
type dw_1 from datawindow within w_fin501_letras_x_vencimiento
end type
type dw_cns from u_dw_cns within w_fin501_letras_x_vencimiento
end type
type gb_1 from groupbox within w_fin501_letras_x_vencimiento
end type
end forward

global type w_fin501_letras_x_vencimiento from w_cns
integer x = 0
integer y = 0
integer width = 3616
integer height = 1700
string title = "Letras Por Fecha de Vencimiento ( FI501)"
string menuname = "m_consulta_print"
long backcolor = 12632256
integer ii_x = 0
event ue_saveas ( )
cb_2 cb_2
cb_1 cb_1
dw_2 dw_2
dw_1 dw_1
dw_cns dw_cns
gb_1 gb_1
end type
global w_fin501_letras_x_vencimiento w_fin501_letras_x_vencimiento

forward prototypes
public subroutine wf_insert_tt_cns ()
end prototypes

event ue_saveas();dw_cns.saveas( )
end event

public subroutine wf_insert_tt_cns ();Insert into tt_fin_proveedor_cns
SELECT CC.COD_RELACION                         ,
       PR.NOM_PROVEEDOR                        
  FROM CNTAS_COBRAR           CC ,
       DOC_PENDIENTES_CTA_CTE DP ,
       PROVEEDOR              PR 
 WHERE ((CC.COD_RELACION = DP.COD_RELACION   )  AND
        (CC.TIPO_DOC     = DP.TIPO_DOC       )  AND
        (CC.NRO_DOC      = DP.NRO_DOC        )) AND
       ((CC.COD_RELACION = PR.PROVEEDOR      )) AND
        (CC.TIPO_DOC     = (SELECT F.DOC_LETRA_COBRAR FROM FINPARAM F WHERE F.RECKEY = '1'))  AND
        (CC.FLAG_TIPO_LTR IS NOT NULL )       AND
     (((CC.COD_MONEDA   =  (SELECT COD_SOLES FROM LOGPARAM WHERE RECKEY = '1')   )    AND  
        (CC.SALDO_SOL     >  0                                                    ))   OR  
       ((CC.COD_MONEDA   =  (SELECT COD_DOLARES FROM LOGPARAM WHERE RECKEY = '1') )    AND  
        (CC.SALDO_DOL    >  0                                                     )) ) 
GROUP BY CC.COD_RELACION  ,
         PR.NOM_PROVEEDOR                        

UNION
SELECT CP.COD_RELACION                         ,
       PR.NOM_PROVEEDOR                        
  FROM CNTAS_PAGAR           CP ,
       DOC_PENDIENTES_CTA_CTE DP ,
       PROVEEDOR              PR 
 WHERE ((CP.COD_RELACION = DP.COD_RELACION   )  AND
        (CP.TIPO_DOC     = DP.TIPO_DOC       )  AND
        (CP.NRO_DOC      = DP.NRO_DOC        )) AND
       ((CP.COD_RELACION = PR.PROVEEDOR      )) AND
        (CP.TIPO_DOC     = (SELECT F.DOC_LETRA_PAGAR FROM FINPARAM F WHERE F.RECKEY = '1'))  AND       
        (CP.FLAG_TIPO_LTR IS NOT NULL )               AND
     (((CP.COD_MONEDA   =  (SELECT COD_SOLES FROM LOGPARAM WHERE RECKEY = '1')   )    AND  
        (CP.SALDO_SOL     >  0                                                    ))   OR  
       ((CP.COD_MONEDA   =  (SELECT COD_DOLARES FROM LOGPARAM WHERE RECKEY = '1') )    AND  
        (CP.SALDO_DOL    >  0                                                     )) ) 
GROUP BY CP.COD_RELACION  ,
         PR.NOM_PROVEEDOR                        ;


end subroutine

on w_fin501_letras_x_vencimiento.create
int iCurrent
call super::create
if this.MenuName = "m_consulta_print" then this.MenuID = create m_consulta_print
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_2=create dw_2
this.dw_1=create dw_1
this.dw_cns=create dw_cns
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_2
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_cns
this.Control[iCurrent+6]=this.gb_1
end on

on w_fin501_letras_x_vencimiento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.dw_cns)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_cns.width  = newwidth  - dw_cns.x - 50
dw_cns.height = newheight - dw_cns.y - 50
end event

event ue_open_pre();call super::ue_open_pre;dw_cns.SetTransObject(sqlca)
idw_1 = dw_cns              // asignar dw corriente
// ii_help = 101           // help topic
of_position_window(0,0)        // Posicionar la ventana en forma fija


/*Preview de Datawindow*/
dw_cns.Modify("DataWindow.Print.Preview=Yes")
dw_cns.Modify("datawindow.print.preview.zoom = 100 " )
SetPointer(hourglass!)


/*Logo de Aipsa*/
idw_1.Object.p_logo.filename = gs_logo
end event

event ue_filter;call super::ue_filter;
idw_1.Event ue_filter()
idw_1.groupcalc( )
end event

type cb_2 from commandbutton within w_fin501_letras_x_vencimiento
integer x = 3150
integer y = 208
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Proveedor"
end type

event clicked;Long ll_count
str_parametros sl_param 





Rollback ;
//llena tabla temporal
wf_insert_tt_cns ()



sl_param.dw1		= 'd_lista_cns_prov_letras_tbl'
sl_param.titulo	= 'Proveedor '
sl_param.opcion   = 1
sl_param.db1 		= 1600
sl_param.string1 	= '1RPP'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)


end event

type cb_1 from commandbutton within w_fin501_letras_x_vencimiento
integer x = 3150
integer y = 332
integer width = 402
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_tip_letra,ls_fecha_inicio,ls_fecha_final,ls_origen,ls_trep
Long   ll_count

dw_1.Accepttext()
dw_2.Accepttext()

ls_fecha_inicio = String(dw_1.object.ad_fecha_inicio [1],'yyyymmdd')
ls_fecha_final	 = String(dw_1.object.ad_fecha_final  [1],'yyyymmdd')
ls_origen		 = dw_1.object.as_origen	  	    [1]
ls_tip_letra  	 = Trim(dw_2.object.as_flag_letra [1])
ls_trep			 = dw_1.object.t_rep					 [1]

/*Verifica Proveedores*/
SELECT Count(*)
  INTO :ll_count
  FROM tt_fin_proveedor ;

IF ll_count  = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Proveedor')	
	Return
END IF
	  
/**/


IF Isnull(ls_fecha_inicio) OR Trim(ls_fecha_inicio) = '00000000' THEN
	Messagebox('Aviso','Debe Ingresar Fecha de Inicio')	
	dw_1.SetFocus()
	dw_1.SetColumn('ad_fecha_inicio')
	Return
END IF

IF Isnull(ls_fecha_final) OR Trim(ls_fecha_final) = '00000000' THEN
	Messagebox('Aviso','Debe Ingresar Fecha Final')	
	dw_1.SetFocus()
	dw_1.SetColumn('ad_fecha_final')
	Return
END IF

IF Isnull(ls_trep) OR Trim(ls_trep) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Reporte')	
	Return
END IF
IF Isnull(ls_origen) OR Trim(ls_origen) = '' THEN
	ls_origen = '%'  /*Todos los origenes */
END IF

IF ls_trep = '1' THEN
	
	if ls_tip_letra = 'C' THEN
		dw_cns.dataobject = 'd_cns_letras_x_cobrar_x_venc_tbl'
	else
		dw_cns.dataobject = 'd_cns_letras_x_pagar_x_venc_tbl'
		
	end if



ELSEIF ls_trep = '2'  THEN
	Messagebox('Aviso','Opcion no habilitada ')	
	return
//	dw_cns.dataobject = 'd_cns_letras_x_cobrar_x_venc_x_prov_tbl'	
END IF

Parent.TriggerEvent('ue_open_pre')

idw_1.Retrieve(ls_fecha_inicio,ls_fecha_final,ls_origen,gs_empresa,gs_user)
//idw_1.SetFilter('tdoc = '+"'"+ls_tip_letra+"'")
//idw_1.Filter()
end event

type dw_2 from datawindow within w_fin501_letras_x_vencimiento
integer x = 2025
integer y = 36
integer width = 718
integer height = 176
integer taborder = 30
string title = "none"
string dataobject = "d_opcion_letras_tbl"
boolean border = false
boolean livescroll = true
end type

event constructor;SettransObject(sqlca)
InsertRow(0)
end event

event itemerror;Return 1
end event

type dw_1 from datawindow within w_fin501_letras_x_vencimiento
integer x = 50
integer y = 76
integer width = 1403
integer height = 336
integer taborder = 20
string title = "none"
string dataobject = "d_argumentos_letras_x_venc_tbl"
boolean border = false
boolean livescroll = true
end type

event constructor;SettransObject(sqlca)
InsertRow(0)
end event

event doubleclicked;Datawindow		 ldw	
str_seleccionar lstr_seleccionar



CHOOSE CASE dwo.name
		 CASE 'ad_fecha_inicio'
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)		
		 CASE 'ad_fecha_final'
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)						
		 CASE 'as_cod_relacion'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO_PROVEEDOR ,'&
								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES ,'&
								   					 +'PROVEEDOR.EMAIL			  AS EMAIL '&
									   				 +'FROM PROVEEDOR '&

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = 'aceptar' THEN
					Setitem(row,'as_cod_relacion',lstr_seleccionar.param1[1])
					Setitem(row,'as_nom_relacion',lstr_seleccionar.param2[1])
				END IF
				
							
END CHOOSE


end event

event itemerror;Return 1
end event

event itemchanged;String ls_nom_prov

Accepttext()

CHOOSE CASE dwo.name
		 CASE 'as_cod_relacion'
				SELECT nom_proveedor
				  INTO :ls_nom_prov
				  FROM proveedor pv
				 WHERE (pv.proveedor = :data) ;
				 
				IF Isnull(ls_nom_prov) OR Trim(ls_nom_prov) = '' THEN
					Messagebox('Aviso','Proveedor No Existe')	
					This.Object.as_cod_relacion [row] = ''
					This.Object.as_nom_relacion [row] = ''
					Return 1
				ELSE
					This.Object.as_nom_relacion [row] = ls_nom_prov
				END IF
END CHOOSE

end event

type dw_cns from u_dw_cns within w_fin501_letras_x_vencimiento
event ue_saveas ( )
integer x = 5
integer y = 464
integer width = 3557
integer height = 696
integer taborder = 0
string dataobject = "d_cns_letras_x_cobrar_x_venc_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
string is_dwform = ""
string is_mastdet = ""
end type

event ue_saveas();idw_1.saveas( )
end event

event constructor;call super::constructor;ii_ck [1] = 1
end event

type gb_1 from groupbox within w_fin501_letras_x_vencimiento
integer x = 23
integer y = 8
integer width = 1440
integer height = 432
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Busqueda"
end type

