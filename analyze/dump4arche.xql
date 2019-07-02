xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/kongress/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/kongress/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace acdh="https://vocabs.acdh.oeaw.ac.at/schema#";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace util = "http://exist-db.org/xquery/util";

declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=no indent=yes";

let $about := doc($app:data||'/project.rdf')/rdf:RDF
let $topCollection := $about//acdh:Collection[not(acdh:isPartOf)]
let $childCollections := $about//acdh:Collection[acdh:isPartOf]
let $customResources := $about//acdh:Resource
let $personURL := "https://id.acdh.oeaw.ac.at/maechtekongresse/persons/"
let $placeURL := "https://id.acdh.oeaw.ac.at/maechtekongresse/place/"

let $license := <acdh:hasLicense rdf:resource="https://creativecommons.org/licenses/by-sa/4.0/"/>
let $current_date := current-date()

let $childCollections_av_dates := for $x in $childCollections
    let $col_id := $x/@rdf:about
    return
        <acdh:Collection rdf:about="{$col_id}">
            <acdh:hasAvailableDate>{$current_date}</acdh:hasAvailableDate>
            {$license}
            <acdh:hasContact>
                <acdh:Person rdf:about="http://d-nb.info/gnd/136442196"/>
            </acdh:hasContact>
            <acdh:hasMetadataCreator>
                <acdh:Person rdf:about="http://d-nb.info/gnd/13281899X"/>
            </acdh:hasMetadataCreator>
            <acdh:hasCurator>
                <acdh:Person rdf:about="http://d-nb.info/gnd/13281899X"/>
            </acdh:hasCurator>
            <acdh:hasDepositor>
                <acdh:Person rdf:about="http://d-nb.info/gnd/13281899X"/>
            </acdh:hasDepositor>
            <acdh:hasOwner>
                <acdh:Person rdf:about="http://d-nb.info/gnd/136442196"/>
            </acdh:hasOwner>
            <acdh:hasRightsholder>
                <acdh:Person rdf:about="http://d-nb.info/gnd/136442196"/>
            </acdh:hasRightsholder>
            <acdh:hasLicensor>
                <acdh:Person rdf:about="http://d-nb.info/gnd/136442196"/>
            </acdh:hasLicensor>
        </acdh:Collection>

let $avail_date := 
    <acdh:hasAvailableDate>{$current_date}</acdh:hasAvailableDate>

let $col_avail_date :=
    <acdh:Collection rdf:about="https://id.acdh.oeaw.ac.at/maechtekongresse">
        {$avail_date}
        {$license}
    </acdh:Collection>


