#! /bin/bash

MainFolder="$(pwd)"
CurrentFolderName=$(echo "${MainFolder##*/}")
SystemName=$(cat /etc/hostname)

Front_Enc=$(MegaCli64 encinfo a0 | egrep 'ID|Slot|Position' | grep -B 2 "Position                      : 1" | grep -B 1 "Number of Slots               : 24" | grep ID | awk '{print$4}')
Rear_Enc=$(MegaCli64 encinfo a0 | egrep 'ID|Slot|Position' | grep -B 2 "Position                      : 1" | grep -B 1 "Number of Slots               : 12" | grep ID | awk '{print$4}')

cd $MainFolder/
echo -e "SystemName\tDate\tEnc Pos\t[EncID:SlotNo]\tMedia & PD Type\tSerial Number\tFirmware version\tDevice Id\tFirmware State\tMedia Error Count\tOther Error Count\tPredictive Failure Count\tSMART Health\tLong SelfTest\tElements Grown Defect List\tNon Medium Error Count\tPower Up Time\tCurrent Temperature\tBadblock Result 0x55\tBadblock Result 0x55 Errors\tBadblock Result 0xaa\tBadblock Result 0xaa Errors\tBadblock Result 0xff\tBadblock Result 0xff Errors\tBadblock Result 0x00\t$Badblock Result 0x00 Errors\tOverAll Status\tRaw_Read_Error_Rate\tReallocated_Sector_Ct\tPower_On_Hours\tPower_Cycle_Count\tUnknown_Attribute_id170\tUnknown_Attribute_id171\tUnknown_Attribute_id172\tUnknown_Attribute_id173\tUnknown_Attribute_id174\tRuntime_Bad_Block\tEnd-to-End_Error\tReported_Uncorrect\tCommand_Timeout\tTemperature_Celsius\tHardware_ECC_Recovered\tReallocated_Event_Count\tCurrent_Pending_Sector\tOffline_Uncorrectable\tUDMA_CRC_Error_Count\tUnknown_SSD_Attribute_id202\tUnknown_SSD_Attribute_id206\tUnknown_Attribute_id246\tUnknown_Attribute_id247\tUnknown_Attribute_id248\tUnused_Rsvd_Blk_Cnt_Tot\tUnknown_Attribute_210\tVendor_0xff_1\tVendor_0xff_2\tVendor_0xff_3\tsmart status\tError_logs"  >> Disks_Table.txt

for Disk in $(ls -d */ | cut -d '/' -f1 );
do

#	MegaCli64 PDinfo Physdrv[$EncID:$Slot_No] $Adapter > Disk.tmp
	SMART_File="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep After_PDClear-SMART-A)"
	PDInfo_File="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep After_PDClear-PDInfo)"
	Badblock_0x55="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep 0x55)"
	Badblock_0xaa="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep 0xaa)"
	Badblock_0x00="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep 0x00)"
	Badblock_0xff="$MainFolder/$Disk/$(ls $MainFolder/$Disk/ | grep 0xff)"
	
	cp $SMART_File SMART.tmp
	cp $PDInfo_File Disk.tmp


