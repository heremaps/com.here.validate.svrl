<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Apply Rules which	apply to topic nodes only -->
	<xsl:template match="topic" mode="topic-pattern">
		<!-- style rules -->
		<xsl:call-template name="fired-rule">
			<xsl:with-param name="context">topic</xsl:with-param>
			<xsl:with-param name="role">style</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="topic-style-rules"/>
	</xsl:template>
	<!--
		Special Style Rules for <topic>elements
	-->
	<xsl:template name="topic-style-rules">
		<!-- For the root <topic>element only -->
		<xsl:if test="not(ancestor::topic)">
			<xsl:variable name="fileName" select="tokenize(base-uri(), '/')[last()]"/>
			<!--
				file-not-lower-case - topic file must be lower case
			-->
			<xsl:if test="matches($fileName, '[A-Z_]+')">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">file-not-lower-case</xsl:with-param>
					<xsl:with-param name="test">matches($fileName, '[A-Z_]+'))</xsl:with-param>
					<!--  Placeholders -->
					<xsl:with-param name="param1" select="string($fileName)"/>
				</xsl:call-template>
			</xsl:if>
			<!--
				topic-file-mismatch- topic ID should match filename
			-->
			<xsl:if test="not(matches($fileName, @id))">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">topic-file-mismatch</xsl:with-param>
					<xsl:with-param name="test">not(matches($fileName, @id)))</xsl:with-param>
					<!--  Placeholders -->
					<xsl:with-param name="param1" select="string($fileName)"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!-- For all non-conref'd sections -->
		<xsl:if test="not(@conref)">
			<!--
				topic-title-missing - topic must have a title
			-->
			<xsl:if test="not(title)">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">topic-title-missing</xsl:with-param>
					<xsl:with-param name="test">not(title)</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	

	<xsl:template match="appendices" mode="appendices-structure-rules">
		<!--
			appendices-href-missing - For <appendices>elements, href is mandatory
		-->
		<xsl:if test="not(@navtitle) and not(navtitle) and not(@href)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">appendices-href-missing</xsl:with-param>
				<xsl:with-param name="test">(name() = 'appendices') and not(@href)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="chapter" mode="chapter-structure-rules">
		<!--
			chapter-href-missing - For <chapter>elements, href is mandatory
		-->
		<xsl:if test="not(@navtitle) and not(navtitle) and not(@href)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">chapter-href-missing</xsl:with-param>
				<xsl:with-param name="test">(name() = 'chapter') and not(@href)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="notices" mode="notices-structure-rules">
		<!--
			notices-href-missing - For <notices>elements, href is mandatory
		-->
		<xsl:if test="not(@navtitle) and not(navtitle) and not(@href)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">notices-href-missing</xsl:with-param>
				<xsl:with-param name="test">(name() = 'notices') and not(@href)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="topicref" mode="topicref-structure-rules">
		<!--
			topicref-href-missing - For <topicref>elements, href is mandatory
		-->
		<xsl:if test="not(@navtitle) and not(navtitle) and not(@href)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">topicref-href-missing</xsl:with-param>
				<xsl:with-param name="test">(name() = 'topicref') and not(@href)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>