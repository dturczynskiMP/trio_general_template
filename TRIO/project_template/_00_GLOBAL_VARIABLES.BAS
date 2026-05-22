'Copyright 2026 Multiprojekt Automatyka sp. z o.o.
'
'licensed under the apache license, VERSION 2.0 (the "License");
'you may NOT use this FILE except IN compliance with the license.
'you may obtain a COPY of the license at
'
'http://www.apache.org/licenses/license-2.0
'
'unless required by applicable law OR agreed TO IN writing, software
'distributed under the license is distributed ON an "AS IS" basis,
'without warranties OR conditions of any kind, either express OR implied.
'see the license FOR the specific language governing permissions AND
'limitations under the license.
'
'
'
'_00_GLOBAL_VARIABLES File
'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~File structure:
'   0.) Clear data
'   1.) Definition space of constants
'   2.) Name definition space for intputs and outputs
'   3.) Name definition space for VR
'   4.) run MAIN
'
'   1.) The constant name starts with
'       c_ - (constant) means constant value
'       cb_ - (constant bit) name of the associated variable, constant bit designation
'       for example:
'           CONSTANT "c_ax0", 0
'           CONSTANT "c_max_speed", 100
'       Use:
'           IF SPEED AXIS(c_axis1) > c_max_speed THEN
'           SPEED AXIS(c_axis1) = c_max_speed
'
'
'
'   2.) The input or output name starts with:
'       di_ - (digital intput) prefix indicate digital intput
'       do_ - (digital output) prefix indicate igital output
'       ai_ - (analog intput) prefix indicate analog intput
'       ao_ - (analog output) prefix indicate analog output
'       vdi_ - (virtual digital intput) prefix indicate virtual digital intput
'       vdo_ - (virtual digital output) prefix indicate virtual digital output
'       vai_ - (virtual analog intput) prefix indicate virtual analog intput
'       vao_ - (virtual analog output) prefix indicate virtual analog output
'       for example:
'           CONSTANT "di_sens_datum_ax_0", 0
'       Use:
'           IN(di_sens_datum_ax_0)
'
'       Names should be created according to the principle from general to specific.
'       The name should indicate the type of device (e.g. sensor, button, sensor),
'       location (e.g. hmi, engine34), function (e.g. start, stop, pressure)
'       for example:
'           CONSTANT "di_sens_ax2_pos_left", 0
'       Use:
'           IN(di_sens_ax2_pos_left)
'
'       Tag names should be arranged in ascending order of assigned numbers.
'       for example:
'       CONSTANT "ai_sens_Laser_1" , 0
'       CONSTANT "ai_sens_Laser_2" , 1
'       CONSTANT "ai_sens_Laser_3" , 2
'
'
'
'   3.) The VR name starts with
'       vr_ - (VR) means pointer to VR memory space
'       for example:
'           CONSTANT "vr_master_state", 1
'       Use:
'           VR(vr_master_state) = 0
'
'       A pointer to a specific bit of a VR should be created by repeating the VR name
'       it refers to, adding the note cb_ (constant bit) and the name of the pointer.
'       Pointers should be located under the definition of the main VR name.
'       for example:
'           CONSTANT "vr_master_state", 1
'           CONSTANT "cb_master_state_active" , 0
'           CONSTANT "cb_master_state_datum" , 1
'           CONSTANT "cb_master_state_error" , 2
'       Use:
'           VR(vr_master_state).cb_master_state_datum = ONW
'



CONSTANT 'clear old definition
GLOBAL 'clear old definition

'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Definition space of constant variables
CONSTANT "c_ax_example", 1
CONSTANT "ground_level", 0.5
CONSTANT "ecat_init_delay_ms", 5000

'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Definition space for intputs and outputs
'
CONSTANT "di_example" , 0 'czujnik bazowania dla osi X


CONSTANT "do_example" , 0
CONSTANT "do_column_red_light", 1
CONSTANT "do_column_yellow_light", 2
CONSTANT "do_column_green_light", 3
CONSTANT "do_column_buzzer", 4


