#!/bin/bash
##################
#Title: opencga_vcf_upload 
#Discription: Program to upload vcf files from DNAnexus to OpenCGA platform
#Version: 1.0.0 
#Author: Dr. Ravi P. More (Research Associate, Department of Paediatrics, University of Cambridge, Email: Ravi.More@addenbrookes.nhs.ac.uk)
#Date: 20-08-2021 
#USAGE: sh opencga-upload-v1.sh -i $PATH/<SAMPLE_NAME>.vcf.gz -p $PATH/Config.txt -o $PATH/outfile.txt
#Example: sh /home/usr/opencga-client-2.1.0-rc2/bin/opencga-upload-v1.sh -i /home/usr/Sampple.vcf.gz -p /home/usr/Config.txt -o /home/usr/Output.txt
##################

while getopts i:p:o: flag
do
    case "${flag}" in
        i) Input_vcf=${OPTARG};;
        p) Config_file=${OPTARG};;
        o) Output=${OPTARG};;
    esac
done

echo "Input vcf file name: $Input_vcf";
echo "Config file name: $Config_file";
echo "Output name: $Output";

#Reading config file
while read -r line
do
    [[ "$line" =~ ^#.*$ ]] && continue
    IFS=":" read -r -a ConfigInfo <<< "$line"
done < "$Config_file"

#Login with username and password 
echo "USERNAME: ${ConfigInfo[0]}"
echo "PASSWORD: ${ConfigInfo[1]}"
/home/dnanexus/opencga-client-2.1.0-rc2_v1/bin/opencga.sh users login -u ${ConfigInfo[0]} <<< ${ConfigInfo[1]}

# Upload vcf files using the config file information (OpenCGA login, Project, Study, and Directory)
echo "PROJECT: ${ConfigInfo[2]}"
echo "STUDY: ${ConfigInfo[3]}"
echo "DIRECTORY: ${ConfigInfo[4]}"
/home/dnanexus/opencga-client-2.1.0-rc2_v1/bin/opencga.sh files upload --study ${ConfigInfo[2]}:${ConfigInfo[3]} -i $Input_vcf --catalog-path ${ConfigInfo[4]}

# Print the VCF file names with the Project and Study name in output file
echo -e "\n***\n$Input_vcf file is uploaded to the Project:${ConfigInfo[2]} and Study:${ConfigInfo[3]}\n***\n" >> $Output

echo -e "\n***\nPlease check uploaded file using following command after login into OpenCGA\n<PATH>/opencga.sh files tree --study <STUDY_NAME> --folder <DIRECTORY>\n" > $Output

