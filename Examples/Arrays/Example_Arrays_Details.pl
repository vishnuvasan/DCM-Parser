use strict;
use warnings;

#Importing all Function from the DCM_Parser Directory.Import specific Functions if you wish
use DCM_Parser;

#Getting the DCM File Name as a Command Line Array and Passing it to DCM_File Function
DCM_File($ARGV[0]);

#Setting the Tag Values in the DCM to be Default which means German Tags
Default_Tags(0);

#Declaration of Hash to Get the Values of Array Details
my ($Details,%Arrays_Details);

#Function to return a Hash Containing all the Array Details
$Details=Arrays_Details();

#DeReferencing the Obtained Hash Reference
%Arrays_Details=%$Details;

#Print All the Details contained in tha Hash
foreach my $Array (keys(%Arrays_Details))
{
	
		print "\n";
		print '+---------------------------------------',"\n";
		
		#Each Key of the Hash will be a Array
		print "		ARRAY			: ",$Array,"\n";
		
		#Syntax to Get the Array Description
		print "		DESCRIPTION		: ",$Arrays_Details{$Array}{'DESCRIPTION'},"\n";
		
		#Syntax to Get the Array Size
		print "		SIZE			: ",$Arrays_Details{$Array}{'SIZE'},"\n";
		
		#Syntax to Get the Function in which the Array is Used
		print "		FUNCTION		: ",$Arrays_Details{$Array}{'FUNCTION'},"\n";
		
		#Syntax to Get the Unit of the Array
		print "		UNIT			: ",$Arrays_Details{$Array}{'UNIT'},"\n";
		
		#Syntax to Get the Value of the Paramter
		print "		VALUE			: ",$Arrays_Details{$Array}{'VALUE'},"\n";
		
		print '											-------------------------------------------+';
		print "\n\n";
}