#PDInfo Check	
	EncID="$(cat Disk.tmp | grep ID | awk '{print$4}' )"
	Slot_No="$(cat Disk.tmp | grep Slot | awk '{print$3}' )"
		if [ $Slot_No -lt 10 ] ; then Slot_No="0$Slot_No" ; fi
	Device_Id="$(cat Disk.tmp | grep Id | awk '{print$3}' )"
	Media_Error_Count="$(cat Disk.tmp | grep "Media Error Count" | awk '{print$4}' )"
	Other_Error_Count="$(cat Disk.tmp | grep "Other Error Count" | awk '{print$4}')"
	Predictive_Failure_Count="$(cat Disk.tmp | grep "Predictive Failure Count" | awk '{print$4}' )"
	Firmware_State="$(cat Disk.tmp | grep "Firmware state" | awk '{print$3,$4,$5}' )"
	Inquiry_Data="$(cat Disk.tmp | grep "Inquiry" | awk '{print$3,$4,$5,$6}' )"
	Media_Type="$(cat Disk.tmp | grep "Media Type" | awk '{print$3,$4,$5}' )"
	Media_Type_Clean=""
	if [ "$Media_Type" == "Hard Disk Device" ] ; then Media_Type_Clean="HDD" ; else Media_Type_Clean="SSD" ; fi
	PD_Type="$(cat Disk.tmp | grep "PD Type" | awk '{print$3}' )"

	Enc_Pos=''
		if [ $EncID -eq $Front_Enc ] ; then Enc_Pos='Front' ; elif [ $EncID -eq $Rear_Enc ] ; then Enc_Pos='Rear' ; else Enc_Pos='Unknown' ; fi
	rm -f Disk.tmp
	
	Serial_Number="$(cat SMART.tmp | grep "Serial Number" | awk '{print$3}' )"
	Serial_Number_CLEAN=$Serial_Number  #"$(echo ${Serial_Number:0:8} )"
	SMART_Health="$(cat SMART.tmp | grep "SMART Health Status" | awk '{print$4}' )"
	Elements_GDL="$(cat SMART.tmp | grep "Elements in grown defect list" | awk '{print$6}' )"
	Non_MEC="$(cat SMART.tmp | grep "Non-medium error count" | awk '{print$4}' )"
	Temperature="$(cat SMART.tmp | grep "Current Drive Temperature" | awk '{print$4}' )"
	PowerUp="$(cat SMART.tmp | grep "number of hours powered up" | awk '{print$7}' )"
	Long_ST="$(cat SMART.tmp | grep "Background long" | grep "# 1" | awk '{print$5}' )"
	Firmware_Version="$(cat SMART.tmp | grep "Firmware Version"  | awk '{print$3}' )"
	Raw_Read_Error_Rate="$(cat SMART.tmp | grep "Raw_Read_Error_Rate"  | awk '{print$9}' )"
	Reallocated_Sector_Ct="$(cat SMART.tmp | grep "Reallocated_Sector_Ct"  | awk '{print$9}' )"
	Power_On_Hours="$(cat SMART.tmp | grep "Power_On_Hours"  | awk '{print$9}' )"
	Power_Cycle_Count="$(cat SMART.tmp | grep "Power_Cycle_Count"  | awk '{print$9}' )"
	Unknown_Attribute_id170="$(cat SMART.tmp | grep -m1 "Unknown_Attribute"  | tail -n1 | awk '{print$9}' )"
	Unknown_Attribute_id171="$(cat SMART.tmp | grep -m2 "Unknown_Attribute"  | tail -n1 | awk '{print$9}' )"
	Unknown_Attribute_id172="$(cat SMART.tmp | grep -m3 "Unknown_Attribute"  | tail -n1 | awk '{print$9}' )"
	Unknown_Attribute_id173="$(cat SMART.tmp | grep -m4 "Unknown_Attribute"  | tail -n1 | awk '{print$9}' )"
	Unknown_Attribute_id174="$(cat SMART.tmp | grep -m5 "Unknown_Attribute"  | tail -n1 | awk '{print$9}' )"
	Runtime_Bad_Block="$(cat SMART.tmp | grep -m1 "Runtime_Bad_Block"  | awk '{print$9}' )"
	End_to_End_Error="$(cat SMART.tmp | grep -m1 "End-to-End_Error"  | awk '{print$9}' )" 
	Reported_Uncorrect="$(cat SMART.tmp | grep -m1 "Reported_Uncorrect" | awk '{print$9}' )"
	Command_Timeout="$(cat SMART.tmp | grep -m1 "Command_Timeout"  | awk '{print$9}' )"
	Temperature_Celsius="$(cat SMART.tmp | grep -m1 "Temperature_Celsius"  | awk '{print$9}' )"
	Hardware_ECC_Recovered="$(cat SMART.tmp | grep -m1 "Hardware_ECC_Recovered"  | awk '{print$9}' )"
	Reallocated_Event_Count="$(cat SMART.tmp | grep -m1 "Reallocated_Event_Count"  | awk '{print$9}' )"
	Current_Pending_Sector="$(cat SMART.tmp | grep -m1 "Current_Pending_Sector"  | awk '{print$9}' )"
	Offline_Uncorrectable="$(cat SMART.tmp | grep -m1 "Offline_Uncorrectable"  | awk '{print$9}' )"
	UDMA_CRC_Error_Count="$(cat SMART.tmp | grep -m1 "UDMA_CRC_Error_Count"  | awk '{print$9}' )"
	Unknown_SSD_Attribute_id202="$(cat SMART.tmp | grep -m1 "Unknown_SSD_Attribute" | tail -n1  | awk '{print$9}' )"
	Unknown_SSD_Attribute_id206="$(cat SMART.tmp | grep -m2 "Unknown_SSD_Attribute"  | tail -n1 | awk '{print$9}' )"
	Unknown_Attribute_id246="$(cat SMART.tmp | grep -m6 "Unknown_Attribute"  | tail -n1  | awk '{print$9}' )"
	Unknown_Attribute_id247="$(cat SMART.tmp | grep -m7 "Unknown_Attribute"  | tail -n1  | awk '{print$9}' )"
	Unknown_Attribute_id248="$(cat SMART.tmp | grep -m8 "Unknown_Attribute"  | tail -n1  | awk '{print$9}' )"
	Unused_Rsvd_Blk_Cnt_Tot="$(cat SMART.tmp | grep -m1 "Unused_Rsvd_Blk_Cnt_Tot"  | awk '{print$9}' )"
	Unknown_Attribute_210="$(cat SMART.tmp | grep -m1 "Unknown_Attribute"  | awk '{print$9}' )"
	Vendor_0xff_1="$(cat SMART.tmp | grep -m1 "Vendor (0xff)"  | awk '{print$10}' )"
	Vendor_0xff_2="$(cat SMART.tmp | grep -m1 "Vendor (0xff)"  | awk '{print$10}' )"
	Vendor_0xff_3="$(cat SMART.tmp | grep -m1 "Vendor (0xff)"  | awk '{print$10}' )"
	SMART_overall_health_self_assessment_test_result="$(cat SMART.tmp | grep -m1 "SMART overall-health self-assessment test result:"  | awk '{print$6}' )"
	Error_logs="$(cat SMART.tmp | grep -A 1 "SMART Error" | tail -1)"
 
	rm -f SMART.tmp