'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Name definition space for VR
'
CONSTANT "vr_never_use", 0 'For safety, never use VR(0)
CONSTANT "vr_run_error_code_01", 1 'Internal process error code number
CONSTANT "vr_run_error_line_01", 2 'Internal process error line number
CONSTANT "vr_run_error_code_02", 3 'Internal process error code number
CONSTANT "vr_run_error_line_02", 4 'Internal process error line number
CONSTANT "vr_run_error_code_03", 5 'Internal process error code number
CONSTANT "vr_run_error_line_03", 6 'Internal process error line number
CONSTANT "vr_run_error_code_05", 7 'Internal process error code number
CONSTANT "vr_run_error_line_05", 8 'Internal process error line number
CONSTANT "vr_run_error_code_06", 9 'Internal process error code number
CONSTANT "vr_run_error_line_06", 10 'Internal process error line number
CONSTANT "vr_run_error_code_10", 11 'Internal process error code number
CONSTANT "vr_run_error_line_10", 12 'Internal process error line number
CONSTANT "vr_run_error_code_11", 13 'Internal process error code number
CONSTANT "vr_run_error_line_11", 14 'Internal process error line number
CONSTANT "vr_run_error_code_12", 15 'Internal process error code number
CONSTANT "vr_run_error_line_12", 16 'Internal process error line number
CONSTANT "vr_run_error_code_13", 17 'Internal process error code number
CONSTANT "vr_run_error_line_13", 18 'Internal process error line number

'to address (inclusive) 19 reserve for internal process error

CONSTANT "vr_warning_code_0", 20 'Process warning code
' = 0 - brak ostrzeżeń
' = 1 - (Bit 0) Warning 0 - Uwaga, uruchomileś proces HOMING
' = 2 - (Bit 1) Warning 1 - Uwaga, uruchomileś proces JOG
' = 4 - (Bit 2) Warning 2 - Uwaga, uruchomileś proces AUTO
' = 8 - (Bit 3) Warning 3 - Uwaga, uruchomileś proces MANUAL
' = 16 - (Bit 4) Warning 4 - Uwaga, brak wybranego trybu pracy
' = 32 - (Bit 5) Warning 5 -
' = 64 - (Bit 6) Warning 6 -
' = 128 - (Bit 7) Warning 7 -
' = 254 - (Bit 8) Warning 8 -
' = 512 - (Bit 9) Warning 9 -
' = 1024 - (Bit 10) Warning 10 -
' = 2048 - (Bit 11) Warning 11 -
' = 4096 - (Bit 12) Warning 12 -
' = 8192 - (Bit 13) Warning 13 -
' = 16384 - (Bit 14) Warning 14 -
' = 32768 - (Bit 15) Warning 15 -
CONSTANT "vr_warning_code_1", 21 'Process warning code
CONSTANT "vr_warning_code_2", 22 'Process warning code
CONSTANT "vr_warning_code_3", 23 'Process warning code
CONSTANT "vr_warning_code_4", 24 'Process warning code

'to address (inclusive) 39 reserve for warning code


CONSTANT "vr_error_code_0", 40 'Process error code
'CONSTANT "c_vr_error_code_0", 40
' = 0 - brak błędów
' = 1 - (Bit 0) Error 0 - Błąd stanu sieci ECAT (różny od operacyjnego)
' = 2 - (Bit 1) Error 1 - Błąd ilości urządzeń ECAT
' = 4 - (Bit 2) Error 2 - Błąd sieci ECAT
' = 8 - (Bit 3) Error 3 - Błąd systemu bezpieczeństwa
' = 16 - (Bit 4) Error 4 - Błąd HMI
' = 32 - (Bit 5) Error 5 -  Błąd zatrzymania procesu HOMING_MODE
' = 64 - (Bit 7) Error 6 - Błąd zatrzymania procesu _11_JOG_MODE
' = 128 - (Bit 6) Error 7 - Błąd zatrzymania procesu _12_AUTO_MODE
' = 254 - (Bit 7) Error 8 - Błąd zatrzymania procesu _13_MANUAL_MODE


' ....

