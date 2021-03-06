xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";


(: 'denormalizes' indeces by fetching index entries
 : and writing them in tei:back element:)

(:BE AWARE! Already exisitng back elements will be deleted :)

for $x in collection($app:editions)//tei:TEI
    let $removeBack := update delete $x//tei:back
    let $persons := data($x//tei:*/@ref)
    let $persons := string-join($persons, ' ')
    let $persons := distinct-values(tokenize($persons, ' '))
    
    let $listperson :=
    <listPerson xmlns="http://www.tei-c.org/ns/1.0">
        {
        for $y in $persons
            let $node := doc($app:personIndex)//tei:body//id(substring-after($y, '#'))
                where $y != "#KS"
                return $node
        }
    </listPerson>

    let $listplace :=
    <listPlace xmlns="http://www.tei-c.org/ns/1.0">
       {
        for $y in $persons
            let $node := doc($app:placeIndex)//tei:body//id(substring-after($y, '#'))
                return $node
        }
    </listPlace>
    
    let $listbible :=
    <listBibl xmlns="http://www.tei-c.org/ns/1.0">
       {
        for $y in $persons
            let $node := doc($app:treatiesIndex)//tei:body//id(substring-after($y, '#'))
                return $node
        }
    </listBibl>
    
    let $listwit :=
    <listWit xmlns="http://www.tei-c.org/ns/1.0">
       {
        for $y in $persons
            let $node := doc($app:listWittnes)//tei:body//id(substring-after($y, '#'))
                return $node
        }
    </listWit>
    
    let $listorg :=
    <listOrg xmlns="http://www.tei-c.org/ns/1.0">
       {
        for $y in $persons
            let $node := doc($app:orgIndex)//tei:body//id(substring-after($y, '#'))
                return $node
        }
    </listOrg>
    
    
   
    let $listperson := if ($listperson/tei:person) then $listperson else ()
    let $listplace := if ($listplace/tei:place) then $listplace else ()
    let $listbible := if ($listbible/tei:bibl) then $listbible else ()
    let $listwit := if ($listwit/tei:bibl) then $listwit else ()
    let $listorg := if ($listorg/tei:bibl) then $listorg else ()

    let $back := 
    <back xmlns="http://www.tei-c.org/ns/1.0">
        {$listperson}
        {$listplace}
        {$listbible}
        {$listwit}
        {$listorg}
    </back>
    
    let $update := update insert $back into $x/tei:text
    
    return "done"