#Badblock Check	
	
	Badblock_Result_0x55="$(cat $Badblock_0x55 | grep Pass | awk '{print$1,$2}')" 
	Badblock_Result_0xaa="$(cat $Badblock_0xaa | grep Pass | awk '{print$1,$2}')"
	Badblock_Result_0xff="$(cat $Badblock_0xff | grep Pass | awk '{print$1,$2}')"
	Badblock_Result_0x00="$(cat $Badblock_0x00 | grep Pass | awk '{print$1,$2}')"
	
	Badblock_Result_0x55_Errors="$(cat $Badblock_0x55 | grep Pass | cut -d '(' -f2 | awk '{print$1}')"
	Badblock_Result_0xaa_Errors="$(cat $Badblock_0xaa | grep Pass | cut -d '(' -f2 | awk '{print$1}')"
	Badblock_Result_0xff_Errors="$(cat $Badblock_0xff | grep Pass | cut -d '(' -f2 | awk '{print$1}')"
	Badblock_Result_0x00_Errors="$(cat $Badblock_0x00 | grep Pass | cut -d '(' -f2 | awk '{print$1}')"

#Overall Check
	OverAllStatus='Passed'
	if [[ (  $Predictive_Failure_Count -ne 0 ) || ( $Media_Error_Count -ne 0 ) || ( $Other_Error_Count -ne 0 )  || ( $Elements_GDL -ne 0 ) || ( $Temperature -gt 55 ) || ( "$SMART_Health" != "OK" ) || ("$Long_ST" != "Completed" ) || ( $Badblock_Result_0x55 != "Pass completed," ) || ( $Badblock_Result_0xaa != "Pass completed," ) || ( $Badblock_Result_0xff != "Pass completed," ) || ( $Badblock_Result_0x00 != "Pass completed," ) || ( $Badblock_Result_0x55_Errors != "0/0/0" ) || ( $Badblock_Result_0xaa_Errors != "0/0/0" ) || ( $Badblock_Result_0xff_Errors != "0/0/0" ) || ( $Badblock_Result_0x00_Errors != "0/0/0" )  ]]
	then
		OverAllStatus='Attention'
	fi	
	
	echo -e "$SystemName\t$CurrentFolderName\t$Enc_Pos\t[$EncID:$Slot_No]\t$Media_Type_Clean-$PD_Type\t$Serial_Number\t$Firmware_Version\t$Device_Id\t$Firmware_State\t$Media_Error_Count\t$Other_Error_Count\t$Predictive_Failure_Count\t$SMART_Health\t$Long_ST\t$Elements_GDL\t$Non_MEC\t$PowerUp\t$Temperature\t$Badblock_Result_0x55\t$Badblock_Result_0x55_Errors\t$Badblock_Result_0xaa\t$Badblock_Result_0xaa_Errors\t$Badblock_Result_0xff\t$Badblock_Result_0xff_Errors\t$Badblock_Result_0x00\t$Badblock_Result_0x00_Errors\t$OverAllStatus\t$Raw_Read_Error_Rate\t$Reallocated_Sector_Ct\t$Power_On_Hours\t$Power_Cycle_Count\t$Unknown_Attribute_id170\t$Unknown_Attribute_id171\t$Unknown_Attribute_id172\t$Unknown_Attribute_id173\t$Unknown_Attribute_id174\t$Runtime_Bad_Block\t$End_to_End_Error\t$Reported_Uncorrect\t$Command_Timeout\t$Temperature_Celsius\t$Hardware_ECC_Recovered\t$Reallocated_Event_Count\t$Current_Pending_Sector\t$Offline_Uncorrectable\t$UDMA_CRC_Error_Count\t$Unknown_SSD_Attribute_id202\t$Unknown_SSD_Attribute_id206\t$Unknown_Attribute_id246\t$Unknown_Attribute_id247\t$Unknown_Attribute_id248\t$Unused_Rsvd_Blk_Cnt_Tot\t$Unknown_Attribute_210\t$Vendor_0xff_1\t$Vendor_0xff_2\t$Vendor_0xff_3\t$SMART_overall_health_self_assessment_test_result\t$Error_logs"  >> Disks_Table.txt
		
done

cd $MainFolder/
for i in $( ls -d */ | cut -f1 -d '/' ) ; do ls $i/badblock-0x* | zip  -@ $i/$i-badblock-All.zip ; done
