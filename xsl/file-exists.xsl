<?xml version="1.0" ?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns:xs="http://www.w3.org/2001/XMLSchema"
	 xmlns:java="http://www.java.com/"
	 exclude-result-prefixes="java xs">


	<!--
		Check whether a file exists with XSLT2 (a Java extension -powered function)

		This function was created by  Eero Helenius (http://stackoverflow.com/users/825783/eero-helenius) for Stack Exchange.
		Material on Stack Exchange is available under  the Creative Commons Attribution Share Alike license
		see: http://stackexchange.com/legal

		You are free to:

		Share — copy and redistribute the material in any medium or format
		Adapt — remix, transform, and build upon the material for any purpose, even commercially.

		https://gist.github.com/eerohele/4531924
		http://stackoverflow.com/questions/2917655/how-do-i-check-for-the-existence-of-an-external-file-with-xsl/14323873#14323873

	-->
	<xsl:function name="java:file-exists" xmlns:file="java.io.File" as="xs:boolean">
		<xsl:param name="file" as="xs:string"/>
		<xsl:param name="base-uri" as="xs:string"/>

		<xsl:choose>
			<xsl:when test="starts-with($base-uri, 'file:C:')">
				<xsl:variable name="base-uri-win" select="replace($base-uri, 'file:C:', '')" />
				<xsl:variable name="absolute-uri-win" select="resolve-uri($file, $base-uri-win)" as="xs:anyURI"/>
				<xsl:sequence select="file:exists(file:new(concat('file:C:', $absolute-uri-win)))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="absolute-uri" select="resolve-uri($file, $base-uri)" as="xs:anyURI"/>
				<xsl:sequence select="file:exists(file:new($absolute-uri))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>