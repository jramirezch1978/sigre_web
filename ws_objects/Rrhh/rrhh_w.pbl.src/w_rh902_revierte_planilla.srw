$PBExportHeader$w_rh902_revierte_planilla.srw
forward
global type w_rh902_revierte_planilla from w_prc
end type
type rb_2 from radiobutton within w_rh902_revierte_planilla
end type
type rb_1 from radiobutton within w_rh902_revierte_planilla
end type
type cb_revertir from commandbutton within w_rh902_revierte_planilla
end type
type dw_master from u_dw_abc within w_rh902_revierte_planilla
end type
type st_3 from statictext within w_rh902_revierte_planilla
end type
type st_1 from statictext within w_rh902_revierte_planilla
end type
end forward

global type w_rh902_revierte_planilla from w_prc
integer width = 3570
integer height = 2284
string title = "[RH902] Revierte cálculo de la planilla"
string menuname = "m_only_exit"
boolean resizable = false
boolean center = true
event ue_retrieve ( )
rb_2 rb_2
rb_1 rb_1
cb_revertir cb_revertir
dw_master dw_master
st_3 st_3
st_1 st_1
end type
global w_rh902_revierte_planilla w_rh902_revierte_planilla

type variables
string is_tipo_emp, is_salir
end variables

forward prototypes
public function integer of_get_param ()
end prototypes

event ue_retrieve();if rb_1.checked then
	dw_master.DataObject = 'd_lista_cierre_planilla_tbl'
else
	dw_master.DataObject = 'd_lista_revierte_historico_calculo_tbl'
end if

dw_master.SetTransObject(SQLCA)
dw_master.Retrieve(gs_user)

cb_revertir.enabled = false
end event

public function integer of_get_param ();select tipo_trab_empleado
  into :is_tipo_emp
  from rrhhparam
 where reckey = '1';
 
if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha indicado parametros en RRHHPARAM')
	return 0
end if

return 1
end function

on w_rh902_revierte_planilla.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_revertir=create cb_revertir
this.dw_master=create dw_master
this.st_3=create st_3
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.cb_revertir
this.Control[iCurrent+4]=this.dw_master
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_1
end on

on w_rh902_revierte_planilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_revertir)
destroy(this.dw_master)
destroy(this.st_3)
destroy(this.st_1)
end on

event open;call super::open;

//long ll_x,ll_y
//ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
//ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
//This.move(ll_x,ll_y)

end event

event ue_open_pre;call super::ue_open_pre;//dw_1.settransobject(SQLCA)
//
if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

this.event ue_retrieve()
end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10



end event

type rb_2 from radiobutton within w_rh902_revierte_planilla
integer x = 2167
integer y = 92
integer width = 434
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Histórico"
end type

event clicked;parent.event ue_retrieve()
end event

type rb_1 from radiobutton within w_rh902_revierte_planilla
integer x = 1705
integer y = 92
integer width = 434
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "En proceso"
boolean checked = true
end type

event clicked;parent.event ue_retrieve()
end event

type cb_revertir from commandbutton within w_rh902_revierte_planilla
integer x = 2647
integer y = 12
integer width = 599
integer height = 148
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Revertir"
end type

event clicked;String ls_origen, ls_tipo_trabaj, ls_mensaje, ls_tipo_planilla
Date ld_fec_proceso
Integer li_i, li_count

//Si ha marcado el historico, entonces debo consultar antes de eliminarlo por completo

if rb_2.checked then
	if MessageBox('Informacion', &
		"Ha seleccionado revertir una planilla que ha sido enviada ya al historico, está seguro de relizar " &
	 + "esta operación." &
	 + "~r~nEs posible, según la configuración del SIGRE en su empresa, que no pueda realizar esta opción", &
		Information!, Yesno!, 2) = 2 then return
else
	if MessageBox('Informacion', &
		"Ha seleccionado revertir una(s) planilla(s) que no ha sido enviada al HISTORICO. " &
	 + "Si la elimina no podra RECUPERARLA posteriormente." &
	 + "Desea continuar con el proceso de REVERSION?", &
		Information!, Yesno!, 2) = 2 then return
	
end if

