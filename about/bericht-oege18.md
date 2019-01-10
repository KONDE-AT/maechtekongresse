---
title: Digitale Edition der Dokumente der Mächtekongresse 1818–1822
author:
- Karin Schneider
- Stephan Kurz
institute: Institut für Neuzeit- und Zeitgeschichtsforschung an der Österreichischen Akademie der Wissenschaften
lang: de-DE
documentclass: scrartcl
classoption: headings=small
classoption: 12pt
header-includes:
    - \usepackage[babel,german=quotes]{csquotes}
    - \usepackage{fourier}
    - \usepackage[a4paper,nohead,total={13.9cm,25.2cm}]{geometry}
    - \setcounter{tocdepth}{1}
    - \usepackage{hyperref}
    - \let\Contentsline\contentsline
    - \renewcommand\contentsline[3]{\Contentsline{#1}{#2}{}}
    - \hypersetup{unicode=true,colorlinks=false,hypertexnames=false}
    - \usepackage{tocloft}
    - \setlength{\cftbeforesecskip}{.4ex}
    - \renewcommand{\cftsecfont}{\normalfont}
    - \renewcommand{\cfttoctitlefont}{\normalfont}
    - \setkomafont{disposition}{\normalcolor\sffamily}
---

\include{hyphenation-sk}


# Digitale Edition der Dokumente der Mächtekongresse 1818–1822

Aus den Beständen des Österreichischen Staatsarchivs

Mehrere FWF-Projekte

Kooperation mit Staatsarchiv, ÖAW-ACDH,

## Über die Dokumente

## Transkription

TEI Elemente beschreiben

Bis zu drei Apparate sind im Seitenfuß dargestellt: Der editorische Fußnotenapparat zählt mit arabischen Ziffern (1, 2, 3, …). Anmerkungen aus den edierten Texten, die im Original vorhanden sind, werden in einem separaten Apparat mit alphabetischer Zählung (a, b, c, …) verzeichnet. Ein dritter Apparat betrifft die Varianten, die im Lesetext lediglich durch graue Schrift angezeigt werden.

Die Transkripte lagen zum Zeitpunkt des Beginns an der Entwicklung der Applikation weitgehend fertig vor und wurden im Zuge der Arbeit an der Darstellung vereinheitlicht, korrigiert und tw. verfeinert.

## Interfaces und Zugangsweisen

Zwei Besonderheiten zeichnen die Digitale Edition über die mit TEI standardisierte Textdarstellung hinaus aus: Einerseits ist hervorzuheben, dass die Dokumente zu den Kongressen von Aachen, Troppau, Laibach und Verona, wo überhaupt, so bislang nur in einzelnen Stücken für die Forschung zugänglich war – diesem Desiderat wäre allerdings auch mithilfe einer traditionellen papiergebundenen Edition beizukommen gewesen.

Andererseits eröffnet die Digitale Edition neue Zugangsweisen zu den Dokumenten:

Grundlegend sind die Dokumente nach den Orten ihrer Entstehung sortiert – das Inhaltsverzeichnis der digitalen Edition ordnet entsprechend und macht die Dokumente, die Bestandsbeschreibungen sowie die Regesten nach den zentralen Orten der diplomatischen Zusammenkünfte; innerhalb dieser Ordnung wird nach Folgenummern der Dokumente und damit chronologisch sortiert.

Gleich auf der Startseite der Editionsdarstellung ist darüber hinaus auch eine räumliche Darstellung beigegeben, die die Dokumente auch in ihren europäischen Zusammenhang der Mächte in der nachnapoleonischen Landkarte setzt.^[Diese Karte wurde basierend auf einer frei lizenzierten Karte „Europa 1820“ von Andreas Kunz, Wolf Röss und Joachim Robert Möschl (<https://www.ieg-maps.uni-mainz.de/mapsp/mappEu820Serie2.htm>) von Stephan Kurz erstellt und liegt illustrativ auch im Hintergrund der Seitendarstellung.]

Zwei verschiedene chronologische Zugänge greifen die `@when`-Attribute aus den `teiHeader`-Elementen zur Datierung der Verträge und Dokumente heraus und stellen sie dar: Kalender und Zeitleiste. Während der Kalender ein rasches Erfassen der Wochentage der einzelnen Sitzungen ermöglicht, führt die Zeitleiste den Gesamtzusammenhang aus der zeitlichen Perspektive vor.

Die relativ tiefe Erschließung der Personen- und Ortsnamen (erwähnt sind auch zwei Institutionen) in den edierten Dateien ermöglicht auch den Zugriff über automatisch aus den Editionsdaten erstellte Register. Das Ortsregister ist mit Geodaten angereichert, sodass eine Kartendarstellung auch eine räumliche Einordnung erlaubt, die mit heutigem Kartenmaterial unterlegt ist. Die Personendaten dagegen enthalten auch Verweise auf die Normdaten aus dem Virtual International Authority File (VIAF), um Personen zu disambiguieren und zugleich die Verbindung zwischen der Edition und den genannten Personen publizieren zu können (u.a. über eine Beacon-Datei und über JSON-Autocompletes).^[Die API-Spezifikationen sind selbsterklärend.]

Regesten zu den einzelnen Dokumenten erschließen die Texte inhaltlich, sie sind wie die Dokumente sowohl nach den Orten der Kongresse als auch in der Gesamtschau geordnet abrufbar.

Konzeptionell gegenüber der semantischen Erschließung steht die Volltextsuche an der Textoberfläche, die über Apache Lucene implementiert ist; das Suchergebnis lässt sich in der Datatables-Anzeige zusätzlich einschränken und wird sofort nach dem Eintippen gefiltert.

## Technische Plattform

Durch die Beteiligung des ÖAW-ACDH (und auch des INZ) am HRSM-Projekt *Kompetenznetzwerk Digitale Edition (KONDE)* fiel auf der Suche nach einer technischen Lösung für den Präsentationslayer zu den bereits weitgehend in getaggter und „fertig“ edierter Form vorliegenden Dokumente die Wahl auf eine Umsetzung als Applikation für `eXist-db` (eine java-basierte XML-Serverlösung). Im Zusammenhang mit KONDE wurde aufbauend auf den Blogposts von Peter Andorfer zur Verwendung der `dsebaseapp` (dse = digital scholarly edition), die ihrerseits ihre Herkunft aus einer Briefedition nicht verleugnen kann, mit der Umsetzung begonnen.

Die Verwendung von eXist-db als Plattform ist an sich nicht konkurrenzlos. Für den relativ geringen Umfang von 115 der Edition zugehörigen XML-Dateien – und zentral auch der Anforderung, dass es zu keinen zusätzlichen Kosten kommen dürfe – war zum Zeitpunkt der Entscheidung für eine Softwarelösung keine Alternativlösung zu finden. Mit der Bereitstellung der `dsebaseapp` und der Kooperationsbereitschaft des ÖAW-ACDH, die die Bereitschaft mit einschloss, die Applikation auch über Server des ACDH zu hosten und dabei auch die Langzeitarchivierungslösung ARCHE (A Resource Centre for the HumanitiEs) mitnutzen zu können,^[https://www.oeaw.ac.at/acdh/tools/arche/, Fedora Commons-basiert] waren die Rahmenbedingungen im Gesamtpaket letztlich alternativlos.

Die oben erwähnten Zugänge der Erschließung der einmal edierten Dokumente verdanken sich zu großen Teilen den Vorarbeiten aus KONDE, und zwar insbesondere den Vorarbeiten aus der generischen `dsebaseapp` – und damit den programmiererischen Fähigkeiten von Peter Andorfer vom ÖAW-ACDH.

Seit September 2018 ist die Digitale Edition online erreichbar unter <https://maechtekongresse.acdh.oeaw.ac.at/>. Wir hoffen damit einen Beitrag zur quellentreuen geschichtswissenschaftlichen Erschließung der europäischen Großwetterlage in der Umbruchphase der politischen Neuordnung nach dem Wiener Kongress geleistet zu haben.

## Als Postscriptum: Bekannte Desiderate

- Die Quellennachweise in den Literaturverzeichnissen (`listBibl` in `listtreaties.xml` und `listWit` in `listwit.xml`) sind in der aktuellen Fassung flach gehalten und damit nicht ernsthaft maschinenlesbar.
- In der Darstellung der XML-Daten sind Leerzeichen in `mixed content`-Elementen, die sowohl Kindelemente als auch Text enthalten, nicht konsequent gesetzt; das folgt aus dem erratischen Whitespace-Handling von eXist-db beim Installieren von Paketen. Nachdem die autoritative Fassung der Edition aber jedenfalls in den TEI-Daten besteht und der Präsentationslayer lediglich die verschiedenen Zugänge legt, konnte entschieden werden, auf dieses Manko lediglich hinzuweisen.
- Weiters in Arbeit ist eine Darstellung der Beziehungen zwischen den teilnehmenden Personen und den Kongressen bzw. deren einzelnen Sitzungen als GEFX-Netzwerk; eine solche wird den chronotopischen Zusammenhang zwischen Personen und Dokumenten leichter auf einen Blick erfassbar machen.
- Die angekündigte Veröffentlichung nicht nur der Editionsdaten, sondern auch des Applikationscodes auf GitHub steht ebenso noch aus wie die in Vorbereitung befindliche Archivierung der Editionsdaten im ARCHE-Repositorium; diese sind für die nächsten Monate geplant.

Über weitere Rückmeldungen zur Edition sind die Autorin und der Autor des vorliegenden Beitrags dankbar.
