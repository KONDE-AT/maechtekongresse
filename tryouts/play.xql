xquery version "3.0";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
import module namespace functx = "http://www.functx.com";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/kongress/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/kongress/templates" at "../modules/app.xql";

let $hansi := doc($app:treatiesIndex)
    return
        $hansi