for li_i = 1 to dw_master.RowCount()
	if dw_master.object.checked [li_i] = '1' then
		
		ls_origen 		 	= dw_master.object.cod_origen 		[li_i]
		ls_tipo_trabaj	 	= dw_master.object.tipo_trabajador 	[li_i]
		ld_fec_proceso  	= Date(dw_master.object.fec_proceso [li_i])
		ls_tipo_planilla	= dw_master.object.tipo_planilla 	[li_i]
		
		//create or replace procedure usp_rh_del_doc_cal_plla(
		//       asi_tipo_trab        in maestro.tipo_trabajador%type,
		//       asi_origen           in maestro.cod_origen%type     ,
		//       adi_fec_proceso      in date,
		//       asi_tipo_planilla    in calculo.tipo_planilla%TYPE                        
		//) is
		
		//ELIMINO ARCHIVOS DE PAGO
		DECLARE usp_rh_del_doc_cal_plla PROCEDURE FOR 
			usp_rh_del_doc_cal_plla( :ls_tipo_trabaj,
											 :ls_origen,
											 :ld_fec_proceso,
											 :ls_tipo_planilla) ;
		EXECUTE usp_rh_del_doc_cal_plla ;
		
		//busco errores
		if sqlca.sqlcode = -1 then
		  ls_mensaje = sqlca.sqlerrtext
		  Rollback ;
		  Messagebox('SQL Error usp_rh_del_doc_cal_plla',ls_mensaje)
		  Return
		end if
		
		CLOSE usp_rh_del_doc_cal_plla ;
		
		if rb_1.checked then
		
			//create or replace procedure usp_rh_cal_borra_mov_calculo (
			//  asi_origen         in origen.cod_origen%TYPE,
			//  adi_fec_proceso    in date,
			//  asi_tipo_trabaj    in tipo_trabajador.tipo_trabajador %TYPE,
			//  asi_tipo_planilla  in calculo.tipo_planilla%TYPE
			//) is
			
			DECLARE USP_RH_CAL_BORRA_MOV_CALCULO PROCEDURE FOR 
				USP_RH_CAL_BORRA_MOV_CALCULO( :ls_origen, 
														:ld_fec_proceso, 
														:ls_tipo_trabaj,
														:ls_tipo_planilla) ;
			EXECUTE USP_RH_CAL_BORRA_MOV_CALCULO ;
			
			IF SQLCA.sqlcode = -1 THEN
				ls_mensaje = "PROCEDURE USP_RH_CAL_BORRA_MOV_CALCULO: " + SQLCA.SQLErrText
				Rollback ;
				MessageBox('SQL error', ls_mensaje, StopSign!)	
				return 
			END IF
			
			CLOSE USP_RH_CAL_BORRA_MOV_CALCULO;
		else
			//create or replace procedure USP_SIGRE_RRHH.usp_rh_cal_borra_hist_calculo (
			//  asi_origen         in origen.cod_origen%TYPE,
			//  adi_fec_proceso    in date,
			//  asi_tipo_trabaj    in tipo_trabajador.tipo_trabajador %TYPE,
			//  asi_tipo_planilla  in calculo.tipo_planilla%TYPE
			//) is
			
			DECLARE usp_rh_cal_borra_hist_calculo PROCEDURE FOR 
				USP_SIGRE_RRHH.usp_rh_cal_borra_hist_calculo( :ls_origen, 
														:ld_fec_proceso, 
														:ls_tipo_trabaj,
														:ls_tipo_planilla) ;
			EXECUTE usp_rh_cal_borra_hist_calculo ;
			
			IF SQLCA.sqlcode = -1 THEN
				ls_mensaje = "PROCEDURE USP_SIGRE_RRHH.usp_rh_cal_borra_hist_calculo: " + SQLCA.SQLErrText
				Rollback ;
				MessageBox('SQL error', ls_mensaje, StopSign!)	
				return 
			END IF
			
			CLOSE usp_rh_cal_borra_hist_calculo;
			
		end if
		
	end if
next

Commit ;	
parent.event ue_retrieve()

MessageBox('Aviso', 'Proceso concluído Satifactoriamente')


end event

type dw_master from u_dw_abc within w_rh902_revierte_planilla
integer y = 180
integer width = 3259
integer height = 1080
string dataobject = "d_lista_cierre_planilla_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_lbuttonup;call super::ue_lbuttonup;Integer li_count, ll_i

this.AcceptText()

li_count = 0
for ll_i = 1 to this.RowCount()
	if this.object.checked[ll_i] = '1' then
		li_count++
	end if
next

if li_count > 0 then
	cb_revertir.Enabled = true
else
	cb_revertir.Enabled = false
end if
end event

type st_3 from statictext within w_rh902_revierte_planilla
integer y = 68
integer width = 887
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "aún no se haya pasado al histórico."
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh902_revierte_planilla
integer width = 2359
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Este proceso revierte un proceso de cálculo que anteriormente se haya ejecutado, pero que"
boolean focusrectangle = false
end type