CONSTANT "vr_error_code_1", 41 'Process error code
'CONSTANT "c_vr_error_code_1", 41
' = 0 - brak błędów
' = 1 - (Bit 0) Error 100 -
' = 2 - (Bit 1) Error 101 -
' = 4 - (Bit 2) Error 102 -
' = 8 - (Bit 3) Error 103 -
' = 16 - (Bit 4) Error 104 -
' = 32 - (Bit 5) Error 105 -
' = 64 - (Bit 6) Error 106 -
' = 128 - (Bit 7) Error 107 -
' = 254 - (Bit 8) Error 108 -
' = 512 - (Bit 9) Error 109 -
' = 1024 - (Bit 10) Error 110 -
' = 2048 - (Bit 11) Error 111 -
' = 4096 - (Bit 12) Error 112 -
' = 8192 - (Bit 13) Error 113 -
' = 16384 - (Bit 14) Error 114 -
' = 32768 - (Bit 15) Error 115 -

CONSTANT "vr_error_code_2", 42 'Process error code
'CONSTANT "c_vr_error_code_2", 42
' = 0 - brak błędów
' = 1 - (Bit 0) Error 200 -
' = 2 - (Bit 1) Error 201 -
' = 4 - (Bit 2) Error 202 -
' = 8 - (Bit 3) Error 203 -
' = 16 - (Bit 4) Error 204 -
' = 32 - (Bit 5) Error 205 -
' = 64 - (Bit 6) Error 206 -
' = 128 - (Bit 7) Error 207 -
' = 254 - (Bit 8) Error 208 -
' = 512 - (Bit 9) Error 209 -
' = 1024 - (Bit 10) Error 210 -
' = 2048 - (Bit 11) Error 211 -
' = 4096 - (Bit 12) Error 212 -
' = 8192 - (Bit 13) Error 213 -
' = 16384 - (Bit 14) Error 214 -
' = 32768 - (Bit 15) Error 215 -

CONSTANT "vr_error_code_3", 43 'Process error code
'CONSTANT "c_vr_error_code_3", 43
CONSTANT "vr_error_code_4", 44 'Process error code
CONSTANT "c_vr_error_code_4", 44

CONSTANT "vr_error_code_list_last", 49 'List of 4 last process error code - last saved register
CONSTANT "c_error_code_list_bank_start", 50 'List of 4 last process error code - start of data bank
CONSTANT "c_error_code_list_bank_stop", 69 'List of 4 last process error code - stop of data bank
'
'to address (inclusive) 69 reserve for error code

CONSTANT "vr_simulation_mode", 97
'CONSTANT "c_vr_simulation_mode", 97
' bit 0 -> no EtherCAT mode
CONSTANT "cb_vr_simulation_mode", 0

CONSTANT "vr_debug_channel", 98
VR(vr_debug_channel) = 5

CONSTANT "vr_debug_level", 99
' 0 - off
' 1 - general info
' 2 - functions info
' 4 - cyclic info
VR(vr_debug_level) = 0

CONSTANT "vr_master_state", 100 ' machine state
VR(vr_master_state) = 0
CONSTANT "c_state_disabled", 1
CONSTANT "c_state_active", 2
CONSTANT "c_state_manual", 4
CONSTANT "c_state_homing", 8
CONSTANT "c_state_automatic", 16
CONSTANT "c_state_jog", 32
CONSTANT "c_state_error", 32768

CONSTANT "vr_enable", 101
VR(vr_enable) = 0
CONSTANT "vr_enable_cb_restart_ex" , 0
CONSTANT "vr_enable_cb_master_error" , 1
CONSTANT "vr_enable_cb_alarm" , 2
CONSTANT "vr_enable_cb_enable_from_safety" , 3
CONSTANT "vr_enable_cb_enable_from_hmi" , 4
CONSTANT "vr_enable_cb_start_from_hmi" , 5
CONSTANT "vr_enable_cb_force_do" , 6
CONSTANT "vr_enable_cb_force_do_flag" , 7
CONSTANT "vr_enable_cb_one_cycle_flag" , 8
CONSTANT "vr_enable_cb_terminate_flag" , 9

CONSTANT "vr_process_enabled", 102 'process currently active
VR(vr_process_enabled) = 0

CONSTANT "vr_process_run", 103 'selected process to run
VR(vr_process_run) = 0
CONSTANT "c_process_run_nothing", 0
CONSTANT "c_process_run_manual_mode", 4
CONSTANT "c_process_run_homing", 8
CONSTANT "c_process_run_auto_mode", 16
CONSTANT "c_process_run_jog_mode", 32

