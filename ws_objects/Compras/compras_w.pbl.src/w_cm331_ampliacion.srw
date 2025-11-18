$PBExportHeader$w_cm331_ampliacion.srw
forward
global type w_cm331_ampliacion from w_abc
end type
type st_1 from statictext within w_cm331_ampliacion
end type
type cb_1 from commandbutton within w_cm331_ampliacion
end type
type sle_nro_oc from singlelineedit within w_cm331_ampliacion
end type
type dw_master from u_dw_abc within w_cm331_ampliacion
end type
end forward

global type w_cm331_ampliacion from w_abc
integer width = 3986
integer height = 1608
string title = "Variaciones (CM331)"
string menuname = "m_save_exit"
st_1 st_1
cb_1 cb_1
sle_nro_oc sle_nro_oc
dw_master dw_master
end type
global w_cm331_ampliacion w_cm331_ampliacion

forward prototypes
public function boolean wf_update_log (string as_org_amp, long al_nro_amp, string as_org_oc, long al_nro_oc, decimal adc_cant_original, decimal adc_cant_variacion)
public function boolean wf_update_amp_ot (string as_cod_origen, long al_nro_mov, decimal adc_cant_variacion)
public function boolean wf_update_total_oc (string as_nro_oc)
end prototypes

public function boolean wf_update_log (string as_org_amp, long al_nro_amp, string as_org_oc, long al_nro_oc, decimal adc_cant_original, decimal adc_cant_variacion);String   ls_msj_err
Datetime ldt_fecha_actual
Boolean  lb_ret = TRUE

select sysdate into :ldt_fecha_actual from dual ;

Insert Into log_var_amp_oc 
(org_amp    	,nro_amp    ,fecha   ,
 org_oc_det 	,nro_oc_det ,cod_usr ,
 cant_original ,cant_variacion )
Values
(:as_org_amp        ,:al_nro_amp ,:ldt_fecha_actual,
 :as_org_oc         ,:al_nro_oc  ,:gs_user	      ,
 :adc_cant_original ,:adc_cant_variacion);
 
 

IF SQLCA.SQLCode = -1 THEN
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error',ls_msj_err)
	lb_ret = FALSE
END IF

Return lb_ret 
end function

public function boolean wf_update_amp_ot (string as_cod_origen, long al_nro_mov, decimal adc_cant_variacion);String  ls_msj_err,ls_flag_mod
Boolean lb_ret = TRUE,lb_mod = FALSE



//realizar modificacion
select amp.flag_modificacion into :ls_flag_mod from articulo_mov_proy amp
 where (amp.cod_origen = :as_cod_origen ) and
 		 (amp.nro_mov    = :al_nro_mov    ) ;

if ls_flag_mod = '0' then //NO MODIFICABLE
	update articulo_mov_proy amp set amp.flag_modificacion= '1' 
	 where (amp.cod_origen = :as_cod_origen ) and
	 		 (amp.nro_mov	  = :al_nro_mov	 ) ;
			  
	IF SQLCA.SQLCode = -1 THEN 
		ls_msj_err = SQLCA.SQLErrText
		Rollback ;
	   MessageBox('SQL error', ls_msj_err )
		lb_ret = FALSE
	END IF		  
			  
	lb_mod = TRUE		  
end if

//orden trabajo
Update articulo_mov_proy amp
   set amp.cant_proyect = :adc_cant_variacion
 where (amp.cod_origen = :as_cod_origen) and
 		 (amp.nro_mov	  = :al_nro_mov	) ;


IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error', ls_msj_err )
	lb_ret = FALSE
END IF		  


IF lb_mod THEN
	//CAMBIAR ESTADO DE MODIFICACION
	update articulo_mov_proy amp set amp.flag_modificacion= '0' 
	 where (amp.cod_origen = :as_cod_origen ) and
	 		 (amp.nro_mov	  = :al_nro_mov	 ) ;
			  
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_msj_err = SQLCA.SQLErrText
		Rollback ;
	   MessageBox('SQL error', ls_msj_err )
		lb_ret = FALSE
	END IF		  
	
	
END IF			  

		  
	
	

Return lb_ret
end function

public function boolean wf_update_total_oc (string as_nro_oc);Boolean lb_ret     = TRUE
String  ls_msj_err
Decimal ldc_total_ot


DECLARE PB_USP_CMP_TOTAL_OT PROCEDURE FOR USP_CMP_TOTAL_OT
(:as_nro_oc);
EXECUTE PB_USP_CMP_TOTAL_OT ;


IF SQLCA.SQLCode = -1 THEN 
   ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	lb_ret = FALSE
	MessageBox('SQL error', ls_msj_err)
	GOTO SALIDA
