xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace app="http://www.digital-archiv.at/ns/kongress/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/kongress/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

(: This script adds @prev and @next attributes to tei:TEI nodes.
 : The values for theses attributes are fetched from the current tei:TEI node 
 : in it's collection
:)

let $archeURL := "https://id.acdh.oeaw.ac.at/"
let $projectURL := 'maechtekongresse/'
let $dataURL := 'editions'
let $idURL := $archeURL||$projectURL||$dataURL


let $all := collection($app:editions)//tei:TEI
(:let $all := subsequence($all, 1, 5):)
for $x in $all
    let $collectionName := util:collection-name($x)
    let $currentDocName := util:document-name($x)
    let $xmlPath := $app:editions||'/'||$currentDocName
    let $next := app:next-doc($xmlPath)
    let $prev := app:prev-doc($xmlPath)
    let $base := update insert attribute xml:base {$idURL} into $x
    let $currentID := update insert attribute xml:id {$currentDocName} into $x
    let $prev_ins := if($prev)
        then
            update insert attribute prev {string-join(($idURL, $prev), '/')} into $x 
        else
            ()
    let $next_ins := if($next)
        then
            update insert attribute next {string-join(($idURL, $next), '/')}into $x 
        else
            ()
    return
        <group for="{$currentDocName}">
            <prev>{$prev}</prev>
            <next>{$next}</next>
        </group>