'SFL File
'the standard functions library contains universal functions for various projects

'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~IMPORTANT INFORMATION
'
'
'Organization:
'   1.) The function name starts with
'       f_ - (function) means function
'
'       for example:
'         FUNCTION f_ecat_test(temp_vr AS INTEGER, devices_number AS INTEGER) AS INTEGER
'       Use:
'         f_ecat_test(vr_ecat, 6) 'vr_ecat contains the VR register number
'
'       Use:
'         f_ecat_test(234, devices_number) 'devices_number contains a specific variable
'
'   2.) the function should return status:
'       -1 - The function completed successfully
'       0 - General conditions error
'       1... - Errors with specific meaning
'
'   3.) Above the FUNCTION keyword there should be description what function does.
'       Below the FUNCTION keyword and ENDFUNC keyword there should be a description of the
'       arguments accepted by the FUNCTION
'
'       for example:
'
'         Set of SD card operations that can manipulate data
'         FUNCTION f_program_sd(action AS INTEGER, program_no AS INTEGER) AS INTEGER
'          'action = 1     'insert a row with an offset
'          'action = 2     'delete row with offset
'          'action = 3     'clear row without shifting
'          'action = 4     'clear entire program
'          'program_no = 1...99   'program number
'
'          'RETURN state
'          'state =  -1 (TRUE) 'OK
'          'state =   0 (FALSE)'ERROR
'          'state.0 = 1        'ERROR invalid line number
'          'state.1 = 1        'ERROR invalid action number
'          'state.2 = 1        'ERROR no copied data to paste
'
'
'         ///function code....///
'
'         RETURN state
'         ENDFUNC
'         'f_program_sd(action AS INTEGER, program_number AS INTEGER) AS INTEGER
'         'action = 1     'insert a row with an offset
'         'action = 2     'delete row with offset
'         'action = 3     'clear row without shifting
'         'action = 4     'clear entire program
'         'program_no = 1...99   'program line
'         '
'         'RETURN state
'         'state =  -1 (TRUE) 'OK
'         'state =   0 (FALSE)'ERROR
'         'state.0 = 1        'ERROR invalid line number
'         'state.1 = 1        'ERROR invalid action number
'         'state.2 = 1        'ERROR no copied data to paste
'
'   4.) between ENDFUN and next FUNCTION keywords keep 5 ENTER distances




'Set bit ON in specified word, used to trigger messages on HMI.
'Each bit trigger one message
'It simplifies error message trigger machanism (event log).
'The best way is to include in event message the same value passed to this function, for examle
'If error message is: "A103 Motor hot!" it means that it is triggered by bit nubmer 3 in word number 1.
'It is easy to search for it on code. Use keys CTRL + ALT + f to search in entire project for keyword f_error(103)
'This function is not resetting bits in words - it is done in MAIN, in state ERROR
FUNCTION f_error(error_code AS INTEGER) AS INTEGER
'error_code = range 0-31; 100-131; 200-231; 300-331; 400-431
'             XYY format: X error code number (0-4), YY - bit number (0-31)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR
'state.0 = 1        'ERROR error code value error

    DIM state AS INTEGER = 0
    DIM bit_no AS INTEGER = 0

    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "* f_error() STARTED"

    IF error_code < 0 OR error_code > 431 THEN
        state = state OR 1 'ERROR error code value error
        RETURN state
    ENDIF

    IF error_code >= 0 AND error_code <= 15 THEN
        bit_no = error_code
        VR(vr_error_code_0).bit_no = ON
        VR(vr_enable).vr_enable_cb_alarm = ON
    ENDIF

    IF error_code >= 100 AND error_code <= 115 THEN
        bit_no = error_code - 100
        VR(vr_error_code_1).bit_no = ON
        VR(vr_enable).vr_enable_cb_alarm = ON
    ENDIF

    IF error_code >= 200 AND error_code <= 215 THEN
        bit_no = error_code - 200
        VR(vr_error_code_2).bit_no = ON
        VR(vr_enable).vr_enable_cb_alarm = ON
    ENDIF

    IF error_code >= 300 AND error_code <= 315 THEN
        bit_no = error_code -300
        VR(vr_error_code_3).bit_no = ON
        VR(vr_enable).vr_enable_cb_alarm = ON
    ENDIF

    IF error_code >= 400 AND error_code <= 415 THEN
        bit_no = error_code - 400
        VR(vr_error_code_4).bit_no = ON
        VR(vr_enable).vr_enable_cb_alarm = ON
    ENDIF

    RETURN state
ENDFUNC
'f_error(error_code AS INTEGER) AS INTEGER
'error_code = range 0-31; 100-131; 200-231; 300-331; 400-431
'             XYY format: X error code number (0-4), YY - bit number (0-31)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR
'state.0 = 1        'ERROR error code value error




