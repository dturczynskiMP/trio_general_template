ON BASICERROR GOTO error_routine



'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~LOCAL VARIABLES DEFINITION
DIM i AS INTEGER = 0
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


DIM pozycja_dojazdu_x1 AS FLOAT = 0
DIM pozycja_dojazdu_x2 AS FLOAT = 0
DIM pozycja_dojazdu_y AS FLOAT = 0
DIM pozycja_dojazdu_z AS FLOAT = 0
DIM pozycja_dojazdu_a AS FLOAT = 0
DIM pozycja_dojazdu_b AS FLOAT = 0
DIM poz_odczytana AS FLOAT = 0
DIM poz_sprawdzenia AS FLOAT = 0
DIM pozycja_powrotu_x AS FLOAT = 0
DIM pozycja_powrotu_y AS FLOAT = 0
DIM pozycja_powrotu_z AS FLOAT = 0
DIM pozycja_powrotu_a AS FLOAT = 0
DIM wykonane_obroty_b1 AS FLOAT = 0
DIM wykonane_obroty_b_calk1 AS INTEGER = 0
DIM pozycja_docelowa_b1 AS FLOAT = 0
DIM pozycja_docelowa_b_11 AS FLOAT = 0
DIM pozycja_powrotu_b1 AS FLOAT = 0
DIM time_passed AS FLOAT = 0
DIM pozostala_prod AS INTEGER = 0
DIM pozostaly_czas_sek AS INTEGER = 0
DIM pozostaly_czas_min AS INTEGER = 0
DIM ilosc_obrotow_finalna AS FLOAT = 0
DIM ilosc_obrotow_calkowita AS FLOAT = 0
DIM pozycja_zerowania_b AS FLOAT = 0
DIM aktualna AS FLOAT = 0
DIM dystans AS FLOAT = 0


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~INITIALIZATION OF VARIABLES
VR(vr_auto_mode_step) = 0
'f_hmi_open_window(27)
VR(vr_selected_program_row_id) = 0
VR(vr_efficiency_per_min) = 0
VR(vr_cycle_time_ms) = 0
VR(vr_time_to_end_hh) = 0
VR(vr_time_to_end_mm) = 0
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MODE INITIALIZATION
'f_warning(2,"set") 'Uwaga, uruchomileś proces AUTO
WA(500)


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MODE INFINITE LOOP


WHILE VR(vr_process_enabled) = c_process_run_auto_mode OR _
        VR(vr_process_enabled) = c_process_run_manual_mode
    SELECT_CASE VR(vr_auto_mode_step)
        CASE 0
        CASE 3
            WA(10)
            IF VR(vr_process_enabled) <> VR(vr_process_run) THEN
                'normal stop, with process stop procedure
                VR(vr_auto_mode_step) = 10
            ELSEIF VR(vr_enable).vr_enable_cb_start_from_hmi = OFF THEN
                'normal stop, with process stop procedure
                VR(vr_auto_mode_step) = 10
            ELSE
                VR(vr_auto_mode_step) = 0
            ENDIF

        CASE 10
            WA(10)
            'f_warning(2,"reset") 'Uwaga, uruchomileś proces AUTO
            VR(vr_auto_mode_step) = 11

        CASE 11
            EXIT_LOOP

        CASE ELSE
            VR(vr_auto_mode_step) = 0
    END_CASE
    '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MODE CYCLIC SECTION
WEND
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MODE EXIT SECTION
WA(1000)
STOP




error_routine:
IF RUN_ERROR <> 0 AND RUN_ERROR <> 31 THEN ' 31 is normal stop. Hence not an error

    WDOG = OFF
    CANCEL
    OP(0)
    'f_error(7)
    VR(vr_run_error_code_12) = RUN_ERROR
    VR(vr_run_error_line_12) = ERROR_LINE

    IF vr_debug_level AND 1 THEN
        PRINT #VR(vr_debug_channel), "* RUN_ERROR: ";RUN_ERROR[0];" LINE: ";ERROR_LINE[0]; " AUTO_MODE"
    ENDIF

    STOP'***********************************
ENDIF


