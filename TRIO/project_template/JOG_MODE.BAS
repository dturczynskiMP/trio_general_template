'======= JOG MODE =======
'It works like this: using MPG (manual pulse generator, handwheel, you can move selected axis

ON BASICERROR GOTO error_routine



'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~LOCAL VARIABLES DEFINITION
DIM v_temp AS INTEGER = 0 'example, please delete me

DIM delay_time_filter AS INTEGER = 350
DIM i AS INTEGER = 0
DIM jogspeed_val AS INTEGER = 1

VR(vr_jog_type) = 0



'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~INITIALIZATION OF VARIABLES
IF VR(vr_jog_type) = 0 THEN
    VR(vr_jog_mode_step) = 0
ELSEIF VR(vr_jog_type) = 1 THEN
    VR(vr_jog_mode_step) = 1
ELSE
    VR(vr_jog_mode_step) = 0
ENDIF
VR(vr_hmi_ctrl).cb_hmi_ctrl_jog_plus = OFF
VR(vr_hmi_ctrl).cb_hmi_ctrl_jog_plus = OFF
'BASE(c_ax_z_axis)
'FWD_JOG = -1
'REV_JOG = -1
'VR(vr_process_enabled) = c_process_run_jog_mode
'VR(vr_process_run) = VR(vr_process_enabled)
'VR(vr_enable).vr_enable_cb_start_from_hmi = ON
'TICKS = 0

'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MODE INITIALIZATION
'f_warning(10,"set") 'Uwaga, uruchomileś proces JOG


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MODE INFINITE LOOP



WHILE VR(vr_process_enabled) = c_process_run_jog_mode
    SELECT_CASE VR(vr_jog_mode_step)
        CASE 0
        CASE 1
        CASE 3
            IF VR(vr_process_enabled) <> VR(vr_process_run) THEN
                'normal stop, with process stop procedure
                VR(vr_jog_mode_step) = 10
            ELSEIF VR(vr_enable).vr_enable_cb_start_from_hmi = OFF THEN
                'normal stop, with process stop procedure
                VR(vr_jog_mode_step) = 10
            ELSE
                IF VR(vr_jog_type) = 0 THEN
                    VR(vr_jog_mode_step) = 0
                ELSEIF VR(vr_jog_type) = 1 THEN
                    VR(vr_jog_mode_step) = 1
                ELSE
                    VR(vr_jog_mode_step) = 0
                ENDIF
            ENDIF

        CASE 10
            ' f_warning(1,"reset") 'Uwaga, uruchomileś proces JOG
            RAPIDSTOP(2)
            WA(200)
            VR(vr_jog_mode_step) = 11

        CASE 11
            EXIT_LOOP

        CASE ELSE
            ' commands
            VR(vr_jog_mode_step) = 1
    END_CASE
WEND
STOP





error_routine:
IF RUN_ERROR <> 31 THEN ' 31 is normal stop. Hence not an error

    WDOG = OFF
    RAPIDSTOP(2)
    OP(0)
    'f_error(6)
    VR(vr_run_error_code_11) = RUN_ERROR
    VR(vr_run_error_line_11) = ERROR_LINE

    IF VR(vr_debug_level) AND 1 THEN
        PRINT #VR(vr_debug_channel), "*** RUN_ERROR: ";RUN_ERROR[0];" LINE: ";ERROR_LINE[0]; " JOG_MODE"
    ENDIF

    STOP'***********************************
ENDIF

