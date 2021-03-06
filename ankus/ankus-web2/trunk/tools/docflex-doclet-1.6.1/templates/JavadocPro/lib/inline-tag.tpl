<DOCFLEX_TEMPLATE VER='1.18'>
CREATED='2007-02-23 11:28:41'
LAST_UPDATE='2012-05-24 08:56:33'
DESIGNER_TOOL='DocFlex SDK 1.x'
DESIGNER_LICENSE_TYPE='Filigris Works Team'
APP_ID='docflex-javadoc'
APP_NAME='DocFlex/Javadoc | JavadocPro'
APP_AUTHOR='Copyright © 2004-2012 Filigris Works, Leonid Rudy Softwareprodukte. All rights reserved.'
TEMPLATE_TYPE='DocumentTemplate'
DSM_TYPE_ID='javadoc2'
ROOT_ET='Tag'
<TEMPLATE_PARAMS>
	PARAM={
		param.name='$contextClassId';
		param.description='GOMElement.id of the class for which the current document (or its fragment) is being generated. This is used in processing of {@link} tags.
<p>
Note: This parameter is specified by caller templates to to be auto-passed further to called subtemplates.';
		param.type='Object';
	}
	PARAM={
		param.name='$contextPackageId';
		param.description='GOMElement.id of the package for which (or for whose class) the current document (or its fragment) is being generated.  This is used to shorten the linked program element\'s qualified name according to the context where it is mentioned.
<p>
Note: This parameter is specified by caller templates to to be auto-passed further to called subtemplates.';
		param.type='Object';
	}
</TEMPLATE_PARAMS>
<STYLES>
	CHAR_STYLE={
		style.name='Code';
		style.id='cs1';
		text.font.name='Courier New';
		text.font.size='9';
	}
	CHAR_STYLE={
		style.name='Default Paragraph Font';
		style.id='cs2';
		style.default='true';
	}
	CHAR_STYLE={
		style.name='Hyperlink';
		style.id='cs3';
		text.decor.underline='true';
		text.color.foreground='#0000FF';
	}
	PAR_STYLE={
		style.name='Normal';
		style.id='s1';
		style.default='true';
	}
</STYLES>
FMT={
	doc.lengthUnits='pt';
	doc.default.font='Arial';
	doc.hlink.style.link='cs3';
}
<ROOT>
	<FOLDER>
		DESCR='{@link} / {@linkplain}'
		MATCHING_ET='SeeTag'
		BREAK_PARENT_BLOCK='when-executed'
		COLLAPSED
		<BODY>
			<TEMPLATE_CALL>
				DESCR='case of {@link} tag; "Code" character style is set in "Formatting | Text" tab'
				COND='getAttrValue("name") == "@link"'
				BREAK_PARENT_BLOCK='when-executed'
				TEMPLATE_FILE='see-link.tpl'
				FMT={
					text.style='cs1';
				}
			</TEMPLATE_CALL>
			<TEMPLATE_CALL>
				DESCR='otherwise, {@linkplain} tag; no special style is set'
				TEMPLATE_FILE='see-link.tpl'
			</TEMPLATE_CALL>
		</BODY>
	</FOLDER>
	<AREA_SEC>
		DESCR='{@literal}'
		COND='getAttrValue("kind") == "@literal"'
		BREAK_PARENT_BLOCK='when-executed'
		COLLAPSED
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<DATA_CTRL>
						FORMULA='encodeXMLChars (getAttrStringValue("text"))'
					</DATA_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<AREA_SEC>
		DESCR='{@code}'
		COND='getAttrValue("kind") == "@code"'
		BREAK_PARENT_BLOCK='when-executed'
		COLLAPSED
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<DATA_CTRL>
						FORMULA='encodeXMLChars (getAttrStringValue("text"))'
						FMT={
							text.style='cs1';
						}
					</DATA_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<AREA_SEC>
		DESCR='{@docRoot}'
		COND='getAttrValue("kind") == "@docRoot"'
		BREAK_PARENT_BLOCK='when-executed'
		COLLAPSED
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<DATA_CTRL>
						DESCR='According to Javadoc spec, the {@docRoot} tag should be replaced with the relative path to the root directory of the whole documentation from the currently generated page.

Basically, the {@docRoot} tag is used to reference to some custom files (e.g. images) that should be added to the generated output.

DocFlex/Javadoc may generate three kinds of output:

(1)  the framed multi-file HTML
(2)  the single-file HTML
(3)  the single-file RTF

Depending on each kind of output, there may be three different ways of processing of {@docRoot} tags.

