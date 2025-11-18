$PBExportHeader$w_prc.srw
$PBExportComments$Ventana basica para procesos
forward
global type w_prc from w_base
end type
end forward

global type w_prc from w_base
integer x = 823
integer y = 360
integer width = 507
integer height = 288
long backcolor = 79741120
event ue_close_pre ( )
event ue_open_pre ( )
event ue_help_topic ( )
event ue_help_index ( )
event ue_about ( )
end type
global w_prc w_prc

type variables
u_dw_abc		idw_1

end variables

forward prototypes
public subroutine of_color (long al_value)
public subroutine of_position_window (integer ai_x, integer ai_y)
public subroutine of_close_sheet ()
public function integer of_new_list (str_list_pop astr_1)
public subroutine of_set_menu_abc ()
end prototypes

event ue_open_pre();//dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
//dw_detail.SetTransObject(sqlca)
//dw_lista.SetTransObject(sqlca)

//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic

end event

event ue_help_topic;ShowHelp(gs_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gs_help, Index!)
end event

public subroutine of_color (long al_value);THIS.BackColor = al_value
end subroutine

public subroutine of_position_window (integer ai_x, integer ai_y);THIS.x = ai_x
THIS.y = ai_y
end subroutine

public subroutine of_close_sheet ();Integer	 li_x

FOR li_x = 2 to ii_x							// eliminar todas las ventanas pop
	IF IsValid(iw_sheet[li_x]) THEN close(iw_sheet[li_x])
NEXT

end subroutine

public function integer of_new_list (str_list_pop astr_1);Integer 			li_rc
w_list_qs_pop	lw_sheet

li_rc = OpenSheetWithParm(lw_sheet, astr_1, this, 0, Original!)
ii_x ++
iw_sheet[ii_x]  = lw_sheet

RETURN li_rc     						//	Valores de Retorno: 1 = exito, -1 = error
end function

public subroutine of_set_menu_abc ();
end subroutine

on w_prc.create
call super::create
end on

on w_prc.destroy
call super::destroy
end on

event open;IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
ELSE
	CLOSE(THIS)
END IF
end event

event close;THIS.Event ue_close_pre()

of_close_sheet()


end event

