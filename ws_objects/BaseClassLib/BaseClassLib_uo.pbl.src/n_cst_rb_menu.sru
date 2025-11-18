$PBExportHeader$n_cst_rb_menu.sru
$PBExportComments$Funciones para llamar al menu del boton derecho del mouse
forward
global type n_cst_rb_menu from nonvisualobject
end type
end forward

global type n_cst_rb_menu from nonvisualobject
end type
global n_cst_rb_menu n_cst_rb_menu

type variables
m_rbutton   im_1
end variables

forward prototypes
public subroutine of_call_rb_menu (string as_colname, string as_coltype, long al_row)
end prototypes

public subroutine of_call_rb_menu (string as_colname, string as_coltype, long al_row);
im_1.PopMenu(w_main.PointerX(), w_main.PointerY())

end subroutine

event constructor;im_1 = CREATE m_rButton
end event

on n_cst_rb_menu.create
TriggerEvent( this, "constructor" )
end on

on n_cst_rb_menu.destroy
TriggerEvent( this, "destructor" )
end on

event destructor;Destroy im_1
end event

