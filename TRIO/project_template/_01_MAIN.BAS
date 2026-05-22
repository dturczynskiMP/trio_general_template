ON BASICERROR GOTO error_routine

'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~LOCAL VARIABLES DEFINITION
DIM i AS INTEGER = 0
DIM v_temp AS INTEGER = 0
DIM ticks_at_cyclic_loop_begin AS INTEGER = 0
DIM cyclic_loop_scan_time AS FLOAT = 0


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~INITIALIZATION OF VARIABLES
TICKS = 0
VR(vr_master_state) = c_state_disabled
VR(vr_enable) = 0
VR(vr_process_enabled) = 0
VR(vr_error_code_0) = 0
VR(vr_error_code_1) = 0
VR(vr_error_code_2) = 0
VR(vr_error_code_3) = 0
VR(vr_error_code_4) = 0
VR(vr_warning_code_0) = 0
VR(vr_warning_code_1) = 0
VR(vr_warning_code_2) = 0
VR(vr_warning_code_3) = 0
VR(vr_warning_code_4) = 0
VR(vr_debug_level) = 3
VR(vr_simulation_mode).cb_vr_simulation_mode = OFF



'Clear terminals
PRINT #0,CHR(27);CHR(27);"[2J";
PRINT #5,CHR(27);CHR(27);"[2J";
PRINT #6,CHR(27);CHR(27);"[2J";
PRINT #7,CHR(27);CHR(27);"[2J";

'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~INITIALIZATION MODBUS MODE 7
f_modbus_tcp_config() ' W tym projekcie korzystamy z trybu 32 bitowego (Mode 7 na Weinteku)
PRINT #0, "DEV_STOP1":PRINT #5, "DEV_STOP1":STOP


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MAIN INITIALIZATION
VR(vr_required_ecat_devices) = 1

IF VR(vr_simulation_mode).cb_vr_simulation_mode = OFF THEN
    f_ecat_startup(VR(vr_required_ecat_devices), 1)
ELSE
    'f_simulation_mode_config()
ENDIF
f_axis_startup(VR(vr_first_axis_number), VR(vr_last_axis_number))
f_hmi_open_window(10) 'Okno główne hmi


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MAIN LOOP



REPEAT
    IF VR(vr_master_state) = c_state_disabled THEN
        GOSUB state_disabled
    ELSEIF VR(vr_master_state) = c_state_active THEN
        GOSUB state_active
    ELSEIF VR(vr_master_state) = c_state_homing THEN
        GOSUB state_homing
    ELSEIF VR(vr_master_state) = c_state_automatic THEN
        GOSUB state_automatic
    ELSEIF VR(vr_master_state) = c_state_manual THEN
        GOSUB state_manual
    ELSEIF VR(vr_master_state) = c_state_jog THEN
        GOSUB state_jog
    ELSEIF VR(vr_master_state) = c_state_error THEN
        GOSUB state_error
    ELSE
        VR(vr_master_state) = c_state_disabled
    ENDIF
UNTIL FALSE
STOP



'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MAIN STATE
main_state_check:
'Jeżeli został zgloszony błąd ale aplikacja nie zdążyła ustawic alarmu
IF VR(vr_error_code_0) <> 0 _
        OR VR(vr_error_code_1) <> 0 _
        OR VR(vr_error_code_2) <> 0 _
        OR VR(vr_error_code_3) <> 0 _
        OR VR(vr_error_code_4) <> 0 _
    THEN
    VR(vr_enable).vr_enable_cb_alarm = ON
ENDIF

IF VR(vr_enable).vr_enable_cb_alarm = ON THEN
    VR(vr_master_state) = c_state_error

ELSEIF VR(vr_enable).vr_enable_cb_enable_from_safety = OFF THEN
    f_error(3)') 'Zgłoś błąd systemu bezpieczeństwa
    VR(vr_master_state) = c_state_error

ELSEIF VR(vr_enable).vr_enable_cb_enable_from_hmi = OFF THEN
    'f_error(4) 'Zgłoś błąd HMI
    VR(vr_master_state) = c_state_disabled