'Set bit ON in specified word, used to trigger messages on HMI.
'Each bit trigger one message
'It simplifies warning message trigger machanism (event log).
'The best way is to include in event message the same value passed to this function, for examle
'If warning message is: "W103 Speed is equal 0!" it means that it is triggered by bit nubmer 3 in word number 1.
'It is easy to search for it on code. Use keys CTRL + ALT + f to search in entire project
'for keyword f_warning(103, "set") - to check where warning set logic is
'and f_warning(103, "reset") - to check where warning reset logic is
FUNCTION f_warning(warning_code AS INTEGER, option AS STRING) AS INTEGER
'warning_code = range 0-31; 100-131; 200-231; 300-331; 400-431
'             XYY format: X error code number (0-4), YY - bit number (0-31)
'option = string, "set" or "reset", set or reset warning
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR
'state.0 = 1        'ERROR error code value error
'state.1 = 1        'ERROR option selection error


    DIM state AS INTEGER = -1
    DIM bit_no AS INTEGER = 0
    DIM v_offset AS INTEGER = 0

    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "* f_warning() STARTED"

    IF warning_code < 0 OR warning_code > 431 THEN
        state = state OR 1 'error code value error
        RETURN state
    ENDIF

    IF NOT (option = "set" OR option = "reset") THEN
        state = state OR 2 'option value error
        RETURN state
    ENDIF

    IF warning_code >= 0 AND warning_code <= 15 THEN
        bit_no = warning_code
        IF option = "set" THEN
            SET_BIT(bit_no, vr_warning_code_0)
        ELSE
            CLEAR_BIT(bit_no, vr_warning_code_0)
        ENDIF
    ENDIF

    IF warning_code >= 100 AND warning_code <= 115 THEN
        bit_no = warning_code - 100
        IF option = "set" THEN
            SET_BIT(bit_no, VR(vr_warning_code_1))
        ELSE
            CLEAR_BIT(bit_no, VR(vr_warning_code_1))
        ENDIF
    ENDIF

    IF warning_code >= 200 AND warning_code <= 215 THEN
        bit_no = warning_code - 200
        IF option = "set" THEN
            SET_BIT(bit_no, VR(vr_warning_code_2))
        ELSE
            CLEAR_BIT(bit_no, VR(vr_warning_code_2))
        ENDIF
    ENDIF

    IF warning_code >= 300 AND warning_code <= 315 THEN
        bit_no = warning_code -300
        IF option = "set" THEN
            SET_BIT(bit_no, VR(vr_warning_code_3))
        ELSE
            CLEAR_BIT(bit_no, VR(vr_warning_code_3))
        ENDIF
    ENDIF

    IF warning_code >= 400 AND warning_code <= 415 THEN
        bit_no = warning_code - 400
        IF option = "set" THEN
            SET_BIT(bit_no, VR(vr_warning_code_4))
        ELSE
            CLEAR_BIT(bit_no, VR(vr_warning_code_4))
        ENDIF
    ENDIF

    RETURN state
ENDFUNC
'f_warning(warning_code AS INTEGER, option AS STRING) AS INTEGER
'warning_code = range 0-31; 100-131; 200-231; 300-331; 400-431
'             XYY format: X error code number (0-4), YY - bit number (0-31)
'option = string, "set" or "reset", set or reset warning
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR
'state.0 = 1        'ERROR error code value error
'state.1 = 1        'ERROR option selection error




'contain all necessary steps to initialise EtherCAT network
'see detailed code to check what exact EtherCAT commands are used, modify if needed. Usually this is the best way
'to hande EtherCAT initialisation.
'function automaticly detect if project is runing on MC400 simulator and if yes - skips unnecesarrry logic
'function wait some time using WA() command to wait for every EtherCAT devices to power on.
'Usually, controller power up faster than drives.
FUNCTION f_ecat_startup(devices_number AS INTEGER, tries_number AS INTEGER) AS INTEGER
'devices_number = any  'number of expected devices in the network
'tries_number = any    'number of initialization attempts
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR

    DIM state AS INTEGER = 0
    DIM i AS INTEGER = 0
    DIM result AS BOOLEAN = FALSE

    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "* f_ecat_startup() STARTED"

    IF NOT(CONTROL = 400) THEN 'if not MC400 simulator
        result = ETHERCAT($22, 0, vr_ecat_temp)
        IF (result AND VR(vr_ecat_temp) <> 3) OR NOT result THEN
            FOR i = 0 TO tries_number
                WA(ecat_init_delay_ms) 'wait for drives power up or initialise network
                WDOG = OFF
                WA(100)
                ETHERCAT($E0, 0, 1)
                WA(100)
                ETHERCAT(1, 0)
                WA(100)
                ETHERCAT(0, 0)
                WA(100)

                f_ecat_error_reset()
                state = f_ecat_test(devices_number)

                IF state <> -1 THEN
                    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), _
                            "*** f_ecat_startup() error detected "; state
                ELSE
                    EXIT_LOOP
                ENDIF
            NEXT i
        ELSE
            PRINT #VR(vr_debug_channel), "-> ETHERCAT ALREADY OPERATIONAL, SKIPPING INITIALIZATION"
            state = f_ecat_test(devices_number)
        ENDIF
    ELSE
        PRINT #VR(vr_debug_channel), "-> MC SIMULATOR DETECTED  ETHERCAT DISABLED"
    ENDIF

    IF state = 0 THEN
        state = -1
    ENDIF
    IF state <> -1 THEN
        IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "*** f_ecat_startup() error detected "; _
                state
        STOP
    ENDIF

    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "*** f_ecat_startup() ENDED. Code: "; state

    RETURN state
