use strict;
use warnings;

#Importing all Function from the DCM_Parser Directory.Import specific Functions if you wish
use DCM_Parser;

#Getting the DCM File Name as a Command Line Parameter
DCM_File($ARGV[0]);

#Setting the Tag Values in the DCM to be Default which means German Tags
Default_Tags(0);

my $Total_Functions;

#Function to return Total No of Functions/Description Present in the DCM
$Total_Functions=Functions_And_Description_Count();

#Printing the Total Number of Functions/Descriptions
print "	TOTAL : ",$Total_Functions,"\n";