CONSTANT "vr_first_axis_number", 104
VR(vr_first_axis_number) = 1

CONSTANT "vr_last_axis_number", 105
VR(vr_last_axis_number) = 1

CONSTANT "vr_hmi_ctrl", 110 'hmi control bits
CONSTANT "cb_hmi_ctrl_save_homepos_ax_z" , 0 'hmi control bits
CONSTANT "cb_hmi_ctrl_save_homepos_ax_a" , 1 'hmi control bits
CONSTANT "cb_hmi_ctrl_save_homepos_ax_b" , 2 'hmi control bits
CONSTANT "cb_hmi_ctrl_delete_program_row", 3
CONSTANT "cb_hmi_ctrl_insert_program_row", 4
CONSTANT "cb_hmi_ctrl_jog_plus", 5
CONSTANT "cb_hmi_ctrl_jog_minus", 6
CONSTANT "vr_hmi_ctrl_cb_auto" , 9 'hmi control bits
CONSTANT "vr_hmi_ctrl_cb_reczny" , 10 'hmi control bits
CONSTANT "vr_hmi_ctrl_cb_baza" , 11 'hmi control bits
CONSTANT "vr_hmi_ctrl_cb_jog" , 12 'hmi control bits
CONSTANT "vr_hmi_ctrl_cb_clr_error" , 14 'hmi control bits
CONSTANT "vr_hmi_ctrl_cb_clr_warning" , 15 'hmi control bits

CONSTANT "vr_hmi_lock", 111 'hmi lock bits
CONSTANT "cb_hmi_lock_jog_buttons", 7
CONSTANT "cb_hmi_lock_start", 8 'hmi control bits
CONSTANT "cb_hmi_lock_auto", 9 'hmi control bits
CONSTANT "cb_hmi_lock_reczny", 10 'hmi control bits
CONSTANT "cb_hmi_lock_baza", 11 'hmi control bits
CONSTANT "cb_hmi_lock_jog", 12 'hmi control bits
CONSTANT "cb_hmi_lock_load_recipe", 13 'hmi control bits
CONSTANT "cb_hmi_lock_clr_error", 14 'hmi control bits
CONSTANT "cb_hmi_lock_clr_warning", 15 'hmi control bits

CONSTANT "vr_ecat_temp" , 200 'Temporary VR for ethercat operation
CONSTANT "vr_homepos_ax_z", 201
CONSTANT "vr_homepos_ax_a", 202
CONSTANT "vr_homepos_ax_b", 203
CONSTANT "vr_selected_program_row_id", 204

CONSTANT "vr_di_mapping_0" , 210 'Mapping controller inputs for HMI
CONSTANT "vr_di_mapping_1" , 211 'Mapping controller inputs for HMI
CONSTANT "vr_do_mapping_0" , 212 'Mapping controller outputs for HMI
CONSTANT "vr_do_force_mask_0" , 213 'Mapping controller outputs for HMI
VR(vr_do_force_mask_0) = 0