ENDFUNC
'f_ecat_startup(devices_number AS INTEGER, tries_number AS INTEGER) AS INTEGER
'devices_number = any  'number of expected devices in the network
'tries_number = any    'number of initialization attempts
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR




'check EtherCAT network informations, easy way to capture that  something is wrong
FUNCTION f_ecat_test(devices_number AS INTEGER) AS INTEGER
'devices_number = any 'number of expected devices on the network
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR
'state.0 = 1 'ECAT network state error (different from operational)
'state.1 = 1 'ECAT device count error
'state.2 = 1 'ecat stat error

    DIM state AS INTEGER = 0
    DIM status_flag AS BOOLEAN = FALSE

    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "* f_ecat_test() STARTED"

    IF CONTROL <> 400 AND VR(vr_simulation_mode).cb_vr_simulation_mode = OFF THEN
        status_flag = ETHERCAT($22, 0, vr_ecat_temp) 'sprawdzenie stanu sieci
        IF status_flag THEN
            IF VR(vr_ecat_temp) <> 3 THEN
                state = state OR 1 'błąd stanu sieci ECAT (różny od operacyjnego)
            ENDIF
        ENDIF

        status_flag = ETHERCAT($03, 0, vr_ecat_temp) 'sprawdzenie ilości urządzeń
        IF status_flag THEN
            IF VR(vr_ecat_temp) <> devices_number THEN
                VR(vr_detected_ecat_devices) = VR(vr_ecat_temp)
                state = state OR 2 'błąd ilości urządzeń ECAT error, for now not used DT
            ENDIF
        ENDIF

        IF (SYSTEM_ERROR AND $00ff0000) <> 0 THEN
            state = state OR 4 'błąd staci ecat
        ENDIF
    ENDIF

    IF state = 0 THEN
        state = -1
    ENDIF

    RETURN state
ENDFUNC
'f_ecat_test(devices_number AS INTEGER) AS INTEGER
'devices_number = any 'number of expected devices on the network
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR
'state.0 = 1 'ECAT network state error (different from operational)
'state.1 = 1 'ECAT device count error
'state.2 = 1 'ecat stat error




'one place to handle all resetting commands used for EtherCAT network
FUNCTION f_ecat_error_reset() AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR

    DIM state AS INTEGER = 0
    DIM i AS INTEGER =0
    DIM status_flag AS BOOLEAN = FALSE

    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "* f_ecat_error_reset() STARTED"



    status_flag = ETHERCAT($22, 0, vr_ecat_temp) 'sprawdzenie stanu sieci
    IF status_flag THEN
        IF VR(vr_ecat_temp) <> 3 THEN 'błąd stanu sieci ECAT (różny od operacyjnego)
            WDOG = OFF
            WA(100)
            ETHERCAT(0,0)
        ENDIF
    ENDIF


    FOR i = VR(vr_first_axis_number) TO VR(vr_last_axis_number)
        BASE(i)
        IF AXISSTATUS.3 THEN
            ETHERCAT($64,i)
            WA(10)
            DATUM(7)
        ENDIF
    NEXT i

    IF SYSTEM_ERROR <> 0 THEN
        UNIT_CLEAR
        WA(100)
    ENDIF

    DATUM(0) 'clears motion error

    state = -1
    RETURN state
ENDFUNC
'f_ecat_error_reset() AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR




'general purpouse timer, usefull to delay something
'this is non-blocking version, so usefull in cyclic loops
'timer's base is 1 second
'keep in mind that it is based on TICKS, and TICKS value is decresed once per SERVO_CYCLE.
'function is avare about possibility of different SERVO_PERIOD value
'function is used to set preset delay value and begin counting
FUNCTION f_timer_set_s(ticks_begin AS INTEGER, timer_vr AS INTEGER, delay_time_s AS INTEGER) AS INTEGER
'ticks_begin = TICK       'current timestamp
'timer_vr = any       'pointer to vr memory address, vr number to use
'delay_time_s = any time in s
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR

    DIM state AS INTEGER = 0
    VR(timer_vr) = ticks_begin - (delay_time_s * (1000000 / SERVO_PERIOD))

    state = -1
    RETURN state
