---
title: Digital Edition on the Documents of the Powers’ Congresses 1818–1822
author:
- Karin Schneider
- Stephan Kurz
institute: Institute for Modern and Contemporary Historical Research at the Austrian Academy of Sciences
lang: en-GB
documentclass: scrartcl
classoption: headings=small
classoption: 12pt
header-includes:
    - \usepackage[babel,quotes]{csquotes}
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


# Digital Edition on the Documents of the Powers’ Congresses 1818–1822

*Karin Schneider, Stephan Kurz (Institute for Modern and Contemporary Historical Research at the Austrian Academy of Sciences)*

# The documents

The paper trails of the Congresses of Aix-la-Chapelle (1818), Troppau (1820), Laibach (1821) and Verona (1822) are kept in the Austrian state archives, and they have been transcribed in a series of FWF funded projects by Karin Schneider. This ensures easier access to the results of those congresses, sparing the original papers the hardship of being used – and offering a host of new pathways to access them.

The digital edition licences all the edition data under Creative Commons (CC-BY 4.0) licence, contributing to the digitally available research output of the Austrian Academy of Sciences, and adding to the resources available on early 19th century European history in the context of what has been dubbed the "Concert of Europe".

# HERE GOES KARIN'S PART

to me mentioned:

FWF funded projects

cooperation partners: Austrian State Archives, ÖAW-ACDH

TEI training by the ÖAW-ACDH (Daniel Schopper)

# Transcriptions in XML

