#! /bin/bash

MainFolder="$(pwd)"
CurrentFolderName=$(echo "${MainFolder##*/}")
SystemName=$(cat /etc/hostname)


Front_Enc=$(MegaCli64 encinfo a0 | egrep 'ID|Slot|Position' | grep -B 2 "Position                      : 1" | grep -B 1 "Number of Slots               : 24" | grep ID | awk '{print$4}')
Rear_Enc=$(MegaCli64 encinfo a0 | egrep 'ID|Slot|Position' | grep -B 2 "Position                      : 1" | grep -B 1 "Number of Slots               : 12" | grep ID | awk '{print$4}')

# echo -e   >> Disks_Table.txt
cd $MainFolder/
echo -e "$SystemName\t$Serial_Number\t$Firmware_Version\t$Vendor_0xff_1\t$Vendor_0xff_2\t$Vendor_0xff_3\t$SMART_overall_health_self_assessment_test_result\t$Error_logs\t$raw_value_id1\t$raw_value_id5\tPower_On_Hours_id9\t$value_id12\t$raw_value_id171\t$when_failed_id172\t$updated_id173\t$updated_id174\tRuntime_Bad_Block_id183\t$type_id184\Reported_Uncorrect_187type_id187\t$updated_id187\t$when_failed_id187\t$raw_value_id187\tCommand_Timeout_id188\t$flag_id188\t$value_id188\t$worst_id188\t$thresh_id188\t$type_id188\t$updated_id188\t$when_failed_id188\t$raw_value_id188\tTemperature_Celsius_id194\t$flag_id194\t$value_id194\t$worst_id194\t$thresh_id194\t$type_id194\t$updated_id194\t$when_failed_id194\t$raw_value_id194\tHardware_ECC_Recovered_id195\t$flag_id195\t$value_id195\t$worst_id195\t$thresh_id195\t$type_id195\t$updated_id195\t$when_failed_id195\t$raw_value_id195\tReallocated_Event_Count_id196\t$flag_id196\t$value_id196\t$worst_id196\t$thresh_id196\t$type_id196\t$updated_id196\t$when_failed_id196\t$raw_value_id196\tCurrent_Pending_Sector_id197\t$flag_id197\t$value_id197\t$worst_id197\t$thresh_id197\t$type_id197\t$updated_id197\t$when_failed_id197\t$raw_value_id197\tOffline_Uncorrectable_id198\t$flag_id198\t$value_id198\t$worst_id198\t$thresh_id198\t$type_id198\t$updated_id198\t$when_failed_id198\t$raw_value_id198\tUDMA_CRC_Error_Count_id199\t$flag_id199\t$value_id199\t$worst_id199\t$thresh_id199\t$type_id199\t$updated_id199\t$when_failed_id199\t$raw_value_id199\tUnknown_SSD_Attribute_id202\t$flag_id202\t$value_id202\t$worst_id202\t$thresh_id202\t$type_id202\t$updated_id202\t$when_failed_id202\t$raw_value_id202\tUnknown_SSD_Attribute_id206\t$flag_id206\t$value_id206\t$worst_id206\t$thresh_id206\t$type_id206\t$updated_id206\t$when_failed_id206\t$raw_value_id206\t\t\t\t\t\t\t\tUnknown_Attribute_id246\t$flag_id246\t$value_id246\t$worst_id246\t$thresh_id246\t$type_id246\t$updated_id246\t$when_failed_id246\t$raw_value_id246\tUnknown_Attribute_id247\t$flag_id247\t$value_id247\t$worst_id247\t$thresh_id247\t$type_id247\t$updated_id247\t$when_failed_id247\t$raw_value_id247\tUnknown_Attribute_id248\t$flag_id248\t$value_id248\t$worst_id248\t$thresh_id248\t$type_id248\t$updated_id248\t$when_failed_id248\t$raw_value_id248\tUnused_Rsvd_Blk_Cnt_Tot_id180\t$flag_id180\t$value_id180\t$worst_id180\t$thresh_id180\t$type_id180\t$updated_id180\t$when_failed_id180\t$raw_value_id180\tUnknown_Attribute_210\t$flag_id210\t$value_id210\t$worst_id210\t$thresh_id210\t$type_id210\t$updated_id210\t$when_failed_id210\t$raw_value_id210"  >> Disks_Table.txt

