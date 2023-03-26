#! /bin/bash

MainFolder="$(pwd)"
CurrentFolderName=$(echo "${MainFolder##*/}") 
SystemName=$(cat /etc/hostname)


Front_Enc=$(MegaCli64 encinfo a0 | egrep 'ID|Slot|Position' | grep -B 2 "Position                      : 1" | grep -B 1 "Number of Slots               : 24" | grep ID | awk '{print$4}')
Rear_Enc=$(MegaCli64 encinfo a0 | egrep 'ID|Slot|Position' | grep -B 2 "Position                      : 1" | grep -B 1 "Number of Slots               : 12" | grep ID | awk '{print$4}')

cd $MainFolder/
echo -e "$SystemName\t$Serial_Number\t$Firmware_Version\t$Vendor_0xff_1\t$Vendor_0xff_2\t$Vendor_0xff_3\t$SMART_overall_health_self_assessment_test_result\t$Error_logs\t$raw_value_id1\t$raw_value_id5\tPower_On_Hours_id9\t$value_id12\t$raw_value_id171\t$when_failed_id172\t$updated_id173\t$updated_id174\tRuntime_Bad_Block_id183\t$type_id184\Reported_Uncorrect_187type_id187\t$updated_id187\t$when_failed_id187\t$raw_value_id187\tCommand_Timeout_id188\t$flag_id188\t$value_id188\t$worst_id188\t$thresh_id188\t$type_id188\t$updated_id188\t$when_failed_id188\t$raw_value_id188\tTemperature_Celsius_id194\t$flag_id194\t$value_id194\t$worst_id194\t$thresh_id194\t$type_id194\t$updated_id194\t$when_failed_id194\t$raw_value_id194\tHardware_ECC_Recovered_id195\t$flag_id195\t$value_id195\t$worst_id195\t$thresh_id195\t$type_id195\t$updated_id195\t$when_failed_id195\t$raw_value_id195\tReallocated_Event_Count_id196\t$flag_id196\t$value_id196\t$worst_id196\t$thresh_id196\t$type_id196\t$updated_id196\t$when_failed_id196\t$raw_value_id196\tCurrent_Pending_Sector_id197\t$flag_id197\t$value_id197\t$worst_id197\t$thresh_id197\t$type_id197\t$updated_id197\t$when_failed_id197\t$raw_value_id197\tOffline_Uncorrectable_id198\t$flag_id198\t$value_id198\t$worst_id198\t$thresh_id198\t$type_id198\t$updated_id198\t$when_failed_id198\t$raw_value_id198\tUDMA_CRC_Error_Count_id199\t$flag_id199\t$value_id199\t$worst_id199\t$thresh_id199\t$type_id199\t$updated_id199\t$when_failed_id199\t$raw_value_id199\tUnknown_SSD_Attribute_id202\t$flag_id202\t$value_id202\t$worst_id202\t$thresh_id202\t$type_id202\t$updated_id202\t$when_failed_id202\t$raw_value_id202\tUnknown_SSD_Attribute_id206\t$flag_id206\t$value_id206\t$worst_id206\t$thresh_id206\t$type_id206\t$updated_id206\t$when_failed_id206\t$raw_value_id206\t\t\t\t\t\t\t\tUnknown_Attribute_id246\t$flag_id246\t$value_id246\t$worst_id246\t$thresh_id246\t$type_id246\t$updated_id246\t$when_failed_id246\t$raw_value_id246\tUnknown_Attribute_id247\t$flag_id247\t$value_id247\t$worst_id247\t$thresh_id247\t$type_id247\t$updated_id247\t$when_failed_id247\t$raw_value_id247\tUnknown_Attribute_id248\t$flag_id248\t$value_id248\t$worst_id248\t$thresh_id248\t$type_id248\t$updated_id248\t$when_failed_id248\t$raw_value_id248\tUnused_Rsvd_Blk_Cnt_Tot_id180\t$flag_id180\t$value_id180\t$worst_id180\t$thresh_id180\t$type_id180\t$updated_id180\t$when_failed_id180\t$raw_value_id180\tUnknown_Attribute_210\t$flag_id210\t$value_id210\t$worst_id210\t$thresh_id210\t$type_id210\t$updated_id210\t$when_failed_id210\t$raw_value_id210"  >> Disks_Table.txt