ELSEIF VR(vr_enable).vr_enable_cb_start_from_hmi = OFF _
        OR VR(vr_process_run) <> VR(vr_process_enabled) _
        OR VR(vr_enable).vr_enable_cb_terminate_flag = ON THEN
    'zmiana trybu pracy lub STOP
    VR(vr_enable).vr_enable_cb_terminate_flag = OFF
    VR(vr_master_state) = c_state_active

ENDIF
RETURN


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~CYCLIC UPDATE
cyclic_update:
IF VR(vr_master_state) <> c_state_disabled THEN


ENDIF

IF VR(vr_master_state) = c_state_active THEN
    VR(vr_hmi_lock).cb_hmi_lock_auto = ON
    VR(vr_hmi_lock).cb_hmi_lock_reczny = ON
    VR(vr_hmi_lock).cb_hmi_lock_baza = ON
    VR(vr_hmi_lock).cb_hmi_lock_jog = ON
ELSE
    VR(vr_hmi_lock).cb_hmi_lock_auto = OFF
    VR(vr_hmi_lock).cb_hmi_lock_reczny = OFF
    VR(vr_hmi_lock).cb_hmi_lock_baza = OFF
    VR(vr_hmi_lock).cb_hmi_lock_jog = OFF
ENDIF

ticks_at_cyclic_loop_begin = -TICKS
'Jeżeli został zgloszony błąd ale aplikacja nie zdążyła ustawic alarmu
IF VR(vr_error_code_0) <> 0 _
        OR VR(vr_error_code_1) <> 0 _
        OR VR(vr_error_code_2) <> 0 _
        OR VR(vr_error_code_3) <> 0 _
        OR VR(vr_error_code_4) <> 0 _
    THEN

    IF VR(vr_master_state) <> c_state_error THEN
        VR(vr_enable).vr_enable_cb_alarm = ON
    ENDIF
ENDIF


IF f_timer_ms(TICKS,c_timer_0,5000) = TRUE THEN
    'sprawdzanie lub aktualizacja danych co interwał czasu
    IF VR(vr_debug_level) AND 2 THEN
        PRINT #VR(vr_debug_channel), "* CYCLE_LOOP TIME: ";cyclic_loop_scan_time[2]; " TICKS"
    ENDIF

    v_temp = f_ecat_test(VR(vr_required_ecat_devices))
    IF v_temp <> TRUE THEN
        IF v_temp.0 = ON THEN
            f_error(0) 'błąd stanu sieci ECAT (różny od operacyjnego)
        ENDIF

        IF v_temp.1 = ON THEN
            f_error(1) 'błąd ilości urządzeń ECAT
        ENDIF

        IF v_temp.2 = ON THEN
            f_error(2) 'błąd sieci ECAT
        ENDIF

        REPEAT
            'Zawieszenie programu
            'f_safety_stop(0)
            'f_hmi_open_window(101) 'Okno hmi błąd krytyczny
        UNTIL ON

    ENDIF
    f_timer_set_ms(TICKS,c_timer_0,5000)

ELSEIF f_timer_ms(TICKS,c_timer_0,5000) = 1 THEN
    f_timer_set_ms(TICKS,c_timer_0,5000)
ENDIF

'Generowanie rejestru z cyklicznymi impulsami
IF f_timer_ms(TICKS,c_timer_1,1000)THEN
    VR(vr_time_pulse) = VR(vr_time_pulse) + 1
    IF VR(vr_time_pulse) > 10000 THEN
        VR(vr_time_pulse) = 0
    ENDIF
    IF VR(vr_process_run) <> 0 AND VR(vr_master_state) = c_state_active THEN
        'TIMER(0,do_start_button_light,1,500)
    ELSE
        'OP(do_start_button_light,OFF)
    ENDIF
    IF VR(vr_enable).vr_enable_cb_alarm = ON THEN
        TIMER(1,do_column_red_light,1,500)
        OP(do_column_yellow_light,OFF)
        OP(do_column_green_light,OFF)
    ELSE
        OP(do_column_red_light,OFF)
    ENDIF
    f_timer_set_ms(TICKS,c_timer_1,1000)
ELSEIF f_timer_ms(TICKS,c_timer_1,1000) = 1 THEN
    'Błąd czasu, zadeklaruj nowe zliczanie
    f_timer_set_ms(TICKS,c_timer_1,1000)