1. In the case of framed multi-file HTML, the documentation generated by DocFlex is organized the same as the one generated by the Standard Javadoc Doclet. It is exactly the situation, for which the {@docRoot} is originally supposed.

In that case, every separate HTML file not located in the root directory is always associated with a certain package (e.g. the HTML file describing a class lays in the subdirectory associated with the class\' package). So, the replacement for {@docRoot} tag can be  produced from the number of dots (\'.\') in the package name. For example, in an HTML file generated by the class javax.swing.text.Document, the {@docRoot} value will be: "../../.." (the number of slashes must be equal to the number of dots in the package name).

When the file is located in the documentation root directory itself, it is not associated with any package (if only with the default package, whose name is an empty string). For such a file, {@docRoot} should be replaced with "." (the empty string will be wrong because in that case, the prefix "{@docRoot}/" would point not to the documentation root but rather to the root of the http server).

2. In case of single-file HTML output, each {@docRoot} tag should be replaced with "." string. The reference produced in the output HTML will always lead to the right location.

3. In the case of single-file RTF output, unlike HTML, any added custom files (namely, images) are processed directly by the generator itself (not just the correct references to the images should be placed in the generated output).

That means, the generator should access the custom input files just in time of the generation of the particular piece of output. To do so, the generator uses the value stored in the Input Files Search Path property (see \'output.inputFilesPath\' and GOMOutputInfo.inputFilesPath) as the base directory against which any relative pathnames of the input files are resolved. 

In the templates (for instance, in PlainDoc.tpl), that property is dynamically assigned with the pathname of the source directory of each Java class (or package) being processed (the directory pathname is obtained from \'SourcePosition/@fileDir\' attribute). 

According to this, for instance, an image inserted in the class comments using <IMG SRC="doc-files/image.gif"> tag and prepared in the "doc-files" subdir of the class\' package director will be successfully found by the generator, processed and inserted in the generated RTF output. So, the generator behaves like an instant HTML browser. 

From this follows that each {@docRoot} tag should be processed the same way as in the case of the framed HTML. However, the base package should be obtained from the tag\'s holder program element (in which comments it is used). This will ensure the correct processing of the referenced image file even when the comments are inherited by another program element (e.g. overriding method).'
						FORMULA='refElement = (output.format.name == "RTF") 
             ? getElementByLinkAttr ("holder") 
             : documentContext.rootElement;

package = refElement.instanceOf ("ProgramElementDoc")
          ? refElement.getElementByLinkAttr("containingPackage")
          : refElement.instanceOf ("PackageDoc") ? refElement : null;

(packageName = package.getAttrStringValue("name")) != "" ? 
{
  docRoot = "..";

  iterateChars (
    packageName,
    @c,
    FlexQuery ({
      (c == ".") ? { docRoot = "../" + docRoot }
    })
  );

  docRoot
} : "."'
					</DATA_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<AREA_SEC>
		DESCR='{@value}'
		COND='getAttrValue("kind") == "@value"'
		BREAK_PARENT_BLOCK='when-executed'
		COLLAPSED
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<DATA_CTRL>
						CONTEXT_ELEMENT_EXPR='(nameSpec = getAttrStringValue("text")) != ""
  ? findProgramElement (nameSpec)
  : getElementByLinkAttr ("holder")'
						MATCHING_ET='FieldDoc'
						ATTR='constantValueExpression'
						FMT={
							text.style='cs1';
						}
						<DOC_HLINK>
							HKEYS={
								'contextElement.id';
								'"detail"';
							}
						</DOC_HLINK>
					</DATA_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
	<AREA_SEC>
		DESCR='unknown inline tag -- reproduce it as is'
		COND='getAttrValue("kind") != "@inheritDoc"'
		COLLAPSED
		<AREA>
			<CTRL_GROUP>
				<CTRLS>
					<TEXT_CTRL>
						TEXT='{'
					</TEXT_CTRL>
					<DATA_CTRL>
						ATTR='name'
					</DATA_CTRL>
					<DELIMITER>
					</DELIMITER>
					<DATA_CTRL>
						ATTR='text'
						FMT={
							ctrl.option.text.noBlankOutput='true';
						}
					</DATA_CTRL>
					<DELIMITER>
						FMT={
							txtfl.delimiter.type='none';
						}
					</DELIMITER>
					<TEXT_CTRL>
						TEXT='}'
					</TEXT_CTRL>
				</CTRLS>
			</CTRL_GROUP>
		</AREA>
	</AREA_SEC>
</ROOT>
CHECKSUM='bA6tkOZzVdth0pjxScNhhAZ33fYv+NwXHNkjTyrJGnM'
</DOCFLEX_TEMPLATE>