END IF

		 
FETCH PB_USP_CMP_TOTAL_OT INTO :ldc_total_ot ;
CLOSE PB_USP_CMP_TOTAL_OT ;



//actualiza total de orden de compra
UPDATE orden_compra oc
   SET oc.monto_total = :ldc_total_ot
 WHERE (oc.nro_oc = :as_nro_oc);

IF SQLCA.SQLCode = -1 THEN 
   ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	lb_ret = FALSE
	MessageBox('SQL error', ls_msj_err)
	GOTO SALIDA
END IF 



SALIDA:

Return lb_ret


end function

on w_cm331_ampliacion.create
int iCurrent
call super::create
if this.MenuName = "m_save_exit" then this.MenuID = create m_save_exit
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_nro_oc=create sle_nro_oc
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_nro_oc
this.Control[iCurrent+4]=this.dw_master
end on

on w_cm331_ampliacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_nro_oc)
destroy(this.dw_master)
end on

event ue_update_pre;call super::ue_update_pre;String  ls_origen,ls_origen_oc ,ls_msj_err,ls_nro_oc
Long    ll_inicio,ll_nro_mov,ll_nro_mov_oc
Decimal {4} ldc_cant_proy   ,ldc_cant_var     ,ldc_cant_may_var,ldc_cant_proc,ldc_cant_var_ot,&
				ldc_cant_var_oc ,ldc_cant_proy_oc ,ldc_cant_proy_act
Decimal {2} ldc_fact_var
dwItemStatus ldis_status


select Nvl(l.frac_var_amp,0.0000) into :ldc_fact_var from logparam l where l.reckey = '1';