ENDIF


VR(vr_di_mapping_0) = IN
VR(vr_do_mapping_0) = OP
FOR i = VR(vr_first_axis_number) TO VR(vr_last_axis_number)
    BASE(i)
    VR(vr_actual_pos_ax_example + (BASE - 1)) = ROUND(MPOS * 100, 0)
    IF AXISSTATUS.3 THEN
        ' CO_READ_AXIS(BASE, $1001, $0, 2, vr_actual_error_ax_example)
        CO_READ_AXIS(BASE, $1001, $0, 2, 316 + BASE)
        f_error(4 + BASE)
    ENDIF
    IF MOTION_ERROR.BASE = 1 THEN
        VR(316 + BASE) = AXISSTATUS
        f_error(4 + BASE)
    ENDIF
    'LOOKAHEAD_FACTOR = VR(vr_mfo) / 100
    IF VR(vr_mfo) > 300 THEN
        VR(vr_mfo) = 300
    ELSEIF VR(vr_mfo) < 0 THEN
        VR(vr_mfo) = 0
    ENDIF
    IF VR(vr_master_state) <> c_state_homing THEN
        IF VR(vr_mfo) > 300 THEN
            SPEED_FACTOR = 1
        ELSE
            SPEED_FACTOR = VR(vr_mfo) / 300
        ENDIF
    ELSE
        SPEED_FACTOR = 1
    ENDIF
    IN_POS_DIST AXIS(i) = VR(vr_inpos_dist) / 100
    IN_POS_SPEED AXIS(i) = VR(vr_inpos_speed) / 100
NEXT i



IF VR(vr_enable).vr_enable_cb_force_do = ON THEN
    OP(VR(vr_do_force_mask_0))
    VR(vr_enable).vr_enable_cb_force_do_flag = ON
ELSEIF VR(vr_enable).vr_enable_cb_force_do = OFF THEN
    VR(vr_do_force_mask_0) = 0
    IF VR(vr_enable).vr_enable_cb_force_do_flag = ON THEN
        VR(vr_do_force_mask_0) = 0
        OP(VR(vr_do_force_mask_0))
        VR(vr_enable).vr_enable_cb_force_do_flag = OFF
    ENDIF
ENDIF

'IF IN(di_gotowosc) = ON THEN
'    VR(vr_enable).vr_enable_cb_enable_from_safety = ON
'ELSE
'    VR(vr_enable).vr_enable_cb_enable_from_safety = OFF
'ENDIF

'IF IN(di_sens_sprzeglo) = ON THEN f_error(211)




'IF VR(vr_hmi_ctrl).cb_hmi_ctrl_save_homepos_ax_z = ON THEN
'    f_save_homepos_ax_z()
'    f_set_homepos_ax_z()
'ENDIF

'IF IN(di_maszyna_wlacz) = ON THEN
'    VR(vr_enable).vr_enable_cb_start_from_hmi = ON
'ELSEIF IN(di_maszyna_wylacz) = ON THEN
'    VR(vr_enable).vr_enable_cb_start_from_hmi = OFF
'ENDIF


IF VR(vr_hmi_ctrl).vr_hmi_ctrl_cb_clr_error = ON THEN
    VR(vr_hmi_ctrl).vr_hmi_ctrl_cb_clr_error = OFF
    VR(vr_warning_code_0) = 0
    VR(vr_warning_code_1) = 0
ENDIF
IF VR(vr_master_state) = c_state_automatic THEN
    VR(vr_hmi_lock).cb_hmi_lock_load_recipe = ON
ELSE
    VR(vr_hmi_lock).cb_hmi_lock_load_recipe = OFF
ENDIF

IF VR(vr_master_state) = c_state_jog THEN
    IF VR(vr_jog_type) = 0 THEN
        VR(vr_hmi_lock).cb_hmi_lock_jog_buttons = ON
    ELSE
        VR(vr_hmi_lock).cb_hmi_lock_jog_buttons = OFF
    ENDIF
ELSE
    VR(vr_hmi_lock).cb_hmi_lock_jog_buttons = ON
ENDIF