ENDFUNC
'f_timer_set_s(ticks_begin AS INTEGER,timer_vr AS INTEGER, delay_time_s AS INTEGER) AS INTEGER
'ticks_begin = TICK       'current timestamp
'timer_vr = any       'pointer to vr memory address, vr number to use
'delay_time_s = any 'time in s
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR




'general purpouse timer, usefull to delay something
'this is non-blocking version, so usefull in cyclic loops
'timer's base is 1 second
'keep in mind that it is based on TICKS, and TICKS value is decresed once per SERVO_CYCLE.
'function is avare about possibility of different SERVO_PERIOD value
'function is used to check if counting is done already or not yet
FUNCTION f_timer_s(ticks_begin AS INTEGER, timer_vr AS INTEGER, delay_time_s AS INTEGER) AS INTEGER
'ticks_begin = TICK       'current timestamp
'timer = any       'pointer to vr memory address, vr number to use
'delay_time_s = any 'declared time in s in the set function (to check the correctness of operation)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR
'state =  1         'Function error (the stored time is longer than the counted time)

    DIM state AS INTEGER = 0


    IF VR(timer_vr) >= ticks_begin THEN
        state = -1
    ELSEIF VR(timer_vr) < (ticks_begin - (delay_time_s * (1000000 / SERVO_PERIOD))) THEN
        state = state OR 1 'error state,stored time is longer than cunted
    ELSE
        state = 0
    ENDIF

    RETURN state
ENDFUNC
'f_timer_s(ticks_begin AS INTEGER, timer_vr AS INTEGER, delay_time_s AS INTEGER) AS INTEGER
'ticks_begin = TICK       'current timestamp
'timer = any       'pointer to vr memory address, vr number to use
'delay_time_s = any 'declared time in s in the set function (to check the correctness of operation)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR
'state =  1         'Function error (the stored time is longer than the counted time)





'general purpouse timer, usefull to delay something
'this is non-blocking version, so usefull in cyclic loops
'timer's base is 1 mili second
'keep in mind that it is based on TICKS, and TICKS value is decresed once per SERVO_CYCLE.
'function is avare about possibility of different SERVO_PERIOD value
'function is used to set preset delay value and begin counting
FUNCTION f_timer_set_ms(ticks_begin AS INTEGER, timer_vr AS INTEGER, delay_time_ms AS INTEGER) AS INTEGER
'ticks_begin = TICK       'current timestamp
'timer = any       'pointer to vr memory address, vr number to use
'delay_time_ms = any 'declared time in ms in the set function (to check the correctness of operation)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR
'state =  1

    DIM state AS INTEGER = 0

    VR(timer_vr) = ticks_begin - (delay_time_ms * (1000 / SERVO_PERIOD))

    state = -1
    RETURN state
ENDFUNC
'f_timer_set_ms(ticks_begin AS INTEGER, timer_vr AS INTEGER, delay_time_ms AS INTEGER) AS INTEGER
'ticks_begin = TICK       'current timestamp
'timer = any       'pointer to vr memory address, vr number to use
'delay_time_ms = any 'declared time in ms in the set function (to check the correctness of operation)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR
'state =  1         'Function error (the stored time is longer than the counted time)




'general purpouse timer, usefull to delay something
'this is non-blocking version, so usefull in cyclic loops
'timer's base is 1 second
'keep in mind that it is based on TICKS, and TICKS value is decresed once per SERVO_CYCLE.
'function is avare about possibility of different SERVO_PERIOD value
'function is used to check if counting is done already or not yet
FUNCTION f_timer_ms(ticks_begin AS INTEGER, timer_vr AS INTEGER, delay_time_ms AS INTEGER) AS INTEGER
'ticks_begin = TICK       'current timestamp
'timer = any       'pointer to vr memory address, vr number to use
'delay_time_ms = any 'declared time in ms in the set function (to check the correctness of operation)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR
'state =  1         'Function error (the stored time is longer than the counted time)

    DIM state AS INTEGER = 0

    IF VR(timer_vr) >= ticks_begin THEN
        state = -1
    ELSEIF VR(timer_vr) < (ticks_begin - (delay_time_ms * (1000 / SERVO_PERIOD))) THEN
        state = 1 'zgłoś błąd poprawności odliczanego czasu (zapamiętany czas jest dłóższy niż odliczany)
    ELSE
        state = 0
    ENDIF

    RETURN state