for Disk in $(ls -d */ | cut -d '/' -f1 );
do
	SMART_File="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep SMART-After-4)"
	cp $SMART_File SMART.tmp
	Serial_Number="$(cat SMART.tmp | grep "Serial Number" | awk '{print$3}' )"
	Serial_Number_CLEAN=$Serial_Number  #"$(echo ${Serial_Number:0:8} )"
	SMART_Health="$(cat SMART.tmp | grep "SMART Health Status" | awk '{print$4}' )"
	Elements_GDL="$(cat SMART.tmp | grep "Elements in grown defect list" | awk '{print$6}' )"
	Non_MEC="$(cat SMART.tmp | grep "Non-medium error count" | awk '{print$4}' )"
	Temperature="$(cat SMART.tmp | grep "Current Drive Temperature" | awk '{print$4}' )"
	PowerUp="$(cat SMART.tmp | grep "number of hours powered up" | awk '{print$7}' )"
	Long_ST="$(cat SMART.tmp | grep "Background long" | grep "# 1" | awk '{print$5}' )"
	Firmware_Version="$(cat SMART.tmp | grep "Firmware Version"  | awk '{print$3}' )"

	#Raw_Read_Error_Rate_id1
	flag_id1="$(cat SMART.tmp | grep "1.*Raw_Read_Error_Rate"  | awk '{print$3}' )"
	value_id1="$(cat SMART.tmp | grep "1.*Raw_Read_Error_Rate"  | awk '{print$4}' )"
	worst_id1="$(cat SMART.tmp | grep "1.*Raw_Read_Error_Rate"  | awk '{print$5}' )"
	thresh_id1="$(cat SMART.tmp | grep "1.*Raw_Read_Error_Rate"  | awk '{print$6}' )"
	type_id1="$(cat SMART.tmp | grep "1.*Raw_Read_Error_Rate"  | awk '{print$7}' )"
	updated_id1="$(cat SMART.tmp | grep "1.*Raw_Read_Error_Rate"  | awk '{print$8}' )"
	when_failed_id1="$(cat SMART.tmp | grep "1.*Raw_Read_Error_Rate"  | awk '{print$9}' )"
	raw_value_id1="$(cat SMART.tmp | grep "1.*Raw_Read_Error_Rate"  | awk '{print$10}' )"

	#Reallocated_Sector_Ct_id5
	flag_id5="$(cat SMART.tmp | grep "5.*Reallocated_Sector_Ct"  | awk '{print$3}' )"
	value_id5="$(cat SMART.tmp | grep "5.*Reallocated_Sector_Ct"  | awk '{print$4}' )"
	worst_id5="$(cat SMART.tmp | grep "5.*Reallocated_Sector_Ct"  | awk '{print$5}' )"
	thresh_id5="$(cat SMART.tmp | grep "5.*Reallocated_Sector_Ct"  | awk '{print$6}' )"
	type_id5="$(cat SMART.tmp | grep "5.*Reallocated_Sector_Ct"  | awk '{print$7}' )"
	updated_id5="$(cat SMART.tmp | grep "5.*Reallocated_Sector_Ct"  | awk '{print$8}' )"
	when_failed_id5="$(cat SMART.tmp | grep "5.*Reallocated_Sector_Ct"  | awk '{print$9}' )"
	raw_value_id5="$(cat SMART.tmp | grep "5.*Reallocated_Sector_Ct"  | awk '{print$10}' )"

	#Power_On_Hours_id9
	flag_id9="$(cat SMART.tmp | grep "9.*Power_On_Hours"  | awk '{print$3}' )"
	value_id9="$(cat SMART.tmp | grep "9.*Power_On_Hours"  | awk '{print$4}' )"
	worst_id9="$(cat SMART.tmp | grep "9.*Power_On_Hours"  | awk '{print$5}' )"
	thresh_id9="$(cat SMART.tmp | grep "9.*Power_On_Hours"  | awk '{print$6}' )"
	type_id9="$(cat SMART.tmp | grep "9.*Power_On_Hours"  | awk '{print$7}' )"
	updated_id9="$(cat SMART.tmp | grep "9.*Power_On_Hours"  | awk '{print$8}' )"
	when_failed_id9="$(cat SMART.tmp | grep "9.*Power_On_Hours"  | awk '{print$9}' )"
	raw_value_id9="$(cat SMART.tmp | grep "9.*Power_On_Hours"  | awk '{print$10}' )"

	#Power_Cycle_Count_id12
	flag_id12="$(cat SMART.tmp | grep "12.*Power_Cycle_Count"  | awk '{print$3}' )"
	value_id12="$(cat SMART.tmp | grep "12.*Power_Cycle_Count"  | awk '{print$4}' )"
	worst_id12="$(cat SMART.tmp | grep "12.*Power_Cycle_Count"  | awk '{print$5}' )"
	thresh_id12="$(cat SMART.tmp | grep "12.*Power_Cycle_Count"  | awk '{print$6}' )"
	type_id12="$(cat SMART.tmp | grep "12.*Power_Cycle_Count"  | awk '{print$7}' )"
	updated_id12="$(cat SMART.tmp | grep "12.*Power_Cycle_Count"  | awk '{print$8}' )"
	when_failed_id12="$(cat SMART.tmp | grep "12.*Power_Cycle_Count"  | awk '{print$9}' )"
	raw_value_id12="$(cat SMART.tmp | grep "12.*Power_Cycle_Count"  | awk '{print$10}' )"

	#Unknown_Attribute_id170
	flag_id170="$(cat SMART.tmp | grep -m1 "170.*Reserved_Block_Pct"  | awk '{print$3}' )"
	value_id170="$(cat SMART.tmp | grep -m1 "170.*Reserved_Block_Pct"  | awk '{print$4}' )"
	worst_id170="$(cat SMART.tmp | grep -m1 "170.*Reserved_Block_Pct"  | awk '{print$5}' )"
	thresh_id170="$(cat SMART.tmp | grep -m1 "170.*Reserved_Block_Pct"  | awk '{print$6}' )"
	type_id170="$(cat SMART.tmp | grep -m1 "170.*Reserved_Block_Pct"  | awk '{print$7}' )"
	updated_id170="$(cat SMART.tmp | grep -m1 "170.*Reserved_Block_Pct"  | awk '{print$8}' )"
	when_failed_id170="$(cat SMART.tmp | grep -m1 "170.*Reserved_Block_Pct"  | awk '{print$9}' )"
	raw_value_id170="$(cat SMART.tmp | grep -m1 "170.*Reserved_Block_Pct"  | awk '{print$10}' )"

	#Unknown_Attribute_id171
	flag_id171="$(cat SMART.tmp | grep -m2 "171.*Program_Fail_Count"  | awk '{print$3}' )"
	value_id171="$(cat SMART.tmp | grep -m2 "171.*Program_Fail_Count"  | awk '{print$4}' )"
	worst_id171="$(cat SMART.tmp | grep -m2 "171.*Program_Fail_Count"  | awk '{print$5}' )"
	thresh_id171="$(cat SMART.tmp | grep -m2 "171.*Program_Fail_Count"  | awk '{print$6}' )"
	type_id171="$(cat SMART.tmp | grep -m2 "171.*Program_Fail_Count"  | awk '{print$7}' )"
	updated_id171="$(cat SMART.tmp | grep -m2 "171.*Program_Fail_Count"  | awk '{print$8}' )"
	when_failed_id171="$(cat SMART.tmp | grep -m2 "171.*Program_Fail_Count"  | awk '{print$9}' )"
	raw_value_id171="$(cat SMART.tmp | grep -m2 "171.*Program_Fail_Count"  | awk '{print$10}' )"

	#Unknown_Attribute_id172
	flag_id172="$(cat SMART.tmp | grep -m3 "172.*Erase_Fail_Count"  | awk '{print$3}' )"
	value_id172="$(cat SMART.tmp | grep -m3 "172.*Erase_Fail_Count"  | awk '{print$4}' )"
	worst_id172="$(cat SMART.tmp | grep -m3 "172.*Erase_Fail_Count"  | awk '{print$5}' )"
	thresh_id172="$(cat SMART.tmp | grep -m3 "172.*Erase_Fail_Count"  | awk '{print$6}' )"
	type_id172="$(cat SMART.tmp | grep -m3 "172.*Erase_Fail_Count"  | awk '{print$7}' )"
	updated_id172="$(cat SMART.tmp | grep -m3 "172.*Erase_Fail_Count"  | awk '{print$8}' )"
	when_failed_id172="$(cat SMART.tmp | grep -m3 "172.*Erase_Fail_Count"  | awk '{print$9}' )"
	raw_value_id172="$(cat SMART.tmp | grep -m3 "172.*Erase_Fail_Count"  | awk '{print$10}' )"

	#Unknown_Attribute_id173
	flag_id173="$(cat SMART.tmp | grep -m4 "173.*Avg_Block-Erase_Count"  | awk '{print$3}' )"
	value_id173="$(cat SMART.tmp | grep -m4 "173.*Avg_Block-Erase_Count"  | awk '{print$4}' )"
	worst_id173="$(cat SMART.tmp | grep -m4 "173.*Avg_Block-Erase_Count"  | awk '{print$5}' )"
	thresh_id173="$(cat SMART.tmp | grep -m4 "173.*Avg_Block-Erase_Count"  | awk '{print$6}' )"
	type_id173="$(cat SMART.tmp | grep -m4 "173.*Avg_Block-Erase_Count"  | awk '{print$7}' )"
	updated_id173="$(cat SMART.tmp | grep -m4 "173.*Avg_Block-Erase_Count"  | awk '{print$8}' )"
	when_failed_id173="$(cat SMART.tmp | grep -m4 "173.*Avg_Block-Erase_Count"  | awk '{print$9}' )"
	raw_value_id173="$(cat SMART.tmp | grep -m4 "173.*Avg_Block-Erase_Count"  | awk '{print$10}' )"

	#Unknown_Attribute_id174
	flag_id174="$(cat SMART.tmp | grep -m5 "174.*Unexpect_Power_Loss_Ct"  | awk '{print$3}' )"
	value_id174="$(cat SMART.tmp | grep -m5 "174.*Unexpect_Power_Loss_Ct"  | awk '{print$4}' )"
	worst_id174="$(cat SMART.tmp | grep -m5 "174.*Unexpect_Power_Loss_Ct"  | awk '{print$5}' )"
	thresh_id174="$(cat SMART.tmp | grep -m5 "174.*Unexpect_Power_Loss_Ct"  | awk '{print$6}' )"
	type_id174="$(cat SMART.tmp | grep -m5 "174.*Unexpect_Power_Loss_Ct"  | awk '{print$7}' )"
	updated_id174="$(cat SMART.tmp | grep -m5 "174.*Unexpect_Power_Loss_Ct"  | awk '{print$8}' )"
	when_failed_id174="$(cat SMART.tmp | grep -m5 "174.*Unexpect_Power_Loss_Ct"  | awk '{print$9}' )"
	raw_value_id174="$(cat SMART.tmp | grep -m5 "174.*Unexpect_Power_Loss_Ct"  | awk '{print$10}' )"

	#SATA_Int_Downshift_Ct_id183
	flag_id183="$(cat SMART.tmp | grep -m1 "183.*SATA_Int_Downshift_Ct"  | awk '{print$3}' )"
	value_id183="$(cat SMART.tmp | grep -m1 "183.*SATA_Int_Downshift_Ct"  | awk '{print$4}' )"
	worst_id183="$(cat SMART.tmp | grep -m1 "183.*SATA_Int_Downshift_Ct"  | awk '{print$5}' )"
	thresh_id183="$(cat SMART.tmp | grep -m1 "183.*SATA_Int_Downshift_Ct"  | awk '{print$6}' )"
	type_id183="$(cat SMART.tmp | grep -m1 "183.*SATA_Int_Downshift_Ct"  | awk '{print$7}' )"
	updated_id183="$(cat SMART.tmp | grep -m1 "183.*SATA_Int_Downshift_Ct"  | awk '{print$8}' )"
	when_failed_id183="$(cat SMART.tmp | grep -m1 "183.*SATA_Int_Downshift_Ct"  | awk '{print$9}' )"
	raw_value_id183="$(cat SMART.tmp | grep -m1 "183.*SATA_Int_Downshift_Ct"  | awk '{print$10}' )"

	#End_to_End_Error_id184
	flag_id184="$(cat SMART.tmp | grep -m1 "184.*End-to-End_Error"  | awk '{print$3}' )"
	value_id184="$(cat SMART.tmp | grep -m1 "184.*End-to-End_Error"  | awk '{print$4}' )"
	worst_id184="$(cat SMART.tmp | grep -m1 "184.*End-to-End_Error"  | awk '{print$5}' )"
	thresh_id184="$(cat SMART.tmp | grep -m1 "184.*End-to-End_Error"  | awk '{print$6}' )"
	type_id184="$(cat SMART.tmp | grep -m1 "184.*End-to-End_Error"  | awk '{print$7}' )"
	updated_id184="$(cat SMART.tmp | grep -m1 "184.*End-to-End_Error"  | awk '{print$8}' )"
	when_failed_id184="$(cat SMART.tmp | grep -m1 "184.*End-to-End_Error"  | awk '{print$9}' )"
	raw_value_id184="$(cat SMART.tmp | grep -m1 "184.*End-to-End_Error"  | awk '{print$10}' )"

	#Reported_Uncorrect_187
	Reported_Uncorrect_187="$(cat SMART.tmp | grep -m1 "187.*Reported_Uncorrect" | awk '{print$9}' )"
	flag_id187="$(cat SMART.tmp | grep -m1 "187.*Reported_Uncorrect"  | awk '{print$3}' )"
	value_id187="$(cat SMART.tmp | grep -m1 "187.*Reported_Uncorrect"  | awk '{print$4}' )"
	worst_id187="$(cat SMART.tmp | grep -m1 "187.*Reported_Uncorrect"  | awk '{print$5}' )"
	thresh_id187="$(cat SMART.tmp | grep -m1 "187.*Reported_Uncorrect"  | awk '{print$6}' )"
	type_id187="$(cat SMART.tmp | grep -m1 "187.*Reported_Uncorrect"  | awk '{print$7}' )"
	updated_id187="$(cat SMART.tmp | grep -m1 "187.*Reported_Uncorrect"  | awk '{print$8}' )"
	when_failed_id187="$(cat SMART.tmp | grep -m1 "187.*Reported_Uncorrect"  | awk '{print$9}' )"
	raw_value_id187="$(cat SMART.tmp | grep -m1 "187.*Reported_Uncorrect"  | awk '{print$10}' )"

	#Command_Timeout_id188
	flag_id188="$(cat SMART.tmp | grep -m1 "188.*Command_Timeout"  | awk '{print$3}' )"
	value_id188="$(cat SMART.tmp | grep -m1 "188.*Command_Timeout"  | awk '{print$4}' )"
	worst_id188="$(cat SMART.tmp | grep -m1 "188.*Command_Timeout"  | awk '{print$5}' )"
	thresh_id188="$(cat SMART.tmp | grep -m1 "188.*Command_Timeout"  | awk '{print$6}' )"
	type_id188="$(cat SMART.tmp | grep -m1 "188.*Command_Timeout"  | awk '{print$7}' )"
	updated_id188="$(cat SMART.tmp | grep -m1 "188.*Command_Timeout"  | awk '{print$8}' )"
	when_failed_id188="$(cat SMART.tmp | grep -m1 "188.*Command_Timeout"  | awk '{print$9}' )"
	raw_value_id188="$(cat SMART.tmp | grep -m1 "188.*Command_Timeout"  | awk '{print$10}' )"

	#Temperature_Celsius_id194
	flag_id194="$(cat SMART.tmp | grep -m1 "194.*Temperature_Celsius"  | awk '{print$3}' )"
	value_id194="$(cat SMART.tmp | grep -m1 "194.*Temperature_Celsius"  | awk '{print$4}' )"
	worst_id194="$(cat SMART.tmp | grep -m1 "194.*Temperature_Celsius"  | awk '{print$5}' )"
	thresh_id194="$(cat SMART.tmp | grep -m1 "194.*Temperature_Celsius"  | awk '{print$6}' )"
	type_id194="$(cat SMART.tmp | grep -m1 "194.*Temperature_Celsius"  | awk '{print$7}' )"
	updated_id194="$(cat SMART.tmp | grep -m1 "194.*Temperature_Celsius"  | awk '{print$8}' )"
	when_failed_id194="$(cat SMART.tmp | grep -m1 "194.*Temperature_Celsius"  | awk '{print$9}' )"
	raw_value_id194="$(cat SMART.tmp | grep -m1 "194.*Temperature_Celsius"  | awk '{print$10}' )"

	#Hardware_ECC_Recovered_id195
	flag_id195="$(cat SMART.tmp | grep -m1 "195.*Hardware_ECC_Recovered"  | awk '{print$3}' )"
	value_id195="$(cat SMART.tmp | grep -m1 "195.*Hardware_ECC_Recovered"  | awk '{print$4}' )"
	worst_id195="$(cat SMART.tmp | grep -m1 "195.*Hardware_ECC_Recovered"  | awk '{print$5}' )"
	thresh_id195="$(cat SMART.tmp | grep -m1 "195.*Hardware_ECC_Recovered"  | awk '{print$6}' )"
	type_id195="$(cat SMART.tmp | grep -m1 "195.*Hardware_ECC_Recovered"  | awk '{print$7}' )"
	updated_id195="$(cat SMART.tmp | grep -m1 "195.*Hardware_ECC_Recovered"  | awk '{print$8}' )"
	when_failed_id195="$(cat SMART.tmp | grep -m1 "195.*Hardware_ECC_Recovered"  | awk '{print$9}' )"
	raw_value_id195="$(cat SMART.tmp | grep -m1 "195.*Hardware_ECC_Recovered"  | awk '{print$10}' )"

	#Reallocated_Event_Count_id196
	flag_id196="$(cat SMART.tmp | grep -m1 "196.*Reallocated_Event_Count"  | awk '{print$3}' )"
	value_id196="$(cat SMART.tmp | grep -m1 "196.*Reallocated_Event_Count"  | awk '{print$4}' )"
	worst_id196="$(cat SMART.tmp | grep -m1 "196.*Reallocated_Event_Count"  | awk '{print$5}' )"
	thresh_id196="$(cat SMART.tmp | grep -m1 "196.*Reallocated_Event_Count"  | awk '{print$6}' )"
	type_id196="$(cat SMART.tmp | grep -m1 "196.*Reallocated_Event_Count"  | awk '{print$7}' )"
	updated_id196="$(cat SMART.tmp | grep -m1 "196.*Reallocated_Event_Count"  | awk '{print$8}' )"
	when_failed_id196="$(cat SMART.tmp | grep -m1 "196.*Reallocated_Event_Count"  | awk '{print$9}' )"
	raw_value_id196="$(cat SMART.tmp | grep -m1 "196.*Reallocated_Event_Count"  | awk '{print$10}' )"

	#Current_Pending_Sector_id197
	Current_Pending_Sector_id197="$(cat SMART.tmp | grep -m1 "197.*Current_Pending_Sector"  | awk '{print$9}' )"
	flag_id197="$(cat SMART.tmp | grep -m1 "197.*Current_Pending_Sector"  | awk '{print$3}' )"
	value_id197="$(cat SMART.tmp | grep -m1 "197.*Current_Pending_Sector"  | awk '{print$4}' )"
	worst_id197="$(cat SMART.tmp | grep -m1 "197.*Current_Pending_Sector"  | awk '{print$5}' )"
	thresh_id197="$(cat SMART.tmp | grep -m1 "197.*Current_Pending_Sector"  | awk '{print$6}' )"
	type_id197="$(cat SMART.tmp | grep -m1 "197.*Current_Pending_Sector"  | awk '{print$7}' )"
	updated_id197="$(cat SMART.tmp | grep -m1 "197.*Current_Pending_Sector"  | awk '{print$8}' )"
	when_failed_id197="$(cat SMART.tmp | grep -m1 "197.*Current_Pending_Sector"  | awk '{print$9}' )"
	raw_value_id197="$(cat SMART.tmp | grep -m1 "197.*Current_Pending_Sector"  | awk '{print$10}' )"

	#Offline_Uncorrectable_id198
	flag_id198="$(cat SMART.tmp | grep -m1 "198.*Offline_Uncorrectable"  | awk '{print$3}' )"
	value_id198="$(cat SMART.tmp | grep -m1 "198.*Offline_Uncorrectable"  | awk '{print$4}' )"
	worst_id198="$(cat SMART.tmp | grep -m1 "198.*Offline_Uncorrectable"  | awk '{print$5}' )"
	thresh_id198="$(cat SMART.tmp | grep -m1 "198.*Offline_Uncorrectable"  | awk '{print$6}' )"
	type_id198="$(cat SMART.tmp | grep -m1 "198.*Offline_Uncorrectable"  | awk '{print$7}' )"
	updated_id198="$(cat SMART.tmp | grep -m1 "198.*Offline_Uncorrectable"  | awk '{print$8}' )"
	when_failed_id198="$(cat SMART.tmp | grep -m1 "198.*Offline_Uncorrectable"  | awk '{print$9}' )"
	raw_value_id198="$(cat SMART.tmp | grep -m1 "198.*Offline_Uncorrectable"  | awk '{print$10}' )"

	#UDMA_CRC_Error_Count_id199
	flag_id199="$(cat SMART.tmp | grep -m1 "199.*UDMA_CRC_Error_Count"  | awk '{print$3}' )"
	value_id199="$(cat SMART.tmp | grep -m1 "199.*UDMA_CRC_Error_Count"  | awk '{print$4}' )"
	worst_id199="$(cat SMART.tmp | grep -m1 "199.*UDMA_CRC_Error_Count"  | awk '{print$5}' )"
	thresh_id199="$(cat SMART.tmp | grep -m1 "199.*UDMA_CRC_Error_Count"  | awk '{print$6}' )"
	type_id199="$(cat SMART.tmp | grep -m1 "199.*UDMA_CRC_Error_Count"  | awk '{print$7}' )"
	updated_id199="$(cat SMART.tmp | grep -m1 "199.*UDMA_CRC_Error_Count"  | awk '{print$8}' )"
	when_failed_id199="$(cat SMART.tmp | grep -m1 "199.*UDMA_CRC_Error_Count"  | awk '{print$9}' )"
	raw_value_id199="$(cat SMART.tmp | grep -m1 "199.*UDMA_CRC_Error_Count"  | awk '{print$10}' )"

	#Unknown_SSD_Attribute_id202
	flag_id202="$(cat SMART.tmp | grep -m1 "202.*Percent_Lifetime_Remain"  | awk '{print$3}' )"
	value_id202="$(cat SMART.tmp | grep -m1 "202.*Percent_Lifetime_Remain"  | awk '{print$4}' )"
	worst_id202="$(cat SMART.tmp | grep -m1 "202.*Percent_Lifetime_Remain"  | awk '{print$5}' )"
	thresh_id202="$(cat SMART.tmp | grep -m1 "202.*Percent_Lifetime_Remain"  | awk '{print$6}' )"
	type_id202="$(cat SMART.tmp | grep -m1 "202.*Percent_Lifetime_Remain"  | awk '{print$7}' )"
	updated_id202="$(cat SMART.tmp | grep -m1 "202.*Percent_Lifetime_Remain"  | awk '{print$8}' )"
	when_failed_id202="$(cat SMART.tmp | grep -m1 "202.*Percent_Lifetime_Remain"  | awk '{print$9}' )"
	raw_value_id202="$(cat SMART.tmp | grep -m1 "202.*Percent_Lifetime_Remain"  | awk '{print$10}' )"

	#Unknown_SSD_Attribute_id206
	flag_id206="$(cat SMART.tmp | grep -m2 "206.*Write_Error_Rate"  | awk '{print$3}' )"
	value_id206="$(cat SMART.tmp | grep -m2 "206.*Write_Error_Rate"  | awk '{print$4}' )"
	worst_id206="$(cat SMART.tmp | grep -m2 "206.*Write_Error_Rate"  | awk '{print$5}' )"
	thresh_id206="$(cat SMART.tmp | grep -m2 "206.*Write_Error_Rate"  | awk '{print$6}' )"
	type_id206="$(cat SMART.tmp | grep -m2 "206.*Write_Error_Rate"  | awk '{print$7}' )"
	updated_id206="$(cat SMART.tmp | grep -m2 "206.*Write_Error_Rate"  | awk '{print$8}' )"
	when_failed_id206="$(cat SMART.tmp | grep -m2 "206.*Write_Error_Rate"  | awk '{print$9}' )"
	raw_value_id206="$(cat SMART.tmp | grep -m2 "206.*Write_Error_Rate"  | awk '{print$10}' )"

	#Unknown_Attribute_id246
	flag_id246="$(cat SMART.tmp | grep -m6 "246.*Unknown_Attribute"  | awk '{print$3}' )"
	value_id246="$(cat SMART.tmp | grep -m6 "246.*Unknown_Attribute"  | awk '{print$4}' )"
	worst_id246="$(cat SMART.tmp | grep -m6 "246.*Unknown_Attribute"  | awk '{print$5}' )"
	thresh_id246="$(cat SMART.tmp | grep -m6 "246.*Unknown_Attribute"  | awk '{print$6}' )"
	type_id246="$(cat SMART.tmp | grep -m6 "246.*Unknown_Attribute"  | awk '{print$7}' )"
	updated_id246="$(cat SMART.tmp | grep -m6 "246.*Unknown_Attribute"  | awk '{print$8}' )"
	when_failed_id246="$(cat SMART.tmp | grep -m6 "246.*Unknown_Attribute"  | awk '{print$9}' )"
	raw_value_id246="$(cat SMART.tmp | grep -m6 "246.*Unknown_Attribute"  | awk '{print$10}' )"

	#Unknown_Attribute_id247
	flag_id247="$(cat SMART.tmp | grep -m7 "247.*Host_Program_Page_Count"  | awk '{print$3}' )"
	value_id247="$(cat SMART.tmp | grep -m7 "247.*Host_Program_Page_Count"  | awk '{print$4}' )"
	worst_id247="$(cat SMART.tmp | grep -m7 "247.*Host_Program_Page_Count"  | awk '{print$5}' )"
	thresh_id247="$(cat SMART.tmp | grep -m7 "247.*Host_Program_Page_Count"  | awk '{print$6}' )"
	type_id247="$(cat SMART.tmp | grep -m7 "247.*Host_Program_Page_Count"  | awk '{print$7}' )"
	updated_id247="$(cat SMART.tmp | grep -m7 "247.*Host_Program_Page_Count"  | awk '{print$8}' )"
	when_failed_id247="$(cat SMART.tmp | grep -m7 "247.*Host_Program_Page_Count"  | awk '{print$9}' )"
	raw_value_id247="$(cat SMART.tmp | grep -m7 "247.*Host_Program_Page_Count"  | awk '{print$10}' )"

	#Unknown_Attribute_id248
	flag_id248="$(cat SMART.tmp | grep -m8 "248.*Bckgnd_Program_Page_Cnt"  | awk '{print$3}' )"
	value_id248="$(cat SMART.tmp | grep -m8 "248.*Bckgnd_Program_Page_Cnt"  | awk '{print$4}' )"
	worst_id248="$(cat SMART.tmp | grep -m8 "248.*Bckgnd_Program_Page_Cnt"  | awk '{print$5}' )"
	thresh_id248="$(cat SMART.tmp | grep -m8 "248.*Bckgnd_Program_Page_Cnt"  | awk '{print$6}' )"
	type_id248="$(cat SMART.tmp | grep -m8 "248.*Bckgnd_Program_Page_Cnt"  | awk '{print$7}' )"
	updated_id248="$(cat SMART.tmp | grep -m8 "248.*Bckgnd_Program_Page_Cnt"  | awk '{print$8}' )"
	when_failed_id248="$(cat SMART.tmp | grep -m8 "248.*Bckgnd_Program_Page_Cnt"  | awk '{print$9}' )"
	raw_value_id248="$(cat SMART.tmp | grep -m8 "248.*Bckgnd_Program_Page_Cnt"  | awk '{print$10}' )"

	#Unused_Rsvd_Blk_Cnt_Tot_id180
	flag_id180="$(cat SMART.tmp | grep -m1 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$3}' )"
	value_id180="$(cat SMART.tmp | grep -m1 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$4}' )"
	worst_id180="$(cat SMART.tmp | grep -m1 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$5}' )"
	thresh_id180="$(cat SMART.tmp | grep -m1 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$6}' )"
	type_id180="$(cat SMART.tmp | grep -m1 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$7}' )"
	updated_id180="$(cat SMART.tmp | grep -m1 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$8}' )"
	when_failed_id180="$(cat SMART.tmp | grep -m1 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$9}' )"
	raw_value_id180="$(cat SMART.tmp | grep -m1 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$10}' )"

	#Unknown_Attribute_210
	flag_id210="$(cat SMART.tmp | grep -m1 "210.*RAIN_Success_Recovered"  | awk '{print$3}' )"
	value_id210="$(cat SMART.tmp | grep -m1 "210.*RAIN_Success_Recovered"  | awk '{print$4}' )"
	worst_id210="$(cat SMART.tmp | grep -m1 "210.*RAIN_Success_Recovered"  | awk '{print$5}' )"
	thresh_id210="$(cat SMART.tmp | grep -m1 "210.*RAIN_Success_Recovered"  | awk '{print$6}' )"
	type_id210="$(cat SMART.tmp | grep -m1 "210.*RAIN_Success_Recovered"  | awk '{print$7}' )"
	updated_id210="$(cat SMART.tmp | grep -m1 "210.*RAIN_Success_Recovered"  | awk '{print$8}' )"
	when_failed_id210="$(cat SMART.tmp | grep -m1 "210.*RAIN_Success_Recovered"  | awk '{print$9}' )"
	raw_value_id210="$(cat SMART.tmp | grep -m1 "210.*RAIN_Success_Recovered"  | awk '{print$10}' )"



	Vendor_0xff_1="$(cat SMART.tmp | grep -m1 "Vendor (0xff)"  | awk '{print$10}' )"
	Vendor_0xff_2="$(cat SMART.tmp | grep -m1 "Vendor (0xff)"  | awk '{print$10}' )"
	Vendor_0xff_3="$(cat SMART.tmp | grep -m1 "Vendor (0xff)"  | awk '{print$10}' )"

	SMART_overall_health_self_assessment_test_result="$(cat SMART.tmp | grep -m1 "SMART overall-health self-assessment test result:"  | awk '{print$6}' )"

	Error_logs="$(cat SMART.tmp | grep -A 1 "SMART Error" | tail -1)"
	rm -f SMART.tmp
	echo -e "$SystemName\t$Serial_Number\t$Firmware_Version\t$Vendor_0xff_1\t$Vendor_0xff_2\t$Vendor_0xff_3\t$SMART_overall_health_self_assessment_test_result\t$Error_logs\t$flag_id1\tRaw_Read_Error_Rate_id1\t$value_id1\t$worst_id1\t$thresh_id1\t$type_id1\t$updated_id1\t$when_failed_id1\t$raw_value_id1\tReallocated_Sector_Ct_id5\t$flag_id5\t$value_id5\t$worst_id5\t$thresh_id5\t$type_id5\t$updated_id5\t$when_failed_id5\t$raw_value_id5\t\tPower_On_Hours_id9\t$flag_id9\t$value_id9\t$worst_id9\t$thresh_id9\t$type_id9\t$updated_id9\t$when_failed_id9\t$raw_value_id9\tPower_Cycle_Count_id12\t$flag_id9\t$value_id12\t$worst_id12\t$thresh_id12\t$type_id12\t$updated_id12\t$when_failed_id12\t$raw_value_id12\tUnknown_Attribute_id170\t$flag_id170\t$value_id170\t$worst_id170\t$thresh_id170\t$type_id170\t$updated_id170\t$when_failed_id170\t$raw_value_id170\tUnknown_Attribute_id171\t$flag_id171\t$value_id171\t$worst_id171\t$thresh_id171\t$type_id171\t$updated_id171\t$when_failed_id171\t$raw_value_id171\tUnknown_Attribute_id172\t$flag_id172\t$value_id172\t$worst_id172\t$thresh_id172\t$type_id172\t$updated_id172\t$when_failed_id172\t$raw_value_id172\tUnknown_Attribute_id173\t$flag_id173\t$value_id173\t$worst_id173\t$thresh_id173\t$type_id173\t$updated_id173\t$when_failed_id173\t$raw_value_id173\tUnknown_Attribute_id174\t$flag_id174\t$value_id174\t$worst_id174\t$thresh_id174\t$type_id174\t$updated_id174\t$when_failed_id174\t$raw_value_id174\tRuntime_Bad_Block_id183\t$flag_id183\t$value_id183\t$worst_id183\t$thresh_id183\t$type_id183\t$updated_id183\t$when_failed_id183\t$raw_value_id183\tEnd_to_End_Error_id184\t$flag_id184\t$value_id184\t$worst_id184\t$thresh_id184\t$type_id184\t$updated_id184\t$when_failed_id184\t$raw_value_id184\tReported_Uncorrect_187\t$flag_id187\t$value_id187\t$worst_id187\t$thresh_id187\t$type_id187\t$updated_id187\t$when_failed_id187\t$raw_value_id187\tCommand_Timeout_id188\t$flag_id188\t$value_id188\t$worst_id188\t$thresh_id188\t$type_id188\t$updated_id188\t$when_failed_id188\t$raw_value_id188\tTemperature_Celsius_id194\t$flag_id194\t$value_id194\t$worst_id194\t$thresh_id194\t$type_id194\t$updated_id194\t$when_failed_id194\t$raw_value_id194\tHardware_ECC_Recovered_id195\t$flag_id195\t$value_id195\t$worst_id195\t$thresh_id195\t$type_id195\t$updated_id195\t$when_failed_id195\t$raw_value_id195\tReallocated_Event_Count_id196\t$flag_id196\t$value_id196\t$worst_id196\t$thresh_id196\t$type_id196\t$updated_id196\t$when_failed_id196\t$raw_value_id196\tCurrent_Pending_Sector_id197\t$flag_id197\t$value_id197\t$worst_id197\t$thresh_id197\t$type_id197\t$updated_id197\t$when_failed_id197\t$raw_value_id197\tOffline_Uncorrectable_id198\t$flag_id198\t$value_id198\t$worst_id198\t$thresh_id198\t$type_id198\t$updated_id198\t$when_failed_id198\t$raw_value_id198\tUDMA_CRC_Error_Count_id199\t$flag_id199\t$value_id199\t$worst_id199\t$thresh_id199\t$type_id199\t$updated_id199\t$when_failed_id199\t$raw_value_id199\tUnknown_SSD_Attribute_id202\t$flag_id202\t$value_id202\t$worst_id202\t$thresh_id202\t$type_id202\t$updated_id202\t$when_failed_id202\t$raw_value_id202\tUnknown_SSD_Attribute_id206\t$flag_id206\t$value_id206\t$worst_id206\t$thresh_id206\t$type_id206\t$updated_id206\t$when_failed_id206\t$raw_value_id206\t\t\t\t\t\t\t\tUnknown_Attribute_id246\t$flag_id246\t$value_id246\t$worst_id246\t$thresh_id246\t$type_id246\t$updated_id246\t$when_failed_id246\t$raw_value_id246\tUnknown_Attribute_id247\t$flag_id247\t$value_id247\t$worst_id247\t$thresh_id247\t$type_id247\t$updated_id247\t$when_failed_id247\t$raw_value_id247\tUnknown_Attribute_id248\t$flag_id248\t$value_id248\t$worst_id248\t$thresh_id248\t$type_id248\t$updated_id248\t$when_failed_id248\t$raw_value_id248\tUnused_Rsvd_Blk_Cnt_Tot_id180\t$flag_id180\t$value_id180\t$worst_id180\t$thresh_id180\t$type_id180\t$updated_id180\t$when_failed_id180\t$raw_value_id180\tUnknown_Attribute_210\t$flag_id210\t$value_id210\t$worst_id210\t$thresh_id210\t$type_id210\t$updated_id210\t$when_failed_id210\t$raw_value_id210" >> Disks_Table.txt
done
