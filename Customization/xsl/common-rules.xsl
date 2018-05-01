<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Validator project.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet version="2.0" xmlns:java="http://www.java.com/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- Apply Rules which	apply to all nodes  -->
	<xsl:template match="*" mode="common-pattern">
		<active-pattern name="common-style-rules" role="style">
			<xsl:apply-templates mode="common-style-rules" select="//*"/>
		</active-pattern>
		<active-pattern name="common-content-rules" role="content">
			<xsl:apply-templates mode="common-content-rules" select="//*[text()]"/>
			<xsl:apply-templates mode="common-comment-rules" select="//*[comment()]"/>
			<xsl:apply-templates mode="common-textual-rules" select="//*[text()]"/>
		</active-pattern>
		<xsl:if test="//*[@conref]">
			<active-pattern name="common-structure-rules" role="structure">
				<xsl:apply-templates mode="conref-structure-rules" select="//*[@conref]"/>
			</active-pattern>
		</xsl:if>
	</xsl:template>
	<!--
		Common DITA Style Rules - attribute values, casing and required attributes
	-->
	<xsl:template match="*[not(self::keyword)]" mode="common-style-rules">
		<xsl:call-template name="fired-rule"/>
		<!-- Wherever ids	exist-->
		<xsl:if test="@id">
			<!--
				id-not-lower-case - For all elements, @id where it exists, must be lower case and dash separated.
			-->
			<xsl:if test="matches(@id, '[A-Z_]+')">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">id-not-lower-case</xsl:with-param>
					<xsl:with-param name="test">matches(@id, '[A-Z_]+')</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<!--
				id-not-unique - For all elements, @id where it exists, must be unique.
			-->
			<xsl:if test="@id = preceding:: */@id">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">id-not-unique</xsl:with-param>
					<xsl:with-param name="test">@id = preceding:: */@id</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<!--
				fig-id-invalid - For <fig>elements, ID for a	must start "fig-''
			-->
			<xsl:if test="(name() = 'fig') and not(starts-with(@id, 'fig-'))">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">fig-id-invalid</xsl:with-param>
					<xsl:with-param name="test">(name() = 'table') and not(starts-with(@id, 'fig-'))</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<!--
				table-id-invalid - For <table>elements, ID must start "table-''
			-->
			<xsl:if test="(name() = 'table') and not(starts-with(@id, 'table-'))">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">table-id-invalid</xsl:with-param>
					<xsl:with-param name="test">(name() = 'table') and not(starts-with(@id, 'table-'))</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!--
			Checks for mandatory ID attributes - only applies to certain types of element.
		-->
		<xsl:if test="not(@id)">
			<xsl:apply-templates mode="common-mandatory-id" select="."/>
		</xsl:if>
		<!--
			colsep-invalid - For all elements, @colsep where it exists, must be 1 or 0.
		-->
		<xsl:if test="@colsep">
			<xsl:if test="not(matches(@colsep, '^[0|1]$'))">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">colsep-invalid</xsl:with-param>
					<xsl:with-param name="test">not(matches(@colsep, '^[0|1]$'))</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!--
			conref-not-lower-case - For all elements, @conref where it exists, filename must be lower case dash and separated.
		-->
		<xsl:if test="@conref">
			<xsl:variable name="isFileRef" select="not(starts-with(@conref, '#'))"/>
			<xsl:variable name="filePath" select="if (contains(@conref, '#'))  then resolve-uri(substring-before(@conref, '#'), resolve-uri('.', document-uri(/)))  else resolve-uri(@conref, resolve-uri('.', document-uri(/)))"/>
			<xsl:variable name="file" select="if ($isFileRef) then tokenize($filePath, '/')[last()] else ''"/>
			<xsl:if test="matches($file, '[A-Z_]+')">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">conref-not-lower-case</xsl:with-param>
					<xsl:with-param name="test">matches(@conref, '[A-Z_]+')</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!--
			href-not-lower-case - For all elements, @href where it exists, filename must be lower case dash and separated.
		-->
		<xsl:if test="@href">
			<xsl:variable name="isWWWRef" select="starts-with(@href, 'http://') or starts-with(@href, 'https://')"/>
			<xsl:variable name="isFileRef" select="not($isWWWRef) and not(starts-with(@href, '#')) and not(contains(@href, 'file:/')) and not(contains(@href, 'mailto'))"/>
			<xsl:variable name="filePath" select="if (contains(@href, '#'))  then resolve-uri(substring-before(@href, '#'), resolve-uri('.', document-uri(/)))  else resolve-uri(@href, resolve-uri('.', document-uri(/)))"/>
			<xsl:variable name="file" select="if ($isFileRef) then tokenize($filePath, '/')[last()] else ''"/>
			<xsl:if test="matches($file, '[A-Z_]+')">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">href-not-lower-case</xsl:with-param>
					<xsl:with-param name="test">matches(@href, '[A-Z_]+')</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!--
			rowsep-invalid - For all elements, @rowsep where it exists, must be 1 or 0.
		-->
		<xsl:if test="@rowsep">
			<xsl:if test="not(matches(@rowsep, '^[0|1]$'))">
				<xsl:call-template name="failed-assert">
					<xsl:with-param name="rule-id">rowsep-invalid</xsl:with-param>
					<xsl:with-param name="test">not(matches(@rowsep, '^[0|1]$'))</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="keyword" mode="common-style-rules"/>
	<!--
		Common DITA Style Rules - checks for mandatory ID attributes
	-->
	<xsl:template match="section|topic" mode="common-mandatory-id">
		<!--
			*-id-missing - For <section>and <topic>elements, ID is mandatory
		-->
		<xsl:if test="not(@id)">
			<xsl:call-template name="fired-rule"/>
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">
					<xsl:value-of select="name()"/>-id-missing</xsl:with-param>
				<xsl:with-param name="test">(name() = '
					<xsl:value-of select="name()"/>
					') and not(@id)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="common-mandatory-id"/>
	<!--
		Common DITA Content Rules - proscribed words.
	-->
	<xsl:template match="*[not(self::keyword)]" mode="common-content-rules">
		<xsl:call-template name="fired-rule"/>
		<!-- Running text checks-->
		<xsl:variable name="running-text">
			<xsl:value-of select="text()"/>
		</xsl:variable>
		<!--
			running-text-fixme - The words FIXME should not be found in the running text
		-->
		<xsl:if test="contains(lower-case($running-text),'fixme')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">running-text-fixme</xsl:with-param>
				<xsl:with-param name="test">matches(lower-case(text()),'fixme')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="replace($running-text, '\\', '\\\\')"/>
			</xsl:call-template>
		</xsl:if>
		<!--
			running-text-todo - The words TODO should not be found in the running text
		-->
		<xsl:if test="contains(lower-case($running-text),'todo')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">running-text-todo</xsl:with-param>
				<xsl:with-param name="test">matches(lower-case(text()),'fixme')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="replace($running-text, '\\', '\\\\')"/>
			</xsl:call-template>
		</xsl:if>
		<!--
			running-text-lorem-ipsum - The words lorem ipsum should not be found in the running text
		-->
		<xsl:if test="contains(lower-case($running-text),'lorem') or contains(lower-case($running-text),'ipsum')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">running-text-lorem-ipsum</xsl:with-param>
				<xsl:with-param name="test">matches(lower-case(text()),'lorem ipsum')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="replace($running-text, '\\', '\\\\')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*" mode="common-content-rules"/>
	<!--
		Common comment Rules - FIXME and TODO in the comments.
	-->
	<xsl:template match="*" mode="common-comment-rules">
		<!-- Comment checks-->
		<xsl:variable name="comment">
			<xsl:value-of select="comment()"/>
		</xsl:variable>
		<!--
			comment-fixme - The words FIXME should not be found in the comments
		-->
		<xsl:if test="contains(lower-case($comment),'fixme')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">comment-fixme</xsl:with-param>
				<xsl:with-param name="test">contains(lower-case(text()),'fixme')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="$comment"/>
			</xsl:call-template>
		</xsl:if>
		<!--
			comment-todo - The words TODO should not be found in the comments
		-->
		<xsl:if test="contains(lower-case($comment),'todo')">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">comment-todo</xsl:with-param>
				<xsl:with-param name="test">contains(lower-case(text()),'todo')</xsl:with-param>
				<!--  Placeholders -->
				<xsl:with-param name="param1" select="$comment"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!--
		Common conref DITA Structure Rules - missing links and ids for content references.
	-->
	<xsl:template match="*[@conref]" mode="conref-structure-rules">
		<xsl:call-template name="fired-rule"/>
		<xsl:variable name="isFileRef" select="(contains(@conref, '.dita') or contains(@conref, '.xml')) and not(contains(@conref, 'file:/'))"/>
		<xsl:variable name="isIdRef" select="starts-with(@conref, '#') and not(contains(@conref, '/'))"/>
		<xsl:variable name="isIdIdRef" select="starts-with(@conref, '#') and contains(@conref, '/')"/>
		<xsl:variable name="idRefPart" select="if (contains(@conref, '#')) then substring-after(@conref, '#') else false()"/>
		<xsl:variable name="idRef" select="if (boolean($idRefPart)) then (if (contains($idRefPart, '/')) then substring-before($idRefPart, '/') else $idRefPart) else false()"/>
		<xsl:variable name="idIdRef" select="if ($idRefPart) then substring-after($idRefPart, '/') else false()"/>
		<xsl:variable name="filePath" select="if (contains(@conref, '#')) then resolve-uri(substring-before(@conref, '#'), resolve-uri('.', document-uri(/)))  else resolve-uri(@conref, resolve-uri('.', document-uri(/)))"/>
		<xsl:variable name="file" select="if ($isFileRef) then tokenize($filePath, '/')[last()] else ''"/>
		<xsl:variable name="isFileRefAndFileExists" select="if ($isFileRef and $file) then java:file-exists($filePath, base-uri()) else false()"/>
		<xsl:variable name="idRefNode" select="if ($isFileRefAndFileExists and $idRef) then document($filePath)//*[@id = $idRef] else false()"/>
		<xsl:variable name="idIdRefNode" select="if ($isFileRefAndFileExists and ($idRef and $idIdRef)) then document($filePath)//*[@id = $idIdRef] else false()"/>
		<!--
			conref-internal-id-not-found - For a conref within a single file, the ID linked to must exist
		-->
		<xsl:if test="$isIdRef and not(//*/@id = $idRef)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">conref-internal-id-not-found</xsl:with-param>
				<xsl:with-param name="test">not(//*/@id = $idRef)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			conref-internal-path-not-found - For a conref within a single file, the path linked to must exist
		-->
		<xsl:if test="$isIdIdRef and not(//*[@id = $idIdRef]/ancestor:: */@id=$idRef)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">conref-internal-path-not-found</xsl:with-param>
				<xsl:with-param name="test">not(//*/@id = $idRef)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			conref-external-file-not-found - For a conref to an another file within the document, the file linked to must exist
		-->
		<xsl:if test="$isFileRef and not($isFileRefAndFileExists)">
			<xsl:call-template name="failed-assert">
				<xsl:with-param name="rule-id">conref-external-file-not-found</xsl:with-param>
				<xsl:with-param name="test">not($isFileRefAndFileExists)</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<!--
			Checks for content-references to within a single file.
		-->
		<xsl:if test="not($isFileRefAndFileExists) and $idRef">
			<xsl:choose>
				<!--
					conref-internal-id-mismatch  - For a conref within a single file, the ID linked to must be
													a node of the same type as the original
				-->
				<xsl:when test="$idRefNode and not($idIdRefNode) and not(name() = $idRefNode/name())">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">conref-internal-id-mismatch</xsl:with-param>
						<xsl:with-param name="test">not(name() = $idRefNode/name())</xsl:with-param>
						<!-- Placeholders -->
						<xsl:with-param name="param1" select="$idRefNode/name()"/>
					</xsl:call-template>
				</xsl:when>
				<!--
					conref-internal-path-mismatch  - For a conref to within a single file, the path linked to must be a node of the same type as the original
				-->
				<xsl:when test="$idIdRefNode and ($idIdRefNode/ancestor:: */@id=$idRef)  and not(name() = $idIdRefNode/name())">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">conref-internal-path-mismatch</xsl:with-param>
						<xsl:with-param name="test">not(name() = $idIdRefNode/name())</xsl:with-param>
						<!-- Placeholders -->
						<xsl:with-param name="param1" select="$idIdRefNode/name()"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<!--
			Checks for content-references to an another file within the document.
		-->
		<xsl:if test="$isFileRefAndFileExists and $idRef">
			<xsl:choose>
				<!--
					conref-external-id-not-found - For a conref to an another file within the document, the ID linked to must exist
				-->
				<xsl:when test="not($idIdRef) and not(document($filePath)//*/@id = $idRef)">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">conref-external-id-not-found</xsl:with-param>
						<xsl:with-param name="test">not($idIdRef) and not(document($filePath)//*/@id = $idRef)</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<!--
					conref-external-path-not-found - For a conref to an another file within the document, the path linked to must exist
				-->
				<xsl:when test="$idIdRef and not(document($filePath)//*[@id = $idIdRef]/ancestor:: */@id=$idRef)">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">conref-external-path-not-found</xsl:with-param>
						<xsl:with-param name="test">$idIdRef and not(document($filePath)//*[@id = $idIdRef]/ancestor:: */@id=$idRef)</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<!--
					conref-external-id-mismatch - For a conref to an another file within the document, the ID a node of the same type as the original
				-->
				<xsl:when test="$idRefNode and not($idIdRefNode) and not(name() = $idRefNode/name())">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">conref-external-id-mismatch</xsl:with-param>
						<xsl:with-param name="test">not(name() = $idRefNode/name())</xsl:with-param>
						<xsl:with-param name="param1" select="$idRefNode/name()"/>
					</xsl:call-template>
				</xsl:when>
				<!--
					conref-external-path-mismatch - For a conref to an another file within the document, the path linked to must be a node of the same type as the original
				-->
				<xsl:when test="$idIdRefNode and ($idIdRefNode/ancestor:: */@id=$idRef)  and not(name() = $idIdRefNode/name())">
					<xsl:call-template name="failed-assert">
						<xsl:with-param name="rule-id">conref-external-path-mismatch</xsl:with-param>
						<xsl:with-param name="test">not(name() = $idIdRefNode/name())</xsl:with-param>
						<!-- Placeholders -->
						<xsl:with-param name="param1" select="$idIdRefNode/name()"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*[not(@conref)]" mode="conref-structure-rules"/>
</xsl:stylesheet>