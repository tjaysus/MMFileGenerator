require 'CSV'
require 'english'

source_directory = 'D:\Code\GitHub\MMFileGenerator-master\\'

output_file = 'UnenrichedSampleFile.txt'
output_file_location = source_directory + output_file

profile_data_file = 'profile_extract.csv'
profile_data_file_location = source_directory + profile_data_file

promotion_data_file = 'promo_extract.csv'
promotion_data_file_location = source_directory + promotion_data_file

#Number of offers included in file per person
offers_per_person = 6

#Number of customer records included in file
output_file_record_limit = 10


#Build structure of file and header row strings

promotion_attributes_ary = []

(1..offers_per_person).each do |i|
	 promotion_attributes_ary.push(
	 	"TPNB#{i}",
	 	"TPNB#{i}_DESC",
		"TPNB#{i}_IMAGE_URL",
		"OFFERID#{i}",
		"OFFERID#{i}_DESC",
		"OFFERID#{i}_IMAGE_URL",
		"OFFERID#{i}_STARTDATE",
		"OFFERID#{i}_ENDDATE",
		"ZONEID#{i}",
		"TREATMENT_CODE#{i}")
end

record_attributes = [
	"UCI@CHAR@36",
	"UCI_VERSION_NUMBER@INT@10",
	"SUPERCELLID@INT@12",
	"CAMPAIGN_CODE@CHAR@16",
	"CELL_CODE@CHAR@16",
	"FIRST_SHOPPED_DOT_COM@CHAR@9",
	"TEMPLATE_ID",
	"EMAIL_ADDRESS@CHAR@128",
	"FIRSTNAME@CHAR@32",
	"SURNAME@CHAR@32",
	"TITLE@CHAR@16",
	"MIDDLEINITIAL@CHAR@5",
	"MOBILE@CHAR@32",
	"ADDRESS_LINE_1@CHAR@100",
	"ADDRESS_LINE_2@CHAR@100",
	"ADDRESS_LINE_3@CHAR@100",
	"ADDRESS_LINE_4@CHAR@100",
	"ADDRESS_LINE_5@CHAR@100",
	promotion_attributes_ary,
	"OFFERCOUNT"
	]

record_attributes.flatten!


#Create the header row ary
header_row_titles_ary = record_attributes

#Create an array of profile parameters from file
#Assume structure of file is UCI,UCI_version
profile_param_ary = []
total_profiles_required_in_ary = output_file_record_limit

CSV.foreach(profile_data_file_location, :headers => :true ) do |line|
	unless profile_param_ary.size >= total_profiles_required_in_ary
		profile_param_ary.push(line)
	end
end

#Create an array of promotion parameters from file
#Assume structure of file is OfferID,ZoneID,TPNB
promo_param_ary = []
total_promo_offers_required_in_ary = offers_per_person * output_file_record_limit

CSV.foreach(promotion_data_file_location, :headers => :true ) do |line|
	unless promo_param_ary.size >= total_promo_offers_required_in_ary
		promo_param_ary.push(line)
	end
end


#For the number of customer records required, build single customer record and add to output_ary. Match required data to header record string

single_rec = []
output_ary = []

(1..output_file_record_limit).each do |record|
	record_attributes.each_with_index do | e, index |
		case e
		when "UCI@CHAR@36"
			single_rec[index] = profile_param_ary[0][0]
		when "UCI_VERSION_NUMBER@INT@10"
			single_rec[index] = profile_param_ary[0][1]
		when "SUPERCELLID@INT@12"
			single_rec[index] = 123456789101
		when "CAMPAIGN_CODE@CHAR@16"
			single_rec[index] = "CAMPABCDEFGHI123"
		when "CELL_CODE@CHAR@16"
			single_rec[index] = "CELLABCDEFGHI123"
		when "FIRST_SHOPPED_DOT_COM@CHAR@9"
			single_rec[index] = "FSHOPA123"
		when /OFFERID\d\d?$/
			single_rec[index] = promo_param_ary[0][0]
		when /ZONEID\d\d?$/
			single_rec[index] = promo_param_ary[0][1]
		when /TPNB\d\d?$/
			single_rec[index] = promo_param_ary[0][2]
		when "OFFERCOUNT"
			single_rec[index] = offers_per_person
		else
			single_rec[index] = ""
		end
	end
	output_ary.push(single_rec)
	profile_param_ary.shift
	promo_param_ary.shift
	single_rec = []
end


#Open and write header and customer records to the output file

f = File.open(output_file_location, "w")

#Create tab delimited string for header record from array and write to file
header_row_str = header_row_titles_ary.join("\t")
f.puts(header_row_str)

#For each record, create tab delimited string from array and write to file
output_ary.each do |record|
	joined_record = record.join("\t")
	f.puts(joined_record)
end

f.close