ENDFUNC
'f_timer_ms(ticks_begin AS INTEGER, timer_vr AS INTEGER, delay_time_ms AS INTEGER) AS INTEGER
'ticks_begin = TICK       'current timestamp
'timer = any       'pointer to vr memory address, vr number to use
'delay_time_ms = any 'declared time in ms in the set function (to check the correctness of operation)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR
'state =  1         'Function error (the stored time is longer than the counted time)




'used to configure Modbus TCP/IP
'below set configure all VR to use 32bit signed data type
'it is good copromise, float are usually more complex and not required
'it is easier TO multiply valu by FOR example 100 AND THEN ON hmi make division (/100)
FUNCTION f_modbus_tcp_config() AS INTEGER
'The function defines modbus communication for the WEINTEK HMI for the MODE 7 controller (32bit)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR

    DIM state AS INTEGER = 0

    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "* f_modbus_tcp_config() STARTED"

    'Modbus TCP port number
    ETHERNET(1,-1,10,502)
    'Modbus TCP
    ETHERNET(1,-1,14,0,1,3)
    ETHERNET(1,-1,14,0,2,1)
    ETHERNET(1,-1,14,0,6,1)
    IP_PROTOCOL_CTRL = 0 ' start the Modbus TCP protocol

    state = -1
    RETURN state
ENDFUNC
'f_modbus_tcp_config() AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR




'all comands to make motors stop sequence the same every time
'sometimes dofferent behaviour is required, that is why there is stop_category parameter
FUNCTION f_safety_stop(stop_category AS INTEGER) AS INTEGER
'stop_category  - any
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR

    DIM i AS INTEGER
    DIM state AS INTEGER = 0

    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "* f_safety_stop() STARTED ";stop_category


    STOP "AUTO_MODE"
    STOP "HOMING_MODE"
    STOP "JOG_MODE"
    STOP "MANUAL_MODE"

    VR(vr_process_enabled) = 0
    VR(vr_process_run) = 0
    VR(vr_enable).vr_enable_cb_terminate_flag = OFF
    VR(vr_enable).vr_enable_cb_one_cycle_flag = OFF
    VR(vr_enable).vr_enable_cb_start_from_hmi = OFF

    IF stop_category = 0 THEN
        OP(do_column_buzzer,ON)
        TIMER(2, do_column_buzzer, 1, 500) 'turns ON output for 500 milisec

        VR(vr_enable).vr_enable_cb_enable_from_safety = OFF
        VR(vr_enable).vr_enable_cb_enable_from_hmi = OFF
        VR(vr_do_force_mask_0) = 0
    ENDIF
    FOR i = c_ax_example TO c_ax_example

        BASE(i)
        FWD_START = 0
        REV_START = 0
    NEXT i


    RAPIDSTOP(2)
    REPEAT
    UNTIL f_all_axis_idle()
    WA(100)'give time to stop

    IF stop_category = 0 THEN
        WDOG = OFF
        OP(do_column_buzzer,OFF)
        'Disable all output
        'OP(0, 10, FALSE)
        ' OP(12, 15, FALSE)
    ENDIF

    state = -1
    RETURN state
ENDFUNC
'f_safety_stop(stop_category AS INTEGER) AS INTEGER
'stop_category  - any
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR




'all comands to make motors start sequence the same every time
'sometimes dofferent behaviour is required, that is why there is start_category parameter
FUNCTION f_safety_start(start_category AS INTEGER, last_axis_no AS INTEGER ) AS INTEGER
'start_category = any
'last_axis_no = any   'number of all axes
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR

    DIM state AS INTEGER = 0
    DIM i AS INTEGER = 0
    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "* f_safety_start() STARTED ";start_category

    WA(10)

    'Stop all programs from running
    VR(vr_process_enabled) = 0
    VR(vr_do_force_mask_0) = 0

    OP(0, 31, OFF)
    OP(32, 63, OFF)
    OP(64, 95, OFF)


    FOR i = VR(vr_first_axis_number) TO last_axis_no
        BASE(i)
        SERVO = ON
        AXIS_ENABLE = ON
        DATUM(0)
    NEXT i

    WDOG = ON 'enables the motors

    state = -1
    RETURN state
ENDFUNC
'f_safety_start(start_category AS INTEGER, last_axis_no AS INTEGER ) AS INTEGER
'start_category = any
'last_axis_no = any   'number of all axes
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR




'check if SD card is detected and other usefull informations
FUNCTION f_sd_check() AS INTEGER
'f_sd_check() AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR
'state.0 = 1 'ERROR no SD card detected
'state.1 = 1 'ERROR SD card size below 8GB
'state.2 = 1 'ERROR free space

    DIM sd_detect AS INTEGER = 0
    DIM sd_size AS INTEGER = 0
    DIM sd_free AS INTEGER = 0
    DIM state AS INTEGER = 0

    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "* f_sd_check() STARTED "

    state = 0

    sd_detect = FILE "DETECT"
    IF sd_detect = FALSE THEN
        state = state OR 1
    ENDIF

    sd_size = FILE "DISK_SIZE"
    PRINT sd_size
    IF sd_size < 8000000000 THEN '
        state = state OR 2
    ENDIF

    sd_free = FILE "DISK_FREE"
    PRINT sd_free
    IF sd_free < 1000000000 THEN
        state = state OR 3
    ENDIF

    IF state = 0 THEN
        state = -1
    ENDIF

    RETURN state
