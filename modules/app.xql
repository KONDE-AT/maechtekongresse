xquery version "3.0";
module namespace app="http://www.digital-archiv.at/ns/kongress/templates";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace functx = 'http://www.functx.com';
import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://www.digital-archiv.at/ns/kongress/config" at "config.xqm";
import module namespace kwic = "http://exist-db.org/xquery/kwic" at "resource:org/exist/xquery/lib/kwic.xql";
import module namespace console = "http://exist-db.org/xquery/console";
import module namespace r = "http://joewiz.org/ns/xquery/roman-numerals" at "roman-numerals.xqm";

declare variable  $app:data := $config:app-root||'/data';
declare variable  $app:editions := $config:app-root||'/data/editions';
declare variable  $app:indices := $config:app-root||'/data/indices';
declare variable $app:placeIndex := $config:app-root||'/data/indices/listplace.xml';
declare variable $app:personIndex := $config:app-root||'/data/indices/listperson.xml';
declare variable $app:orgIndex := $config:app-root||'/data/indices/listorg.xml';
declare variable $app:workIndex := $config:app-root||'/data/indices/listwork.xml';
declare variable $app:treatiesIndex := $config:app-root||'/data/indices/listtreaties.xml';
declare variable $app:listWittnes := $config:app-root||'/data/indices/listwit.xml';
declare variable $app:defaultXsl := doc($config:app-root||'/resources/xslt/xmlToHtml.xsl');

