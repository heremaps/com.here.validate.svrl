var Markdown={};
Markdown.errors = {
	'text-before-header': {
		text: 'Text was found before the first header',
		role: 'warning'
	},
	'headers-not-found': {
		text: 'No Headers found in file',
		role: 'error'
	},
	'header-depth-invalid': {
		text: 'Header depth invalid - expected %1 but was %2',
		role: 'error'
	},
	'header-depth-too-deep': {
		text: 'Header depth too deep - level %1 is not allowed in MDITA',
		role: 'error'
	}
}

Markdown.analyseMarkup = function(markup) {

	var codeblock= false;
	var headers =[];
	var xrefs =[];
	var output =[];
	var lines = markup.split('\n');
	var count = 0;
	var regex = /\[.*\]\(.*\)/;

	headerLevel = function (string){
		var level = 0;
		while (level < string.length() ){
			if (string.charAt(level) != '#'){
				break;
			}
			level++;
		}
		return level;
	}

	for (var i = 0; i < lines.length; i++){
		if (lines[i].startsWith('```')){
			codeblock = (!codeblock);
		} else if (!codeblock) {
			if (lines[i].startsWith('#')){
			   	headers.push({
			   		line: i,
			   		text: lines[i],
			   		depth: headerLevel(lines[i]),
			   		expectedDepth: i > 0 ? headerLevel(lines[i]) : 1,
			   		parent: 0
			   	});

			   	var current = headers.length - 1;
			   	for (j = current ; j > 0; j--){
					if (headers[j].depth < headers[current].depth){
						headers[current].parent = j;
						break;
					}
				}
			} else if (regex.test(lines[i])){

				var x = lines[i].split('](');
				for (j = 1; j < x.length; j = j +2){
					var href =  x[j].split(')')[0];
					xrefs.push({href: href, external: href.contains(':')});
				}
			}
		} 
	}

	for (var i = 1; i < headers.length; i++){
		if (headers[i].expectedDepth > headers[headers[i].parent].expectedDepth){
			headers[i].expectedDepth = headers[headers[i].parent].expectedDepth + 1;
		}
	}

	return {headers: headers, xrefs: xrefs};
}


Markdown.validateMarkup = function (file, headers, type){

	getErrorText = function(diagnostic, arg1, arg2){
		return Markdown.errors[diagnostic].text.replace('%1', arg1).replace('%2', arg2);
	};

	getRole = function(diagnostic){
		return Markdown.errors[diagnostic].role;
	};

	failedAssert = function(diagnostic, line, element, arg1, arg2){
		svrl = svrl + '\t<failed-assert role="'+ getRole(diagnostic) +'" location="/">\n';
		svrl = svrl + '\t\t<diagnostic-reference diagnostic="'+ diagnostic + '">';
		svrl = svrl + 'Line ' + line + ': '+ element +' - ['+ diagnostic + ']\n';
		svrl = svrl + getErrorText(diagnostic, arg1, arg2);
		svrl = svrl + '\t\t</diagnostic-reference>\n';
		svrl = svrl + '\t</failed-assert>\n';
	};


	var svrl = '<?xml version="1.0" encoding="utf-8" standalone="yes"?>\n' +
			'<schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl">\n' +
			'\t<active-pattern role="'+ type + '" name="/' + file + '"/>\n' +
			'\t<fired-rule context="common" role="structure"/>\n';

	if (headers.length === 0) {
		failedAssert('headers-not-found', 1, 'p');
	} else if (headers[0].line > 0) {
		failedAssert('text-before-header', 1, 'p');
	} 

	if (type ==='markdown'){
		for (var i = 0; i < headers.length; i++){
			if (headers[i].depth !== headers[i].expectedDepth){
				failedAssert('header-depth-invalid', headers[i].line,
					'h'+ headers[i].depth, headers[i].expectedDepth, headers[i].depth);
			} 
		}

	} else if (type==='mdita'){
		for (var i = 0; i < headers.length; i++){
			if (headers[i].expectedDepth > 2){
				failedAssert('header-depth-too-deep', headers[i].line,
					'h'+ headers[i].depth, headers[i].depth);
			} else if (headers[i].depth !== headers[i].expectedDepth){
				failedAssert('header-depth-invalid', headers[i].line,
				 	'h'+ headers[i].depth,headers[i].expectedDepth, headers[i].depth);
			} 
		}
	}

	svrl = svrl + '</schematron-output>\n';
	return svrl;
}

Markdown.writeSVRL = function(file, svrl, outputDir){

	var task = project.createTask("echo"); 
	task.setFile(new java.io.File(outputDir +'/' + file.substring(0,file.lastIndexOf(".")) + '.svrl')); 
	task.setMessage(svrl);
	task.perform();
}

Markdown.writeMarkup = function(file, markup, outputDir){

	var task = project.createTask("echo"); 
	task.setFile(new java.io.File(outputDir +'/' + file)); 
	task.setMessage(markup);
	task.perform();
}



Markdown.fixMarkup = function (markup, headers, type){

	correctMDITA = function (header){
		switch (header.expectedDepth){
	 		case 1:
	 			return '#' + header.text.substring(header.depth);
	 		case 2:
	 			return '##' + header.text.substring(header.depth);
	 		default:
	 			return '**' + header.text.substring(header.depth).trim() + '**';
	 	}
	};

	correctMarkdown = function (header){
		switch (header.expectedDepth){
	 		case 1:
	 			return '#' + header.text.substring(header.depth);
	 		case 2:
	 			return '##' + header.text.substring(header.depth);
	 		case 3:
	 			return '###' + header.text.substring(header.depth);
	 		case 4:
	 			return '####' + header.text.substring(header.depth);
	 		case 5:
	 			return '#####' + header.text.substring(header.depth);
	 		case 6:
	 			return '######' + header.text.substring(header.depth);
	 	}
	};

	var count = 0;
	var lines = markup.split('\n');
	var output = [];

	for (var i = 0; i < lines.length; i++){
		 if (count < headers.length && lines[i].equals(headers[count].text)){
		 	if (type ==='markdown'){
		 		lines[i] = correctMarkdown(headers[count]);
		 	} else if (type ==='mdita'){
		 		lines[i] = correctMDITA(headers[count])
		 	}
		 	count++;
		 } 
		 if (count > 0) {
		 	output.push(lines[i]); 
		 }
	}

	return output.join('\n');
}




