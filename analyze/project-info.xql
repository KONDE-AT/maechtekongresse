xquery version "3.1";
declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";
declare namespace pkg="http://expath.org/ns/pkg";
import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/config" at "modules/config.xqm";
declare option exist:serialize "method=json media-type=text/javascript content-type=application/json";

let $title := doc(concat($config:app-root, "/expath-pkg.xml"))//pkg:title/text()
let $description := doc(concat($config:app-root, "/repo.xml"))//repo:description/text()
let $authors := normalize-space(string-join(doc(concat($config:app-root, "/repo.xml"))//repo:author//text(), ', '))
let $map := map{
    "title": $title,
    "subtitle": "Digitale Edition der Dokumente zu den Kongressen von Aachen (1818), Troppau (1820), Laibach (1821) und Verona (1822)",
    "author": $authors,
    "description": $description,
    "github": "https://github.com/KONDE-AT/kongress",
    "purpose_de": "Ziel von kongress ist die Publikation von Forschungsdaten.",
    "purpose_en": "The purpose of kongress is the publication of research data.",
    "app_type": "digital-edition",
    "base_tech": "eXist-db",
    "framework": "Digital Scholarly Editions Base Application"
}
return 
        $map