for Disk in $(ls -d */ | cut -d '/' -f1 );
do
	SMART_File="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep "SMART-After-4")"
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

	#Wear_Leveling_Count_id177
	flag_id177="$(cat SMART.tmp | grep -m1 "177.*Wear_Leveling_Count"  | awk '{print$3}' )"
	value_id177="$(cat SMART.tmp | grep -m1 "177.*Wear_Leveling_Count"  | awk '{print$4}' )"
	worst_id177="$(cat SMART.tmp | grep -m1 "177.*Wear_Leveling_Count"  | awk '{print$5}' )"
	thresh_id177="$(cat SMART.tmp | grep -m1 "177.*Wear_Leveling_Count"  | awk '{print$6}' )"
	type_id177="$(cat SMART.tmp | grep -m1 "177.*Wear_Leveling_Count"  | awk '{print$7}' )"
	updated_id177="$(cat SMART.tmp | grep -m1 "177.*Wear_Leveling_Count"  | awk '{print$8}' )"
	when_failed_id177="$(cat SMART.tmp | grep -m1 "177.*Wear_Leveling_Count"  | awk '{print$9}' )"
	raw_value_id177="$(cat SMART.tmp | grep -m1 "177.*Wear_Leveling_Count"  | awk '{print$10}' )"

	#Used_Rsvd_Blk_Cnt_Tot_id179
	flag_id179="$(cat SMART.tmp | grep -m2 "179.*Used_Rsvd_Blk_Cnt_Tot"  | awk '{print$3}' )"
	value_id179="$(cat SMART.tmp | grep -m2 "179.*Used_Rsvd_Blk_Cnt_Tot"  | awk '{print$4}' )"
	worst_id179="$(cat SMART.tmp | grep -m2 "179.*Used_Rsvd_Blk_Cnt_Tot"  | awk '{print$5}' )"
	thresh_id179="$(cat SMART.tmp | grep -m2 "179.*Used_Rsvd_Blk_Cnt_Tot"  | awk '{print$6}' )"
	type_id179="$(cat SMART.tmp | grep -m2 "179.*Used_Rsvd_Blk_Cnt_Tot"  | awk '{print$7}' )"
	updated_id179="$(cat SMART.tmp | grep -m2 "179.*Used_Rsvd_Blk_Cnt_Tot"  | awk '{print$8}' )"
	when_failed_id179="$(cat SMART.tmp | grep -m2 "179.*Used_Rsvd_Blk_Cnt_Tot"  | awk '{print$9}' )"
	raw_value_id179="$(cat SMART.tmp | grep -m2 "179.*Used_Rsvd_Blk_Cnt_Tot"  | awk '{print$10}' )"

	#Unused_Rsvd_Blk_Cnt_Tot_id180
	flag_id180="$(cat SMART.tmp | grep -m3 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$3}' )"
	value_id180="$(cat SMART.tmp | grep -m3 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$4}' )"
	worst_id180="$(cat SMART.tmp | grep -m3 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$5}' )"
	thresh_id180="$(cat SMART.tmp | grep -m3 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$6}' )"
	type_id180="$(cat SMART.tmp | grep -m3 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$7}' )"
	updated_id180="$(cat SMART.tmp | grep -m3 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$8}' )"
	when_failed_id180="$(cat SMART.tmp | grep -m3 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$9}' )"
	raw_value_id180="$(cat SMART.tmp | grep -m3 "180.*Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$10}' )"

	#Program_Fail_Cnt_Total_id181
	flag_id181="$(cat SMART.tmp | grep -m4 "181.*Program_Fail_Cnt_Total"  | awk '{print$3}' )"
	value_id181="$(cat SMART.tmp | grep -m4 "181.*Program_Fail_Cnt_Total"  | awk '{print$4}' )"
	worst_id181="$(cat SMART.tmp | grep -m4 "181.*Program_Fail_Cnt_Total"  | awk '{print$5}' )"
	thresh_id181="$(cat SMART.tmp | grep -m4 "181.*Program_Fail_Cnt_Total"  | awk '{print$6}' )"
	type_id181="$(cat SMART.tmp | grep -m4 "181.*Program_Fail_Cnt_Total"  | awk '{print$7}' )"
	updated_id181="$(cat SMART.tmp | grep -m4 "181.*Program_Fail_Cnt_Total"  | awk '{print$8}' )"
	when_failed_id181="$(cat SMART.tmp | grep -m4 "181.*Program_Fail_Cnt_Total"  | awk '{print$9}' )"
	raw_value_id181="$(cat SMART.tmp | grep -m4 "181.*Program_Fail_Cnt_Total"  | awk '{print$10}' )"

	#Erase_Fail_Count_Total_id182
	flag_id182="$(cat SMART.tmp | grep -m5 "182.*Erase_Fail_Count_Total"  | awk '{print$3}' )"
	value_id182="$(cat SMART.tmp | grep -m5 "182.*Erase_Fail_Count_Total"  | awk '{print$4}' )"
	worst_id182="$(cat SMART.tmp | grep -m5 "182.*Erase_Fail_Count_Total"  | awk '{print$5}' )"
	thresh_id182="$(cat SMART.tmp | grep -m5 "182.*Erase_Fail_Count_Total"  | awk '{print$6}' )"
	type_id182="$(cat SMART.tmp | grep -m5 "182.*Erase_Fail_Count_Total"  | awk '{print$7}' )"
	updated_id182="$(cat SMART.tmp | grep -m5 "182.*Erase_Fail_Count_Total"  | awk '{print$8}' )"
	when_failed_id182="$(cat SMART.tmp | grep -m5 "182.*Erase_Fail_Count_Total"  | awk '{print$9}' )"
	raw_value_id182="$(cat SMART.tmp | grep -m5 "182.*Erase_Fail_Count_Total"  | awk '{print$10}' )"

	#Runtime_Bad_Block_id183
	flag_id183="$(cat SMART.tmp | grep -m1 "183.*Runtime_Bad_Block"  | awk '{print$3}' )"
	value_id183="$(cat SMART.tmp | grep -m1 "183.*Runtime_Bad_Block"  | awk '{print$4}' )"
	worst_id183="$(cat SMART.tmp | grep -m1 "183.*Runtime_Bad_Block"  | awk '{print$5}' )"
	thresh_id183="$(cat SMART.tmp | grep -m1 "183.*Runtime_Bad_Block"  | awk '{print$6}' )"
	type_id183="$(cat SMART.tmp | grep -m1 "183.*Runtime_Bad_Block"  | awk '{print$7}' )"
	updated_id183="$(cat SMART.tmp | grep -m1 "183.*Runtime_Bad_Block"  | awk '{print$8}' )"
	when_failed_id183="$(cat SMART.tmp | grep -m1 "183.*Runtime_Bad_Block"  | awk '{print$9}' )"
	raw_value_id183="$(cat SMART.tmp | grep -m1 "183.*Runtime_Bad_Block"  | awk '{print$10}' )"

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

	#Airflow_Temperature_Cel_id190
	flag_id190="$(cat SMART.tmp | grep -m1 "190.*Airflow_Temperature_Cel"  | awk '{print$3}' )"
	value_id190="$(cat SMART.tmp | grep -m1 "190.*Airflow_Temperature_Cel"  | awk '{print$4}' )"
	worst_id190="$(cat SMART.tmp | grep -m1 "190.*Airflow_Temperature_Cel"  | awk '{print$5}' )"
	thresh_id190="$(cat SMART.tmp | grep -m1 "190.*Airflow_Temperature_Cel"  | awk '{print$6}' )"
	type_id190="$(cat SMART.tmp | grep -m1 "190.*Airflow_Temperature_Cel"  | awk '{print$7}' )"
	updated_id190="$(cat SMART.tmp | grep -m1 "190.*Airflow_Temperature_Cel"  | awk '{print$8}' )"
	when_failed_id190="$(cat SMART.tmp | grep -m1 "190.*Airflow_Temperature_Cel"  | awk '{print$9}' )"
	raw_value_id190="$(cat SMART.tmp | grep -m1 "190.*Airflow_Temperature_Cel"  | awk '{print$10}' )"

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
	flag_id202="$(cat SMART.tmp | grep -m1 "202.*Unknown_SSD_Attribute"  | awk '{print$3}' )"
	value_id202="$(cat SMART.tmp | grep -m1 "202.*Unknown_SSD_Attribute"  | awk '{print$4}' )"
	worst_id202="$(cat SMART.tmp | grep -m1 "202.*Unknown_SSD_Attribute"  | awk '{print$5}' )"
	thresh_id202="$(cat SMART.tmp | grep -m1 "202.*Unknown_SSD_Attribute"  | awk '{print$6}' )"
	type_id202="$(cat SMART.tmp | grep -m1 "202.*Unknown_SSD_Attribute"  | awk '{print$7}' )"
	updated_id202="$(cat SMART.tmp | grep -m1 "202.*Unknown_SSD_Attribute"  | awk '{print$8}' )"
	when_failed_id202="$(cat SMART.tmp | grep -m1 "202.*Unknown_SSD_Attribute"  | awk '{print$9}' )"
	raw_value_id202="$(cat SMART.tmp | grep -m1 "202.*Unknown_SSD_Attribute"  | awk '{print$10}' )"

	#Unknown_SSD_Attribute_id235
	flag_id235="$(cat SMART.tmp | grep -m1 "235.*Unknown_Attribute"  | awk '{print$3}' )"
	value_id235="$(cat SMART.tmp | grep -m1 "235.*Unknown_Attribute"  | awk '{print$4}' )"
	worst_id235="$(cat SMART.tmp | grep -m1 "235.*Unknown_Attribute"  | awk '{print$5}' )"
	thresh_id235="$(cat SMART.tmp | grep -m1 "235.*Unknown_Attribute"  | awk '{print$6}' )"
	type_id235="$(cat SMART.tmp | grep -m1 "235.*Unknown_Attribute"  | awk '{print$7}' )"
	updated_id235="$(cat SMART.tmp | grep -m1 "235.*Unknown_Attribute"  | awk '{print$8}' )"
	when_failed_id235="$(cat SMART.tmp | grep -m1 "235.*Unknown_Attribute"  | awk '{print$9}' )"
	raw_value_id235="$(cat SMART.tmp | grep -m1 "235.*Unknown_Attribute"  | awk '{print$10}' )"
	
	#Total_LBAs_Written_id241
	flag_id241="$(cat SMART.tmp | grep -m1 "241.*Total_LBAs_Written"  | awk '{print$3}' )"
	value_id241="$(cat SMART.tmp | grep -m1 "241.*Total_LBAs_Written"  | awk '{print$4}' )"
	worst_id241="$(cat SMART.tmp | grep -m1 "241.*Total_LBAs_Written"  | awk '{print$5}' )"
	thresh_id241="$(cat SMART.tmp | grep -m1 "241.*Total_LBAs_Written"  | awk '{print$6}' )"
	type_id241="$(cat SMART.tmp | grep -m1 "241.*Total_LBAs_Written"  | awk '{print$7}' )"
	updated_id241="$(cat SMART.tmp | grep -m1 "241.*Total_LBAs_Written"  | awk '{print$8}' )"
	when_failed_id241="$(cat SMART.tmp | grep -m1 "241.*Total_LBAs_Written"  | awk '{print$9}' )"
	raw_value_id241="$(cat SMART.tmp | grep -m1 "241.*Total_LBAs_Written"  | awk '{print$10}' )"
	
	#Total_LBAs_Read_id242
	flag_id242="$(cat SMART.tmp | grep -m1 "242.*Total_LBAs_Read"  | awk '{print$3}' )"
	value_id242="$(cat SMART.tmp | grep -m1 "242.*Total_LBAs_Read"  | awk '{print$4}' )"
	worst_id242="$(cat SMART.tmp | grep -m1 "242.*Total_LBAs_Read"  | awk '{print$5}' )"
	thresh_id242="$(cat SMART.tmp | grep -m1 "242.*Total_LBAs_Read"  | awk '{print$6}' )"
	type_id242="$(cat SMART.tmp | grep -m1 "242.*Total_LBAs_Read"  | awk '{print$7}' )"
	updated_id242="$(cat SMART.tmp | grep -m1 "242.*Total_LBAs_Read"  | awk '{print$8}' )"
	when_failed_id242="$(cat SMART.tmp | grep -m1 "242.*Total_LBAs_Read"  | awk '{print$9}' )"
	raw_value_id242="$(cat SMART.tmp | grep -m1 "242.*Total_LBAs_Read"  | awk '{print$10}' )"

	#Unknown_Attribute_id243
	flag_id243="$(cat SMART.tmp | grep -m8 "243.*Unknown_Attribute"  | awk '{print$3}' )"
	value_id243="$(cat SMART.tmp | grep -m8 "243.*Unknown_Attribute"  | awk '{print$4}' )"
	worst_id243="$(cat SMART.tmp | grep -m8 "243.*Unknown_Attribute"  | awk '{print$5}' )"
	thresh_id243="$(cat SMART.tmp | grep -m8 "243.*Unknown_Attribute"  | awk '{print$6}' )"
	type_id243="$(cat SMART.tmp | grep -m8 "243.*Unknown_Attribute"  | awk '{print$7}' )"
	updated_id243="$(cat SMART.tmp | grep -m8 "243.*Unknown_Attribute"  | awk '{print$8}' )"
	when_failed_id243="$(cat SMART.tmp | grep -m8 "243.*Unknown_Attribute"  | awk '{print$9}' )"
	raw_value_id243="$(cat SMART.tmp | grep -m8 "243.*Unknown_Attribute"  | awk '{print$10}' )"

	#Unknown_Attribute_id244
	flag_id244="$(cat SMART.tmp | grep -m8 "244.*Unknown_Attribute"  | awk '{print$3}' )"
	value_id244="$(cat SMART.tmp | grep -m8 "244.*Unknown_Attribute"  | awk '{print$4}' )"
	worst_id244="$(cat SMART.tmp | grep -m8 "244.*Unknown_Attribute"  | awk '{print$5}' )"
	thresh_id244="$(cat SMART.tmp | grep -m8 "244.*Unknown_Attribute"  | awk '{print$6}' )"
	type_id244="$(cat SMART.tmp | grep -m8 "244.*Unknown_Attribute"  | awk '{print$7}' )"
	updated_id244="$(cat SMART.tmp | grep -m8 "244.*Unknown_Attribute"  | awk '{print$8}' )"
	when_failed_id244="$(cat SMART.tmp | grep -m8 "244.*Unknown_Attribute"  | awk '{print$9}' )"
	raw_value_id244="$(cat SMART.tmp | grep -m8 "244.*Unknown_Attribute"  | awk '{print$10}' )"

	#Unknown_Attribute_id245
	flag_id245="$(cat SMART.tmp | grep -m8 "245.*Unknown_Attribute"  | awk '{print$3}' )"
	value_id245="$(cat SMART.tmp | grep -m8 "245.*Unknown_Attribute"  | awk '{print$4}' )"
	worst_id245="$(cat SMART.tmp | grep -m8 "245.*Unknown_Attribute"  | awk '{print$5}' )"
	thresh_id245="$(cat SMART.tmp | grep -m8 "245.*Unknown_Attribute"  | awk '{print$6}' )"
	type_id245="$(cat SMART.tmp | grep -m8 "245.*Unknown_Attribute"  | awk '{print$7}' )"
	updated_id245="$(cat SMART.tmp | grep -m8 "245.*Unknown_Attribute"  | awk '{print$8}' )"
	when_failed_id245="$(cat SMART.tmp | grep -m8 "245.*Unknown_Attribute"  | awk '{print$9}' )"
	raw_value_id245="$(cat SMART.tmp | grep -m8 "245.*Unknown_Attribute"  | awk '{print$10}' )"


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
	flag_id247="$(cat SMART.tmp | grep -m7 "247.*Unknown_Attribute"  | awk '{print$3}' )"
	value_id247="$(cat SMART.tmp | grep -m7 "247.*Unknown_Attribute"  | awk '{print$4}' )"
	worst_id247="$(cat SMART.tmp | grep -m7 "247.*Unknown_Attribute"  | awk '{print$5}' )"
	thresh_id247="$(cat SMART.tmp | grep -m7 "247.*Unknown_Attribute"  | awk '{print$6}' )"
	type_id247="$(cat SMART.tmp | grep -m7 "247.*Unknown_Attribute"  | awk '{print$7}' )"
	updated_id247="$(cat SMART.tmp | grep -m7 "247.*Unknown_Attribute"  | awk '{print$8}' )"
	when_failed_id247="$(cat SMART.tmp | grep -m7 "247.*Unknown_Attribute"  | awk '{print$9}' )"
	raw_value_id247="$(cat SMART.tmp | grep -m7 "247.*Unknown_Attribute"  | awk '{print$10}' )"

	#Unknown_Attribute_id251
	flag_id251="$(cat SMART.tmp | grep -m7 "251.*Unknown_Attribute"  | awk '{print$3}' )"
	value_id251="$(cat SMART.tmp | grep -m7 "251.*Unknown_Attribute"  | awk '{print$4}' )"
	worst_id251="$(cat SMART.tmp | grep -m7 "251.*Unknown_Attribute"  | awk '{print$5}' )"
	thresh_id251="$(cat SMART.tmp | grep -m7 "251.*Unknown_Attribute"  | awk '{print$6}' )"
	type_id251="$(cat SMART.tmp | grep -m7 "251.*Unknown_Attribute"  | awk '{print$7}' )"
	updated_id251="$(cat SMART.tmp | grep -m7 "251.*Unknown_Attribute"  | awk '{print$8}' )"
	when_failed_id251="$(cat SMART.tmp | grep -m7 "251.*Unknown_Attribute"  | awk '{print$9}' )"
	raw_value_id251="$(cat SMART.tmp | grep -m7 "251.*Unknown_Attribute"  | awk '{print$10}' )"


	Vendor_0xff_1="$(cat SMART.tmp | grep -m1 "Vendor (0xff)"  | awk '{print$10}' )"
	Vendor_0xff_2="$(cat SMART.tmp | grep -m1 "Vendor (0xff)"  | awk '{print$10}' )"
	Vendor_0xff_3="$(cat SMART.tmp | grep -m1 "Vendor (0xff)"  | awk '{print$10}' )"

	SMART_overall_health_self_assessment_test_result="$(cat SMART.tmp | grep -m1 "SMART overall-health self-assessment test result:"  | awk '{print$6}' )"

	Error_logs="$(cat SMART.tmp | grep -A 1 "SMART Error" | tail -1)"
	rm -f SMART.tmp
	echo -e "$SystemName\t$Serial_Number\t$Firmware_Version\t$Vendor_0xff_1\t$Vendor_0xff_2\t$Vendor_0xff_3\t$SMART_overall_health_self_assessment_test_result\t$Error_logs\tReallocated_Sector_Ct_id5\t$flag_id5\t$value_id5\t$worst_id5\t$thresh_id5\t$type_id5\t$updated_id5\t$when_failed_id5\t$raw_value_id5\t\tPower_On_Hours_id9\t$flag_id9\t$value_id9\t$worst_id9\t$thresh_id9\t$type_id9\t$updated_id9\t$when_failed_id9\t$raw_value_id9\tPower_Cycle_Count_id12\t$flag_id12\t$value_id12\t$worst_id12\t$thresh_id12\t$type_id12\t$updated_id12\t$when_failed_id12\t$raw_value_id12\tUnknown_Attribute_id177\t$flag_id177\t$value_id177\t$worst_id177\t$thresh_id177\t$type_id177\t$updated_id177\t$when_failed_id177\t$raw_value_id177\tUnknown_Attribute_id179\t$flag_id179\t$value_id179\t$worst_id179\t$thresh_id179\t$type_id179\t$updated_id179\t$when_failed_id179\t$raw_value_id179\tUnknown_Attribute_id180\t$flag_id180\t$value_id180\t$worst_id180\t$thresh_id180\t$type_id180\t$updated_id180\t$when_failed_id180\t$raw_value_id180\tUnknown_Attribute_id181\t$flag_id181\t$value_id181\t$worst_id181\t$thresh_id181\t$type_id181\t$updated_id181\t$when_failed_id181\t$raw_value_id181\tUnknown_Attribute_id182\t$flag_id182\t$value_id182\t$worst_id182\t$thresh_id182\t$type_id182\t$updated_id182\t$when_failed_id182\t$raw_value_id182\tRuntime_Bad_Block_id183\t$flag_id183\t$value_id183\t$worst_id183\t$thresh_id183\t$type_id183\t$updated_id183\t$when_failed_id183\t$raw_value_id183\tEnd_to_End_Error_id184\t$flag_id184\t$value_id184\t$worst_id184\t$thresh_id184\t$type_id184\t$updated_id184\t$when_failed_id184\t$raw_value_id184\tReported_Uncorrect_187\t$flag_id187\t$value_id187\t$worst_id187\t$thresh_id187\t$type_id187\t$updated_id187\t$when_failed_id187\t$raw_value_id187\tCommand_Timeout_id190\t$flag_id190\t$value_id190\t$worst_id190\t$thresh_id190\t$type_id190\t$updated_id190\t$when_failed_id190\t$raw_value_id190\tTemperature_Celsius_id194\t$flag_id194\t$value_id194\t$worst_id194\t$thresh_id194\t$type_id194\t$updated_id194\t$when_failed_id194\t$raw_value_id194\tHardware_ECC_Recovered_id195\t$flag_id195\t$value_id195\t$worst_id195\t$thresh_id195\t$type_id195\t$updated_id195\t$when_failed_id195\t$raw_value_id195\tReallocated_Event_Count_id197\t$flag_id197\t$value_id197\t$worst_id197\t$thresh_id197\t$type_id197\t$updated_id197\t$when_failed_id197\t$raw_value_id197\tCurrent_Pending_Sector_id199\t$flag_id199\t$value_id199\t$worst_id199\t$thresh_id199\t$type_id199\t$updated_id199\t$when_failed_id199\t$raw_value_id199\tOffline_Uncorrectable_id202\t$flag_id202\t$value_id202\t$worst_id202\t$thresh_id202\t$type_id202\t$updated_id202\t$when_failed_id202\t$raw_value_id202\tUDMA_CRC_Error_Count_id235\t$flag_id235\t$value_id235\t$worst_id235\t$thresh_id235\t$type_id235\t$updated_id235\t$when_failed_id235\t$raw_value_id235\tTotal_LBAs_Written_id241\t$flag_id241\t$value_id241\t$worst_id241\t$thresh_id241\t$type_id241\t$updated_id241\t$when_failed_id241\t\t$raw_value_id241\tTotal_LBAs_Read_id242\t$flag_id242\t$value_id242\t$worst_id242\t$thresh_id242\t$type_id242\t$updated_id242\t$when_failed_id242\t$raw_value_id242\t\tUnknown_SSD_Attribute_id243\t$flag_id243\t$value_id243\t$worst_id243\t$thresh_id243\t$type_id243\t$updated_id243\t$when_failed_id243\t$raw_value_id243\t\tUnknown_SSD_Attribute_id244\t$flag_id244\t$value_id244\t$worst_id244\t$thresh_id244\t$type_id244\t$updated_id244\t$when_failed_id244\t$raw_value_id244\t\tUnknown_SSD_Attribute_id245\t$flag_id245\t$value_id245\t$worst_id245\t$thresh_id245\t$type_id245\t$updated_id245\t$when_failed_id245\t$raw_value_id245\t\tUnknown_Attribute_id246\t$flag_id246\t$value_id246\t$worst_id246\t$thresh_id246\t$type_id246\t$updated_id246\t$when_failed_id246\t$raw_value_id246\tUnknown_Attribute_id247\t$flag_id247\t$value_id247\t$worst_id247\t$thresh_id247\t$type_id247\t$updated_id247\t$when_failed_id247\t$raw_value_id247\tUnknown_Attribute_id251\t$flag_id251\t$value_id251\t$worst_id251\t$thresh_id251\t$type_id251\t$updated_id251\t$when_failed_id251\t$raw_value_id251" >> Disks_Table.txt
done
