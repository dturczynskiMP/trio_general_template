ON BASICERROR GOTO error_routine
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~LOCAL VARIABLES DEFINITION
DIM v_temp AS INTEGER = 0 'example, please delete me


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~INITIALIZATION OF VARIABLES
VR(vr_homing_mode_step) = 0

'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MODE INITIALIZATION
f_warning(9,"set") 'Uwaga, uruchomileś proces HOMING
WA(200)
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MODE INFINITE LOOP



WHILE VR(vr_process_enabled) = c_process_run_homing
    SELECT_CASE VR(vr_homing_mode_step)
        CASE 0
        CASE 3
            WA(100)

            IF VR(vr_process_enabled) <> VR(vr_process_run) THEN
                'normal stop, with process stop procedure
                VR(vr_homing_mode_step) = 10
            ELSEIF VR(vr_enable).vr_enable_cb_start_from_hmi = OFF THEN
                'normal stop, with process stop procedure
                VR(vr_homing_mode_step) = 10
            ELSE
                VR(vr_homing_mode_step) = 0
            ENDIF

        CASE 10
            WA(50)
            f_warning(9,"reset") 'Uwaga, uruchomileś proces HOMING
            VR(vr_homing_mode_step) = 11

        CASE 11
            EXIT_LOOP

        CASE ELSE
            VR(vr_homing_mode_step) = 0
    END_CASE
WEND
STOP

error_routine:
IF RUN_ERROR <> 31 THEN ' 31 is normal stop. Hence not an error

    WDOG = OFF
    RAPIDSTOP(2)
    OP(0)
    'f_error(5)
    VR(vr_run_error_code_10) = RUN_ERROR
    VR(vr_run_error_line_10) = ERROR_LINE
    IF VR(vr_debug_level) AND 1 THEN
        PRINT #VR(vr_debug_channel), "* RUN_ERROR: ";RUN_ERROR[0];" LINE: ";ERROR_LINE[0]; " HOMING_MODE"
    ENDIF

    STOP'***********************************
ENDIF