Following widespread good practice of digital scholarly editing, the transcriptions were prepared using the XML schema proposed by the Text Encoding Initiative (TEI P5).^[In fact, some documents had been transcribed using standard MS Word text processing, and then converted to TEI XML using the OxGarage tool <http://oxgarage.tei-c.org/>.] Given that in almost all cases there are only singular archival records available as source materials, this is an adequate solution that did not require too much of additional manual markup effort.^[For a different approach concerning a similar textual genre, but different textual source situation, cf. the representation of the records of the Constitutional Convention of 1787 that remodels textual events with a relational database, using the Quill Project (<https://www.quillproject.net/quill>). In this case, the negotiations underlying a collaboratively edited text like the US federal constitution are represented as different types of events that result in different states of textual snippets at a given point time.]

From the perspective of editorial scholarship, the 'Mächtekongresse' edition does follow the guidelines and good practices of standard necessary to produce accurate textual representation of the documents.

In order to achieve this, a subset of the TEI namespace had to be used.^[In particular, this refers to the following TEI modules: `header`, `linking`, `core`, `textstructure`, `namesdates`, `transcr`, `textcrit`, `figures` and `msdescription`.]

In this short overview, we cannot go into detail on the elements used, but we point out that the TEI files are readily available for download both from the individual document’s metadata header block and through RestXQ.

The most frequent textual phenomena encountered in the edition files include: contemporary additions and deletions, changes of scribes, recordings of paper damage and additions and supplements by the editor. To add to the functionality of the resulting web application and root linked data deep into the edition’s fabrics, references to named entities such as persons, places and institutions have been added as well. The edition currently distinguishes between directly mentioned `[pers|org|place]Name`s and references to the meant entity (e.g. `persName` is used if a part of a person’s proper name is mentioned, whereas a reference to the same person without explicit naming is encoded as `rs type="person"`).^[Note on `country`: Only `place`s are recorded in the `listPlace` index, historical country names are not geo-referenced, but still marked up using the `country` tag.]

Up to three scientific apparatus are displayed throughout the edition documents: The editorial apparatus including commentary and notes on context is being counted numerically (1, 2, 3, …). As soon as notes are present in the source documents, those are distinguished by alphabetical indexes (a, b, c, …). A third apparatus, indicated by lowercase roman numbering, is shown in cases where longer phrases have been transcribed as textual variants.

When we started to develop and adopt the viewer application, the transcripts were already in an almost publishable form, but had to be corrected (markup- and language-wise) and harmonised with respect to some XML elements.

# Interfaces as access paths to historical documents

Two arguments justify the edition – the first aiming for general accessibility of sound transcripts of the Congresses’ respective paper trails (which could have been tackled by a 'traditional' paper-based edition as well), the second expanding that to online accessibility without the need to physically move to either the archives or a library holding a paper edition.

Yet there’s an even more powerful addition that the digital form entails: The edition’s web application enables users to access the edition data in new ways that transcend the scientific value of the standardised markup that constitutes the edition.

Tables of contents are contructed from the file listings. The underlying files are labelled and sorted by the places of the congresses and a consecutive numbering which depicts the chronological order of the congresses’ proceedings. This structure is used for the ordering of the documents themselves ("Dokumente"), the descriptions of the archival holdings ("Bestandsbeschreibungen") and the abstracts ("Regesten").

A spatial rendering of the origins of the edited documents is available directly at the landing page of the web application in form of a map that gives the broader context of post-napoleonic Europe.^[The monochrome map is based on a CC-licenced map "Europe 1820" by Andreas Kunz, Wolf Röss and Joachim Robert Möschl (<https://www.ieg-maps.uni-mainz.de/mapsp/mappEu820Serie2.htm>); it has been edited by Stephan Kurz and forms the background graphics for the whole web application.]

Two additional chronological access paths make use of the `@when` attributes in the `teiHeader` metadata concerning the dating of the documents: A calendar view and a timeline view. While the calendar allows to link the documents (and the events that led to them) to a structured understanding of time (from year to months and days of the week), the timeline view gives an overview of the temporal continuum that the documents relate to more from a bird’s eye.

The relatively deep tagging of named entities in the TEI files – mostly person and place data, only two institions have been listed separately – enables access to the edition data by means of indices automatically created from the encoded files. The `listPlace` index of places includes geo data that allows for a spatial pinning not only of the places of document generation, but also of all places that are mentioned within the edition text. Furthermore, all places mentioned include GeoNames identifiers to ensure interoperability with other ressources in a linked open data approach, and a representation on any given map (in the current version, our web application takes the shortcut of using contemporary GIS data via leaflet/OpenStreetMap).^[This might be updated to a more accurate data set stemming from the HistoGIS project that involves the ÖAW-ACDH, <https://histogis.acdh.oeaw.ac.at/>, in a future feature release.] The same holds true for the reference data identifying persons, where we chose to use the norm data from the Virtual International Authority File (VIAF) to disambiguate persons and link them to the documents in a machine-readable way. The web application also provides access through an API, through a simple Beacon file and through JSON-based autocomplete data.

Abstracts are provided to describe the actual contents of the documents. These are provided as a separate list through the table of contents submenu, but also in the head section of the individual documents’ views.

Conceptionally opposed to a structured semantic approach the web interface also offers a full text search (implemented in Apache Lucene), its results (displayed in a `datatables` view) can be narrowed down on the fly just by using a text input field.

# Technicalities and Platform Choice

As the ÖAW-ACDH, which serves as a service institution within the Austrian Academy of Sciences, was taking part in the HRSM-funded project *Kompetenznetzwerk Digitale Edition (KONDE)* already, and our academic home institute, the Institute for Modern and Contemporary Historical Research (INZ) got involved in this network effort as well, our attention focused on choosing a technical solution for the web application from this ecosystem. This predetermined our deciding to use the `dsebaseapp` as a blueprint for developing an application for accessing the TEI edition data. `dsebaseapp` (dse stands for 'digital scholarly edition') was developed by Peter Andorfer at the ÖAW-ACDH as a starting point for edition interfaces, and it is especially suitable for epistolary material since it in itself stems from the application for the letters of Leo von Thun-Hohenstein.^[The latest iteration of this application is to be found at <https://thun-korrespondenz.acdh.oeaw.ac.at/pages/index.html>.] With the assistance of a series of accompanying blog posts,^[See <https://github.com/csae8092/posts/tree/master/digital-edition-web-app>.] we proceeded to implement `maechtekongresse` as an application for the `eXist-db` platform^[<http://exist-db.org/>] which is notorious in the Digital Humanities context.

This choice has also been influenced by the fact that the amount of data in the edition is relatively small, as it does not include image data and spans a total of 115 XML documents only. Moreover, due to the fact that there was no additional funding available, the solution to be selected could not be other than "free" (as in software), and the ÖAW-ACDH already had server and network infrastructure in place for using an eXist-db approach. In addition, this infrastructure includes the possibility to archive the edition data in ARCHE (A Resource Centre for the HumanitiEs).^[<https://www.oeaw.ac.at/acdh/tools/arche/>, repository based on Fedora Commons.] Consequently, there were no viable alternatives available to this whole package.

The access paths outlined above are mostly based on preparatory work from the KONDE consortium, especially drawing from the aforementioned `dsebaseapp` package developed by Peter Andorfer that reused XSLT transformation scripts written by Dario Kampkaspar (both are currently working at the ÖAW-ACDH). Since early 2018, the application was refined in close collaboration between ÖAW-ACDH and INZ.

A beta version is available online since September 2018 on <https://maechtekongresse.acdh-dev.oeaw.ac.at/>, with the next version due in the upcoming weeks, to be made available on <https://maechtekongresse.acdh.oeaw.ac.at/>. With the publication of the 'Mächtekongresse' edition, we hope to have contributed to further historiographical investigation on a crucial period in European history following the napoleonic wars and the Congress of Vienna, the based on the actual archival sources. On the technical and methodological flip side of our effort, we intend to continue furthering the development of suitable tools that open up historical documents to new questions (and APIs).

## Postscriptum: Known Desiderata

- Sources in the bibliography (`listBibl` in `listtreaties.xml` and `listWit` in `listwit.xml`) are currently flat text, precluding programmatic access.
- Whitespace handling, especially in mixed content XML nodes that contain both text and child elements, is still not properly addressed. As a result, some links include trailing spaces preceding punctuation marks. In general, the authoritative version of the 'Mächtekongresse' edition is the one transcribed in the TEI XML files; those should be consulted in case the HTML representation raises doubts.
- A network representation in GEFX format is in the works; it is intended to depict the interrelations between sessions of congress (and the resulting documents that form the edition) and the individuals taking part therein. Such a network view will allow grasping the relation in a chronotopical context.
- All of the edition’s documentary data is yet to be archived on the ARCHE service. Furthermore, the application’s code will soon be public under MIT licence on the KONDE GitHub.^[https://github.com/KONDE-AT/]

The team are grateful for any feedback regarding the 'Mächtekongresse' digital edition.