ENDFUNC
'f_sd_check() AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR
'state.0 = 1 'ERROR no SD card detected
'state.1 = 1 'ERROR SD card size below 8GB
'state.2 = 1 'ERROR free space




'force window change on HMI using this function
FUNCTION f_hmi_open_window(new_window AS INTEGER) AS INTEGER
'new_window_v = any
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR

    DIM state AS INTEGER = 0

    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "* f_hmi_open_window() STARTED "


    VR(vr_hmi_open_window) = 0 'just in case
    WA(300)
    VR(vr_hmi_open_window) = new_window
    WA(300) 'The HMI must notice the window change
    'WAIT UNTIL VR(vr_hmi_open_window)<> new_window

    state = -1
    RETURN state

ENDFUNC
'f_hmi_open_window(new_window AS INTEGER) AS INTEGER
'new_window_v = any
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR




'to set every required axis parameter here, Add more if needed
FUNCTION f_axis_startup(first_axis_number AS INTEGER, last_axis_number AS INTEGER) AS INTEGER
'first_axis_number = INTEGER
'last_axis_number = INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR

    DIM state AS INTEGER = 0
    DIM i AS INTEGER = 0
    DIM delay AS INTEGER = 50
    DIM pn100 AS INTEGER = 0
    DIM pn102 AS INTEGER = 0
    DIM pn103 AS INTEGER = 0
    DIM pn106 AS INTEGER = 0
    DIM pn001 AS INTEGER = 0

    IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel), "* f_axis_startup() STARTED "


    FOR i = 0 TO 11
        INVERT_IN(100 + i, ON)
    NEXT i

    BASE(c_ax_example)
    UNITS = VR(vr_units_ax_example) '2^23
    FE_LIMIT = VR(vr_fe_limit_ax_example)' 50
    DRIVE_FE_LIMIT = FE_LIMIT
    FE_RANGE = FE_LIMIT / 2
    SPEED = VR(vr_speed_max_ax_example)
    CREEP = 1
    ACCEL = VR(vr_acc_dec_max_ax_example)
    DECEL = ACCEL
    FASTDEC = DECEL * 100
    JERK = VR(vr_jerk_max_ax_example)
    FASTJERK = JERK * 100
    VP_MODE = 6
    JOGSPEED = SPEED
'    FWD_JOG = 100
'    REV_JOG = 101
    P_GAIN = VR(vr_p_gain_ax_example) / 1000 '0.065'0.08'0.05
    I_GAIN = VR(vr_i_gain_ax_example) / 1000 ' 0'0.00001'0.002
    D_GAIN = VR(vr_d_gain_ax_example) / 1000 ' 0.6
    REP_DIST = 360
    REP_OPTION = 1
    FS_LIMIT = REP_DIST * 2
    RS_LIMIT = -REP_DIST * 2
    AXIS_MODE.12 = ON
    'INVERT_IN(di_sens_home_ax_example, ON)' For NO contact of home sensor
    'DATUM_IN = di_sens_home_ax_example
    DEFPOS(0.00)


    IF VR(vr_simulation_mode).cb_vr_simulation_mode = OFF THEN
'        pn001 = 1 'change plus direction
'        IF NOT CO_WRITE_AXIS(BASE,$3001,0,6,-1,pn001) THEN
'            IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel),"Error - failed to write CO_WRITE_AXIS";BASE;_
'                    " to 0x3001 value",pn001
'        ENDIF
'        WA(delay)

'        pn100 = 0 'enable manual tuing
'        IF NOT CO_WRITE_AXIS(BASE,$3010,0,6,-1,pn100) THEN
'            IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel),"Error - failed to write CO_WRITE_AXIS";BASE;_
'                    " to 0x3010 value",pn100
'        ENDIF
'        WA(delay)
'
'        pn102 = VR(vr_pn102_ax_example) '100 'set speed loop gain
'        IF NOT CO_WRITE_AXIS(BASE,$3012,0,6,-1,pn102) THEN
'            IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel),"Error - failed to write CO_WRITE_AXIS";BASE;_
'                    " to 0x3012 value",pn102
'        ENDIF
'        WA(delay)
'
'        pn103 = VR(vr_pn103_ax_example) '800 'set inegral time cosntant
'        IF NOT CO_WRITE_AXIS(BASE,$3013,0,6,-1,pn103) THEN
'            IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel),"Error - failed to write CO_WRITE_AXIS";BASE;_
'                    " to 0x3013 value",pn103
'        ENDIF
'        WA(delay)
'
'        pn106 = VR(vr_pn106_ax_example) 'set inertia ratio
'        IF NOT CO_WRITE_AXIS(BASE,$3016,0,6,-1,pn106) THEN
'            IF VR(vr_debug_level) AND 2 THEN PRINT #VR(vr_debug_channel),"Error - failed to write CO_WRITE_AXIS";BASE;_
'                    " to 0x3016 value",pn106
'        ENDIF
    ENDIF
    state = -1
    RETURN state
