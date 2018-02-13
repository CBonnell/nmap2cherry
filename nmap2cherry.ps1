# Runs the nmap2cherry XSLT on the XML file specified as the first command line argument.
# The output .ctd file will be saved to the directory where this PowerShell script is located.
$input = $args[0]
$script_dir = Split-Path -Parent $PSCommandPath
$output = [System.IO.Path]::Combine($script_dir, [System.IO.Path]::GetFileName([System.IO.Path]::ChangeExtension($input, '.ctd')))
Transform.exe -s:$input -o:$output -xsl:nmap2cherry.xslt