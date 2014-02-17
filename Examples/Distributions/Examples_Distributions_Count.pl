use strict;
use warnings;

#Importing all Function from the DCM_Parser Directory.Import specific Functions if you wish
use DCM_Parser;

#Getting the DCM File Name as a Command Line Parameter
DCM_File($ARGV[0]);

#Setting the Tag Values in the DCM to be Default which means German Tags
Default_Tags(0);

my $Total_Distributions;

#Function to return Total No of Distributions Present in the DCM
$Total_Distributions=Distributions_Count();

#Printing the Total Number of Distributions
print "	TOTAL : ",$Total_Distributions,"\n";