For ll_inicio = 1 to dw_master.rowcount()
	 ls_origen	   	= dw_master.object.org_amp_ref    [ll_inicio]
	 ll_nro_mov	   	= dw_master.object.nro_amp_ref    [ll_inicio]
	 ls_origen_oc  	= dw_master.object.cod_origen     [ll_inicio]
	 ll_nro_mov_oc 	= dw_master.object.nro_mov        [ll_inicio]
	 ldc_cant_var  	= dw_master.object.variacion	    [ll_inicio]
	 ldc_cant_proy_oc	= dw_master.object.cant_proyect   [ll_inicio]
	 ldc_cant_proc 	= dw_master.object.cant_procesada [ll_inicio]
	 ls_nro_oc			= dw_master.object.nro_doc			 [ll_inicio]
	 
	 ldis_status = dw_master.GetItemStatus( ll_inicio, 'variacion', Primary!)
	 
	 IF Isnull(ldc_cant_var) THEN ldc_cant_var = 0.0000
	 
	 ldc_cant_var_ot = 0.0000
	 ldc_cant_var_oc = 0.0000
	 
	 
	 IF ldis_status = DataModified! THEN
		 if  ldc_cant_var <> 0 then	  
			  DECLARE PB_usf_cmp_log_var_oc PROCEDURE FOR usf_cmp_log_var_oc 
			  (:ls_origen ,:ll_nro_mov);
			  EXECUTE PB_usf_cmp_log_var_oc ;


			  IF SQLCA.SQLCode = -1 THEN 
				  ls_msj_err = SQLCA.SQLErrText
				  Rollback ;
				  ib_update_check = FALSE
	           MessageBox('SQL error', ls_msj_err)
				  GOTO SALIDA
			  END IF
		 
			  FETCH PB_usf_cmp_log_var_oc INTO :ldc_cant_proy ;
		 	  CLOSE PB_usf_cmp_log_var_oc ;
				
		 end if 

    	 //RECUPERA CANTIDAD PROYECTADA ACTUAL
		 select amp.cant_proyect into :ldc_cant_proy_act from articulo_mov_proy amp 
		  where amp.cod_origen = :ls_origen  and
				  amp.nro_mov	  = :ll_nro_mov ;

		 //verificar porcentaje ...si es positivo el cambio
		 ldc_cant_may_var = Round( ldc_cant_proy * ldc_fact_var,4) + (ldc_cant_proy  - ldc_cant_proy_act)
		 
		 IF ldc_cant_var > ldc_cant_may_var THEN //VARIACION NO PUEDE SER MAYO A PORCENTAJE
		 	 Messagebox('Aviso','Variacion de Nro de Mov '+ls_origen+' '+Trim(String(ll_nro_mov))+' No puede ser Mayor de Acuerdo a factores de Variación ')
		    ib_update_check = FALSE
			 GOTO SALIDA
		 ELSEIF ldc_cant_var > 0 THEN
			 //ACTUALIZA LOG
 			 IF wf_update_log(ls_origen,ll_nro_mov,ls_origen_oc,ll_nro_mov_oc,ldc_cant_proy_ACT,ldc_cant_var) = FALSE THEN
				 ib_update_check = FALSE
				 GOTO SALIDA
			 END IF
			 
		
			 
			 //cantidad de variacion de ot
			 ldc_cant_var_ot = ldc_cant_proy_act  + ldc_cant_var			 
			 //cantidad de variacion de oc
			 ldc_cant_var_oc = ldc_cant_proy_oc + ldc_cant_var			 			 
			 
			 //ACTUALIZA MOVIMIENTO DE ORDEN DE TRABAJO
			 IF wf_update_amp_ot (ls_origen ,ll_nro_mov ,ldc_cant_var_ot) = FALSE THEN
				 ib_update_check = FALSE
				 GOTO SALIDA
			 END IF
			 
			 //ACTUALIZA MOVIMIENTO DE ORDEN DE COMPRA
			 IF wf_update_amp_oT  (ls_origen_OC ,ll_nro_mov_OC ,ldc_cant_var_oc) = FALSE THEN
				 ib_update_check = FALSE
				 GOTO SALIDA
			 END IF
			 
			 //ACTUALIZA TOTAL DE ORDEN DE COMPRA

			 IF wf_update_total_oc (ls_nro_oc) = FALSE THEN
				 ib_update_check = FALSE
				 GOTO SALIDA
			 END IF
			 
		 ELSEIF ldc_cant_var < 0 THEN
			 //ACTUALIZA LOG
 			 IF wf_update_log(ls_origen,ll_nro_mov,ls_origen_oc,ll_nro_mov_oc,ldc_cant_proy_ACT,ldc_cant_var) = FALSE THEN
				 ib_update_check = FALSE
				 GOTO SALIDA
			 END IF
			 
		
			 //
			 
		 	 //cantidad de variacion de ot
			 ldc_cant_var_ot = ldc_cant_proy_act + ldc_cant_var			 
			 //cantidad de variacion de oc
			 ldc_cant_var_oc = ldc_cant_proy_oc  + ldc_cant_var	
			 
			 
			 IF ldc_cant_var_ot < ldc_cant_proy OR ldc_cant_var_oc < ldc_cant_proc THEN
				 Messagebox('Aviso','Variacion de Nro de Mov '+ls_origen+' '+Trim(String(ll_nro_mov))+' No puede ser Menor que cantidad Proyectada Original ')				 	 
				 ib_update_check = FALSE
				 GOTO SALIDA
			 ELSE
				 //ACTUALIZA MOVIMIENTO DE ORDEN DE COMPRA
			    IF wF_update_amp_oT  (ls_origen_OC ,ll_nro_mov_OC ,ldc_cant_var_oc) = FALSE THEN
				 	 ib_update_check = FALSE
					 GOTO SALIDA
				 END IF
			    //ACTUALIZA MOVIMIENTO DE ORDEN DE TRABAJO
			    IF wf_update_amp_ot (ls_origen ,ll_nro_mov ,ldc_cant_var_ot) = FALSE THEN
					 ib_update_check = FALSE
					 GOTO SALIDA					 
				 END IF
				 
			 	 //ACTUALIZA TOTAL DE ORDEN DE COMPRA
				 IF wf_update_total_oc (ls_nro_oc) = FALSE THEN
					 ib_update_check = FALSE
					 GOTO SALIDA
			 	 END IF
				  
			 END IF
			 
			 
		 END IF
		 
	 END IF
	 
	 
	 
	 
	 
Next	


SALIDA:
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF lbo_ok THEN
	COMMIT using SQLCA;
	Messagebox('Aviso','Se Grabo Satisfactoriamente ')
END IF

cb_1.event clicked()
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos

idw_1 = dw_master 
of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event resize;call super::resize;
dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type st_1 from statictext within w_cm331_ampliacion
integer x = 32
integer y = 32
integer width = 215
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro. OC :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cm331_ampliacion
integer x = 704
integer y = 12
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_doc_oc,ls_nro_oc

select doc_oc into :ls_doc_oc from logparam where reckey = '1' ;



ls_nro_oc = sle_nro_oc.text

dw_master.retrieve(ls_doc_oc,ls_nro_oc,'0')
end event

type sle_nro_oc from singlelineedit within w_cm331_ampliacion
integer x = 279
integer y = 24
integer width = 402
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type dw_master from u_dw_abc within w_cm331_ampliacion
integer x = 14
integer y = 164
integer width = 3895
integer height = 1236
string dataobject = "d_abc_o_compra_det_211_mod"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

end event

