<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->

<!--
	Stylesheet that is used to process each *.dita file in turn and transform it into
	Schematron Validation Report Language (SVRL) files

	see http://www.schematron.com/validators.html

	Schematron is an ISO/IEC Standard. ISO/IEC 19757-3:2006 Information technology
			Document Schema Definition Language (DSDL) - Part 3: Rule-based validation - Schematron
	The standard is available Royalty-free at the ISO website

	http://standards.iso.org/ittf/PubliclyAvailableStandards/index.html
-->

<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml"
	 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 xmlns:xs="http://www.w3.org/2001/XMLSchema"
	 xmlns:saxon="http://saxon.sf.net/"
	 xmlns:java="http://www.java.com/"
	 exclude-result-prefixes="java saxon"

	 version="2.0">


	<!-- Import XSL template that holds a function to some basic SVRL generation functions. -->
	<xsl:import href="schematron.xsl"/>




	<!--PROLOG-->
	<xsl:param name="IGNORE_RULES" as="xs:string"/>
	<xsl:param name="OUTPUT_RULE-ID" select="true" as="xs:string"/>
	<xsl:param name="BLACKLIST" as="xs:string"/>
	<xsl:param name="CHECK_CASE" as="xs:string"/>
	<xsl:param name="SOURCE" as="xs:string"/>
	<xsl:param name="DEFAULTLANG">en-us</xsl:param>
	<xsl:param name="FATAL_RULESET">a^</xsl:param>
	<xsl:param name="ERROR_RULESET">a^</xsl:param>
	<xsl:param name="WARNING_RULESET">a^</xsl:param>

	<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>


	<xsl:include href="../Customization/xsl/common-rules.xsl"/>
	<xsl:include href="../Customization/xsl/textual-rules.xsl"/>
	<xsl:include href="../Customization/xsl/fop-rules.xsl"/>

	<xsl:include href="../Customization/xsl/codeblock.xsl"/>
	<xsl:include href="../Customization/xsl/figure.xsl"/>
	<xsl:include href="../Customization/xsl/image.xsl"/>
	<xsl:include href="../Customization/xsl/section.xsl"/>
	<xsl:include href="../Customization/xsl/topic.xsl"/>
	<xsl:include href="../Customization/xsl/xref.xsl"/>

	<xsl:template match="/" >
		<!--SCHEMA SETUP-->
		<schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="Dita Validation" schemaVersion="1.5">

			<xsl:apply-templates mode="topic-pattern"/>
			<xsl:apply-templates mode="figure-pattern"/>
			<xsl:apply-templates mode="section-pattern"/>
			<xsl:apply-templates mode="codeblock-pattern"/>
			<xsl:apply-templates mode="image-pattern"/>
			<xsl:apply-templates mode="xref-pattern"/>

			<xsl:apply-templates mode="common-pattern"/>
			<xsl:apply-templates mode="fop-pattern"/>

		</schematron-output>
	</xsl:template>

</xsl:stylesheet>
