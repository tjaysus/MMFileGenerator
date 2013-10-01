require 'CSV'
require 'english'

source_directory = "/Users/Timothy/Documents/Code/GitHub/MMFileGenerator/"
output_file = "UnenrichedSampleFile.txt"
promotion_data_file = "promo_extract.csv"

global_offers_per_person = 6
output_file_record_limit = 5


#Create, open and name file that is created
somefile = File.open(output_file, "w")



#Create a record

#Insert header record- the same for every sample file
somefile.write "UCI@CHAR@36\tUCI_VERSION_NUMBER@CHAR@10\tSUPERCELLID@INT@12\tCAMPAIGN_CODE@CHAR@16\tCELL_CODE@CHAR@16\tFIRST_SHOPPED_DOT_COM@CHAR@9\tTEMPLATE_ID\tEMAIL_ADDRESS@CHAR@128\tFIRSTNAME@CHAR@32\tSURNAME@CHAR@32\tTITLE@CHAR@16\tMIDDLEINITIAL@CHAR@5\tMOBILE@CHAR@32\tADDRESS_LINE_1@CHAR@100\tADDRESS_LINE_2@CHAR@100\tADDRESS_LINE_3@CHAR@100\tADDRESS_LINE_4@CHAR@100\tADDRESS_LINE_5@CHAR@100\tTPNB1\tTPNB1_DESC\tTPNB1_IMAGE_URL\tOFFERID1\tOFFERID1_DESC\tOFFERID1_IMAGE_URL\tOFFERID1_STARTDATE\tOFFERID1_ENDDATE\tZONEID1\tTREATMENT_CODE1\tTPNB2\tTPNB2_DESC\tTPNB2_IMAGE_URL\tOFFERID2\tOFFERID2_DESC\tOFFERID2_IMAGE_URL\tOFFERID2_STARTDATE\tOFFERID2_ENDDATE\tZONEID2\tTREATMENT_CODE2\tTPNB3\tTPNB3_DESC\tTPNB3_IMAGE_URL\tOFFERID3\tOFFERID3_DESC\tOFFERID3_IMAGE_URL\tOFFERID3_STARTDATE\tOFFERID3_ENDDATE\tZONEID3\tTREATMENT_CODE3\tTPNB4\tTPNB4_DESC\tTPNB4_IMAGE_URL\tOFFERID4\tOFFERID4_DESC\tOFFERID4_IMAGE_URL\tOFFERID4_STARTDATE\tOFFERID4_ENDDATE\tZONEID4\tTREATMENT_CODE4\tTPNB5\tTPNB5_DESC\tTPNB5_IMAGE_URL\tOFFERID5\tOFFERID5_DESC\tOFFERID5_IMAGE_URL\tOFFERID5_STARTDATE\tOFFERID5_ENDDATE\tZONEID5\tTREATMENT_CODE5\tTPNB6\tTPNB6_DESC\tTPNB6_IMAGE_URL\tOFFERID6\tOFFERID6_DESC\tOFFERID6_IMAGE_URL\tOFFERID6_STARTDATE\tOFFERID6_ENDDATE\tZONEID6\tTREATMENT_CODE6\tOFFERCOUNT\n"

#Build contents of file
output_file_record_count = 0
until output_file_record_count > output_file_record_limit

#Populate customer profile params
somefile.write "UCI\tUCI_VERSION_NUMBER"
#Insert padding for RED data
somefile.write "\t" * 16

#Populate promotion data - price and product parameters
offers_per_person = global_offers_per_person

#Read the promotions data file line by line
CSV.foreach(promotion_data_file, :headers => :true ) do |line|
	unless $INPUT_LINE_NUMBER > offers_per_person
		somefile.write "#{line['TPNB']}" + "\t" * 2 + "#{line['OfferID']}" + "\t" * 3 + "#{line['ZoneID']}\tTreatmentCode\t"
	end
end

#Populate offer count
somefile.write "#{offers_per_person}\n"

output_file_record_count += 1

end




#Close file and write to directory
somefile.close