IF VR(vr_master_state) = c_state_manual THEN



    IF VR(vr_master_state) = c_state_manual _
            OR VR(vr_master_state) = c_state_homing _
            OR VR(vr_master_state) = c_state_jog _
            OR VR(vr_master_state) = c_state_automatic THEN
'    IF IN(di_maszyna_wylacz) = ON THEN
'        counter_01 = counter_01 + 1
'        IF (counter_01 > 25) AND VR(vr_enable).vr_enable_cb_one_cycle_flag = OFF THEN
'            VR(vr_enable).vr_enable_cb_one_cycle_flag = ON
'            PRINT #5, "ONE_CYCLE"
'        ENDIF
'        IF (counter_01 > 50) AND VR(vr_enable).vr_enable_cb_terminate_flag = OFF THEN
'            VR(vr_enable).vr_enable_cb_terminate_flag = ON
'            PRINT #5, "TERMINATE"
'        ENDIF
'    ELSE
'        counter_01 = 0
    ENDIF
ENDIF




WA(5)
cyclic_loop_scan_time = (-TICKS - ticks_at_cyclic_loop_begin) '/ SERVO_PERIOD
RETURN
STOP

'################### Funkcja błędu programu ###################
error_routine:
IF RUN_ERROR <> 31 THEN ' 31 is normal stop. Hence not an error

    STOP "HOMING_MODE"
    STOP "JOG_MODE"
    STOP "AUTO_MODE"
    STOP "MANUAL_MODE"

    WDOG = OFF
    RAPIDSTOP(2)
    OP(0)

    VR(vr_run_error_code_06) = RUN_ERROR
    VR(vr_run_error_line_06) = ERROR_LINE
    IF VR(vr_debug_level) AND 1 THEN
        PRINT #VR(vr_debug_channel), "*** RUN_ERROR: ";RUN_ERROR[0];" LINE: ";ERROR_LINE[0]; " MAIN"
    ENDIF
    f_error(10)
ENDIF
STOP'***********************************




state_disabled:
IF VR(vr_debug_level) AND 1 THEN PRINT #VR(vr_debug_channel), "-> FSM_DISABLED"
'actions RUN only once in this state
VR(vr_process_enabled) = c_process_run_nothing
OP(do_column_green_light,OFF)
OP(do_column_yellow_light,OFF)
OP(do_column_red_light,OFF)
f_safety_stop(0)
WA(500)

REPEAT
    'actions RUN cyclically in this state
    GOSUB cyclic_update
    WA(10) 'wait for machine to be turned ON or ERROR occur

UNTIL VR(vr_enable).vr_enable_cb_alarm = ON _
    OR VR(vr_enable).vr_enable_cb_enable_from_safety = OFF _
    OR VR(vr_enable).vr_enable_cb_restart_ex = ON _
    OR (VR(vr_enable).vr_enable_cb_enable_from_safety = ON _
    AND VR(vr_enable).vr_enable_cb_enable_from_hmi = ON)

GOSUB main_state_check

IF VR(vr_master_state) = c_state_disabled THEN
    IF VR(vr_enable).vr_enable_cb_restart_ex = ON THEN
        EX
    ELSEIF VR(vr_enable).vr_enable_cb_enable_from_safety = ON THEN
        VR(vr_master_state) = c_state_active
    ENDIF
ENDIF
RETURN

state_active:
IF VR(vr_debug_level) AND 1 THEN PRINT #VR(vr_debug_channel), "-> FSM_ACTIVE"
'actions RUN only once in this state
VR(vr_process_enabled) = c_process_run_nothing
VR(vr_process_run) = c_process_run_nothing
VR(vr_enable).vr_enable_cb_start_from_hmi = OFF
f_safety_stop(1)
f_safety_start(0, VR(vr_last_axis_number))
OP(do_column_green_light,ON)
OP(do_column_yellow_light,OFF)
OP(do_column_red_light,OFF)


REPEAT
    'actions RUN cyclically in this state
    GOSUB cyclic_update
    WA(10)

UNTIL VR(vr_enable).vr_enable_cb_alarm = ON _
    OR VR(vr_enable).vr_enable_cb_enable_from_safety = OFF _
    OR VR(vr_enable).vr_enable_cb_enable_from_hmi = OFF _
    OR VR(vr_enable).vr_enable_cb_start_from_hmi = ON