CONSTANT "vr_ai_mapping_0" , 214 'Mapping controller outputs for HMI
CONSTANT "vr_ai_mapping_1" , 215 'Mapping controller outputs for HMI
CONSTANT "vr_ai_mapping_2" , 216 'Mapping controller outputs for HMI
CONSTANT "vr_ai_mapping_3" , 217 'Mapping controller outputs for HMI
CONSTANT "vr_ai_mapping_4" , 218 'Mapping controller outputs for HMI
CONSTANT "vr_ai_mapping_5" , 219 'Mapping controller outputs for HMI
CONSTANT "vr_ai_mapping_6" , 220 'Mapping controller outputs for HMI
CONSTANT "vr_ai_mapping_7" , 221
CONSTANT "vr_time_passed_hh", 222
CONSTANT "vr_time_passed_mm", 223
CONSTANT "vr_time_passed_ss", 224
CONSTANT "vr_production_demand", 225
CONSTANT "vr_production_counter", 226
CONSTANT "vr_mfo", 227
CONSTANT "vr_hmi_open_window" , 228 'changing HMI windows via PLC
CONSTANT "vr_hmi_actual_window" , 229 'changing HMI windows via PLC4
CONSTANT "vr_prog_name_0", 230
CONSTANT "vr_prog_name_1", 231
CONSTANT "vr_prog_name_2", 232
CONSTANT "vr_prog_name_3", 233
CONSTANT "vr_prog_name_4", 234
CONSTANT "vr_prog_name_5", 235
CONSTANT "vr_prog_name_6", 236
CONSTANT "vr_prog_name_7", 237
CONSTANT "vr_prog_name_8", 238
CONSTANT "vr_prog_name_9", 239
CONSTANT "vr_prog_name_10", 240
CONSTANT "vr_prog_name_11", 241
CONSTANT "vr_prog_name_12", 242
CONSTANT "vr_prog_name_13", 243
CONSTANT "vr_prog_name_14", 244
CONSTANT "vr_prog_name_15", 245
CONSTANT "vr_prog_name_16", 246
CONSTANT "vr_prog_name_17", 247
CONSTANT "vr_homing_mode_step" , 248 'Actual homing mode step
CONSTANT "vr_jog_mode_step" , 249 'Actual jog mode step
CONSTANT "vr_auto_mode_step" , 250 'Actual auto mode step
CONSTANT "vr_manual_mode_step" , 251 'Actual manual mode step
CONSTANT "vr_efficiency_per_min", 252
CONSTANT "vr_cycle_time_ms", 253
CONSTANT "vr_time_to_end_hh", 254
CONSTANT "vr_time_to_end_mm", 255
CONSTANT "vr_jog_type", 256
CONSTANT "vr_required_ecat_devices", 258
CONSTANT "vr_detected_ecat_devices", 259
CONSTANT "vr_actual_current_ax_example", 260

CONSTANT "vr_speed_override", 298
CONSTANT "vr_inpos_speed", 299
CONSTANT "vr_inpos_dist", 300
CONSTANT "vr_not_used", 301
CONSTANT "vr_position_ax_example", 302
CONSTANT "vr_position_ax_y", 303
CONSTANT "vr_position_ax_z", 304
CONSTANT "vr_position_ax_a", 305
CONSTANT "vr_position_ax_b", 306
CONSTANT "vr_mpg_speed_select_manual", 307
CONSTANT "vr_miss_touch_demand", 308
CONSTANT "vr_miss_touch_counter", 309
CONSTANT "vr_odwijak_signal_config", 310
CONSTANT "c_odwijak_signal_config_no", 0
CONSTANT "c_odwijak_signal_config_nc", 1

CONSTANT "vr_actual_pos_ax_example" , 311
CONSTANT "vr_modbus_handle", 312
CONSTANT "vr_weight", 313

CONSTANT "vr_actual_error_ax_example" , 317


CONSTANT "vr_speed_max_ax_example", 323

CONSTANT "vr_acc_dec_max_ax_example", 328

CONSTANT "vr_jerk_max_ax_example", 333

CONSTANT "vr_fe_limit_ax_example", 338

CONSTANT "vr_p_gain_ax_example", 343

CONSTANT "vr_i_gain_ax_example", 348

CONSTANT "vr_d_gain_ax_example", 353

CONSTANT "vr_units_ax_example", 358

CONSTANT "vr_pn102_ax_example", 363

CONSTANT "vr_pn103_ax_example", 368

CONSTANT "vr_pn106_ax_example", 373

CONSTANT "vr_distance_ax_example", 378
CONSTANT "vr_distance_ax_y", 379
CONSTANT "vr_distance_ax_z", 380
CONSTANT "vr_distance_ax_a", 381
CONSTANT "vr_distance_ax_b", 382



CONSTANT "vr_time_pulse" , 899 ' VR for time puls 500ms
CONSTANT "vr_timer_0" , 900 ' VR for period cyclic update
CONSTANT "c_timer_0", 900
CONSTANT "vr_timer_1" , 901 ' VR for time puls 500ms
CONSTANT "c_timer_1", 901
CONSTANT "vr_timer_2" , 902 ' VR for time puls 500ms
CONSTANT "c_timer_2", 902



'~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~RUN INITIALIZATION
IF PROC_STATUS PROC(20) = 0 THEN
    RUN "_01_MAIN", 20
ENDIF
STOP