declare function functx:contains-case-insensitive
  ( $arg as xs:string? ,
    $substring as xs:string )  as xs:boolean? {

   contains(upper-case($arg), upper-case($substring))
 } ;

 declare function functx:escape-for-regex
  ( $arg as xs:string? )  as xs:string {

   replace($arg,
           '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
 } ;

declare function functx:substring-after-last
  ( $arg as xs:string? ,
    $delim as xs:string )  as xs:string {
    replace ($arg,concat('^.*',$delim),'')
 };

 declare function functx:substring-before-last
  ( $arg as xs:string? ,
    $delim as xs:string )  as xs:string {

   if (matches($arg, functx:escape-for-regex($delim)))
   then replace($arg,
            concat('^(.*)', functx:escape-for-regex($delim),'.*'),
            '$1')
   else ''
 } ;

 declare function functx:capitalize-first
  ( $arg as xs:string? )  as xs:string? {

   concat(upper-case(substring($arg,1,1)),
             substring($arg,2))
 } ;

declare function app:fetchEntity($ref as xs:string){
    let $entity := collection($config:app-root||'/data/indices')//*[@xml:id=$ref]
    let $type: = if (contains(node-name($entity), 'place')) then 'place'
        else if  (contains(node-name($entity), 'person')) then 'person'
        else 'unkown'
    let $viewName := if($type eq 'place') then(string-join($entity/tei:placeName[1]//text(), ', '))
        else if ($type eq 'person' and exists($entity/tei:persName/tei:forename)) then string-join(($entity/tei:persName/tei:surname/text(), $entity/tei:persName/tei:forename/text()), ', ')
        else if ($type eq 'person') then $entity/tei:placeName/tei:surname/text()
        else 'no name'
    let $viewName := normalize-space($viewName)

    return
        ($viewName, $type, $entity)
};

declare function local:everything2string($entity as node()){
    let $texts := normalize-space(string-join($entity//text(), ' '))
    return
        $texts
};

declare function local:viewName($entity as node()){
    let $name := node-name($entity)
    return
        $name
};


(:~
: returns the name of the document of the node passed to this function.
:)
declare function app:getDocName($node as node()){
let $name := functx:substring-after-last(document-uri(root($node)), '/')
    return $name
};


(:~
: returns the (relativ) name of the collection the passed in node is located at.
:)
declare function app:getColName($node as node()){
let $root := tokenize(document-uri(root($node)), '/')
    let $dirIndex := count($root)-1
    return $root[$dirIndex]
};



(:~
: renders the name element of the passed in entity node as a link to entity's info-modal.
:)
declare function app:nameOfIndexEntry($node as node(), $model as map (*)){

    let $searchkey := xs:string(request:get-parameter("searchkey", "No search key provided"))
    let $withHash:= '#'||$searchkey
    let $entities := collection($app:editions)//tei:TEI//*[@ref=$withHash]
    let $terms := (collection($app:editions)//tei:TEI[.//tei:term[./text() eq substring-after($withHash, '#')]])
    let $noOfterms := count(($entities, $terms))
    let $hit := collection($app:indices)//*[@xml:id=$searchkey]
    let $name := if (contains(node-name($hit[1]), 'person'))
        then
            <a class="reference" data-type="listperson.xml" data-key="{$searchkey}">{normalize-space(string-join($hit/tei:persName[1], ', '))}</a>
        else if (contains(node-name($hit[1]), 'place'))
        then
            <a class="reference" data-type="listplace.xml" data-key="{$searchkey}">{normalize-space(string-join($hit/tei:placeName[1], ', '))}</a>
        else if (contains(node-name($hit[1]), 'org'))
        then
            <a class="reference" data-type="listorg.xml" data-key="{$searchkey}">{normalize-space(string-join($hit/tei:orgName[1], ', '))}</a>
        else if (contains(node-name($hit[1]), 'bibl'))
        then
            <a class="reference" data-type="listwork.xml" data-key="{$searchkey}">{normalize-space(string-join($hit/tei:title[1], ', '))}</a>
        else if (contains(node-name($hit[1]), 'treaties'))
        then
            <a class="reference" data-type="listtreaties.xml" data-key="{$searchkey}">{normalize-space(string-join($hit/tei:bibl[1], ', '))}</a>
        else
            functx:capitalize-first($searchkey)
    return
    <h1 style="text-align:center;">
        <small>
            <span id="hitcount"/>{$noOfterms} Treffer für</small>
        <br/>
        <strong>
            {$name}
        </strong>
    </h1>
};

(:~
 : href to document.
 :)
declare function app:hrefToDoc($node as node()){
let $name := functx:substring-after-last($node, '/')
let $href := concat('show.html','?document=', app:getDocName($node))
    return $href
};

(:~
 : href to document.
 :)
declare function app:hrefToDoc($node as node(), $collection as xs:string){
let $name := functx:substring-after-last($node, '/')
let $href := concat('show.html','?document=', app:getDocName($node), '&amp;directory=', $collection)
    return $href
};

(:~
 : a fulltext-search function
 :)
 declare function app:ft_search($node as node(), $model as map (*)) {
 if (request:get-parameter("searchexpr", "") !="") then
 let $searchterm as xs:string:= request:get-parameter("searchexpr", "")
 for $hit in collection(concat($config:app-root, '/data/editions/'))//*[.//tei:p[ft:query(.,$searchterm)]|.//tei:cell[ft:query(.,$searchterm)]]
    let $href := concat(app:hrefToDoc($hit), "&amp;searchexpr=", $searchterm)
    let $score as xs:float := ft:score($hit)
    order by $score descending
    return
    <tr>
        <td>{$score}</td>
        <td class="KWIC">{kwic:summarize($hit, <config width="40" link="{$href}" />)}</td>
        <td>{app:getDocName($hit)}</td>
    </tr>
 else
    <div>Kein Suchausdruck angegeben</div>
 };

declare function app:indexSearch_hits($node as node(), $model as map(*),  $searchkey as xs:string?, $path as xs:string?){
let $indexSerachKey := $searchkey
let $searchkey:= '#'||$searchkey
let $entities := collection($app:data)//tei:TEI[.//*/@ref=$searchkey]
let $terms := collection($app:editions)//tei:TEI[.//tei:term[./text() eq substring-after($searchkey, '#')]]
for $title in ($entities, $terms)
    let $docTitle := string-join(root($title)//tei:titleStmt/tei:title[@type='main']//text(), ' ')
    let $hits := if (count(root($title)//*[@ref=$searchkey]) = 0) then 1 else count(root($title)//*[@ref=$searchkey])
    let $collection := app:getColName($title)
    let $snippet :=
        for $entity in root($title)//*[@ref=$searchkey]
                let $before := $entity/preceding::text()[1]
                let $after := $entity/following::text()[1]
                return
                    <p>… {$before} <strong><a href="{concat(app:hrefToDoc($title, $collection), "&amp;searchkey=", $indexSerachKey)}"> {$entity//text()[not(ancestor::tei:abbr)]}</a></strong> {$after}…<br/></p>
    let $zitat := $title//tei:msIdentifier
    let $collection := app:getColName($title)
    return
            <tr>
               <td>{$docTitle}</td>
               <td>{$hits}</td>
               <td>{$snippet}<p style="text-align:right">{<a href="{concat(app:hrefToDoc($title, $collection), "&amp;searchkey=", $indexSerachKey)}">{app:getDocName($title)}</a>}</p></td>
            </tr>
};

(:~
 : creates a basic person-index derived from the  '/data/indices/listperson.xml'
 :)
declare function app:listPers($node as node(), $model as map(*)) {
    let $hitHtml := "hits.html?searchkey="
    for $person in doc($app:personIndex)//tei:listPerson/tei:person
    let $gnd := $person/tei:idno/text()
    let $gnd_link := if ($gnd != "no gnd provided") then
        <a href="{$gnd}">{$gnd}</a>
        else
        "-"
        return
    let $notiz := $person/tei:note/text()    
    let $notizlink := if ($notiz != '') then "Notiz" else ""
        return    
        <tr>
            <td>
                <a href="{concat($hitHtml,data($person/@xml:id))}">{$person/tei:persName/tei:surname}</a>
            </td>
            <td>
                <a href="{concat($hitHtml,data($person/@xml:id))}">{$person/tei:persName/tei:forename}</a>
            </td>
            <td><a href="{concat($hitHtml,data($person/@xml:id))}">{$person/tei:persName/tei:roleName}</a></td>
            <td>{$person/tei:birth}–{$person/tei:death}</td>
            <td><a href="{concat($hitHtml,data($person/@xml:id))}" title="{$notiz}">{$notizlink}</a></td>
            <td>
                {$gnd_link}
            </td>
        </tr>
};

(:~
 : creates a basic place-index derived from the  '/data/indices/listplace.xml'
 :)
declare function app:listPlace($node as node(), $model as map(*)) {
    let $hitHtml := "hits.html?searchkey="
    for $place in doc($app:placeIndex)//tei:listPlace/tei:place
    let $lat := tokenize($place//tei:geo/text(), ' ')[1]
    let $lng := tokenize($place//tei:geo/text(), ' ')[2]
        return
        <tr>
            <td>
                <a href="{concat($hitHtml, data($place/@xml:id))}">{functx:capitalize-first($place/tei:placeName[1])}</a>
            </td>
            <td>{for $altName in $place//tei:placeName return <p>{$altName/text()}</p>}</td>
            <td>{$place//tei:idno/text()}</td>
            <td>{$lat}</td>
            <td>{$lng}</td>
        </tr>
};


(:~
 : creates a basic table of contents derived from the documents stored in '/data/editions'
 :)
declare function app:toc($node as node(), $model as map(*)) {
    
    let $filterstring := (request:get-parameter("filterstring", ""))
    let $collection := request:get-parameter("collection", "")
    let $docs := if ($collection)
            then
                collection(concat($config:app-root, '/data/', $collection, '/'))//tei:TEI
            else
                collection(concat($config:app-root, '/data/editions/'))//tei:TEI
    for $title in $docs
        let $idno := $title//tei:publicationStmt/tei:idno[1]//translate(text(),'_',' ')
        let $datum := if ($title//tei:msDesc[1]//tei:origin[1]/tei:date[1]/@when)
            then data($title//tei:msDesc[1]//tei:origin[1]/tei:date[1]/@when)(:/format-date(xs:date(@when), '[D02].[M02].[Y0001]')):)
            else if (data($title//tei:msDesc[1]//tei:origin[1]/tei:date[1]))
            then data($title//tei:msDesc[1]//tei:origin[1]/tei:date[1])
            else data($title//tei:editionStmt/tei:edition/tei:date[1]/text()) (: picks date in meta collection :)
        let $date := if ($title//tei:title[2][@type='main']//text()) 
            then 
                concat($title//tei:title[1][@type='main']//text(), ' – ',  $title//tei:title[2][@type='main']//text())
            else if ($title//tei:title[1][@type='main']//text())
                then
                    $title//tei:title[1][@type='main']//text()
            else
                $title//tei:title//text()
                
        let $texts := for $x in $title//tei:msDesc[position()>1]//tei:title
                    (: where count($title//tei:msDesc[position()>1]//tei:title) > 1 :)
                    return
                        <span>{$x/text()}<br/></span>
        where if ($filterstring) then starts-with($idno, $filterstring) else $title
        return  
        <tr>
            <td>{$idno}</td>
            <td>
                <a href="{app:hrefToDoc($title, $collection)}">{$date}</a></td>
            <td>{$texts}</td>
            <td>{$datum}</td>
        </tr>
};

(:~
 : perfoms an XSLT transformation
:)
declare function app:XMLtoHTML ($node as node(), $model as map (*), $query as xs:string?) {
let $ref := xs:string(request:get-parameter("document", ""))
let $refname := substring-before($ref, '.xml')
let $xmlPath := concat(xs:string(request:get-parameter("directory", "editions")), '/')
let $xmlFullPath := replace(concat($config:app-root,'/data/', $xmlPath, $ref), '/exist/', '/db/')
let $xml := doc($xmlFullPath)
let $collection := functx:substring-after-last(util:collection-name($xml), '/')
let $xslPath := xs:string(request:get-parameter("stylesheet", ""))
let $xsl := if($xslPath eq "")
    then
        if(doc($config:app-root||'/resources/xslt/'||$collection||'.xsl'))
            then
                doc($config:app-root||'/resources/xslt/'||$collection||'.xsl')
        else if(doc($config:app-root||'/resources/xslt/'||$refname||'.xsl'))
            then
                doc($config:app-root||'/resources/xslt/'||$refname||'.xsl')
        else
            $app:defaultXsl
    else
        if(doc($config:app-root||'/resources/xslt/'||$xslPath||'.xsl'))
            then
                doc($config:app-root||'/resources/xslt/'||$xslPath||'.xsl')
            else
                $app:defaultXsl
let $path2source := string-join(('../../../../exist/restxq', $config:app-name, $collection, $ref, 'xml'), '/')
let $prev-doc := if ($collection = 'editions') then app:prev-doc(base-uri($xml)) else ()
let $next-doc := if ($collection = 'editions') then app:next-doc(base-uri($xml)) else ()
let $params :=
<parameters>
    <param name="app-name" value="{$config:app-name}"/>
    <param name="app-title" value="{$config:app-title}"/>
    <param name="collection-name" value="{$collection}"/>
    <param name="prev-doc-name" value="{$prev-doc}"/>
    <param name="next-doc-name" value="{$next-doc}"/>
    <param name="path2source" value="{$path2source}"/>
    <param name="xmlFullPath" value="{$xmlFullPath}"/>
    <param name="base-url" value="{request:get-header('X-Forwarded-Host')}"/>
    <param name="ref" value="{$ref}"/>
   {
        for $p in request:get-parameter-names()
            let $val := request:get-parameter($p,())
                return
                   <param name="{$p}"  value="{$val}"/>
   }
</parameters>
return
    transform:transform($xml, $xsl, $params)
};


(:~
 : perfoms an XSLT transformation for the indices (persons etc)
:)
declare function app:XMLtoHTMLindices ($node as node(), $model as map (*), $query as xs:string?) {
let $ref := xs:string(request:get-parameter("document", ""))
let $xmlPath := concat(xs:string(request:get-parameter("directory", "editions")), '/')
(: let $xml := doc(replace(concat($config:app-root,'/data/', $xmlPath, $ref), '/exist/', '/db/')) :)
let $entityID := xs:string(request:get-parameter("entityID", ""))
let $xml := collection($config:app-root||'/data/indices')//*[@xml:id=$entityID]
let $xslPath := concat(xs:string(request:get-parameter("stylesheet", "xmlToHtml")), '.xsl')
let $xsl := doc(replace(concat($config:app-root,'/resources/xslt/', $xslPath), '/exist/', '/db/'))
let $collection := functx:substring-after-last(util:collection-name($xml), '/')
let $path2source := string-join(('../../../../exist/restxq', $config:app-name, $collection, $ref, 'xml'), '/')
let $params :=
<parameters>
    <param name="app-name" value="{$config:app-name}"/>
    <param name="collection-name" value="{$collection}"/>
    <param name="path2source" value="{$path2source}"/>
   {for $p in request:get-parameter-names()
    let $val := request:get-parameter($p,())
   (: where  not($p = ("document","directory","stylesheet")):)
    return
       <param name="{$p}"  value="{$val}"/>
   }
</parameters>
return
    transform:transform($xml, $xsl, $params)
};

(:~
 : creates a basic treaty-index derived from the  '/data/indices/listtreaties.xml'
 :)
declare function app:listTreaties($node as node(), $model as map(*)) {
    let $hitHtml := "hits.html?searchkey="
    for $item in doc($app:treatiesIndex)//tei:listBibl//tei:bibl
       return
            <tr>
                <td>{$item}</td>
            </tr>
};


(:~
 : creates a basic wittnes-index derived from the  '/data/indices/listwit.xml'
 :)
declare function app:listBibl($node as node(), $model as map(*)) {
    let $hitHtml := "hits.html?searchkey="
    for $item in doc($app:listWittnes)//tei:listWit//tei:witness
    let $biblTxt := $item/tei:bibl
    let $witId := $item/string(@xml:id)
       return
            <tr>
                <td>
                    {$witId}
                </td>
                <td>{$biblTxt}</td>
            </tr>
};


(:~
 : creates a basic work-index derived from the  '/data/indices/listbibl.xml'
 :)
declare function app:listBibl2($node as node(), $model as map(*)) {
    let $hitHtml := "hits.html?searchkey="
    for $item in doc($app:workIndex)//tei:listBibl/tei:bibl
    let $author := normalize-space(string-join($item/tei:author//text(), ' '))
    let $gnd := $item//tei:idno/text()
    let $ext := $item//ref[1]/string(@target)
    let $ext_link := if ($ext) 
        then
            <a href="{$ext}">{$ext}</a>
        else
            'keine Normdaten angegeben'
   return
        <tr>
            <td>
                <a href="{concat($hitHtml,data($item/@xml:id))}">{$item//text()}</a>
            </td>
            <td>
                {$author}
            </td>
            <td>
                {$ext_link}
            </td>
        </tr>
};

(:~
 : creates a basic organisation-index derived from the  '/data/indices/listorg.xml'
 :)
declare function app:listOrg($node as node(), $model as map(*)) {
    let $hitHtml := "hits.html?searchkey="
    for $item in doc($app:orgIndex)//tei:listOrg/tei:org
    let $altnames := normalize-space(string-join($item//tei:orgName[@type='alt'], ' '))
    let $gnd := $item//tei:idno/text()
    let $gnd_link := if ($gnd) 
        then
            <a href="{$gnd}">{$gnd}</a>
        else
            'keine Normdaten angegeben'
   return
        <tr>
            <td>
                <a href="{concat($hitHtml,data($item/@xml:id))}">{$item//tei:orgName[1]/text()}</a>
            </td>
            <td>
                {$altnames}
            </td>
            <td>
                {$gnd_link}
            </td>
        </tr>
};

(:
Read out all abstracts regesten
:)
declare function app:listAbstract($node as node(), $model as map(*)) {
let $filterstring := (request:get-parameter("filterstring", ""))
    let $collection := (request:get-parameter("collection", "editions"))
    let $docs := if ($collection)
            then
                collection(concat($config:app-root, '/data/', $collection, '/'))//tei:TEI
            else
                collection(concat($config:app-root, '/data/editions/'))//tei:TEI
    for $title in $docs
        let $idno := $title//tei:publicationStmt/tei:idno//translate(text(),'_',' ')
        let $docTitle := string-join(root($title)//tei:titleStmt/tei:title[@type='main']//text(), ' ')
        let $datum := if ($title//tei:msDesc[1]//tei:origin[1]/tei:date[1]/@when)
            then data($title//tei:msDesc[1]//tei:origin[1]/tei:date[1]/@when)(:/format-date(xs:date(@when), '[D02].[M02].[Y0001]')):)
            else data($title//tei:editionStmt/tei:edition/tei:date[1]/text()) (: picks date in meta collection :)
        let $date := for $x in $title//tei:abstract
                    return
                        <p>{$x//text()}</p> 
        return  
        <tr>
            <td>{$idno}</td>
            <td>{$date}<p style="text-align:right"><a href="{app:hrefToDoc($title, $collection)}">{$docTitle}</a></p></td>
            <td><a href="{app:hrefToDoc($title, $collection)}">{$datum}</a></td>
        </tr>
};

(:~
 : creates paging 
 :)
declare function app:Pagination($doc as node(), $fileIndex as node(), $sourceFile as xs:string) {

    let $first := concat($fileIndex/tei:item[1]/@source, '.html')
    let $last := concat($fileIndex/tei:item[last()]/@source, '.html')
    let $previous := 
        if ($sourceFile ne $first) then 
            concat($doc/preceding-sibling::*[1]/@source, '.html')
        else $first
    let $next := 
        if ($sourceFile ne $last) then 
            concat($doc/following-sibling::*[1]/@source, '.html')
        else $last
    let $pagination := 
        <list xmlns="http://www.tei-c.org/ns/1.0">
            <item type="first" source="{$first}"/>
            <item type="previous" source="{$previous}"/>
            <item type="next" source="{$next}"/>
            <item type="last" source="{$last}"/>
        </list>

    return $pagination
};


declare %private function app:related-docs($xmlPath as xs:string) {
    let $doc-name := util:document-name($xmlPath)
    let $doc-name-filter := substring-before($doc-name,'_')
    return
        for $doc in xmldb:get-child-resources(functx:substring-before-last($xmlPath, "/"))
        let $o1 := tokenize($doc,"_")[2][not(.=('Prot','Dok'))],   
            $o2 := replace(tokenize($doc,"_")[3],"\.xml","")
        where starts-with($doc, $doc-name-filter)
        order by if ($o1) then r:roman-numeral-to-integer($o1) else 0, xs:integer($o2) ascending
        return $doc
};

(:~
 : returns the name of the next document  
 :)
declare function app:next-doc($xmlPath as xs:string) {
    let $doc-name := util:document-name($xmlPath)
    let $r := app:related-docs($xmlPath)
    let $i := index-of($r, $doc-name)
    return if (count($r) gt $i) then $r[$i + 1] else () 
};


(:~
 : returns the name of the previous document  
 :)
declare function app:prev-doc($xmlPath as xs:string) {
    let $doc-name := util:document-name($xmlPath)
    let $r := app:related-docs($xmlPath)
    let $i := index-of($r, $doc-name)
    return if ($i gt 1) then $r[$i - 1] else ()  
};