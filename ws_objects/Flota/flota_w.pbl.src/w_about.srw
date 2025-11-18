$PBExportHeader$w_about.srw
forward
global type w_about from w_main_about_ancst
end type
end forward

global type w_about from w_main_about_ancst
end type
global w_about w_about

on w_about.create
call super::create
end on

on w_about.destroy
call super::destroy
end on

type pb_1 from w_main_about_ancst`pb_1 within w_about
end type

type st_2 from w_main_about_ancst`st_2 within w_about
end type

type st_1 from w_main_about_ancst`st_1 within w_about
end type

type p_1 from w_main_about_ancst`p_1 within w_about
end type

