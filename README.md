DITA Validator for DITA-OT
==========================

[![DITA-OT 3.1](https://img.shields.io/badge/DITA--OT-3.1-blue.svg)](http://www.dita-ot.org/3.1)
[![DITA-OT 2.5](https://img.shields.io/badge/DITA--OT-2.5-green.svg)](http://www.dita-ot.org/2.5)
[![Build Status](https://travis-ci.org/jason-fox/com.here.validate.svrl.svg?branch=master)](https://travis-ci.org/jason-fox/com.here.validate.svrl)
[![license](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

The DITA Validator plug-in for [DITA-OT](http://www.dita-ot.org/) is a structure, style and content checker for DITA documents. The plug-in returns information about the compliance of the document against a **modifiable** series of validator rules. The plug-in also supports standard XML validation

The plug-in consists of a single transform which can do the following:
* Echo validation results to the command line
* Automatically fix common validation errors within the document.
* Return a report in *Schematron Validation Report Language* (`SVRL`) format. 
  More information about SVRL can be found at [www.schematron.com](http://www.schematron.com/validators.html)


Table of Contents
=================

- [Background](#background)
  * [What Is Valid XML?](#what-is-valid-xml)
  * [Validator compliant DITA](#validator-compliant-dita)
- [Install](#install)
  * [Installing DITA-OT](#installing-dita-ot)
  * [Installing the Plug-in](#installing-the-plug-in)
- [Usage](#usage)
  * [Validating a document from the Command line](#validating-a-document-from-the-command-line)
    + [Creating an SVRL file](#creating-an-svrl-file)
    + [Echoing results to the command line](#echoing-results-to-the-command-line)
    + [Fix common errors automatically](#fix-common-errors-automatically)
    + [Parameter Reference](#parameter-reference)
  * [Validating a document using ANT](#validating-a-document-using-ant)
- [Customizing the Validator](#customizing-the-validator)
  * [Adding New Validator Rules](#adding-new-validator-rules)
  * [Altering the severity of a validator rule](#altering-the-severity-of-a-validator-rule)
  * [Ignoring Validator Rules](#ignoring-validator-rules)
    + [Removing validator rules globally](#removing-validator-rules-globally)
    + [Ignoring a validator rule throughout a document](#ignoring-a-validator-rule-throughout-a-document)
    + [Ignoring a specific instance of a validator rule](#ignoring-a-specific-instance-of-a-validator-rule)
    + [Ignoring all warnings within a block](#ignoring-all-warnings-within-a-block)
    + [Ignoring all errors within a block](#ignoring-all-errors-within-a-block)
- [Customizing the DITA Fixer](#customizing-the-dita-fixer)
  * [Adding a new fixable rule](#adding-a-new-fixable-rule)
  * [Amending a fixable rule](#amending-a-fixable-rule)
- [Sample Document](#sample-document)
- [Validator Error Messages](#validator-error-messages)
  * [Content Validation](#content-validation)
  * [Style Validation](#style-validation)
  * [Structure Validation](#structure-validation)
  * [Deprecated Elements](#deprecated-elements)
- [Contribute](#contribute)
- [License](#license)


Background
==========

What Is Valid XML?
------------------

For any DITA publication to build successfully, all its files must contain valid DITA markup.

General XML validation rules require that:

-	Documents are well formed.
-	Documents contain only correctly encoded legal Unicode characters.
-	None of the special syntax characters such as "<" and "&" appear except as markup delineators.
-	The beginning and end tags must match exactly, unless tags are self-closing.
-	A single root element such as `<topic>`, contains all the other elements.
-	`<topic>` within a DITA document must conform to the `topic.dtd` Document Type Defintion

Validator compliant DITA
------------------------

The DITA Validator extends the concept of XML validation to run a series of structure and style compliance rules.
Sample rules include:

-	Whether the source files for	`<image>` and `<codeblock>` elements exist
-	Whether `conref` attributes are linking to missing elements
-	Whether every	`<section>` or `<fig>` element in the document has a meaningful `id`
-	Whether every `<section>` element has a title
-	If an `<xref>` refers to a location on the web, both the `scope="external"` and `format="html"` attributes must be set
-	Whether all `id` attributes are lower case and dash separated
-	Whether any blacklisted words are found within the document.
-	Whether the document will be unable to render as PDF due to empty `<table>` elements


Install
=======

The validator has been tested against [DITA-OT 3.0.x](http://www.dita-ot.org/download). It is recommended that you upgrade to the latest version. Running the validator plug-in against DITA-OT 1.8.5 or earlier versions of DITA-OT will not work as it uses the newer `getVariable` template. To work with DITA-OT 1.8.5 this would need to be refactored to use `getMessage`. The validator can be run safely against DITA-OT 2.x.

Installing DITA-OT
------------------

The DITA Validator is a plug-in for the DITA Open Toolkit.

-  Install the DITA-OT distribution JAR file dependencies by running `gradle install` from your clone of the [DITA-OT repository](https://github.com/dita-ot/dita-ot).

The required dependencies are installed to a local Maven repository in your home directory under `.m2/repository/org/dita-ot/dost/`.

-  Run the Gradle distribution task to generate the plug-in distribution package:

```console
./gradlew dist
```

The distribution ZIP file is generated under `build/distributions`.

Installing the Plug-in
----------------------

-  Run the plug-in installation command:

```console
dita -install https://github.com/jason-fox/com.here.validate.svrl/archive/master.zip
```

The `dita` command line tool requires no additional configuration.

Usage
=====

Validating a document from the Command line
-------------------------------------------

A test document can be found within the plug-in at `PATH_TO_DITA_OT/plugins/com.here.validate.svrl/sample`

### Creating an SVRL file

To create an SVRL file use the `svrl` transform with the `--args.validate.mode=report` parameter.

-  From a terminal prompt move to the directory holding the document to validate

-  SVRL file creation (`svrl`) can be run like any other DITA-OT transform:

```console
PATH_TO_DITA_OT/bin/dita -f svrl --args.validate.mode=report -o out -i document.ditamap
```

Once the command has run, an SVRL file is created

```xml
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<svrl:schematron-output>
	<active-pattern role="dita" name="/running-text-fixme.dita"/>
	<fired-rule context="common" role="content"/>
	<failed-assert role="warning" location="/topic/body[1]/section[2]/p[1]">
		<diagnostic-reference diagnostic="running-text-fixme">
			Line 20: p - [running-text-fixme] 
			Found 'FIXME' comments in the following text in this &lt;p&gt; element - 
			fix as requested and delete the comment. 

			FIXME This needs to be fixed
		</diagnostic-reference>
		</failed-assert>
	<fired-rule context="common" role="structure"/>
	<fired-rule context="common" role="style"/>
	<fired-rule context="topic" role="style"/>
	<fired-rule context="section" role="style"/>
	<fired-rule context="section" role="style"/>
	<active-pattern role="ditamap" name="/document.ditamap"/>
	<fired-rule context="common" role="structure"/>
</svrl:schematron-output>
```

### Echoing results to the command line

To echo results to the command line use the `svrl` transform without specifying a `report`

-  Document validation (`svrl`) can be run like any other DITA-OT transform:

```console
PATH_TO_DITA_OT/bin/dita -f svrl -i document.ditamap
```

Once the command has run, all errors and warnings are echoed to the command line

```console
[WARN]	 [/out/temp/dita/topics/comment-fixme.dita]
 Line 15: section[id="bad"] - [comment-fixme]
Found 'FIXME' comments within the <section> element - fix as requested and delete the comment.

FIXME This comment requires action

Found 0 Errors 1 Warnings
```

Additionally, if an error occurs, the command will fail

```console
[ERROR]	[/document.ditamap]
 Line 89: topicref - [href-not-lower-case]
The value provided in href="topics/FILE-NOT-LOWER-CASE.dita" is invalid, allowed characters are: lowercase, a-z only, words separated by hyphens.

Found 1 Errors 0 Warnings
Error: [SVRL001F][FATAL] Errors detected during validation
```

Optionally, the output can be highlighed using ANSI color codes by adding the `args.validate.color` parameter

```console
PATH_TO_DITA_OT/bin/dita -f svrl-echo -i document.ditamap -Dargs.validate.color=true
```

### Fix common errors automatically 

To run the  auto-fix command from the command line use the `svrl` transform with the `--args.validate.mode=fix-dita` parameter.

```console
PATH_TO_DITA_OT/bin/dita -f svrl -i document.ditamap --args.validate.mode=fix-dita
```

Once the command has run, the DITA files are updated and fixable errors and warnings are
no longer present.


### Parameter Reference

- `args.validate.ignore.rules` - Comma separated list of rules not to be enforced
- `args.validate.blacklist` - Comma separated list of words not to be present in the running text
- `args.validate.cachefile` - Specifies the location of cache file to be used. Validation will only run across altered files if this parameter is present
- `args.validate.check.case` - Comma separated list of words which have a specified capitalization
- `args.validate.color` - When set, errors and warnings are Output highlighted using ANSI color codes
- `args.validate.mode` - Validation reporting mode. The following values are supported:
	- `strict`	 - Outputs both warnings and errors. Fails on errors and warnings.
	- `default`  - Outputs both warnings and errors. Fails on errors only
	- `lax`		 - Ignores all warnings and outputs errors only. Fails on Errors only
	- `report`	 - Creates an SVRL file
	- `fix-dita` - Updates existing DITA files and automatically fixes as many errors as possible
- `svrl.customization.dir` - Specifies the customization directory
- `svrl.ruleset.file` - Specifies severity of the rules to apply. If this parameter is not present, default severity levels will be used.
- `svrl.filter.file` - Specifies the location of the XSL file used to filter the echo output. If this parameter is not present, the default echo output format will be used.



Validating a document using ANT
-------------------------------

An ANT build file is supplied in the same directory as the sample document. The main target can be seen below:


```xml
<dirname property="dita.dir" file="PATH_TO_DITA_OT"/>
<property name="dita.exec" value="${dita.dir}/bin/dita"/>
<property name="args.input" value="PATH_TO_DITA_DOCUMENT/document.ditamap"/>

<target name="validate" description="validate a document">
	<exec executable="${dita.exec}" osfamily="unix" failonerror="true">
		<arg value="-input"/>
		<arg value="${args.input}"/>
		<arg value="-output"/>
		<arg value="${dita.dir}/out/svrl"/>
		<arg value="-format"/>
		<arg value="svrl"/>
		<!-- validation transform specific parameters -->
		<arg value="-Dargs.validate.blacklist=(kilo)?metre|colour|teh|seperate"/>
		<arg value="-Dargs.validate.check.case=Bluetooth|HTTP[S]? |IoT|JSON|Java|Javadoc|JavaScript|XML"/>
		<arg value="-Dargs.validate.color=true"/>
	</exec>
	<!-- For Windows run from a DOS command -->
	<exec dir="${dita.dir}/bin" executable="cmd" osfamily="windows" failonerror="true">
		<arg value="/C"/>
		<arg value="dita -input ${args.input} -output ${dita.dir}/out/svrl -format svrl -Dargs.validate.blacklist=&quot;(kilo)?metre|colour|teh|seperate&quot; -Dargs.validate.check.case=&quot;Bluetooth|HTTP[S]? |IoT|JSON|Java|Javadoc|JavaScript|XML&quot;"/>
	</exec>	
</target>
```


Customizing the Validator
=========================

Adding New Validator Rules
--------------------------

This DITA-OT plug-in contains a common ruleset of general validator rules. The ruleset has been designed to be applicable to all documents created by all users. To add new custom rules (which only apply to your specific use case) you should create a separate custom validator plug-in which extends the base validator. See the sample [Extended DITA Validator](https://github.com/jason-fox/com.here.validate.svrl.overrides) as an example of how to do this.

Altering the severity of a validator rule
-----------------------------------------

The severity of a validator rule can be altered by amending entries in the `cfg/rulesset/default.xml`  file The plug-in supports four severity levels:

* **FATAL** - Fatal rules will fail validation and cannot be overridden.
* **ERROR** - Error rules will fail validation. Errors can be overridden as described above.
* **WARNING** - Warning rules will display a warning on validation, but do not fail the validation. Warnings can also be individually overridden.
* **INACTIVE** - Inactive rules are not applied.


A custom ruleset file can be passed into the plug-in using the `svrl.ruleset.file` parameter


```console
PATH_TO_DITA_OT/bin/dita -f svrl-echo -i document.ditamap -Dsvrl.ruleset.file=PATH_TO_CUSTOM/ruleset.xml
```


Ignoring Validator Rules
------------------------

### Removing validator rules globally

Rules can be made inactive by altering the severity (see above).  Alternatively a rule can be commented out in the XSL.

To completely remove rules which do not apply to your document set, you can create a customized DITA-OT plug-in which extends the base validator. See the [Extended DITA Validator](https://github.com/jason-fox/com.here.validate.svrl.overrides) as an example of how to do this.


### Ignoring a validator rule throughout a document

Individual rules can be ignored by adding the `args.validate.ignore.rules` parameter to the command line. The value of the parameter should be a comma-delimited list of each `rule-id` to ignore.

For example to ignore the `table-id-missing` validation rule within a document you would run:

```console
PATH_TO_DITA_OT/dita -f svrl-echo -i document.ditamap -Dargs.validate.ignore.rules=table-id-missing
```


### Ignoring a specific instance of a validator rule

Specific instances of a rule can be ignored by adding a comment within the `*.dita` file. The comment should start with `ignore-rule`, and needs to be added at the location where the error is flagged.

```xml
...
<table platform="pdfonly" frame="none" >
	<!-- ignore-rule:table-id-missing -->
	<tgroup cols="1">
		<colspec colname="c1" colnum="1" colwidth="336pt"/>
		<tbody>
			<row>
				<entry>&#xA0;</entry>
			</row>
		</tbody>
	</tgroup>
</table>
```

Some rules such as **FIXME** and **TODO** in the running text need to be double escaped as shown below:

 - Add a comment line with the text `ignore-rule:running-text-*` to ignore the issue flagged in the text below (no FIXMEs allowed in the running text)
 - Add the `comment-*` to the list of ignored rules	to ignore the fact that the comment itself fails an additional rule (no FIXMEs allowed in the comments)

```xml
<!--
	We want to display the text below which would usually
	result in a warning
-->
<p>
	<!-- ignore-rule:running-text-fixme,comment-fixme -->
	FIXME is usually banned in the running text.
</p>
```

### Ignoring all warnings within a block

A block of DITA can be excluded from firing all rules at **WARNING** level by adding the comment `ignore-all-warnings` to the block. This is especially useful to avoid false positive TODO warnings for text which is in Spanish.

```xml
<!--
	We want to display the Spanish text below which would usually
	result in a series of warnings for the word TODOS
-->
<section xml:lang="es-es" id="legal-es">
	<!-- ignore-all-warnings -->
	<title>Avisos legales</title>
	<p>
		© 2017 <keyword keyref="brand-name"/> Global B.V. Todos los derechos reservados.
	</p>
	<p>
		Este material, incluidos la documentación y los programas informáticos relacionados, está protegido por derechos de autor controlados
		por <keyword keyref="brand-name"/>. Todos los derechos están reservados. La copia, incluidos la reproducción, almacenamiento,
		adaptación o traducción de una parte o de todo este material requiere el consentimiento por escrito de <keyword keyref="brand-name"/>.
		Este material también contiene información confidencial, que no se puede revelar a otras personas sin el consentimiento previo y
		por escrito de <keyword keyref="brand-name"/>.
	</p>
<section>
```

### Ignoring all errors within a block

A block of DITA can be excluded from firing all rules at **ERROR** level by adding the comment `ignore-all-errors` to the block. This is useful to avoid issues with generated DITA files which are parsable DITA, but which may not satisfy in-house validation style rules.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- THIS TOPIC IS GENERATED -->
<!DOCTYPE topic PUBLIC "-//OASIS//DTD DITA Topic//EN" "topic.dtd">
<topic id="generated-topic" other-props="generated">
	<!-- ignore-all-warnings, ignore-all-errors -->
	<title>Topic title</title>
	<body>
		Generated Content goes here...
	</body>
</topic>
```

Rules set at **FATAL** level cannot be ignored.


Customizing the DITA Fixer
==========================

Adding a new fixable rule
-------------------------

An editable macrofile can be found in `cfg/rulesset/fix-macros.xml`. If a rule can be auto fixed, 
a macro should be added to the file in the following format:

```
<macrodef name="rowsep-invalid">
	<attribute name="file"/>
	<attribute name="path"/>
	<sequential>
		<delete-attribute file="@{file}" path="@{path}" attr="rowsep"/>
	</sequential>
</macrodef>
```
Where the `name` of the macro matches the rule `id`. The `file` attribute supplies name of the
file to be updated and the `path` attribute supplies the XPath to the invalid element.
The DITA file can be updated using [XMLTask](http://www.oopsconsultancy.com/software/xmltask/) 
which has been supplied as a library. The following convenience functions are also available
by default:


* `delete-attribute`
* `delete-element`
* `get-attribute-value`
* `lower-case-attribute`
* `put-attribute-value`
* `replace-with-subelement`

Amending a fixable rule
-----------------------

The default functionality applied to fix a broken rule can be amended by altering the macro.
If a rule is inactive within the ruleset it will not be fixed.  


Sample Document
===============

A sample document can be found within the plug-in which can used to test validator rules. The document covers with positive and negative test cases. The sample document contains "broken" DITA which **cannot** be built as a PDF document - please use the `html` transform to read the contents or examine the `*.dita` files directly.

A complete list of rules covered by the DITA validator can be found below. The final `<chapters>` of the sample document contain a set of test DITA `<topics>`, each demonstrating a broken validation rule.

The `<topic>` files are sorted as follows:

-	 The [base plug-in](https://github.com/jason-fox/com.here.validate.svrl) \(`com.here.validate.svrl`\) – this `<chapter>` contains a set of common validator rules applicable to all users. The rules are grouped thematically according to the name of the associated `<active-pattern>` within the XSL stylesheets of the plug-in and then are listed alphabetically by `rule-id` within the group. The following types of validation rules are supported:
	-	 `style` – Style rules enforce a standardized look and feel across DITA elements and ensure a better SEO and consistency. Alteration or removal of these rules should not affect the ability of DITA-OT to create a valid document.
	-	 `structure` – Structure rules offer an error reporting mechanism against fatal changes which would result in an invalid DITA document. If these rules are altered or removed, errors will not be caught up-front and DITA-OT will not be able to build a valid document. Examples include a `conref` link to a non-existent topic or an attempt to create a `table` containing no `row` elements.
	-	 `content` – These rules check the text within the DITA elements themselves, for example blacklisted words.
-	 The [extended plug-in](https://github.com/jason-fox/com.here.validate.svrl.overrides) \(`com.here.validate.svrl.overrides`\) – This `<chapter>` shows how to modify, relax or remove existing validator rules and create additional custom validator rules. The custom rules are listed alphabetically by `rule-id`.

Note that **extended** rules will only be detected if the `overrides` transform from the [Extended DITA Validator](https://github.com/jason-fox/com.here.validate.svrl.overrides) is used.


Validator Error Messages
========================

The following tables list the validator error messages by type and message ID. Base DITA validator rules are in normal text. Rules in **bold** are examples of custom rules which can be detected if the `overrides` transform from the [Extended DITA Validator](https://github.com/jason-fox/com.here.validate.svrl.overrides) is used.

Content Validation
------------------

|Fix|Message ID|Message|Corrective Action/Comment|
|---|----------|-------|-------------------------|
| :x: |comment-fixme|Found 'FIXME' comments within the <\{name\}\> element - fix as requested and delete the comment.|Replace the draft content with the correct information.|
| :x: |comment-todo|Found 'TODO' within the following text of the <\{name\}\> element - fix as requested and delete the comment.|Replace the draft content with the correct information.|
| :x: |blacklisted-words|Words in the blacklist should not appear in the running text:|Remove the blacklisted words.|
| :x: |incorrect-capitalization|The word '\{word\}' is incorrectly capitalized in the following text:|The indicated word is not capitalized correctly. Fix the capitalization.|
| :x: |running-text-fixme|Found 'FIXME' comments in the following text in this <\{name\}\> element - fix as requested and delete the comment.|Replace the draft content with the correct information.|
| :x: |running-text-lorem-ipsum|Found dummy text in this <\{name\}\> element, remove or replace with valid content.|Replace the standard lorem ipsum filler text with the correct information.|
| :x: |running-text-todo|Found 'TODO' comments in the following text in this <\{name\}\> element - fix as requested and delete the comment.|Replace the draft content with the correct information.|



Style Validation
----------------

|Fix|Message ID|Message|Corrective Action/Comment|
|---|----------|-------|-------------------------|
| :heavy_check_mark: |codeblock-outputclass-missing|Always provide an outputclass attribute in `<codeblock>` elements \(for example, add outputclass="language-javascript"\).|This `outputclass` attribute is used for decorating the HTML output to make code easier to read. If the content in the `<codeblock>` element is JSON use the key value pair `outputclass="language-javascript"`. For more information on the `<codeblock>` element, see [codeblock](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/codeblock.html).|
| :heavy_check_mark: |codeblock-scale-missing|Always provide a scale attribute in `<codeblock>` elements \(for example, add `scale="80"`\).|This `scale` attribute reduces the size of the code text in the output to make it easier to read \(the values are percent\). We recommend you set the scale to 80 percent. For more information on the `<codeblock>` element, see [codeblock](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/codeblock.html).|
| :heavy_check_mark: |conref-not-lower-case|The specification of `conref="..."` is invalid, allowed characters are: lower case, a-z only, words separated by hyphens.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the source file specified in the `conref` attribute references a file with an invalid name. For instance, if you define the `conref` attribute as follows `<p conref="<InvalidFileName>#invalid-file-name/submission-note">` the file name does not comply with the file naming guidelines.	- Only use lower case letters in a file name. - If a file name contains multiple words, use a hyphen to separate them, for example, `overview-map.dita` or `request-map-report.dita`. - The file type \(and file extension\) for all DITA XML files in the repository must be *.dita* or *.ditamap*. - Base the file name on the main topic title. If the title is `Naming Conventions` then the topic `id` should be `naming-conventions` and the file name should be `naming-conventions.dita`. - Do not include arbitrary strings to indicate the contents of the chapter, topic type, etc. - Do not include computer-generated text such as `topic-2` or `GUID-1234-5678-1234`. - Do not use non-standard acronyms, for instance, `border-xing` instead of `border-crossing`.	 |
| :x: |**element-blacklisted**|**The `<name>` element is not compliant with our subset of DITA documentation standards.**|**Custom Rule**: While the DITA open standard supports a large number of elements, the extended validator only supports a subset of these elements in order to make the documents more consistent. Replace the rejected element with a supported element.|
| :heavy_check_mark: |fig-id-invalid|`id` values must start with `'fig-'` in all `<fig>` elements.|In order to assist with search engine optimization \(SEO\) of content, all [figure](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/fig.html) elements must have an `id`.|
| :x: |fig-id-missing|Always provide an `id` value in `<fig>` elements.|In order to assist with search engine optimization \(SEO\) of content, all [figure](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/fig.html) elements must have an `id`.|
| :heavy_check_mark: |file-not-lower-case|Found file `'...'` with invalid name, allowed characters in file names are: lowercase, a-z only, words separated by hyphens.|In order to assist with search engine optimization \(SEO\) of content, file names must be lower case. Fix the name as appropriate.|
| :heavy_check_mark: |href-not-lower-case|The value provided in `href="..."` is invalid, allowed characters are: lowercase, a-z only, words separated by hyphens.|The file specified in the `href` attribute does not comply with the file naming conventions. Fix the name as appropriate.|
| :x: |**id-blacklisted**|**`id` attribute values must not use the word `'content'`. Change the `id` value.**| **Custom Rule**: Some delivery channels used to deliver content to customers may be configured to already use certain `id` values. Change the word content to another `id`. For more information on `id` attributes, see [id](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/id.html).|
| :heavy_check_mark: |id-not-lower-case|The ID value in `id="..."` is invalid, allowed characters are: lowercase, a-z only, words separated by hyphens.|In order to assist with search engine optimization \(SEO\) of content, `id` attributes must comply with the `id` conventions. Fix the name as appropriate.	- Only use lower case letters in a file name. - If a file name contains multiple words, use a hyphen to separate them, for example, `overview-map.dita` or `request-map-report.dita`. - The file type \(and file extension\) for all DITA XML files in the repository must be *.dita* or *.ditamap*. - Base the file name on the main topic title. If the title is `Naming Conventions` then the topic ID should be `naming-conventions` and the file name should be `naming-conventions.dita`. - Do not include arbitrary strings to indicate the contents of the chapter, topic type, etc. - Do not include computer-generated text such as `topic-2` or `GUID-1234-5678-1234`.	For more information on `id` atrributes, see [id](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/id.html).|
| :x: |image-file-type-not-supported|The value provided in `href="..."` specifies an unsupported file format \(only \*.jpg, \*.jpeg or \*.png are allowed\). Change the format of the linked file.|The validator ensures that only \*.jpg, \*.jpeg or \*.png format files are used in online HTML documents. Convert the image format to the correct format.|
| :x: |section-id-missing|Always provide an `id` attribute in `<section>` elements.|In order to assist with search engine optimization \(SEO\), all [section](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/section.html) elements must have an `id`.||table-id-invalid|`id` values must start with 'table-' in `<table>` elements.|If you add an `id` to a table, start the `id` with the word 'table-'. For more information on tables, see [table](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/table.html).|
| :x: |table-id-missing|Always provide an `id` attribute in `<table>` elements.|In order to assist with search engine optimization \(SEO\), add an `id` to `<table>` elements. For more information on tables, see [table](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/table.html).|
| :heavy_check_mark: |topic-file-mismatch|The value specified in id="\{name\}" does not match the file name: \{file\_name\}. Make sure the `id` value and the file name are the same.|In order to assist with search engine optimization \(SEO\) of content, the `id` for `<topic>` elements must be the same as the file name, which also ends up by the name of the HTML file. For more information on topics, see [topic](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/topic.html). For more information on element 'id`s', see [id](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/id.html).|
| :heavy_check_mark: |xref-no-format|Always provide a format attribute in `<xref>` elements, \(for example, format="dita" or format="html"\).|Specify a value for the `format` attribute for `<xref>` elements. Examples of valid values include `dita`, `html`, and `pdf`. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|

Structure Validation
--------------------

|Fix|Message ID|Message|Corrective Action/Comment|
|---|----------|-------|-------------------------|
| :x: |chapter-href-missing|Always provide an href attribute in `<chapter>` elements.|When you add a `<chapter>` element to a `ditamap`, you must specify a `href="{file_name}"` key/value pair that defines the content that appears on the chapter page in the PDF \(and on the chapter landing page in HTML\). Alternatively, you can define the following two attributes: `navtitle="..." lockitle="yes"`. This approach has the effect of adding a title but not content on the chapter page/node. For more information on the `<chapter>` element, see [chapter](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/chapter.html).|
| :x: |coderef-href-ref-file-not-found|The linked source file does not exist. Check the related folder for the missing file and make sure the file name is correct.|The `<coderef>` element is generally used for importing a source file when the validator builds the document. When you get this error, the reference cannot be resolved. Note that DITA does not allow you to reference files outside the root folder of the document. By default, these files should be in the `source` folder under the document root folder. For more information on the `<coderef>` element, see [codeblock](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/codeblock.html).|
| :x: |colspec-colnum-not-unique|The key/value pair `colnum="..."` is not unique. Make sure there are no duplicates.|In order for the validator to render table content properly, these key/value pairs must be unique. For instance, the following codeblock illustrates well-formated DITA that complies with this requirement. `<colspec colnum="1"/><colspec colnum="2"/><colspec colnum="3"/>` For more information on the `<table>` element, see [table](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/table.html).|
| :x: |conref-external-file-not-found|The linked file does not exist. Check the related folder for the missing file and make sure the file name is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the referenced file cannot be resolved. Note that DITA does not allow you to reference files outside the root folder of the document. By default, this kind of content should be in the `includes.dita` file. |
| :x: |conref-external-id-mismatch|The conref source `<{name}>` and the destination `<{name}>` are not the same type. Check to make sure the referenced elements are the same.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the referenced `id` in the source file specified in the `conref` attribute is an `id` for an element that is of a different type than the element with the `conref` attribute. DITA requires that `conref` attributes point at the same kind of element. For instance, `<p conref="includes.dita#includes/submission-note">` needs to reference an element in the `includes.dita` file that is formatted as follows `<p id="submission-note">CONTENT</p>`. |
| :x: |conref-external-id-not-found|The referenced `id` does not exist in the source file. Make sure the ID value specified is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the referenced `id` in the source file specified in the `conref` attribute cannot be resolved. For instance, if you define the `conref` attribute as follows `<p conref="includes.dita#includes/submission-note">` and you get this error, then the `includes.dita` file does not have a `<p>` whose `id` is set to `id="submission-note"`. |
| :x: |conref-external-path-not-found|The referenced path does not exist. Make sure the path is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the source file specified in the `conref` attribute cannot be resolved. For instance, if you define the `conref` attribute as follows `<p conref="includes.dita#includes/submission-note">` and you get this error, then the validator cannot find the `includes.dita` file. Note that DITA does not allow you to reference files outside the root folder of the document. |
| :x: |conref-external-path-mismatch|The conref source <\{name\}\> and the destination <\{name\}\> are not the same type. Make sure the path is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the referenced `id` in the source file specified in the `conref` attribute is an `id` for an element that is of a different type than the element with the `conref` attribute. DITA requires that `conref` attributes point at the same kind of element. For instance, `<p conref="includes.dita#includes/submission-note">` needs to reference an element in the `includes.dita` file that is formatted as follows `<p id="submission-note">CONTENT</p>`. |
| :x: |conref-internal-id-not-found|The referenced `id` does not exist in this file. Make sure the `id` value specified is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the referenced `id` specified in the `conref` attribute cannot be resolved. For instance, if you define the `conref` attribute as follows `<p conref="submission-note">` and you get this error, then the source file does not have a `<p>` whose `id` is set to `id="submission-note"`. |
| :x: |conref-internal-path-mismatch|The conref source <\{name\}\> and the destination <\{name\}\> are not the same type. Make sure the path is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the referenced `id` specified in the `conref` attribute is an ID for an element that is of a different type than the element with the `conref` attribute. DITA requires that `conref` attributes point at the same kind of element. For instance, `<p conref="submission-note">` needs to reference an element that is formatted as follows `<p id="submission-note">CONTENT</p>`. |
| :x: |conref-internal-path-not-found|The referenced path does not exist in this file. Make sure the path is correct.| The `conref` attribute is used for importing documentation segements reused across the document when the validator builds the document. For more information on using the `conref` attribute, see [conref](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/conref.html). When you get this error, the value specified in the `conref` attribute cannot be resolved. For instance, if you define the `conref` attribute as follows `<p conref="<file_name>#submission-note">` and you get this error, then the validator cannot resolve the path. |
| :x: |href-file-not-found|The file specified in `href="..."` does not exist. Check the related folder for the missing file and make sure the file name is correct.|The validator cannot find the file specified in the `href` attribute. Make sure the file is in the indicated path. Note that DITA does not allow you to reference files outside the root folder of the document.|
| :x: |id-not-unique|Found a duplicate ID with value '\{name\}', `id` values must be unique within a file. Change the `id` value.|DITA requires that all `id`s within a file must be unique. Change the `id` value. For more information on `id` attributes, see [id](http://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/id.html).|
| :x: |image-href-ref-file-not-found|The linked image file does not exist. Check the graphics folder for the missing file and make sure the link and file name specified are correct.|The validator cannot find the file specified in the `href` attribute. Check the path to ensure the file is there.|
| :x: |**image-product-filtered-not-included**|**Found `<image product="...">`. This results in an empty `<fig>` for other variants. Add additional `product` attributes for the missing ditaval filters.**|**Custom Rule**: When skinning a document for various customers it is necessary to filter the images used. By placing all images in a single conref'd file it is easier to ensure that all images will be present for all customers. see [ditavals](http://docs.oasis-open.org/dita/v1.2/os/spec/common/about-ditaval.html).|
| :x: |list-all-li-filtered|Found only `<li product="...">` elements in `<ul>`. This results in an empty `<ul>` for other variants. Either add additional `product` attributes for the ditaval filters or add `<ul product="..."\>` to the appropriate list elements.|The specified variant creation attributes result in a variant with a list without list items. Specify an additional variant attribute to ensure the list has items in all variants or remove the list entirely by specifiying the appropriate attributes. For more information on creating variants, see [ditavals](http://docs.oasis-open.org/dita/v1.2/os/spec/common/about-ditaval.html). For information on list items, see [li](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/li.html).|
| :x: |table-all-rows-filtered| Found only `<row product="..."\>` elements in `<tbody\>`.	This results in an empty `<tbody>` for other variants. Either add additional product attributes for the missing variants or add `<table product="..."\>` to the appropriate elements. The specified variant creation attributes result in a variant with a table without rows, which results in a broken PDF build.	| Specify an additional variant attribute to ensure the table has rows in all variants or remove the table entirely by specifiying the appropriate attributes. For more information on creating variants, see [ditavals](http://docs.oasis-open.org/dita/v1.2/os/spec/common/about-ditaval.html). For more information on tables, see [table](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/table.html).|
| :x: |tgroup-cols-colspec-mismatch|The number of \{name\} `<colspec>` elements defined do not match the parent `<tgroup cols="..."\>` attribute. Make sure the number of `<colspec>` elements corresponds with the cols value.|In order to generate PDFs correctly, the number of `<colspec>` elements must match the number in the `<tgroup cols="...">` attribute. For more information on tables, see [table](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/table.html).|
| :x: |tgroup-cols-entry-mismatch|The number of \{name\} `<entry>` elements found do not match the parent `<tgroup cols="..."\>` attribute. Make sure the number of `<entry>` elements corresponds with the cols value.|In order to generate PDFs correctly, the number of `<entry>` elements in a `<row>` element must match the number in the `<tgroup cols="...">` attribute. For more information on tables, see [table](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/table.html).|
| :x: |topicref-href-missing|Always provide an `href` attribute in `<topicref>` elements.|DITA uses the `href` attribute to specify connections between [topicref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/topicref.html) elements and a file. Add an `href` attribute to the element and specify the appropriate value. For more information on `<topicref>` elements, see [topicref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/topicref.html).|
| :x: |xref-external-file-not-found|The file specified in `<xref href="...">` does not exist. Check the related folder for the missing file and make sure the link and file name specified are correct.|When you get this error, the referenced file cannot be resolved. Note that DITA does not allow you to reference files outside the root folder of the document. Make sure the path exists. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
| :x: |xref-external-id-not-found|The referenced `id` in `<xref href="...">` does not exist. Make sure the `id` value specified is correct.|When you get this error, the validator cannot resolve the `id` in the target file. Note that DITA does not allow you to reference files outside the root folder of the document. Make sure the file exists and contains the `id`. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
| :x: |xref-external-path-not-found|The referenced path in `<xref href="...">` does not exist. Make sure the path specified is correct.|When you get this error, the validator cannot resolve the `id` in the target file. Note that DITA does not allow you to reference files outside the root folder of the document. Make sure the file exists and contains the `id`. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
| :x: |xref-internal-id-not-found|The referenced ID in `<xref href="...">` does not exist. Make sure the `id` value specified is correct.|When you get this error, the validator cannot resolve the `id` in the file. Make sure the file contains the `id`. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
| :x: |xref-internal-path-not-found|The referenced path in `<xref href="...">` does not exist. Make sure the path is correct.|When you get this error, the validator cannot resolve the provided path in the file. Make sure the file contains the path. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
| :heavy_check_mark: |xref-www-format-invalid|`<xref href="..." format="dita">` The specified value points to an external file and cannot have the attribute key/value pair format="dita". Change the format value as appropriate \(for example, format="html"\).|Specify a value for the `format` attribute for `<xref>` elements. Examples of valid values include `dita`, `html`, and `pdf`. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|
| :heavy_check_mark: |xref-www-scope-invalid|`<xref href="...">` The specified value points to an external file. Specify the attribute key/value pair scope="external".|The `href` attribute specifies a web page or similar target, which means the `scope` attribute must have the value `external`. Change the value as required. For more information on `<xref>` elements, see [xref](http://docs.oasis-open.org/dita/v1.2/os/spec/langref/xref.html).|

Deprecated Elements
-------------------

According to the [DITA 2.0 proposal to remove deprecated markup](https://lists.oasis-open.org/archives/dita/201803/msg00024.html) certain elements, attributes and values will cease to be supported under 
DITA 2.0. These structure rules are all currently set to **WARNING** level and are auto-fixable.

|Fix|Message ID|Message|Corrective Action/Comment|
|---|----------|-------|-------------------------|
| :heavy_check_mark: |boolean-deprecated|The `<boolean>` element will no longer be supported in DITA 2.0. | Replace the `<boolean>` element with a `<state>` element.| 
| :heavy_check_mark: |chunk-to-navigation-deprecated|`chunk="to-navigation"` is not supported in DITA 2.0.|Delete the attribute| 
| :heavy_check_mark: |image-alt-deprecated|`<image>` elements will no longer support the `alt` attribute in DITA 2.0.|Replace the `alt` attribute with an `<alt>` sub-element.| 
| :heavy_check_mark: |image-longdescref-deprecated|`<image>` elements will no longer support the `longdescref` attribute in DITA 2.0. | Replace the `longdescref` attribute with an `<longdescref>` sub-element.| 
| :heavy_check_mark: |indextermref-deprecated|The `<boolean>` element will no longer be supported in DITA 2.0.|Delete the element|
| :heavy_check_mark: |linklist-collection-type-tree-deprecated|The `<linklist>` element will no longer support `collection-type="tree"` in DITA 2.0.|Replace the value| 
| :heavy_check_mark: |linkpool-collection-type-tree-deprecated|The `<linkpool>` element will no longer support `collection-type="tree"` in DITA 2.0.|Replace the value| 
| :heavy_check_mark: |lq-type-deprecated|The `<lq>` element will no longer support the `type` attribute in DITA 2.0.|Delete the attribute| 
| :heavy_check_mark: |map-title-deprecated|The `<map>` element will no longer support the `title` attribute in DITA 2.0.|Replace the `title` attribute with an `<title>` sub-element.| 
| :heavy_check_mark: |navref-keyref-deprecated|The `<navref>` element will no longer support the `keyref` attribute in DITA 2.0.|Delete the attribute| 
| :heavy_check_mark: |navtitle-deprecated|The `navtitle` attribute will no longer be supported in DITA 2.0.|Replace the `navtitle` attribute with an `<navtitle>` sub-element.| 
| :heavy_check_mark: |print-deprecated|The `print` attribute will no longer be supported in DITA 2.0.|Delete the attribute| 
| :heavy_check_mark: |query-deprecated|The `query` attribute will no longer be supported in DITA 2.0.|Delete the attribute| 
| :heavy_check_mark: |refcols-deprecated|The `refcols` attribute will no longer be supported in DITA 2.0.|Delete the attribute| 
| :heavy_check_mark: |relcolspec-collection-type-deprecated|`<relcolspec>` elements will no longer support the `collection-type` attribute in DITA 2.0.|Delete the attribute| 
| :heavy_check_mark: |reltable-collection-type-deprecated|`<reltable>` elements will no longer support the `collection-type` attribute in DITA 2.0.|Delete the attribute| 
| :heavy_check_mark: |role-external-deprecated|`role="external"` is not supported in DITA 2.0. |Delete the attribute or replace with `scope` and `format`| 
| :heavy_check_mark: |role-sample-deprecated|`role="sample"` is not supported in DITA 2.0.|Delete the attribute.| 
| :heavy_check_mark: |topichead-locktitle-deprecated|`<topichead>` elements will no longer support the `locktitle` attribute in DITA 2.0.|Delete the attribute.| 
| :heavy_check_mark: |topicgroup-locktitle-deprecated|`<topicgroup>` elements will no longer support the `locktitle` attribute in DITA 2.0.|Delete the attribute.|


Contribute
==========

PRs accepted.

License
=======

[Apache 2.0](LICENSE) © 2018 HERE Europe B.V.

See the [LICENSE](LICENSE) file in the root of this project for license details.

The Program includes the following additional software components which were obtained under license:

* Saxon-9.1.0.8.jar - http://saxon.sourceforge.net/  - **Mozilla Public license 1.0**
* Saxon-9.1.0.8-dom.jar - http://saxon.sourceforge.net/  - **Mozilla Public license 1.0**
* xmltask.jar - http://www.oopsconsultancy.com/software/xmltask/ - **Apache 1.1 license**


