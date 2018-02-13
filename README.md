# nmap2cherry
A hacky XSLT to convert nmap scan results into CherryTree (<https://www.giuspen.com/cherrytree>) format.

![Example](https://user-images.githubusercontent.com/1066366/36130429-ca24aa96-103a-11e8-8f78-bdb98cac1142.PNG)

# Why?
While studying for the Offensive Security Certified Professional training, I found myself constantly manually copying nmap scan result data into CherryTree. This detracted from the learning process, as it is very tedious and time-consuming. So I wrote this little XSLT to convert nmap XML output into a format that can be readily imported into CherryTree.

# How to run
1. Do an nmap scan and specify the <code>-oX</code> output option so that the scan results are output to an XML file.
2. Run an XSLT 3.0-compatible XSLT processor on the output file (I've used Saxon 9 <http://saxon.sourceforge.net/> with good results), specifying the nmap2cherry XSLT and an output file with a file extension of <code>.ctd</code>. Here's an example command line invocation: <code>Transform.exe \-xsl:nmap2cherry.xslt \-s:nmap\_results.xml -o:nmap\_results.ctd</code>
3. Open the output <code>.ctd</code> file directly in CherryTree, or import it into an existing CherryTree document using the <code>Nodes Import</code> function.

# Found a problem or have a feature request?
Feel free to create an issue. Pull requests are also very welcome.
