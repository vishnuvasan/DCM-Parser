use strict;
use warnings;

#Importing all Function from the DCM_Parser Directory.Import specific Functions if you wish
use DCM_Parser;

#Getting the DCM File Name as a Command Line Parameter and Passing it to DCM_File Function
DCM_File($ARGV[0]);

#Setting the Tag Values in the DCM to be Default which means German Tags
Default_Tags(0);

#Declaration of Hash to Get the Values of Functions and Description
my ($Details,%Function_And_Description_Details);

#Function to return a Hash Containing all the Function and Description Details
$Details=Functions_And_Description();

#DeReferencing the Obtained Hash Reference
%Function_And_Description_Details=%$Details;

#Print All the Details contained in tha Hash
foreach my $Function (keys(%Function_And_Description_Details))
{
	
		print "\n";
		print '+---------------------------------------',"\n";
		
		#Each Key of the Hash will be a Function
		print "		FUNCTION		: ",$Function,"\n";
		
		#Syntax to Get the Function Description
		print "		DESCRIPTION		: ",$Function_And_Description_Details{$Function},"\n";
		
		print '											-------------------------------------------+';
		print "\n\n";
}

