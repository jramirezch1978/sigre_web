$PBExportHeader$w_main_about.srw
forward
global type w_main_about from w_main_about_ancst
end type
end forward

global type w_main_about from w_main_about_ancst
end type
global w_main_about w_main_about

on w_main_about.create
call super::create
end on

on w_main_about.destroy
call super::destroy
end on

type st_4 from w_main_about_ancst`st_4 within w_main_about
end type

type st_3 from w_main_about_ancst`st_3 within w_main_about
integer x = 41
integer y = 260
integer width = 1801
integer height = 196
string text = "@Copyright North Peruvian System S.A.C. derechos reservados"
end type

type st_2 from w_main_about_ancst`st_2 within w_main_about
end type

type st_1 from w_main_about_ancst`st_1 within w_main_about
integer width = 1851
string text = "Sistema Integrado de Gestión de Recursos Empresariales - NPS"
end type

type cb_ok from w_main_about_ancst`cb_ok within w_main_about
end type