ENDFUNC
'f_axis_startup() AS INTEGER
'first_axis_number = INTEGER
'last_axis_number = INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR




'check if all axes are IN_POS
'usefull if axes have good tuning.
'might be blocking if axes have bad tuning and huge following error
'adjust IN_POS_DIST and IN_POS_SPEED if needed
FUNCTION f_all_axis_inpos() AS BOOLEAN
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR

    DIM i AS INTEGER = 0

    FOR i = c_ax_example TO c_ax_example
        REPEAT
            WA(1)
        UNTIL f_axis_inpos(i)
    NEXT i
    RETURN TRUE
ENDFUNC
'f_all_axis_inpos() AS BOOLEAN
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR






'check if selected axis is IN_POS
'usefull if axis have good tuning.
'might be blocking if axis have bad tuning and huge following error
'adjust IN_POS_DIST and IN_POS_SPEED if needed
FUNCTION f_axis_inpos(axis_no AS INTEGER) AS BOOLEAN
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR

    IF IN_POS AXIS(axis_no)THEN
        RETURN TRUE
    ELSE
        RETURN FALSE
    ENDIF
ENDFUNC
'f_axis_inpos(axis_no AS INTEGER) AS BOOLEAN
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR




'check if all axes are IDLE
'sometimes IN_POS is better than IDLE - compare them in manual and choose
FUNCTION f_all_axis_idle() AS BOOLEAN
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR

    DIM i AS INTEGER = 0

    FOR i = c_ax_example TO c_ax_example
        REPEAT
            WA(1)
        UNTIL f_axis_idle(i)
    NEXT i
    RETURN TRUE
ENDFUNC
'f_all_axis_idle(axis_no AS INTEGER) AS BOOLEAN
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR




'check if selected axis is IDLE
'sometimes IN_POS is better than IDLE - compare them in manual and choose
FUNCTION f_axis_idle(axis_no AS INTEGER) AS BOOLEAN
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR

    IF IDLE AXIS(axis_no)THEN
        RETURN TRUE
    ELSE
        RETURN FALSE
    ENDIF
ENDFUNC
'f_axis_idle(axis_no AS INTEGER) AS BOOLEAN
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR




'used mainly together with SP motion types (MOVESP, MOVEABSSP etc)
'to set correct vector speed
FUNCTION f_set_velocity_profile() AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'GENERAL ERROR

    DIM state AS INTEGER = 0

    SPEED = VR(vr_speed_max_ax_example) ' + (BASE - 1))


    FORCE_SPEED = SPEED
    ACCEL = VR(vr_acc_dec_max_ax_example)' + (BASE - 1))
    DECEL = ACCEL
    FASTDEC = DECEL * 10
    JERK = VR(vr_jerk_max_ax_example) '+ (BASE - 1))
    FASTJERK = JERK * 10

    RETURN state = -1
ENDFUNC
'f_set_velocity_profile() AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR




'force an immediate forward jog motion if FWD_JOG = -1
FUNCTION f_jog_plus(axis_no AS INTEGER)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR

    IF (MTYPE AXIS(axis_no) = 0) AND ((AXISSTATUS AXIS(axis_no) AND 512) = 0) THEN
        WA(20)
        FWD_START AXIS(axis_no) = 1
        'PRINT #5, "  ";axis_no, -TICKS
    ENDIF
ENDFUNC
'f_jog_plus(axis_no AS INTEGER)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR




'force an immediate revese jog motion if REV_JOG = -1
FUNCTION f_jog_minus(axis_no AS INTEGER)
    IF (MTYPE AXIS(axis_no) = 0) AND ((AXISSTATUS AXIS(axis_no) AND 1024) = 0) THEN
        WA(20)
        REV_START AXIS(axis_no) = 1
        'PRINT #5, axis_no;"  ", -TICKS
    ENDIF
ENDFUNC
'f_jog_minus(axis_no AS INTEGER)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR



'unforce an immediate jog motion
FUNCTION f_jog_cancel(axis_no AS INTEGER)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR

    IF FWD_START AXIS(axis_no) <> 0 OR REV_START AXIS(axis_no) <> 0 THEN
        FWD_START AXIS(axis_no) = 0
        REV_START AXIS(axis_no) = 0
        'PRINT #5, " ";axis_no;" ", -TICKS
    ENDIF
