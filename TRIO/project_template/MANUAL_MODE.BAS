'======= MANUAL MODE =======
'It works like this: using MPG (manual pulse generator, handwheel, you can test whole program

ON BASICERROR GOTO error_routine



'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~LOCAL VARIABLES DEFINITION
DIM zwloka AS INTEGER = 0
DIM i AS INTEGER = 0
DIM predkosc AS INTEGER = 24
DIM accdist AS FLOAT = 0
DIM decdist AS FLOAT = 0

DIM column_01_x1 AS FLOAT = 0
DIM column_02_x2 AS FLOAT = 0
DIM column_03_y AS FLOAT = 0
DIM column_04_z AS FLOAT = 0
DIM column_05_a AS FLOAT = 0
DIM column_06_f AS INTEGER = 0
DIM column_07_yf AS FLOAT = 0
DIM column_08_t AS INTEGER = 0
DIM column_09_j AS INTEGER= 0
DIM column_10_l AS INTEGER = 0
DIM column_11_b AS INTEGER = 0
DIM column_12_d AS INTEGER = 0

DIM start_krok AS INTEGER = 0
DIM wejscie AS INTEGER = 0
DIM powtorzenie AS INTEGER = 0

DIM drogax AS FLOAT = 0
DIM drogay AS FLOAT = 0
DIM drogaz AS FLOAT = 0
DIM drogaa AS FLOAT = 0
DIM drogab AS FLOAT = 0

DIM baza AS FLOAT = 0
DIM dystans AS FLOAT = 0
DIM aktualna AS FLOAT = 0
DIM obrot_lewo AS INTEGER = 0
DIM odleglosc_move AS FLOAT = 0
DIM poz_odczytana AS FLOAT = 0
DIM poz_sprawdzenia AS FLOAT = 0




'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~INITIALIZATION OF VARIABLES
VR(vr_manual_mode_step) = 0


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MODE INITIALIZATION
'f_warning(3,"set") 'Uwaga, uruchomileś proces MANUAL
f_hmi_open_window(27)
WA(500)


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MODE INFINITE LOOP


WHILE VR(vr_process_enabled) = c_process_run_auto_mode OR _
        VR(vr_process_enabled) = c_process_run_manual_mode

    SELECT_CASE VR(vr_manual_mode_step)
        CASE 0
        CASE 3
            WA(100)
            IF VR(vr_process_enabled) <> VR(vr_process_run) THEN
                'normal stop, with process stop procedure
                VR(vr_manual_mode_step) = 10
            ELSEIF VR(vr_enable).vr_enable_cb_start_from_hmi = OFF _
                    OR VR(vr_enable).vr_enable_cb_one_cycle_flag = ON THEN
                VR(vr_enable).vr_enable_cb_one_cycle_flag = OFF
                'normal stop, with process stop procedure
                VR(vr_manual_mode_step) = 10
            ELSE
                VR(vr_manual_mode_step) = 0
            ENDIF

        CASE 10
            RAPIDSTOP(2)
            WA(100)
            'f_warning(2,"reset") 'Uwaga, uruchomileś proces AUTO
            VR(vr_manual_mode_step) = 11


        CASE 11
            EXIT_LOOP

        CASE ELSE
            VR(vr_manual_mode_step) = 0
    END_CASE
    '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MODE CYCLIC SECTION
WEND


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MODE EXIT SECTION
WA(1000)
STOP

error_routine:
IF RUN_ERROR <> 31 THEN ' 31 is normal stop. Hence not an error

    WDOG = OFF
    RAPIDSTOP(2)
    OP(0)
    ' f_error(8)
    VR(vr_run_error_code_12) = RUN_ERROR
    VR(vr_run_error_line_12) = ERROR_LINE

    IF VR(vr_debug_level) AND 1 THEN
        PRINT #VR(vr_debug_channel), "* RUN_ERROR: ";RUN_ERROR[0];" LINE: ";ERROR_LINE[0]; " MANUAL_MODE"
    ENDIF

    STOP'***********************************
ENDIF
STOP

