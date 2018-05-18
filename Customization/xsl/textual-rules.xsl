<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--
	Common DITA Spelling Rules - Typographic errors within the running text, not codeph or codeblock
  -->
	<xsl:template match="*[not(self::draft-comment or self::codeph or self::codeblock or ancestor::codeblock)]" mode="common-textual-rules">
		<!-- Running text checks-->
		<xsl:variable name="running-text">
			<xsl:value-of select="text()" />
		</xsl:variable>
		<xsl:variable name="running-text-node" select="."/>
		<!--
			blacklisted-word - The words in ${args.validate.blacklist} should not be found within the running text.
		-->
		<xsl:variable name="blacklisted-words" select="tokenize($BLACKLIST,'\|')"/>
		<xsl:for-each select="$blacklisted-words">
			<xsl:variable name="banned-word-regex">(^|\W)<xsl:value-of select="."/>($|\W)</xsl:variable>
			<xsl:if test="matches($running-text,$banned-word-regex,'i')">
				<xsl:apply-templates mode="failed-assert-with-node" select="$running-text-node">
					<xsl:with-param name="rule-id">blacklisted-word</xsl:with-param>
					<xsl:with-param name="test">matches($running-text,$banned-word-regex,'i')</xsl:with-param>
					<!--  Placeholders -->
					<xsl:with-param name="param1" select="string(.)"/>
					<xsl:with-param name="param2" select="replace($running-text, '\\', '\\\\')" />
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>
		<!--
		incorrect-capitalization - The words in ${args.validate.check.case} should only be found with the same captilization
		-->
		<xsl:variable name="all-case-checked-words-regex">(^|\W)(<xsl:value-of select="$CHECK_CASE"/>)($|\W)</xsl:variable>
		<xsl:if test="matches($running-text,$all-case-checked-words-regex,'i') and not(matches($running-text,$all-case-checked-words-regex))">
			<xsl:variable name="case-checked-words" select="tokenize($CHECK_CASE,'\|')"/>
			<xsl:for-each select="$case-checked-words">
				<xsl:variable name="case-checked-word-regex">(^|\W)<xsl:value-of select="."/>($|\W)</xsl:variable>
				<xsl:variable name="case-checked-word-prefixed">(\.|\\|/|_|\-|:)<xsl:value-of select="."/></xsl:variable>
				<xsl:variable name="case-checked-word-postfixed"><xsl:value-of select="."/>(\.|\\|/|_|\-|:)</xsl:variable>
				<xsl:if test="matches($running-text,$case-checked-word-regex,'i') and not(matches($running-text,$case-checked-word-regex)) and not(matches($running-text,$case-checked-word-prefixed,'i')) and not(matches($running-text,$case-checked-word-postfixed,'i'))">
				<xsl:apply-templates mode="failed-assert-with-node" select="$running-text-node">
						<xsl:with-param name="rule-id">incorrect-capitalization</xsl:with-param>
						<xsl:with-param name="test">matches($running-text,$case-checked-word-regex,'i') and not(matches($running-text,$case-checked-word-regex))</xsl:with-param>
						<!--  Placeholders -->
						<xsl:with-param name="param1" select="string(.)"/>
						<xsl:with-param name="param2" select="replace($running-text, '\\', '\\\\')" />
					</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="common-textual-rules" />
</xsl:stylesheet>