ENDFUNC
'f_jog_cancel(axis_no AS INTEGER)
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR




'used to set serial port parameters
FUNCTION f_set_rs485_port() AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR

    DIM station_no AS INTEGER = 2
    DIM baudrate AS INTEGER = 19200
    DIM databits AS INTEGER = 8
    DIM stopbits AS INTEGER = 1
    DIM parity AS INTEGER = 0 '0 - none, 1 - odd, 2 - even
    DIM port_no AS INTEGER = 2
    DIM mode AS INTEGER = 11 '11 - Modbus RTU Master
    DIM variable AS INTEGER = 0 '0 - VR
    DIM timeout AS INTEGER = 100
    DIM network_type AS INTEGER = 1 '0 - RS485 4W, 1 - RS485 2W

    DIM state AS INTEGER = 0
    ADDRESS = station_no
    'SETCOM(baudrate, databits, stopbits, parity, PORT[, mode][, variable][, timeout][, linetype])
    SETCOM(baudrate, databits, stopbits, parity, port_no, mode, variable, timeout, network_type)


    state = -1
    RETURN state
ENDFUNC
'f_set_rs485_port() AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR




'used to close any opened connection via MODBUS master connection
FUNCTION f_modbus_rtu_close_connections()AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR

    DIM state AS INTEGER = 0
    DIM result AS BOOLEAN = FALSE
    DIM function_no AS INTEGER = 0
    DIM slot_no AS INTEGER = -1
    DIM i AS INTEGER = 0
    DIM check_any_open_handle AS INTEGER = 0

    FOR i = 0 TO 11
        function_no = 2 ' get status
        IF NOT MODBUS(function_no, slot_no, check_any_open_handle, vr_modbus_handle) THEN
            PRINT #VR(vr_debug_channel),"Error: failed to check port status, handle: ";i[0]
        ELSE
            'Read connection status ok, now close if it is open
            IF VR(vr_modbus_handle) = 1 THEN
                function_no = 1 ' close connection
                IF NOT MODBUS(function_no, slot_no, i) THEN
                    'Error failed to close the port
                    PRINT #VR(vr_debug_channel),"Error: failed to close connection, handle ";i[0]
                    STOP
                ELSE
                    PRINT #VR(vr_debug_channel),"Closed connection, handle ";i[0]
                ENDIF
            ENDIF
        ENDIF
    NEXT i
    RETURN state = -1
ENDFUNC
'f_modbus_rtu_close_connections() AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR




'used to open  MODBUS master connection
FUNCTION f_modbus_rtu_open_connection()AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR

    DIM state AS BOOLEAN = FALSE
    DIM result AS BOOLEAN = FALSE
    DIM function_no AS INTEGER = 0
    DIM modbus_function AS INTEGER = $03
    DIM slot_no AS INTEGER = -1
    DIM network_type AS INTEGER = -2 '-2 - RS485
    DIM connection_type AS INTEGER = 0 '0 - client
    DIM unit_id AS INTEGER = 1
    DIM cmd_timeout AS INTEGER = 1000
    DIM char_timeout AS INTEGER = 100
    DIM i AS INTEGER = 0
    DIM begin_adress AS INTEGER = 0
    DIM cout AS INTEGER = 0


    function_no = 0
    result = MODBUS(function_no, slot_no, network_type, connection_type, _
        vr_modbus_handle, unit_id, cmd_timeout, char_timeout)
    IF NOT result THEN
        PRINT #VR(vr_debug_channel),"Failed to open Modbus Client session"
        STOP
    ELSE
        PRINT #VR(vr_debug_channel),"Opened Modbus Client with handle ";VR(vr_modbus_handle)[0]
    ENDIF

    state = -1
    RETURN state
ENDFUNC
'f_modbus_rtu_open_connection() AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR




'used to read data via MODBUS master
FUNCTION f_modbus_rtu_read_data()AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR

    DIM state AS BOOLEAN = FALSE
    DIM result AS BOOLEAN = FALSE
    DIM function_no AS INTEGER = 0
    DIM modbus_function AS INTEGER = $03
    DIM slot_no AS INTEGER = -1
    DIM unit_id AS INTEGER = 1
    DIM i AS INTEGER = 0
    DIM begin_adress AS INTEGER = 2307
    DIM cout AS INTEGER = 2

    function_no = 3
    result = MODBUS(function_no, slot_no, vr_modbus_handle, modbus_function, _
        begin_adress, cout, vr_weight)

    state = -1
    RETURN state
ENDFUNC
'f_modbus_rtu_read_data() AS INTEGER
'
'RETURN state
'state =  -1 (TRUE) 'OK
'state =   0 (FALSE)'ERROR


