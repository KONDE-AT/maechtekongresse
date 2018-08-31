xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/kongress/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/kongress/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";

let $data := <data>{
    for $x at $pos in collection($app:editions)//tei:msDesc[(.//@when[1] castable as xs:date)][1]
    let $sender := string-join($x//tei:correspAction[@type='sent']/tei:persName/text(), ' ')
    let $backlink := concat(app:hrefToDoc($x),'&amp;directory=editions')
    let $doctitle := if (contains($x//root()//tei:fileDesc/tei:titleStmt/tei:title[@type='main'][1], 'Protokoll der '))
        then string-join($x//root()//tei:fileDesc/tei:titleStmt/substring-after(tei:title[@type='main'][1], 'Protokoll der '), ' ')
        else concat('', string-join($x//root()//tei:fileDesc/tei:titleStmt/tei:title[@type='main'], ' '))
    let $content := $doctitle
    let $date := data($x//@when[1])
    let $year := year-from-date(xs:date($date))
    let $month := month-from-date(xs:date($date))
    let $day := day-from-date(xs:date($date))
    return 
        <item>
            <event_id>{$pos}</event_id>
            <sender>{$sender}</sender>
            <content>{$content}</content>
            <doctitle>{$doctitle}</doctitle>
            <backlink>{$backlink}</backlink>
            <start>{data($x//@when[1])}</start>
            <date>({$year},{$month},{$day})</date>
            <showdate>{$day}.{$month}.{$year}</showdate>
        </item>
}</data>

return $data