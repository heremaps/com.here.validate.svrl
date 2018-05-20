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
