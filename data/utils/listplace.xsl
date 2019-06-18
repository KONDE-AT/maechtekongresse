<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:sparql="http://www.w3.org/2005/sparql-results#" exclude-result-prefixes="tei" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"/>
    
    <xsl:variable name="title">
        <xsl:value-of select="normalize-space(string-join(//tei:titleStmt[1]/tei:title//text(), ' '))"/>
    </xsl:variable>
    
    <xsl:variable name="baseID">https://id.acdh.oeaw.ac.at/</xsl:variable>
    <xsl:variable name="personbase">
        <xsl:value-of select="concat($baseID, 'maechtekongresse/persons/')"/>
    </xsl:variable>
    <xsl:variable name="placebase">
        <xsl:value-of select="concat($baseID, 'maechtekongresse/places/')"/>
    </xsl:variable>
    
    <xsl:variable name="current-id">listperson.xml</xsl:variable>
    <xsl:variable name="current-base">https://id.acdh.oeaw.ac.at/maechtekongresse/indices</xsl:variable>
    <xsl:variable name="current">
        <xsl:choose>
            <xsl:when test="ends-with($current-base, '/')">
                <xsl:value-of select="string-join(($current-base, $current-id), '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="string-join(($current-base, $current-id), '/')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!--  TOC  -->
    
    <xsl:variable name="toc" select="doc($query)"/>
    
    <!--  BLAZEGRAPH  -->
    
    <xsl:variable name="sparql">PREFIX%20acdh%3A%20%3Chttps%3A%2F%2Fvocabs.acdh.oeaw.ac.at%2Fschema%23%3E%0A%0ASELECT%20%3Facdhid%20%3Ftitle%20%3Fdate%0AWHERE%20%7B%0A%09%3Fid%20acdh%3AhasIdentifier%20%3Chttps%3A%2F%2Fid.acdh.oeaw.ac.at%2Fmaechtekongresse%2Feditions%3E%20.%20%0A%20%20%09%3Fid%20acdh%3AhasIdentifier%20%3FcolID%20.%0A%20%20%09%3Feditions%20acdh%3AisPartOf%20%3FcolID%20.%0A%20%20%09%3Feditions%20acdh%3AhasTitle%20%3Ftitle%20.%0A%20%20%09%3Feditions%20acdh%3AhasCoverageStartDate%20%3Fdate%20.%0A%20%20%09%3Feditions%20acdh%3AhasIdentifier%20%3Facdhid%20.%0A%20%20%20%20FILTER%20regex(str(%3Facdhid)%2C%20%22editions%22%2C%20%22i%22%20)%20%0A%7D</xsl:variable>
    <xsl:variable name="blazegraph">https://arche-curation.acdh-dev.oeaw.ac.at/blazegraph/sparql?query=</xsl:variable>
    <xsl:variable name="query">
        <xsl:value-of select="concat($blazegraph, $sparql)"/>
    </xsl:variable>
    
    <xsl:template match="/">
        <html lang="en-US">
            <head>
                <meta charset="UTF-8"/>
                <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
                <meta name="mobile-web-app-capable" content="yes"/>
                <meta name="apple-mobile-web-app-capable" content="yes"/>
                <meta name="apple-mobile-web-app-title" content="Fundament WP - Example HTML Page"/>
                <link rel="profile" href="http://gmpg.org/xfn/11"/>
                <title>
                    <xsl:value-of select="$title"/>
                </title>
                <link rel="stylesheet" id="fundament-styles"  href="https://shared.acdh.oeaw.ac.at/fundament/dist/fundament/css/fundament.min.css" type="text/css"/>
                <link rel="stylesheet" id="fundament-styles"  href="https://shared.acdh.oeaw.ac.at/maechtekongresse/resources/css/style.css" type="text/css"/>
            </head>
            <body role="document" class="home contained fixed-nav" id="body">
                <div class="hfeed site" id="page">
                    <!-- ******************* The Navbar Area ******************* -->
                    <div class="wrapper-fluid wrapper-navbar sticky-navbar" id="wrapper-navbar" itemscope="" itemtype="http://schema.org/WebSite">
                        <a class="skip-link screen-reader-text sr-only" href="#content">Skip to content</a>
                        <nav class="navbar navbar-expand-lg navbar-light">
                            <div class="container-fluid">
                                <!-- Your site title as branding in the menu -->
                                <a href="index.html" class="navbar-brand custom-logo-link" rel="home" itemprop="url">
                                    <img src="https://shared.acdh.oeaw.ac.at/schnitzler-tagebuch/project-logo.svg" class="img-fluid" alt="Schnitzler Tagebuch" itemprop="logo"/>
                                </a><!-- end custom logo -->
                                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
                                    <span class="navbar-toggler-icon"/>
                                </button>
                                <div class="collapse navbar-collapse justify-content-end" id="navbarNavDropdown">
                                    <!-- Your menu goes here -->
                                    <ul id="main-menu" class="navbar-nav">
                                        <li class="nav-item">
                                            <a class="nav-link" href="https://id.acdh.oeaw.ac.at/maechtekongresse/meta/about.xml?format=customTEI2HTML">Zur Edition</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="#" data-toggle="modal" data-target="#tocModal">Alle Einträge</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="https://id.acdh.oeaw.ac.at/maechtekongresse/indices/listperson.xml?format=customTEI2HTML">Personen</a>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="https://id.acdh.oeaw.ac.at/maechtekongresse/indices/listperson.xml?format=customTEI2HTML">Orte</a>
                                        </li>
                                    </ul>
                                    <div class="form-inline my-2 my-lg-0 navbar-search-form">
                                        <input class="form-control navbar-search" id="query" type="text" placeholder="Search" value="" autocomplete="off"/>
                                        <button class="navbar-search-icon" id="send" data-toggle="modal" data-target="#myModal">
                                            <i data-feather="search"></i>
                                        </button>
                                    </div>
                                </div>
                                <!-- .collapse navbar-collapse -->
                            </div>
                            <!-- .container -->
                        </nav>
                        <!-- .site-navigation -->
                    </div>
                    <!-- .wrapper-navbar end -->
                    
                    <div class="wrapper" id="index-wrapper">
                        <div class="container" id="content" tabindex="-1">
                            <div class="card">
                                <div class="card-header">
                                    <div class="row" style="text-align:left">
                                        <div class="col-md-12">
                                            <h2 align="center">
                                                <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title">
                                                    <xsl:apply-templates/>
                                                    <br/>
                                                </xsl:for-each>
                                            </h2>
                                            <h3 align="center">
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <a>
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="$current"/>
                                                            </xsl:attribute>
                                                            <emph data-feather="home"/>
                                                        </a>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <emph data-feather="info" data-toggle="modal" data-target="#exampleModalLong"/>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <a>
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="concat($current, '?format=raw')"/>
                                                            </xsl:attribute>
                                                            <emph data-feather="download"/>
                                                        </a>
                                                    </div>
                                                </div>
                                                
                                            </h3>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div>
                                        <xsl:apply-templates select="//tei:listPlace"/>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Wrapper end -->
                    <div class="wrapper fundament-default-footer" id="wrapper-footer-full">
                        <div class="container-fluid" id="footer-full-content" tabindex="-1">
                            <div class="footer-separator">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-message-circle">
                                    <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/>
                                </svg> CONTACT
                            </div>
                            <div class="row">
                                <div class="footer-widget col-lg-1 col-md-2 col-sm-2 col-xs-6 col-3">
                                    <div class="textwidget custom-html-widget">
                                        <a href="/">
                                            <img src="https://fundament.acdh.oeaw.ac.at/common-assets/images/acdh_logo.svg" class="image" alt="ACDH Logo" style="max-width: 100%; height: auto;" title="ACDH Logo"/>
                                        </a>
                                    </div>
                                </div>
                                <!-- .footer-widget -->
                                <div class="footer-widget col-lg-4 col-md-4 col-sm-6 col-9">
                                    <div class="textwidget custom-html-widget">
                                        <p>
                                            ACDH-ÖAW
                                            <br/>
                                            Austrian Centre for Digital Humanities
                                            <br/>
                                            Austrian Academy of Sciences
                                        </p>
                                        <p>
                                            Sonnenfelsgasse 19,
                                            <br/>
                                            1010 Vienna
                                        </p>
                                        <p>
                                            T: +43 1 51581-2200
                                            <br/>
                                            E: <a href="mailto:acdh@oeaw.ac.at">acdh@oeaw.ac.at</a>
                                        </p>
                                    </div>
                                </div>
                                <!-- .footer-widget -->
                                <div class="footer-widget col-lg-3 col-md-4 col-sm-4 ml-auto">
                                    <div class="textwidget custom-html-widget">
                                        <h6>HELPDESK</h6>
                                        <p>ACDH runs a helpdesk offering advice for questions related to various digital humanities topics.</p>
                                        <p>
                                            <a class="helpdesk-button" href="mailto:acdh-helpdesk@oeaw.ac.at">ASK US!</a>
                                        </p>
                                    </div>
                                </div>
                                <!-- .footer-widget -->
                            </div>
                        </div>
                    </div>
                    <!-- #wrapper-footer-full -->
                    <div class="footer-imprint-bar" id="wrapper-footer-secondary" style="text-align:center; padding:0.4rem 0; font-size: 0.9rem;">
                       <a href="https://www.oeaw.ac.at/die-oeaw/impressum/">Impressum/Imprint</a>
                    </div>
                </div>
                
    <!--   SOLR-MODAL   -->
                <div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" id="myModal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title">Ergebniss der Volltextsuche</h4>
                            </div>
                            <div class="modal-body">
                                <table id="table" class="table table-striped table-condensed table-hover">
                                    <thead>
                                        <tr id="columns">
                                            <th>Title</th>
                                            <th>Highlight</th>
                                            <th>Type</th>
                                        </tr>
                                    </thead>
                                </table>
                                <div id="output"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-danger" data-dismiss="modal">Schließen</button>
                            </div>
                        </div>
                    </div>
                </div>
                
    <!-- TEI-HEADER-MODAL -->
                <div class="modal fade bd-example-modal-lg" id="exampleModalLong" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
                    <div class="modal-dialog  modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLongTitle">
                                    <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title">
                                        <xsl:apply-templates/>
                                        <br/>
                                    </xsl:for-each>
                                </h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">x</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <table class="table table-striped">
                                    <tbody>
                                        <xsl:if test="//tei:msIdentifier">
                                            <tr>
                                                <th>
                                                    <abbr title="//tei:msIdentifie">Signatur</abbr>
                                                </th>
                                                <td>
                                                    <xsl:for-each select="//tei:msIdentifier/child::*">
                                                        <abbr>
                                                            <xsl:attribute name="title">
                                                                <xsl:value-of select="name()"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="."/>
                                                        </abbr>
                                                        <br/>
                                                    </xsl:for-each><!--<xsl:apply-templates select="//tei:msIdentifier"/>-->
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:msContents">
                                            <tr>
                                                <th>
                                                    <abbr title="//tei:msContents">Regest</abbr>
                                                </th>
                                                <td>
                                                    <xsl:apply-templates select="//tei:msContents"/>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:supportDesc/tei:extent">
                                            <tr>
                                                <th>
                                                    <abbr title="//tei:supportDesc/tei:extent">Extent</abbr>
                                                </th>
                                                <td>
                                                    <xsl:apply-templates select="//tei:supportDesc/tei:extent"/>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <tr>
                                            <th>Schlagworte</th>
                                            <td>
                                                <xsl:for-each select="//tei:index/tei:term">
                                                    <li>
                                                        <xsl:value-of select="."/>
                                                    </li>
                                                </xsl:for-each>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                <abbr title="//tei:availability//tei:p[1]">License</abbr>
                                            </th>
                                            <td align="center">
                                                <a class="navlink" target="_blank" href="https://creativecommons.org/licenses/by/4.0/">
                                                    https://creativecommons.org/licenses/by/4.0/
                                                </a>
                                            </td>
                                        </tr>                            
                                    </tbody>
                                </table>
                                
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>
                
    <!-- TOC-MODAL  -->
                <div class="modal fade bd-example-modal-lg" id="tocModal" tabindex="-1" role="dialog" aria-labelledby="tocModalTitle" aria-hidden="true">
                    <div class="modal-dialog  modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="tocModalTitle">
                                    Inhaltsverzeichnis
                                </h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Schließen">
                                    <span aria-hidden="true">x</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select="$toc//sparql:result">
                                            <tr>
                                                <td>
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="concat(./sparql:binding[@name='acdhid']/sparql:uri/text(), '?format=customTEI2HTML')"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="./sparql:binding[@name='title']//text()"/>
                                                    </a>
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                                
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Schließen</button>
                            </div>
                        </div>
                    </div>
                </div>
                
    <!-- FETCH-MENTIONS-MODAL -->
                <div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" id="fetchMentionsModal">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            
                            <!-- Modal Header -->
                            <div class="modal-header">
                                <h4 class="modal-title" id="fetchMentionsModalHeader"></h4>
                            </div>
                            
                            <!-- Modal body -->
                            <div class="modal-body" id="fetchMentionsModalBody">
                            </div>
                            
                            <!-- Modal footer -->
                            <div class="modal-footer">
                                <button type="button" class="btn btn-danger" data-dismiss="modal">Schließen</button>
                            </div>
                        </div>
                    </div>
                </div>
    <!-- JAVASCRIPT -->
                <script type="text/javascript" src="https://shared.acdh.oeaw.ac.at/fundament/dist/fundament/vendor/jquery/jquery.min.js"></script>
                <script type="text/javascript" src="https://shared.acdh.oeaw.ac.at/fundament/dist/fundament/js/fundament.min.js"></script>
                <script type="text/javascript" src="https://cdn.datatables.net/v/bs4/jszip-2.5.0/dt-1.10.16/b-1.4.2/b-html5-1.4.2/b-print-1.4.2/datatables.min.js"/>
                <script src="https://shared.acdh.oeaw.ac.at/solr-getter/solr.js"></script>
                <script src="https://shared.acdh.oeaw.ac.at/maechtekongresse/resources/js/fetchMentions.js"></script>
                <script>
                    <![CDATA[
                    $( document ).ready(function() {
                        $('#send').click(function() {
                            getSolr({
                               solrEndpoint: 'https://arche-curation.acdh-dev.oeaw.ac.at/solr/arche/query',
                               pageSize: 25,
                               input: $("#query").val(),
                               columns: [
                               { 'Type': 'content_type' },
                               { 'Title': 'meta_title' },
                               { 'highlight': 'highlight_with_link' }
                               ],
                               sparqlQuery: decodeURIComponent('select%20%3Fres%20where%20%7B%0A%20%20%3Fres%20%3Chttps%3A%2F%2Fvocabs.acdh.oeaw.ac.at%2Fschema%23isPartOf%3E%20%3Chttps%3A%2F%2Fid.acdh.oeaw.ac.at%2Fuuid%2F18fc414c-280f-e003-8366-9da29661bdc8%20%3E%20.%0A%7D'),
                               sparqlEndpoint: 'https://arche-curation.acdh-dev.oeaw.ac.at/blazegraph/sparql',
                            });
                        });
                    });
                    ]]>
                </script>
                <script>
                    $("button").click(function(e) {
                    e.preventDefault();
                    var endpoint = "https://arche-curation.acdh-dev.oeaw.ac.at/blazegraph/sparql";
                    var itemId = $(this).attr('data-key');
                    var personName = $(this).attr('data-person');
                    var resultTitleId = "fetchMentionsModalHeader";
                    var resultTitleString = `${personName} wird in folgenden Dokumenten erwähnt:`;
                    var resultBody = "fetchMentionsModalBody";
                    console.log(itemId);
                    var sparqlQuery = `PREFIX%20acdh%3A%20%3Chttps%3A%2F%2Fvocabs.acdh.oeaw.ac.at%2Fschema%23%3E%0A%0ASELECT%20%3Ftitle%20%3Facdhid%0AWHERE%20%7B%0A%20%20%3FcurrentActor%20acdh%3AhasIdentifier%20%3Chttps%3A%2F%2Fid.acdh.oeaw.ac.at%2Fmaechtekongresse%2Fplace%2F${itemId}%3E%20.%0A%20%20%3FcurrentActor%20acdh%3AhasIdentifier%20%3Fuuid%20.%0A%20%20%3Feditions%20acdh%3AhasSpatialCoverage%20%3Fuuid%20.%0A%20%20%3Feditions%20acdh%3AhasTitle%20%3Ftitle%20.%0A%20%20%3Feditions%20acdh%3AhasIdentifier%20%3Facdhid%20.%0A%20%20FILTER%20regex(str(%3Facdhid)%2C%20%22maechtekongresse%22%2C%20%22i%22%20)%0A%7D`;
                    var resultShow = "fetchMentionsModal";
                    
                    fetchMentions(endpoint, sparqlQuery, resultTitleId, resultTitleString, resultBody, resultShow)
                    });
                </script>
            </body>
        </html>
    </xsl:template>

    
    <!--  TEMPLATE RULES  -->
    <xsl:template match="tei:listPlace">
        <table class="table table-striped table-condensed table-hover">
            <thead>
                <tr>
                    <th>Ortsname</th>
                    <th>Alternative Bezeichnungen</th>
                    <th>ID</th>
                    <th>GeoNames</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="./tei:place">
                    <tr>
                        <td>
                            <xsl:value-of select="./tei:placeName[1]"/>
                        </td>
                        <td>
                            <xsl:for-each select="subsequence(.//tei:placeName, 2)">
                                <li>
                                    <xsl:value-of select="./text()"/>
                                </li>
                            </xsl:for-each>
                        </td>
                        <td>
                            <button class="btn btn-primary btn-action" data-key="{data(./@xml:id)}" data-person="{./tei:placeName[1]}" id="{concat(data(./@xml:id), '__fetch')}">erwähnt in</button>
                        </td>
                        <td>
                            <a>
                                <xsl:attribute name="href"><xsl:value-of select="./tei:idno[@type='URI']/text()"/></xsl:attribute>
                                <xsl:value-of select="./tei:idno[@type='URI']/text()"/>
                            </a>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
        
    </xsl:template>

</xsl:stylesheet>