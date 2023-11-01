#Connect to Exchange OnLine
UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

#Delete contact on Office 365 if contact is present on CSV file
$PATHCSV = "C:\DeleteContact.CSV"
$IMPORTCSV = Import-Csv $PATHCSV

ForEach ($item in $IMPORTCSV)
{
	$TODELETE = $item.ADRESSE
	Remove-MailContact -Identity $TODELETE -Confirm:$false
	$TODELETE
}

#Import contact to CSVFile
#Create CSV file with column (Display name and External mail) 
$PATHCSVNEW = "C:\Newcontacts.CSV"
$IMPORTCSVNEW = Import-Csv $PATHCSVNEW
ForEach ($itemnew in $IMPORTCSVNEW)
{
	$NAME = $itemnew.NAME
	$ADDRESS = $itemnew.ADDRESS
	$NAME
	New-MailContact -Name $NAME -DisplayName $NAME -ExternalEmailAddress $ADDRESS
}