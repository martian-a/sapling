<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	type="tcy:clean"
	version="2.0">
	
	
	<p:documentation>
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Deletes a directory and all it's contents.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
	<p:documentation>
		<d:doc>
			<d:desc>A URL to the directory to be deleted.</d:desc>
			<d:note>
				<d:p>For example: file:///project/dist/www/</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:option name="href" required="true" />
	
	<p:output port="result" primary="true" />
	
	<p:import href="recursive_delete_directory.xpl"/>

	<!-- Ensure that the directory exists before
		 attempting to delete any prexisting results
		 otherwise, if it doesn't exist, the pipeline 
		 fails.-->
	<!-- TODO: find a better way to test whether the 
		 directory exists and if it doesn't, simply 
		 skip delete step.-->
	<cxf:mkdir>
		<p:with-option name="href" select="$href" />
	</cxf:mkdir>

	<tcy:recursive-delete-directory name="delete">
		<p:with-option name="href" select="$href" />
	</tcy:recursive-delete-directory>
			

	<p:wrap-sequence wrapper="c:deleted">
		<p:input port="source" select="c:results/*">
			<p:pipe port="result" step="delete" />
		</p:input>
	</p:wrap-sequence>
	
	
</p:declare-step>