GOSUB main_state_check

IF VR(vr_master_state) = c_state_active THEN
    IF VR(vr_enable).vr_enable_cb_start_from_hmi = ON THEN
        ' f_warning(4,"reset") 'Uwaga, brak wybranego trybu pracy
        IF VR(vr_process_run) = c_process_run_homing THEN
            VR(vr_master_state) = c_state_homing
        ELSEIF VR(vr_process_run) = c_process_run_auto_mode THEN
            VR(vr_master_state) = c_state_automatic
        ELSEIF VR(vr_process_run) = c_process_run_manual_mode THEN
            VR(vr_master_state) = c_state_manual
        ELSEIF VR(vr_process_run) = c_process_run_jog_mode THEN
            VR(vr_master_state) = c_state_jog
        ELSE
            ' f_warning(4,"set") 'Uwaga, brak wybranego trybu pracy
            VR(vr_enable).vr_enable_cb_start_from_hmi = OFF
        ENDIF

    ENDIF
ENDIF
RETURN


state_homing:
IF VR(vr_debug_level) AND 1 THEN PRINT #VR(vr_debug_channel), "-> FSM_HOMINIG"

'actions RUN only once IN this state
VR(vr_process_enabled) = c_process_run_homing
OP(do_column_green_light,ON)
OP(do_column_yellow_light,ON)
OP(do_column_red_light,OFF)

IF PROC_STATUS PROC(16) = 0 THEN
    RUN "HOMING_MODE", 16
ENDIF

REPEAT
    'actions RUN cyclically in this state
    GOSUB cyclic_update
    WA(10)
UNTIL VR(vr_enable).vr_enable_cb_alarm = ON _
    OR VR(vr_enable).vr_enable_cb_enable_from_safety = OFF _
    OR VR(vr_enable).vr_enable_cb_enable_from_hmi = OFF _
    OR PROC_STATUS PROC(16) = 0 _
    OR VR(vr_enable).vr_enable_cb_terminate_flag = ON

STOP "HOMING_MODE"


GOSUB main_state_check

IF VR(vr_master_state) = c_state_homing THEN
    IF VR(vr_process_enabled) = c_process_run_nothing THEN
        VR(vr_master_state) = c_state_disabled
    ELSE
        'VR(vr_master_state) = c_state_error
        VR(vr_master_state) = c_state_disabled
        'Zgłoś błąd zatrzymania procesu HOMING_MODE
        'f_error(5)
    ENDIF
ENDIF
RETURN


state_automatic:
IF VR(vr_debug_level) AND 1 THEN PRINT #VR(vr_debug_channel), "-> FSM_AUTOMATIC"

'actions RUN only once IN this state
VR(vr_process_enabled) = c_process_run_auto_mode
OP(do_column_green_light,ON)
OP(do_column_yellow_light,ON)
OP(do_column_red_light,OFF)

IF PROC_STATUS PROC(16) = 0 THEN
    RUN "AUTO_MODE", 16
ENDIF

REPEAT
    'actions RUN cyclically in this state
    GOSUB cyclic_update
    WA(10)
UNTIL VR(vr_enable).vr_enable_cb_alarm = ON _
    OR VR(vr_enable).vr_enable_cb_enable_from_safety = OFF _
    OR VR(vr_enable).vr_enable_cb_enable_from_hmi = OFF _
    OR PROC_STATUS PROC(16) = 0 _
    OR VR(vr_enable).vr_enable_cb_terminate_flag = ON

STOP "AUTO_MODE"

GOSUB main_state_check

IF VR(vr_master_state) = c_state_automatic THEN
    IF VR(vr_process_enabled) = c_process_run_nothing THEN
        VR(vr_master_state) = c_state_disabled
    ELSE
        'VR(vr_master_state) = c_state_error
        VR(vr_master_state) = c_state_disabled
        'f_error(7)
    ENDIF
ENDIF
RETURN

state_manual:
IF VR(vr_debug_level) AND 1 THEN PRINT #VR(vr_debug_channel), "-> FSM_MANUAL"

'actions RUN only once IN this state
VR(vr_process_enabled) = c_process_run_manual_mode

OP(do_column_green_light,ON)
OP(do_column_yellow_light,ON)
OP(do_column_red_light,OFF)