let $baseID := 'https://id.acdh.oeaw.ac.at/'
let $RDF := 
    <rdf:RDF
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/schema#"
        xmlns:acdhi="https://id.acdh.oeaw.ac.at/"
        xmlns:foaf="http://xmlns.com/foaf/spec/#"
        xml:base="https://id.acdh.oeaw.ac.at/">
            {$topCollection}
            {$childCollections}
            {$col_avail_date}
            {$childCollections_av_dates}
            {
            for $x in $childCollections
                let $collID := data($x/@rdf:about)
                let $collName := tokenize($collID, '/')[last()]
                let $collection-uri := $app:data||'/'||$collName
                let $document-names := xmldb:get-child-resources($collection-uri)
                let $sample := $document-names
                for $doc in $sample
(:                for $doc in subsequence($sample, 1, 3):)
                let $resID := string-join(($collection-uri, $doc), '/')
                let $node := try {
                        doc($resID)
                    } catch * {
                        false()
                    }
                let $title := try {
                        <acdh:hasTitle xml:lang="de">{normalize-space(string-join($node//tei:titleStmt//tei:title//text()[not(parent::*:note)], ' '))}</acdh:hasTitle>
                    } catch * {
                        <acdh:hasTitle>{$doc}</acdh:hasTitle>
                    }
               
               let $startDate := if($collName = "editions" and data($node//tei:origin[1]/tei:date/@when)[1] castable as xs:date) then 
                    <acdh:hasCoverageStartDate>{data($node//tei:origin[1]/tei:date/@when)[1]}</acdh:hasCoverageStartDate>
                    else ()
               let $endDate := if($collName = "editions" and data($node//tei:origin[last()]/tei:date/@when)[last()] castable as xs:date) then 
                    <acdh:hasCoverageEndDate>{data($node//tei:origin[last()]/tei:date/@when)[last()]}</acdh:hasCoverageEndDate>
                    else ()

               let $description := if ($node//tei:abstract//text()) then
                    <acdh:hasDescription xml:lang="de">{normalize-space(string-join($node//tei:abstract//text()))}</acdh:hasDescription>
                    else ()
               let $persons := if($collName = 'editions') then
                    for $per in $node//tei:listPerson//tei:person[@xml:id]
                         let $pername := normalize-space(string-join($per//tei:persName[1]//text(), ' '))
                         let $firstname := $per//tei:forename[1]/text()
                         let $perID := $personURL||data($per/@xml:id)
                         return
                             <acdh:hasActor>
                                 <acdh:Person rdf:about="{$perID}">
                                     <acdh:hasLastName>{$pername}</acdh:hasLastName>
                                     <acdh:hasFirstName>{$firstname}</acdh:hasFirstName>
                                     {for $id in $per//tei:idno
                                        return <acdh:hasIdentifier rdf:resource="{$id/text()}"/>
                                     }
                                 </acdh:Person>
                             </acdh:hasActor>
                    else ()
                let $places := if($collName = 'editions') then
                    for $item in $node//tei:listPlace//tei:place[@xml:id]
                         let $placename := normalize-space(string-join($item//tei:placeName[1]/text(), ' '))
                         let $itemID := $placeURL||data($item/@xml:id)
                         return
                             <acdh:hasSpatialCoverage>
                                 <acdh:Place rdf:about="{$itemID}">
                                     <acdh:hasTitle>{$placename}</acdh:hasTitle>
                                     {for $id in $item//tei:idno
                                        return <acdh:hasIdentifier rdf:resource="{$id/text()}"/>
                                     }
                                 </acdh:Place>
                             </acdh:hasSpatialCoverage>
                    else ()
                let $orgs := if($collName = 'editions') then
                    for $item in $node//tei:listOrg//tei:org
                         let $itemname := $item//tei:orgName[1]/text()
                         let $itemID := $item//tei:idno[1]
                         return
                             <acdh:hasActor>
                                 <acdh:Organisation rdf:about="{$itemID}">
                                     <acdh:hasTitle>{$itemname}</acdh:hasTitle>
                                 </acdh:Organisation>
                             </acdh:hasActor>
                    else ()
                
                let $next :=
                    if(exists($node/tei:TEI/@prev)) then
                        <acdh:continues rdf:resource="{data($node/tei:TEI/@prev)}"/>
                    else
                        ()
                
                let $prev :=
                    if(exists($node/tei:TEI/@next)) then
                        <acdh:isContinuedBy rdf:resource="{data($node/tei:TEI/@next)}"/>
                    else
                        ()
                
                let $pid_str := $node//tei:publicationStmt//tei:idno[@type="handle"]/text()
                    
                let $pid := if ($pid_str != "")
                    then
                        <acdh:hasPid rdf:about="{$pid_str}"/>
                    else
                        ()
                let $author := 
                        if($collName = "editions") then 
                            <acdh:authors>
                                 <acdh:hasCreator>
                                     <acdh:Person rdf:about="http://d-nb.info/gnd/136442196"/>
                                 </acdh:hasCreator>
                                 <acdh:hasContributor>
                                    <acdh:Person rdf:about="http://d-nb.info/gnd/13281899X"/>
                                </acdh:hasContributor>
                            </acdh:authors>  
                          else if($collName = 'meta' and $title='Zur technischen Umsetzung') then
                          <acdh:authors>
                            <acdh:hasCreator>
                                <acdh:Person rdf:about="http://d-nb.info/gnd/13281899X"/>
                            </acdh:hasCreator>
                          </acdh:authors>
                          else if($collName = 'meta') then
                         <acdh:authors>
                            <acdh:hasCreator>
                                <acdh:Person rdf:about="http://d-nb.info/gnd/136442196"/>
                            </acdh:hasCreator>
                            <acdh:hasContributor>
                                <acdh:Person rdf:about="http://d-nb.info/gnd/13281899X"/>
                            </acdh:hasContributor>
                          </acdh:authors>
                           else if($collName = 'indices') then
                         <acdh:authors>
                            <acdh:hasCreator>
                                <acdh:Person rdf:about="http://d-nb.info/gnd/13281899X"/>
                            </acdh:hasCreator>
                            <acdh:hasContributor>
                                <acdh:Person rdf:about="http://d-nb.info/gnd/136442196"/>
                            </acdh:hasContributor>
                          </acdh:authors>
                          else
                            <acdh:authors>
                            <acdh:hasCreator>
                                <acdh:Person rdf:about="http://d-nb.info/gnd/13281899X"/>
                            </acdh:hasCreator>
                            <acdh:hasCreator>
                                <acdh:Person rdf:about="http://d-nb.info/gnd/1043833846"/>
                            </acdh:hasCreator>
                        </acdh:authors>
                        
                where $collName != 'utils'        
                return 
                    <acdh:Resource rdf:about="{string-join(($collID, $doc), '/')}">
                         <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/dataset"/>
                         {$title}
                         {$pid}
                         {$startDate}
                         {$endDate}
                         {$description}
                         {$persons}
                         {$places}
                         {$orgs}
                         {$avail_date}
                         {for $x in $author//acdh:hasCreator return $x}
                         {for $x in $author//acdh:hasContributor return $x}
                         {$prev}
                         {$next}
                         <acdh:hasDissService rdf:resource="https://id.acdh.oeaw.ac.at/dissemination/customTEI2HTML"/>
                         <acdh:hasCustomXSL rdf:resource="https://id.acdh.oeaw.ac.at/maechtekongresse/utils/tei2html.xsl"/>
                         <acdh:hasSchema>https://www.tei-c.org/release/xml/tei/schema/relaxng/tei.rng</acdh:hasSchema>
                         <acdh:hasLicense rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
                         <acdh:isPartOf rdf:resource="{$collID}"/>
                         <acdh:hasMetadataCreator>
                             <acdh:Person rdf:about="http://d-nb.info/gnd/13281899X"/>
                         </acdh:hasMetadataCreator>
                         <acdh:hasCurator>
                             <acdh:Person rdf:about="http://d-nb.info/gnd/13281899X"/>
                         </acdh:hasCurator>
                         <acdh:hasCurator>
                             <acdh:Person rdf:about="http://d-nb.info/gnd/1043833846"/>
                         </acdh:hasCurator>
                         <acdh:hasDepositor>
                             <acdh:Person rdf:about="http://d-nb.info/gnd/13281899X"/>
                         </acdh:hasDepositor>
                         <acdh:hasOwner>
                             <acdh:Person rdf:about="http://d-nb.info/gnd/136442196"/>
                         </acdh:hasOwner>
                         <acdh:hasRightsholder>
                             <acdh:Person rdf:about="http://d-nb.info/gnd/136442196"/>
                         </acdh:hasRightsholder>
                         <acdh:hasLicensor>
                             <acdh:Person rdf:about="http://d-nb.info/gnd/136442196"/>
                         </acdh:hasLicensor>
                     </acdh:Resource>
        }
        {$customResources}

    </rdf:RDF>
    
return
    $RDF