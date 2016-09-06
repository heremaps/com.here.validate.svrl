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
	 xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
	 version="2.0">

	<!-- Import the standard com.here.validate.svrl ruleset -->
	<xsl:import href="plugin:com.here.validate.svrl:xsl/dita2svrl.xsl"/>

	<!--
			To override a set of rules, uncomment one or more of the rule groups defined below
			see the com.here.validate.svrl.override plugin for an example usage.
	-->


	<!--xsl:import href="../Customization/xsl/common-rules.xsl"/-->
	<!--xsl:import href="../Customization/xsl/textual-rules.xsl"/-->
	<!--xsl:import href="../Customization/xsl/fop-rules.xsl"/-->

	<!--xsl:import href="../Customization/xsl/codeblock.xsl"/-->
	<!--xsl:import href="../Customization/xsl/figure.xsl"/-->
	<!--xsl:import href="../Customization/xsl/image.xsl"/-->
	<!--xsl:import href="../Customization/xsl/section.xsl"/-->
	<!--xsl:import href="../Customization/xsl/topic.xsl"/-->
	<!--xsl:import href="../Customization/xsl/xref.xsl"/-->



</xsl:stylesheet>