IF PROC_STATUS PROC(16) = 0 THEN
    RUN "MANUAL_MODE", 16
ENDIF

REPEAT
    'actions RUN cyclically in this state
    GOSUB cyclic_update
    WA(10)
UNTIL VR(vr_enable).vr_enable_cb_alarm = ON _
    OR VR(vr_enable).vr_enable_cb_enable_from_safety = OFF _
    OR VR(vr_enable).vr_enable_cb_enable_from_hmi = OFF _
    OR PROC_STATUS PROC(16) = 0 _
    OR VR(vr_enable).vr_enable_cb_terminate_flag = ON

STOP "MANUAL_MODE"

GOSUB main_state_check

IF VR(vr_master_state) = c_state_manual THEN
    IF VR(vr_process_enabled) = c_process_run_nothing THEN
        VR(vr_master_state) = c_state_disabled
    ELSE
        'VR(vr_master_state) = c_state_error
        VR(vr_master_state) = c_state_disabled
        'f_error(8)
    ENDIF
ENDIF

RETURN



state_jog:
IF VR(vr_debug_level) AND 1 THEN PRINT #VR(vr_debug_channel), "-> FSM_JOG"

'actions RUN only once IN this state
VR(vr_process_enabled) = c_process_run_jog_mode

OP(do_column_green_light,ON)
OP(do_column_yellow_light,ON)
OP(do_column_red_light,OFF)

IF PROC_STATUS PROC(16) = 0 THEN
    RUN "JOG_MODE", 16
ENDIF

REPEAT
    'actions RUN cyclically in this state
    GOSUB cyclic_update
    WA(10)
UNTIL VR(vr_enable).vr_enable_cb_alarm = ON _
    OR VR(vr_enable).vr_enable_cb_enable_from_safety = OFF _
    OR VR(vr_enable).vr_enable_cb_enable_from_hmi = OFF _
    OR PROC_STATUS PROC(16) = 0 _
    OR VR(vr_enable).vr_enable_cb_terminate_flag = ON

STOP "JOG_MODE"

GOSUB main_state_check

IF VR(vr_master_state) = c_state_jog THEN
    IF VR(vr_process_enabled) = c_process_run_jog_mode THEN
        VR(vr_master_state) = c_state_disabled
    ELSE
        'VR(vr_master_state) = c_state_error
        VR(vr_master_state) = c_state_disabled
        'f_error(6)
    ENDIF
ENDIF
RETURN



state_error:
IF VR(vr_debug_level) AND 1 THEN PRINT #VR(vr_debug_channel), "-> FSM_ERROR"
OP(do_column_green_light,OFF)
OP(do_column_yellow_light,OFF)
OP(do_column_red_light,ON)
'actions RUN only once IN this state
f_safety_stop(0) 'zatrzymanie



REPEAT

    'actions RUN cyclically in this state
    GOSUB cyclic_update
    WA(10)

UNTIL VR(vr_hmi_ctrl).vr_hmi_ctrl_cb_clr_error = ON


WDOG = OFF ' should already be off, but just to be sure
VR(vr_master_state) = c_state_disabled

'Jeżeli błąd krytyczny nie pozwól na skasowanie błędów
IF VR(vr_enable).vr_enable_cb_master_error = OFF THEN
    VR(vr_error_code_0) = 0
    VR(vr_error_code_1) = 0
    VR(vr_error_code_2) = 0
    VR(vr_error_code_3) = 0
    VR(vr_error_code_4) = 0

    VR(vr_warning_code_0) = 0
    VR(vr_warning_code_1) = 0
    VR(vr_warning_code_2) = 0
    VR(vr_warning_code_3) = 0
    VR(vr_warning_code_4) = 0

    f_ecat_error_reset() 'Reset błędów na sieci ECAT
    VR(vr_enable).vr_enable_cb_alarm = OFF
ELSE
    VR(vr_enable).vr_enable_cb_alarm = ON
    VR(vr_hmi_ctrl).vr_hmi_ctrl_cb_clr_error = OFF
ENDIF
WA(100) ' wait for flags and errors to clear
VR(vr_hmi_ctrl).vr_hmi_ctrl_cb_clr_error = OFF
RETURN



